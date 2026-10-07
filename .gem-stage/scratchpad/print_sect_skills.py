import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
from kskill_data import load, CLASS, HERO

data = load()
for hero, cl in CLASS.items():
    hname = HERO[hero][1]
    keyed = [s for s in data.get(cl, [])[:14] if s.get('key')]
    print(f"\n[{cl}] {hname} ({hero}):")
    for s in keyed:
        print(f"  {s['kv']}: \"{s['name']}\" [Phím {s['key']}, khuôn {s['kind']}, đòn {s['hits']}] - {s['tip'].split(chr(10))[0][:70]}")
