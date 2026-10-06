# KVCT skill sets (Kiem Vo Chi Ton, Silva.Fox) for the VLTK heroes: names, icons, hotkeys, descriptions read
# from KVCT's ability strings; the kind of each skill (template of the skill engine in kskill.j) and its
# numbers come from the description words. Used by kskill.py.
import re

KV_STRINGS = r"D:\kvct-dev\src\map\Units\CampaignAbilityStrings.txt"
# VLTK hero -> KVCT class
CLASS = {
    "E000": "NDD", "H002": "TVD", "E001": "VDK", "E002": "TYD", "E003": "DMPT", "H00Z": "TLQ", "H014": "TND",
    "H00A": "CBC", "H009": "CLK", "H01E": "TLD", "H01F": "TVT", "H01L": "NDC", "H01M": "DMTT", "E005": "NMC",
    "H01P": "TNK", "H01S": "VDQ", "H01U": "CLD", "H00L": "TLB", "H00U": "DTK", "H00V": "TVC", "E006": "DMPD", "H020": "CBB", "H021": "NMK", "H022": "MGC", "H023": "MGK", "H024": "DTC", "H025": "CMC", "H026": "CMK", "H027": "HSQ", "H028": "HSK", "H029": "TDC", "H02A": "TDK", "H02B": "TYK"
}
# VLTK hero -> (KVCT hero model, KVCT class name)
HERO = {
    "E000": ("Hero_ngudocdao", "Ngũ Độc Đao"), "H002": ("Hero_thienvuongdao2", "Thiên Vương Đao"),
    "E001": ("Hero_vodangkiem", "Võ Đang Kiếm"), "E002": ("Hero_thuyyendao", "Thúy Yên Đao"),
    "E003": ("Hero_duongmonphitieu", "Đường Môn Phi Tiêu"), "H00Z": ("Hero_thieulamquyen", "Thiếu Lâm Quyền"),
    "H014": ("Hero_thiennhandao", "Thiên Nhẫn Đao"), "H00A": ("Hero_caibangchuong", "Cái Bang Chưởng"),
    "H009": ("Hero_conlonkiem", "Côn Lôn Kiếm"), "H01E": ("Hero_thieulamdao", "Thiếu Lâm Đao"),
    "H01F": ("Hero_thienvuongthuong", "Thiên Vương Thương"), "H01L": ("Hero_ngudocchuong", "Ngũ Độc Chưởng"),
    "H01M": ("Hero_duongmontutien", "Đường Môn Tụ Tiễn"), "E005": ("Hero_ngamychuong", "Nga My Chưởng"),
    "H01P": ("Hero_thiennhankich", "Thiên Nhẫn Kích"), "H01S": ("Hero_vodangkhi", "Võ Đang Khí"),
    "H01U": ("Hero_conlondao", "Côn Lôn Đao"), "H00L": ("Hero_thieulambong", "Thiếu Lâm Bổng"),
    "H00U": ("Hero_doanthikhi", "Đoàn Thị Khí"), "H00V": ("Hero_thienvuongchuy", "Thiên Vương Chùy"),
    "E006": ("Hero_duongmonphidao", "Đường Môn Phi Đao"),
    "H020": ("Hero_caibangbong", "Cái Bang Bổng"), "H021": ("Hero_ngamykiem2", "Nga My Kiếm"),
    "H022": ("Hero_minhgiaochuy", "Minh Giáo Chùy"), "H023": ("Hero_minhgiaokiem", "Minh Giáo Kiếm"),
    "H024": ("Hero_doanthichi", "Đoàn Thị Chỉ"), "H025": ("Hero_comocham", "Cổ Mộ Châm"), "H026": ("Hero_comokiem", "Cổ Mộ Kiếm"), "H027": ("Hero_hoasonkhi", "Hoa Sơn Khí"), "H028": ("Hero_hoasonkiem", "Hoa Sơn Kiếm"), "H029": ("Hero_tieudaochuong", "Tiêu Dao Chưởng"), "H02A": ("Hero_tieudaokiem", "Tiêu Dao Kiếm"), "H02B": ("Hero_thuyyenkiem", "Thúy Yên Kiếm")
}
# templates: 1 strike (target unit), 2 cone (point, in front), 3 dash (point), 4 nova (around self),
# 5 lance (point, long line), 6 self buff, 7 party buff, 8 cleanse (immune to control), 0 passive
STATUS = {"thọ thương": 1, "định thân": 2, "choáng": 3, "chậm": 4, "làm chậm": 4, "giảm tốc": 4, "bất động": 2}


