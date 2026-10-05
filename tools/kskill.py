# KVCT skill sets on the VLTK heroes (engine: kskill.j, data: kskill_data.py). Every hero of CLASS loses its
# VLTK hero skills and gets its KVCT class's skills as unit abilities (X000...), opened by hero level 1..200.
# Icons and one effect model per skill come from KVCT (textures of KVCT3_Data put in the map, as vfx.py does).
# Writes build\kskill_table.j (read by gameplay.py). Run after lvl200.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata, vfx
from kskill_data import CLASS, HERO, KV_STRINGS, load
KV_STRINGS_DIR = KV_STRINGS
from icons import blp1_palette
from gameplay_items import plain
from PIL import Image
import io
from difflib import SequenceMatcher

SRC = r"D:\vltk-dev-clone\src\map"
TABLE = r"D:\vltk-dev-clone\build\kskill_table.j"
I_ = "war3mapImported" + chr(92)
# weapon model of each class, attached to the hero's "weapon" point as KVCT does (its hero models have none)
WEAPON = {"NDD": "VK_daoNDD", "TVD": "VK_daidaoTVD", "VDK": "VK_kiemVDK", "TYD": "VK_daoTYD", "DMPT": "VK_phitieuv1",
          "TLQ": "VK_quyenthieu2", "TND": "VK_daoTND", "CBC": "VK_chuongcaiv1", "CLK": "VK_kiemCLK", "TLD": "VK_daoTLD",
          "TVT": "VK_thuongTVT", "NDC": "VK_chuongv3_chuongdoc-left", "DMTT": "VK_tutien", "NMC": "VK_chuongngav1",
          "TNK": "VK_thuongTNK", "VDQ": "VK_kiemVDQ", "CLD": "VK_daoCLD", "TLB": "VK_bongTL", "DTK": "VK_kiemDTK",
          "TVC": "VK_chuyTVC", "DMPD": "VK_pdaov1", "CBB": "VK_bongTL", "NMK": "VK_kiemVDK", "MGC": "VK_chuyTVC", "MGK": "VK_kiemVDK", "DTC": "VK_phitieuv1", "CMC": "VK_phitieuv1", "CMK": "VK_kiemVDK", "HSQ": "VK_chuongcaiv1", "HSK": "VK_kiemVDK", "TDC": "VK_chuongcaiv1", "TDK": "VK_kiemVDK", "TYK": "VK_kiemVDK"}
# model scale of each hero model in KVCT (its UnitUI), so the heroes look the same size
KV_SCALE = {"Hero_thienvuongthuong": 1.05, "Hero_thienvuongchuy": 1.05, "Hero_conlonkiem": 1.03, "Hero_thienvuongdao2": .98,
            "Hero_thieulamquyen": 1.2, "Hero_thieulamdao": 1.05, "Hero_ngudocchuong": 1.1, "Hero_ngudocdao": 1.05,
            "Hero_duongmontutien": .82, "Hero_duongmonphidao": 1.25, "Hero_ngamychuong": .8, "Hero_thuyyendao": 1.25,
            "Hero_doanthikhi": .85, "Hero_caibangchuong": .77, "Hero_thieulambong": .85, "Hero_thiennhandao": .95,
            "Hero_thiennhankich": 1.15, "Hero_conlondao": 1.2, "Hero_vodangkhi": .82, "Hero_vodangkiem": 1.25,
            "Hero_duongmonphitieu": 1.18, "Hero_minhgiaokiem": .85, "Hero_minhgiaochuy": .85, "Hero_ngamykiem2": .80,
            "Hero_doanthichi": .85, "Hero_caibangbong": .77, "Hero_thuyyenkiem": 1.25,
            "Hero_comocham": .90, "Hero_comokiem": .90, "Hero_hoasonkhi": .90, "Hero_hoasonkiem": .90,
            "Hero_tieudaochuong": .90, "Hero_tieudaokiem": .90}
