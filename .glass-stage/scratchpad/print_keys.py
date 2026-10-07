import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
from kskill_data import load

data = load()
sects = ['NDC', 'DMPT', 'DMTT', 'DMPD', 'TND', 'TNK', 'NMC', 'NMK', 'TLD', 'TLB', 'CLD', 'DTK', 'CBB']
for cl in sects:
    print(f"\n=== {cl} ===")
    for s in data.get(cl, [])[:14]:
        print(f"  {s['kv']}: \"{s['name']}\" (phím {s.get('key','-')}, khuôn {s['kind']}, đòn {s['hits']})")
