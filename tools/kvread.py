# Read how each KVCT skill works from KVCT's (obfuscated) script: find the cast handler of the ability,
# follow its own functions (the shared core used by many skills is left out) and list what they do:
# effect models, sounds, areas, movement, missiles, lightning, dummy units, timers, numbers.
# Writes docs\kvct_skills.md.  python kvread.py
import os, re, sys, collections
sys.path.insert(0, os.path.dirname(__file__))
from kskill_data import CLASS, load

KJ = r"D:\kvct-dev\work\readable.j"
OUT = r"D:\vltk-dev-clone\docs\kvct_skills.md"
src = open(KJ, encoding="utf-8", errors="ignore").read().replace("\r\n", "\n")
L = src.split("\n")
g0, g1 = L.index("globals"), L.index("endglobals")
consts = {}
for l in L[g0 + 1:g1]:
    m = re.match(r"\s*(?:constant\s+)?integer\s+(\w+)=(?:\$([0-9A-Fa-f]{8})|(\d{9,10}))\s*$", l)
    if m:
        consts[m.group(1)] = int(m.group(2), 16) if m.group(2) else int(m.group(3))
funcs, cur = {}, None
for l in L[g1 + 1:]:
    m = re.match(r"(?:constant\s+)?function (\w+)", l)
    if m:
        cur = m.group(1)
        funcs[cur] = [l]
    elif cur:
        funcs[cur].append(l)
        if l.strip() == "endfunction":
            cur = None
body = {f: "\n".join(b) for f, b in funcs.items()}
calls = {f: set(w for w in re.findall(r"\b([A-Za-z_]\w*)\s*\(", re.sub(r'"[^"]*"', '""', b)) if w in funcs)
         | set(re.findall(r"function (\w+)", b[b.index("\n"):] if "\n" in b else "")) & set(funcs)
         for f, b in body.items()}


def raw(i):
    return int.from_bytes(i.encode(), "big")


def handlers(aid):
    v = raw(aid)
    names = {c for c, x in consts.items() if x == v}
    alt = "|".join([re.escape("$%08X" % v)] + sorted(names))
    pat = re.compile(r"GetSpellAbilityId\(\)==(" + alt + r")\b", re.I)
    return [f for f, b in body.items() if pat.search(b)]


def reach(roots, depth):
    seen, front = set(roots), list(roots)
    for _ in range(depth):
        nxt = []
        for f in front:
            for g in calls.get(f, ()):
                if g not in seen:
                    seen.add(g)
                    nxt.append(g)
        front = nxt
    return seen


def main():
    data = load()
    per = {}
    for hero, cl in CLASS.items():
        for s in data.get(cl, [])[:14]:
            hs = handlers(s["kv"])
            per[(cl, s["kv"])] = (s, hs, reach(hs, 4))
    count = collections.Counter(f for _, _, r in per.values() for f in r)
    core = {f for f, c in count.items() if c > 6}
    out = ["# Kỹ năng KVCT - đọc từ script (tự động)", "",
           "Mỗi skill: hàm xử lý khi tung chiêu, các hàm riêng của nó (bỏ phần lõi dùng chung %d hàm) và những gì chúng làm." % len(core), ""]
    for hero, cl in CLASS.items():
        out += ["## %s (%s)" % (cl, hero), ""]
        for s in data.get(cl, [])[:14]:
            s_, hs, r = per[(cl, s["kv"])]
            own = [f for f in r if f not in core]
            text = "\n".join(body[f] for f in own)
            models = sorted(set(m.split("\\")[-1] for m in re.findall(r'"([^"]+\.md[xl])"', text, re.I)))
            sounds = sorted(set(m.split("\\")[-1] for m in re.findall(r'"([^"]+\.(?:wav|mp3))"', text, re.I)))
            feat = []
            if re.search(r"SetUnitX|SetUnitPosition", text):
                feat.append("di chuyển (lao / đẩy / kéo)")
            if re.search(r"BlzSetSpecialEffect(X|Position)|SetUnitX\(.*dummy", text):
                feat.append("đạn bay (effect di chuyển)")
            if "AddLightning" in text:
                feat.append("tia sét / dây nối")
            if re.search(r"CreateUnit", text):
                feat.append("tạo lính ảo / triệu hồi")
            if re.search(r"GroupEnumUnitsInRange", text):
                feat.append("đánh vùng")
            if re.search(r"PauseUnit|SetUnitPropWindow", text):
                feat.append("khống chế (dừng / định thân)")
            if "SetUnitVertexColor" in text or "SetUnitTimeScale" in text:
                feat.append("đổi màu / tốc độ diễn hoạt")
            if "SetUnitAnimation" in text:
                feat.append("diễn hoạt riêng")
            radii = sorted(set(int(x) for x in re.findall(r"GroupEnumUnitsInRange\([^,]+,[^,]+,[^,]+,(\d+)", text)))
            loops = len(re.findall(r"TimerStart|fS5\(", text))
            out.append("- **%s** (%s, %s)%s" % (s["name"], s["kv"], {0: "bị động", 1: "đánh mục tiêu", 2: "quét phía trước", 3: "xung kích",
                                                               4: "nổ quanh thân", 5: "phóng / đạn bay", 6: "buff bản thân",
                                                               7: "buff phe ta", 8: "miễn khống chế"}[s["kind"]],
                                               " - phím %s" % s["key"] if s["key"] else ""))
            out.append("  - Mô tả: " + s["tip"].split("\n")[0])
            if hs:
                out.append("  - Code: %d hàm riêng, %d dòng; %s" % (len(own), text.count("\n"), ", ".join(feat) or "-"))
                if radii:
                    out.append("  - Bán kính: " + ", ".join(map(str, radii)))
                if loops:
                    out.append("  - Hẹn giờ / đánh lặp: %d" % loops)
                if models:
                    out.append("  - Model: " + ", ".join(models[:8]))
                if sounds:
                    out.append("  - Âm thanh: " + ", ".join(sounds[:4]))
            else:
                out.append("  - Code: không có hàm tung chiêu riêng (bị động / gắn vào đòn đánh hoặc lõi)")
        out.append("")
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write("\n".join(out))
    have = sum(1 for v in per.values() if v[1])
    print("skills %d, with a cast handler %d, core functions %d -> %s" % (len(per), have, len(core), OUT))


if __name__ == "__main__":
    main()
