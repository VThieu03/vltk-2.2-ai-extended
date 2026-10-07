# KVCT skill sets on the VLTK heroes (engine: kskill.j, data: kskill_data.py). Every hero of CLASS loses its
# VLTK hero skills and gets its KVCT class's skills as unit abilities (X000...), opened by hero level 1..200.
# Icons and one effect model per skill come from KVCT (textures of KVCT3_Data put in the map, as vfx.py does).
# Writes build\kskill_table.j (read by gameplay.py). Run after lvl200.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata, vfx
from kskill_data import CLASS, HERO, KV_STRINGS, KV_ORDER, MANUAL_QWE, load
KV_STRINGS_DIR = KV_STRINGS
from icons import blp1_palette
from gameplay_items import plain
from PIL import Image
import io
from difflib import SequenceMatcher
from tk_mapping import TK_OVERRIDES
import kvfx
import config

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
TABLE = os.path.join(ROOT, "build", "kskill_table.j")
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
# KVCT order of the skill -> (base ability with autocast, order, list of fields to zero out)
AUTO = {
    "blackarrow": (b"ANba", "blackarrow", [(b"Hba1", 2, 0., 1), (b"Hba2", 3, "", 2), (b"Hba3", 2, 0., 3), (b"abuf", 3, "Bdba,Bdba,Bdba", 0)]),
    "poisonarrowstarg": (b"AEpa", "poisonarrowstarg", [(b"Poa1", 2, 0., 1), (b"Poa2", 2, 0., 2), (b"Poa3", 2, 0., 3), (b"Poa4", 2, 0., 4), (b"Poa5", 2, 0., 5), (b"abuf", 3, "Bpoa,Bpoa,Bpoa", 0)]),
    "coldarrows": (b"AHca", "coldarrows", [(b"Hca1", 2, 0., 1), (b"Hca2", 2, 0., 2), (b"Hca3", 2, 0., 3), (b"Hca4", 2, 0., 4), (b"abuf", 3, "Bhea,Bhea,Bhea", 0)]),
}
# Q W E of every sect: autocast on attacks (right click turns it on / off), whatever KVCT's own order is;
# kskill.j zzKS_OnHit finds the skill by the buff its hit leaves (Bdba Q, Bpoa W, Bhea E)
AUTO_KEY = {"Q": AUTO["blackarrow"], "W": AUTO["poisonarrowstarg"], "E": AUTO["coldarrows"]}
# numbers read from KVCT's own skill code (docs\kvct_skills.md), per KVCT ability:
# kind = template, dur = buff seconds, stats = [(stat of zzVL_af, base, per rank), ...]
OVR = {

    # Thien Vuong Dao (TVD): read from KVCT's code; A01M A01R A01W A01Z A0WA are shared with TVT / TVC
    "A031": {"kind": 16, "rad": 130, "max": 7, "st": 1, "ch": 30, "sd": 1},   # Q er4: splash 130 at the target
    "A032": {"kind": 0, "stats": [5, 3]},                    # Thien Vuong Dao Phap: chinh xac, vat cong %, chi mang
    # R eOV / eO2: dash <= 700, no damage; around the end (200, at most 7) (30+6/rank)% dinh than 3 s and
    # (30+5/rank)% tho thuong 2 s; then 2 s free of control (Thua Phong Pha Lang)
    "A01M": {"kind": 3, "nodmg": 1, "st": 2, "ch": 30, "chr": 6, "sd": 3, "st2": 1, "ch2": 30, "chr2": 5, "sd2": 2,
             "selfimm": 2},
    # Kinh Loi Pha Thien: sinh luc toi da; at 40% life (45%): immune to damage and control 8 s, every 80 s
    "A01R": {"onhurt": 1, "kind": 0, "stats": [7], "fx": 1024, "low": (8, 80, 0, 8, 45)},
    # D JKl: heroes of the side within 1000 (allies 60%): vat cong +70+30/rank, chi mang, 300 s
    "A01W": {"kind": 7, "dur": 300, "stats": [(12, 70, 30), 3]},
    "A01Z": {"kind": 0, "stats": [5]},                       # Thien Canh Chien Khi: phat huy luc tan cong
    # W eH3: 2 hits 0.25 s apart, splash 120 where the target stood, at most 7, 35% tho thuong 1 s
    "A033": {"kind": 16, "hits": 2, "gap": .25, "rad": 120, "max": 7, "st": 1, "ch": 35, "sd": 1},
    "A034": {"kind": 0, "stats": [6]},                       # Tinh Tam Quyet: khang tat ca, sinh khi
    # Phi Tinh Tram Thich: attacking, 80%: chi mang + phat huy luc tan cong 20 s, every 40 s
    "A035": {"kind": 0, "stats": [3, 5], "proc": 80, "pcd": 40, "dur": 20},
    # F JeJ: (8+rank) s immune to every status, chi mang + sat thuong chi mang; cooldown 40
    "A03A": {"kind": 8, "dur": 8, "durr": 1, "stats": [3]},
    # E eAg / eAM: 3 blades every 1/6 s flying 450 on from the target (width 150), at most 7 each, 40% tho thuong
    "A03D": {"wid": 150, "kind": 5, "hits": 3, "gap": .17, "rad": 450, "max": 7, "fromtgt": 1, "st": 1, "ch": 40, "sd": 1},
    # Bat Phong Tram: sinh luc toi da; E 50%: 2 more blades
    "A03E": {"kind": 0, "stats": [7], "link": 2, "xw": 2, "xc": 50},
    "A0WA": {"kind": 0, "stats": [3]},                       # Thien Ma Hanh Khong (slot 14): chi mang

    # Thien Vuong Thuong (TVT): read from KVCT's code; A01M A01R A01W A01Z A0WA as in TVD
    # Q Jow: splash 100 where the target stood, at most 7, 30% tho thuong 1 s
    "A01O": {"kind": 16, "rad": 100, "max": 7, "st": 1, "ch": 30, "sd": 1},
    "A01K": {"kind": 0, "stats": [5, 3]},                    # Thien Vuong Thuong Phap: chinh xac, vat cong %, chi mang
    # W Jsu: 3 thrusts 1/6 s apart, splash 120 where the target stood, at most 7, 35% tho thuong 1 s
    "A020": {"kind": 16, "hits": 3, "gap": .17, "rad": 120, "max": 7, "st": 1, "ch": 35, "sd": 1},
    # F Jag / JaA: 7 dashes 0.3125 s apart to enemies within 1000 not hit yet, 100% tho thuong 2 s; immune to
    # damage and control meanwhile
    "A021": {"kind": 11, "st": 1, "ch": 100, "sd": 2},
    # Lien Hoan Doat Menh: every hit +1 tang (phat huy luc tan cong +3%), 8 s, at most rank + 5
    "A022": {"kind": 0, "stats": [], "fx": 8192, "stk": (5, 1, 8, 3)},   # KVCT: +3% each, 8 s, at most rank + 5
    # T egC / egx: (8 + rank) s immune to tho thuong / dinh than / cham / choang / day lui / keo; cooldown 40
    "A026": {"kind": 8, "dur": 8, "durr": 1},
    # E JaG: 4 thrusts 0.125 s apart, splash 270, at most 7, 40% tho thuong 1 s
    "A01N": {"kind": 16, "hits": 4, "gap": .13, "rad": 270, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # Huyet Chien Bat Phuong: sinh luc; E 75%: a spear flies 900 (width 150)
    "A029": {"pch": (75, 0), "pmul": (100, 0), "kind": 0, "stats": [7], "link": 2, "lfx": 65536},

    # Thuy Yen Kiem (TYK): read from KVCT's code; A0BO A0BQ as in TYD
    # Q eQJ: one sword qi flies 750 (width 100), at most 7, 30% cham 2 s
    "A0BM": {"wid": 100, "kind": 5, "rad": 750, "max": 7, "st": 4, "ch": 30, "sd": 2},
    "A0BN": {"kind": 0, "stats": [5, 3, 4]},                 # Thuy Yen Kiem Phap: bang cong %, chi mang, toc danh
    # R edt: 8 shards fly out 500 (width 110, at most 4 each), 0.6 s later 8 more fly in from a ring of 640 with 80% cham
    # 4 s; 4 s free of control for the hero
    "A0BP": {"wid": 110, "kind": 5, "fan": 8, "spread": 45, "hits": 2, "gap": .6, "rad": 500, "max": 4, "st": 4, "ch": 80, "sd": 4, "selfimm": 4},
    "A0BT": {"kind": 0, "stats": [5, 14]},                   # Bang Cot Tuyet Tam: phat huy luc tan cong, ti le cham
    # W edc: one sword qi flies 912 (width 100), at most 7; every enemy hit takes a second blow 0.3 s later; 35% cham 2 s
    "A0BU": {"wid": 100, "kind": 5, "hits": 2, "gap": .3, "rad": 912, "max": 7, "st": 4, "ch": 35, "sd": 2},
    # D eHA: at a point <= 740: every 0.3 s for 7.8 s (26 hits), radius 300, at most 7: 50% cham 3 s, 50% dinh than 1 s
    "A0BV": {"kind": 13, "hits": 26, "gap": .3, "rad": 300, "far": 740, "max": 7, "st": 4, "ch": 50, "sd": 3, "st2": 2, "ch2": 50, "sd2": 1},
    "A0BW": {"kind": 0, "stats": [5, 13]},                   # Phu Van Tan Tuyet: vat cong noi, ne tranh, phat huy luc tan cong
    # F edD: toggle: bang cong +(160 + 20/rank)%, life regeneration; every attacker takes (1000 + 200/rank) bang cong back
    "A0BX": {"kind": 6, "dur": 300, "stats": [(5, 40, 5)]},
    # E Jsw: a sword qi flies 1100 (width 220), at most 7, 40% cham 2 s; every enemy hit takes 3 more blows 0.25 s apart
    "A0BY": {"wid": 220, "kind": 5, "hits": 4, "gap": .25, "rad": 1100, "max": 7, "st": 4, "ch": 40, "sd": 2},
    "A0BZ": {"kind": 0, "stats": [14]},                      # Thap Dien Mai Phuc: khang ti le trang thai (E calls Phi Tu Phieu Hoa: not done)
    "A0WY": {"kind": 0, "stats": [5, 7]},                    # Tuyet Anh Hong Tran: sat thuong he Hoa, hoi phuc (ice blows on hit: not done)
    # Tieu Dao Kiem (TDK): read from KVCT's code
    # Q JsY: 1 sword qi (2 side by side from rank 3, 3 from rank 6) flies 600 (width 110) through everyone; 30% bong 2 s
    # and 30% tho thuong 0.5 s
    "A0GE": {"wid": 110, "kind": 5, "fan": 2, "spread": 5, "fangrow": 1, "rad": 600, "st": 5, "ch": 30, "sd": 2, "st2": 1, "ch2": 30, "sd2": .5},
    "A0GS": {"kind": 0, "stats": [5, 3, 4]},                 # Tieu Dao Kiem Phap: chinh xac, hoa cong %, chi mang, toc danh
    # R e_Q: a field at a point <= 640: every 1 s for 10 s, radius 350, at most 7: 50% dinh than 1.5 s, 50% bong 2.5 s
    "A0GV": {"kind": 13, "hits": 10, "gap": 1, "rad": 350, "far": 640, "max": 7, "st": 2, "ch": 50, "sd": 1.5, "st2": 5, "ch2": 50, "sd2": 2.5},
    # Chan Hoa Ho The: sinh luc toi da, ne tranh; hit under 50% life: hon loan around, 5 s immune, every 30 s
    "A0GW": {"kind": 0, "stats": [7, 13], "fx": 1024, "low": (0, 30, 0, 5, 100), "lowat": 50},
    # F eik: heroes of the side within 1000, 30 s: khang phan don, khang thoi gian trang thai
    "A0GZ": {"kind": 7, "dur": 30, "stats": [14, 6]},
    "A0GT": {"kind": 0, "stats": [5, 14]},                   # Doan Ca Hanh: phat huy luc tan cong, ti le bong, khang tho thuong
    # W JCk: 3 blades 0.2 s apart (the 2nd and 3rd +-12 degrees) fly 600 (width 120), at most 7 each; 35% tho thuong 0.5 s
    # and 35% bong 2 s
    "A0GF": {"wid": 120, "kind": 5, "hits": 3, "gap": .2, "rad": 600, "max": 7, "st": 1, "ch": 35, "sd": .5, "st2": 5, "ch2": 35, "sd2": 2},
    # D eqW: a field at a point <= 640: every 0.3 s for 7.5 s, radius 480, at most 7, 50% tho thuong 1 s
    "A0GU": {"kind": 13, "hits": 25, "gap": .3, "rad": 480, "far": 640, "max": 7, "st": 1, "ch": 50, "sd": 1},
    "A0H0": {"kind": 0, "stats": [7]},                       # Binh Nhuoc Quan Hoa: R heals 8% + 2%/rank per s (not done)
    "A0H1": {"kind": 0, "stats": [5, 13]},                   # Ngang Nhat Do: hoa cong, toc chay, ne tranh
    # E J4A: 4 swords side by side 0.15 s apart fly 800 (width 120), at most 7 each; 40% tho thuong 0.5 s and 40% bong 2 s
    "A0GG": {"wid": 120, "kind": 5, "hits": 4, "gap": .15, "rad": 800, "max": 7, "st": 5, "ch": 40, "sd": 2, "st2": 1, "ch2": 40, "sd2": .5},
    # Phan Phach Tru Tam: chi mang; E 75%: Kiem Ngam swords around the target (3 more blows here)
    "A0H2": {"kind": 0, "stats": [3], "link": 2, "xw": 3, "xc": 75},
    "A0XB": {"kind": 0, "stats": [5]},                       # Hoa Hai Vo Nhai: sat thuong he Kim (fire damage on E: not done)
    # Tieu Dao Chuong (TDC): read from KVCT's code
    # Q JD6: 2 blows 0.2 s apart where the target stood, radius 150, at most 7, 30% bong 2 s
    "A0H5": {"kind": 16, "hits": 2, "gap": .2, "rad": 150, "max": 7, "st": 5, "ch": 30, "sd": 2},
    "A0HI": {"kind": 0, "stats": [5, 3, 4]},                 # Tieu Dao Chuong Phap: hoa cong %, chi mang, toc danh
    # R eAU: one random enemy within 1200 is chased and held: 90% dinh than 3 s, 1 + 3 blows every 1 s
    "A0HK": {"kind": 17, "hits": 4, "gap": 1, "rad": 1200, "max": 1, "st": 2, "ch": 90, "sd": 3},
    # Suu Hon Dai Phap: ne tranh; hit under 50% life: 400 around, hon loan + 7 blows, life steal (not done)
    "A0HL": {"kind": 0, "stats": [13]},
    # Diem Nguyen Luan Hoi: every 10 s a buff of 8 s: damage taken (35 + 5/rank)% less
    "A0HO": {"kind": 0, "stats": [(6, 35, 5)], "proc": 100, "pcd": 10, "dur": 8},
    "A0HJ": {"kind": 0, "stats": [5, 14]},                   # Phuc Nhat Xuat Van: phat huy luc tan cong, ti le bong, khang tho thuong
    # W J4S: 3 blows 0.2 s apart where the target stood, radius 250, at most 7, 35% bong 2 s
    "A0H6": {"kind": 16, "hits": 3, "gap": .2, "rad": 250, "max": 7, "st": 5, "ch": 35, "sd": 2},
    # D eiK: at a point <= 800: 15 waves 0.2 s apart of 3 talismans flying out 800 (width 100), 50% bong 2 s
    "A0HQ": {"kind": 13, "hits": 15, "gap": .2, "rad": 450, "far": 800, "max": 7, "st": 5, "ch": 50, "sd": 2},
    "A0HR": {"kind": 0, "stats": [6, 14]},                   # Hon Nhat Khi Quyet: giam sat thuong ngu hanh (Bat Hoang Luc Hop stacks: not done)
    # F J0Q: 15 s: toc chay +30; every 0.5 s 3 enemies are chased, burst 150 (at most 4), 15% of the damage as life
    "A0HS": {"kind": 18, "hits": 30, "gap": .5, "rad": 800, "max": 3, "fx": 4, "steal_pct": 15},
    # E J4Q: 3 palms chase the target 1000 (width 160), at most 7 each, 40% bong 2 s
    "A0H7": {"wid": 160, "kind": 5, "fan": 3, "spread": 10, "rad": 1000, "max": 7, "st": 5, "ch": 40, "sd": 2},
    # Thai Hu Than Cong: hoa cong %; E 75%: Bai Van Chuong, a burst around the target (200)
    "A0HT": {"kind": 0, "stats": [5], "link": 2, "xw": 1, "xc": 75},
    # T Jfb: jump <= 700 (immune on the way); on landing 4 s: chi mang +(265 + 35/rank), sat thuong chi mang
    "A0XG": {"kind": 3, "rad": 700, "nodmg": 1, "selfbuf": 1, "dur": 4, "stats": [(3, 26, 4)]},
    # Hoa Son Kiem (HSK): read from KVCT's code; A0KZ as in HSQ. Only Q and W are autocast (E is a skill to press)
    # Q J46: 2 blows 0.24 s apart where the target stood, radius 150, at most 7, 30% choang 0.5 s
    "A0L6": {"kind": 16, "hits": 2, "gap": .24, "rad": 150, "max": 7, "st": 3, "ch": 30, "sd": .5},
    "A0LH": {"kind": 0, "stats": [5, 3, 4]},                 # Kiem Tong Tong Quyet: chinh xac, loi cong %, chi mang, toc danh
    # E JKF: at the cursor point <= 600: 10 blows 0.3 s apart, radius 300, at most 7, 40% choang 0.5 s
    "A0LO": {"kind": 13, "hits": 10, "gap": .3, "rad": 300, "far": 600, "max": 7, "st": 3, "ch": 40, "sd": .5},
    # R eSU: 20 s: toc danh +(8 + rank), ne tranh, immune to hon loan / cham; Kiem Vu stacks (not done)
    "A0LP": {"kind": 6, "dur": 20, "stats": [(4, 8, 1), 14]},
    "A0LI": {"kind": 0, "stats": [5, 14]},                   # Hi Di Kiem Phap: phat huy luc tan cong, ti le choang, khang cham
    # W Js2: 3 knives 1/6 s apart side by side fly 600 (width 110) through up to 7 enemies each, 35% choang 0.5 s
    "A0L7": {"wid": 110, "kind": 5, "hits": 3, "gap": .17, "rad": 600, "max": 7, "st": 3, "ch": 35, "sd": .5},
    "A0LJ": {"kind": 0, "stats": [6, 14]},                   # Thai Nhac Tam Thanh: ne tranh noi cong, hoa giai trang thai
    # D eOy: toggle: every 6 s a 3 s boost of (13 + 2/rank)% damage (a smaller steady buff here)
    "A0LK": {"kind": 6, "dur": 300, "stats": [(5, 7, 1)]},
    # Pha Kiem Thuc: on Q / W (every 5 s): 3 blows 0.5 s apart around the hero, radius 350, at most 7, 5% back as life
    "A0LN": {"kind": 4, "hits": 3, "gap": .5, "rad": 350, "max": 7, "fx": 4, "steal_pct": 5},
    # Cuu Kiem Hop Nhat: on Q / W (every 4 s): 9 swords (every 40 degrees) fly and chase, 50% choang 1 s
    "A0LL": {"kind": 5, "fan": 9, "spread": 40, "rad": 800, "max": 7, "st": 3, "ch": 50, "sd": 1},
    "A0LM": {"kind": 0, "stats": [3]},                       # Nhat Kiem Pha Van Phap: chi mang (Cuu Kiem +%, life steal 5%: not done)
    "A0XS": {"kind": 0, "stats": [4]},                       # Doc Co Cuu Kiem: toc danh, sat thuong he Thuy (finishing blow: not done)
    # Hoa Son Khi (HSQ): read from KVCT's code
    # Q JEM: 2 blows 0.2 s apart where the target stood, radius 150, at most 7, 30% choang 1 s
    "A0KJ": {"kind": 16, "hits": 2, "gap": .2, "rad": 150, "max": 7, "st": 3, "ch": 30, "sd": 1},
    "A0KM": {"kind": 0, "stats": [5, 3, 4]},                 # Hoa Son Khi Cong: loi cong %, chi mang, toc danh
    "A0KZ": {"kind": 0, "stats": [13, 14]},                  # Long Nhieu Than: toc chay, khang cham, khang bang
    # R elj: 5 s: damage taken (35 + 5/rank)% less, statuses resisted; at the end 100% choang 3 s within 500 (not done)
    "A0L0": {"kind": 8, "dur": 5, "stats": [(6, 35, 5)]},
    "A0L1": {"kind": 0, "stats": [5, 14]},                   # Hai Nap Bach Xuyen: loi cong %, khang trang thai (full mana)
    "A0KN": {"kind": 0, "stats": [5, 14]},                   # Khi Chan Son Ha: phat huy luc tan cong, ti le choang, khang cham
    # W e1L: 0.64 s after, radius 300, at most 7, 35% choang 1 s; then Ma Van Khi Cong: 3 more blows every 0.5 s
    # (no choang)
    "A0KK": {"kind": 16, "hits": 4, "gap": .5, "rad": 300, "max": 7, "st": 3, "ch": 35, "sd": 1, "st2": 3, "ch2": 0, "sd2": 1},
    "A0L4": {"kind": 0, "stats": [5]},                       # Khi Quan Truong Hong: more skill damage with more mana
    # D JfU: 20 s: loi cong +(0.8 + 0.2/rank) (a burst of mana here), mana back every second, immune to 4 statuses
    "A0L3": {"kind": 8, "dur": 20, "stats": [(5, 50, 10)], "fx": 4096},
    "A0L2": {"kind": 0, "stats": [6]},                       # Huyen Nhan Yen Van: giam sat thuong (full mana)
    # E eZN: radius 240 at the target, at most 7, 40% choang 1 s; every enemy then takes 3 single hits 0.2 s apart
    "A0KL": {"kind": 16, "hits": 4, "gap": .2, "rad": 240, "max": 7, "st": 3, "ch": 40, "sd": 1},
    "A0KX": {"kind": 0, "stats": [14]},                      # Than Quang Toan Nhieu: khang thoi gian trang thai (E: Long Huyen Kiem Khi not done)
    "A0XP": {"kind": 0, "stats": [5], "fx": 4096},           # Tu Khi Dong Lai: loi cong %, mana back (after R: not done)
    # Co Mo Kiem (CMK): read from KVCT's code
    # Q JhM: a sword qi flies 832 (width 100) through everyone and comes back (2 passes, ~0.8 s apart), 30% choang 1 s
    "A0ML": {"wid": 100, "kind": 5, "hits": 2, "gap": .81, "rad": 832, "st": 3, "ch": 30, "sd": 1},
    "A0MO": {"kind": 0, "stats": [5, 3, 4]},                 # Kiem Mo Phap: chinh xac, loi cong %, chi mang, toc danh
    # R egz: at a point <= 800, radius 250, ticks at 2 4 6 8 s, at most 7: (36 + 4/rank)% choang 1.5 s
    "A0MZ": {"kind": 13, "hits": 4, "gap": 2, "rad": 250, "far": 800, "max": 7, "st": 3, "ch": 36, "chr": 4, "sd": 1.5},
    "A0N7": {"kind": 0, "stats": [7]},                       # Tinh Anh Tram Bich: noi luc -> sinh luc (every 60 s: not done)
    # Mo Van Ngung Bich: hit under 50% life: a shield of (0.6 + 0.2/rank) x max mana for 5 s (a heal here), every 10 s
    "A0N8": {"kind": 0, "stats": [5], "fx": 1024, "low": (0, 10, 30, 0, 100), "lowat": 50},
    "A0MP": {"kind": 0, "stats": [5, 14]},                   # Ngoc Nu Kiem Phap: phat huy luc tan cong, ti le choang, khang cham
    # W JFb: like Q, 832 (width 180), 35% choang 1 s
    "A0MM": {"wid": 180, "kind": 5, "hits": 2, "gap": .81, "rad": 832, "st": 3, "ch": 35, "sd": 1},
    # D JD4: a sword qi flies 952 (width 120) through up to 7 enemies, 3 hits each, 50% choang 1 s; spends 2 Tuyet
    "A0N2": {"wid": 120, "kind": 5, "hits": 3, "gap": .17, "rad": 952, "max": 7, "st": 3, "ch": 50, "sd": 1},
    # Han Son Doc Lap: every Q W E +1 Cam (chi mang, sat thuong), 5 Cam cast D by itself (stacks on hits here)
    "A0N3": {"kind": 0, "stats": [], "fx": 8192},
    # F eH8: 12 s: (25 + 5/rank)% of the damage taken is shrugged off (at most 36% of life), immune to 5 statuses
    "A0N6": {"kind": 8, "dur": 12, "stats": [(6, 25, 5)]},
    # E Jhe: a sword qi flies 900 (width 200) through everyone and comes back, 40% choang 1 s
    "A0MN": {"wid": 200, "kind": 5, "hits": 2, "gap": .94, "rad": 900, "st": 3, "ch": 40, "sd": 1},
    # Ngoc Nu Tam Kinh: chi mang; E 65%: Pha Mong Hanh, 3 more blows around the first enemy
    "A0MY": {"kind": 0, "stats": [3, 6], "link": 2, "xw": 3, "xc": 65},
    "A0XW": {"kind": 0, "stats": [3, 14]},                   # Bach Van Hoi Vong: chi mang, mien cham (E return stronger: not done)
    # Co Mo Cham (CMC): read from KVCT's code (A0ML A0MM A0MN A0N2 A0N6 A0MZ are Co Mo Kiem's)
    # Q Jav: 2 needles 0.2 s apart fly 250 (width 90), at most 7 each, 30% choang 1 s
    "A0LS": {"wid": 90, "kind": 5, "hits": 2, "gap": .2, "rad": 250, "max": 7, "st": 3, "ch": 30, "sd": 1},
    "A0LV": {"kind": 0, "stats": [5, 3, 4]},                 # Mo Cham Phap: loi cong %, chi mang, toc danh
    # R Jkl: dash <= 720, at the start radius 350, at most 10: 80% dinh than 2 s; then 6 volleys of needles (not done)
    "A0M8": {"kind": 3, "rad": 720, "st": 2, "ch": 80, "sd": 2},
    # Suc The Doi Phat: every 5 s a buff of 5 s: more damage of the next 3 skills, less damage taken
    "A0ME": {"kind": 0, "stats": [5, 6], "proc": 100, "pcd": 5, "dur": 5},
    # D Jxu: 7 needles 0.08 s apart in a fan of +-24 degrees, 600 (width 120), at most 7 each, 40% choang 1 s;
    # needs 2 Thon Tu stacks (not done)
    "A0MA": {"wid": 120, "kind": 5, "fan": 7, "spread": 8, "rad": 600, "max": 7, "st": 3, "ch": 40, "sd": 1},
    "A0LW": {"kind": 0, "stats": [5, 14]},                   # Luu Van Phap: phat huy luc tan cong, ti le choang, khang cham
    # W Jxa: 3 volleys 0.2 s apart fly 384 (width 100), at most 7 each, 35% choang 1 s
    "A0LT": {"wid": 100, "kind": 5, "hits": 3, "gap": .2, "rad": 384, "max": 7, "st": 3, "ch": 35, "sd": 1},
    # F Joc: 5 s, every 0.25 s radius 360 around the hero, at most 7: 30% choang 1 s (20 hits)
    "A0MC": {"kind": 4, "hits": 20, "gap": .25, "rad": 360, "max": 7, "st": 3, "ch": 30, "sd": 1},
    "A0MF": {"kind": 0, "stats": [5]},                       # Hanh Van Doi Vu: loi cong % (ne tranh when Thon Tu is spent: not done)
    # T JJo: toggle: Q W E D hit one enemy only, chi mang +(175 + 25/rank), sat thuong chi mang (one buff here)
    "A0MD": {"kind": 6, "dur": 300, "stats": [(3, 18, 3)]},
    # E Jay: 3 volleys 0.2 s apart fly 400 (width 100), at most 7 each, 40% choang 1 s
    "A0LU": {"wid": 100, "kind": 5, "hits": 3, "gap": .2, "rad": 400, "max": 7, "st": 3, "ch": 40, "sd": 1},
    "A0M7": {"kind": 0, "stats": [5, 3]},                    # Phong Luu Van Tan: loi cong %, chi mang (Luu Quang Tu Xa on E: not done)
    "A0XT": {"kind": 0, "stats": [4, 13]},                   # Me Than Dan: toc danh, ne tranh (enemies near deal 20% less: not done)
    # Doan Thi Chi (DTC): read from KVCT's code
    # Q JCC: 2 blows 0.2 s apart where the target stood, radius 100, at most 7, 30% tho thuong 0.5 s and 30% cham 1 s
    "A0DB": {"kind": 16, "hits": 2, "gap": .2, "rad": 100, "max": 7, "st": 1, "ch": 30, "sd": .5, "st2": 4, "ch2": 30, "sd2": 1},
    "A0DE": {"kind": 0, "stats": [5, 3]},                    # Doan Thi Chi Phap: chinh xac, bang cong %, chi mang
    # R enA: one finger flies 900 (width 150) through up to 7 enemies, 80% dinh than 3 s, ignores dodge
    "A0DO": {"wid": 150, "kind": 5, "rad": 900, "max": 7, "st": 2, "ch": 80, "sd": 3},
    # F erd: 15 s: toc chay +(45 + 5/rank), ne tranh noi / ngoai cong, immune to tho thuong / cham
    "A0DQ": {"kind": 6, "dur": 15, "stats": [(13, 45, 5), 14]},
    # Tu Bi Quyet: hit under 50% life: Lang Ba Vi Bo for 15 s (not done), every 60 s
    "A0DR": {"kind": 0, "stats": []},
    "A0DF": {"kind": 0, "stats": [5, 14]},                   # Kim Ngoc Chi Phap: phat huy luc tan cong, ti le cham, khang bong
    # W JaN: 3 blows 1/6 s apart around the hero, radius 250, at most 7, 35% tho thuong 0.5 s and 35% cham 1 s
    "A0DC": {"kind": 4, "hits": 3, "gap": .17, "rad": 250, "max": 7, "st": 1, "ch": 35, "sd": .5, "st2": 4, "ch2": 35, "sd2": 1},
    # D egt: 9 ice needles every 0.25 s chase the target, each bursts radius 180, 80% cham 3 s
    "A0DU": {"kind": 16, "hits": 9, "gap": .25, "rad": 180, "st": 4, "ch": 80, "sd": 3},
    "A0DP": {"kind": 0, "stats": [3]},                       # Dieu De Chi: R gives chinh xac / chi mang / phat huy 30 s (not done)
    # Thi Nguyen Quyet: casting Q W E: 30 s immune to dinh than / te liet / hon loan / day keo, every 30 s
    "A0DV": {"kind": 0, "stats": [5, 6], "proc": 100, "pcd": 30, "pimm": 29.9},
    # E JCN: 3 blows 1/6 s apart where the target stood, radius 150, at most 7, 40% tho thuong 0.5 s and 40% cham 1 s
    "A0DD": {"kind": 16, "hits": 3, "gap": .17, "rad": 150, "max": 7, "st": 1, "ch": 40, "sd": .5, "st2": 4, "ch2": 40, "sd2": 1},
    # Can Thien Chi Phap: E 30%: more damage and ignores dodge for 10 s
    "A0DX": {"pch": (100, 0), "pmul": (18, 2), "kind": 0, "stats": [6], "link": 2, "lfx": 65536},
    "A0X4": {"kind": 0, "stats": [5]},                       # Bach Bo Xuyen Duong: sat thuong he Hoa (R diem huyet: not done)
    # Minh Giao Kiem (MGK): read from KVCT's code
    # Q JEv: a fire field at the target, 4 pulses 1 s apart, radius 150, at most 7, 30% dinh than 0.5 s, poison
    "A08W": {"kind": 13, "hits": 4, "gap": 1, "rad": 150, "max": 7, "st": 2, "ch": 30, "sd": .5, "fx": 8},
    "A08X": {"kind": 0, "stats": [3, 4]},                    # Minh Giao Kiem Phap: doc cong, chi mang, toc danh
    "A08Y": {"kind": 0, "stats": [13]},                      # Di Khi Phieu Tung: toc chay, ne tranh noi cong
    # W JFk: at a point <= 740: 2 bursts 0.2 s apart (radius 200, damage only), then 6 flames fly 600: 50% dinh than 2 s
    "A08Z": {"kind": 13, "hits": 2, "gap": .2, "rad": 200, "far": 740, "max": 7, "st": 2, "ch": 50, "sd": 2, "fx": 8},
    # D ely: 15 s: (8 + 2/rank)% of the damage as life, immune to choang / dinh than
    "A090": {"kind": 8, "dur": 15, "stats": [(1, 8, 2)]},
    "A093": {"kind": 0, "stats": [5, 14]},                   # Ly Hoa Dai Phap: phat huy luc tan cong, ti le dinh than, khang choang
    # E JCp: at a point <= 740: radius 400, at most 10, 35% dinh than 1 s, poison 5 ticks
    "A094": {"psec": 5, "kind": 13, "hits": 1, "gap": .6, "rad": 400, "far": 740, "max": 10, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    # F JEh: 7 + 0.5/rank s: the cooldown of W / E / R is 0.3 s (not done)
    "A095": {"kind": 6, "dur": 8, "stats": []},
    "A098": {"kind": 0, "stats": [5]},                       # Nhan Huan Tu Khi: doc cong (W / E cooldown shorter: not done)
    # Hoang Hoa Ngoc Phan: (8 + rank)% of the poison ticks do x (1.27 + 0.03/rank)
    "A099": {"pch": (8, 1), "pmul": (27, 3), "kind": 0, "stats": [], "link": 3, "lfx": 65536},
    # R Jkw: at a point <= 740: 3 hits 0.2 s apart, radius 500, at most 10, 40% dinh than 1 s, poison on the last
    "A09A": {"kind": 13, "hits": 3, "gap": .2, "rad": 500, "far": 740, "max": 10, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    "A09B": {"kind": 0, "stats": [5]},                       # Thanh Hoa Than Cong: doc sat gay ra, R cooldown shorter
    "A0WU": {"kind": 0, "stats": [5]},                       # Muc Da Ung Duong: sat thuong he Tho, noi cong, thoi gian doc
    # Minh Giao Chuy (MGC): read from KVCT's code; A08Z A090 A094 below are Minh Giao Kiem's
    # Q e6L: burst 150 at the target, no limit, 30% tho thuong 1 s, poison 2 ticks
    "A09M": {"psec": 2, "kind": 16, "rad": 150, "st": 1, "ch": 30, "sd": 1, "fx": 8},
    "A09N": {"kind": 0, "stats": [3, 5]},                    # Minh Giao Chuy Phap: chinh xac, doc cong, chi mang
    # R e6Q: dash <= 700 (hits 150 on the way); at the end radius 200, at most 7: 50% dinh than 2 s + poison 4 ticks
    "A09O": {"psec": 4, "kind": 3, "rad": 700, "st": 2, "ch": 50, "sd": 2, "fx": 8},
    # T eS6: heroes of the side within 1000 (allies 60%), 300 s: chi mang +(16 + 8/rank), sat thuong chi mang
    "A09P": {"kind": 7, "dur": 300, "stats": [(3, 16, 8)]},
    # D eZ5: a hammer flies 960 (width 150) through up to 7 enemies, 80% dinh than 2 s, +25% damage on each next
    # enemy, poison 4 ticks
    "A09Q": {"psec": 4, "wid": 150, "kind": 5, "rad": 960, "max": 7, "st": 2, "ch": 80, "sd": 2, "fx": 8},
    "A09R": {"kind": 0, "stats": [5, 6]},                    # Ngu Ma Thuat: phat huy luc tan cong, khang tat ca
    # W etU: 0.3 s after, a burst 100 in front of the hero, radius 240, no limit, 35% tho thuong 1 s, poison 2 ticks
    "A09S": {"psec": 2, "kind": 4, "rad": 240, "st": 1, "ch": 35, "sd": 1, "fx": 8},
    # F egU: 6 s: phat huy luc tan cong +(12 + 3/rank)%; 5 hammers 1000 make the enemies deal 30% less for 10 s
    "A09T": {"kind": 6, "dur": 6, "stats": [(5, 12, 3)], "weak": (20, 10, 1000)},   # KVCT -30%, map caps 20%
    # Cuu Hi Hon Duong: hit at 50% life: heal and immune to some statuses, every 30 s
    "A09U": {"kind": 0, "stats": [], "fx": 1024, "low": (0, 30, 40, 3, 100), "lowat": 50},
    "A09X": {"kind": 0, "stats": [7]},                       # Liet Diem Thao Thien: sinh luc toi da (ne tranh, Dia Liet: not done)
    # E eqc: 2 sweeps 0.25 s apart 150 in front of the hero, radius 280, at most 7, 40% tho thuong 1 s; poison on the 2nd
    "A09Z": {"kind": 4, "hits": 2, "gap": .25, "rad": 280, "max": 7, "st": 1, "ch": 40, "sd": 1, "fx": 8},
    "A0A0": {"kind": 0, "stats": [6]},                       # Tran Nguc Pha Thien Kinh: giam sat thuong ngu hanh
    "A0WV": {"kind": 0, "stats": [5, 14]},                   # Khong Tuyet Tam Phap: vat cong, hoa giai trang thai
    # Nga My Kiem (NMK): read from KVCT's code
    # Q J30: 2 knives 0.2 s apart fly 600 (width 100) through up to 7 enemies each, 30% cham 2 s
    "A0A5": {"wid": 100, "kind": 5, "hits": 2, "gap": .2, "rad": 600, "max": 7, "st": 4, "ch": 30, "sd": 2},
    # R Jf6: allies (heroes) within 500 get (6 + rank)% of the caster's life every second for 4 s (one burst here)
    "A0A6": {"kind": 7, "dur": 4, "stats": [], "fx": 16},
    # D J0S: heroes of the side within 1000 (allies 60%), 1200 s: the effects of Mong Diep, Phat Tam, Ba La,
    # Thanh Am, Thanh Tam (each at most the rank of D)
    "A0A7": {"kind": 7, "dur": 1200, "stats": [(6, 20, 3), 7]},
    "A0AA": {"kind": 0, "stats": [5]},                       # Mong Diep: bang cong %, hoi phuc sinh luc / noi luc
    # Phat Tam Tu Huu: sinh luc toi da; hit under 40% life: heal 100%, 4 s free of control, every 45 s
    "A0AB": {"kind": 0, "stats": [7], "fx": 1024, "low": (0, 45, 100, 4, 100), "lowat": 40},
    "A0AG": {"kind": 0, "stats": [5, 14]},                   # Ba La Tam Kinh: phat huy luc tan cong, ti le cham
    "A0AH": {"kind": 0, "stats": [14]},                      # Thanh Am Phan Xuong: khang thoi gian trang thai
    "A0AI": {"kind": 0, "stats": [6]},                       # Thanh Tam Tinh Khi: giam sat thuong chi mang
    "A0AL": {"kind": 0, "stats": [4, 5]},                    # Lien Hoa Tam Kinh: toc danh, bang cong %, phat huy
    # W eqw: 3 knives 0.15 s apart fly 900 (width 165) through up to 7 enemies each, 35% cham 2 s
    "A0AN": {"wid": 165, "kind": 5, "hits": 3, "gap": .15, "rad": 900, "max": 7, "st": 4, "ch": 35, "sd": 2},
    # E ed9: 5 swords (0, +-72, +-144 degrees) turn once to the target, ~1080 (width 150), at most 7 each, 40% cham 2 s
    "A0AO": {"wid": 150, "kind": 5, "fan": 5, "spread": 10, "rad": 1080, "max": 7, "st": 4, "ch": 40, "sd": 2},
    # Do Nguyen Cong: noi cong, sinh khi; E +(10 + 2/rank)% damage and 5% back as life
    "A0AM": {"kind": 0, "stats": [7], "link": 2, "lfx": 4, "steal_pct": 5},
    "A0WW": {"kind": 0, "stats": [4, 3]},                    # Be Nguyet Phat Tran: toc danh, chi mang, vat cong noi
    # Cai Bang Bong (CBB): read from KVCT's code; A0E9 is shared with CBC
    # Q Ja8: a stick bursts at the first enemy: radius 100, no limit, 30% bong 1.5 s and 30% tho thuong 1 s
    "A0EK": {"kind": 16, "rad": 100, "st": 5, "ch": 30, "sd": 1.5, "st2": 1, "ch2": 30, "sd2": 1},
    "A0ER": {"kind": 0, "stats": [5, 3, 4]},                 # Cai Bang Bong Phap: chinh xac, hoa cong, chi mang, toc danh
    "A0ET": {"kind": 0, "stats": [13]},                      # Tieu Dao Cong: ne tranh, khang phan don, toc chay
    # R J4w: 12 sticks every 30 degrees fly 600 (width 100) through every enemy, 50% bong 3 s and 50% tho thuong 1 s
    "A0F0": {"wid": 100, "kind": 5, "fan": 12, "spread": 30, "rad": 600, "st": 5, "ch": 50, "sd": 3, "st2": 1, "ch2": 50, "sd2": 1},
    "A0ES": {"kind": 0, "stats": [5, 14]},                   # Bon Luu Dao Hai: phat huy luc tan cong, ti le bong, khang tho thuong
    # W J0Y: 3 sticks chase the target 1000 (width 100), at most 7 each; the middle one 35% bong 1.5 s, the sides
    # 35% tho thuong 1 s
    "A0EL": {"wid": 100, "kind": 5, "fan": 3, "spread": 6, "rad": 1000, "max": 7, "st": 5, "ch": 35, "sd": 1.5, "st2": 1, "ch2": 35, "sd2": 1},
    # Da Cau Bong Phap: vat cong, tho thuong time; Hoai Thuong 35%: damage x (1.12 + 0.08/rank)
    "A0EU": {"pch": (35, 0), "pmul": (12, 8), "kind": 0, "stats": [5], "link": 3, "lfx": 65536},
    # D e1i: 300 s: ne tranh noi / ngoai cong +(10 + 2/rank)%; used again it only renews
    "A0EX": {"kind": 6, "dur": 300, "stats": [(6, 10, 2)]},
    # Tung Hac Cong: hit at 95% life or less: pushes enemies within 400 back 300, 15 s immune and dodge, every 45 s
    "A0EV": {"kind": 0, "stats": [6], "fx": 1024, "low": (0, 45, 0, 15, 100), "lowat": 95},
    # E JaU / Jal: 3 sticks 1/6 s apart chase the target 1200 (width 110), at most 7 each, each target hit twice per
    # stick; every hit 40% bong 2 s or tho thuong 1 s (one of the two)
    "A0EM": {"wid": 110, "kind": 5, "hits": 3, "gap": .17, "rad": 1200, "max": 7, "st": 5, "ch": 40, "sd": 2, "st2": 1, "ch2": 40, "sd2": 1},
    "A0EW": {"kind": 0, "stats": [6]},                       # Da Cau Tran Phap: giam sat thuong nhan (the 3 s ground field: not done)
    "A0X8": {"kind": 0, "stats": [6]},                       # Hon Thien Khi Cong: khang tat ca, bo qua phong thu

    # Duong Mon Phi Dao (DMPD): read from KVCT's code; A07S A07T A07W as in DMTT; R A08J D A08P below
    # Q Jsy: a knife flies 900 (width 100) through up to 7 enemies, 30% dinh than 1 s, poison 2 ticks
    "A08H": {"psec": 2, "wid": 100, "kind": 5, "rad": 900, "max": 7, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    # W JxA: at the target 3 blows 0.32 s apart, radius 280, at most 7, 35% dinh than 1 s (poison on the last only)
    "A08K": {"kind": 16, "hits": 3, "gap": .32, "rad": 280, "max": 7, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    # Thuc Cot Huyet Nhan: R marks the enemies (Cau Hon 10 s): more damage of W and E (not done)
    "A08M": {"kind": 0, "stats": []},
    # E JFp / JFm: a knife flies 1000 and bursts at the first enemy (180, at most 7), then 3 more bursts 0.1 s apart;
    # 40% dinh than 1 s, poison 2 ticks on the first
    "A08S": {"psec": 2, "kind": 16, "hits": 4, "gap": .1, "rad": 180, "max": 7, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    "A08T": {"kind": 0, "stats": [13]},                      # Tam Phach: ne tranh noi / ngoai cong (E poison 6 ticks: not done)
    "A0WT": {"kind": 0, "stats": [4, 13]},                   # Bach Phat Bach Trung: toc danh, than phap, sinh khi

    # Thien Vuong Chuy (TVC): read from KVCT's code; A01M R and A0WA are shared with TVD / TVT
    # Q eA8: splash 150 where the target stood, at most 7, 35% tho thuong 1 s
    "A02C": {"kind": 16, "rad": 150, "max": 7, "st": 1, "ch": 35, "sd": 1},
    "A02E": {"kind": 0, "stats": [5, 3]},                    # Thien Vuong Chuy Phap: chinh xac, vat cong %, chi mang
    # Thien Vuong Ban Sinh: sinh luc toi da; hit under 40% life (25 + 5/rank %): 10 s immune to damage and
    # control, every 45 s
    "A02F": {"onhurt": 1, "kind": 0, "stats": [7], "fx": 1024, "low": (10, 45, 0, 10, 25), "lowr": (5, 0), "lowat": 40},
    # F eSh: heroes of the side within 1000 (allies 60%): khang 45 + 15/rank, tho thuong time shorter, 300 s
    "A02K": {"kind": 7, "dur": 300, "stats": [(11, 45, 15), 14]},
    "A02N": {"kind": 0, "stats": [5, 14]},                   # Bat Diet Sat Y: phat huy luc tan cong, khang dinh than
    # W J3D: 2 blows 0.24 s apart 100 in front of the hero, radius 220, at most 7, 40% tho thuong 1 s
    "A02O": {"kind": 4, "hits": 2, "gap": .24, "rad": 220, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # D eLJ: dash <= 800; at the end radius 300: 100% tho thuong 2 s, pulled 150 to the centre; then 4 more
    # pulses every 0.5 s (100% tho thuong 1 s)
    "A02P": {"kind": 3, "st": 1, "ch": 100, "sd": 2, "fx": 2, "rad": 800},
    "A02Q": {"kind": 0, "stats": [], "fx": 8192, "onhurt": 2, "stk": (5, 1, 6, 6)},            # Can Khon Chuy: tang phat huy luc tan cong (KVCT: when hit)
    "A02U": {"kind": 0, "stats": [6]},                       # Hoa Kinh Quyet: giam sat thuong nhan
    # E JeC: 3 sweeps 1/6 s apart 120 in front of the hero, radius 220, no limit, 45% tho thuong 1 s
    "A02X": {"kind": 4, "hits": 3, "gap": .17, "rad": 220, "st": 1, "ch": 45, "sd": 1},
    # Dao Hu Thien: sinh luc toi da; E 75%: a blast around the hero (radius 250) at each of its 3 sweeps
    "A02Y": {"kind": 0, "stats": [7], "link": 2, "xw": 3, "xc": 75},

    # Thien Vuong Chuy (TVC)
    "A01S": {"kind": 1, "hits": 3},                          # Hao Hung Tram (strike 3 hits)
    "A02I": {"kind": 4, "hits": 4},                          # Huy Thien Diet Dia (nova 4 hits)

    # Thieu Lam Quyen (TLQ): read from KVCT's code; A03J A03N A03Q are shared with TLD / TLB
    # Q etn: 2 hits 0.2 s apart, splash 120 where the target stood, at most 7, 30% tho thuong 0.5 s
    "A04S": {"kind": 16, "hits": 2, "gap": .2, "rad": 120, "max": 7, "st": 1, "ch": 30, "sd": .5},
    "A04T": {"kind": 0, "stats": [5, 3]},                    # Thieu Lam Quyen Phap: vat cong %, chi mang, toc danh
    "A03J": {"kind": 0, "stats": [7]},                       # Dich Can Kinh: sinh luc toi da
    # R eiz / eiP: enemies within 600 (at most 10): damage, (36 + 4 x rank)% tho thuong 3 s and dinh than 3 s
    "A04U": {"kind": 4, "rad": 600, "max": 10, "st": 1, "ch": 36, "chr": 4, "sd": 3, "st2": 2, "ch2": 36, "chr2": 4,
             "sd2": 3},
    # D elV / elG: 300 s: khang thoi gian tho thuong / dinh than / cham / choang +(17 + 3 x rank)%, khang doc
    "A03N": {"kind": 6, "dur": 300, "stats": [(14, 17, 3)]},
    "A03Q": {"kind": 0, "stats": [5]},                       # Nhu Lai Thien Diep: phat huy luc tan cong
    # W eSG / eSm: 2 blows 0.625 s apart, splash 250 where the target stood, at most 7, 35% tho thuong 0.5 s
    "A04X": {"kind": 16, "hits": 2, "gap": .63, "rad": 250, "max": 7, "st": 1, "ch": 35, "sd": .5},
    # F ery: 30 s: toc danh +(17 + 3 x rank), phat huy luc tan cong +(10 + 10 x rank)%; cooldown 60
    "A04Y": {"kind": 6, "dur": 30, "stats": [(4, 17, 3), (5, 10, 10)]},
    "A051": {"kind": 0, "stats": [5, 4]},                    # Dat Ma Vo Kinh: vat cong noi, sat thuong chi mang, toc danh
    "A054": {"kind": 0, "stats": [6, 14]},                   # Hon Nguyen Nhat Khi: hoa giai sat thuong, bo qua trang thai
    # E e_z / e_w: 3 palms 1/6 s apart, 900 (width 150), at most 7 each, 40% tho thuong 1 s
    "A055": {"wid": 150, "kind": 5, "hits": 3, "gap": .17, "rad": 900, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # Vo Tuong Than Cong: sinh luc; E 40%: Nhu Lai Chuong, more damage
    "A056": {"pch": (40, 0), "pmul": (27, 3), "kind": 0, "stats": [7], "link": 2, "lfx": 65536},
    # T JKG: 60 s: vat cong +(4.55 + 0.65 x rank)%, immune to tho thuong / cham / dinh than; cooldown 180
    "A0WD": {"kind": 8, "dur": 60, "stats": [(5, 5, 1)]},

    # Thieu Lam Dao (TLD): read from KVCT's code; A03J A03K A03N A03Q shared with TLQ / TLB
    # Q eQs: a blade along a line 700 (width 180), at most 7, 30% tho thuong 1 s
    "A03H": {"wid": 180, "kind": 5, "rad": 700, "max": 7, "st": 1, "ch": 30, "sd": 1},
    "A03I": {"kind": 0, "stats": [3, 4]},                    # Thieu Lam Dao Phap: chinh xac, vat cong %, chi mang, toc danh
    # A La Han Than Cong (aura): phan don can chien / tam xa; La Han Tran reflects
    "A03K": {"kind": 0, "stats": [], "fx": 128},
    # W JKw / JKv: 2 blades along the line 0.31 s apart (700), at most 7, 35% tho thuong 1 s; 30% damage +30%
    "A03R": {"pch": (30, 0), "pmul": (30, 0), "kind": 5, "hits": 2, "gap": .31, "rad": 700, "max": 7, "st": 1, "ch": 35, "sd": 1, "fx": 65536},
    # F eAz: 20 s (ends after 30 hits taken): 99% less damage, immune to statuses, chi mang, sat thuong chi mang
    "A03S": {"kind": 8, "dur": 20, "dimm": 20, "dimmhits": 30, "stats": [3]},
    # Dat Ma Be Tuc: khang ti le trang thai; when hit 50%: cleanse + immune 3 s
    "A03V": {"kind": 0, "stats": [14], "fx": 1024, "low": (0, 15, 0, 3, 50), "lowat": 100},
    # R e_R / e_W: at the point, enemies within 350 (at most 7) pulled 140 to it, 40% dinh than 2 s, take reflect
    # damage 15 s; no damage
    "A040": {"kind": 13, "nodmg": 1, "hits": 1, "gap": .03, "rad": 350, "max": 7, "st": 2, "ch": 40, "sd": 2,
             "fx": 2 | 512, "dur": 15},
    # E eQr / eQq: 3 blades 1/6 s apart (700), at most 7, 40% tho thuong 1 s; 30% damage +30%
    "A043": {"pch": (30, 0), "pmul": (30, 0), "kind": 5, "hits": 3, "gap": .17, "rad": 700, "max": 7, "st": 1, "ch": 40, "sd": 1, "fx": 65536},
    # Thien Nguyen Cong: suc manh, than phap, sinh khi; E 40%: the third blow throws 6 blades
    "A044": {"kind": 0, "stats": [5], "link": 2, "xw": 3, "xc": 40},
    "A0WB": {"kind": 0, "stats": [3, 14]},                   # Tram Ma Dao Phap: chi mang, hoa giai trang thai

    # Thieu Lam Bong (TLB): read from KVCT's code; A03J A03K A03Q as in TLQ / TLD
    # Q eHN / eHt: one blow 0.1 s after the cast where the target stood, radius 180, at most 7, 30% tho thuong 1 s
    "A047": {"kind": 16, "rad": 180, "max": 7, "st": 1, "ch": 30, "sd": 1},
    "A048": {"kind": 0, "stats": [3, 4]},                    # Thieu Lam Con Phap: chinh xac, vat cong %, chi mang, toc danh
    "A049": {"kind": 6, "dur": 300, "stats": [6]},           # D ed8: 300 s ne tranh, sat thuong nhan -%
    # W JEQ / JEH: one sweep 1/6 s after the cast around the hero, radius 300, at most 7, 35% tho thuong 1 s
    "A04C": {"kind": 4, "rad": 300, "max": 7, "st": 1, "ch": 35, "sd": 1},
    # R JsO / JsB: 8 s: every 0.5 s pulls up to 4 enemies within 800 to the hero and casts That Tinh La Sat Con;
    # immune to tho thuong meanwhile
    "A04D": {"kind": 18, "hits": 16, "gap": .5, "rad": 800, "max": 4, "st": 1, "ch": 35, "sd": 1, "fx": 2},
    # Kim Cang Bat Hoai: hit below 95% life: 3 s immune to damage and control, every (>= 10) s
    "A04G": {"onhurt": 1, "kind": 0, "stats": [], "fx": 1024, "low": (3, 3, 0, 3, 100), "lowr": (0, 33), "lowat": 95},   # every 3 s at rank 1 .. 6 s at rank 10 (level 200)
    "A04L": {"kind": 6, "dur": 180, "stats": [6, 14]},       # F eZY: 180 s sinh khi, hoa giai sat thuong, khang trang thai
    # E J9P / J9w: 2 sweeps 0.2 s apart around the hero, radius 300, at most 7, 40% tho thuong 1 s
    "A04O": {"kind": 4, "hits": 2, "gap": .2, "rad": 300, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # Ma Kha Vo Luong: E 50%: a thrust hits 7 enemies on a line, 5% back as life
    "A04P": {"pch": (50, 10), "pmul": (100, 0), "kind": 0, "stats": [], "link": 2, "lfx": 65536},
    "A0WC": {"kind": 0, "stats": [3], "fx": 128},            # Tay Tuy Kinh: phan don sat thuong ky nang, chi mang

    # Doan Thi Khi (DTK): read from KVCT's code
    # Q eSW / eSy: 3 sword qi side by side (4 at rank 4, 5 at rank 7), 900 (width 120), at most 7 each, 30% cham 2 s
    "A0D5": {"wid": 120, "kind": 5, "fan": 3, "fangrow": 1, "spread": 7, "rad": 900, "max": 7, "st": 4, "ch": 30, "sd": 2},
    "A0CP": {"kind": 0, "stats": [5, 3, 4]},                 # Doan Thi Tam Phap: bang cong %, chi mang, toc danh
    "A0CQ": {"kind": 0, "stats": [6, 14]},                   # Bac Minh Than Cong: hoa giai sat thuong, khang trang thai
    # Luc Kiem Te Phat: life under 50%, hit: 6 sword qi (Luc Mach Than Kiem) at the attacker, every 30 s
    "A0D3": {"kind": 0, "stats": [], "fx": 1024, "low": (0, 30, 0, 0, 100), "lowat": 50, "also": 2},
    # Kho Vinh Thien Cong: toc danh, bang cong %; life under 35%: 5 s heal every 0.5 s, every 60 s
    "A0CU": {"kind": 0, "stats": [4, 5], "fx": 1024, "low": (0, 60, 20, 0, 100), "lowat": 35},
    "A0CR": {"kind": 0, "stats": [5]},                       # Doan Gia Khi Kiem: phat huy luc tan cong, ti le cham
    # W eNp / eNG / eNh: 6 homing sword qi every 0.21 s (1 of 6 +40% damage, 35% cham 2 s, 11% bong / choang / tho thuong)
    "A0D6": {"kind": 5, "hits": 6, "gap": .21, "rad": 800, "max": 7, "st": 4, "ch": 35, "sd": 2},
    # R erk / erD: 18 sword qi 0.1 s apart (random +-20 degrees), 1200 (width 150), at most 5 each, cham 2 s, push 120
    "A0D8": {"wid": 150, "kind": 5, "hits": 18, "gap": .1, "rad": 1200, "max": 5, "st": 4, "ch": 100, "sd": 2, "fx": 1},
    "A0CS": {"kind": 0, "stats": [4, 13, 7, 3]},            # Bach Hong Thuc Nhat: toc danh, toc chay, sinh luc, chi mang
    # Luyen Khi Hoan Than: an orb every 10 s, 4 stacks of chi mang for 60 s
    "A0D4": {"kind": 0, "stats": [3]},
    # E Jko / Jk4: 2 blades 1/6 s apart, 1000 (width 100), at most 7 each, 40% cham 2 s; with Luc Mach Than Kiem
    "A0D7": {"wid": 100, "kind": 5, "hits": 2, "gap": .17, "rad": 1000, "max": 7, "st": 4, "ch": 40, "sd": 2, "also": 2},
    "A0CT": {"kind": 0, "stats": [14]},                      # Thien Long Than Cong: ne tranh, khang thoi gian trang thai
    # Am Huong So Anh: +1 stack every second, every 6 stacks Luc Mach Than Kiem
    "A0X1": {"kind": 0, "stats": [], "proc": 100, "pcd": 6, "also": 2},

    "A05B": {"kind": 2, "hits": 3},                          # Dai Luc Kim Cang Chuong (cone 3 hits)
    "A05D": {"kind": 4, "hits": 4},                          # Vo Luong Tram (nova 4 hits)
    "A058": {"kind": 6, "dur": 300, "stats": [(6, 15, 2)]},  # La Han Tran (buff)

    # Thuy Yen Dao (TYD): read from KVCT's code; A0BO A0BQ are shared with TYK
    # Q JxC / Jxx: 3 missiles fanned 20 degrees, 500 (width 90), at most 4 each, 30% cham 2 s
    "A0CD": {"wid": 90, "kind": 5, "fan": 3, "spread": 20, "rad": 500, "max": 4, "st": 4, "ch": 30, "sd": 2},
    "A0CB": {"kind": 0, "stats": [3, 4]},                    # Thuy Yen Dao Phap: chinh xac, bang cong, chi mang, toc danh
    "A0BO": {"kind": 0, "stats": [13]},                      # Tuyet Anh: toc do di chuyen, khang hoa
    # R ebl / ebd: invisible 30 s; the next attack ends it: Luu Phong Hoi Tuyet (2.8 + 0.1 x rank s):
    # toc danh +30 + 5 x rank, phat huy luc tan cong +20 + 10 x rank %
    "A0CE": {"kind": 19, "dur": 30, "hidebuf": 2.8, "hidebufr": .1, "stats": [(4, 30, 5), (5, 20, 10)]},
    # Ho The Han Bang: sinh luc; at 40% life: every enemy around frozen 3.5 s, khang +, every 30 s
    "A0BQ": {"onhurt": 1, "kind": 0, "stats": [7], "fx": 1024, "low": (0, 30, 0, 0, 100), "freeze": 3.5},
    "A0CC": {"kind": 0, "stats": [5]},                       # Bang Co Ngoc Cot: phat huy luc tan cong
    # W Ja0 / JaE: 3 missiles (4 from rank 3, 5 from rank 5) fanned ~13 degrees, 500, at most 3, 35% cham 2 s
    "A0CG": {"kind": 5, "fan": 3, "fangrow": 1, "spread": 13, "rad": 500, "max": 3, "st": 4, "ch": 35, "sd": 2},
    # Dap Tuyet Vo Ngan: attacking, (25 + 5 x rank)%: free of control (4.1 + 0.1 x rank) s, every 15 s
    "A0CH": {"kind": 0, "stats": [], "proc": 25, "pchr": 5, "pcd": 15, "pimm": 4.1},
    "A0CJ": {"kind": 0, "stats": [4, 3]},                    # Han Nguyet Yen Toa: toc danh, chi mang
    # D Je7 / Jev: on / off; every 2 s +1 tang (max 20), each +(10 + rank)% phat huy luc tan cong, spent by Q W E
    "A0CK": {"kind": 20, "chg": (10, 1)},
    # E Ja4 / Ja9 / Jae: a blade that bursts at the first enemy into 5 blades fanned 15 degrees, 600 (width 120),
    # at most 7 each, 40% cham 2 s
    "A0CL": {"wid": 120, "kind": 5, "fromtgt": 1, "fan": 5, "spread": 15, "rad": 600, "max": 7, "st": 4, "ch": 40, "sd": 2},
    "A0CM": {"kind": 0, "stats": [3]},                       # Bang Tam Thien Anh: sat thuong chi mang
    # F e_U / e_O: freeze every enemy within 400 (at most 10) (2.4 + 0.3 x rank) s, no damage; cooldown 45
    "A0WZ": {"kind": 4, "nodmg": 1, "rad": 400, "max": 10, "st": 3, "ch": 100, "sd": 2.4, "sdr": .3},

    # Thuy Yen (TYK)

    # Cai Bang Chuong (CBC): read from KVCT's code; A0E9 is shared with CBB
    # Q e6B / e6l: palms fanned 15 degrees, 3 (ranks 1-4) then rank - 1 (9 at rank 10), 528 (width 90), at most 7,
    # 30% bong 1 s
    "A0E7": {"wid": 90, "kind": 5, "fan": 3, "fanrank": 1, "spread": 15, "rad": 528, "max": 7, "st": 5, "ch": 30, "sd": 1},
    "A0E0": {"kind": 0, "stats": [3, 4]},                    # Cai Bang Chuong Phap: hoa cong, chi mang, toc danh
    "A0E8": {"kind": 0, "stats": [13]},                      # Hoa Hiem Vi Di: ne tranh, khang phan don, toc chay
    # R J3f / J33: 12 s (6 attacks): luc tan cong ky nang +60% (rank 1), thoi gian gay bong +; cooldown 25
    "A0ED": {"kind": 6, "dur": 12, "stats": [(5, 55, 5)], "bhits": 6},   # KVCT: ends after 6 attacks / skills
    "A0E9": {"kind": 0, "stats": [6, 14]},                   # Tuy Diep Cuong Vu: khang tat ca, khang thoi gian tho thuong
    "A0EA": {"kind": 0, "stats": [5]},                       # Tiem Long Tai Uyen: phat huy luc tan cong
    # W eHR / eHW: 4 blows on the target (0.04 s apart), at most 7, 35% bong 2 s; 35% fire damage +60%
    "A0E1": {"pch": (35, 0), "pmul": (60, 0), "kind": 16, "hits": 4, "gap": .04, "rad": 150, "max": 7, "st": 5, "ch": 35, "sd": 2, "fx": 65536},
    "A0EB": {"kind": 0, "stats": [5]},                       # Trao Long Cong: hoa cong; below 50% life skills hit harder
    "A0EC": {"kind": 0, "stats": []},                        # Than Long Bai Vi: chance of Trao Long Cong (not done)
    # Ba Vuong Ta Giap: every Q W E: 4 s toc danh +15, phat huy luc tan cong +(10 + 2 x rank)%, immune; every 10 s
    "A0EE": {"kind": 0, "stats": [(4, 15, 0), (5, 10, 2)], "proc": 100, "pcd": 10, "dur": 4, "pimm": 3.9},
    # E Jk1: Du Long flies (600), at the enemy Long Dai Dau strikes again, at most 7, 40% bong 3 s; 35% fire +60%
    "A0E2": {"pch": (35, 0), "pmul": (60, 0), "kind": 5, "hits": 2, "gap": .3, "rad": 600, "max": 7, "st": 5, "ch": 40, "sd": 3, "fx": 65536},
    "A0EG": {"kind": 0, "stats": [5]},                       # Giang Long Chuong: hoa cong (E -> Thoi Thua Luc Long: not done)
    # D Jff: 20 s: sat thuong len Kim +(20 + rank)%, bo qua hoa phong +(9 + rank)%, khang tat ca +(80 + 20 x rank)
    "A0X5": {"kind": 6, "dur": 20, "stats": [(5, 9, 1), 6]},

    # Cai Bang Bong (CBB)

    # Vo Dang Kiem (VDK): read from KVCT's code; A0JO is shared with VDQ
    # Q ei5: 3 hits 0.24 s apart, splash 100 where the target stood, 30% choang 0.5 s
    "A0JX": {"kind": 16, "hits": 3, "gap": .24, "rad": 100, "st": 3, "ch": 30, "sd": .5},
    "A0K8": {"kind": 0, "stats": [3, 4]},                    # Vo Dang Kiem Phap: chinh xac, loi cong, chi mang, toc danh
    # D JfE / J3H: 300 s, mana takes (18+3/rank)% of the damage (while mana > 15%), khang cham
    "A0JO": {"kind": 6, "dur": 300, "stats": [(6, 18, 3)]},
    # R Jx3 / JxK / JkQ: dash <= 800, no damage of its own: the hero's Q W E on the enemies around the end (200);
    # then Tu Tieu Hoanh Van: free of control, toc danh +40
    "A0KG": {"kind": 3, "rad": 800, "nodmg": 1, "qwe": 1, "selfimm": 2},
    "A0KA": {"kind": 0, "stats": [1, 2]},                    # That Tinh Quyet: ne tranh, damage -> life / mana
    "A0K9": {"kind": 0, "stats": [5]},                       # Kiem Khi Tung Hoanh: phat huy luc tan cong
    # W eZK / eZE: 3 sword qi 0.2 s apart from the hero, 220 long (width 100), at most 7 each, 35% choang 0.5 s
    "A0JY": {"wid": 100, "kind": 5, "hits": 3, "gap": .2, "rad": 220, "max": 7, "st": 3, "ch": 35, "sd": .5},
    # F eN8 / eNR: 12 s, every 0.3 s 2 sword qi at random enemies within 800, 50% choang 0.5 s; ne tranh +50%
    "A0KH": {"kind": 17, "hits": 40, "gap": .3, "rad": 800, "max": 2, "st": 3, "ch": 50, "sd": .5},
    # Thai Nhat Chan Khi: noi luc, ne tranh, toc danh; every 6.6 - 0.2 x rank s: 1 s immune to damage and control
    "A0KB": {"kind": 0, "stats": [4], "period": (66, 2)},
    "A0KC": {"kind": 0, "stats": [5], "fx": 8192, "onhurt": 2, "stk": (16, 0, 5, 2)},  # Me Tung Huyen Anh: +1 stack when hit (16, 5 s)
    # E J9A / J9X: 3 sword qi 0.2 s apart, 390 long (width 120), at most 7 each, 40% choang 0.5 s
    "A0JZ": {"wid": 120, "kind": 5, "hits": 3, "gap": .2, "rad": 390, "max": 7, "st": 3, "ch": 40, "sd": .5},
    # Thai Cuc Kiem Phap: sat thuong ngu hanh nhan -%; E 40%: 6 sword qi instead of 3 (every 1.5 s)
    "A0KE": {"kind": 0, "stats": [6], "link": 2, "xw": 3, "xc": 40},
    # T JeR / Jey: 20 s, every 1 s enemies within 800 (at most 7): toc chay -15% and khang loi down, 24 s
    "A0XM": {"kind": 18, "nodmg": 1, "hits": 20, "gap": 1, "rad": 800, "max": 7, "st": 4, "ch": 100, "sd": 24,
             "fx": 512, "dur": 24},

    # Vo Dang Khi (VDQ): read from KVCT's code; A0JO as in VDK
    # Q J4l / J4d: 2 blows 0.18 s apart where the target stood, radius 150, at most 7, 30% choang 1 s
    "A0J9": {"kind": 16, "hits": 2, "gap": .18, "rad": 150, "max": 7, "st": 3, "ch": 30, "sd": 1},
    "A0JL": {"kind": 0, "stats": [3, 4]},                    # Vo Dang Khi Cong: loi cong, chi mang, toc danh
    "A0JR": {"kind": 0, "stats": [5, 2]},                    # Chan Vu That Tiet: vat cong noi, damage -> noi luc
    # F JsC / Jsx: 85% of the mana becomes a shield of (rank) % of the max mana, 20 s; cooldown 30
    "A0JP": {"kind": 9, "dur": 20},
    "A0JM": {"kind": 0, "stats": [5]},                       # Thai Cuc Vo Y: phat huy luc tan cong
    # W JCU / JCO: 3 blows 0.3 s apart where the target stood, radius 250, at most 7, 35% choang 1 s
    "A0JA": {"kind": 16, "hits": 3, "gap": .3, "rad": 250, "max": 7, "st": 3, "ch": 35, "sd": 1},
    # R J9k / J9o: 5 (+1 for each 2 enemies) sword rains 0.1 s apart on enemies within 1000 (at most 10), 80% choang
    # 1 s; then 15 s chi mang on attacks (Kiem Tam Thong Dung); cooldown 30
    "A0JS": {"kind": 4, "hits": 5, "gap": .1, "rad": 1000, "max": 10, "st": 3, "ch": 80, "sd": 1,
             "selfbuf": 1, "dur": 15, "stats": [3]},
    "A0JU": {"kind": 0, "stats": [5]},                       # Vo Dang Cuu Duong: more damage with more mana (up to !%)
    "A0JQ": {"kind": 0, "stats": []},                        # Bat Quai Du Long: shield counters / ends with immunity (not done)
    # E JDp / JDG: 3 blows 0.25 s apart where the target stood, radius 280, at most 7, 40% choang 1 s
    "A0JB": {"kind": 16, "hits": 3, "gap": .25, "rad": 280, "max": 7, "st": 3, "ch": 40, "sd": 1},
    # Thai Cuc Than Cong: loi cong; E 75%: Vo Nga Vo Kiem, 2 more blows
    "A0JN": {"kind": 0, "stats": [5], "link": 2, "xw": 2, "xc": 75},
    "A0XL": {"kind": 0, "stats": [5], "fx": 4096},           # Luong Nghi Tam Phap: loi cong, hoi noi luc


    # Con Lon Kiem (CLK): read from KVCT's code; A0ID is shared with CLD
    # Q e_E / eli: lightning on the target, radius 120, at most 3, 30% choang 1 s
    "A0HV": {"kind": 16, "rad": 120, "max": 3, "st": 3, "ch": 30, "sd": 1},
    "A0HX": {"kind": 0, "stats": [3, 4]},                    # Con Lon Kiem Phap: loi cong, chi mang, toc danh
    # F JEU / JEl: heroes of the side within 1000 (allies 60%) 300 s: toc chay +(5 + rank), khang thoi gian cham
    # +(18 + 2 x rank)%
    "A0ID": {"kind": 7, "dur": 300, "stats": [(13, 5, 1), (14, 18, 2)]},
    # W JKJ / JK9: 8 bolts (16 ticks of 0.1 s) at the point, radius 420, at most 7, 35% choang 1 s; KVCT: cast, cd 2.5
    "A0I9": {"kind": 16, "hits": 8, "gap": .2, "rad": 420, "max": 7, "st": 3, "ch": 35, "sd": 1},
    # T eBe / eBK: side within 1000 (allies 60%) 300 s: khang +(45 + 15 x rank), sat thuong ngu hanh nhan -(10 + 2 x rank)%
    "A0IE": {"kind": 7, "dur": 300, "stats": [(6, 10, 2)]},
    "A0HY": {"kind": 0, "stats": [5]},                       # Ngu Loi Chanh Phap: phat huy luc tan cong
    # E etR / etW: 9 great bolts 0.3 s apart on random enemies within 1000, 80% choang 1 s; KVCT: cast, cd 9
    "A0IA": {"kind": 17, "hits": 9, "gap": .3, "rad": 1000, "max": 1, "st": 3, "ch": 80, "sd": 1},
    # Loi Dinh Quyet (aura): enemies around take (14 + 2 x rank)% more from Con Lon skills, toc chay -15%
    "A0IG": {"kind": 0, "stats": [5]},
    "A0IH": {"kind": 0, "stats": [6, 3]},                    # Huyen Thien Vo Cuc: hoa giai sat thuong, chi mang khi bi danh
    # D ebR / ebW: a cyclone flies 960 (width 220), no damage: 90% choang 3 s, then khang loi / khang chi mang down 8 s
    "A0IC": {"wid": 220, "kind": 5, "nodmg": 1, "rad": 960, "st": 3, "ch": 90, "sd": 3, "fx": 512, "dur": 8},
    # R J0n / J0u: thunderstorm at the point, 9 strikes 0.12 s apart, radius 400, at most 10, 40% choang 1 s;
    # Hon Nguyen Can Khon: 20% Bao Loi, more damage
    "A0IB": {"pch": (20, 0), "pmul": (25, 0), "kind": 13, "hits": 9, "gap": .12, "rad": 400, "max": 10, "st": 3, "ch": 40, "sd": 1, "fx": 65536},
    "A0IF": {"kind": 0, "stats": [3]},                       # Hon Nguyen Can Khon: loi cong, chi mang, sat thuong chi mang
    "A0XJ": {"kind": 0, "stats": [3]},                       # Hoa Tuy Vo Y: giam gian cach E / R (not done), chi mang

    # Con Lon Dao (CLD): read from KVCT's code; A0ID as in CLK
    # Q JDF / JDs: a blade along a line 800 (width 150), at most 7, 30% choang 1 s
    "A0IK": {"wid": 150, "kind": 5, "rad": 800, "max": 7, "st": 3, "ch": 30, "sd": 1},
    "A0IN": {"kind": 0, "stats": [3, 4]},                    # Con Lon Dao Phap: chinh xac, loi cong, chi mang, toc danh
    "A0J0": {"kind": 6, "dur": 300, "stats": [7]},           # R Jem: 300 s sinh luc toi da +%
    "A0J1": {"kind": 6, "dur": 300, "stats": [5]},           # D eZJ: 300 s vat cong ngoai (+20% of the base), chinh xac
    "A0IO": {"kind": 0, "stats": [5]},                       # Thien Thanh Dia Troc: phat huy luc tan cong
    # W Jxc / JxF: a blade 800 (width 180), at most 7, 35% choang 1 s, then Tieu Phong Lien Kich 2 more blows
    "A0IL": {"wid": 180, "kind": 5, "hits": 3, "gap": .17, "rad": 800, "max": 7, "st": 3, "ch": 35, "sd": 1},
    # Hoi Phong Phat Lieu: W / E first hit: a wind field pulls the enemies around (6 x 0.4 s), 50% tho thuong
    "A0J3": {"kind": 0, "stats": [], "link": 3, "lfx": 65536},
    # Luong Nghi Chan Khi: hoa giai sat thuong; attacking: 15 s immune to statuses, hoa giai, toc chay +30, every 60 s
    "A0J5": {"kind": 0, "stats": [6, 13], "proc": 100, "pcd": 60, "dur": 15, "pimm": 14},
    "A0J7": {"kind": 0, "stats": []},                        # Phan Luong Nghi Dao Phap: on the wind field (not done)
    # E JDR / JDW: a blade 1000 (width 200), at most 7, 40% choang 1 s, then Vo Tan Cuong Phong 3 more blows
    "A0IM": {"wid": 200, "kind": 5, "hits": 4, "gap": .17, "rad": 1000, "max": 7, "st": 3, "ch": 40, "sd": 1},
    "A0J2": {"kind": 0, "stats": [4, 14], "link": 2, "lfx": 65536},  # Vo Nhan Vo Nga: toc danh, khang thoi gian choang; E +
    "A0XK": {"kind": 0, "stats": [5]},                       # Suong Ngao Con Lon: vat cong ngoai


    # Ngu Doc Dao (NDD): read from KVCT's code (readable.j), see docs\kvct_audit.md
    # Q: JoX - missile 500 (width 120), at most 7 enemies, 30% dinh than 1 s, doc sat 3 s
    "A075": {"psec": 3, "wid": 120, "kind": 5, "hits": 1, "rad": 500, "max": 7, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    "A076": {"kind": 0, "stats": [(3, 0, 0), (4, 0, 0)]},  # Ngu Doc Dao Phap: chinh xac, doc cong, chi mang, toc danh
    # F: J9u - toggle; every 1 s costs 12 x rank mana, poison to at most 7 enemies within 700
    "A077": {"kind": 14, "rad": 700, "max": 7, "mana": 12},
    # R: eLM - one slow missile on an arc (460), at most 10 enemies, 25% dinh than 1 s, doc sat 5 s
    "A07A": {"psec": 5, "kind": 5, "hits": 1, "rad": 460, "max": 10, "st": 2, "ch": 25, "sd": 1, "fx": 8},
    # Van Co Thuc Tam: KVCT J9e - every Q W E hit lowers the enemy's resistances for 30 s
    "A07B": {"wdur": 30, "kind": 0, "stats": [], "link": 3, "lfx": 512},
    "A07E": {"kind": 0, "stats": [(5, 0, 0)]},              # Ngu Doc Ky Kinh: phat huy luc tan cong
    # W: JoR / Joy - 2 waves 0.32 s apart along a line of 800, at most 7 each; wave 1 30% tho thuong 1 s and
    # doc sat 3 s, wave 2 35% dinh than 1 s
    "A07F": {"kind": 5, "hits": 2, "gap": .32, "rad": 800, "max": 7, "st": 1, "ch": 30, "sd": 1,
             "st2": 2, "ch2": 35, "sd2": 1, "fx": 8},
    # D: elS / elq - a field at the point (<= 640), 5 pulses every 2 s, radius 350, at most 7: pull 100 to the
    # middle, 80% choang / te liet / hon loan 2 s, doc sat 3 s; cooldown 20
    "A07G": {"kind": 13, "hits": 5, "gap": 2, "rad": 350, "max": 7, "st": 3, "ch": 80, "sd": 2, "fx": 2 | 8},
    # Hoa Huyet Tiet Mach: Q and the first wave of W E turn 1% x rank of their damage into life
    "A07H": {"kind": 0, "stats": [], "link": 3, "steal": 1},
    "A07I": {"kind": 0, "stats": [(7, 0, 0), (6, 0, 0)], "fx": 1024, "low": (0, 25, 0, 10, 100), "lowat": 95, "onhurt": 1},  # Huyet Dinh Cong: sinh luc toi da, giam sat thuong nhan
    # E: Jsq / Jsg - 2 waves 0.25 s apart, 900, at most 7 each; wave 1 30% tho thuong 1 s and doc sat 3 s,
    # wave 2 40% dinh than 1 s
    "A07N": {"kind": 5, "hits": 2, "gap": .25, "rad": 900, "max": 7, "st": 1, "ch": 30, "sd": 1,
             "st2": 2, "ch2": 40, "sd2": 1, "fx": 8},
    # Thien Thu Van Doc: chi mang; every E hit adds 1 tang That Tam Co to the enemy, 3 tang burst
    "A07O": {"kind": 0, "stats": [(3, 0, 0)], "link": 2, "lfx": 16384},
    # T (NDD slot 14, NDC14): Jst - curse at the point, radius 200, at most 7: khang doc down, poison longer, 15 s
    "A0WM": {"kind": 15, "rad": 200, "max": 7, "fx": 512, "dur": 15},

    # Ngu Doc Chuong (NDC): read from KVCT's code; A0WM as in NDD
    # Q JDO / JDl: a poison palm flies at the target (800) and bursts at the first enemy, radius 150, at most 7,
    # doc sat 4 s
    "A06J": {"psec": 4, "kind": 16, "rad": 150, "max": 7, "fx": 8},
    "A06K": {"kind": 0, "stats": [3, 4]},                    # Ngu Doc Chuong Phap: doc cong, chi mang, toc danh
    # R JCn / JCu: curse at the point, radius 180, at most 4: doc sat every 1 s for 6 s
    "A06L": {"kind": 13, "hits": 6, "gap": 1, "rad": 180, "max": 4},
    "A06M": {"kind": 0, "stats": [5]},                       # Xuyen Tam Doc Thich: doc sat gay ra +%
    # Bi Ma Huyet Quang: every hit lowers the enemy's chi mang and khang doc, 30 s
    "A06N": {"wdur": 30, "kind": 0, "stats": [], "link": 3, "lfx": 512},
    "A06R": {"kind": 0, "stats": [5]},                       # Bach Co Doc Kinh: phat huy luc tan cong
    # W J4W / J4y: at the target 3 pulses 0.5 s apart, radius ~200, at most 7, 35% bat dong 1 s, doc sat 4 s
    "A06S": {"psec": 4, "kind": 13, "hits": 3, "gap": .5, "rad": 200, "max": 7, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    # D Jo0 / JoE: enemies within 200 of the point (at most 7) poisoned 8 s, more if they move (up to +100%)
    "A06T": {"kind": 13, "hits": 8, "gap": 1, "rad": 200, "max": 7},
    # Truy Phong Doc Thich: attacking or casting, chance: free of tho thuong / cham / choang, every 15 s
    "A06U": {"kind": 0, "stats": [], "proc": 30, "pcd": 15, "pimm": 3},
    # Luyen Nguc Hu Co: W radius +; every hit lowers khang doc 12 s (stacks)
    "A06V": {"wdur": 12, "kind": 0, "stats": [], "link": 3, "lfx": 512},
    # E JF3 / JFK: at the target 2 blows 0.48 s apart, at most 7, 40% bat dong 1 s, doc sat 4 s
    "A071": {"psec": 4, "kind": 13, "hits": 2, "gap": .48, "rad": 200, "max": 7, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    # Doan Can Hu Cot: doc sat gay ra +%, E radius +; E 75%: Hac Ho Dao Tam, more poison
    "A072": {"kind": 0, "stats": [5], "link": 2, "lfx": 65536},


    # Duong Mon Phi Tieu (DMPT): read from KVCT's code; A07T A07W A08J A081 A08L A08P shared with DMTT / DMPD
    # Q JCf / JC3: 5 darts fanned 12 degrees, 500 out and back (width 110), at most 4 each, 30% dinh than 1 s, doc sat
    "A0XZ": {"wid": 110, "kind": 5, "fan": 5, "spread": 12, "rad": 500, "max": 4, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    "A0XY": {"kind": 0, "stats": [3, 4]},                    # Duong Mon Am Khi: chinh xac, doc cong, chi mang, toc danh
    # F e1U / e1O: dash 300 + 40 x rank, no damage; then Xuat Ky Bat Y 5 s: phat huy luc tan cong +(12 + 3 x rank)%
    "A07T": {"kind": 3, "rad": 300, "radr": 40, "nodmg": 1, "selfbuf": 1, "dur": 5, "stats": [(5, 12, 3)]},
    "A07W": {"kind": 0, "stats": [5, 3]},                    # Toi Doc Thuat: vat cong, doc cong %, sat thuong chi mang
    # R e1T / e1z: at the point (<= 740) 3 pulses every 1 s, radius 300, at most 7: 50% dinh than 1 s, doc sat 2 s
    "A08J": {"psec": 2, "kind": 13, "hits": 3, "gap": 1, "rad": 300, "far": 740, "max": 7, "st": 2, "ch": 50, "sd": 1, "fx": 8},
    "A081": {"kind": 0, "stats": [5, 14]},                   # Tam Nhan: phat huy luc tan cong, khang choang
    # W JDP / JD7: 5 darts (1, then 2 + 2 curving), 800 out and back (width 80), at most 3, 35% dinh than 1 s, doc sat
    "A0Y1": {"wid": 80, "kind": 5, "fan": 5, "spread": 10, "rad": 800, "max": 3, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    "A08L": {"kind": 0, "stats": [4, 3]},                    # Ham Sa Xa Anh: toc danh, chi mang, doc sat
    # Me Hon Tran: when hit, enemies around -20% toc danh / sat thuong 6 s every 20 s (not done: giam sat thuong nhan)
    "A0Y2": {"kind": 0, "stats": [6], "onhurt": 3, "weak": (20, 6, 400), "pcd": 20},
    # D eLG: 16 s formation (radius 500): every 2 s (27 + 3 x rank)% to ignore damage and immune to control
    "A08P": {"kind": 8, "dur": 16, "stats": [(6, 27, 3)]},
    # E Jai / JaQ: 5 darts (+-8, +-16 degrees), 800 (width 100), at most 3 each, 40% dinh than 1 s, doc sat
    "A0Y9": {"wid": 100, "kind": 5, "fan": 5, "spread": 8, "rad": 800, "max": 3, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    # Truy Hon Doat Menh: chi mang; every dart of E 30%: more damage
    "A0YA": {"kind": 0, "stats": [3], "link": 2, "lfx": 65536},
    # T JKg / JKA: enemies within 650 (at most 10): khang vat cong -(20 + rank)%, toc chay / toc danh -99% 9 s
    "A0YB": {"kind": 4, "nodmg": 1, "rad": 650, "max": 10, "st": 2, "ch": 100, "sd": 9, "fx": 512, "dur": 9},

    # Duong Mon Tu Tien (DMTT): read from KVCT's code; A07S A07T A07W A081 as in DMPT
    # Q JCg / JCA: a dart hunts the target (900), 30% dinh than 1 s, then scatters around it; doc sat
    "A07R": {"kind": 16, "rad": 180, "max": 7, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    # R eOJ / eO9: 5 darts fanned 15 degrees, 900 (width 90), at most 7, (25 + 5 x rank)% dinh than 2 s, then
    # khang chi mang down 15 s
    "A07S": {"kind": 0, "stats": [3, 4]},                    # Duong Mon Am Khi: chinh xac, doc cong, chi mang, toc danh
    "A07X": {"kind": 5, "fan": 5, "spread": 15, "rad": 900, "max": 7, "st": 2, "ch": 25, "chr": 5, "sd": 2,
             "fx": 512, "dur": 15},
    # W JaC / Jax: at the target 3 bursts 0.4 s apart, radius 180, at most 7, 35% dinh than 1.5 s (darts fly out:
    # 25% tho thuong 0.5 s); doc sat
    "A082": {"kind": 13, "hits": 3, "gap": .4, "rad": 180, "max": 7, "st": 2, "ch": 35, "sd": 1.5, "fx": 8},
    # D JJz / JJP: an arrow hunts the target, then 3 more hits 0.3 s apart; (20 + distance / 10)% dinh than 3 s,
    # doc sat 6 s; cooldown 20
    "A083": {"psec": 6, "kind": 1, "hits": 4, "gap": .3, "st": 2, "ch": 30, "sd": 3, "fx": 8},
    # That Tuyet Sat Quang: attacking: toc danh, chi mang, phat huy luc tan cong for a while, every 30 s
    "A084": {"kind": 0, "stats": [4, 3], "proc": 100, "pcd": 30, "dur": 10},
    "A088": {"kind": 0, "stats": [3]},                       # Tang Hon Dinh: chi mang (+ more when R is cast: not done)
    # E Jkm / Jkc: at the target 3 bursts 0.3 s apart, at most 7, 40% dinh than 1.5 s (30% tho thuong); doc sat
    "A08B": {"kind": 13, "hits": 3, "gap": .3, "rad": 180, "max": 7, "st": 2, "ch": 40, "sd": 1.5, "fx": 8},
    # Tam Ma: ne tranh; every 4 hits of E: Truy Tinh Truc Dien at the target
    "A08C": {"kind": 0, "stats": [], "link": 2, "lfx": 16384},
    # Phu Quang Luoc Anh: a critical hit: vat cong / doc cong / sat thuong chi mang 20 s, every 30 s
    "A0WP": {"kind": 0, "stats": [5, 3], "proc": 25, "pcd": 30, "dur": 20},

    # Duong Mon Phi Dao (DMPD)

    # Thien Nhan Dao (TND): read from KVCT's code. Status 5 = bong: KVCT's burnt enemy takes x1.5 damage
    # Q JDX / JD5: a fire spot where the target stood, 3 burns 0.95 s apart, radius 120, at most 7, 30% bong 2 s
    "A0F4": {"kind": 13, "hits": 3, "gap": .95, "rad": 120, "max": 7, "st": 5, "ch": 30, "sd": 2},
    "A0F7": {"kind": 0, "stats": [3, 4]},                    # Thien Nhan Dao Phap: hoa cong, chi mang, toc danh
    # D egJ / eg9: fire ring at the point (<= 740) 8 s, every 2 s radius 270 + 30 x rank (at most 7): pulls the
    # enemies 100+ away to the middle, 100% bong 3 s, no damage
    "A0FK": {"kind": 13, "nodmg": 1, "suck": 1, "hits": 4, "gap": 2, "rad": 270, "radr": 30, "far": 740, "max": 7,
             "st": 5, "ch": 100, "sd": 3, "fx": 2},
    # R Js3 / Js0: fire wall at the point (<= 600), every 0.5 s for 9 s (radius 150 per column), at most 7,
    # 35% bong 1 s; cooldown 3
    "A0FJ": {"kind": 13, "hits": 18, "gap": .5, "rad": 250, "far": 600, "max": 7, "st": 5, "ch": 35, "sd": 1},
    # F eZG / eZm: curse at the point, radius 300 (at most 7): (36 + 4 x rank)% te liet 4 s, toc chay -25% 20 s
    "A0FL": {"kind": 15, "rad": 300, "max": 7, "st": 3, "ch": 36, "chr": 4, "sd": 4, "st2": 4, "ch2": 100, "sd2": 20},
    "A0F8": {"kind": 0, "stats": [5]},                       # Xi Khong Ma Diem: phat huy luc tan cong
    # W J0M / J0X: a fireball falls on the target (radius 220) then the ground burns (240), 3 burns 0.4 s apart,
    # at most 7, 35% bong 2 s
    "A0F5": {"kind": 13, "hits": 3, "gap": .4, "rad": 230, "max": 7, "st": 5, "ch": 35, "sd": 2},
    # Thuc Phoc Chu: khang phan don, hoa cong; hit below 95% life: free of control 10 s, toc chay, every 20 s
    "A0FM": {"onhurt": 1, "kind": 0, "stats": [5], "fx": 1024, "low": (0, 20, 0, 10, 100), "lowat": 95},
    # Nghich Chuyen Tam Kinh: W E hits mark the enemy, it takes more damage 10 s
    "A0FR": {"wdur": 10, "kind": 0, "stats": [], "link": 3, "lfx": 512},
    # T e1C / e1o: on / off; every 5 s 5 blades (0, +-22, +-44 degrees) 600 at the enemy in front, 5% life steal
    "A0FP": {"kind": 21, "gap": 5, "fan": 5, "spread": 22, "rad": 600, "fx": 4, "steal_pct": 5},
    # E JhU / JhO: flame sword on the target, 2 blows 0.4 s apart radius 250, at most 7, 40% bong 2 s,
    # then Viem Hoa Phan Thien burns every 1 s for 4 s
    "A0F6": {"kind": 13, "hits": 2, "gap": .4, "rad": 250, "max": 7, "st": 5, "ch": 40, "sd": 2, "fx": 8 | 2048},
    "A0FQ": {"pch": (100, 0), "pmul": (17, 3), "kind": 0, "stats": [3], "link": 2, "lfx": 65536},  # Ma Diem That Sat: hoa cong, chi mang; E more damage
    # Huyen Minh Hap Tinh (slot 14): E 21% takes away a part of a monster's life (not players)
    "A0X9": {"kind": 0, "stats": [], "link": 2, "lfx": 131072},

    # Thien Nhan Kich (TNK)

    # Thien Nhan Kich (TNK): read from KVCT's code
    # Q eiS / eiq: splash 100 where the target stood, at most 7, 30% tho thuong 1 s and 30% bong 1.5 s; 10% of the
    # damage back as life
    "A0G0": {"kind": 16, "rad": 100, "max": 7, "st": 1, "ch": 30, "sd": 1, "st2": 5, "ch2": 30, "sd2": 1.5,
             "fx": 4, "steal_pct": 10},
    "A0G3": {"kind": 0, "stats": [3, 4]},                    # Thien Nhan Mau Phap: chinh xac, hoa cong, chi mang, toc danh
    # R etc / eth / ets: 10 spears (0.2 s apart) thrown 560 around, 50% bong 2 s; cooldown 2
    "A0G5": {"kind": 4, "hits": 10, "gap": .2, "rad": 560, "max": 7, "st": 5, "ch": 50, "sd": 2},
    # D eNi / eNQ: enemies within 500 (at most 7): (45 + 5 x rank)% bong 4 s, (36 + 4 x rank)% hon loan 5 s,
    # toc danh -25% 8 s; no damage
    "A0G6": {"kind": 4, "nodmg": 1, "rad": 500, "max": 7, "st": 5, "ch": 45, "chr": 5, "sd": 4,
             "st2": 3, "ch2": 36, "chr2": 4, "sd2": 5},
    # Bi To Thanh Phong: every hit lowers the enemy's khang vat cong / ne tranh / chinh xac 30 s
    "A0G7": {"wdur": 30, "kind": 0, "stats": [], "link": 3, "lfx": 512},
    "A0G4": {"kind": 0, "stats": [5]},                       # Thien Ma Giai The: phat huy luc tan cong
    # W J9F / J9s: a thrust 200 long (width 120), at most 7, 35% tho thuong 1 s and 35% bong 1.5 s; 15% back as life
    "A0G1": {"wid": 120, "kind": 5, "rad": 200, "max": 7, "st": 1, "ch": 35, "sd": 1, "st2": 5, "ch2": 35, "sd2": 1.5,
             "fx": 4, "steal_pct": 15},
    # F eHs / eHC: dash 920, hits on the way (240), 100% bong 2 s; immune meanwhile; cooldown 24
    "A0G8": {"kind": 3, "rad": 920, "st": 5, "ch": 100, "sd": 2, "selfimm": 1},
    # Cuu Khuc Hop Thuong: D gives 5 s, F 3 s of immunity to damage and statuses with full chi mang (not done)
    "A0GB": {"kind": 0, "stats": []},
    "A0G9": {"kind": 0, "stats": [4]},                       # Van Long Tam Hien: vat cong, ne tranh, toc danh; F twice
    # E eA2 / eAm: spears fanned in front, 2 waves 0.3 s apart, at most 7, 40% tho thuong 1 s / 40% bong 1.5 s;
    # 20% back as life
    "A0G2": {"kind": 5, "fan": 3, "spread": 20, "hits": 2, "gap": .3, "rad": 400, "max": 7, "st": 1, "ch": 40,
             "sd": 1, "st2": 5, "ch2": 40, "sd2": 1.5, "fx": 4, "steal_pct": 20},
    "A0GC": {"kind": 0, "stats": [6, 3], "link": 2, "lfx": 65536},  # Ma Viem Tai Thien: giam sat thuong nhan, chi mang; E +
    "A0XA": {"kind": 0, "stats": [5]},                       # Bich Nguyet Phi Tinh: chinh xac, vat cong ngoai

    # Nga My Chuong (NMC): read from KVCT's code
    # Q Jsl / Jsd: 2 blows 0.15 s apart where the target stood, radius 200, at most 7, 30% cham 2 s (then an ice ray)
    "A0AR": {"kind": 16, "hits": 2, "gap": .15, "rad": 200, "max": 7, "st": 4, "ch": 30, "sd": 2},
    "A0AS": {"kind": 0, "stats": [3, 4]},                    # Nga My Chuong Phap: bang cong, chi mang, toc danh
    "A0AT": {"kind": 0, "stats": [7]},                       # Phat Tam Tu Huu: sinh luc / noi luc toi da
    # Bat Diet Bat Tuyet: hit below 50% life: heals itself and allies around every 0.5 s for 5 s, every 30 s
    "A0AU": {"kind": 0, "stats": [], "fx": 1024, "low": (0, 30, 20, 0, 100), "lowat": 50},
    # R eH4: heroes of the side within 1000 (allies 60%) 300 s: vat cong noi, sat thuong chi mang
    "A0AX": {"kind": 7, "dur": 300, "stats": [5, 3]},
    "A0B0": {"kind": 0, "stats": [5]},                       # Phat Phap Vo Bien: phat huy luc tan cong
    # W JxH / JxZ: palm qi flies 400 at the target and back (width 100), at most 7, 35% cham 2 s
    "A0B1": {"wid": 100, "kind": 5, "hits": 3, "gap": .2, "rad": 400, "max": 7, "st": 4, "ch": 35, "sd": 2},
    # Diep De Tang Hoa: W E hits: 3 more blows in a small area, every 3.1 - 0.1 x rank s
    "A0B2": {"kind": 0, "stats": [], "link": 3, "lfx": 65536},
    # Kim Dinh Mien Chuong: attacking: chi mang + immune to statuses 3 s, every 15 s
    "A0B3": {"kind": 0, "stats": [3], "proc": 100, "pcd": 15, "dur": 3, "pimm": 2.9},
    # D J9p: 300 s: khang ti le tho thuong / dinh than / cham / bong, phat huy luc tan cong
    "A0B7": {"kind": 6, "dur": 300, "stats": [14, 5]},
    # E Jhd / Jhn: 3 palm qi 1/6 s apart hunt the target (800, width 150), each hits going and coming back,
    # at most 7, 40% cham 2 s
    "A0BA": {"wid": 150, "kind": 5, "hits": 6, "gap": .17, "rad": 800, "max": 7, "st": 4, "ch": 40, "sd": 2},
    "A0BB": {"pch": (100, 0), "pmul": (27, 3), "kind": 0, "stats": [3], "link": 2, "lfx": 65536},  # Van Phat Quy Tong: E +18..40% random damage
    "A0WX": {"kind": 0, "stats": [7]},                       # Kim Dinh Phat Quang: sinh luc, Kim Dinh Mien Chuong stronger

    # Nga My Kiem (NMK)

    # Doan Thi (DTK, DTC)

    # Minh Giao (MGC, MGK)
    "A097": {"kind": 2, "hits": 3},                          # Hoa Long Thao Thien

    # Co Mo (CMC, CMK)

    # Hoa Son (HSQ, HSK)

    # Tieu Dao (TDC, TDK)

    # Thuy Yen Kiem (TYK)
}
KIND = {1: (1, 250., 4, 1), 2: (2, 450., 6, 2), 3: (2, 700., 8, 2), 4: (0, 0., 10, 0), 5: (2, 900., 7, 2),
        6: (0, 0., 30, 0), 7: (0, 0., 30, 0), 8: (0, 0., 40, 0), 9: (0, 0., 30, 0), 11: (0, 0., 15, 0), 12: (0, 0., 15, 0),
        13: (2, 500., 20, 2), 14: (0, 0., 5, 4), 15: (2, 500., 45, 2), 16: (1, 250., 4, 1),
        17: (0, 0., 30, 0), 18: (0, 0., 60, 0), 19: (0, 0., 32, 0), 20: (0, 0., 5, 4), 21: (0, 0., 5, 4)}
ATTACK = (1, 2, 3, 4, 5, 13, 16, 17)
# stat words of a passive / buff -> stat of zzVL_af (kskill.j zzKS_per)
STAT = [("sinh lực tối đa", 7), ("chí mạng", 3), ("tốc độ tấn công", 4), ("tốc đánh", 4), ("vật công", 5),
        ("phát huy lực tấn công", 5), ("công kích", 5), ("sát thương", 5), ("phòng thủ", 11), ("kháng", 6),
        ("giảm sát thương", 6), ("hút", 1), ("hồi phục", 7), ("sinh lực", 7), ("tốc độ di chuyển", 13)]
STATUS_TXT = {1: "thọ thương", 2: "định thân", 3: "choáng", 4: "làm chậm"}
KIND_TXT = {1: "Đánh mục tiêu", 2: "Quét các mục tiêu phía trước (450)", 3: "Xung kích tới điểm chọn (700), đánh trên đường",
            4: "Đánh các mục tiêu quanh thân (380)", 5: "Phóng chiêu bay thẳng 900, xuyên qua mọi mục tiêu"}
STAT_TXT = {1: "Hút sinh lực +%d%%", 3: "Bạo kích +%d%%", 4: "Tốc đánh +%d%%", 5: "Sát thương +%d%%",
            6: "Giảm sát thương nhận %d%%", 7: "Sinh lực +%d", 11: "Phòng thủ +%d", 13: "Tốc chạy +%d"}
PER = {1: 1, 2: 1, 3: 1, 4: 3, 5: 2, 6: 1, 7: 80, 11: 1, 13: 4, 14: 2}


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


# keys of an OVR entry that tools/kvfx/hand/<PHAI>.py may override per skill: hits (number of hits / waves / pulses), gap (seconds between
# them), rad (radius or range), max (most enemies per hit), st / ch / sd (status, chance %, seconds), dur (buff seconds), far, radr, wid, psec
HAND_OVR = {"hits", "gap", "rad", "max", "st", "ch", "sd", "dur", "far", "radr", "wid", "psec"}


def patch_textures(kv):
    """tools/kvfx/hand/<PHAI>.py TEXTURES = {"model.mdx": {"old.blp": "new.blp"}}: rewrite the texture table (TEXS) of the model copy in
    src/map/war3mapImported; the new texture is copied from KVCT when it is not in the map yet (stock textures need nothing)."""
    for model, mp in kvfx.texture_overrides().items():
        path = os.path.join(SRC, "war3mapImported", *model.replace("/", chr(92)).split(chr(92)))
        if not os.path.exists(path):
            print("TEXTURES: model not in the map:", model)
            continue
        data = bytearray(open(path, "rb").read())
        i = data.find(b"TEXS")
        low = {k.lower().replace("/", chr(92)): v for k, v in mp.items()}
        for j in range(struct.unpack_from("<i", data, i + 4)[0] // 268):
            o = i + 8 + 268 * j + 4
            cur = bytes(data[o : o + 260]).split(bytes(1))[0].decode("latin1")
            new = low.get(cur.lower()) or low.get(os.path.basename(cur.replace(chr(92), "/")).lower())
            if new is None:
                continue
            new = new.replace("/", chr(92))
            assert len(new) < 260, new
            data[o : o + 260] = new.encode("latin1").ljust(260, bytes(1))
            dst = os.path.join(SRC, *new.split(chr(92)))
            if not os.path.exists(dst):
                d = vfx.read(kv, new)
                ext = os.path.join(vfx.KVCT_DATA, *new.split(chr(92)))
                if d is None and os.path.exists(ext):
                    d = open(ext, "rb").read()
                if d is not None:
                    os.makedirs(os.path.dirname(dst), exist_ok=True)
                    open(dst, "wb").write(d)
            print("TEXTURES: %s: %s -> %s" % (model, cur, new))
        open(path, "wb").write(bytes(data))


def model_loops(kv, name):
    """1 when the model has a Stand sequence (it loops: a buff / aura shown for as long as it lasts), else 0"""
    d = vfx.read(kv, "war3mapImported" + chr(92) + name.replace("/", chr(92)))
    if not d:
        path = os.path.join(SRC, "war3mapImported", *name.replace("/", chr(92)).split(chr(92)))
        d = open(path, "rb").read() if os.path.exists(path) else b""
    i = d.find(b"SEQS")
    if i < 0:
        return 0
    for j in range(struct.unpack_from("<i", d, i + 4)[0] // 132):
        if d[8 + i + 132 * j : 8 + i + 132 * j + 80].split(bytes(1))[0].lower().startswith(b"stand"):
            return 1
    return 0


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
            if kind in ATTACK:
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


def passive_of(kind, proc):
    return kind == 0 or proc


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
    rows, made, models = ["call SaveInteger(zzVL_ht,0,291,%d)" % config.SKILL_VFX_SCALE_PERCENT], 0, {}
    for st_, (mdl_, per_) in config.STATUS_VFX.items():              # status effect models (kskill.j zzKS_StatusFx)
        if mdl_:
            models[mdl_] = 1
            rows.append('call SaveStr(zzVL_ht,0,%d,"war3mapImported%s%s")' % (300 + st_, "\\\\", mdl_))
            rows.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (310 + st_, round(per_ * 100)))
    n = 0
    for hero, cl in CLASS.items():
        skills = data.get(cl, [])[:14]
        used = set()
        for i, s in enumerate(skills):
            sid = "X%03d" % n if n < 1000 else "Y%03d" % (n - 1000)
            n += 1
            # numbers of the skill: the OVR table below, any of HAND_OVR set in tools/kvfx/hand/<PHAI>.py wins (the user's config)
            kvfx_ = kvfx.get(cl, s["name"])
            o_ = dict(OVR.get(s["kv"], {}))
            o_.update({k_: v_ for k_, v_ in kvfx_.items() if k_ in HAND_OVR})
            full = cl in KV_ORDER                       # checked against KVCT's code: OVR has every number
            if full:
                assert s["kv"] in OVR, "%s %s: no OVR entry" % (cl, s["kv"])
                s = dict(s, hits=o_.get("hits", 1), status=o_.get("st", 0), chance=o_.get("ch", 0),
                         sdur=o_.get("sd", 0), fx=o_.get("fx", 0), dur=o_.get("dur", 0))
            kind, key = o_.get("kind", s["kind"]), s["key"]
            if "dur" in o_:
                s["dur"] = o_["dur"]
            proc = kind in ATTACK and (key not in SLOT or key in used)
            if kind in (6, 7, 8, 9, 14, 15, 18, 19, 20, 21) and (key not in SLOT or key in used):
                kind = 0                                        # keyless buff: a passive
            used.add(key)
            st = stats_of(s["tip"])
            if "stats" in o_:                          # a stat alone: the engine's scale; (stat, base, per rank): KVCT's
                st = [x if isinstance(x, int) else x[0] for x in o_["stats"]] or [0]
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
            # roles of a KVCT model by its name: cast / caster on the hero, target on a hit enemy, buff / aura on the
            # hero, the rest is the effect itself (numbered variants of a model are more layers of the same effect)
            def role(x):
                w = os.path.basename(x)[len(cl) + 1:-4].lower()
                return ("cast" if re.search(r"cast", w) else "target" if re.search(r"target|hit|taget", w)
                        else "buff" if re.search(r"buff|aura", w) else "main")

            is_buff = kind in (6, 7, 8, 0)
            best = max(own, key=score) if own else None
            mains = [x for x in own if role(x) == ("buff" if is_buff else "main") and score(x)] or                     [x for x in own if role(x) == "main" and score(x)]
            if mains:                                   # the effect model first, the others serve their own role
                best = max(mains, key=score)
            extra = {}                                  # role -> up to 2 models (top scores, not the main one)
            for r_, cnt in (("cast", 2), ("target", 2), ("buff", 1), ("main", 2)):
                cand = sorted([x for x in own if role(x) == r_ and score(x) and x is not best], key=score, reverse=True)
                extra[r_] = [os.path.basename(x) for x in cand[:cnt]]
                for x in extra[r_]:
                    models[x] = 1
            # a class model named only "caster" / "target" (no skill name in it) is the class's own generic layer
            def generic(r_):
                g_ = [x for x in own if role(x) == r_ and not re.sub(r"cast(er)?|target|taget|hit|effect|\d|_|buff|aura", "", key_of(os.path.basename(x)[len(cl) + 1:-4]))]
                return os.path.basename(sorted(g_)[0]) if g_ else None
            if kind in ATTACK and not passive_of(kind, proc):
                if not extra["target"] and generic("target"):
                    extra["target"] = [generic("target")]
                if not extra["cast"] and key in SLOT and generic("cast"):
                    extra["cast"] = [generic("cast")]
                for r_ in ("cast", "target"):
                    for x in extra[r_]:
                        models[x] = 1
            # read from KVCT's code (tools/kvfx/hand/<class>.py by hand, tools/kvfx/auto/<class>.py by kvfx_extract.py): wins over the name matching
            # and over tk_mapping; a skill with no entry keeps the name matching / tk_mapping
            kvfx_ = kvfx.get(cl, s["name"])
            for r_, k_ in (("scale", 290), ("cast_scale", 292), ("target_scale", 293)):
                v_ = kvfx_.get(r_)                       # size of the main / cast / target effect: a factor (0.5, 1.5) or percent (>= 10)
                if v_:
                    rows.append("call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, k_, round(v_ * 100) if v_ < 10 else round(v_)))
            for r_, k_ in (("cast", 289), ("target", 288)):
                if kvfx_.get(r_ + "_ground"):
                    rows.append("call SaveInteger(zzVL_ht,'%s',%d,1)" % (sid, k_))
            if "aura" in kvfx_:
                models[kvfx_["aura"]] = 1
                rows.append('call SaveStr(zzVL_ht,\'%s\',287,"war3mapImported%s%s")' % (sid, "\\\\", kvfx_["aura"]))
            if "cast" in kvfx_:
                extra["cast"] = [kvfx_["cast"]]
            if "target" in kvfx_:
                extra["target"] = [kvfx_["target"]]
            if kvfx_:
                extra["main"] = list(kvfx_.get("area", []))
            for r_ in ("cast", "target", "main"):
                for x in extra[r_]:
                    models[x] = 1
            if best and score(best):
                model = os.path.basename(best)
            else:
                pool = [x for x in own if not re.search(r"buff|aura|cast", x, re.I)] or own
                model = os.path.basename(pool[i % len(pool)] if pool else "Effect_Slam.mdx")
            if "main" in kvfx_:
                model = kvfx_["main"]
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
            auto = AUTO_KEY.get(key) if kind in (1, 2, 3, 4, 5, 13, 16, 17) and not passive_of(kind, proc) and key not in MANUAL_QWE.get(cl, ()) else None
            mods = [m(b"anam", 3, s["name"]), m(b"aart", 3, icon), m(b"alev", 0, 10), m(b"aher", 0, 0)]
            mods.append(m(b"aani", 3, s["anim"]))
            mods += [m(b"auar", 3, icon), m(b"arar", 3, icon)]       # turn-off / research art: the same icon
            passive = passive_of(kind, proc)
            if passive:
                mods += [m(b"abpx", 0, 0), m(b"abpy", 0, -11)]
            else:
                x, y = SLOT[key]
                mods += [m(b"abpx", 0, x), m(b"abpy", 0, y), m(b"ahky", 3, key)]
            for L in range(1, 11):
                lines = [fill(s["raw"], L, kind, st, s["hits"], proc, s["chance"] or 30) or first]
                if auto:
                    lines.append("|cff00ff00Tự động: nhấp chuột phải vào biểu tượng để bật / tắt, bật thì đòn đánh thường tự tung chiêu.|r")
                lines.append("|cff808080Mở ở cấp %d, cấp 10 khi tướng cấp 200 (võ công %s, KVCT).|r" % (UNLOCK[i], cl))
                tipL = "%s%s - cấp %d" % (s["name"], (" (|cffffcc00%s|r)" % key) if not passive else "", L)
                mods += [m(b"atp1", 3, tipL, L), m(b"aub1", 3, "|n".join(lines), L)]
                if passive:
                    mods.append(m(b"Eev1", 2, 0., L, 1))
                else:
                    tt, rng, cd, _ = KIND[kind]
                    kcd, krng = slk.get(s["kv"], (None, None))
                    cd = kcd if kcd is not None else (s["cd"] or cd)          # KVCT's cooldown
                    rng = krng if (krng and kind in (1, 2, 5, 13, 15)) else rng
                    mods += [m(b"acdn", 2, float(cd), L), m(b"amcs", 0, 0, L), m(b"aran", 2, rng or 100., L),
                             m(b"Ncl1", 2, 0., L, 1), m(b"Ncl2", 0, tt, L, 2), m(b"Ncl3", 0, 1, L, 3),
                             m(b"Ncl4", 2, 0., L, 4), m(b"Ncl5", 0, 0, L, 5), m(b"Ncl6", 3, ORDER[key], L, 6),
                             m(b"adur", 2, 0., L), m(b"ahdu", 2, 0., L)]
                    if tt == 1:
                        mods.append(m(b"atar", 3, "air,enemies,ground,neutral,organic", L))
            if auto:                                        # KVCT "tu dong danh": autocast on attacks
                base, order, fields = auto
                mods = [x for x in mods if not x[0].startswith(b"Ncl")]
                for L in range(1, 11):
                    for fid, typ, val, dp in fields:
                        mods.append(m(fid, typ, val, L, dp))
                    mods += [m(b"adur", 2, .1, L), m(b"ahdu", 2, .1, L),
                             m(b"atar", 3, "air,enemies,ground,neutral,organic", L)]
                tabs[1].append([base, sid.encode(), [mods]])
            else:
                tabs[1].append([b"ACev" if passive else b"ANcl", sid.encode(), [mods]])
            made += 1
            if not passive and key in SLOT:                         # skill bar (kskill.j zzKS_BarAb)
                rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (hero, 260 + "QWERDFT".index(key), sid))
            k = 0 if passive else kind
            # extra effect models by role (kskill.j): 280 / 282 cast on the hero, 281 / 283 on a hit enemy, 284 buff on the hero,
            # 285 / 286 more layers of the effect at the point
            for r_, keys in (("cast", (280, 282)), ("target", (281, 283)), ("buff", (284,)), ("main", (285, 286))):
                for x_, k_ in zip(extra.get(r_, []), keys):
                    rows.append('call SaveStr(zzVL_ht,\'%s\',%d,"war3mapImported%s%s")' % (sid, k_, "\\\\", x_))
            rows += ["call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (hero, 200 + i, sid),
                     "call SaveInteger(zzVL_ht,'%s',%d,%d)" % (hero, 230 + i, UNLOCK[i]),
                     "call SaveInteger(zzVL_ht,'%s',240,%d)" % (sid, k if not proc else 0),
                     "call SaveInteger(zzVL_ht,'%s',241,%d)" % (sid, max(1, s["hits"])),
                     "call SaveInteger(zzVL_ht,'%s',242,%d)" % (sid, s["status"]),
                     "call SaveInteger(zzVL_ht,'%s',243,%d)" % (sid, s["chance"]),
                     "call SaveInteger(zzVL_ht,'%s',244,%d)" % (sid, max(1, round(s["sdur"] * 10))),
                     "call SaveInteger(zzVL_ht,'%s',246,%d)" % (sid, s["dur"]),
                     "call SaveInteger(zzVL_ht,'%s',247,%d)" % (sid, st[0]),
                     "call SaveInteger(zzVL_ht,'%s',248,%d)" % (sid, st[1] if len(st) > 1 else 0),
                     "call SaveInteger(zzVL_ht,'%s',249,%d)" % (sid, 1 if proc else 0),
                     "call SaveInteger(zzVL_ht,'%s',252,%d)" % (sid, s["fx"]),
                     ] + ["call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, 253 + 2 * n + w, v) for n, x in enumerate(o_.get("stats", [])) if not isinstance(x, int) for w, v in ((0, x[1]), (1, x[2]))]
            main_model = TK_OVERRIDES[s["name"]] if s["name"] in TK_OVERRIDES and "main" not in kvfx_ else model
            if model_loops(kv, main_model):          # a looping model (Stand sequence): a self buff keeps it for the whole buff
                rows.append("call SaveInteger(zzVL_ht,'%s',294,1)" % sid)
            if s["name"] in TK_OVERRIDES and "main" not in kvfx_:
                tk_model = TK_OVERRIDES[s["name"]]
                rows.append('call SaveStr(zzVL_ht,\'%s\',250,"war3mapImported%s%s")' % (sid, "\\\\", tk_model.replace("\\", "\\\\")))
            else:
                rows.append('call SaveStr(zzVL_ht,\'%s\',250,"war3mapImported%s%s")' % (sid, "\\\\", model))
            if proc:
                rows.append("call SaveInteger(zzVL_ht,'%s',240,%d)" % (sid, kind))
            if full:                                                 # kskill.j keys of the KVCT numbers
                ex = {234: o_.get("st2", 0), 235: o_.get("ch2", 0), 236: round(o_.get("sd2", 0) * 10),
                      257: o_.get("rad", 0), 258: round(o_.get("gap", 0) * 100), 259: o_.get("max", 0),
                      245: o_.get("lfx", 0), 231: o_.get("steal", 0), 232: o_.get("mana", 0),
                      225: o_.get("chr", 0), 224: o_.get("chr2", 0), 228: o_.get("nodmg", 0), 223: o_.get("selfimm", 0),
                      222: o_.get("durr", 0), 215: o_.get("fromtgt", 0), 216: o_.get("proc", 0), 214: o_.get("qwe", 0),
                      212: o_.get("period", (0, 0))[0], 211: o_.get("period", (0, 0))[1],
                      209: o_.get("xw", 0), 208: o_.get("xc", 0), 207: o_.get("fan", 0), 206: o_.get("spread", 0),
                      205: o_.get("fangrow", 0), 204: round(o_.get("freeze", 0) * 10), 203: round(o_.get("pimm", 0) * 10),
                      202: o_.get("pchr", 0), 201: 1, 200: round(o_.get("sdr", 0) * 10), 199: round(o_.get("hidebuf", 0) * 10),
                      198: o_.get("chg", (0, 0))[0], 197: o_.get("chg", (0, 0))[1], 196: o_.get("radr", 0),
                      195: o_.get("selfbuf", 0), 194: o_.get("far", 0), 189: o_.get("lowat", 0),
                      183: o_.get("also", 0), 186: o_.get("fanrank", 0), 185: o_.get("dimm", 0), 184: o_.get("dimmhits", 0), 182: o_.get("bhits", 0), 181: o_.get("suck", 0), 180: o_.get("pch", (0, 0))[0], 177: o_.get("pch", (0, 0))[1], 179: o_.get("pmul", (0, 0))[0], 178: o_.get("pmul", (0, 0))[1], 174: round(o_.get("hidebufr", 0) * 10), 173: o_.get("stk", (0, 0, 0, 0))[0], 172: o_.get("stk", (0, 0, 0, 0))[1], 171: o_.get("stk", (0, 0, 0, 0))[2], 170: o_.get("stk", (0, 0, 0, 0))[3], 169: o_.get("lowr", (0, 0))[0], 168: o_.get("lowr", (0, 0))[1], 167: o_.get("wid", 0), 166: o_.get("psec", 0), 165: o_.get("onhurt", 0), 164: o_.get("wdur", 0), 162: o_.get("weak", (0, 0, 0))[0], 161: o_.get("weak", (0, 0, 0))[1], 160: o_.get("weak", (0, 0, 0))[2]}
                if "steal_pct" in o_:
                    ex[187] = o_["steal_pct"]
                if "pcd" in o_:
                    ex[220] = o_["pcd"]
                keep = {239: o_["link"]} if "link" in o_ else {}   # written even when 0 (Q slot / no heal)
                if "low" in o_:
                    keep.update(zip((221, 220, 219, 218, 217), o_["low"]))
                rows += ["call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, k_, v_) for k_, v_ in ex.items() if v_ and k_ not in keep]
                rows += ["call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, k_, v_) for k_, v_ in keep.items()]
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
                has_w = has_m = has_z = False
                for x in sets[0]:
                    if x[0] == b"uhab":
                        x[4] = b""
                    elif x[0] in (b"umdl", b"unam"):
                        x[4] = (I_ + model + ".mdx" if x[0] == b"umdl" else cname).encode("utf-8")
                    elif x[0] == b"ua1w":
                        x[4] = b"missile"
                        has_w = True
                    elif x[0] == b"ua1m":
                        x[4] = b""
                        has_m = True
                    elif x[0] == b"ua1z":
                        x[4] = struct.pack("<i", config.ATTACK_PROJECTILE_SPEED)
                        has_z = True
                rng = config.HERO_ATTACK_RANGE.get(CLASS[hid])   # attack range per sect (tools/config.py)
                if rng:
                    sets[0] = [x for x in sets[0] if x[0] not in (b"ua1r", b"uacq")]
                    sets[0].append([b"ua1r", 1, 0, 0, struct.pack("<i", rng), bytes(4)])
                    sets[0].append([b"uacq", 1, 0, 1, struct.pack("<f", float(max(rng, 600))), bytes(4)])
                if not has_w:
                    sets[0].append([b"ua1w", 1, 0, 3, b"missile", bytes(4)])
                if not has_m:
                    sets[0].append([b"ua1m", 1, 0, 3, b"", bytes(4)])
                if not has_z:
                    sets[0].append([b"ua1z", 1, 0, 0, struct.pack("<i", config.ATTACK_PROJECTILE_SPEED), bytes(4)])
                pm = config.HERO_ATTACK_PROJECTILE.get(CLASS[hid])   # missile of the normal attack per sect (tools/config.py)
                if pm and pm[0]:
                    sets[0] = [x for x in sets[0] if x[0] not in (b"ua1m", b"ua1z")]
                    sets[0].append([b"ua1m", 1, 0, 3, (I_ + pm[0]).encode("utf-8"), bytes(4)])
                    sets[0].append([b"ua1z", 1, 0, 0, struct.pack("<i", int(pm[1] if len(pm) > 1 else config.ATTACK_PROJECTILE_SPEED)), bytes(4)])
                    models[pm[0]] = 1
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
    patch_textures(kv)                      # TEXTURES of tools/kvfx/hand/<PHAI>.py: change the textures of a model
    print("kskill: %d skills on %d heroes, %d effect models (%d files)" % (made, len(CLASS), len(done), nf))


if __name__ == "__main__":
    main()
