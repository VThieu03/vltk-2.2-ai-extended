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

def item_id(kind, tier):
    return "IG%d%d" % (kind, tier)

def icon_name(kind, tier):
    return "baothach%d_%d.blp" % (kind, tier)

def amount(kind, tier):
    stat, _, base = KINDS[kind]
    return stat, base * TIER_SCALE[tier - 1]
