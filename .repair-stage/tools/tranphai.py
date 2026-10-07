# Tuyet hoc tran phai: one sect skill per hero (5th skill, given by gameplay.j at hero level 15, +1 level
# every 5 hero levels up to 5). Three come from the author's Thien Kiem map (name, icon, idea: Thuan Duong
# Vo Cuc Cong, Duy Nga Doc Ton, Vo Nhan Vo Nga), the others are new. The effects are scripted in gameplay.j
# (zzVL_Tp*): the Thien Kiem versions run on Thien Kiem triggers, and their ids are other skills in VLTK.
# Actives are copies of Channel (own order string each, none used by a VLTK skill), passives copies of
# Evasion at 0%. Writes src\map\war3map.w3a, copies the icons and writes build\tranphai_table.j.
# Run after skills.py.
import os, shutil, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
TK = r"D:\thienkiem-dev\src"
TABLE = os.path.join(ROOT, "build", "tranphai_table.j")
BS = chr(92)
CB = "ReplaceableTextures" + BS + "CommandButtons" + BS
PB = "ReplaceableTextures" + BS + "PassiveButtons" + BS

# id, name, sect, heroes, kind (0 none, 1 unit, 2 point, -1 passive), order, icon, range, cooldown, mana, text(L)
SKILLS = [
    (
        "A0T0",
        "Thuần Dương Vô Cực Công",
        "Võ Đang",
        "E001 H01S",
        0,
        "avatar",
        CB + "BTNSpell_ThuanDuongVoCuc.blp",
        0,
        30,
        150,
        lambda L: "Chuyển nội lực thành lá chắn trong 12 giây, hấp thụ sát thương bằng |cffffcc00%d%%|r nội lực hiện tại."
        % (40 + 15 * L),
    ),
    (
        "A0T1",
        "Duy Ngã Độc Tôn",
        "Thiên Vương",
        "H002 H01F H00V",
        0,
        "roar",
        CB + "BTNSpell_ThienVuongChienY.blp",
        0,
        35,
        150,
        lambda L: "Lập tức hồi |cffffcc00%d%%|r sinh lực tối đa, trong 8 giây giảm |cffffcc00%d%%|r sát thương phải nhận."
        % (15 + 5 * L, 15 + 5 * L),
    ),
    (
        "A0T2",
        "Vô Nhân Vô Ngã",
        "Côn Luân",
        "H009 H01U",
        -1,
        "",
        PB + "PASBTNSpell_VoNhanVoNga.blp",
        0,
        0,
        0,
        lambda L: "|cffffcc00Bị động|r: tăng |cffffcc00%d%%|r sát thương, |cffffcc00%d%%|r cơ hội gây gấp đôi."
        % (6 * L, 3 * L),
    ),
    (
        "A0T3",
        "Kim Chung Tráo",
        "Thiếu Lâm",
        "H00Z H01E H00L",
        0,
        "metamorphosis",
        CB + "BTNDivineIntervention.blp",
        0,
        30,
        120,
        lambda L: "Kim chung hộ thể trong 8 giây: giảm |cffffcc00%d%%|r sát thương phải nhận và phản lại |cffffcc00%d%%|r cho kẻ đánh."
        % (15 + 5 * L, 10 * L),
    ),
    (
        "A0T4",
        "Cửu Âm Chân Kinh",
        "Nga My",
        "E005",
        0,
        "tranquility",
        CB + "BTNTranquility.blp",
        0,
        30,
        200,
        lambda L: "Hồi cho bản thân và đồng đội trong 800 phạm vi |cffffcc00%d|r + 2 x Trí lực sinh lực." % (200 * L),
    ),
    (
        "A0T5",
        "Hàng Long Thập Bát Chưởng",
        "Cái Bang",
        "H00A",
        2,
        "shockwave",
        CB + "BTNShockWave.blp",
        700,
        20,
        150,
        lambda L: "Chưởng lực vào vùng 300: gây |cffffcc00%d|r + 3 x chỉ số chính sát thương và đẩy lùi kẻ địch."
        % (150 * L),
    ),
    (
        "A0T6",
        "Cửu Âm Bạch Cốt Trảo",
        "Ngũ Độc",
        "E000 H01L",
        1,
        "manaburn",
        CB + "BTNUnholyFrenzy.blp",
        500,
        18,
        120,
        lambda L: "Trảo vào mục tiêu: |cffffcc00%d|r + 3 x chỉ số chính sát thương, hút 50%% thành sinh lực, trúng độc thêm 5 lần mỗi giây 10%%."
        % (130 * L),
    ),
    (
        "A0T7",
        "Bạo Vũ Lê Hoa Châm",
        "Đường Môn",
        "E003 H01M E006",
        2,
        "blizzard",
        CB + "BTNFanOfKnives.blp",
        800,
        16,
        130,
        lambda L: "Phóng ám khí hình quạt dài 800: mỗi kẻ địch trúng |cffffcc00%d|r + 3 x chỉ số chính sát thương."
        % (120 * L),
    ),
    (
        "A0T8",
        "Băng Tâm Tiên Tử",
        "Thúy Yên",
        "E002",
        0,
        "starfall",
        CB + "BTNGlacier.blp",
        0,
        22,
        150,
        lambda L: "Hàn khí quanh thân 450: gây |cffffcc00%d|r + 2 x chỉ số chính sát thương và đóng băng kẻ địch %g giây."
        % (100 * L, 1 + 0.25 * L),
    ),
    (
        "A0T9",
        "Thiên Ma Giải Thể",
        "Thiên Nhẫn",
        "H014 H01P",
        1,
        "holybolt",
        CB + "BTNDeathPact.blp",
        500,
        20,
        100,
        lambda L: "Đốt 15%% sinh lực hiện tại, gây |cffffcc00%d|r + 4 x chỉ số chính + phần sinh lực đã đốt thành sát thương."
        % (150 * L),
    ),
    (
        "A0TA",
        "Cửu Dương Thần Công",
        "Đại Lý",
        "H00U",
        -1,
        "",
        CB + "BTNImmolationOn.blp",
        0,
        0,
        0,
        lambda L: "|cffffcc00Bị động|r: mỗi giây hồi |cffffcc00%.1f%%|r sinh lực tối đa, sát thương tăng |cffffcc00%d%%|r."
        % (0.4 * L, 4 * L),
    ),
]


