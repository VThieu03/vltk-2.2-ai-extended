# Thêm MỌI chiêu của MỌI phái vào VFX của tools/kvfx/hand/<PHÁI>.py, với model đang có hiệu lực trong bản build gần nhất
# (build/kskill_table.j: main 250, cast 280/282, target 281/283, buff 284, area 285/286, aura 287, ground 288/289).
# Mục đã có trong file (người dùng đã viết) được GIỮ NGUYÊN; chỉ thêm các chiêu còn thiếu. Chạy: python tools/kvfx_fill.py
# Sau đó chạy lại pipeline: kết quả build phải giống hệt (các mục thêm vào chỉ nói rõ cái đang dùng).
import collections
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kvfx
from kskill_data import CLASS, load

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
BS = chr(92)


def parse_table():
    table = open(os.path.join(ROOT, "build", "kskill_table.j"), encoding="utf-8").read()
    models = collections.defaultdict(dict)  # skill id -> {key: model path}
    pat = "call SaveStr\\(zzVL_ht,'(\\w{4})',(\\d+),\"war3mapImported" + BS * 4 + "([^\"]+)\"\\)"
    for m in re.finditer(pat, table):
        k = int(m.group(2))
        if k in (250, 280, 281, 282, 283, 284, 285, 286, 287):
            models[m.group(1)][k] = m.group(3).replace(BS * 2, BS)
    flags = collections.defaultdict(dict)
    for m in re.finditer(r"call SaveInteger\(zzVL_ht,'(\w{4})',(288|289),(\d+)\)", table):
        flags[m.group(1)][int(m.group(2))] = int(m.group(3))
    hero_skill = collections.defaultdict(dict)
    for m in re.finditer(r"call SaveInteger\(zzVL_ht,'(\w{4})',(2[01]\d),'([XY]\d+)'\)", table):
        hero_skill[m.group(1)][int(m.group(2)) - 200] = m.group(3)
    return models, flags, hero_skill


def entry_of(ms, fl):
    def one_or_list(keys):
        xs = [ms[k] for k in keys if k in ms]
        return None if not xs else xs[0] if len(xs) == 1 else xs

    e = {}
    if 250 in ms:
        e["main"] = ms[250]
    for role, keys in (("cast", (280, 282)), ("target", (281, 283)), ("buff", (284,))):
        v = one_or_list(keys)
        if v:
            e[role] = v
    area = [ms[k] for k in (285, 286) if k in ms]
    if area:
        e["area"] = area
    if 287 in ms:
        e["aura"] = ms[287]
    if fl.get(289):
        e["cast_ground"] = True
    if fl.get(288):
        e["target_ground"] = True
    return e


def add_to_file(cl, new_lines):
    path = os.path.join(HERE, "kvfx", "hand", cl + ".py")
    text = open(path, encoding="utf-8").read() if os.path.exists(path) else "VFX = {\n}\n"
    a = text.index("VFX = {")
    b = text.index("\n}", a)
    head = text[:b].rstrip("\n")
    if not head.endswith("{") and not head.rstrip().endswith(","):
        head = head.rstrip() + ","  # the last line of the user's own entries may lack a comma
    out = head + "\n    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---\n"
    out += "\n".join(new_lines) + text[b:]
    open(path, "w", encoding="utf-8").write(out)


def main():
    models, flags, hero_skill = parse_table()
    data = load()
    total = 0
    for hero, cl in CLASS.items():
        mine = kvfx._load("hand", cl)
        lines = []
        for i, s in enumerate(data[cl][:14]):
            sid = hero_skill[hero].get(i)
            if not sid or s["name"] in mine:
                continue
            e = entry_of(models.get(sid, {}), flags.get(sid, {}))
            if not e:
                continue
            lines.append("    %r: %r,   # [%s]" % (s["name"], e, s["key"] or "bị động"))
        if lines:
            add_to_file(cl, lines)
            total += len(lines)
        print(cl, "thêm", len(lines))
    print("tổng số chiêu thêm:", total)


if __name__ == "__main__":
    main()
