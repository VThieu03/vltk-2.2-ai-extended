"""Generate the 6x9 KVCT gem items, icons, and runtime lookup table."""
import io, os, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import config
import kvgem_data as D
from mpq import MPQ
from PIL import Image
from icons import blp_size, blp1_palette

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
KVCT = r"D:\kvct-dev\work\base.w3x"
BS = chr(92)
ICON_DIR = os.path.join(SRC, "war3mapImported", "kv_gem")
ICON_PREFIX = "war3mapImported" + BS + "kv_gem" + BS

def mod(mid, val, typ=0):
    if typ == 3:
        return [mid, None, None, 3, val.encode("utf-8"), b"\0\0\0\0"]
    return [mid, None, None, 0, struct.pack("<i", val), b"\0\0\0\0"]

def item_rows():
    path = os.path.join(SRC, "war3map.w3t")
    of_tabs = objdata.ObjectFile.load(path)
    version, tabs = of_tabs.ver, of_tabs.tables
    wanted = {D.item_id(k, t).encode("ascii") for k in range(1, 7) for t in range(1, 10)}
    wanted.update(D.stat_stone_id(stat, grade).encode("ascii") for stat in D.STAT_STONES for grade in range(1, 4))
    wanted.update((b"KTR1", b"KTR2", b"KTR3"))
    used = {n for _, n, _ in tabs[1]}
    clash = wanted & used
    # Re-running this step replaces only our own 54 records.
    tabs[1][:] = [entry for entry in tabs[1] if entry[1] not in wanted]
    for kind in range(1, 7):
        stat, stat_name, base = D.KINDS[kind]
        for tier in range(1, 10):
            iid = D.item_id(kind, tier)
            _, value = D.amount(kind, tier)
            color = ("|cff9a9a9a", "|cff40c040", "|cff4080ff", "|cffc080ff", "|cffff8040", "|cffff4040", "|cffffcc00", "|cffffcc00", "|cffffcc00")[tier-1]
            title = "%sBảo Thạch %s - Bậc %d|r" % (color, stat_name, tier)
            detail = "%sChỉ số KVCT: %s +%s%s|r" % (color, stat_name, value, "%" if stat not in (7, 8, 9, 10) else "")
            text = detail + "|n|cff80c0ff[Khảm] Mở Hành Trang (B) và Nhân Vật (C), bật Khảm, bấm viên này rồi bấm trang bị; tối đa %d lỗ mỗi trang bị. Tách: %d vàng / viên.|r" % (config.GAME["KHAM_SO_LO"], config.GAME["KHAM_TACH_VANG"])
            icon = ICON_PREFIX + D.icon_name(kind, tier)
            mods = [mod(b"unam", title, 3), mod(b"utip", title, 3), mod(b"utub", text, 3),
                    mod(b"ides", text, 3), mod(b"iabi", "", 3), mod(b"iico", icon, 3),
                    # giá = vàng nâng lên bậc này ở tiệm (config mục 12); bậc 1 không bán ở tiệm
                    mod(b"igol", 0 if tier < 2 else config.GEM_UP_GOLD + config.GEM_UP_GOLD_STEP * (tier - 2)), mod(b"ilum", 0),
                    mod(b"isto", 10), mod(b"istr", 10), mod(b"isst", 0), mod(b"idro", 1), mod(b"ipaw", 1),
                    mod(b"isel", 1), mod(b"ilev", tier), mod(b"icla", "Permanent", 3)]
            tabs[1].append([b"clfm", iid.encode("ascii"), [mods]])
    shared_icon = ICON_PREFIX + D.icon_name(1, 1)
    for stat, (stat_name, unit, low, high) in D.STAT_STONES.items():
        for grade in range(1, 4):
            iid = D.stat_stone_id(stat, grade)
            value = D.stat_stone_amount(stat, grade)
            amount = str(value) + unit
            title = "|cff40c0ffĐá %s - %s|r" % (stat_name, D.STAT_STONE_GRADE_NAMES[grade])
            detail = "%s%s +%s|r" % ("|cffffcc00" if grade == 3 else "|cff80c0ff", stat_name, amount)
            text = detail + "|n|cff80c0ff[Khảm] Mở Hành Trang (B), bật Khảm, chọn viên đá rồi chọn trang bị. Mỗi viên thêm một dòng thuộc tính.|r"
            mods = [mod(b"unam", title, 3), mod(b"utip", title, 3), mod(b"utub", text, 3), mod(b"ides", text, 3),
                    mod(b"iabi", "", 3), mod(b"iico", shared_icon, 3), mod(b"igol", 0), mod(b"ilum", 0),
                    mod(b"isto", 10), mod(b"istr", 10), mod(b"isst", 0), mod(b"idro", 1), mod(b"ipaw", 1),
                    mod(b"isel", 1), mod(b"ilev", 1), mod(b"icla", "Permanent", 3)]
            tabs[1].append([b"clfm", iid.encode("ascii"), [mods]])
    for grade in range(1, 4):
        iid = "KTR%d" % grade
        price = config.KQTRC_STONE_GOLD[grade]
        title = "|cffffcc00Chọn đá thuộc tính - %s|r" % D.STAT_STONE_GRADE_NAMES[grade]
        text = "Chọn một trong 22 dòng thuộc tính. Giá: %d vàng." % price
        mods = [mod(b"unam", title, 3), mod(b"utip", title, 3), mod(b"utub", text, 3), mod(b"ides", text, 3),
                mod(b"iabi", "", 3), mod(b"iico", shared_icon, 3), mod(b"igol", price), mod(b"ilum", 0),
                mod(b"isto", 10), mod(b"istr", 10), mod(b"isst", 0), mod(b"idro", 1), mod(b"ipaw", 1),
                mod(b"isel", 1), mod(b"ilev", 1), mod(b"icla", "Permanent", 3)]
        tabs[1].append([b"clfm", iid.encode("ascii"), [mods]])
    of_tabs.save()
    return 54 + 66 + 3, len(clash)

