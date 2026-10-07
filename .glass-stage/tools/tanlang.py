# Boss Tan Thuy Hoang (Kiem Vu Chi Ton, Silva.Fox): the unit n0TL in war3map.w3u plus its models and textures.
# The event itself (when it appears, its skills, the Tan Lang Hoa Thi Bich drop 'ITHB') is tools/jass/gameplay_11_tanlang.j.
# Numbers read from KVCT's own unit tables (D:\kvct-dev\src\map\Units\*.slk, row n038): model scale 2.3, move speed 300,
# ranged attack 600, attack cooldown 0.8, level 100, base HP 10000 (KVCT multiplies it by script; here the JASS sets the HP).
# Run after convert_text.py and import_boss.py (they rewrite war3map.w3u), before gameplay.py; safe to rerun.
import os, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import vfx

SRC = vfx.SRC
NEW = b"n0TL"          # unit id of the boss (checked: not used by war3map.w3u / war3map.j before this step)
TEMPLATE = b"n008"     # custom unit of the map (Vo Lam Minh Chu): its fields are copied, then overridden
MODELS = ["Boss_tanthuyhoang.mdx", "BienThan_tanthuyhoang.mdx"]
MODEL_PATH = "war3mapImported\\Boss_tanthuyhoang.mdx"


def s(v):
    return v.encode("utf-8")


def i(v):
    return struct.pack("<i", v)


def f(v):
    return struct.pack("<f", v)


# field id -> (type, value): types 0 int, 1 real, 2 unreal, 3 string (see objdata.py)
FIELDS = {
    b"unam": (3, s("|cffffcc07Tần Thủy Hoàng|r")),
    b"umdl": (3, s(MODEL_PATH)),
    b"uico": (3, s("ReplaceableTextures\\CommandButtons\\BTNArthas.blp")),
    b"usca": (1, f(2.3)),          # KVCT modelScale
    b"umvs": (0, i(300)),          # KVCT spd
    b"ulev": (0, i(60)),
    b"uhpm": (0, i(100000)),       # the JASS sets the real HP
    b"udef": (0, i(80)),
    b"uabi": (3, b""),             # no stock abilities (KVCT's A0PG... are KVCT skills, not copied)
    b"ua1b": (0, i(500)),
    b"ua1d": (0, i(2)),
    b"ua1s": (0, i(100)),
    b"ua1r": (0, i(600)),          # KVCT rangeN1
    b"ua1c": (2, f(0.8)),          # KVCT cool1
    b"ua1w": (3, s("missile")),
    b"ua1m": (3, s("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl")),
    b"ua1z": (0, i(1500)),         # KVCT Missilespeed
    b"utyp": (3, s("giant")),
}


def main():
    p = os.path.join(SRC, "war3map.w3u")
    ver, vl = objdata.parse(open(p, "rb").read(), ".w3u")
    used = [e[1] for e in vl[0] + vl[1] if e[1] != NEW]
    if NEW in used:
        sys.exit("tanlang: unit id %s already used" % NEW.decode())
    tpl = next((e for e in vl[1] if e[1] == TEMPLATE), None)
    if tpl is None:
        sys.exit("tanlang: template unit %s not found in war3map.w3u" % TEMPLATE.decode())
    vl[1][:] = [e for e in vl[1] if e[1] != NEW]
    mods = [list(m) for m in tpl[2][0] if m[0] not in FIELDS]
    for k, (typ, val) in FIELDS.items():
        mods.append([k, None, None, typ, val, b"\0\0\0\0"])
    vl[1].append([tpl[0], NEW, [mods]])
    open(p, "wb").write(objdata.write(ver, vl, ".w3u"))

    # models and textures (read from KVCT's archive; its outside texture pack D:\KVCT31_Data, as vfx.py does)
    kv = vfx.vlkt()
    imp = os.path.join(SRC, "war3mapImported")
    os.makedirs(imp, exist_ok=True)
    nf = 0
    for mdl in MODELS:
        data = vfx.read(kv, vfx.I + mdl)
        if data is None:
            sys.exit("tanlang: not in KVCT: " + vfx.I + mdl)
        files = {vfx.I + mdl: data}
        for t in vfx.textures(data):
            d = vfx.read(kv, t)
            ext = os.path.join(vfx.KVCT_DATA, *t.split("\\"))
            if d is None and os.path.exists(ext):
                d = open(ext, "rb").read()
            if d is not None:       # stock textures (Textures\Flare.blp) are in the game files
                files[t] = d
        for name, d in files.items():
            q = os.path.join(SRC, *name.split("\\"))
            os.makedirs(os.path.dirname(q), exist_ok=True)
            open(q, "wb").write(d)
            nf += 1
    print("tanlang: unit %s (Tan Thuy Hoang), %d model/texture files" % (NEW.decode(), nf))


if __name__ == "__main__":
    main()
