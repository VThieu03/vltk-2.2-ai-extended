# Tuyet dai cao thu from the author's Thien Kiem map: the 4 boss units plus a 5th (Diep Thanh, Nga My model),
# with their models, textures and icons. Their Thien Kiem abilities are NOT copied: the ids (A089, A00B, A0CI...)
# are other skills in VLTK and most of them work through Thien Kiem triggers.
# Run after convert_text.py (it rewrites war3map.w3u); safe to rerun.
import os, shutil, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata

TK = r"D:\thienkiem-dev\src"
SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
BOSSES = [b"o001", b"h01F", b"e003", b"n018"]
NEW = b"n0TK"                                         # Diep Thanh: copy of o001, unused id in VLTK
MODELS = {"HeroButVo.mdx": ["HeroButVo.blp"],
          "HeroVoDang.mdx": ["yijian_0%d.blp" % i for i in range(1, 8)],
          "HeroNgaMy.mdx": ["HeroNgaMy_Body.blp"]}
ICONS = ["BTNHero_QuyenThieu.blp", "BTNHero_ChuongCai.blp", "BTNHero_ButMinh.blp", "BTNHero_KiemVo.blp",
         "BTNHero_NgaMy.blp"]
DROP = {b"uabi", b"udaa", b"uhab"}


def setf(mods, key, typ, val):
    m = next((m for m in mods if m[0] == key), None)
    if m is None:
        mods.append([key, None, None, typ, val, b"\0\0\0\0"])
    else:
        m[3], m[4] = typ, val


def main():
    _, tk = objdata.parse(open(os.path.join(TK, "war3map.w3u"), "rb").read(), ".w3u")
    p = os.path.join(SRC, "war3map.w3u")
    ver, vl = objdata.parse(open(p, "rb").read(), ".w3u")
    vl[1][:] = [e for e in vl[1] if e[1] not in BOSSES + [NEW]]
    for o, n, sets in tk[1]:
        if n in BOSSES:
            mods = [list(m) for m in sets[0] if m[0] not in DROP]
            vl[1].append((o, n, [mods]))
            if n == b"o001":
                d = [list(m) for m in mods]
                setf(d, b"unam", 3, "|cff00ff00Diệp Thanh|r".encode())
                setf(d, b"umdl", 3, b"Hero\\HeroNgaMy.mdl")
                setf(d, b"uico", 3, b"ReplaceableTextures\\CommandButtons\\BTNHero_NgaMy.blp")
                vl[1].append((o, NEW, [d]))
            print("boss", n.decode(), "abilities removed")
    open(p, "wb").write(objdata.write(ver, vl, ".w3u"))
    os.makedirs(os.path.join(SRC, "Hero"), exist_ok=True)
    for mdl, texs in MODELS.items():
        shutil.copy(os.path.join(TK, "Hero", mdl), os.path.join(SRC, "Hero", mdl))
        for t in texs:
            shutil.copy(os.path.join(TK, t), os.path.join(SRC, t))
    btn = os.path.join(SRC, "ReplaceableTextures", "CommandButtons")
    os.makedirs(btn, exist_ok=True)
    for ic in ICONS:
        s = os.path.join(TK, "ReplaceableTextures", "CommandButtons", ic)
        if os.path.exists(s):
            shutil.copy(s, os.path.join(btn, ic))
        else:
            print("icon missing:", ic)


if __name__ == "__main__":
    main()
