# Bước pipeline: hệ trang bị KVCT (nhóm DATA). Tác giả icon / tên trang bị KVCT: Silva.Fox.
#   - war3map.w3t: tạo vật phẩm ITV0..ITVA (vũ khí gốc 11 loại), ITS1..ITS5 / ITS7..ITSA (nón, áo, lưng, tay, giày, liên, nhẫn,
#     bội, hộ phù), ITW0..ITWA (Vũ khí Tần Lăng, trùng sinh 11, bán trong tiệm) và ITHB (Tần Lăng Hòa Thị Bích, nguyên liệu).
#   - icon KVCT theo bậc cường hóa 0..10 (+ bậc 11 của vũ khí) chép vào src\map\war3mapImported\kvq\ (thư mục riêng, icons.py chỉ xóa
#     war3mapImported\kv\) kèm bản "disabled" cho icon hiện trong tiệm (ReplaceableTextures\CommandButtonsDisabled\DIS<tên>).
#   - bảng dữ liệu cho JASS (gameplay_09_equip.j): hàm zzEQ_Items ghi thẳng vào war3map.j, được gọi từ zzVL_Items (cách của icons.py).
# Chạy SAU gameplay.py và describe.py (war3map.j đã có zzVL_Items), TRƯỚC icons.py. Chạy lại được (xóa bản ghi cũ trước khi tạo).
#   python kvequip.py
import io, os, re, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import kvequip_data as D
import config
from PIL import Image
from mpq import MPQ
from icons import blp_size, blp1_palette

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
KVCT = r"D:\kvct-dev\work\base.w3x"
BS = chr(92)
DST = "war3mapImported" + BS + "kvq" + BS
NL = "|n"

ITEM_IDS = (
    [D.weapon_code(w) for w in range(11)]
    + [D.weapon_code(w, True) for w in range(11)]
    + [D.slot_code(s) for s in D.ARMOR_SLOTS]
    + ["ITHB"]
)


def mod(mid, typ, val):
    if typ == 3:
        return [mid, None, None, 3, val.encode("utf-8"), b"\0\0\0\0"]
    return [mid, None, None, 0, struct.pack("<i", val), b"\0\0\0\0"]


def esc(s):
    return s.replace(BS, BS + BS).replace('"', BS + '"')


def entries():
    """(mã, ô 1..10, loại vũ khí hoặc -1, là Tần Lăng) của mọi trang bị KVCT"""
    out = []
    for w in range(11):
        out.append((D.weapon_code(w), 6, w, False))
    for s in D.ARMOR_SLOTS:
        out.append((D.slot_code(s), s, -1, False))
    for w in range(11):
        out.append((D.weapon_code(w, True), 6, w, True))
    return out


def tiers_of(tanlang):
    return [D.TANLANG_TIER] if tanlang else list(range(D.MAX_TIER + 1))


def icon_path(slot, w, tier):
    return DST + D.icon_dest(slot, w, tier)


def static_text(iid, slot, w, tanlang):
    """mô tả nền của vật phẩm (utub = ides); tiêu đề bậc và chỉ số đã nhân hệ số do zzEQ_SetTier gắn thêm ở đầu"""
    import gameplay as gp

    sname = D.SLOTS[slot][1]
    if slot == 6:
        wn = D.WEAPONS[w][0]
        t = "|cffffcc00Vũ Khí|r - loại |cffffcc00%s|r" % wn
        if tanlang:
            t += NL + "|cffff8000Trùng sinh 11 - Vũ khí Tần Lăng|r: cực phẩm, luôn ở bậc cao nhất, không cường hóa thêm."
    else:
        t = "|cffffcc00%s|r (ô %d của bảng Nhân Vật, phím C)" % (sname, slot)
    t += NL + "|cffffcc00Chỉ số gốc (100%%)|r: %s" % D.stat_line(slot, 100)
    if tanlang:
        t += NL + "|cffffcc00Chỉ số Tần Lăng|r (500%%): %s" % D.stat_line(slot, D.pct(D.TANLANG_TIER))
    t += NL + "|cff80c0ffLỗ khảm: 2 - Cường hóa: Thủy tinh +1 đến +10, mỗi bậc đổi icon và chỉ số theo trùng sinh 1 đến 10 của Kiếm Vũ Chí Tôn|r"
    if slot == 6:
        e = D.weapon_element(w) - 1
        t += NL + "|cffffcc00Ngũ hành vũ khí:|r %s%s|r - %s" % (gp.ELEMENT_COLOR[e], gp.ELEMENTS[e], gp.ELEMENT_TEXT[e])
        t += NL + "|cff00ff80Tiến cử:|r " + (", ".join(D.class_names(w)) or "chưa phái nào dùng loại này (chỉ rơi / thần binh)")
        t += NL + "|cff9a9a9aChỉ các phái trên (dùng vũ khí loại %s) mới mặc được.|r" % D.WEAPONS[w][0].lower()
        if tanlang:
            t += NL + "|cff9a9a9aMua ở tiệm tạp hóa: vàng + 1 vũ khí %s +10 + 1 Tần Lăng Hòa Thị Bích.|r" % D.WEAPONS[w][0].lower()
    t += NL + "|cff9a9a9aBấm trong Hành Trang (B) để mặc, bấm ô trên bảng Nhân Vật để tháo. Cường hóa đi theo món đồ.|r"
    return t


