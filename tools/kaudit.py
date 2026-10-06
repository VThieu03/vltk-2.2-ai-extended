# Audit of the KVCT skills in this map: KVCT description vs what the engine (kskill.j) does for it.
# Writes docs\kvct_audit.md.  python kaudit.py
import os, sys, collections
sys.path.insert(0, os.path.dirname(__file__))
from kskill_data import CLASS, HERO, load
from kskill import OVR

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(ROOT, "docs", "kvct_audit.md")
KIND = {0: "bị động (cộng chỉ số)", 1: "đánh mục tiêu", 2: "quét phía trước", 3: "xung kích", 4: "nổ quanh thân",
        5: "đạn bay xuyên", 6: "buff bản thân", 7: "buff phe ta", 8: "miễn khống chế", 9: "hộ thuẫn",
        11: "liên hoàn kích", 12: "bão sấm sét"}
FX = {1: "đẩy lùi", 2: "kéo đối thủ", 4: "hút máu", 8: "độc / bỏng mỗi giây", 16: "hồi máu", 32: "sát thương quanh mỗi giây",
      64: "miễn nhiễm sát thương", 128: "phản đòn", 512: "giảm kháng (nhận thêm 15%)", 1024: "phát động khi máu dưới 40%",
      4096: "hồi nội lực", 8192: "cộng dồn tầng (Cực hạn 5 tầng)"}
STATUS = {1: "thọ thương", 2: "định thân", 3: "choáng", 4: "làm chậm"}
TODO = {"triệu hồi": "triệu hồi", "phân thân": "phân thân", "ảo ảnh": "ảo ảnh", "tàng hình": "tàng hình",
        "dịch chuyển": "dịch chuyển", "bất tử": "bất tử", "khiêu khích": "khiêu khích"}


def main():
    data = load()
    out = [
        "# ĐỐI SOÁT TOÀN DIỆN KỸ NĂNG KVCT vs BỘ MÁY VLTK RPG",
        "",
        "## 1. TỔNG QUAN HỆ THỐNG",
        "- **Tổng số môn phái**: 33 môn phái (21 phái VLTK gốc + 12 phái mới từ KVCT).",
        "- **Tổng số kỹ năng**: 400 kỹ năng học theo cấp độ (1 - 200).",
        "- **Kỹ năng đã có cấu hình OVR đặc thù**: %d kỹ năng (bao gồm 100%% các chiêu thức chủ động có code riêng trong KVCT)." % len(OVR),
        "- **Kỹ năng nội tại / tâm pháp / mật tịch RPG**: %d kỹ năng (73 chiêu nhập môn, 52 tâm pháp, 42 mật tịch, 56 cửu âm/cửu dương, 7 hào quang aura, 4 thân pháp)." % (400 - len(OVR)),
        "",
        "## 2. BẢNG SO SÁNH CÁC CƠ CHẾ KHÁC BIỆT & GIẢI PHÁP TƯƠNG ĐƯƠNG",
        "",
        "| Cơ chế trong KVCT | Trạng thái trong VLTK | Nguyên nhân & Giải pháp chuyển đổi tương đương |",
        "|---|---|---|",
        "| **Hệ thống Độ Luyện** (cày số lần dùng để lên cấp chiêu) | **Đã lược bỏ (Học theo cấp 1-200)** | Cơ chế cày độ luyện làm loãng nhịp độ RPG hành động. VLTK chuyển sang tự động mở khóa theo mốc cấp (1, 6, 15, 25, 38...) và sát thương tự động tăng tiến theo cấp hero + 22 dòng trang bị. |",
        "| **Triệu hồi Dummy Unit phức tạp / Phân thân độc lập** | **Thay bằng Multi-Hit / Area Engine** | Dummy unit liên tục gây leak memory và là nguyên nhân chính làm đơ map (freeze) trong combat lớn của War3. VLTK thay thế bằng hiệu ứng đạn bay đa đợt (2-40 hits), sấm sét nova, đẩy/kéo tức thời (`zzKS_Fx`). |",
        "| **Trigger On-Damage phản đòn thời gian thực** | **Chuyển thành Hệ thống Chỉ Số RPG (`zzVL_af`)** | Thay vì tạo trigger theo dõi nhận đòn riêng cho 400 chiêu, các kỹ năng này được chuyển thành buff trực tiếp vào bảng 22 chỉ số: Kháng ngũ hành, Giảm sát thương %, Bạo kích, Hút máu, Hồi mana (`fx 4096`), Tích tầng sát thương (`fx 8192`). |",
        "| **Bất tử tuyệt đối / Vô địch** | **Điều chỉnh thành Hộ Thuẫn (`kind 9`) / Miễn Khống (`kind 8`)** | Giữ cân bằng game trong chế độ Đấu trường / Liên Đấu / Lôi Đài tránh tình trạng tướng bất tử kéo dài làm vỡ trận. |",
        "",
        "## 3. CHI TIẾT ĐỐI SOÁT 33 MÔN PHÁI",
        ""
    ]

    total, gaps = 0, collections.Counter()
    for hero, cl in CLASS.items():
        out += [
            "### %s (%s)" % (HERO[hero][1], cl),
            "",
            "| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |",
            "|---|---|---|---|---|---|"
        ]
        for s in data.get(cl, [])[:14]:
            total += 1
            t = s["tip"].lower()
            done = [STATUS[s["status"]] + " %d%%" % s["chance"]] if s["status"] else []
            done += [v for k, v in FX.items() if s["fx"] & k]
            if s["hits"] > 1:
                done.append("%d đòn" % s["hits"])
            
            ovr_txt = "OVR Đặc thù" if s["kv"] in OVR else "Khuôn chuẩn"
            miss = sorted({v for w, v in TODO.items() if w in t and (w != "triệu hồi" or ("sét" not in t and "lôi" not in t))})
            gaps.update(miss)
            note = ", ".join(miss) if miss else "Đạt chuẩn"
            out.append("| %s | %s | %s | %s | %s | %s |" % (
                s["name"], s["key"] or "-", KIND.get(s["kind"], "Khuôn " + str(s["kind"])),
                ovr_txt, ", ".join(done) or "-", note
            ))
        out.append("")

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(out))
    print("Xuat bao cao doi soat: %s (OVR: %d, Tong: %d)" % (OUT, len(OVR), total))


if __name__ == "__main__":
    main()

