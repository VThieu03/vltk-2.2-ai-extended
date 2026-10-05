# Hero skills: proper Vietnamese names (the author typed most of them without accents), a line in every
# tooltip with the cooldown / mana of that level and whether the skill casts itself, and the table the
# auto-cast system (gameplay.j, zzVL_Auto*) reads: skills with a cooldown <= 15 s cast themselves while
# the hero fights, the ultimates (55-60 s) stay manual.
# Writes src\map\war3map.w3a and build\skills_table.j (included by gameplay.py). Run after convert_text.py.
import os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata

ROOT = r"D:\vltk-dev-clone"
SRC = os.path.join(ROOT, "src", "map")
TABLE = os.path.join(ROOT, "build", "skills_table.j")
AUTO_MAX_CD = 15.0

NAMES = {
    "Bac Minh Thân Công": "Bắc Minh Thần Công", "Bác Câp Nhi Phuc": "Bác Cập Nhi Phục",
    "Bách Doc Xuyên Tâm": "Bách Độc Xuyên Tâm", "Bât Dong Minh Vuong": "Bất Động Minh Vương",
    "Cuu Cung Phi Tinh": "Cửu Cung Phi Tinh", "Cuông Lôi Chân Dia": "Cuồng Lôi Chấn Địa",
    "Cuông Phong Sâu Diên": "Cuồng Phong Sậu Điện", "Da Câu Trân": "Đả Cẩu Trận",
    "Dat Ma Do Giang": "Đạt Ma Độ Giang", "Dich Cân Kinh": "Dịch Cân Kinh", "Doan Hôn Thích": "Đoạn Hồn Thích",
    "Doan Thi Chi Pháp": "Đoàn Thị Chỉ Pháp", "Doc Thu Cot": "Độc Thứ Cốt", "Don Chi Liêt Diêm": "Đơn Chỉ Liệt Diệm",
    "Giáng Long Chuong": "Giáng Long Chưởng", "Hoat Bát Luu Thu": "Hoạt Bát Lưu Thủ",
    "Hoành Tao Luc Hop": "Hoành Tảo Lục Hợp", "Hoành Tao Thiên Quân": "Hoành Tảo Thiên Quân",
    "Huyên Âm Tram": "Huyền Âm Trảm", "Huyêt Chiên Bát Phuong": "Huyết Chiến Bát Phương",
    "Hàng Long Bát Vu": "Hàng Long Bát Vũ", "Khí Hàn Ngao Tuyêt": "Khí Hàn Ngạo Tuyết",
    "Kim Cang Phuc Ma": "Kim Cang Phục Ma", "Lang Ba Di Bô": "Lăng Ba Vi Bộ", "Lich Ma Doat Hôn": "Lịch Ma Đoạt Hồn",
    "Liêt Hoa Tinh Thiên": "Liệt Hỏa Tình Thiên", "Loan Hoàn Kích": "Loạn Hoàn Kích",
    "Luu Tinh Can Nguyêt": "Lưu Tinh Cản Nguyệt", "Lôi Dong Cuu Thiên": "Lôi Động Cửu Thiên",
    "Lôi Kích Thuât": "Lôi Kích Thuật", "Ma Diêm Thât Sát": "Ma Diệm Thất Sát", "Ma Ha Vô Luong": "Ma Ha Vô Lượng",
    "Mông Diêp": "Mộng Điệp", "Ngu Doc Kì Kinh": "Ngũ Độc Kỳ Kinh", "Ngu Lôi Chính Pháp": "Ngũ Lôi Chính Pháp",
    "Nhan Kiem Hop Nhat": "Nhân Kiếm Hợp Nhất", "Nhiêp Hôn Loan Tâm": "Nhiếp Hồn Loạn Tâm",
    "Nhu Lai Thien Diep": "Như Lai Thiên Điệp", "Nhât Chi Càn Khôn": "Nhất Chỉ Càn Khôn",
    "Phong Hoa Tuyêt Nguyêt": "Phong Hoa Tuyết Nguyệt", "Phong Quyên Tàn Tuyêt": "Phong Quyển Tàn Tuyết",
    "Phá Thiên Tram": "Phá Thiên Trảm", "Phât Pháp Vô Biên": "Phật Pháp Vô Biên",
    "Suong Ngao Côn Luân": "Sương Ngạo Côn Lôn", "Tam Hoàn Thao Nguyêt": "Tam Hoàn Thao Nguyệt",
    "Thiên Dia Vô Cuc": "Thiên Địa Vô Cực", "Thiên Ngoai Luu Tinh": "Thiên Ngoại Lưu Tinh",
    "Thiên Thanh Dia Troc": "Thiên Thanh Địa Trọc", "Thiên Vuong Chiên Ý": "Thiên Vương Chiến Ý",
    "Thái Cuc Thân Công": "Thái Cực Thần Công", "Thât Tinh Trân": "Thất Tinh Trận",
    "Thâu Thiên Hoan Nhât": "Thâu Thiên Hoán Nhật", "Thôi Song Vong Nguyêt": "Thôi Song Vọng Nguyệt",
    "Tram Long Quyêt": "Trảm Long Quyết", "Truy Tinh Truc Nguyêt": "Truy Tinh Trục Nguyệt",
    "Tuyêt Anh": "Tuyết Ảnh", "Ty Tuong Dong Quy": "Tứ Tượng Đồng Quy", "Vu Da Lê Hoa": "Vũ Đả Lê Hoa",
    "Vô Hình Doc": "Vô Hình Độc", "Vô Ngã Vô Kiêm": "Vô Ngã Vô Kiếm", "Vô Tuong Tram": "Vô Tướng Trảm",
    "Vô Tâm Tram": "Vô Tâm Trảm", "Ám Khí Duong Môn": "Ám Khí Đường Môn", "Âm Phong Thuc Côt": "Âm Phong Thực Cốt",
}
# base ability -> (order string, target: 0 none, 1 unit, 2 point)
ORDERS = {
    "AHtb": ("thunderbolt", 1), "Absk": ("berserk", 0), "Atau": ("taunt", 0), "ANcl": ("channel", 2),
    "AUcs": ("carrionswarm", 2), "ACbf": ("breathoffire", 2), "AUfn": ("frostnova", 1), "Acri": ("cripple", 1),
    "ANbr": ("battleroar", 0), "Auhf": ("unholyfrenzy", 1), "ACcl": ("chainlightning", 1),
    "AOcl": ("chainlightning", 1), "ANab": ("acidbomb", 1), "ANcs": ("clusterrockets", 2),
    "ANht": ("howlofterror", 0), "ANso": ("soulburn", 1), "AEsh": ("shadowstrike", 1),
}
# standard (unmodified) abilities in the heroes' lists: base = itself
NL = "|n"


