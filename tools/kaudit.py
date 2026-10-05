# Audit of the KVCT skills in this map: KVCT description vs what the engine (kskill.j) does for it.
# Writes docs\kvct_audit.md.  python kaudit.py
import os, sys, collections
sys.path.insert(0, os.path.dirname(__file__))
from kskill_data import CLASS, HERO, load

OUT = r"D:\vltk-dev-clone\docs\kvct_audit.md"
KIND = {0: "bị động (cộng chỉ số)", 1: "đánh mục tiêu", 2: "quét phía trước", 3: "xung kích", 4: "nổ quanh thân",
        5: "đạn bay xuyên", 6: "buff bản thân", 7: "buff phe ta", 8: "miễn khống chế", 9: "hộ thuẫn"}
FX = {1: "đẩy lùi", 2: "kéo đối thủ", 4: "hút máu", 8: "độc / bỏng mỗi giây", 16: "hồi máu", 32: "sát thương quanh mỗi giây",
      64: "miễn nhiễm sát thương", 128: "phản đòn", 512: "giảm kháng (nhận thêm 15%)", 1024: "phát động khi máu dưới 40%"}
STATUS = {1: "thọ thương", 2: "định thân", 3: "choáng", 4: "làm chậm"}
# words the engine still has no mechanic for
TODO = {"triệu hồi": "triệu hồi", "phân thân": "phân thân", "ảo ảnh": "ảo ảnh", "tàng hình": "tàng hình",
        "cộng dồn": "cộng dồn tầng", "dịch chuyển": "dịch chuyển", "hồi nội lực": "hồi nội lực",
        "bất tử": "bất tử", "khiêu khích": "khiêu khích"}


def main():
    data = load()
    out = ["# Soát kỹ năng KVCT trong bản VLTK", "",
           "Mỗi chiêu: khuôn đang dùng, trạng thái và hiệu ứng thêm đọc từ mô tả KVCT, và những gì mô tả nhắc mà bộ máy chưa làm.", ""]
    total, gaps = 0, collections.Counter()
    for hero, cl in CLASS.items():
        out += ["## %s (%s)" % (HERO[hero][1], cl), "", "| Chiêu | Phím | Khuôn | Đã làm | Chưa làm |", "|---|---|---|---|---|"]
        for s in data.get(cl, [])[:14]:
            total += 1
            t = s["tip"].lower()
            done = [STATUS[s["status"]] + " %d%%" % s["chance"]] if s["status"] else []
            done += [v for k, v in FX.items() if s["fx"] & k]
            if s["hits"] > 1:
                done.append("%d đòn" % s["hits"])
            miss = sorted({v for w, v in TODO.items() if w in t})
            gaps.update(miss)
            out.append("| %s | %s | %s | %s | %s |" % (s["name"], s["key"] or "-", KIND[s["kind"]], ", ".join(done) or "-",
                                                    ", ".join(miss) or ""))
        out.append("")
    out[3:3] = ["Tổng %d chiêu. Cơ chế còn thiếu: %s." % (total, ", ".join("%s (%d)" % kv for kv in gaps.most_common()) or "không"), ""]
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write("\n".join(out))
    print(out[3])


if __name__ == "__main__":
    main()
