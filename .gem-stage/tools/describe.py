# Item descriptions. In the inventory the game shows the item's Description (ides), which the author
# left as a short label ("áo giáp", "Dược.") while the stats are in the shop tooltip (utub). Every item
# gets: its stats + a short line of flavour (written in the style of Vo Lam Truyen Ky online when the map
# has none) + for materials, what they craft (from the author's recipe list in war3map.wts).
# Also gives Vietnamese text to the few items still named / described in English or without accents.
# Run after gameplay.py (it also describes the phi phong items, which gameplay.py adds).
import os, re, sys, unicodedata

sys.path.insert(0, os.path.dirname(__file__))
import objdata
from gameplay_items import plain, SLOTS

SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
NL = "\r\n"
GREY = "|cff9a9a9a"

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

# flavour by family (plain lowercase name without +n / colour) then by slot
LORE = {
    "mat van sam": "Áo vải mây nhẹ, thứ giáp đầu tiên của kẻ mới nhập giang hồ.",
    "hoan hoa thuong": "Áo dài thêu hoa, được các đệ tử trẻ ưa chuộng.",
    "cam anh thuong": "Áo gấm ánh kim, đường may chắc chắn chịu được đao kiếm.",
    "cam van sam": "Áo gấm thêu mây, thợ may Lâm An mất ba tháng mới xong một chiếc.",
    "kim ngoc tru sam": "Áo khảm ngọc, giúp tĩnh tâm vận khí.",
    "nhuyen kim y": "Áo đan từ sợi kim loại mềm, thân pháp vẫn nhẹ nhàng.",
    "thanh suong y": "Áo màu sương xanh, che chắn tốt trước ám khí tầm xa.",
    "hao hiep y": "Áo của hiệp khách, khí huyết lưu thông không ngừng.",
    "xuan noan thuong": "Áo ấm như gió xuân, kẻ địch chạm vào sẽ bị phản thương.",
    "xich long bao": "Áo thêu rồng lửa, đốt cháy kẻ địch xung quanh.",
    "tham lang y": "Áo da sói tham lang, giúp né tránh nhanh nhẹn.",
    "ha vinh trang": "Trang phục mùa hạ, làm chậm bước chân kẻ địch.",
    "thien phong sam": "Áo gió trời, tăng sức công phá của chiêu thức.",
    "than sach kim giap": "Kim giáp hoàng kim, tương truyền do binh bộ triều đình rèn đúc.",
    "tay thi cam sam": "Cẩm sam của Tây Thi, đẹp mà bền như ngọc.",
    "hoang ho y": "Áo da hổ vàng, vật của bậc vương giả sơn lâm.",
    "tay vuong nu giap": "Giáp của Tây Vương Mẫu, gia tăng mọi chỉ số.",
    "ba vuong giap": "Giáp của Bá Vương, phản đòn mạnh mẽ.",
    "hoang long kim giap": "Kim giáp rồng vàng, phòng ngự bậc nhất võ lâm.",
    "sa nhung mao": "Mũ nhung cát, nhẹ và ấm.",
    "quyen ty mao": "Mũ tơ quyên, giúp hồi phục nội lực.",
    "ho nha mao": "Mũ nanh hổ, tăng sức mạnh.",
    "nguyen linh quan": "Mũ nguyên linh, hồi phục sinh lực đều đặn.",
    "thien khu mao": "Mũ thiên khu, mở rộng tầm nhìn.",
    "la han mao": "Mũ La Hán của Thiếu Lâm.",
    "thanh linh can": "Khăn thánh linh, phản đòn cận chiến.",
    "lang nha mao": "Mũ nanh sói, khí thế dũng mãnh.",
    "that tinh quan": "Mũ thất tinh, ứng với bảy vì sao Bắc Đẩu.",
    "an lang khoi": "Mũ trụ của Rex hiên nhân, chỉ rơi khi hạ được hắn.",
    "phong van quan": "Một món trong bộ Phong Vân.",
    "phong van hai": "Một món trong bộ Phong Vân.",
    "pha quan hai": "Giày phá quân, bước đi như gió.",
    "nghe van ngoa": "Giày mây nghê, nhẹ như không.",
    "lang bi hai": "Giày da sói, bền bỉ đường xa.",
    "thanh thien ly": "Giày thiên lý, ngày đi ngàn dặm.",
    "giao long hai": "Giày da giao long, nhanh nhẹn né tránh.",
    "thanh phong kiem": "Kiếm gió mát, binh khí nhập môn của kiếm khách.",
    "long lan dao": "Đao vảy rồng, nặng mà sắc.",
    "tu kim dao": "Đao tử kim, lưỡi ánh tím.",
    "kim linh kiem": "Kiếm kim linh, tiếng ngân như chuông.",
    "nguyet nha san": "Sản trăng khuyết, binh khí của nhà sư.",
    "kim dinh lang nha soc": "Sóc nanh sói đỉnh vàng, binh khí hạng nặng.",
    "cuu long phuong tien san": "Thiền trượng chín rồng.",
    "tran duyen": "Binh khí tục duyên.",
    "thuy mac phien": "Quạt thủy mặc, nét mực như mây.",
    "nga mao phien": "Quạt lông ngỗng của văn nhân.",
    "thanh tam phien": "Quạt thanh tâm, giữ tâm như nước.",
    "thien muc hoan": "Vòng thiên mục, ám khí phóng ra không thấy dấu.",
    "xich long": "Binh khí Xích Long, lửa rồng đỏ rực.",
    "kim xa": "Binh khí Kim Xà, độc như rắn vàng.",
    "tieu dao": "Binh khí Tiêu Dao, ung dung tự tại.",
    "nhat thuc": "Binh khí Nhật Thực, che lấp ánh mặt trời.",
    "chan thien phu": "Rìu chấn thiên, một nhát rung chuyển trời đất.",
    "phach phong": "Đao bổ gió, vật hoàng kim hiếm có.",
    "lang tinh thiep y kiem": "Kiếm tình ý, đôi uyên ương trong kiếm phổ.",
    "khoa khuc kiem": "Kiếm khoa khúc, uốn lượn như con chữ.",
    "am duong vo cuc song dao": "Song đao âm dương vô cực.",
    "phong bai ba tieu": "Quạt lá chuối phong bài, phẩy một cái nổi cuồng phong.",
    "long phung than dao": "Thần đao long phụng.",
    "phong van song dao": "Một món trong bộ Phong Vân.",
    "luc bao thach": "Ngọc xanh lục kết tinh linh khí núi rừng.",
    "o long bao thach": "Ngọc đen tuyền, tương truyền lấy từ hang Ô Long.",
    "lam bao thach": "Ngọc xanh lam trong như nước biển Đông.",
    "hong anh bao thach": "Ngọc đỏ tươi, nguyên liệu không thể thiếu của binh khí hoàng kim.",
    "ngoc luc bao": "Lục bảo thượng phẩm.",
    "bach bao thach": "Ngọc trắng tinh khiết.",
    "thien nien co vat": "Cổ vật ngàn năm, ẩn chứa linh khí xưa.",
    "co nguyet bao thach": "Ngọc mang ánh trăng xưa.",
    "kim cuong": "Đá cứng nhất thế gian.",
    "long nguyen": "Nguyên khí của rồng, cực kỳ hiếm.",
    "sa nhung": "Nhung cát mềm mịn, dùng để may y phục quý.",
    "bo de moc": "Gỗ cây Bồ Đề, mang Phật tính.",
    "nu oa tinh thach": "Đá Nữ Oa vá trời còn sót lại.",
    "bi pho": "Công thức thần bí ghi cách chế tạo binh khí, giáp trụ hoàng kim.",
    "thuy tinh": "Rơi khi đánh quái và cao thủ, nên giữ lại để nâng cấp đồ.",
    "tien xu": "Bán lại cho cửa hàng để lấy ngân lượng.",
}
SLOT_LORE = {
    1: "Mũ hộ thân của người giang hồ.",
    2: "Giáp trụ hộ thân.",
    3: "Binh khí giang hồ.",
    4: "Giày đi đường của hiệp khách.",
}
GOLD_LINE = "Trang bị hoàng kim, cả giang hồ ít người sở hữu."


