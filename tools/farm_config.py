"""Cau hinh bai farm va diem den Xa Phu (toa do the gioi Warcraft III).

Sua entry de doi diem dich chuyen, camps de doi cac diem sinh quai.
Sau khi sua, chay: python tools/pipeline.py --no-ui
Khong sua build/zones.txt: file do duoc tao lai moi lan build.
"""

# Thu tu la thu tu hien trong menu Xa Phu. level_max la moc goi y;
# unit trong tung bai hien dung cap level_min (Warcraft III khong doi duoc cap
# unit thuong sau khi tao). Doi cap that can tao them unit type trong kvcreep.py.
FARM_ZONES = [
    {"name": "Thanh Hạc Động(Bắc)", "level_min": 1, "level_max": 19, "teleport": True,
     "entry": (9632, -2848), "camps": [(9632, -3648), (9152, -4608), (9152, -768), (9792, -448)]},
    {"name": "Dược Vương Động(Bắc)", "level_min": 20, "level_max": 39, "teleport": True,
     "entry": (10688, -2368), "camps": [(11328, -1728), (11168, -3328), (10688, -768), (10368, -3648)]},
    {"name": "Đào hoa đảo (Trên)", "level_min": 40, "level_max": 59, "teleport": True,
     "entry": (11904, -2368), "camps": [(12864, -3168), (12384, -608), (11904, -1568), (12704, -2368)]},
    {"name": "Thanh Hạc Động(Nam)", "level_min": 1, "level_max": 19, "teleport": True,
     "entry": (9632, 4320), "camps": [(9312, 6720), (9632, 2560), (9792, 6240), (9472, 3520)]},
    {"name": "Dược Vương Động(Nam)", "level_min": 20, "level_max": 39, "teleport": True,
     "entry": (10688, 4800), "camps": [(10528, 5760), (10688, 3680), (11328, 6560), (11328, 5120)]},
    {"name": "Đào hoa đảo (Dưới)", "level_min": 40, "level_max": 59, "teleport": True,
     "entry": (11904, 4800), "camps": [(12704, 3360), (12224, 5920), (12704, 5280), (11904, 6560)]},
    {"name": "Thanh Hạc Động(Bắc)", "level_min": 60, "level_max": 79, "teleport": True,
     "entry": (20224, -2208), "camps": [(21824, -3008), (23424, -1568), (23584, -3648), (20544, -3008)]},
    {"name": "Thanh Hạc Động(Nam)", "level_min": 60, "level_max": 79, "teleport": True,
     "entry": (20224, 4960), "camps": [(22144, 6560), (23264, 4960), (21184, 6080), (22304, 4480)]},
    {"name": "Thiên Kiếm Thành(Sơ)", "level_min": 80, "level_max": 99, "teleport": True,
     "entry": (25600, -2208), "camps": [(25600, -3968), (27200, -2528), (28800, -1088), (25760, -448)]},
    {"name": "Thiên Kiếm Thành(Cao)", "level_min": 100, "level_max": 200, "teleport": True,
     "entry": (25600, 4960), "camps": [(28960, 4960), (25920, 5600), (26080, 3520), (27680, 4960)]},
]


def level_range(level):
    matches = {(zone["level_min"], zone["level_max"])
               for zone in FARM_ZONES if zone["level_min"] == level}
    if len(matches) != 1:
        raise ValueError("Bai farm cap %d can dung mot dai cap" % level)
    return next(iter(matches))
