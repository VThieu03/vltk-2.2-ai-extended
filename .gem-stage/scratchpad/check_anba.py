import sys
sys.path.insert(0, r"D:\vltk-2.2-ai-extended\tools")
import objdata

w3a_data = open(r"D:\vltk-2.2-ai-extended\src\map\war3map.w3a", "rb").read()
ver, tabs = objdata.parse(w3a_data, ".w3a")

# Find an autocast ability, base ANba
for tab in tabs:
    for o, nw, sets in tab:
        if o == b"ANba":
            print(f"Found ANba -> {nw.decode()}")
            for s in sets[0]:
                if s[0] in [b"amcs", b"acdn", b"aran", b"Hba1", b"Hba2", b"Hba3", b"abuf"]:
                    print(s)
            break