def family(name):
    p = re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", name)
    p = plain(re.sub(r"\+\s*\d", "", p)).strip()
    p = re.sub(r"\s+", " ", p)
    p = p.replace("kiem", "kiem").replace("dao", "dao")
    for k in sorted(LORE, key=len, reverse=True):
        if p == k or p.startswith(k + " ") or p.startswith(k):
            return k
    return None


def recipes():
    w = open(os.path.join(SRC, "war3map.wts"), "rb").read().decode("utf-8")
    m = re.search(r"\{[^}]*chế tạo đồ[^}]*\}", w)
    if not m:
        return {}
    block = m.group(0)
    uses = {}
    for prod, mats in re.findall(r"\|c0000ff00([^|]+)\|r:[ \t]*([^\r\n]+)", block):
        for m in mats.split("+"):
            uses.setdefault(plain(m.strip()), []).append(prod.strip())
    return uses


# kham attributes (gameplay.j zzVL_KhamInit)
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


# stats of a piece of gear, read from its item abilities (for the pieces whose text has none)
STOCK = {
    b"AId4": {b"Idef": 4},
    b"AId8": {b"Idef": 8},
    b"AIx1": {b"Istr": 1, b"Iagi": 1, b"Iint": 1},
    b"AIx2": {b"Istr": 2, b"Iagi": 2, b"Iint": 2},
}
SLOT_NAME = {1: "Mũ", 2: "Áo", 3: "Vũ khí", 4: "Giày"}
Y = "|c00ffff00"


