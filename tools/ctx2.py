# contexts of a character inside already-converted (Unicode) strings of src\map
import os, re, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata
c = sys.argv[1]
seen = 0
for f in ("war3map.w3t", "war3map.w3u", "war3map.w3a", r"Scripts\war3map.j", "war3mapSkin.txt"):
    d = open(os.path.join(r"D:\vltk-dev-clone\src\map", f), "rb").read().decode("utf-8", "replace")
    for m in re.finditer(re.escape(c), d):
        print(f, "...", d[max(0, m.start() - 30):m.end() + 20].replace("\r", " ").replace("\n", " "))
        seen += 1
        if seen > 12:
            sys.exit()
