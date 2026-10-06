# Item icons in the style of KVCT / VLKT (both by Silva.Fox): the icons are copied from the KVCT map into
# src\map\war3mapImported\kv\ (so every player has them, no external data pack) and set on the items.
#   hats / armors: KVCT "Anh Hung" non / ao icons, colour by tier (blue..gold), alternating the two sets
#   boots: KVCT TBDH set (5 colours = 5 tiers); weapons: KVCT icon of the same weapon type, brighter by tier
#   cloaks, Thuy tinh, gems, Bi Pho, potions...: the KVCT item of the same kind
# Run after describe.py (it changes only iico).
import io, os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata
from PIL import Image
from mpq import MPQ
from gameplay_items import items, plain
import gameplay

SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
KVCT = r"D:\kvct-dev\work\base.w3x"
DST = "war3mapImported\\kv\\"
BS = chr(92)

WEAPON_TYPES = [("kiem", "kiem"), ("song dao", "dao"), ("phien", "tutien"), ("ba tieu", "tutien"),
                ("mau", "thuong"), ("thuong", "thuong"), ("san", "con"), ("soc", "truongdao"), ("phu", "chuy"),
                ("hoan", "phitieu"), ("duyen", "phidao"), ("phach phong", "daidao"), ("than dao", "daidao"),
                ("loan dao", "dao"), ("dao", "dao")]
VK_LEVEL = {1: 2, 2: 6, 3: 10, 4: 14, 5: 18}
MISC = {  # item id -> KVCT vatpham id
    "I00W": 61,                                      # Thuy tinh
    "I06J": 60, "I06K": 212, "I06L": 231, "I06M": 230, "I06P": 66, "I06Q": 67, "I06U": 68, "I06W": 62,
    "I06S": 274, "I017": 232, "I00P": 370, "I00R": 6, "I00S": 46,
    "I00J": 356, "lmbr": 356,                        # Kim Nguyen Bao
    "phea": 385, "pghe": 386, "pman": 387, "pgma": 388, "I00M": 389, "pres": 390,
    "I01C": 404, "I06G": 159, "manh": 159, "tdex": 174, "tint": 174, "tstr": 174,
}
CLOAK_ICONS = ["Icon_PP1_2", "Icon_PP1_4", "Icon_PP1_7", "Icon_PP1_11", "Icon_PP2_15"]


def blp_size(data):
    return struct.unpack_from("<2I", data, 12)


def blp1_palette(im, side=64):
    """64x64 BLP1, 256-colour palette + 8-bit alpha, full mipmap chain (64..1). The 1.31 game shows a
    green square for a texture whose sides are not powers of two (some KVCT item icons are 44 or 56 px,
    KVCT draws them in its own UI frames)."""
    im = im.convert("RGBA").resize((side, side), Image.LANCZOS)
    pal_img = im.convert("RGB").quantize(256, method=Image.Quantize.MEDIANCUT)
    pal = pal_img.getpalette()[:768] + [0] * (768 - len(pal_img.getpalette()[:768]))
    palette = b"".join(struct.pack("<4B", pal[3 * i + 2], pal[3 * i + 1], pal[3 * i], 0) for i in range(256))
    mips, size = [], side
    while size >= 1:
        m = im.resize((size, size), Image.LANCZOS) if size != side else im
        idx = m.convert("RGB").quantize(palette=pal_img, dither=Image.Dither.NONE).tobytes()
        mips.append(idx + m.getchannel("A").tobytes())
        size //= 2
    head = 4 + 4 * 6 + 64 + 64
    offs, sizes, pos = [], [], head + len(palette)
    for d in mips:
        offs.append(pos)
        sizes.append(len(d))
        pos += len(d)
    offs += [0] * (16 - len(offs))
    sizes += [0] * (16 - len(sizes))
    return (b"BLP1" + struct.pack("<6I", 1, 8, side, side, 4, 1) + struct.pack("<16I", *offs)
            + struct.pack("<16I", *sizes) + palette + b"".join(mips))


def weapon_type(name):
    p = plain(re.sub(r"\|c\w{8}|\|r", "", name))
    for key, t in WEAPON_TYPES:
        if re.search(r"\b%s\b" % key, p):
            return t
    return "kiem"