UNLOCK = [1, 6, 15, 25, 38, 52, 68, 85, 105, 125, 145, 165, 185, 195]
SLOT = {"Q": (0, 2), "W": (1, 2), "E": (2, 2), "R": (3, 2), "D": (1, 1), "F": (2, 1), "T": (3, 1)}
ORDER = {"Q": "thunderbolt", "W": "shockwave", "E": "stomp", "R": "carrionswarm", "D": "roar", "F": "starfall",
         "T": "avatar"}
# kind -> (target type of the channel: 0 none 1 unit 2 point, cast range, cooldown, AI kind)
# KVCT order of the skill -> (base ability with autocast, order, its two effect fields set to 0)
AUTO = {"blackarrow": (b"Aslo", "slow", b"Slo1", b"Slo2"), "poisonarrowstarg": (b"Afae", "faeriefire", b"Fae1", b"Fae2")}
# numbers read from KVCT's own skill code (docs\kvct_skills.md), per KVCT ability:
# kind = template, dur = buff seconds, stats = [(stat of zzVL_af, base, per rank), ...]
OVR = {
    "A0KG": {"kind": 3},
    "A0KH": {"kind": 4, "hits": 40},
    "A0XM": {"kind": 4, "status": 4, "sdur": 24, "hits": 4},
    "A0CE": {"kind": 6, "status": 5},

    "A021": {"kind": 11},                                    # Bon Loi Toan Long Thuong: 7 dashes to enemies in 1000
    "A01W": {"dur": 300, "stats": [(12, 70, 30), (3, 3, 1)]},  # Thien Vuong Chien Y: +70+30/rank attack, crit (14+6/rank)/4
    "A0ED": {"kind": 6, "dur": 12, "stats": [(5, 28, 2)]},     # Thoi Thua Luc Long
    "A0X5": {"kind": 6, "dur": 20, "stats": [(5, 20, 1), (12, 80, 20)]}, # Triet Y Thap Bat Diet
    "A0JO": {"kind": 6, "dur": 300, "stats": [(6, 18, 3)]},    # Toa Vong Vo Nga
    "A0JP": {"kind": 9, "dur": 20},                            # Thuan Duong Vo Cuc
    "A0JS": {"kind": 12},                                    # Van Kiem Quy Tong (1000 range nova)
}
KIND = {1: (1, 250., 4, 1), 2: (2, 450., 6, 2), 3: (2, 700., 8, 2), 4: (0, 0., 10, 0), 5: (2, 900., 7, 2),
        6: (0, 0., 30, 0), 7: (0, 0., 30, 0), 8: (0, 0., 40, 0), 9: (0, 0., 30, 0), 11: (0, 0., 15, 0), 12: (0, 0., 15, 0)}
# stat words of a passive / buff -> stat of zzVL_af (kskill.j zzKS_per)
STAT = [("sinh lực tối đa", 7), ("chí mạng", 3), ("tốc độ tấn công", 4), ("tốc đánh", 4), ("vật công", 5),
        ("phát huy lực tấn công", 5), ("công kích", 5), ("sát thương", 5), ("phòng thủ", 11), ("kháng", 6),
        ("giảm sát thương", 6), ("hút", 1), ("hồi phục", 7), ("sinh lực", 7), ("tốc độ di chuyển", 13)]
STATUS_TXT = {1: "thọ thương", 2: "định thân", 3: "choáng", 4: "làm chậm"}
KIND_TXT = {1: "Đánh mục tiêu", 2: "Quét các mục tiêu phía trước (450)", 3: "Xung kích tới điểm chọn (700), đánh trên đường",
            4: "Đánh các mục tiêu quanh thân (380)", 5: "Phóng chiêu bay thẳng 900, xuyên qua mọi mục tiêu"}
STAT_TXT = {1: "Hút sinh lực +%d%%", 3: "Bạo kích +%d%%", 4: "Tốc đánh +%d%%", 5: "Sát thương +%d%%",
            6: "Giảm sát thương nhận %d%%", 7: "Sinh lực +%d", 11: "Phòng thủ +%d", 13: "Tốc chạy +%d"}
PER = {1: 1, 3: 1, 4: 3, 5: 2, 6: 1, 7: 80, 11: 1, 13: 4}


