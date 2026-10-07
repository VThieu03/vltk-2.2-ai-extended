# Recover file names for an MPQ without (listfile).
# Every file is unencrypted, so all blocks can be read by index; names are
# guessed from strings found inside the files and checked against the hash table.
import os, re, sys, struct
from mpq import MPQ, hs

MAP = sys.argv[1] if len(sys.argv) > 1 else r"D:\vlkt-dev\work\base.w3x"
BASE = 512
OUT = sys.argv[2] if len(sys.argv) > 2 else r"D:\vlkt-dev\work\listfile.txt"
EXTRA_DIRS = [r"D:Warcraft 1.31.1Data"]

STANDARD = """war3map.j war3map.lua war3map.w3i war3map.w3e war3map.wpm war3map.doo war3mapUnits.doo
war3map.w3r war3map.w3c war3map.w3s war3map.wtg war3map.wct war3map.wts war3map.shd war3mapMap.blp
war3mapMap.tga war3mapPreview.tga war3mapPath.tga war3map.mmp war3map.w3u war3map.w3t war3map.w3b
war3map.w3d war3map.w3a war3map.w3h war3map.w3q war3map.imp war3mapMisc.txt war3mapSkin.txt
war3mapExtra.txt war3map.w3o (attributes) (signature) (listfile) war3mapSkin.w3u war3mapSkin.w3t
war3mapSkin.w3a war3mapSkin.w3h war3mapSkin.w3b war3mapSkin.w3d war3mapSkin.w3q
Units\\UnitData.slk Units\\UnitUI.slk Units\\UnitBalance.slk Units\\UnitWeapons.slk Units\\UnitAbilities.slk
Units\\ItemData.slk Units\\AbilityData.slk Units\\AbilityBuffData.slk Units\\UpgradeData.slk
Units\\DestructableData.slk Doodads\\Doodads.slk Units\\CampaignUnitFunc.txt Units\\CampaignUnitStrings.txt
Units\\HumanUnitFunc.txt Units\\HumanUnitStrings.txt Units\\OrcUnitFunc.txt Units\\OrcUnitStrings.txt
Units\\NightElfUnitFunc.txt Units\\NightElfUnitStrings.txt Units\\UndeadUnitFunc.txt Units\\UndeadUnitStrings.txt
Units\\NeutralUnitFunc.txt Units\\NeutralUnitStrings.txt Units\\ItemFunc.txt Units\\ItemStrings.txt
Units\\CommonAbilityFunc.txt Units\\CommonAbilityStrings.txt Units\\HumanAbilityFunc.txt
Units\\HumanAbilityStrings.txt Units\\OrcAbilityFunc.txt Units\\OrcAbilityStrings.txt
Units\\NightElfAbilityFunc.txt Units\\NightElfAbilityStrings.txt Units\\UndeadAbilityFunc.txt
Units\\UndeadAbilityStrings.txt Units\\NeutralAbilityFunc.txt Units\\NeutralAbilityStrings.txt
Units\\CampaignAbilityFunc.txt Units\\CampaignAbilityStrings.txt Units\\ItemAbilityFunc.txt
Units\\ItemAbilityStrings.txt Units\\CommonAbilityFunc.txt Units\\MiscData.txt Units\\MiscGame.txt
Units\\CampaignUpgradeFunc.txt Units\\CampaignUpgradeStrings.txt Units\\HumanUpgradeFunc.txt
Units\\HumanUpgradeStrings.txt Units\\NeutralUpgradeFunc.txt Units\\NeutralUpgradeStrings.txt
Units\\OrcUpgradeFunc.txt Units\\OrcUpgradeStrings.txt Units\\UndeadUpgradeFunc.txt
Units\\UndeadUpgradeStrings.txt Units\\NightElfUpgradeFunc.txt Units\\NightElfUpgradeStrings.txt
Units\\Telemetry.txt Scripts\\common.j Scripts\\Blizzard.j Scripts\\war3map.j Scripts\\common.ai
UI\\FrameDef\\GlobalStrings.fdf UI\\FontStyles.txt UI\\MiscUI.txt UI\\MiscData.txt UI\\WorldEditStrings.txt
UI\\SkinMetaData.slk UI\\war3skins.txt UI\\FrameDef\\FrameDef.toc war3mapImported\\FrameDef.toc
UI\\TriggerData.txt UI\\TriggerStrings.txt Fonts\\FRIZQT__.TTF Fonts\\DFHeiMd.ttf
""".split()

