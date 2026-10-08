import sys
sys.path.insert(0, r"D:\vltk-2.2-ai-extended\tools")
import objdata

w3u_data = open(r"D:\vltk-2.2-ai-extended\src\map\war3map.w3u", "rb").read()
ver, tabs = objdata.parse(w3u_data, ".w3u")

for tab in tabs:
    for o, nw, sets in tab:
        if o == b"H00A" or nw == b"H00A":
            print(f"Found H00A (Cai Bang Chuong)")
            for s in sets[0]:
                if s[0] in [b"ua1w", b"ua1g", b"ua1r", b"ua1m", b"ua1t", b"ua1z"]:
                    print(s)
