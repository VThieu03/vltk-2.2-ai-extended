# Bang ky nang KVCT theo tung phai, doc tu map da sinh (src\map\war3map.w3a + build\kskill_table.j, ca hai do
# kskill.py viet ra): ten, phim, loai, so hit, cap mo; Q W E danh dau autocast (cung luat voi kskill.py AUTO_KEY).
#   python kskill_list.py  ->  docs\kvct_skill_table.md
import os, re, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata
from kskill_data import CLASS, HERO

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
TABLE = os.path.join(ROOT, "build", "kskill_table.j")
W3A = os.path.join(ROOT, "src", "map", "war3map.w3a")
OUT = os.path.join(ROOT, "docs", "kvct_skill_table.md")
KIND = {0: "bị động", 1: "đánh mục tiêu", 2: "quét phía trước", 3: "lướt", 4: "nổ quanh thân", 5: "phóng / đạn bay",
        6: "buff bản thân", 7: "buff phe ta", 8: "miễn khống", 9: "hộ thuẫn", 11: "liên kích", 12: "nổ diện rộng 1000",
        13: "trận tại điểm (nhiều nhịp)", 14: "bật / tắt (tốn nội lực mỗi giây)", 15: "bùa chú tại điểm",
        16: "đánh lan tại mục tiêu", 17: "kiếm khí vào địch ngẫu nhiên", 18: "vùng quanh thân (nhiều nhịp)"}


def main():
    t = open(TABLE, encoding="utf-8").read()
    ints = {}
    for o, k, v in re.findall(r"SaveInteger\(zzVL_ht,'(\w+)',(\d+),('?\w+'?)\)", t):
        ints[(o, int(k))] = v.strip("'")
    _, tabs = objdata.parse(open(W3A, "rb").read(), ".w3a")
    ab = {}
    for o in tabs[1]:
        sid = o[1].decode("latin-1")
        if sid[0] not in "XY":
            continue
        f = {m[0]: m[4] for m in o[2][0] if m[2] in (0, 1)}
        name = f.get(b"anam", b"").rstrip(b"\0").decode("utf-8", "replace")
        key = f.get(b"ahky", b"").rstrip(b"\0").decode("utf-8", "replace")
        ab[sid] = (name, key)
    out = ["# Kỹ năng KVCT theo từng phái (tự sinh bởi `tools/kskill_list.py`)", "",
           "Q W E của mọi phái là **autocast**: nhấp chuột phải vào biểu tượng để bật / tắt, "
           "bật thì đòn đánh thường tự tung chiêu. Phím khác (R D F T) bấm để tung; bị động tự có hiệu lực.", ""]
    total = 0
    for hero, cl in CLASS.items():
        out += ["## %s (%s, %s)" % (HERO[hero][1], cl, hero), "",
                "| # | Kỹ năng | ID | Phím | Loại | Số hit | Mở ở cấp |", "|---|---|---|---|---|---|---|"]
        for i in range(14):
            sid = ints.get((hero, 200 + i))
            if not sid:
                break
            name, key = ab.get(sid, ("?", ""))
            kind = int(ints.get((sid, 240), 0))
            if ints.get((sid, 249)) == "1":
                label = "tự phát khi đánh (%s)" % KIND.get(kind, kind)
            else:
                label = KIND.get(kind, str(kind))
            if key in ("Q", "W", "E") and kind in (1, 2, 3, 4, 5, 16):
                label += ", **autocast**"
            out.append("| %d | %s | %s | %s | %s | %s | %s |" % (i + 1, name, sid, key or "-", label,
                                                             ints.get((sid, 241), "1"), ints.get((hero, 230 + i), "?")))
            total += 1
        out.append("")
    open(OUT, "w", encoding="utf-8").write("\n".join(out))
    print("%d phái, %d kỹ năng -> %s" % (len(CLASS), total, os.path.relpath(OUT, ROOT)))


if __name__ == "__main__":
    main()
