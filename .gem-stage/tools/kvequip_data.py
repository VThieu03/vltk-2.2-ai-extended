# Dữ liệu hệ trang bị KVCT (nhóm DATA): 10 ô, 11 loại vũ khí, bảng phái <-> loại vũ khí, icon theo bậc, chỉ số nền.
# Dùng bởi tools/kvequip.py (tạo vật phẩm, chép icon, ghi bảng JASS). Tác giả icon / tên trang bị KVCT: Silva.Fox.
# Mọi số liệu "chỉ số nền" ở đây KHỚP với đoạn chữ trong mô tả; JASS (gameplay_09_equip.j) đọc lại từ bảng hashtable
# do kvequip.py ghi, nên chỉ cần sửa ở đây.
import os, sys

sys.path.insert(0, os.path.dirname(__file__))
from kvequip_names import ARMOR_NAMES, WEAPON_NAMES

# ---------------------------------------------------------------------------------------------------------------
# 1. Mười ô (thứ tự KVCT, bảng KU2): mã vật phẩm, tên, "loại" cũ của map (khóa 0 = loại*10+bậc; loại 1 mũ, 2 áo, 3 vũ khí,
#    4 giày, 5 yêu đái, 6 hộ uyển, 7 hạng liên, 8 giới chỉ, 9 ngọc bội, 10 hộ thân phù), mẫu tên icon KVCT.
# ---------------------------------------------------------------------------------------------------------------
# ô: (mã, tên ô, loại cũ, mẫu icon KVCT với {k} = cấp kf)
SLOTS = {
    1: ("ITS1", "Nón", 1, "Icon_PC_non1_1_{k}"),
    2: ("ITS2", "Áo", 2, "Icon_PC_ao1_1_{k}"),
    3: ("ITS3", "Yêu Đái", 5, "Icon_PC_lung1_1_{k}"),
    4: ("ITS4", "Hộ Uyển", 6, "Icon_PC_tay1_1_{k}"),
    5: ("ITS5", "Hài", 4, "Icon_PC_giay1_1_{k}"),
    6: ("ITV", "Vũ Khí", 3, None),  # vũ khí: ITV0..ITVA / ITW0..ITWA theo loại
    7: ("ITS7", "Hạng Liên", 7, "Icon_TS_lien1_{k}"),
    8: ("ITS8", "Giới Chỉ", 8, "Icon_TS_nhan1_{k}"),
    9: ("ITS9", "Ngọc Bội", 9, "Icon_TS_boi1_{k}"),
    10: ("ITSA", "Hộ Thân Phù", 10, "Icon_TS_phu1_{k}"),
}
ARMOR_SLOTS = [1, 2, 3, 4, 5, 7, 8, 9, 10]

# 11 loại vũ khí (chỉ số 0..10 = thứ tự ITV0..ITVA / ITW0..ITWA): tên, mẫu icon KVCT ({k} = cấp kf)
WEAPONS = [
    ("Kiếm", "Icon_VK_kiem{k}"),
    ("Đao", "icon_vk_dao{k}"),
    ("Thương", "icon_vk_thuong{k}"),
    ("Chùy", "icon_vk_chuy{k}"),
    ("Triền Thủ", "icon_vk_trienthu{k}"),
    ("Côn", "icon_vk_con{k}"),
    ("Tụ Tiễn", "icon_vk_tutien{k}"),
    ("Phi Đao", "icon_vk_phidao{k}"),
    ("Trường Đao", "icon_vk_truongdao{k}"),
    ("Đại Đao", "icon_vk_daidao{k}"),
    ("Phi Tiêu", "icon_vk_phitieu{k}"),
]
WCODE = "0123456789A"


def weapon_code(w, tanlang=False):
    return ("ITW" if tanlang else "ITV") + WCODE[w]


def slot_code(s):
    return SLOTS[s][0]


# ---------------------------------------------------------------------------------------------------------------
# 2. Bảng phái <-> loại vũ khí (TRANGBI_SPEC mục 3, đọc từ code KVCT). Mỗi phái chỉ mặc ĐÚNG một loại.
# ---------------------------------------------------------------------------------------------------------------
WEAPON_CLASSES = {
    0: "MGK NMK TYK DTK TDK CLK VDQ VDK HSQ HSK CMK",  # kiếm
    1: "TVD TLD TYD TND CLD NDD",  # đao
    2: "TVT TNK",  # thương
    3: "TVC MGC",  # chùy
    4: "TLQ NDC NMC DTC CBC TDC",  # triền thủ
    5: "TLB CBB",  # côn
    6: "DMTT CMC DMPT",  # tụ tiễn
    7: "DMPD",  # phi đao
    8: "TVD TLD TYD TND CLD NDD",  # trường đao: các phái đao (quy định người dùng)
    9: "TVD TLD TYD TND CLD NDD",  # đại đao: các phái đao
    10: "DMPT",  # phi tiêu: Đường Môn Phi Tiêu (cùng tụ tiễn)
}
# phái -> các loại vũ khí mặc được (loại đầu tiên = loại chính, dùng làm vũ khí khởi đầu)
CLASS_WEAPON = {}
for _w, _cs in sorted(WEAPON_CLASSES.items()):
    for _c in _cs.split():
        CLASS_WEAPON.setdefault(_c, []).append(_w)


