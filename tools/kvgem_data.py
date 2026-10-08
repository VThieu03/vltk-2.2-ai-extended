"""Balance and presentation data for the KVCT gem system."""

# Six gem families map to the six common offensive/defensive attributes used by
# KVCT's baothach icons. Values are tuned for two sockets and +10 equipment.
KINDS = {
    1: (3, "Bạo Kích", 1),
    2: (4, "Tốc Đánh", 2),
    3: (5, "Sát Thương", 1),
    4: (7, "Sinh Lực", 120),
    5: (6, "Giảm Sát Thương Nhận", 1),
    6: (16, "Tốc Độ Xuất Chiêu", 1),
}

TIER_SCALE = [1, 2, 3, 5, 8, 12, 18, 27, 40]
TIER_NAMES = ["Sơ", "Thanh", "Lam", "Tím", "Cam", "Đỏ", "Trùng Sinh", "Thần", "Chí Tôn"]

# Kỳ Trân Các attribute stones: grade 1=min, 2=midpoint, 3=max of the equipment affix range.
STAT_STONES = {
    1: ("Hút sinh lực", "%", 2, 6), 2: ("Hút nội lực", "%", 2, 5),
    3: ("Bạo kích", "%", 3, 8), 4: ("Tốc đánh", "%", 5, 15),
    5: ("Sát thương", "%", 10, 50), 6: ("Giảm sát thương nhận", "%", 10, 50),
    7: ("Sinh lực", "", 10, 50), 8: ("Sức mạnh", "", 10, 50),
    9: ("Thân pháp", "", 10, 50), 10: ("Nội công", "", 10, 50),
    11: ("Kháng vật lý", "%", 5, 20), 12: ("Kháng độc", "%", 5, 20),
    13: ("Kháng thủy", "%", 5, 20), 14: ("Kháng hỏa", "%", 5, 20),
    15: ("Kháng lôi", "%", 5, 20), 16: ("Tốc độ xuất chiêu", "%", 5, 15),
    17: ("Sát thương vật lý nội công", "", 10, 50),
    18: ("Sát thương vật lý ngoại công", "", 10, 50),
    19: ("Điểm đánh trúng", "", 50, 200), 20: ("Né tránh", "", 50, 200),
    21: ("Tốc độ di chuyển", "", 10, 30), 22: ("Tất cả kỹ năng", " cấp", 1, 1),
}

STAT_STONE_GRADE_NAMES = {1: "Tốt", 2: "Trung", 3: "Cao"}

def stat_stone_id(stat, grade):
    return "K%02d%d" % (stat, grade)

def stat_stone_amount(stat, grade):
    _, _, low, high = STAT_STONES[stat]
    if grade == 1:
        return low
    if grade == 2:
        return (low + high) // 2
    return high

def item_id(kind, tier):
    return "IG%d%d" % (kind, tier)

def icon_name(kind, tier):
    return "baothach%d_%d.blp" % (kind, tier)

def amount(kind, tier):
    stat, _, base = KINDS[kind]
    return stat, base * TIER_SCALE[tier - 1]