def ability_values():
    import struct as st

    ver, tabs = objdata.parse(open(os.path.join(SRC, "war3map.w3a"), "rb").read(), ".w3a")
    out = {}
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            vals = {}
            for x in sets[0]:
                if x[1] == 1:
                    if x[3] == 0:
                        vals[x[0]] = st.unpack("<i", x[4])[0]
                    elif x[3] in (1, 2):
                        vals[x[0]] = st.unpack("<f", x[4])[0]
            out[o if ti == 0 else n] = (o, vals)
    return out


def stat_lines(iabi, abil):
    tot = {}
    for a in iabi.split(b","):
        if not a:
            continue
        base, vals = abil.get(a, (a, {}))
        vals = {**STOCK[base], **vals} if base in STOCK else vals
        for k, v in vals.items():
            tot[(base, k)] = tot.get((base, k), 0) + v
    g = lambda base, k: tot.get((base, k), 0)
    lines = []
    st_ = [g(b, f) for b in (b"AIx5", b"AIx1", b"AIx2") for f in (b"Istr",)]
    s_, a_, i_ = (sum(g(b, f) for b in (b"AIx5", b"AIx1", b"AIx2")) for f in (b"Istr", b"Iagi", b"Iint"))
    if s_ and s_ == a_ == i_:
        lines.append("Tất cả chỉ số: %s+%d|r" % (Y, s_))
    else:
        for v, nm in ((s_, "Sức mạnh"), (a_, "Thân pháp"), (i_, "Nội công")):
            if v:
                lines.append("%s: %s+%d|r" % (nm, Y, v))
    for keys, nm, fmt in (
        ((b"AId4", b"Idef"), "Phòng thủ", "+%d"),
        ((b"AIl1", b"Ilif"), "Sinh lực", "+%d"),
        ((b"AI2m", b"Iman"), "Nội lực", "+%d"),
        ((b"AIth", b"Iatt"), "Công kích", "+%d"),
        ((b"AIsx", b"Isx1"), "Tốc đánh", "+%d%%"),
        ((b"AIms", b"Imvb"), "Tốc chạy", "+%d"),
        ((b"Arel", b"Ihpr"), "Hồi sinh lực", "+%g/giây"),
        ((b"ACev", b"Eev1"), "Né tránh", "%d%%"),
        ((b"ACbh", b"Hbh1"), "Choáng khi đánh", "%d%%"),
        ((b"Aakb", b"Akb1"), "Hào quang công kích", "+%d%%"),
        ((b"ACav", b"Had1"), "Hào quang phòng thủ", "+%d"),
        ((b"ACua", b"Uau1"), "Hào quang tốc chạy", "+%d%%"),
        ((b"AIba", b"Hab1"), "Hào quang hồi nội lực", "+%g/giây"),
        ((b"ACah", b"Eah1"), "Phản sát thương", "%d%%"),
    ):
        v = g(*keys)
        if v:
            if "%%" in fmt and keys[1] in (b"Isx1", b"Eev1", b"Hbh1", b"Akb1", b"Uau1", b"Eah1") and abs(v) < 5:
                v = v * 100
            lines.append("%s: %s%s|r" % (nm, Y, fmt % v))
    return lines