def hero_weapon():
    """mã tướng (E000, H014...) -> danh sách loại vũ khí (loại chính đầu tiên), theo kskill_data.CLASS"""
    import kskill_data

    out = {}
    for hero, cls in kskill_data.CLASS.items():
        assert cls in CLASS_WEAPON, "phái %s chưa có loại vũ khí" % cls
        out[hero] = CLASS_WEAPON[cls]
    return out


def class_names(w):
    """tên các phái dùng loại vũ khí w (cho dòng 'Tiến cử' / 'Dành cho')"""
    import kskill_data

    return [kskill_data.HERO[h][1] for h, c in kskill_data.CLASS.items() if w in CLASS_WEAPON[c]]


# ---------------------------------------------------------------------------------------------------------------
# 3. Bậc cường hóa t = 0..10 (và 11 = vũ khí Tần Lăng): icon theo "cấp kf" của KVCT.
#    KVCT: kf 1..7 = đồ cấp 1..200, kf 8.. = trùng sinh 1.. (bảng K5b: kf 8..11 = ts 1..4, 12/13 = ts 5, 14 = ts 6,
#    15/16 = ts 7, 17 = ts 8, 18 = ts 9, 19 = ts 10, 20 = ts 11). Đồ phòng cụ / trang sức của KVCT chỉ có icon tới kf 16.
#    Bậc 0 (chưa cường hóa) dùng icon kf 7 (đồ cấp 200, ngay trước trùng sinh 1).
# ---------------------------------------------------------------------------------------------------------------
# Bộ icon + tên của KVCT theo "cấp kf": kf1 xám (mặc định), kf2 xanh lá, kf3 xanh dương, kf4 tím, kf5-10 cam, kf11+ vàng. Cường hóa +0 ... +10
# đi dần từ kf1 (xám) lên bộ trùng sinh 6 (kf 14 vũ khí / kf 13 giáp và trang sức, bộ vốn dùng ở +6) làm bậc +10; bậc 11 = Tần Lăng (kf20).
# Tên trang bị đổi theo kf của bậc (tên KVCT). Muốn đổi bộ nào ở bậc nào chỉ cần sửa hai danh sách này (chỉ số = bậc 0..11).
KF_WEAPON = [1, 2, 3, 4, 5, 7, 9, 11, 12, 13, 14, 20]  # xám, xanh lá, xanh dương, tím, cam, cam, cam, vàng x4, Tần Lăng
KF_ARMOR = [1, 2, 3, 4, 5, 6, 8, 10, 11, 12, 13, 13]  # xám, xanh lá, xanh dương, tím, cam x4, vàng x3 (+10 = bộ ts6 cũ)
MAX_TIER = 10
TANLANG_TIER = 11


def icon_override(slot, w):
    """config.EQUIP_ICONS: (mẫu tên icon KVCT có {k}, [chỉ số k cho bậc 0..11]) của ô slot (vũ khí: khóa 'w<loại>'), hoặc None"""
    import config

    return getattr(config, "EQUIP_ICONS", {}).get(("w%d" % w) if slot == 6 else slot)


def kf_default(slot, tier):
    """cấp kf KVCT mặc định của bậc (dùng cho TÊN và màu tên, không bị ảnh hưởng bởi EQUIP_ICONS)"""
    return (KF_WEAPON if slot == 6 else KF_ARMOR)[tier]


def kf_of(slot, tier, w=0):
    ov = icon_override(slot, w)
    if ov:
        return ov[1][tier]
    return (KF_WEAPON if slot == 6 else KF_ARMOR)[tier]


def icon_source(slot, w, tier):
    """tên file icon KVCT (không kèm thư mục) của ô slot (loại vũ khí w nếu là vũ khí) ở bậc tier"""
    kf = kf_of(slot, tier, w)
    ov = icon_override(slot, w)
    pat = ov[0] if ov else (WEAPONS[w][1] if slot == 6 else SLOTS[slot][3])
    return pat.format(k=kf) + ".blp"


def icon_dest(slot, w, tier):
    """tên file trong map (src\\map\\war3mapImported\\kvq\\)"""
    kf = kf_of(slot, tier, w)
    return ("w%d_%d.blp" % (w, kf)) if slot == 6 else ("s%d_%d.blp" % (slot, kf))


KJO = [" Vô Hạ", " Phồn Hoa", " Phong Vân", " Kình Tiếu", " Thiên Địa", " Vô Cực"]  # KVCT Kjo (hậu tố Thần Sa)


