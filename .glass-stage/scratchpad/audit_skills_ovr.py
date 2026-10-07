import sys, os, re
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
from kskill_data import load, CLASS, HERO
from kskill import OVR

data = load()
with open(os.path.join(os.path.dirname(__file__), "..", "docs", "kvct_skills.md"), "r", encoding="utf-8") as f:
    text = f.read()

print("=== SO SÁNH KỸ NĂNG KVCT vs ENGINE VLTK ===")
total_handlers = 0
ovr_count = 0
not_ovr_by_sect = {}

for hero, cl in CLASS.items():
    hero_name = HERO[hero][1]
    sect_skills = data.get(cl, [])[:14]
    sect_ovr = [s for s in sect_skills if s['kv'] in OVR]
    sect_needs = []
    
    for s in sect_skills:
        has_ovr = s['kv'] in OVR
        kv_id = s['kv']
        idx = text.find(f"({kv_id},")
        has_handler = False
        details = ""
        feats = ""
        if idx != -1:
            snippet = text[idx:idx+500]
            if "hàm riêng" in snippet:
                has_handler = True
                total_handlers += 1
                m = re.search(r"Code:\s*([^\n]+)", snippet)
                if m: details = m.group(1)
        if has_ovr:
            ovr_count += 1
        elif has_handler:
            sect_needs.append((s['name'], kv_id, s.get('key','-'), s['kind'], details, s['tip'].split('\n')[0]))
            
    if sect_needs:
        not_ovr_by_sect[cl] = (hero_name, sect_needs)

for cl, (hname, needs) in not_ovr_by_sect.items():
    print(f"\n[{cl}] {hname}: có {len(needs)} chiêu có code riêng trong KVCT nhưng đang dùng khuôn generic:")
    for name, kid, key, kind, code_info, tip in needs:
        print(f"  * {name} ({kid}, phím {key}, khuôn {kind}): {code_info}")
        print(f"    -> Mô tả: {tip[:90]}")

print(f"\nTổng số chiêu đã cấu hình OVR đặc thù: {ovr_count}")
print(f"Tổng số chiêu có code riêng trong KVCT cần tiếp tục bê qua: {sum(len(v[1]) for v in not_ovr_by_sect.values())}")
