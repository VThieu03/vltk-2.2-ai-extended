# Item descriptions. In the inventory the game shows the item's Description (ides), which the author
# left as a short label while the stats are in the shop tooltip (utub). This file fixes text for items
# still named / described in English, unaccented, or wrong (FIX), adds socket info for the old-style
# kham materials still usable (KHAM) and the Huyền tinh enhancement text (iid "I00W").
#
# The map's ORIGINAL 4-slot equipment system (Mũ/Áo/Vũ khí/Giày, named via tools/gameplay_items.py) is
# retired: it no longer drops (tools/gameplay.py DROP_FN), can't be picked up (gameplay_02_farm.j
# zzVL_OnAffixPickup removes it on pickup), isn't sold in any shop (gameplay.py legacy_gear_ids()), and
# its crafting ("Bí Phổ" at Tàng Kinh Các) no longer drops ingredients either. The only equipment system
# left in the game is the 10-slot KVCT one (ITV/ITS/ITW/ITHB item codes); its text is written by
# tools/kvequip.py, not here (this file skips those codes, see the "IT" check below). Because the old
# equipment is unreachable, this file no longer invents names/lore/stats/hero recommendations ("Tiến
# cử") for it — that generator was deleted (see git history before this commit if it's ever needed back).
#
# Run after gameplay.py (it also describes the phi phong items, which gameplay.py adds).
import os, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata

SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
NL = "\r\n"

# (name, tooltip) for items whose text is English, unaccented or a joke
FIX = {
    "pres": ("Thiên Hương Tửu", "Rượu quý trăm năm, chữa thương thế nặng và bồi bổ nội lực."),
    "belv": ("Bí Vân Y", "Áo giáp dệt từ tơ mỏng nhưng bền, tăng phòng thủ."),
    "bspd": ("Cẩm Tú Bào", "Áo giáp thêu từ lụa Giang Nam, tăng phòng thủ."),
    "cnob": ("Anh Hoa Y", "Áo giáp lụa tằm thơm hương hoa anh đào, tăng phòng thủ."),
    "ratc": ("Cẩm Đoạn Y", "Áo giáp gấm nhẹ như cánh bướm, tăng phòng thủ."),
    "texp": ("Kinh Nghiệm Phổ", "Dùng: nhận 250 điểm kinh nghiệm."),
    "kybl": ("Môn Phái Bí Kíp", "Bí kíp trấn phái, vật quan trọng của môn phái."),
    "I00K": ("Biến Dương Phù", "Dùng: biến kẻ địch xung quanh thành cừu trong thời gian ngắn."),
    "gemt": ("Ngọc Chống Tàng Hình", "Phát hiện mọi kẻ địch tàng hình ở gần."),
    "rhe3": ("Mát Xa", "Hồi phục sinh lực và nội lực."),
    "rma2": ("Hành Lạc", "Nâng sinh lực lên 100, nâng tất cả chỉ số lên 2."),
    "rre2": ("|c00ffff00Hộp Quà|r", "|c00ffcc00Vứt hộp quà ra mặt đất để nhận được 1 món quà ngẫu nhiên.|r"),
    "kygh": ("|c00ffff00Hộp Quà|r", "|c00ffcc00Vứt hộp quà ra mặt đất để nhận được 1 món quà ngẫu nhiên.|r"),
    "gold": ("|c00ffff00Tiền xu|r", "Có thể đổi lấy ngân lượng ở các cửa hàng."),
    "I00F": (None, "Tạo ảo ảnh, gây 50% sát thương của bản thân."),
    "I00G": (None, "Tăng mạnh tốc độ di chuyển trong thời gian ngắn."),
    "I00M": (
        "|c008080ffKim Nguyệt Đơn|r",
        "|c0087ceebDùng các dược liệu quý trải qua 49 ngày luyện trong lò tiên đơn mới có thể luyện thành.|r|n|nLập tức hồi phục 800 sinh lực.",
    ),
    "I06G": (
        "|c004eee94Sách Sinh Lực|r",
        "|c0087ceebNâng sinh lực lên 20 điểm mỗi khi dùng.|r|n|n|c00ffcc00Dùng được 10 lần.|r",
    ),
}