def make_item(iid, slot, w, tanlang):
    t0 = D.TANLANG_TIER if tanlang else 0
    name = D.tier_color(slot, t0) + D.tier_name(slot, w, t0) + "|r"
    text = static_text(iid, slot, w, tanlang)
    mods = [
        mod(b"unam", 3, name),
        mod(b"utip", 3, name),
        mod(b"utub", 3, text),
        mod(b"ides", 3, text),
        mod(b"iabi", 3, ""),
        mod(b"iico", 3, icon_path(slot, w, t0)),
        mod(b"igol", 0, config.TANLANG_WEAPON_GOLD if tanlang else D.GOLD_COST),
        mod(b"ilum", 0, 0),
        mod(b"idro", 0, 1),
        mod(b"ipaw", 0, 1),
        mod(b"isel", 0, 1),
        mod(b"ilev", 0, 10 if tanlang else 8),
        mod(b"icla", 3, "Permanent"),
    ]
    if tanlang:  # hàng của cửa hàng (gameplay.py shops() đặt cùng số: isto 10, istr 30, isst 0)
        mods += [mod(b"isto", 0, 10), mod(b"istr", 0, 30), mod(b"isst", 0, 0)]
    return [b"clfm", iid.encode(), [mods]]


def make_hoathibich():
    name = "|cffff8000Tần Lăng Hòa Thị Bích|r"
    text = (
        "|cffff8000Nguyên liệu|r rơi từ boss |cffffcc00Tần Thủy Hoàng|r ở Tần Lăng." + NL
        + "Cùng vàng và 1 vũ khí +10 cùng loại, đổi lấy |cffffcc00Vũ khí Tần Lăng|r (trùng sinh 11) ở tiệm tạp hóa." + NL
        + "|cff9a9a9aGiữ trong Hành Trang (B). Không bán được.|r"
    )
    mods = [
        mod(b"unam", 3, name),
        mod(b"utip", 3, name),
        mod(b"utub", 3, text),
        mod(b"ides", 3, text),
        mod(b"iabi", 3, ""),
        mod(b"iico", 3, DST + D.HOATHIBICH_ICON),
        mod(b"igol", 0, 0),
        mod(b"ilum", 0, 0),
        mod(b"idro", 0, 1),
        mod(b"ipaw", 0, 0),
        mod(b"isel", 0, 1),
        mod(b"ilev", 0, 10),
        mod(b"icla", 3, "Miscellaneous"),
    ]
    return [b"clfm", b"ITHB", [mods]]


def items_w3t():
    p = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3t")
    orig = {o for o, n, s in tabs[0]}
    clash = [i for i in ITEM_IDS if i.encode() in orig]
    if clash:
        sys.exit("kvequip: mã vật phẩm đã dùng trong bảng gốc: %s" % clash)
    mine = {i.encode() for i in ITEM_IDS}
    tabs[1][:] = [o for o in tabs[1] if o[1] not in mine]
    for iid, slot, w, tanlang in entries():
        tabs[1].append(make_item(iid, slot, w, tanlang))
    tabs[1].append(make_hoathibich())
    open(p, "wb").write(objdata.write(ver, tabs, ".w3t"))
    return len(tabs[1])