EXT = r"(?:mdx|mdl|blp|tga|dds|mp3|wav|flac|ogg|txt|slk|fdf|toc|ai|j|lua|ttf|otf|w3[a-z]|wtg|wct|wts|imp|doo|shd|mmp|wpm|pld|tif|jpg|png)"
PAT = re.compile(rb"[A-Za-z0-9_\\/.\- ()\[\]#~!@$%&'+,;=\x80-\xff]{1,250}\." + EXT.encode(), re.I)


def norm(n):
    n = n.replace("/", "\\").strip().strip("\\")
    while "\\\\" in n:
        n = n.replace("\\\\", "\\")
    return n


def variants(n):
    n = norm(n)
    out = {n}
    base, ext = os.path.splitext(n)
    el = ext.lower()
    if el in (".mdl", ".mdx"):
        out |= {base + ".mdx", base + ".mdl", base + "_portrait.mdx", base + "_Portrait.mdx"}
    if el in (".blp", ".tga", ".dds"):
        out |= {base + ".blp", base + ".tga", base + ".dds"}
    for x in list(out):
        leaf = x.split("\\")[-1]
        out |= {leaf, "war3mapImported\\" + leaf}
        if x.lower().startswith("war3mapimported\\"):
            out.add(x[16:])
        d, f = os.path.split(x)
        # disabled icon variants
        if "commandbuttons" in x.lower() or f.lower().startswith(("btn", "pas", "atc")):
            out |= {
                "ReplaceableTextures\\CommandButtonsDisabled\\DIS" + f,
                "ReplaceableTextures\\CommandButtonsDisabled\\DISBTN" + f[3:] if f.lower().startswith("btn") else f,
                "ReplaceableTextures\\PassiveButtons\\" + f,
                "ReplaceableTextures\\CommandButtons\\" + f,
            }
    return out


def mdx_textures(data):
    if data[:4] != b"MDLX":
        return []
    i, res = 4, []
    while i + 8 <= len(data):
        tag, size = data[i : i + 4], struct.unpack_from("<I", data, i + 4)[0]
        if tag == b"TEXS":
            for k in range(i + 8, i + 8 + size, 268):
                fn = data[k + 4 : k + 264].split(b"\0")[0]
                if fn:
                    res.append(fn)
        i += 8 + size
    return res


def main():
    m = MPQ(MAP, BASE)
    table = {}
    for ha, hb, loc, plat, bi in m.hashes:
        if bi < m.bcount:
            table[(ha, hb)] = bi
    names = {}  # block index -> name

    def check(n):
        try:
            key = (hs(n, 1), hs(n, 2))
        except UnicodeEncodeError:
            return False
        bi = table.get(key)
        if bi is not None and bi not in names:
            names[bi] = n
            return True
        return False

    print("reading", m.bcount, "blocks ...")
    blobs = {}
    for bi in range(m.bcount):
        if m.blocks[bi][3] & 0x80000000:
            try:
                blobs[bi] = m.read_block(bi, "")
            except Exception as e:
                blobs[bi] = b""

    cands = set(STANDARD)
    for d in EXTRA_DIRS:
        if os.path.isdir(d):
            for root, _, files in os.walk(d):
                for f in files:
                    rel = os.path.relpath(os.path.join(root, f), d)
                    cands.add(rel.encode("utf-8").decode("latin1"))
    for bi, b in blobs.items():
        for s in PAT.findall(b):
            cands.add(s.decode("latin1"))
        for t in mdx_textures(b):
            cands.add(t.decode("latin1"))

    tried = set()
    while True:
        new = set()
        for c in cands:
            for v in variants(c):
                if v in tried:
                    continue
                tried.add(v)
                for enc in (v,):
                    if check(enc):
                        new.add(enc)
        if not new:
            break
        cands = set()
        for n in new:
            bi = [k for k, v in names.items() if v == n][0]
            for t in mdx_textures(blobs.get(bi, b"")):
                cands.add(t.decode("latin1"))

    with open(OUT, "w", encoding="utf-8") as f:
        for bi in sorted(names):
            f.write(names[bi] + "\n")
    live = sum(1 for b in m.blocks if b[3] & 0x80000000)
    print("named %d / %d files" % (len(names), live))
    unk = [bi for bi in blobs if bi not in names]
    from collections import Counter

    print("unnamed by magic:", Counter(blobs[bi][:4] for bi in unk).most_common(10))


if __name__ == "__main__":
    main()