def plain(s):
    return re.sub(r"\|c\w{8}|\|r", "", s or "").replace("|n", "\n").strip('"')


def kind_of(tip):
    t = tip.lower()
    head = t.split("\n")[0]
    if "bị động" in head:
        return 0
    if ("hộ thuẫn" in t or "lá chắn" in t) and "bị động" not in head:
        return 9
    if "hỗ trợ chủ động" in head:
        if "miễn nhiễm" in t and ("định thân" in t or "choáng" in t) and "vật công" not in t:
            return 8
        return 7 if ("phe ta" in t or "đồng đội" in t) else 6
    if "xung kích" in t or "lao tới" in t or "lướt" in t:
        return 3
    if "trước mặt" in t or "tầm xa" in t or "phóng" in t or "bay" in t or "xuyên" in t:
        return 5
    if "phạm vi rộng" in t or "xung quanh" in t or "quanh thân" in t:
        return 4
    if "tầm xa" in t or "phóng" in t or "bay" in t:
        return 5
    if "phía trước" in t or "nhiều mục tiêu" in t:
        return 2
    return 1


def numbers(tip):
    t = tip.lower()
    hits = re.search(r"số chiêu thức:\s*(\d+)", t)
    cd = re.search(r"giãn cách:?\s*(\d+)\s*giây", t)
    dur = re.search(r"duy trì:\s*(\d+)\s*giây", t)
    st, chance, sdur = 0, 0, 0
    for k, v in STATUS.items():
        m = re.search(r"xác suất\s*(\d+)?%?\s*gây\s*" + k + r"\s*(\d+)?", t)
        if m:
            st, chance, sdur = v, int(m.group(1) or 30), int(m.group(2) or 1)
            break
    # extra effects named in the description (kskill.j zzKS_Fx): 1 push back, 2 pull, 4 life steal, 8 poison / burn
    # over time, 16 heal, 32 hurt around every second, 64 damage immunity, 128 reflect, 512 lower resistances,
    # 1024 triggers at low life, 2048 burn (not poison) look
    has = lambda *w: any(x in t for x in w)
    fx = 0
    fx |= 1 if has("đẩy lùi", "đánh bay") else 0
    fx |= 2 if has("kéo ") else 0
    fx |= 4 if has("hút sinh lực", "hút máu", "thành sinh lực") else 0
    fx |= 8 if has("độc sát", "trúng độc", "gây độc", "bỏng", "thiêu đốt", "hạ độc", "hỏa sát") else 0
    fx |= 16 if has("hồi phục sinh lực", "hồi sinh lực", "trị liệu") else 0
    fx |= 32 if has("mỗi giây") else 0
    fx |= 64 if has("miễn nhiễm sát thương", "miễn dịch sát thương", "kháng tất cả sát thương") else 0
    fx |= 128 if has("phản đòn", "phản lại") else 0
    fx |= 512 if has("giảm kháng", "giảm tất cả kháng", "giảm phòng", "bỏ qua") else 0
    fx |= 1024 if has("sinh lực xuống thấp", "sinh lực giảm còn") else 0
    fx |= 2048 if has("bỏng", "thiêu đốt", "hỏa sát") else 0
    fx |= 4096 if has("phục hồi nội lực", "hồi nội lực", "hồi phục nội lực") else 0
    fx |= 8192 if has("cộng dồn", "tích lũy", "tầng ") else 0
    passive = "bị động" in t.split(chr(10))[0]
    if passive:
        st, chance, sdur = 0, 0, 0
    elif st == 0 and re.search(r"gây[^.]{0,20}choáng", t):
        st, chance, sdur = 3, 25, 1
    elif st == 0 and re.search(r"(gây|khiến)[^.]{0,20}(chậm|đóng băng|băng phong)|làm chậm", t):
        st, chance, sdur = 4, 35, 2
    return {"fx": fx, "hits": int(hits.group(1)) if hits else 1, "cd": int(cd.group(1)) if cd else 0,
            "dur": int(dur.group(1)) if dur else 0, "status": st, "chance": chance, "sdur": sdur}


