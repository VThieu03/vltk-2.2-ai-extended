import sys
sys.path.insert(0, r"d:\vltk-2.2-ai-extended\tools")
import objdata

ver, tabs = objdata.parse(open(r"d:\vltk-2.2-ai-extended\src\map\war3map.w3a", "rb").read(), ".w3a")
for o, n, sets in tabs[1]:
    for x in sets[0]:
        if x[0] in (b"Hba1", b"Hba2", b"Poa1", b"Poa2", b"Hca1", b"Hca2"):
            print(n, x[0], x[4])