def tier_name(slot, w, tier):
    """tên trang bị ở bậc tier, theo tên KVCT của cấp kf (vũ khí kf > 14: Thần Sa / Hạo Thiên, Tần Lăng cho ts 11)"""
    kf = kf_default(slot, tier)
    if slot != 6:
        return ARMOR_NAMES[slot][kf - 1]
    names = WEAPON_NAMES[w]
    top = names[-1]
    if kf <= len(names):
        return names[kf - 1]
    if tier == TANLANG_TIER:
        return "Tần Lăng " + top
    if kf <= 14:  # loại chỉ có 13 tên (thương)
        return top
    if kf == 19:
        return "Hạo Thiên " + top
    return "Thần Sa " + top + KJO[max(0, min(kf - 16, 5))]


def tier_color(slot, tier):
    """màu theo bậc (giống K_L của KVCT: cam tới kf 10, vàng từ kf 11; Tần Lăng cam đỏ)"""
    if slot == 6 and tier == TANLANG_TIER:
        return "|cffff8000"
    return "|cffffa500" if kf_default(slot, tier) <= 10 else "|cffffff00"


# ---------------------------------------------------------------------------------------------------------------
# 4. Chỉ số nền (100%) của mỗi ô: danh sách (mã chỉ số, giá trị). Mã chỉ số (khớp zzEQ_AddOne / zzEQ_StatFmt trong JASS):
#    1 hút sinh lực %, 2 hút nội lực %, 3 bạo kích %, 4 tốc đánh %, 5 sát thương %, 6 giảm sát thương nhận %,
#    7 sinh lực, 8 sức mạnh, 9 thân pháp, 10 nội công, 11..15 kháng vật lý / độc / thủy / hỏa / lôi %, 16 tốc độ xuất chiêu %,
#    17 STVL nội công, 18 STVL ngoại công, 19 điểm đánh trúng, 20 né tránh, 21 tốc chạy, 23 sát thương gốc, 24 giáp.
#    Chỉ số theo bậc t = nền * hệ số %, hệ số = 100 + 30 * t (t <= 10, tức 400% ở +10), Tần Lăng (t = 11) = 500%.
# ---------------------------------------------------------------------------------------------------------------
BASE = {
    1: [(8, 10), (9, 10), (10, 10)],
    2: [(24, 3), (6, 2)],
    3: [(7, 160), (12, 4), (13, 4)],
    4: [(4, 4), (14, 4), (15, 4)],
    5: [(7, 300), (21, 5)],
    6: [(23, 30), (5, 6)],
    7: [(3, 2), (17, 20), (16, 2)],
    8: [(19, 40), (1, 1), (5, 2)],
    9: [(2, 1), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)],
    10: [(7, 200), (6, 1)],
}
STAT_NAME = {
    1: ("Hút sinh lực", "%"),
    2: ("Hút nội lực", "%"),
    3: ("Bạo kích", "%"),
    4: ("Tốc đánh", "%"),
    5: ("Sát thương", "%"),
    6: ("Giảm sát thương nhận", "%"),
    7: ("Sinh lực", ""),
    8: ("Sức mạnh", ""),
    9: ("Thân pháp", ""),
    10: ("Nội công", ""),
    11: ("Kháng vật lý", "%"),
    12: ("Kháng độc", "%"),
    13: ("Kháng thủy", "%"),
    14: ("Kháng hỏa", "%"),
    15: ("Kháng lôi", "%"),
    16: ("Tốc độ xuất chiêu", "%"),
    17: ("STVL nội công", ""),
    18: ("STVL ngoại công", ""),
    19: ("Điểm đánh trúng", ""),
    20: ("Né tránh", ""),
    21: ("Tốc chạy", ""),
    23: ("Sát thương gốc", ""),
    24: ("Giáp", ""),
}
MAX_STATS = 6


def pct(t):
    """hệ số chỉ số (%) theo bậc: bản sao của zzEQ_Pct trong JASS"""
    return 500 if t >= TANLANG_TIER else 100 + 30 * max(t, 0)


def stat_line(slot, p=100):
    parts = []
    for code, v in BASE[slot]:
        nm, unit = STAT_NAME[code]
        parts.append("+%d%s %s" % (v * p // 100, unit, nm))
    return ", ".join(parts)


def weapon_element(w):
    """hệ 1..5 (Kim Mộc Thổ Thủy Hỏa theo gameplay.ELEMENTS) của loại vũ khí w: công thức weapon_element() của gameplay.py
    áp lên mã ITV; ITW cùng hệ với ITV cùng loại (mua Tần Lăng không đổi hệ)"""
    return sum(weapon_code(w).encode("latin1")) % 5 + 1


# vật phẩm cơ bản: loại * 10 + bậc dùng cho khóa 0 (bậc 3 = "bộ trang bị" cấp 3, Tần Lăng bậc 5)
KEY0_TIER = 3
KEY0_TIER_TANLANG = 5
SELL_GOLD = 400  # giá bán (khóa 41) của ITV / ITS
GOLD_COST = 2000  # igol của ITV / ITS (không bán trong tiệm, chỉ để có giá)

# Tần Lăng Hòa Thị Bích (vật phẩm nguyên liệu, boss Tần Thủy Hoàng rơi): vatpham_41 = "Hòa Thị Bích" của KVCT
HOATHIBICH_ICON = "vatpham_41.blp"