def m(mid, typ, val, lvl=0, dp=0):
    v = val.encode("utf-8") if typ == 3 else struct.pack("<i", val) if typ == 0 else struct.pack("<f", val)
    return [mid, lvl, dp, typ, v, b"\0\0\0\0"]


def stats_of(tip):
    t = tip.lower()
    out = []
    for w, k in STAT:
        if w in t and k not in out:
            out.append(k)
        if len(out) == 2:
            break
    return out or [5]


def kv_image(d):
    """KVCT icons are BLP1 with JPEG data that PIL decodes wrongly (CMYK, inverted): decode the JPEG part"""
    if d[:4] == b"BLP1" and struct.unpack_from("<I", d, 4)[0] == 0:
        offs, sizes = struct.unpack_from("<16I", d, 28), struct.unpack_from("<16I", d, 92)
        hs = struct.unpack_from("<I", d, 156)[0]
        im = Image.open(io.BytesIO(d[160:160 + hs] + d[offs[0]:offs[0] + sizes[0]]))
        c, mm, y, k = Image.frombytes("RGBA", im.size, im.tobytes()).split()
        inv = lambda b: Image.eval(b, lambda v: 255 - v)
        return Image.merge("RGBA", (inv(y), inv(mm), inv(c), inv(k)))
    return Image.open(io.BytesIO(d)).convert("RGBA")