def icon_for(slot, tier, k, name):
    if slot in (1, 2):
        base = "Icon_TBAH_non" if slot == 1 else "Icon_TBAH_ao"
        idx = min(9, 2 * tier - 1 + (k % 2 if tier < 5 else 0))
        return "%s%d_%d.blp" % (base, 1 + (k // 2) % 2, idx)
    if slot == 4:
        return "Icon_TBDH%d_5.blp" % tier
    return "icon_vk_%s%d.blp" % (weapon_type(name), VK_LEVEL[tier] + (k % 3 if tier == 5 else 0))


def main():
    d = open(KVCT, "rb").read(1 << 20)
    kv = MPQ(KVCT, d.find(b"MPQ\x1a"))
    p = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3t")
    names = {}
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            iid = (o if ti == 0 else n).decode("latin1")
            nm = next((m[4].decode("utf-8") for m in sets[0] if m[0] == b"unam"), "")
            names[iid] = (nm, sets[0])
    want = {}                                        # item id -> KVCT file name (without folder)
    tiers = {}                                       # gear id -> icon of tier 1..5 (cuong hoa look)
    fam_index = {}
    for iid, slot, tier, name in items():
        if iid in gameplay.NOT_GEAR:
            continue
        slot = gameplay.SLOT_FIX.get(iid, slot)
        tier = gameplay.TIER_FIX.get(iid, tier)
        fam = re.sub(r"\s*\+\s*\d", "", plain(re.sub(r"\|c\w{8}|\|r", "", name))).strip()
        k = fam_index.setdefault((slot, fam), len([1 for s, _ in fam_index if s == slot]))
        want[iid] = icon_for(slot, tier, k, name)
        tiers[iid] = [icon_for(slot, t, k, name) for t in range(1, 6)]
    for iid, nm in names.items():
        if "Bí Phổ" in nm[0]:
            want[iid] = "vatpham_189.blp"
    for iid, v in MISC.items():
        want[iid] = "vatpham_%d.blp" % v
    for i, ic in enumerate(CLOAK_ICONS):
        want["I0Z%d" % (i + 2)] = ic + ".blp"
    out_dir = os.path.join(SRC, "war3mapImported", "kv")
    os.makedirs(out_dir, exist_ok=True)
    for f in os.listdir(out_dir):
        os.remove(os.path.join(out_dir, f))
    copied, set_n = set(), 0
    for iid, f in want.items():
        if iid not in names:
            continue
        data = kv.read("war3mapImported" + BS + f)
        if not data:
            print("missing in KVCT:", f, "for", iid)
            continue
        if f not in copied:
            if blp_size(data) != (64, 64):
                data = blp1_palette(Image.open(io.BytesIO(data)))
            open(os.path.join(out_dir, f), "wb").write(data)
            copied.add(f)
        path = DST + f
        mods = names[iid][1]
        m = next((m for m in mods if m[0] == b"iico"), None)
        if m is None:
            mods.append([b"iico", None, None, 3, path.encode(), b"\0\0\0\0"])
        else:
            m[3], m[4] = 3, path.encode()
        set_n += 1
    # cuong hoa: icon of the tier that matches the slot level (gameplay.j zzVL_CuongIcon reads key 46+tier)
    rows = []
    for iid, files in tiers.items():
        for t, f in enumerate(files, 1):
            if f not in copied:
                data = kv.read("war3mapImported" + BS + f)
                if not data:
                    continue
                if blp_size(data) != (64, 64):
                    data = blp1_palette(Image.open(io.BytesIO(data)))
                open(os.path.join(out_dir, f), "wb").write(data)
                copied.add(f)
            rows.append('call SaveStr(zzVL_ht,%s,%d,"%s")' % ("'" + iid + "'", 46 + t, (DST + f).replace(BS, BS + BS)))
    js = os.path.join(SRC, "Scripts", "war3map.j") if os.path.exists(os.path.join(SRC, "Scripts", "war3map.j")) else os.path.join(SRC, "war3map.j")
    raw = open(js, "rb").read().decode("utf-8")
    nl = chr(13) + chr(10) if chr(13) + chr(10) in raw else chr(10)
    head = "function zzVL_Items takes nothing returns nothing"
    assert raw.count(head) == 1
    raw = raw.replace(head, head + nl + nl.join(rows))
    open(js, "wb").write(raw.encode("utf-8"))
    print("cuong hoa icon rows:", len(rows))
    # disabled look (shop items you cannot afford, the inventory of other heroes): the game loads
    # ReplaceableTextures\CommandButtonsDisabled\DIS<file>, a green square when it is missing
    dis = os.path.join(SRC, "ReplaceableTextures", "CommandButtonsDisabled")
    os.makedirs(dis, exist_ok=True)
    for f in sorted(copied):
        im = Image.open(os.path.join(out_dir, f)).convert("RGBA")
        a = im.getchannel("A")
        g = im.convert("L").point(lambda v: int(v * .55)).convert("RGBA")
        g.putalpha(a)
        data = blp1_palette(g)
        open(os.path.join(dis, "DIS" + f), "wb").write(data)
    print("disabled icons:", len(copied))
    open(p, "wb").write(objdata.write(ver, tabs, ".w3t"))
    print("icons copied:", len(copied), "items with a new icon:", set_n)


if __name__ == "__main__":
    main()