KV_SCRIPT = r"D:\kvct-dev\work\readable.j"
# classes checked against KVCT's code (kskill.py OVR is complete for them): their skill list is KVCT's own class
# table (slots 1..14, shared skills included), not the skills named after the class
KV_ORDER = {"NDD", "TVD", "VDK", "TYD", "DMPT", "TLQ", "TND", "CBC", "CLK", "TLD", "TVT", "NDC", "DMTT", "NMC", "TNK", "VDQ", "CLD", "TLB", "DTK", "TVC", "DMPD", "CBB", "NMK", "MGC"}


def kv_table():
    """KVCT's skill table of each class: set Kuz[oY]="NDD" ... SaveInteger(o8,eRS(oY,Ff),slot,'A075')"""
    out, cur = {}, None
    for l in open(KV_SCRIPT, encoding="utf-8", errors="ignore"):
        m = re.match(r'set Kuz\[oY\]="(\w+)"', l)
        if m:
            cur = m.group(1)
            continue
        m = re.match(r"call SaveInteger\(o8,eRS\(oY,Ff\),(\d+),\$([0-9A-F]{8})\)", l)
        if m and cur:
            out.setdefault(cur, {})[int(m.group(1))] = bytes.fromhex(m.group(2)).decode()
    return out


def load():
    t = open(KV_STRINGS, encoding="utf-8", errors="ignore").read()
    out = {}
    for blk in re.split(r"\n(?=\[)", t):
        m = re.search(r"(?m)^Name=([A-Z]{2,5})(\d+)_", blk)
        a = re.match(r"\[(\w{4})\]", blk)
        if not m or not a:
            continue
        f = dict(re.findall(r"(?m)^(\w+)=(.*)$", blk))
        tip = plain(f.get("Researchubertip", ""))
        name = plain(f.get("Researchtip", ""))
        hk = re.search(r"\((\w)\)\s*$", name)
        out.setdefault(m.group(1), []).append({
            "kv": a.group(1), "n": int(m.group(2)), "name": re.sub(r"\s*\(\w\)\s*$", "", name).strip(),
            "key": hk.group(1) if hk else "", "order": f.get("Order", "").strip(), "anim": f.get("Animnames", "spell").strip() or "spell", "icon": f.get("Art", "").split(",")[0], "tip": tip, "raw": f.get("Researchubertip", "").strip().strip('"'),
            "kind": kind_of(tip), **numbers(tip)})
    for v in out.values():
        v.sort(key=lambda s: s["n"])
    if KV_ORDER:
        byid = {s["kv"]: s for v in out.values() for s in v}
        tab = kv_table()
        for cl in KV_ORDER:
            out[cl] = [dict(byid[a], n=slot) for slot, a in sorted(tab[cl].items()) if a in byid]
    return out


if __name__ == "__main__":
    data = load()
    import collections
    c = collections.Counter()
    for h, cl in CLASS.items():
        sk = data.get(cl, [])
        c.update(s["kind"] for s in sk)
        print(h, cl, len(sk), " ".join("%s[%d%s]" % (s["name"], s["kind"], s["key"]) for s in sk))
    print(c)