def hero_scale(model):
    """scale so the model's stand animation is as tall as Huyen Giac (Thieu Lam Quyen) on screen, ~157"""
    d = vfx.read(vfx.vlkt(), I_ + model + ".mdx")
    i = d.find(b"SEQS")
    for k in range(struct.unpack_from("<I", d, i + 4)[0] // 132):
        o = i + 8 + 132 * k
        if d[o:o + 80].split(bytes(1))[0].lower().startswith(b"stand"):
            h = struct.unpack_from("<f", d, o + 128)[0] - struct.unpack_from("<f", d, o + 116)[0]
            return max(.55, min(1.4, 157. / h)) if h > 40 else 1.
    return 1.


def fill(raw, L, kind, st, hits, proc, chance=30):
    """KVCT's own description, its blanks (! @ # $) filled with this map's numbers at rank L"""
    out = []
    pct = int((90 + 17 * L) * (1 + .3 * (hits - 1)) / hits)
    for line in raw.split("|n"):
        low = plain(line)
        def val(_):
            if "xac suat" in low:
                return str(chance)
            if kind == 9 and ("ho thuan" in low or "la chan" in low):
                return str(20 + 5 * L)
            if kind in (1, 2, 3, 4, 5):
                if "phat huy" in low or "ngoai" in low:
                    return str(pct)
                if "cong" in low:
                    return str(20 * L)
            for w, kk in STAT:
                if plain(w) in low:
                    return str(int(PER.get(kk, 2) * L * (1.5 if kind in (6, 7) else 1)))
            return str(2 * L)
        out.append(re.sub(r"[!@#$]", val, line))
    if proc:
        out.append("|cffc3dbffTự phát 10% khi đánh thường.|r")
    return "|n".join(out)


def kv_slk():
    """KVCT's cooldown (Cool1) and cast range (Rng1) of each ability, from its Units AbilityData.slk"""
    txt = open(os.path.join(os.path.dirname(KV_STRINGS_DIR), "AbilityData.slk"), encoding="utf-8", errors="ignore").read()
    cols, rows, cur = {}, {}, None
    for l in txt.split("\n"):
        if l.startswith("C;"):
            f = {p[0]: p[1:] for p in l.strip().split(";")[1:] if p}
            if "Y" in f:
                cur = int(f["Y"])
            x, v = int(f["X"]), f.get("K", "").strip('"')
            if cur == 1:
                cols[v] = x
            rows.setdefault(cur, {})[x] = v
    def num(v):
        try:
            return float(v)
        except (TypeError, ValueError):
            return None
    return {r.get(1): (num(r.get(cols["Cool1"])), num(r.get(cols["Rng1"]))) for r in rows.values()}


def key_of(s):
    return re.sub(r"[^a-z]", "", plain(s))


def main():
    data = load()
    slk = kv_slk()
    kv = vfx.vlkt()
    names = [l.strip() for l in open(r"D:\kvct-dev\work\listfile.txt", encoding="utf-8", errors="ignore")
             if l.strip().lower().endswith(".mdx") and l.strip().lower().startswith("war3mapimported")]
    p = os.path.join(SRC, "war3map.w3a")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3a")
    tabs[1][:] = [o for o in tabs[1] if not o[1].startswith(b"X")]
    rows, made, models = [], 0, {}
    n = 0
    for hero, cl in CLASS.items():
        skills = data.get(cl, [])[:14]
        used = set()
        for i, s in enumerate(skills):
            sid = "X%03d" % n if n < 1000 else "Y%03d" % (n - 1000)
            n += 1
            o_ = OVR.get(s["kv"], {})
            kind, key = o_.get("kind", s["kind"]), s["key"]
            if "dur" in o_:
                s["dur"] = o_["dur"]
            proc = kind in (1, 2, 3, 4, 5) and (key not in SLOT or key in used)
            if kind in (6, 7, 8, 9) and (key not in SLOT or key in used):
                kind = 0                                        # keyless buff: a passive
            used.add(key)
            st = stats_of(s["tip"])
            if "stats" in o_:
                st = [x[0] for x in o_["stats"]]
            # effect: a KVCT model named like the skill, else one of its class, else a generic one
            want = key_of(s["name"])
            own = [x for x in names if os.path.basename(x).upper().startswith(cl + "_")]

            def score(x):                               # longest piece of the model name found in the skill name
                w = key_of(os.path.basename(x)[len(cl) + 1:-4])
                buff = bool(re.search(r"buff|aura", w))
                w2 = re.sub(r"buff|aura|cast(er)?|target|effect|\d", "", w)
                mt = SequenceMatcher(None, w2, want).find_longest_match(0, len(w2), 0, len(want)).size
                if mt < 5:
                    return 0
                return mt * 2 + (1 if buff == (kind in (6, 7, 8, 0)) else 0)
            best = max(own, key=score) if own else None
            if best and score(best):
                model = os.path.basename(best)
            else:
                pool = [x for x in own if not re.search(r"buff|aura|cast", x, re.I)] or own
                model = os.path.basename(pool[i % len(pool)] if pool else "Effect_Slam.mdx")
            models[model] = 1
            icon = s["icon"] or "ReplaceableTextures\\CommandButtons\\BTNSpell_Lightning.blp"
            if icon.lower().startswith("war3mapimported"):
                d = vfx.read(kv, icon)
                if d:
                    im = kv_image(d)
                    out = os.path.join(SRC, *icon.split("\\"))
                    os.makedirs(os.path.dirname(out), exist_ok=True)
                    open(out, "wb").write(blp1_palette(im, 64))
                    g = im.convert("LA").convert("RGBA")
                    dis = os.path.join(SRC, "ReplaceableTextures", "CommandButtonsDisabled", "DIS" + os.path.basename(icon))
                    os.makedirs(os.path.dirname(dis), exist_ok=True)
                    open(dis, "wb").write(blp1_palette(g, 64))
            first = s["tip"].split("\n")[0].strip()
            mods = [m(b"anam", 3, s["name"]), m(b"aart", 3, icon), m(b"alev", 0, 10), m(b"aher", 0, 0)]
            mods.append(m(b"aani", 3, s["anim"]))
            mods += [m(b"auar", 3, icon), m(b"arar", 3, icon)]       # turn-off / research art: the same icon
            passive = kind == 0 or proc
            if passive:
                mods += [m(b"abpx", 0, 0), m(b"abpy", 0, -11)]
            else:
                x, y = SLOT[key]
                mods += [m(b"abpx", 0, x), m(b"abpy", 0, y), m(b"ahky", 3, key)]
            for L in range(1, 11):
                lines = [fill(s["raw"], L, kind, st, s["hits"], proc, s["chance"] or 30) or first]
                lines.append("|cff808080Mở ở cấp %d, cấp 10 khi tướng cấp 200 (võ công %s, KVCT).|r" % (UNLOCK[i], cl))
                tipL = "%s%s - cấp %d" % (s["name"], (" (|cffffcc00%s|r)" % key) if not passive else "", L)
                mods += [m(b"atp1", 3, tipL, L), m(b"aub1", 3, "|n".join(lines), L)]
                if passive:
                    mods.append(m(b"Eev1", 2, 0., L, 1))
                else:
                    tt, rng, cd, _ = KIND[kind]
                    kcd, krng = slk.get(s["kv"], (None, None))
                    cd = kcd if kcd is not None else (s["cd"] or cd)          # KVCT's cooldown
                    rng = krng if (krng and kind in (1, 2, 5)) else rng
                    mods += [m(b"acdn", 2, float(cd), L), m(b"amcs", 0, 0, L), m(b"aran", 2, rng or 100., L),
                             m(b"Ncl1", 2, 0., L, 1), m(b"Ncl2", 0, tt, L, 2), m(b"Ncl3", 0, 1, L, 3),
                             m(b"Ncl4", 2, 0., L, 4), m(b"Ncl5", 0, 0, L, 5), m(b"Ncl6", 3, ORDER[key], L, 6),
                             m(b"adur", 2, 0., L), m(b"ahdu", 2, 0., L)]
                    if tt == 1:
                        mods.append(m(b"atar", 3, "air,enemies,ground,neutral,organic", L))
            auto = AUTO.get(s.get("order")) if not passive else None
            if auto:                                        # KVCT "tu dong danh": autocast on attacks
                base, order, f1, f2 = auto
                mods = [x for x in mods if not x[0].startswith(b"Ncl")]
                for L in range(1, 11):
                    mods += [m(f1, 2, 0., L, 1), m(f2, 2, 0., L, 2), m(b"adur", 2, .01, L), m(b"ahdu", 2, .01, L),
                             m(b"atar", 3, "air,enemies,ground,neutral,organic", L)]
                tabs[1].append([base, sid.encode(), [mods]])
            else:
                tabs[1].append([b"ACev" if passive else b"ANcl", sid.encode(), [mods]])
            made += 1
            if not passive and key in SLOT:                         # skill bar (kskill.j zzKS_BarAb)
                rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (hero, 260 + "QWERDFT".index(key), sid))
            k = 0 if passive else kind
            rows += ["call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (hero, 200 + i, sid),
                     "call SaveInteger(zzVL_ht,'%s',%d,%d)" % (hero, 230 + i, UNLOCK[i]),
                     "call SaveInteger(zzVL_ht,'%s',240,%d)" % (sid, k if not proc else 0),
                     "call SaveInteger(zzVL_ht,'%s',241,%d)" % (sid, max(1, s["hits"])),
                     "call SaveInteger(zzVL_ht,'%s',242,%d)" % (sid, s["status"]),
                     "call SaveInteger(zzVL_ht,'%s',243,%d)" % (sid, s["chance"]),
                     "call SaveInteger(zzVL_ht,'%s',244,%d)" % (sid, max(1, s["sdur"])),
                     "call SaveInteger(zzVL_ht,'%s',246,%d)" % (sid, s["dur"]),
                     "call SaveInteger(zzVL_ht,'%s',247,%d)" % (sid, st[0]),
                     "call SaveInteger(zzVL_ht,'%s',248,%d)" % (sid, st[1] if len(st) > 1 else 0),
                     "call SaveInteger(zzVL_ht,'%s',249,%d)" % (sid, 1 if proc else 0),
                     "call SaveInteger(zzVL_ht,'%s',252,%d)" % (sid, s["fx"]),
                     ] + ["call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, 253 + 2 * n + w, v) for n, x in enumerate(o_.get("stats", [])) for w, v in ((0, x[1]), (1, x[2]))] + [
                     'call SaveStr(zzVL_ht,\'%s\',250,"war3mapImported%s%s")' % (sid, "\\\\", model)]
            if proc:
                rows.append("call SaveInteger(zzVL_ht,'%s',240,%d)" % (sid, kind))
            if not passive:                                          # AI / auto-cast table (gameplay.j zzVL_TryCast)
                o_, k_ = (auto[1], 1) if auto else (ORDER[key], KIND[kind][3])
                rows += ["call SaveInteger(zzVL_ht,'%s',2,OrderId(\"%s\"))" % (sid, o_),
                         "call SaveInteger(zzVL_ht,'%s',3,%d)" % (sid, k_)]
                if auto:
                    rows.append("call SaveStr(zzVL_ht,'%s',251,\"%son\")" % (sid, auto[1]))
        # auto-cast keys 10.. of the hero: the new actives only
        act = [r for r in rows if False]
    # hero skill lists emptied (no skill points: kskill.j opens the skills by level)
    open(p, "wb").write(objdata.write(ver, tabs, ".w3a"))
    pu = os.path.join(SRC, "war3map.w3u")
    uver, utabs = objdata.parse(open(pu, "rb").read(), ".w3u")
    for ti, tab in enumerate(utabs):
        for o, nw, sets in tab:
            if (o if ti == 0 else nw).decode("latin1") in CLASS:
                hid = (o if ti == 0 else nw).decode("latin1")
                model, cname = HERO[hid]
                for x in sets[0]:
                    if x[0] == b"uhab":
                        x[4] = b""
                    elif x[0] in (b"umdl", b"unam"):
                        x[4] = (I_ + model + ".mdx" if x[0] == b"umdl" else cname).encode("utf-8")
                if not any(x[0] == b"umdl" for x in sets[0]):
                    sets[0].append([b"umdl", 0, 0, 3, (I_ + model + ".mdx").encode(), bytes(4)])
                models[model + ".mdx"] = 1
                rows.append("call SaveStr(zzVL_ht,'%s',272,\"war3mapImported%s%s.mdx\")" % (hid, chr(92) * 2, model))
                models[WEAPON[CLASS[hid]] + ".mdx"] = 1
                rows.append("call SaveStr(zzVL_ht,'%s',270,\"war3mapImported%s%s.mdx\")" % (hid, chr(92) * 2, WEAPON[CLASS[hid]]))
                sc = [x for x in sets[0] if x[0] == b"usca"]
                v = struct.pack("<f", KV_SCALE.get(model, 1.))   # KVCT size of the model
                if sc:
                    sc[0][4] = v
                else:
                    sets[0].append([b"usca", 0, 0, 1, v, bytes(4)])   # real field: type 1 (2 made the model invisible)
    open(pu, "wb").write(objdata.write(uver, utabs, ".w3u"))
    # auto-cast list per hero (keys 10..), in skill order
    by = {}
    for r in rows:
        mm = re.match(r"call SaveInteger\(zzVL_ht,'(\w{4})',(2\d\d),'(X\w{3}|Y\w{3})'\)", r)
        if mm and mm.group(2).startswith("20") or (mm and mm.group(2).startswith("21")):
            by.setdefault(mm.group(1), []).append(mm.group(3))
    actives = {re.match(r"call SaveInteger\(zzVL_ht,'(\w{4})',2,", r).group(1) for r in rows if re.match(r"call SaveInteger\(zzVL_ht,'\w{4}',2,OrderId", r)}
    for h, ab in by.items():
        k = 10
        for a in ab:
            if a in actives:
                rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (h, k, a))
                k += 1
        rows += ["call SaveInteger(zzVL_ht,'%s',%d,0)" % (h, j) for j in range(k, k + 4)]
    os.makedirs(os.path.dirname(TABLE), exist_ok=True)
    open(TABLE, "w", encoding="utf-8").write("\n".join(rows) + "\n")
    # effect models (+ their textures) from KVCT
    vfx.SWAP = {m_: m_[:-4] for m_ in models}
    done, nf = vfx.copy_models(kv)
    print("kskill: %d skills on %d heroes, %d effect models (%d files)" % (made, len(CLASS), len(done), nf))


if __name__ == "__main__":
    main()