POTION_ABIL = {b"A009": 400, b"A0CS": 900, b"A0CT": 1600, b"A0CW": 2500, b"A0TB": 4000}


def m(mid, typ, val, lvl=0, dp=0):
    if typ == 3:
        v = val.encode("utf-8")
    elif typ == 0:
        v = struct.pack("<i", val)
    else:
        v = struct.pack("<f", val)
    return [mid, lvl, dp, typ, v, b"\0\0\0\0"]


def main():
    p = os.path.join(SRC, "war3map.w3a")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3a")
    ids = [s[0].encode() for s in SKILLS]
    tabs[1][:] = [o for o in tabs[1] if o[1] not in ids]
    rows = []
    for sid, name, sect, heroes, kind, order, icon, rng, cd, mana, text in SKILLS:
        passive = kind < 0
        mods = [
            m(b"anam", 3, name),
            m(b"aart", 3, icon),
            m(b"alev", 0, 5),
            m(b"aher", 0, 0),
            m(b"abpx", 0, 0),
            m(b"abpy", 0, 1),
            m(b"ahky", 3, "G"),
        ]
        for L in range(1, 6):
            tip = "|cffff8000%s|r (|cffffcc00G|r) - cấp %d (tuyệt học trấn phái %s)" % (name, L, sect)
            ub = text(L)
            if not passive:
                ub += "|n|cffffcc00Hồi chiêu:|r %d giây  |cff6aa0ffNội lực:|r %d" % (cd, mana)
            ub += "|n|cff808080Mở ở cấp 75, lên cấp mỗi 25 cấp tướng.|r"
            mods += [m(b"atp1", 3, tip, L), m(b"aub1", 3, ub, L)]
            if passive:
                mods.append(m(b"Eev1", 2, 0.0, L, 1))
            else:
                mods += [
                    m(b"acdn", 2, float(cd), L),
                    m(b"amcs", 0, mana, L),
                    m(b"aran", 2, float(rng or 100), L),
                    m(b"Ncl1", 2, 0.0, L, 1),
                    m(b"Ncl2", 0, kind, L, 2),
                    m(b"Ncl3", 0, 1, L, 3),
                    m(b"Ncl4", 2, 0.0, L, 4),
                    m(b"Ncl5", 0, 0, L, 5),
                    m(b"Ncl6", 3, order, L, 6),
                    m(b"adur", 2, 0.0, L),
                    m(b"ahdu", 2, 0.0, L),
                ]
                if kind == 1:
                    mods.append(m(b"atar", 3, "air,enemies,ground,neutral,organic", L))
        tabs[1].append([b"ACev" if passive else b"ANcl", sid.encode(), [mods]])
        for h in heroes.split():
            rows.append("call SaveInteger(zzVL_ht,'%s',50,'%s')" % (h, sid))
        rows.append("call SaveInteger(zzVL_ht,'%s',51,%d)" % (sid, kind))
        if order:
            rows.append("call SaveInteger(zzVL_ht,'%s',52,OrderId(\"%s\"))" % (sid, order))
    # potions: one kind heals life and mana over 15 s, 5 tiers (gameplay.py POTIONS), not stopped by damage
    tabs[1][:] = [o for o in tabs[1] if o[1] != b"A0TB"]
    base = next(o for o in tabs[1] if o[1] == b"A009")
    tabs[1].append([base[0], b"A0TB", [[list(x) for x in base[2][0]]]])
    for o, n, sets in tabs[1]:
        if n in POTION_ABIL:
            amount = POTION_ABIL[n]
            sets[0][:] = [x for x in sets[0] if x[0] not in (b"irl1", b"irl2", b"irl5", b"adur", b"ahdu")]
            sets[0] += [
                m(b"irl1", 2, float(amount), 1, 1),
                m(b"irl2", 2, float(amount), 1, 2),
                m(b"irl5", 0, 0, 1, 5),
                m(b"adur", 2, 15.0, 1),
                m(b"ahdu", 2, 15.0, 1),
            ]
    open(p, "wb").write(objdata.write(ver, tabs, ".w3a"))
    open(TABLE, "w", encoding="utf-8").write("\n".join(rows) + "\n")
    for sub, f in (
        ("CommandButtons", "BTNSpell_ThuanDuongVoCuc.blp"),
        ("CommandButtons", "BTNSpell_ThienVuongChienY.blp"),
        ("PassiveButtons", "PASBTNSpell_VoNhanVoNga.blp"),
        ("CommandButtonsDisabled", "DISBTNSpell_ThuanDuongVoCuc.blp"),
        ("CommandButtonsDisabled", "DISBTNSpell_ThienVuongChienY.blp"),
        ("CommandButtonsDisabled", "DISPASBTNSpell_VoNhanVoNga.blp"),
    ):
        d = os.path.join(SRC, "ReplaceableTextures", sub)
        os.makedirs(d, exist_ok=True)
        shutil.copy(os.path.join(TK, "ReplaceableTextures", sub, f), os.path.join(d, f))
    print("tran phai skills:", len(SKILLS))


if __name__ == "__main__":
    main()
