# KVCT skill sets on the VLTK heroes (engine: kskill.j, data: kskill_data.py). Every hero of CLASS loses its
# VLTK hero skills and gets its KVCT class's skills as unit abilities (X000...), opened by hero level 1..200.
# Icons and one effect model per skill come from KVCT (textures of KVCT3_Data put in the map, as vfx.py does).
# Writes build\kskill_table.j (read by gameplay.py). Run after lvl200.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata, vfx
from kskill_data import CLASS, HERO, KV_STRINGS, KV_ORDER, load
KV_STRINGS_DIR = KV_STRINGS
from icons import blp1_palette
from gameplay_items import plain
from PIL import Image
import io
from difflib import SequenceMatcher

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
    "blackarrow": (b"ANba", "blackarrow", [(b"Hba1", 2, 0., 1), (b"Hba2", 3, "", 2), (b"Hba3", 2, 0., 3), (b"abuf", 3, "Bdba", 1)]),
    "poisonarrowstarg": (b"AEpa", "poisonarrowstarg", [(b"Poa1", 2, 0., 1), (b"Poa2", 2, 0., 2), (b"Poa3", 2, 0., 3), (b"Poa4", 2, 0., 4), (b"Poa5", 2, 0., 5), (b"abuf", 3, "Bpoa", 1)]),
    "coldarrows": (b"AHca", "coldarrows", [(b"Hca1", 2, 0., 1), (b"Hca2", 2, 0., 2), (b"Hca3", 2, 0., 3), (b"Hca4", 2, 0., 4), (b"abuf", 3, "Bhea", 1)]),
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
    "A01R": {"kind": 0, "stats": [7], "fx": 1024, "low": (8, 80, 0, 8, 45)},
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
    "A03D": {"kind": 5, "hits": 3, "gap": .17, "rad": 450, "max": 7, "fromtgt": 1, "st": 1, "ch": 40, "sd": 1},
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
    "A022": {"kind": 0, "stats": [], "fx": 8192},
    # T egC / egx: (8 + rank) s immune to tho thuong / dinh than / cham / choang / day lui / keo; cooldown 40
    "A026": {"kind": 8, "dur": 8, "durr": 1},
    # E JaG: 4 thrusts 0.125 s apart, splash 270, at most 7, 40% tho thuong 1 s
    "A01N": {"kind": 16, "hits": 4, "gap": .13, "rad": 270, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # Huyet Chien Bat Phuong: sinh luc; E 75%: a spear flies 900 (width 150)
    "A029": {"kind": 0, "stats": [7], "link": 2, "lfx": 65536},

    # Thien Vuong Chuy (TVC)
    "A01S": {"kind": 1, "hits": 3},                          # Hao Hung Tram (strike 3 hits)
    "A02I": {"kind": 4, "hits": 4},                          # Huy Thien Diet Dia (nova 4 hits)
    "A02K": {"kind": 7, "dur": 30, "stats": [(11, 25, 3)]},  # Kim Chung Trao (party def buff)
    "A02P": {"kind": 3, "hits": 4},                          # Tram Long Quyet (dash slam 4 hits)
    "A02O": {"kind": 1, "hits": 3},                          # Thua Long Quyet (triple strike)

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
    "A055": {"kind": 5, "hits": 3, "gap": .17, "rad": 900, "max": 7, "st": 1, "ch": 40, "sd": 1},
    # Vo Tuong Than Cong: sinh luc; E 40%: Nhu Lai Chuong, more damage
    "A056": {"kind": 0, "stats": [7], "link": 2, "lfx": 65536},
    # T JKG: 60 s: vat cong +(4.55 + 0.65 x rank)%, immune to tho thuong / cham / dinh than; cooldown 180
    "A0WD": {"kind": 8, "dur": 60, "stats": [(5, 5, 1)]},

    # Thieu Lam Dao (TLD): read from KVCT's code; A03J A03K A03N A03Q shared with TLQ / TLB
    # Q eQs: a blade along a line 700 (width 180), at most 7, 30% tho thuong 1 s
    "A03H": {"kind": 5, "rad": 700, "max": 7, "st": 1, "ch": 30, "sd": 1},
    "A03I": {"kind": 0, "stats": [3, 4]},                    # Thieu Lam Dao Phap: chinh xac, vat cong %, chi mang, toc danh
    # A La Han Than Cong (aura): phan don can chien / tam xa; La Han Tran reflects
    "A03K": {"kind": 0, "stats": [], "fx": 128},
    # W JKw / JKv: 2 blades along the line 0.31 s apart (700), at most 7, 35% tho thuong 1 s; 30% damage +30%
    "A03R": {"kind": 5, "hits": 2, "gap": .31, "rad": 700, "max": 7, "st": 1, "ch": 35, "sd": 1, "fx": 65536},
    # F eAz: 20 s (ends after 30 hits taken): 99% less damage, immune to statuses, chi mang, sat thuong chi mang
    "A03S": {"kind": 8, "dur": 20, "dimm": 20, "dimmhits": 30, "stats": [3]},
    # Dat Ma Be Tuc: khang ti le trang thai; when hit 50%: cleanse + immune 3 s
    "A03V": {"kind": 0, "stats": [14], "fx": 1024, "low": (0, 15, 0, 3, 50), "lowat": 100},
    # R e_R / e_W: at the point, enemies within 350 (at most 7) pulled 140 to it, 40% dinh than 2 s, take reflect
    # damage 15 s; no damage
    "A040": {"kind": 13, "nodmg": 1, "hits": 1, "gap": .03, "rad": 350, "max": 7, "st": 2, "ch": 40, "sd": 2,
             "fx": 2 | 512, "dur": 15},
    # E eQr / eQq: 3 blades 1/6 s apart (700), at most 7, 40% tho thuong 1 s; 30% damage +30%
    "A043": {"kind": 5, "hits": 3, "gap": .17, "rad": 700, "max": 7, "st": 1, "ch": 40, "sd": 1, "fx": 65536},
    # Thien Nguyen Cong: suc manh, than phap, sinh khi; E 40%: the third blow throws 6 blades
    "A044": {"kind": 0, "stats": [5], "link": 2, "xw": 3, "xc": 40},
    "A0WB": {"kind": 0, "stats": [3, 14]},                   # Tram Ma Dao Phap: chi mang, hoa giai trang thai

    # Thieu Lam Bong (TLB)
    "A05B": {"kind": 2, "hits": 3},                          # Dai Luc Kim Cang Chuong (cone 3 hits)
    "A05D": {"kind": 4, "hits": 4},                          # Vo Luong Tram (nova 4 hits)
    "A058": {"kind": 6, "dur": 300, "stats": [(6, 15, 2)]},  # La Han Tran (buff)
    "A047": {"kind": 2, "hits": 2},                          # Pho Do Con Phap
    "A04C": {"kind": 4, "hits": 3},                          # That Tinh La Sat Con
    "A04O": {"kind": 4, "hits": 2},                          # Vi Da Hien Chu
    "A04D": {"kind": 4, "hits": 4},                          # Tuy Tien Bat Con
    "A049": {"kind": 6, "dur": 300, "stats": [(6, 20, 2)]},  # Bat Dong Minh Vuong
    "A04L": {"kind": 6, "dur": 300, "stats": [(13, 30, 3)]}, # Nhu Y Thuc Cot Cong

    # Thuy Yen Dao (TYD): read from KVCT's code; A0BO A0BQ are shared with TYK
    # Q JxC / Jxx: 3 missiles fanned 20 degrees, 500 (width 90), at most 4 each, 30% cham 2 s
    "A0CD": {"kind": 5, "fan": 3, "spread": 20, "rad": 500, "max": 4, "st": 4, "ch": 30, "sd": 2},
    "A0CB": {"kind": 0, "stats": [3, 4]},                    # Thuy Yen Dao Phap: chinh xac, bang cong, chi mang, toc danh
    "A0BO": {"kind": 0, "stats": [13]},                      # Tuyet Anh: toc do di chuyen, khang hoa
    # R ebl / ebd: invisible 30 s; the next attack ends it: Luu Phong Hoi Tuyet (2.8 + 0.1 x rank s):
    # toc danh +30 + 5 x rank, phat huy luc tan cong +20 + 10 x rank %
    "A0CE": {"kind": 19, "dur": 30, "hidebuf": 3, "stats": [(4, 30, 5), (5, 20, 10)]},
    # Ho The Han Bang: sinh luc; at 40% life: every enemy around frozen 3.5 s, khang +, every 30 s
    "A0BQ": {"kind": 0, "stats": [7], "fx": 1024, "low": (0, 30, 0, 0, 100), "freeze": 3.5},
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
    "A0CL": {"kind": 5, "fromtgt": 1, "fan": 5, "spread": 15, "rad": 600, "max": 7, "st": 4, "ch": 40, "sd": 2},
    "A0CM": {"kind": 0, "stats": [3]},                       # Bang Tam Thien Anh: sat thuong chi mang
    # F e_U / e_O: freeze every enemy within 400 (at most 10) (2.4 + 0.3 x rank) s, no damage; cooldown 45
    "A0WZ": {"kind": 4, "nodmg": 1, "rad": 400, "max": 10, "st": 3, "ch": 100, "sd": 2.4, "sdr": .3},

    # Thuy Yen (TYK)

    # Cai Bang Chuong (CBC): read from KVCT's code; A0E9 is shared with CBB
    # Q e6B / e6l: palms fanned 15 degrees, 3 (ranks 1-4) then rank - 1 (9 at rank 10), 528 (width 90), at most 7,
    # 30% bong 1 s
    "A0E7": {"kind": 5, "fan": 3, "fanrank": 1, "spread": 15, "rad": 528, "max": 7, "st": 5, "ch": 30, "sd": 1},
    "A0E0": {"kind": 0, "stats": [3, 4]},                    # Cai Bang Chuong Phap: hoa cong, chi mang, toc danh
    "A0E8": {"kind": 0, "stats": [13]},                      # Hoa Hiem Vi Di: ne tranh, khang phan don, toc chay
    # R J3f / J33: 12 s (6 attacks): luc tan cong ky nang +60% (rank 1), thoi gian gay bong +; cooldown 25
    "A0ED": {"kind": 6, "dur": 12, "stats": [(5, 55, 5)]},
    "A0E9": {"kind": 0, "stats": [6, 14]},                   # Tuy Diep Cuong Vu: khang tat ca, khang thoi gian tho thuong
    "A0EA": {"kind": 0, "stats": [5]},                       # Tiem Long Tai Uyen: phat huy luc tan cong
    # W eHR / eHW: 4 blows on the target (0.04 s apart), at most 7, 35% bong 2 s; 35% fire damage +60%
    "A0E1": {"kind": 16, "hits": 4, "gap": .04, "rad": 150, "max": 7, "st": 5, "ch": 35, "sd": 2, "fx": 65536},
    "A0EB": {"kind": 0, "stats": [5]},                       # Trao Long Cong: hoa cong; below 50% life skills hit harder
    "A0EC": {"kind": 0, "stats": []},                        # Than Long Bai Vi: chance of Trao Long Cong (not done)
    # Ba Vuong Ta Giap: every Q W E: 4 s toc danh +15, phat huy luc tan cong +(10 + 2 x rank)%, immune; every 10 s
    "A0EE": {"kind": 0, "stats": [(4, 15, 0), (5, 10, 2)], "proc": 100, "pcd": 10, "dur": 4, "pimm": 3.9},
    # E Jk1: Du Long flies (600), at the enemy Long Dai Dau strikes again, at most 7, 40% bong 3 s; 35% fire +60%
    "A0E2": {"kind": 5, "hits": 2, "gap": .3, "rad": 600, "max": 7, "st": 5, "ch": 40, "sd": 3, "fx": 65536},
    "A0EG": {"kind": 0, "stats": [5]},                       # Giang Long Chuong: hoa cong (E -> Thoi Thua Luc Long: not done)
    # D Jff: 20 s: sat thuong len Kim +(20 + rank)%, bo qua hoa phong +(9 + rank)%, khang tat ca +(80 + 20 x rank)
    "A0X5": {"kind": 6, "dur": 20, "stats": [(5, 9, 1), 6]},

    # Cai Bang Bong (CBB)
    "A0EK": {"kind": 5, "hits": 2},                          # Bong Da Ac Cau
    "A0EL": {"kind": 5, "hits": 3},                          # Thien Ha Vo Cau
    "A0EM": {"kind": 4, "hits": 6},                          # Bong Quynh Luoc Dia
    "A0F0": {"kind": 4, "hits": 12},                         # Ac Cau Lan Lo
    "A0EX": {"kind": 6, "dur": 300, "stats": [(5, 20, 2)]},  # Minh Sat Thu Hao

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
    "A0JY": {"kind": 5, "hits": 3, "gap": .2, "rad": 220, "max": 7, "st": 3, "ch": 35, "sd": .5},
    # F eN8 / eNR: 12 s, every 0.3 s 2 sword qi at random enemies within 800, 50% choang 0.5 s; ne tranh +50%
    "A0KH": {"kind": 17, "hits": 40, "gap": .3, "rad": 800, "max": 2, "st": 3, "ch": 50, "sd": .5},
    # Thai Nhat Chan Khi: noi luc, ne tranh, toc danh; every 6.6 - 0.2 x rank s: 1 s immune to damage and control
    "A0KB": {"kind": 0, "stats": [4], "period": (66, 2)},
    "A0KC": {"kind": 0, "stats": [5]},                       # Me Tung Huyen Anh: ne tranh (stacks when hit: not done)
    # E J9A / J9X: 3 sword qi 0.2 s apart, 390 long (width 120), at most 7 each, 40% choang 0.5 s
    "A0JZ": {"kind": 5, "hits": 3, "gap": .2, "rad": 390, "max": 7, "st": 3, "ch": 40, "sd": .5},
    # Thai Cuc Kiem Phap: sat thuong ngu hanh nhan -%; E 40%: 6 sword qi instead of 3 (every 1.5 s)
    "A0KE": {"kind": 0, "stats": [6], "link": 2, "xw": 3, "xc": 40},
    # T JeR / Jey: 20 s, every 1 s enemies within 800 (at most 7): toc chay -15% and khang loi down, 24 s
    "A0XM": {"kind": 18, "nodmg": 1, "hits": 20, "gap": 1, "rad": 800, "max": 7, "st": 4, "ch": 100, "sd": 24,
             "fx": 512, "dur": 24},

    # Vo Dang Khi (VDQ)
    "A0JP": {"kind": 9, "dur": 20},                            # Thuan Duong Vo Cuc
    "A0JS": {"kind": 12},                                    # Van Kiem Quy Tong
    "A0JA": {"kind": 1, "hits": 3},                          # Thien Dia Vo Cuc (triple strike)

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
    "A0IC": {"kind": 5, "nodmg": 1, "rad": 960, "st": 3, "ch": 90, "sd": 3, "fx": 512, "dur": 8},
    # R J0n / J0u: thunderstorm at the point, 9 strikes 0.12 s apart, radius 400, at most 10, 40% choang 1 s;
    # Hon Nguyen Can Khon: 20% Bao Loi, more damage
    "A0IB": {"kind": 13, "hits": 9, "gap": .12, "rad": 400, "max": 10, "st": 3, "ch": 40, "sd": 1, "fx": 65536},
    "A0IF": {"kind": 0, "stats": [3]},                       # Hon Nguyen Can Khon: loi cong, chi mang, sat thuong chi mang
    "A0XJ": {"kind": 0, "stats": [3]},                       # Hoa Tuy Vo Y: giam gian cach E / R (not done), chi mang

    # Con Lon Dao (CLD)
    "A0IK": {"kind": 2, "hits": 2},                          # Cuong Phong Sau Dien
    "A0IL": {"kind": 2, "hits": 2},                          # Ngao Tuyet Tieu Phong
    "A0IM": {"kind": 4, "hits": 3},                          # Cuu Thien Canh Phong
    "A0J0": {"kind": 6, "dur": 300, "stats": [(5, 25, 2)]},   # Tu Nguyen Thuat
    "A0J1": {"kind": 3},                                     # Nhat Khi Tam Thanh

    # Ngu Doc Dao (NDD): read from KVCT's code (readable.j), see docs\kvct_audit.md
    # Q: JoX - missile 500 (width 120), at most 7 enemies, 30% dinh than 1 s, doc sat 3 s
    "A075": {"kind": 5, "hits": 1, "rad": 500, "max": 7, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    "A076": {"kind": 0, "stats": [(3, 0, 0), (4, 0, 0)]},  # Ngu Doc Dao Phap: chinh xac, doc cong, chi mang, toc danh
    # F: J9u - toggle; every 1 s costs 12 x rank mana, poison to at most 7 enemies within 700
    "A077": {"kind": 14, "rad": 700, "max": 7, "mana": 12},
    # R: eLM - one slow missile on an arc (460), at most 10 enemies, 25% dinh than 1 s, doc sat 5 s
    "A07A": {"kind": 5, "hits": 1, "rad": 460, "max": 10, "st": 2, "ch": 25, "sd": 1, "fx": 8},
    # Van Co Thuc Tam: KVCT J9e - every Q W E hit lowers the enemy's resistances for 30 s
    "A07B": {"kind": 0, "stats": [], "link": 3, "lfx": 512},
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
    "A07I": {"kind": 0, "stats": [(7, 0, 0), (6, 0, 0)]},  # Huyet Dinh Cong: sinh luc toi da, giam sat thuong nhan
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
    "A06J": {"kind": 16, "rad": 150, "max": 7, "fx": 8},
    "A06K": {"kind": 0, "stats": [3, 4]},                    # Ngu Doc Chuong Phap: doc cong, chi mang, toc danh
    # R JCn / JCu: curse at the point, radius 180, at most 4: doc sat every 1 s for 6 s
    "A06L": {"kind": 13, "hits": 6, "gap": 1, "rad": 180, "max": 4},
    "A06M": {"kind": 0, "stats": [5]},                       # Xuyen Tam Doc Thich: doc sat gay ra +%
    # Bi Ma Huyet Quang: every hit lowers the enemy's chi mang and khang doc, 30 s
    "A06N": {"kind": 0, "stats": [], "link": 3, "lfx": 512},
    "A06R": {"kind": 0, "stats": [5]},                       # Bach Co Doc Kinh: phat huy luc tan cong
    # W J4W / J4y: at the target 3 pulses 0.5 s apart, radius ~200, at most 7, 35% bat dong 1 s, doc sat 4 s
    "A06S": {"kind": 13, "hits": 3, "gap": .5, "rad": 200, "max": 7, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    # D Jo0 / JoE: enemies within 200 of the point (at most 7) poisoned 8 s, more if they move (up to +100%)
    "A06T": {"kind": 13, "hits": 8, "gap": 1, "rad": 200, "max": 7},
    # Truy Phong Doc Thich: attacking or casting, chance: free of tho thuong / cham / choang, every 15 s
    "A06U": {"kind": 0, "stats": [], "proc": 30, "pcd": 15, "pimm": 3},
    # Luyen Nguc Hu Co: W radius +; every hit lowers khang doc 12 s (stacks)
    "A06V": {"kind": 0, "stats": [], "link": 3, "lfx": 512},
    # E JF3 / JFK: at the target 2 blows 0.48 s apart, at most 7, 40% bat dong 1 s, doc sat 4 s
    "A071": {"kind": 13, "hits": 2, "gap": .48, "rad": 200, "max": 7, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    # Doan Can Hu Cot: doc sat gay ra +%, E radius +; E 75%: Hac Ho Dao Tam, more poison
    "A072": {"kind": 0, "stats": [5], "link": 2, "lfx": 65536},


    # Duong Mon Phi Tieu (DMPT): read from KVCT's code; A07T A07W A08J A081 A08L A08P shared with DMTT / DMPD
    # Q JCf / JC3: 5 darts fanned 12 degrees, 500 out and back (width 110), at most 4 each, 30% dinh than 1 s, doc sat
    "A0XZ": {"kind": 5, "fan": 5, "spread": 12, "rad": 500, "max": 4, "st": 2, "ch": 30, "sd": 1, "fx": 8},
    "A0XY": {"kind": 0, "stats": [3, 4]},                    # Duong Mon Am Khi: chinh xac, doc cong, chi mang, toc danh
    # F e1U / e1O: dash 300 + 40 x rank, no damage; then Xuat Ky Bat Y 5 s: phat huy luc tan cong +(12 + 3 x rank)%
    "A07T": {"kind": 3, "rad": 300, "radr": 40, "nodmg": 1, "selfbuf": 1, "dur": 5, "stats": [(5, 12, 3)]},
    "A07W": {"kind": 0, "stats": [5, 3]},                    # Toi Doc Thuat: vat cong, doc cong %, sat thuong chi mang
    # R e1T / e1z: at the point (<= 740) 3 pulses every 1 s, radius 300, at most 7: 50% dinh than 1 s, doc sat 2 s
    "A08J": {"kind": 13, "hits": 3, "gap": 1, "rad": 300, "far": 740, "max": 7, "st": 2, "ch": 50, "sd": 1, "fx": 8},
    "A081": {"kind": 0, "stats": [5]},                       # Tam Nhan: phat huy luc tan cong
    # W JDP / JD7: 5 darts (1, then 2 + 2 curving), 800 out and back (width 80), at most 3, 35% dinh than 1 s, doc sat
    "A0Y1": {"kind": 5, "fan": 5, "spread": 10, "rad": 800, "max": 3, "st": 2, "ch": 35, "sd": 1, "fx": 8},
    "A08L": {"kind": 0, "stats": [4, 3]},                    # Ham Sa Xa Anh: toc danh, chi mang, doc sat
    # Me Hon Tran: when hit, enemies around -20% toc danh / sat thuong 6 s every 20 s (not done: giam sat thuong nhan)
    "A0Y2": {"kind": 0, "stats": [6]},
    # D eLG: 16 s formation (radius 500): every 2 s (27 + 3 x rank)% to ignore damage and immune to control
    "A08P": {"kind": 8, "dur": 16, "stats": [(6, 27, 3)]},
    # E Jai / JaQ: 5 darts (+-8, +-16 degrees), 800 (width 100), at most 3 each, 40% dinh than 1 s, doc sat
    "A0Y9": {"kind": 5, "fan": 5, "spread": 8, "rad": 800, "max": 3, "st": 2, "ch": 40, "sd": 1, "fx": 8},
    # Truy Hon Doat Menh: chi mang; every dart of E 30%: more damage
    "A0YA": {"kind": 0, "stats": [3], "link": 2, "lfx": 65536},
    # T JKg / JKA: enemies within 650 (at most 10): khang vat cong -(20 + rank)%, toc chay / toc danh -99% 9 s
    "A0YB": {"kind": 4, "nodmg": 1, "rad": 650, "max": 10, "st": 2, "ch": 100, "sd": 9, "fx": 512, "dur": 9},

    # Duong Mon (DMTT, DMPD)
    "A07R": {"kind": 4, "hits": 4},                          # Thien La Dia Vong
    "A082": {"kind": 4, "hits": 8},                          # Bao Vu Le Hoa
    "A083": {"kind": 5, "hits": 4},                          # Xuyen Van Tien
    "A07X": {"kind": 2, "hits": 3, "status": 2, "sdur": 3},  # Doan Can Nhan (fan cone root 3s)
    "A08B": {"kind": 4, "hits": 6},                          # Khong Tuoc Vu
    "A08H": {"kind": 5, "hits": 2},                          # Tieu Ly Phi Dao
    "A08K": {"kind": 5, "hits": 3},                          # Nhiep Hon Nguyet Anh
    "A08S": {"kind": 3},                                     # Vo Anh Xuyen

    # Thien Nhan Dao (TND): read from KVCT's code. Status 5 = bong: KVCT's burnt enemy takes x1.5 damage
    # Q JDX / JD5: a fire spot where the target stood, 3 burns 0.95 s apart, radius 120, at most 7, 30% bong 2 s
    "A0F4": {"kind": 13, "hits": 3, "gap": .95, "rad": 120, "max": 7, "st": 5, "ch": 30, "sd": 2},
    "A0F7": {"kind": 0, "stats": [3, 4]},                    # Thien Nhan Dao Phap: hoa cong, chi mang, toc danh
    # D egJ / eg9: fire ring at the point (<= 740) 8 s, every 2 s radius 270 + 30 x rank (at most 7): pulls the
    # enemies 100+ away to the middle, 100% bong 3 s, no damage
    "A0FK": {"kind": 13, "nodmg": 1, "hits": 4, "gap": 2, "rad": 270, "radr": 30, "far": 740, "max": 7,
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
    "A0FM": {"kind": 0, "stats": [5], "fx": 1024, "low": (0, 20, 0, 10, 100), "lowat": 95},
    # Nghich Chuyen Tam Kinh: W E hits mark the enemy, it takes more damage 10 s
    "A0FR": {"kind": 0, "stats": [], "link": 3, "lfx": 512},
    # T e1C / e1o: on / off; every 5 s 5 blades (0, +-22, +-44 degrees) 600 at the enemy in front, 5% life steal
    "A0FP": {"kind": 21, "gap": 5, "fan": 5, "spread": 22, "rad": 600, "fx": 4, "steal_pct": 5},
    # E JhU / JhO: flame sword on the target, 2 blows 0.4 s apart radius 250, at most 7, 40% bong 2 s,
    # then Viem Hoa Phan Thien burns every 1 s for 4 s
    "A0F6": {"kind": 13, "hits": 2, "gap": .4, "rad": 250, "max": 7, "st": 5, "ch": 40, "sd": 2, "fx": 8 | 2048},
    "A0FQ": {"kind": 0, "stats": [3], "link": 2, "lfx": 65536},  # Ma Diem That Sat: hoa cong, chi mang; E more damage
    # Huyen Minh Hap Tinh (slot 14): E 21% takes away a part of a monster's life (not players)
    "A0X9": {"kind": 0, "stats": [], "link": 2, "lfx": 131072},

    # Thien Nhan Kich (TNK)
    "A0G0": {"kind": 2, "hits": 2},                          # Tan Duong Nhu Huyet
    "A0G1": {"kind": 2, "hits": 3},                          # Van Long Kich
    "A0G2": {"kind": 5, "hits": 3},                          # Giang Hai No Lan
    "A0G5": {"kind": 4, "hits": 10},                         # Liet Hoa Tinh Thien
    "A0G8": {"kind": 3},                                     # Phi Hong Vo Tich
    "A0G6": {"kind": 4, "hits": 3, "status": 4, "sdur": 4},  # Ma Am Phe Phach (demon nova slow)

    # Nga My (NMC, NMK)
    "A0AR": {"kind": 5, "hits": 2},                          # Tu Tuong Dong Quy
    "A0B1": {"kind": 5, "hits": 3},                          # Phong Suong Toai Anh
    "A0BA": {"kind": 4, "hits": 6},                          # Nguyet Hoa Khuynh Ta
    "A0B7": {"kind": 6, "dur": 300, "stats": [(6, 15, 2)]},  # Van Tuong Than Cong
    "A0AX": {"kind": 7, "dur": 30, "stats": [(5, 25, 2)]},  # Phat Quang Chien Khi (party dmg buff)
    "A0A5": {"kind": 5, "hits": 2},                          # Thoi Song Vong Nguyet
    "A0AN": {"kind": 5, "hits": 3},                          # Kiem Anh Phat Quang
    "A0AO": {"kind": 5, "hits": 5},                          # Bang Suong Dien Phong
    "A0A6": {"kind": 7, "dur": 20},                          # Tu Hang Pho Do
    "A0A7": {"kind": 7, "dur": 20},                          # Thien Phat Thien Diep

    # Doan Thi (DTK, DTC)
    "A0D5": {"kind": 2, "hits": 2},                          # Kim Ngoc Man Duong
    "A0D6": {"kind": 5, "hits": 6},                          # Luc Mach Than Kiem
    "A0D7": {"kind": 5, "hits": 2},                          # Khi Thon Van Ly
    "A0D8": {"kind": 2, "hits": 18},                         # Kinh Thien Nhat Kiem
    "A0DB": {"kind": 1, "hits": 2},                          # Than Chi Diem Huyet
    "A0DO": {"kind": 5, "hits": 2},                          # Nhat Duong Chi
    "A0DQ": {"kind": 3},                                     # Lang Ba Vi Bo
    "A0DU": {"kind": 5, "hits": 9},                          # Huyen Bang Cuu Kiep
    "A0DD": {"kind": 1, "hits": 3},                          # Thien Long Than Chi
    "A0DC": {"kind": 1, "hits": 3},                          # Can Duong Than Chi (triple strike)

    # Minh Giao (MGC, MGK)
    "A095": {"kind": 4, "hits": 2},                          # Dap chuy
    "A097": {"kind": 2, "hits": 3},                          # Hoa Long Thao Thien
    "A099": {"kind": 4, "hits": 4},                          # Cuong Phong Bao Vu
    "A09A": {"kind": 4, "hits": 8},                          # Kiem Dang Bat Hoang
    "A09O": {"kind": 3, "status": 1, "sdur": 3},             # Khon Ho Van Tieu (dash + poison blast)
    "A09P": {"kind": 7, "dur": 30, "stats": [(3, 20, 2)]},   # Kim Qua Thiet Ma (party crit buff)
    "A09Q": {"kind": 5, "hits": 3},                          # Phach Dia The (piercing lance 3 hits)
    "A09T": {"kind": 4, "hits": 5, "status": 4, "sdur": 4},  # Hon Phach Phi Duong (nova weaken)
    "A09S": {"kind": 1, "hits": 3},                          # Long Thon Thuc (triple strike)
    "A08Z": {"kind": 4, "hits": 4, "status": 1, "sdur": 3},  # Van Vat Cau Phan (fire ring nova)
    "A090": {"kind": 6, "dur": 15, "stats": [(1, 30, 3)]},   # Can Khon Dai Na Di (life steal buff)
    "A094": {"kind": 4, "hits": 8, "status": 1, "sdur": 4},  # Thanh Hoa Lieu Nguyen (firestorm 8 hits)

    # Co Mo (CMC, CMK)
    "A0LS": {"kind": 5, "hits": 2},                          # Biet Tu
    "A0M8": {"kind": 3},                                     # Kinh Hong Chieu Anh
    "A0MA": {"kind": 2, "hits": 7},                          # Ngoc Phong Cham
    "A0MC": {"kind": 4, "hits": 20},                         # Hoang Tuyen Lao Dao
    "A0LU": {"kind": 5, "hits": 3},                          # Bi Sau
    "A0MD": {"kind": 6, "dur": 20, "stats": [(3, 25, 3)]},   # Vu Tap Van Hop (crit buff)
    "A0LT": {"kind": 1, "hits": 3},                          # Ly Han (triple strike)
    "A0ML": {"kind": 5, "hits": 2},                          # Thu Nhan Bang Hoang
    "A0MM": {"kind": 2, "hits": 2},                          # Co Nguyet Boi Hoi
    "A0N2": {"kind": 2, "hits": 3},                          # Chung Nam Van Chieu
    "A0N6": {"kind": 3},                                     # Phi Thien Vu
    "A0MN": {"kind": 5, "hits": 3},                          # Co Than Chi Anh
    "A0MZ": {"kind": 4, "hits": 3, "status": 3, "sdur": 2},  # Hong Tu Trien (stun nova 3 hits)

    # Hoa Son (HSQ, HSK)
    "A0L3": {"kind": 6, "dur": 20, "stats": [(5, 25, 2)]},   # Tu Ha Chan Khi
    "A0LO": {"kind": 4, "hits": 10},                         # Thien Than Dao Huyen
    "A0LP": {"kind": 6, "dur": 20, "stats": [(4, 25, 2)]},   # Kim Nhan Hoanh Khong
    "A0L7": {"kind": 2, "hits": 3},                          # Thuong Tung Nghenh Khach
    "A0L0": {"kind": 9, "dur": 20},                          # Chan Khi Ho The (qi shield 20s)
    "A0LK": {"kind": 6, "dur": 20, "stats": [(5, 35, 3)]},   # Doat Menh Lien Hoan Tam Tien Kiem (dmg buff)

    # Tieu Dao (TDC, TDK)
    "A0H5": {"kind": 2, "hits": 2},                          # Duong Ca Thien Quan
    "A0HK": {"kind": 5, "hits": 4},                          # Han Tu Huyet
    "A0H6": {"kind": 4, "hits": 3},                          # Bach Nhat Sam Than
    "A0HQ": {"kind": 4, "hits": 15},                         # Sinh Tu Phu
    "A0H7": {"kind": 5, "hits": 3},                          # Bai Son Dao Hai
    "A0XG": {"kind": 3},                                     # Tung Bo Quan Hoa
    "A0HS": {"kind": 4, "hits": 6, "fx": 4},                  # Thien Tam Cuu Bien (nova 6 hits + lifesteal)
    "A0GE": {"kind": 5, "hits": 2},                          # Tram Van Kiem
    "A0GV": {"kind": 4, "hits": 4},                          # Dan Phuong Dan
    "A0GF": {"kind": 2, "hits": 3},                          # Te Chieu Phon Thuong
    "A0GU": {"kind": 4, "hits": 12},                         # Kiem Chung Dan
    "A0GG": {"kind": 5, "hits": 4},                          # Bach Dieu Trieu Phuong
    "A0GZ": {"kind": 7, "dur": 25, "stats": [(6, 25, 2)]},   # So Hoa Dan (party resist buff)

    # Thuy Yen Kiem (TYK)
    "A0BM": {"kind": 5, "hits": 2},                          # Phong Quyen Tan Tuyet
    "A0BP": {"kind": 5, "hits": 8},                          # Vu Da Le Hoa
    "A0BU": {"kind": 2, "hits": 2},                          # Bang Tam Tien Tu
    "A0BV": {"kind": 4, "hits": 10},                         # Phi Tu Phieu Hoa
    "A0BY": {"kind": 5, "hits": 3},                          # Thuy Anh Man Tu
    "A0BX": {"kind": 6, "dur": 20, "stats": [(6, 20, 2), (5, 25, 2)]}, # Bang Tam Ngoc Lang (reflect / resist)
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
    rows, made, models = [], 0, {}
    n = 0
    for hero, cl in CLASS.items():
        skills = data.get(cl, [])[:14]
        used = set()
        for i, s in enumerate(skills):
            sid = "X%03d" % n if n < 1000 else "Y%03d" % (n - 1000)
            n += 1
            o_ = OVR.get(s["kv"], {})
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
            auto = AUTO_KEY.get(key) if kind in (1, 2, 3, 4, 5, 13, 16, 17) and not passive_of(kind, proc) else None
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
                    mods += [m(b"adur", 2, .01, L), m(b"ahdu", 2, .01, L),
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
                     "call SaveInteger(zzVL_ht,'%s',244,%d)" % (sid, max(1, round(s["sdur"] * 10))),
                     "call SaveInteger(zzVL_ht,'%s',246,%d)" % (sid, s["dur"]),
                     "call SaveInteger(zzVL_ht,'%s',247,%d)" % (sid, st[0]),
                     "call SaveInteger(zzVL_ht,'%s',248,%d)" % (sid, st[1] if len(st) > 1 else 0),
                     "call SaveInteger(zzVL_ht,'%s',249,%d)" % (sid, 1 if proc else 0),
                     "call SaveInteger(zzVL_ht,'%s',252,%d)" % (sid, s["fx"]),
                     ] + ["call SaveInteger(zzVL_ht,'%s',%d,%d)" % (sid, 253 + 2 * n + w, v) for n, x in enumerate(o_.get("stats", [])) if not isinstance(x, int) for w, v in ((0, x[1]), (1, x[2]))] + [
                     'call SaveStr(zzVL_ht,\'%s\',250,"war3mapImported%s%s")' % (sid, "\\\\", model)]
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
                      186: o_.get("fanrank", 0), 185: o_.get("dimm", 0), 184: o_.get("dimmhits", 0)}
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