def wanted_icons():
    """{tên file đích: (tên file KVCT, có cần bản disabled)}"""
    want = {}
    for iid, slot, w, tanlang in entries():
        for t in tiers_of(tanlang):
            dest = D.icon_dest(slot, w, t)
            dis = t == (D.TANLANG_TIER if tanlang else 0)  # icon hiện ở tiệm / lúc chưa cường hóa
            src = D.icon_source(slot, w, t)
            if dest in want:
                want[dest] = (want[dest][0], want[dest][1] or dis)
            else:
                want[dest] = (src, dis)
    want[D.HOATHIBICH_ICON] = (D.HOATHIBICH_ICON, True)
    return want


def blp64(kv, name):
    data = kv.read("war3mapImported" + BS + name)
    if not data:
        sys.exit("kvequip: không có icon %s trong archive KVCT" % name)
    if blp_size(data) != (64, 64):  # 1.31 hiện ô xanh với icon không phải lũy thừa 2
        data = blp1_palette(Image.open(io.BytesIO(data)))
    return data


def copy_icons():
    d = open(KVCT, "rb").read(1 << 20)
    kv = MPQ(KVCT, d.find(b"MPQ\x1a"))
    out_dir = os.path.join(SRC, "war3mapImported", "kvq")
    dis_dir = os.path.join(SRC, "ReplaceableTextures", "CommandButtonsDisabled")
    os.makedirs(out_dir, exist_ok=True)
    os.makedirs(dis_dir, exist_ok=True)
    for f in os.listdir(out_dir):
        os.remove(os.path.join(out_dir, f))
    want = wanted_icons()
    n_dis = 0
    for dest, (src, dis) in sorted(want.items()):
        data = blp64(kv, src)
        open(os.path.join(out_dir, dest), "wb").write(data)
        if dis:
            im = Image.open(os.path.join(out_dir, dest)).convert("RGBA")
            a = im.getchannel("A")
            g = im.convert("L").point(lambda v: int(v * 0.55)).convert("RGBA")
            g.putalpha(a)
            open(os.path.join(dis_dir, "DIS" + dest), "wb").write(blp1_palette(g))
            n_dis += 1
    return len(want), n_dis