# tien cu: heroes whose main stat (or weapon / poison style) fits the piece; advice only
HEROES = {
    "str": [
        "Thiên Vương Đao",
        "Thiên Vương Thương",
        "Thiên Vương Chùy",
        "Thiếu Lâm Quyền",
        "Thiếu Lâm Trượng",
        "Cái Bang Chưởng",
        "Thiên Nhẫn Thương",
    ],
    "agi": [
        "Ngũ Độc Đao",
        "Võ Đang Kiếm",
        "Thúy Yên Song Đao",
        "Đường Môn Phi Tiêu",
        "Đường Môn Bẫy",
        "Đường Môn Bạch Phong",
    ],
    "int": [
        "Nga My Chưởng",
        "Côn Luân Kiếm",
        "Côn Luân Đao",
        "Võ Đang Khí",
        "Ngũ Độc Chưởng",
        "Thiên Nhẫn Đao",
        "Thiếu Lâm Đao",
        "Đại Lý Đoàn Thị",
    ],
}
POISON = ["Ngũ Độc Đao", "Ngũ Độc Chưởng", "Đường Môn Phi Tiêu", "Đường Môn Bẫy"]
WEAPON_KIND = [
    ("song dao", "Song Đao"),
    ("kiem", "Kiếm"),
    ("thuong", "Thương"),
    ("mau", "Thương"),
    ("chuy", "Chùy"),
    ("truong", "Trượng"),
    ("con", "Trượng"),
    ("dao", "Đao"),
]


def recommend(iabi, abil, slot, name):
    if slot != 3:
        return [], False
    tot = {}
    bases = set()
    for a in iabi.split(b","):
        if not a:
            continue
        base, vals = abil.get(a, (a, {}))
        bases.add(base)
        vals = {**STOCK[base], **vals} if base in STOCK else vals
        for k, v in vals.items():
            tot[k] = tot.get(k, 0) + v
    g = lambda k: tot.get(k, 0)
    sc = {
        "str": g(b"Istr") + g(b"Ilif") / 40.0 + g(b"Idef") * 1.5 + g(b"Eah1") * 50,
        "agi": g(b"Iagi")
        + g(b"Iatt") / 4.0
        + g(b"Isx1") * (60 if g(b"Isx1") < 5 else 0.6)
        + g(b"Eev1") * 60
        + g(b"Akb1") * 30
        + g(b"Hbh1") * 40,
        "int": g(b"Iint") + g(b"Iman") / 25.0 + g(b"Hab1") * 3,
    }
    common = min(sc.values())
    best = max(sc, key=sc.get)
    poison = b"Aspo" in bases
    if sc[best] - common < 2 and not poison:
        return [], False
    heroes = list(HEROES[best]) if sc[best] - common >= 2 else []
    if poison:
        heroes = POISON + [h for h in heroes if h not in POISON]
    if slot == 3:
        p_ = plain(re.sub(r"\|c\w{8}|\|r", "", name))
        kind = next((v for k, v in WEAPON_KIND if re.search(r"\b%s\b" % k, p_)), None)
        if kind:
            same = [h for h in HEROES["str"] + HEROES["agi"] + HEROES["int"] if h.endswith(kind)]
            heroes = [h for h in heroes if h in same] + [h for h in same if h not in heroes][:2] if same else heroes
    if slot != 3:  # armor, hat, boots: by sect
        heroes = [" ".join(h.split()[:2]) for h in heroes]
    return list(dict.fromkeys(heroes))[:4], poison


MAT_NAME = {}
REQ = {}


