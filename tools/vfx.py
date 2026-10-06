# Skill effects in the style of KVCT (by Silva.Fox): the stock War3 effect models used by the skills are
# swapped for KVCT models of the same kind (fire, frost, lightning, poison, slash, explosion, heal, ...),
# in the ability / buff art fields and in the script. The models and the textures they use are copied
# from the KVCT archive under their own path. Run after icons.py, before scale.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata

VLKT_TOOLS = r"D:\kvct-dev\tools"                      # KVCT (Kiem Vo Chi Ton, Silva.Fox)
VLKT = r"D:\kvct-dev\work\base.w3x"
VLKT_OFF = 107008
KVCT_DATA = r"D:\KVCT31_Data"                         # holds KVCT3_Data\ (the KVCT models' textures)
SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
I = "war3mapImported\\"
# stock model (lowercase, no extension) -> KVCT model of the same kind
SWAP = {
    r"abilities\spells\other\stampede\stampedemissiledeath": "Effect_Slam",
    r"abilities\spells\nightelf\tranquility\tranquilitytarget": "Effect_hoasen2",
    r"abilities\spells\human\holybolt\holyboltspecialart": "TLQ_kimcuongeff",
    r"effect\holyboltspecialart": "TLQ_kimcuongeff",
    r"abilities\spells\demon\darkportal\darkportaltarget": "NDC_uminheffect",
    r"abilities\spells\human\feedback\spellbreakerattack": "Effect_kiemquang",
    r"objects\spawnmodels\other\neutralbuildingexplosion\neutralbuildingexplosion": "TND_thienngoaifire",
    r"abilities\spells\items\orbcorruption\orbcorruption": "Effect_missile1",
    r"abilities\spells\undead\frostnova\frostnovatarget": "Effect_dongbang",
    r"abilities\weapons\lordofflamemissile\lordofflamemissile": "TND_danchifire",
    r"abilities\weapons\reddragonbreath\reddragonmissile": "TND_danchifire",
    r"abilities\weapons\flamingarrow\flamingarrowmissile": "TND_danchifire",
    r"abilities\weapons\demolisherfiremissile\demolisherfiremissile": "TND_danchifire",
    r"abilities\spells\other\incinerate\firelorddeathexplode": "TND_tathoafire",
    r"abilities\spells\other\incinerate\incineratebuff": "Effect_fire2",
    r"effect\earthrender": "Effect_slam2",
    r"abilities\spells\orc\earthquake\earthquaketarget": "Effect_slam2",
    r"abilities\spells\demon\demonboltimpact\demonboltimpact": "Effect_bloodbom",
    r"abilities\weapons\steamtank\steamtankimpact": "TND_thienngoaifire",
    r"abilities\spells\undead\darkritual\darkritualcaster": "NDC_amphongcast",
    r"abilities\weapons\ancientprotectormissile\ancientprotectormissile": "TND_thienngoaistone",
    r"abilities\spells\other\healingspray\healbottlemissile": "Effect_missile1",
}


def vlkt():
    sys.path.insert(0, VLKT_TOOLS)
    import importlib
    mpq = importlib.import_module("mpq")
    sys.path.pop(0)
    return mpq.MPQ(VLKT, VLKT_OFF)


def read(m, name):
    r = m.find(name.encode("utf-8").decode("latin1"))
    if r is None:
        return None
    return m.read_block(r[1], name) if m.blocks[r[1]][2] else b""


def textures(data):
    out = []
    i = data.find(b"TEXS")
    if i >= 0:
        for j in range(struct.unpack_from("<i", data, i + 4)[0] // 268):
            p = data[i + 8 + 268 * j + 4:i + 8 + 268 * j + 264].split(b"\0")[0].decode("latin1")
            if p:
                out.append(p)
    return out


def copy_models(m):
    done, n = {}, 0
    for model in sorted(set(SWAP.values())):
        name = I + model + ".mdx"
        data = read(m, name)
        if data is None:
            sys.exit("not in VLKT: " + name)
        files = {name: data}
        for t in textures(data):
            d = read(m, t)
            ext = os.path.join(KVCT_DATA, *t.split("\\"))
            if d is None and os.path.exists(ext):     # KVCT's outside texture pack: put it in the map
                d = open(ext, "rb").read()
            if d is not None:                     # stock textures are in the game files
                files[t] = d
        for f, d in files.items():
            p = os.path.join(SRC, *f.split("\\"))
            os.makedirs(os.path.dirname(p), exist_ok=True)
            open(p, "wb").write(d)
            n += 1
        done[model] = name
    return done, n


def key(path):
    p = path.strip().lower().replace("/", "\\")
    return re.sub(r"\.md[lx]$", "", p)


def objects(ext, fields):
    p = os.path.join(SRC, "war3map" + ext)
    ver, tabs = objdata.parse(open(p, "rb").read(), ext)
    n = 0
    for tab in tabs:
        for o, nw, sets in tab:
            for s in sets:
                for x in s:
                    if x[0] in fields and x[3] == 3:
                        parts = x[4].decode("utf-8", "ignore").rstrip("\0").split(",")
                        new = [I + SWAP[key(v)] + ".mdx" if key(v) in SWAP else v for v in parts]
                        if new != parts:
                            x[4] = ",".join(new).encode("utf-8")
                            n += 1
    open(p, "wb").write(objdata.write(ver, tabs, ext))
    return n


def script():
    p = os.path.join(SRC, "Scripts", "war3map.j")
    s = open(p, "rb").read().decode("utf-8")
    n = 0

    def sub(mt):
        nonlocal n
        k = key(mt.group(1).replace("\\\\", "\\"))
        if k not in SWAP:
            return mt.group(0)
        n += 1
        return '"' + (I + SWAP[k] + ".mdx").replace("\\", "\\\\") + '"'
    s = re.sub(r'"([^"\r\n]+\.md[lx])"', sub, s, flags=re.I)
    open(p, "wb").write(s.encode("utf-8"))
    return n


def main():
    done, nf = copy_models(vlkt())
    a = objects(".w3a", {b"aeat", b"amat", b"atat", b"acat", b"asat", b"aaea", b"ata0", b"ata1"})
    h = objects(".w3h", {b"fart", b"ftat", b"feat", b"fmat", b"fsat"})
    j = script()
    print("vfx: %d models (%d files), %d ability fields, %d buff fields, %d script effects" % (len(done), nf, a, h, j))


if __name__ == "__main__":
    main()