def copy_icons():
    data = open(KVCT, "rb").read(1 << 20)
    archive = MPQ(KVCT, data.find(bytes((77, 80, 81, 26))))
    os.makedirs(ICON_DIR, exist_ok=True)
    count = 0
    for kind in range(1, 7):
        for tier in range(1, 10):
            name = D.icon_name(kind, tier)
            src = "war3mapImported" + BS + name
            raw = archive.read(src)
            if not raw:
                raise RuntimeError("KVCT icon missing: " + src)
            if blp_size(raw) != (64, 64):
                raw = blp1_palette(Image.open(io.BytesIO(raw)))
            with open(os.path.join(ICON_DIR, name), "wb") as f:
                f.write(raw)
            count += 1
    # Attribute stones intentionally share the existing KVCT gem icon.
    return count

def patch_script():
    path = os.path.join(SRC, "Scripts", "war3map.j")
    raw = open(path, "rb").read().decode("utf-8")
    if "function zzGM_Items takes nothing returns nothing" in raw:
        raise SystemExit("kvgem: generated table already exists; rerun gameplay.py first")
    # The metadata is keyed by raw item type ids; gameplay_14_gem.j reads keys 110/111.
    rows = []
    for kind in range(1, 7):
        for tier in range(1, 10):
            iid = D.item_id(kind, tier)
            stat, value = D.amount(kind, tier)
            icon = (ICON_PREFIX + D.icon_name(kind, tier)).replace(BS, BS + BS)
            rows.extend(["call SaveInteger(zzVL_ht,'%s',110,%d)" % (iid, kind),
                         "call SaveInteger(zzVL_ht,'%s',111,%d)" % (iid, tier),
                         "call SaveInteger(zzVL_ht,'%s',112,%d)" % (iid, stat),
                         "call SaveInteger(zzVL_ht,'%s',113,%d)" % (iid, value),
                         "call SaveInteger(zzVL_ht,'%s',44,%d)" % (iid, stat),
                         "call SaveInteger(zzVL_ht,'%s',45,%d)" % (iid, value),
                         'call SaveStr(zzVL_ht,\'%s\',114,"%s")' % (iid, icon)])
    for stat in D.STAT_STONES:
        for grade in range(1, 4):
            iid = D.stat_stone_id(stat, grade)
            value = D.stat_stone_amount(stat, grade)
            rows.extend(["call SaveInteger(zzVL_ht,'%s',110,%d)" % (iid, 100 + stat),
                         "call SaveInteger(zzVL_ht,'%s',111,%d)" % (iid, grade),
                         "call SaveInteger(zzVL_ht,'%s',112,%d)" % (iid, stat),
                         "call SaveInteger(zzVL_ht,'%s',113,%d)" % (iid, value),
                         "call SaveInteger(zzVL_ht,'%s',44,%d)" % (iid, stat),
                         "call SaveInteger(zzVL_ht,'%s',45,%d)" % (iid, value),
                         'call SaveStr(zzVL_ht,\'%s\',114,"%s")' % (iid, (ICON_PREFIX + D.icon_name(1, 1)).replace(BS, BS + BS))])
    nl = "\r\n" if "\r\n" in raw else "\n"
    head = "function zzVL_Items takes nothing returns nothing"
    if raw.count(head) != 1:
        raise SystemExit("kvgem: zzVL_Items missing; run gameplay.py first")
    fn = ["function zzGM_Items takes nothing returns nothing"] + rows + ["endfunction"]
    raw = raw.replace(head, nl.join(fn) + nl + head + nl + 'call ExecuteFunc("zzGM_Items")')
    open(path, "wb").write(raw.encode("utf-8"))
    return len(rows)

def main():
    n, clashes = item_rows()
    icons = copy_icons()
    rows = patch_script()
    print("kvgem: %d gem items, %d icons, %d hashtable rows; replaced %d previous records" % (n, icons, rows, clashes))

if __name__ == "__main__":
    main()