def rows():
    r = []
    for iid, slot, w, tanlang in entries():
        q = "'%s'" % iid
        kind = D.SLOTS[slot][2]
        r.append("call SaveInteger(zzVL_ht,%s,0,%d)" % (q, kind * 10 + (D.KEY0_TIER_TANLANG if tanlang else D.KEY0_TIER)))
        r.append("call SaveInteger(zzVL_ht,%s,91,%d)" % (q, slot))
        r.append("call SaveInteger(zzVL_ht,%s,92,%d)" % (q, w + 1 if slot == 6 else 0))
        r.append("call SaveInteger(zzVL_ht,%s,93,%d)" % (q, 2 if tanlang else 1))
        r.append("call SaveInteger(zzVL_ht,%s,41,%d)" % (q, config.TANLANG_WEAPON_GOLD // 2 if tanlang else D.SELL_GOLD))
        if slot == 6:
            r.append("call SaveInteger(zzVL_ht,%s,66,%d)" % (q, D.weapon_element(w)))
        for t in tiers_of(tanlang):
            r.append('call SaveStr(zzVL_ht,%s,%d,"%s")' % (q, 100 + t, esc(D.tier_color(slot, t) + D.tier_name(slot, w, t))))
            r.append('call SaveStr(zzVL_ht,%s,%d,"%s")' % (q, 120 + t, esc(icon_path(slot, w, t))))
        base = D.BASE[slot]
        assert len(base) <= D.MAX_STATS
        r.append("call SaveInteger(zzVL_ht,%s,139,%d)" % (q, len(base)))
        for j, (code, v) in enumerate(base):
            r.append("call SaveInteger(zzVL_ht,%s,%d,%d)" % (q, 140 + 2 * j, code))
            r.append("call SaveInteger(zzVL_ht,%s,%d,%d)" % (q, 141 + 2 * j, v))
    r.append("call SaveInteger(zzVL_ht,'ITHB',41,0)")
    for k_, v_ in ((1, config.GLASS_POINTS_AT_20), (2, config.GLASS_POINTS_AT_30), (3, config.GLASS_POINTS_AT_40),
                   (4, config.GLASS_CATCHUP_KILLS), (5, config.GLASS_MAX_POINTS_PER_KILL), (6, config.GLASS_ENABLED),
                   (7, config.GLASS_VALUE_NORMAL), (8, config.GLASS_VALUE_ELITE), (9, config.GLASS_VALUE_LEADER),
                   (10, config.GLASS_VALUE_BOSS_MIN), (11, config.GLASS_VALUE_BOSS_MAX),
                   (12, config.GLASS_VALUE_SPECIAL_BOSS_MIN), (13, config.GLASS_VALUE_SPECIAL_BOSS_MAX)):
        r.append("call SaveInteger(zzVL_ht,'zzGL',%d,%d)" % (k_, v_))
    for t_ in range(1, 11):
        r.append("call SaveInteger(zzVL_ht,'zzGL',%d,%d)" % (20 + t_, config.GLASS_ENHANCE_COST[t_ - 1]))
        r.append("call SaveInteger(zzVL_ht,'zzGL',%d,%d)" % (40 + t_, config.GLASS_SUCCESS_RATE[t_ - 1]))
        r.append("call SaveInteger(zzVL_ht,'zzGL',%d,%d)" % (60 + t_, config.GLASS_PITY_REQUIRED[t_ - 1]))
    
    # Ruoi bao thach theo lich phut (gameplay_16_gemdrop.j; config muc 13)
    r.append("call SaveInteger(zzVL_ht,0,360,%d)" % config.GD_CATCHUP_KILLS)
    r.append("call SaveInteger(zzVL_ht,0,361,%d)" % config.GD_MAX_PER_KILL)
    r.append("call SaveInteger(zzVL_ht,0,362,%d)" % config.GD_MAX_PER_KILL_BOSS)
    r.append("call SaveInteger(zzVL_ht,0,363,%d)" % config.GD_ENABLED)
    for t_ in range(1, 10):
        u_ = config.GD_TIER_UNLOCK[t_ - 1]
        n40_ = config.GD_TIER_N40[t_ - 1]
        s_ = config.GD_TIER_START[t_ - 1]
        rate_ = config.GD_T9_PER_MIN if n40_ is None else (n40_ - s_) / float(40 - u_)
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (370 + t_, u_))
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (380 + t_, round(rate_ * 1000)))
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (390 + t_, s_))
        
    for hero, ws in sorted(D.hero_weapon().items()):
        r.append("call SaveInteger(zzVL_ht,'%s',96,%d)" % (hero, ws[0] + 1))
        for w in ws:
            r.append("call SaveInteger(zzVL_ht,'%s',%d,1)" % (hero, 400 + w))
    return r


def patch_script():
    js = os.path.join(SRC, "Scripts", "war3map.j")
    raw = open(js, "rb").read().decode("utf-8")
    nl = chr(13) + chr(10) if chr(13) + chr(10) in raw else chr(10)
    head = "function zzVL_Items takes nothing returns nothing"
    if raw.count(head) != 1:
        sys.exit("kvequip: chưa có zzVL_Items trong war3map.j (chạy gameplay.py trước)")
    if "function zzEQ_Items " in raw:
        sys.exit("kvequip: war3map.j đã có zzEQ_Items (chạy lại convert_text.py, fix_script.py, gameplay.py trước)")
    body = rows()
    fn = ["function zzEQ_Items takes nothing returns nothing"] + body + ["endfunction"]
    raw = raw.replace(head, nl.join(fn) + nl + head + nl + 'call ExecuteFunc("zzEQ_Items")')
    open(js, "wb").write(raw.encode("utf-8"))
    return len(body)


def main():
    n = items_w3t()
    ic, dis = copy_icons()
    nr = patch_script()
    print("kvequip: %d vật phẩm trong w3t, %d icon (%d bản disabled), %d hàng bảng" % (n, ic, dis, nr))


if __name__ == "__main__":
    main()