# kham attributes (gameplay_08_ui.j zzVL_KhamInit): old-style socket gems, still usable (fallback path
# of zzIT_LO_KHAM / key 44) alongside the new bảo thạch from tools/kvgem.py.
KHAM = {
    "I06M": "Hút sinh lực +3%",
    "I06L": "Hút nội lực +3%",
    "I06K": "Bạo kích +4%",
    "I06J": "Tốc đánh +8%",
    "I06W": "Sát thương +5%",
    "I06S": "Sát thương +6%",
    "I06Q": "Giảm sát thương nhận 4%",
    "I00S": "Giảm sát thương nhận 3%",
    "I017": "Sinh lực +400",
    "I00R": "Sinh lực +250",
    "I00P": "Sức mạnh +8",
    "I06P": "Thân pháp +8",
    "I06U": "Nội công +8",
}


def main():
    p = os.path.join(SRC, "war3map.w3t")
    w3t = objdata.ObjectFile.load(p)
    ver, tabs = w3t.ver, w3t.tables
    n = 0
    for ti, tab in enumerate(tabs):
        for old, new, sets in tab:
            iid = (old if ti == 0 else new).decode("latin1")
            mods = sets[0]
            if iid in ("phea", "pghe", "pman", "pgma", "pres"):  # potions: text by gameplay.py
                continue
            get = lambda k: next((m for m in mods if m[0] == k), None)

            def setv(k, text):
                m = get(k)
                if m is None:
                    mods.append([k, None, None, 3, text.encode("utf-8"), b"\0\0\0\0"])
                else:
                    m[3], m[4] = 3, text.encode("utf-8")

            if iid in FIX:
                nm, tip = FIX[iid]
                if nm:
                    setv(b"unam", nm)
                    setv(b"utip", nm)
                setv(b"utub", tip)
            name = get(b"unam")[4].decode("utf-8") if get(b"unam") else ""
            if (
                not name or iid.startswith("I0Z") or iid.startswith("IJ") or iid.startswith("IT")
            ):  # phi phong, 10-slot jewels: done by gameplay.py; ITV ITS ITW ITHB (KVCT equipment): text by kvequip.py
                continue
            tub = get(b"utub")[4].decode("utf-8") if get(b"utub") else ""
            if iid in KHAM and "[Khảm]" not in tub:
                tub = (tub + NL if tub else "") + "|cff80c0ff[Khảm] " + KHAM[iid] + " (mỗi trang bị 2 lỗ)|r"
                setv(b"utub", tub)
            if iid == "I00W":
                import config

                cost, rate, pity = config.GLASS_ENHANCE_COST, config.GLASS_SUCCESS_RATE, config.GLASS_PITY_REQUIRED
                lines = [
                    "|c008080ffCường hóa trang bị|r",
                    "Huyền tinh được cộng thẳng cho người hạ quái (hoặc nhặt vào hành trang), cộng dồn, không rơi từng viên.",
                    "Bấm nút + cạnh ô trang bị trong bảng Nhân Vật (I) để cường hóa +1, tối đa +10; mỗi bậc đổi icon, tên và chỉ số.",
                    "Huyền tinh cần cho mỗi bậc: " + ", ".join("+%d: %d" % (i + 1, c) for i, c in enumerate(cost)) + ".",
                ]
                if any(r < 100 for r in rate):
                    lines.append(
                        "Tỉ lệ thành công: " + ", ".join("+%d: %d%%" % (i + 1, r) for i, r in enumerate(rate)) + "."
                    )
                    lines.append(
                        "Thất bại không tụt cấp, mất huyền tinh và tích lũy bảo hiểm riêng từng món (số lần thất bại để chắc chắn thành công: "
                        + ", ".join("+%d: %d" % (i + 1, p_) for i, p_ in enumerate(pity))
                        + ")."
                    )
                else:
                    lines.append("Cường hóa luôn thành công, không tụt cấp.")
                tub = NL.join(lines)
                setv(b"unam", "|cffffff00Huyền tinh|r")
                setv(b"utip", "|cffffff00Huyền tinh|r")
                setv(b"utub", tub)
            parts = [tub] if tub else []
            if parts:
                setv(b"ides", (NL + NL).join(parts))
                n += 1
    data = w3t.to_bytes()
    w3t.save()
    import hashlib

    print('MD5 written:', hashlib.md5(data).hexdigest(), 'to', p)
    print("described items:", n)


if __name__ == "__main__":
    main()
