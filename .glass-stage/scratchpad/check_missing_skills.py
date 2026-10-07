import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
from kskill_data import load, CLASS

data = load()
for cl, skills in data.items():
    for s in skills:
        t = s['tip'].lower()
        matched = [w for w in ['hồi nội lực', 'cộng dồn', 'triệu hồi', 'phân thân', 'ảo ảnh'] if w in t]
        if matched:
            print(f"[{cl}] {s['name']} (kind={s['kind']}, key={s.get('key', '')}, id={s['kv']}) - Matched: {matched}")
            print("   Tip:", s['tip'].replace('\n', ' ')[:140])