def main():
    p = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3t")
    uses = recipes()
    abil = ability_values()
    from gameplay_items import items

    slot_of = {iid: (slot, tier) for iid, slot, tier, _ in items()}
    REQ.clear()
    import gameplay

    nm_of = {}
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            nm = next((x[4].decode("utf-8") for x in sets[0] if x[0] == b"unam"), "")
            nm_of[(o if ti == 0 else n).decode("latin1")] = re.sub(r"\|c\w{8}|\|r", "", nm).strip()
    for prod, mats in gameplay.craft_recipes():
        REQ[prod] = [nm_of.get(m, m) for m in mats]
    MAT_NAME.clear()
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            nm = next((x[4].decode("utf-8") for x in sets[0] if x[0] == b"unam"), "")
            nm = re.sub(r"\|c\w{8}|\|r", "", nm).strip()
            if nm:
                MAT_NAME.setdefault(plain(nm), nm)
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
            fam = family(name)
            lore = LORE.get(fam) if fam else None
            st = slot_of.get(iid)
            if st is None and iid in FIX:  # names fixed here: the slot from the new name
                words = set(re.findall(r"[a-z]+", plain(name)))
                slot = next((sl for sl, keys in SLOTS if words & keys), 0)
                if slot:
                    st = (slot, 1)
            if iid in REQ and "Yêu cầu:" not in tub:
                req = (
                    "|cffff8000Yêu cầu:|r "
                    + ", ".join(REQ[iid])
                    + " + |cffffcc005000 vàng|r"
                    + NL
                    + "|cff9a9a9aMua ở cửa hàng: đủ nguyên liệu (túi, hành trang hoặc Thủ Khố) thì nhận ngay, thiếu thì hoàn tiền.|r"
                )
                tub = req + (NL + tub if tub else "")

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            if "Bí Phổ" in name and " - " in name and "Nguyên liệu" not in tub:
                parts = [plain(x).strip() for x in re.sub(r"\|c\w{8}|\|r", "", name).split(" - ")[1:]]
                mats = [
                    m
                    for m, prods in uses.items()
                    if any(plain(x).startswith(pr) or pr.startswith(plain(x)) for x in prods for pr in parts if pr)
                ]
                mats = [m for m in mats if m != "bi pho"]
                if mats:
                    names = sorted(set(MAT_NAME.get(m, m) for m in mats))
                    tub = (
                        (tub + NL if tub else "")
                        + "|cffffcc00Nguyên liệu:|r "
                        + ", ".join(names)
                        + NL
                        + "Bỏ sách và nguyên liệu vào Thủ Khố rồi bấm Chế Đồ."
                    )

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            if st:
                slot, tier = st
                h = sum(ord(c) for c in iid)
                if tier == 5:
                    if slot == 3:
                        prefix = 'Tần Lăng'
                    else:
                        prefixes = [
                            'Phá Quân',
                            'Sương Tinh',
                            'U Lung',
                            'Sát Quỷ',
                            'Vô Ma',
                            'Băng Hư',
                            'Đồng Cừu',
                            'Ma Hoàng',
                            'Lăng Nhạc',
                            'Vô Vọng',
                        ]
                        prefix = prefixes[h % len(prefixes)]
                else:
                    if tier == 4 and slot == 3:
                        prefix = 'An Bang'
                    else:
                        prefix = {1: 'Động Sát', 2: 'Nhu Tình', 3: 'Hiệp Cốt', 4: 'Định Quốc'}.get(tier, '')
                color_prefix = ''
                color_suffix = ''
                m = re.match(r'(\|c[0-9a-fA-F]{8})(.*?)(\|r)', name)
                if m:
                    color_prefix = m.group(1)
                    color_suffix = m.group(3)
                plus = ''
                pm = re.search(r'(\+\s*\d+)', name)
                if pm:
                    plus = ' ' + pm.group(1)
                orig_plain = plain(name).lower()
                suffix = ''
                if slot == 3:
                    w_words = [
                        ('kiem', 'Kiếm'),
                        ('song dao', 'Song Đao'),
                        ('dao', 'Đao'),
                        ('mau', 'Mâu'),
                        ('kich', 'Kích'),
                        ('con', 'Côn'),
                        ('bong', 'Bổng'),
                        ('truong', 'Trượng'),
                        ('phien', 'Phiến'),
                        ('phu', 'Phủ'),
                    ]
                    for k, v in w_words:
                        if k in orig_plain:
                            suffix = v
                            break
                    if not suffix:
                        suffix = 'Khí'
                elif slot == 1:
                    w_words = [('quan', 'Quán'), ('khoi', 'Khôi'), ('mao', 'Mão'), ('mu', 'Mũ'), ('can', 'Cân')]
                    for k, v in w_words:
                        if k in orig_plain:
                            suffix = v
                            break
                    if not suffix:
                        suffix = ['Quán', 'Khôi', 'Mão'][h % 3]
                elif slot == 2:
                    w_words = [('giap', 'Giáp'), ('y', 'Y'), ('bao', 'Bào'), ('thuong', 'Thường'), ('sam', 'Sam')]
                    for k, v in w_words:
                        if k in orig_plain:
                            suffix = v
                            break
                    if not suffix:
                        suffix = ['Giáp', 'Y', 'Bào', 'Thường', 'Sam'][h % 5]
                elif slot == 4:
                    w_words = [('hai', 'Hài'), ('ngoa', 'Ngoa'), ('ly', 'Lý'), ('giay', 'Giày')]
                    for k, v in w_words:
                        if k in orig_plain:
                            suffix = v
                            break
                    if not suffix:
                        suffix = ['Hài', 'Ngoa', 'Lý'][h % 3]
                new_name = prefix + ' ' + suffix + plus
                name = color_prefix + new_name + color_suffix
                setv(b'unam', name)
                setv(b'utip', name)
                if iid == 'belv':
                    print('belv name:', repr(name), 'st:', st)
            if not lore and st:
                lore = SLOT_LORE[st[0]]
            if st and st[1] == 5 and "hoàng kim" not in tub.lower():
                lore = (lore + " " if lore else "") + GOLD_LINE
            use = uses.get(fam) if fam and "Bí Phổ" not in name else None
            if use:
                use_txt = "|cffffcc00Dùng để chế:|r " + ", ".join(dict.fromkeys(use))
                if "Dùng để chế" not in tub:
                    tub = tub + NL + use_txt if tub else use_txt

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            if st and st[0] in SLOT_NAME:
                plain_tub = re.sub(r"\|c\w{8}|\|r", "", tub)
                if not any(w in plain_tub for w in ("Phòng thủ", "Sinh lực", "Công kích", "chỉ số", "Tốc")):
                    sl = stat_lines(get(b"iabi")[4] if get(b"iabi") else b"", abil)
                    if sl:
                        tub = NL.join(sl) + (NL + tub if tub else "")
                if "Tiến cử" not in tub:
                    rc, poison = recommend(get(b"iabi")[4] if get(b"iabi") else b"", abil, st[0], name)
                    if rc:
                        tub += (
                            NL + "|cff00ff80Tiến cử:|r " + ", ".join(rc) + (" |cff9a9a9a(hệ độc)|r" if poison else "")
                        )
                if st[0] == 3 and "Ngũ hành vũ khí" not in tub:
                    import gameplay as gp

                    e = gp.weapon_element(iid) - 1
                    tub += NL + "|cffffcc00Ngũ hành vũ khí:|r %s%s|r - %s" % (
                        gp.ELEMENT_COLOR[e],
                        gp.ELEMENTS[e],
                        gp.ELEMENT_TEXT[e],
                    )
                if "Lỗ khảm" not in tub:
                    tub += NL + "|cff80c0ff%s bậc %d - Lỗ khảm: 2 - Cường hóa theo ô|r" % (SLOT_NAME[st[0]], st[1])

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            if iid in KHAM and "[Khảm]" not in tub:
                tub = (tub + NL if tub else "") + "|cff80c0ff[Khảm] " + KHAM[iid] + " (mỗi trang bị 2 lỗ)|r"

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            if iid == "I00W":
                tub = (
                    "|c008080ffCường hóa trang bị|r"
                    + NL
                    + "Dùng lên mũ, áo, vũ khí hoặc giày: ô đó của bạn +1 cấp cường hóa "
                    "(tối đa +10). Cấp cường hóa đi theo người, thay món mới vẫn giữ."
                    + NL
                    + "Mũ +3 mọi chỉ số, áo -2% sát thương nhận, vũ khí +4% sát thương, giày +150 sinh lực mỗi cấp."
                )

                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace(
                        "Võ Đang Kiếm, Côn Luân Kiếm",
                        "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao",
                    )
                    tub = tub.replace(
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền",
                        "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy",
                    )
                    tub = tub.replace(
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu",
                        "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ",
                    )
                setv(b"utub", tub)
            parts = [tub] if tub else []
            if lore:
                parts.append(GREY + lore + "|r")
            if parts:
                setv(b"ides", (NL + NL).join(parts))
                n += 1
    data = objdata.write(ver, tabs, ".w3t")
    open(p, "wb").write(data)
    import hashlib

    print('MD5 written:', hashlib.md5(data).hexdigest(), 'to', p)
    print("described items:", n, "| materials with recipes:", len(uses))


if __name__ == "__main__":
    main()
