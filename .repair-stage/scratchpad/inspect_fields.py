import os, sys
sys.path.insert(0, r"d:\vltk-2.2-ai-extended\tools")
import objdata

p = r"d:\vltk-2.2-ai-extended\src\map\war3map.w3a"
ver, a = objdata.parse(open(p, "rb").read(), ".w3a")
for o, n, sets in a[0] + a[1]:  # standard + custom
    if o in (b"ANba", b"AEpa", b"AHca"):
        print(f"Base: {o}")
        for mod in sets[0]:
            print(f"  Field: {mod[0]}")
