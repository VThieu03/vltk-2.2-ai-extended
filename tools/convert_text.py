# Convert every TCVN3 string of the map to Unicode (tcvn3.py decides per string).
# Reads the untouched originals from work\orig (copied there on first run), writes src\map.
import os, re, shutil, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata, tcvn3

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
ORIG = os.path.join(ROOT, "work", "orig")
if not os.path.isdir(ORIG):
    shutil.copytree(SRC, ORIG)
stats = {}
samples = []


def conv(s, where):
    new, ch = tcvn3.convert(s)
    if ch:
        stats[where] = stats.get(where, 0) + 1
        if len(samples) < 12 and len(s) > 12:
            samples.append((where, s[:60], new[:60]))
    return new


def text(name, fn):
    t = open(os.path.join(ORIG, name), "rb").read().decode("utf-8")
    open(os.path.join(SRC, name), "wb").write(fn(t).encode("utf-8"))


# script: string literals only
LIT = re.compile(r'"(?:[^"\\\r\n]|\\.)*"')
text(r"Scripts\war3map.j", lambda t: LIT.sub(lambda m: conv(m.group(0), "script"), t))
# wts: each STRING body (do not overwrite if src/map/war3map.wts already exists)
if not os.path.exists(os.path.join(SRC, "war3map.wts")):
    text(
        "war3map.wts",
        lambda t: re.sub(r"(\{)(.*?)(\})", lambda m: m.group(1) + conv(m.group(2), "wts") + m.group(3), t, flags=re.S),
    )
# skin / misc: values after "="
for f in ("war3mapSkin.txt", "war3mapMisc.txt"):
    text(f, lambda t: re.sub(r"(?m)^([^=\r\n]*=)(.*)$", lambda m: m.group(1) + conv(m.group(2), "skin"), t))
# the skin forces every UI font to the imported Font\VNVOGU.TTF, a TCVN3 font with only 16 of the 66
# Unicode Vietnamese letters: drop those lines so the game's (Unicode) font shows the converted text
p = os.path.join(SRC, "war3mapSkin.txt")
t = open(p, "rb").read().decode("utf-8")
t = re.sub(r"(?mi)^\w*Font=Font\\VNVOGU\.TTF[^\S\n]*\n?", "", t)
# chữ sai trong map gốc (Ê thay cho Ấ): "CÊp" = Cấp, "RÊt" = Rất ... (thêm cặp (sai, đúng) vào đây)
for bad, good in (("CÊp", "Cấp"), ("RÊt", "Rất")):
    t = t.replace(bad, good)
open(p, "wb").write(t.encode("utf-8"))
# object data string values
for f in ("war3map.w3u", "war3map.w3t", "war3map.w3b", "war3map.w3d", "war3map.w3a", "war3map.w3h", "war3map.w3q"):
    ext = os.path.splitext(f)[1]
    of_ = objdata.ObjectFile.load(os.path.join(ORIG, f))
    tables = of_.tables
    for tab in tables:
        for obj in tab:
            for mods in obj[2]:
                for m in mods:
                    if m[3] == 3:
                        m[4] = conv(m[4].decode("utf-8"), f).encode("utf-8")
    of_.save(os.path.join(SRC, f))  # đọc bản gốc, ghi vào src

print("converted strings:", stats)
print("TCVN3 codes without a mapping:", tcvn3.unknown)
for w, a, b in samples:
    print("%-12s %s\n%-12s -> %s" % (w, a, "", b))
