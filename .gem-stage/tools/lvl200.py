# Level cap 200 (was 40): hero stat gains per level / 5 (a level 200 hero is as strong as a level 40 one was),
# hero skills learnt 5 times later (required level, levels between ranks), experience table flatter.
# gameplay.j keeps the pace (30-45 minutes to level 200). Run after tranphai.py / import_boss.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata
import config

SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
K = config.HERO_STAT_DIVIDER


def load(ext):
    p = os.path.join(SRC, "war3map" + ext)
    return p, objdata.parse(open(p, "rb").read(), ext)


def setint(mods, key, v):
    for x in mods:
        if x[0] == key:
            x[4] = struct.pack("<i", v)
            return
    mods.append([key, 0, 0, 0, struct.pack("<i", v), b"\0\0\0\0"])


def main():
    p, (ver, tabs) = load(".w3u")
    nu = 0
    for tab in tabs:
        for o, n, sets in tab:
            for x in sets[0]:
                if x[0] in (b"ustp", b"uagp", b"uinp"):
                    x[4] = struct.pack("<f", struct.unpack("<f", x[4])[0] / K)
                    nu += 1
    open(p, "wb").write(objdata.write(ver, tabs, ".w3u"))
    p, (ver, tabs) = load(".w3a")
    na = 0
    for tab in tabs:
        for o, n, sets in tab:
            mods = sets[0]
            f = {x[0]: x for x in mods}
            hero = b"aher" in f and struct.unpack("<i", f[b"aher"][4])[0] == 1
            if not hero and b"arlv" not in f:
                continue
            if b"aher" in f and not hero:
                continue
            rl = struct.unpack("<i", f[b"arlv"][4])[0] if b"arlv" in f else 1
            sk = struct.unpack("<i", f[b"alsk"][4])[0] if b"alsk" in f else 2
            setint(mods, b"arlv", 1 + (rl - 1) * K)
            setint(mods, b"alsk", sk * K)
            na += 1
    open(p, "wb").write(objdata.write(ver, tabs, ".w3a"))
    p = os.path.join(SRC, "war3mapMisc.txt")
    s = open(p, "rb").read().decode("utf-8")
    nl = "\r\n" if "\r\n" in s else "\n"
    for k, v in (("MaxHeroLevel", "200"), ("NeedHeroXP", "200"), ("NeedHeroXPFormulaA", "1"),
                 ("NeedHeroXPFormulaB", "60"), ("NeedHeroXPFormulaC", "0")):
        if re.search(r"(?m)^%s=" % k, s):
            s = re.sub(r"(?m)^%s=[^\r\n]*" % k, "%s=%s" % (k, v), s)
        else:
            s = s.replace("[Misc]" + nl, "[Misc]" + nl + "%s=%s%s" % (k, v, nl), 1)
    open(p, "wb").write(s.encode("utf-8"))
    print("level 200: %d stat gains, %d hero skills" % (nu, na))


if __name__ == "__main__":
    main()
