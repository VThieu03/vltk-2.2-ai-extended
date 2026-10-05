# show where given characters occur (latin-1 view of TCVN3 text) in script + wts + skin
import re, sys, os
root = r"D:\vltk-dev-clone\src\map"
chars = sys.argv[1]
for f in ["Scripts\\war3map.j", "war3map.wts", "war3mapSkin.txt"]:
    t = open(os.path.join(root, f), "rb").read().decode("utf-8", "replace")
    for c in chars:
        for m in list(re.finditer(re.escape(c), t))[:4]:
            print(f, repr(c), "...", t[max(0, m.start() - 25):m.end() + 25].replace("\r", " ").replace("\n", " "))
