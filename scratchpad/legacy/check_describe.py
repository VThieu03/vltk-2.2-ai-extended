import sys
sys.path.insert(0, r'D:\vltk-dev-clone\tools')
import objdata
ver, tabs = objdata.parse(open(r'D:\vltk-dev-clone\src\map\war3map.w3t', 'rb').read(), '.w3t')

from gameplay_items import items
slot_of = {iid: (slot, tier) for iid, slot, tier, _ in items()}

count = 0
for ti, tab in enumerate(tabs):
    for old, new, sets in tab:
        iid = (old if ti == 0 else new).decode('latin1')
        st = slot_of.get(iid)
        if st:
            d = {m[0]: m[4] for m in sets[0]}
            name = d.get(b'unam', b'').decode('utf-8')
            print(f"IID: {iid}, Slot: {st[0]}, Tier: {st[1]}, Old Name: {name}")
            count += 1
            if count > 5:
                break
    if count > 5:
        break