def f32(b):
    return struct.unpack("<f", b)[0]


def main():
    ver, u = objdata.parse(open(os.path.join(SRC, "war3map.w3u"), "rb").read(), ".w3u")
    heroes = {}
    for tab in u:
        for o, n, sets in tab:
            d = {m[0]: m[4] for m in sets[0]}
            if n[:1] in (b"H", b"E") and n != b"H00R" and b"uhab" in d:
                heroes[n.decode()] = d[b"uhab"].decode().split(",")
    p = os.path.join(SRC, "war3map.w3a")
    ver, a = objdata.parse(open(p, "rb").read(), ".w3a")
    abil = {n.decode(): (o.decode(), sets[0]) for o, n, sets in a[1]}

    def base(x):
        return abil[x][0] if x in abil else x

    def cooldowns(x):
        if x not in abil:
            return {}
        return {m[1]: f32(m[4]) for m in abil[x][1] if m[0] == b"acdn"}

    def manas(x):
        if x not in abil:
            return {}
        return {m[1]: struct.unpack("<i", m[4])[0] for m in abil[x][1] if m[0] == b"amcs"}

    # auto-cast candidates per hero; a hero with two skills of the same order (two "channel" skills)
    # cannot pick one by order, so its skills sharing an order are left manual
    auto = {}
    ult = {}
    rows = []
    for h, lst in heroes.items():
        orders = [ORDERS.get(base(x), (None,))[0] for x in lst]
        k = 0
        u = 0
        for x, order in zip(lst, orders):
            if not order or orders.count(order) > 1:
                continue
            cd1 = cooldowns(x).get(1)
            if cd1 is not None and cd1 > AUTO_MAX_CD:
                # ultimate: manual for players, the computer AI casts it (hero key 20..)
                ult[x] = True
                rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (h, 20 + u, x))
                u += 1
                continue
            auto[x] = True
            rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (h, 10 + k, x))
            k += 1
    for x in sorted(set(auto) | set(ult)):
        order, kind = ORDERS[base(x)]
        rows.append("call SaveInteger(zzVL_ht,'%s',2,OrderId(\"%s\"))" % (x, order))
        rows.append("call SaveInteger(zzVL_ht,'%s',3,%d)" % (x, kind))
    os.makedirs(os.path.dirname(TABLE), exist_ok=True)
    open(TABLE, "w", encoding="utf-8").write("\n".join(rows) + "\n")

    # tooltips
    used = {x for lst in heroes.values() for x in lst}
    named = 0
    for x in used:
        if x not in abil:
            continue
        mods = abil[x][1]
        for m in mods:
            if m[3] == 3:
                t = m[4].decode("utf-8")
                for plain, good in NAMES.items():
                    if plain in t:
                        t = t.replace(plain, good)
                        named += 1
                m[4] = t.encode("utf-8")
        cds, mps = cooldowns(x), manas(x)
        active = base(x) in ORDERS
        for m in mods:
            if m[0] not in (b"aub1", b"arut") or m[3] != 3:
                continue
            t = m[4].decode("utf-8")
            if "Tự thi triển" in t or "Bấm tay" in t or "bị động" in t:
                continue
            lv = m[1] if m[0] == b"aub1" else 1
            info = []
            if cds.get(lv):
                info.append("|cffffcc00Hồi chiêu:|r %g giây" % cds[lv])
            if mps.get(lv):
                info.append("|cff6aa0ffNội lực:|r %d" % mps[lv])
            if x in auto:
                tag = "|cff00ff00Tự thi triển khi giao chiến|r (gõ -auto để bật/tắt)"
            elif active:
                tag = "|cffff8000Bấm tay để thi triển|r (tuyệt chiêu / chiêu hồi lâu)"
            else:
                tag = "|cff9a9a9aNội công bị động, luôn có hiệu lực|r"
            add = (NL + "   ".join(info) if info else "") + NL + tag
            m[4] = (t + NL + add).encode("utf-8")
    open(p, "wb").write(objdata.write(ver, a, ".w3a"))
    print("heroes:", len(heroes), "auto-cast skills:", len(auto), "AI ultimates:", len(ult), "name fixes:", named)
    for h, lst in sorted(heroes.items()):
        print(" ", h, " ".join(("*" if x in auto else "") + x for x in lst))


if __name__ == "__main__":
    main()
