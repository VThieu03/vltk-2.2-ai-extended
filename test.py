import sys
sys.path.insert(0, r'D:\vltk-dev-clone\tools')
import objdata
ver, tabs = objdata.parse(open(r'D:\vltk-dev-clone\src\map\war3map.w3t', 'rb').read(), '.w3t')
for ti, tab in enumerate(tabs):
    for o, n, sets in tab:
        iid = (o if ti == 0 else n).decode('latin1')
        if iid == 'rat3':
            d = {m[0]: m[4] for m in sets[0]}
            if b'unam' in d:
                print(d[b'unam'].decode('utf-8'))
