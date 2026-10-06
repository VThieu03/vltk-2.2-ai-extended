# Add the 1.31 gameplay module (tools\gameplay.j) to the converted map in src\map:
#   - war3map.j: globals, the item table zzVL_Items (generated from war3map.w3t), the module, call in main
#   - war3map.w3t: the phi phong items (one per quan ham)
# Run after convert_text.py and fix_script.py (both rewrite these files from the originals).
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import objdata
from gameplay_items import items, plain

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
JS = os.path.join(SRC, "Scripts", "war3map.j")
# names the keyword rules get wrong
SLOT_FIX = {"I04B": 3, "I04C": 3, "I04D": 3, "I04E": 3,                 # Nga Mao Phiến: fan (weapon)
            "I064": 3, "I065": 3, "I066": 3, "I067": 3,                 # Lang Tình Thiếp Ý Kiếm
            "srbd": 3, "I061": 3, "I062": 3, "I063": 3}                 # Phách Phong
NOT_GEAR = {"pgma", "lmbr", "I00J", "I01C", "I01F"}                    # potion, Kim Nguyên Bảo, Nhân Sâm, Liên Châu
TIER_FIX = {"rugt": 5}                                                  # An Lang Khôi (boss Rex drop)
# phi phong by rank: abilities reused from the author's armors (afac spsh ajen bgst, lgdh for the unique one)
CLOAKS = [  # (id, name, abilities, stats text, icon) for quan ham 1..5
    ("I0Z2", "Phi Phong Siêu Phàm", "AId4,AIx1,A04Z", "Phòng thủ +4, tất cả chỉ số +1, sinh lực +200", "BTNCloak"),
    ("I0Z3", "Phi Phong Xuất Trần", "AIl1,AId8,AIx2", "Phòng thủ +8, tất cả chỉ số +2, sinh lực +400", "BTNCloak"),
    ("I0Z4", "Phi Phong Kinh Thế", "A01G,A00G,AIl1", "Phòng thủ +12, tất cả chỉ số +4, sinh lực +400", "BTNCloak"),
    ("I0Z5", "Phi Phong Ỷ Thiên", "A01J,A01H,A01N", "Phòng thủ +16, tất cả chỉ số +6, sinh lực +600", "BTNCloakOfFlames"),
    ("I0Z6", "Phi Phong Chí Tôn", "A01P,A045,A03X,A041", None, "BTNCloakOfFlames"),
]
RANK = ["Hiệu Úy", "Thống Lĩnh", "Phó Tướng", "Đại Tướng", "Nguyên Soái"]

GLOBALS = """hashtable zzVL_ht=null
integer array zzVL_set
integer array zzVL_he
integer array zzVL_ct
integer array zzVL_rank
integer array zzVL_rq
string array zzVL_hn
string array zzVL_rn
string array zzVL_pn
string array zzVL_bn
string array zzVL_tn
integer array zzVL_cloak
texttag array zzVL_tag
boolean zzVL_fb=false
integer zzVL_winKills=150
unit zzVL_boss=null
timer zzVL_clock=null
unit zzVL_mc=null
integer zzVL_nextBoss=7
integer zzVL_nextMc=18
unit array zzVL_tgt
real array zzVL_tgtT
boolean array zzVL_autoOff
boolean array zzVL_reatk
integer array zzVL_qType
integer array zzVL_qNeed
integer array zzVL_qHave
integer array zzVL_qDone
unit array zzVL_aiTgt
item array zzVL_bag
item array zzVL_equipItem
boolean array zzVL_bagOpen
boolean array zzVL_sendTK
boolean array zzVL_sellMode
boolean array zzVL_sortReq
framehandle zzVL_fMain=null
framehandle zzVL_fInfo=null
framehandle zzVL_fMode=null
framehandle zzVL_fSell=null
framehandle zzVL_fOpen=null
framehandle array zzVL_fIco
framehandle array zzVL_fTip
trigger zzVL_tClick=null
integer array zzVL_af
real array zzVL_bcd
integer array zzVL_asNow
real array zzVL_cX
real array zzVL_cY
integer array zzVL_cZone
integer array zzVL_cType
integer zzVL_cN=0
integer array zzVL_gear
integer array zzVL_gearN
string array zzVL_zName
real array zzVL_zEx
real array zzVL_zEy
integer zzVL_zN=0
dialog array zzVL_dlg
button array zzVL_dlgB
trigger zzVL_tXp=null
real array zzVL_homeX
real array zzVL_homeY
integer array zzVL_start
real array zzVL_tpEnd
real array zzVL_shield
boolean array zzVL_splitMode
boolean zzVL_inTp=false
boolean array zzVL_gotStart
boolean array zzVL_khamMode
integer array zzVL_kSel
integer array zzVL_kNow
framehandle zzVL_fKham=null
framehandle zzVL_fAuto=null
sound zzVL_bgm=null
integer array zzKS_af
integer array zzKS_buf
real array zzKS_bufEnd
real array zzKS_imm
real array zzKS_per
unit zzKS_src=null
boolean zzKS_repl=false
real array zzKS_dimm
real array zzKS_lowCd
integer array zzKS_refl
integer array zzKS_bhN
integer array zzKS_bhAb
integer array zzKS_stack
real array zzKS_hurt
integer array zzKS_stackMax
integer array zzKS_stackPct
real array zzKS_stackEnd
integer zzKS_wave=1
integer array zzKS_pfx
integer array zzKS_pdur
integer array zzKS_pch
integer array zzKS_pmul
integer array zzKS_steal
integer array zzKS_xw
integer array zzKS_xc
integer array zzKS_chg
boolean array zzKS_chgOn
integer array zzKS_chgPct
real array zzKS_chgNext
integer array zzKS_hideAb
real array zzKS_hideEnd
boolean zzKS_noCap=false
unit zzKS_fh=null
integer array zzKS_mis
integer zzKS_misN=0
integer zzKS_misC=0
timer zzKS_misT=null
group zzKS_fg=null
real zzVL_logT=0.
integer zzKS_fab=0
real zzKS_fx=0.
real zzKS_fy=0.
integer array zzKS_dimmN
framehandle array zzUI_hp
framehandle array zzUI_mp
integer zzUI_lastHp=0
integer zzUI_lastMp=0
framehandle zzUI_hpT=null
framehandle zzUI_mpT=null
framehandle zzUI_name=null
framehandle zzUI_cls=null
framehandle zzUI_lv=null
framehandle zzUI_icon=null
framehandle zzUI_gold=null
framehandle zzUI_knb=null
framehandle zzUI_power=null
framehandle zzUI_info=null
boolean zzUI_on=false
framehandle array zzKS_bBtn
framehandle array zzKS_bIco
framehandle array zzKS_bDim
framehandle array zzKS_bCd
framehandle array zzKS_bLv
string array zzKS_bKey
unit zzKS_tgt=null
framehandle zzVL_fHero=null
framehandle zzVL_fHeroTxt=null
framehandle array zzVL_fPassBtn
framehandle array zzVL_fPassIco
framehandle array zzVL_fPassTT
framehandle array zzVL_fPassTTxt
framehandle array zzVL_fEqBtn
framehandle array zzVL_fEqIco
framehandle array zzVL_fEqTxt
framehandle array zzVL_fEqTT
framehandle array zzVL_fEqTTxt
framehandle zzVL_fBanner=null
framehandle zzVL_fBannerBg=null
boolean array zzVL_heroOpen
timer zzVL_bannerT=null
integer zzVL_dmgN=0
boolean zzVL_logBusy=false
boolean array zzVL_autoSell
integer array zzVL_cuong
item array zzVL_kItem
item array zzVL_tSel
item zzVL_potion=null
item array zzVL_want
unit zzVL_cbH=null
rect zzVL_lootR=null
integer zzVL_lootPid=0
integer zzVL_lootN=0
item array zzVL_lootIt
integer array zzVL_wel
unit zzVL_pickU=null
integer zzVL_dmgDepth=0
boolean zzVL_wzBusy=false
string zzVL_logMsg=""
dialog array zzVL_pickD
button array zzVL_pickB
integer array zzVL_pickH
trigger zzVL_tPick=null
string array zzVL_logS
integer zzVL_logN=0
framehandle zzVL_fClock=null
framehandle zzVL_fScore=null
integer array zzVL_kills
integer array zzVL_deaths
integer array zzVL_teamK
integer zzVL_pickT=0
framehandle array zzVL_fCnt
integer array zzVL_mat
integer zzVL_matN=0
framehandle array zzVL_fHl
framehandle zzVL_fSplit=null
constant integer zzVL_XAPHU='h0XP'
group zzVL_deadArena=null
item array zzVL_equip
integer array zzVL_jw
item zzVL_jOld=null"""

# placed right after endglobals (the author's drop functions call it): every gear type drops at most 5 times per
# match, then another gear type is drawn; materials and other items are not limited
DROP_FN = [

    "function zzVL_InArena takes unit u returns boolean",
    "local real x=GetUnitX(u)",
    "local real y=GetUnitY(u)",
    "return x>8300. and x<10800. and y>-200. and y<6600.",
    "endfunction",
    "function zzVL_ReviveArenaDeadAction takes nothing returns nothing",
    "local unit u=GetEnumUnit()",
    "local player p=GetOwningPlayer(u)",
    "call ReviveHeroLoc(u,GetPlayerStartLocationLoc(p),true)",
    "call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_MAX_LIFE))",
    "call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA))",
    "call PanCameraToTimedForPlayer(p,GetStartLocationX(GetPlayerStartLocation(p)),GetStartLocationY(GetPlayerStartLocation(p)),.0)",
    "endfunction",
    "function zzVL_ReviveArenaDead takes nothing returns nothing",
    "if zzVL_deadArena!=null then",
    "call ForGroup(zzVL_deadArena,function zzVL_ReviveArenaDeadAction)",
    "call GroupClear(zzVL_deadArena)",
    "endif",
    "endfunction",

    "function zzVL_Drop takes itempool vl_p,real vl_x,real vl_y returns item",
    "local item vl_it",
    "local integer vl_n=0",
    "local integer vl_c",
    "loop",
    "set vl_it=PlaceRandomItem(vl_p,vl_x,vl_y)",
    "if vl_it!=null and zzVL_ht!=null and zzVL_matN>0 and (LoadInteger(zzVL_ht,GetItemTypeId(vl_it),53)>0 or LoadInteger(zzVL_ht,GetItemTypeId(vl_it),44)>0) then",
    "call RemoveItem(vl_it)",
    "return CreateItem(zzVL_mat[GetRandomInt(0,zzVL_matN-1)],vl_x,vl_y)",
    "endif",
    "if vl_it==null or zzVL_ht==null or LoadInteger(zzVL_ht,GetItemTypeId(vl_it),0)/10<1 then",
    "return vl_it",
    "endif",
    "set vl_c=LoadInteger(zzVL_ht,GetItemTypeId(vl_it),42)",
    "if vl_c<5 then",
    "call SaveInteger(zzVL_ht,GetItemTypeId(vl_it),42,vl_c+1)",
    # 10-slot equipment: half of the gear drops become a jewel / belt / bracer of the same tier (JEWELS)
    "if GetRandomInt(1,100)<=50 then",
    "set vl_c=LoadInteger(zzVL_ht,GetItemTypeId(vl_it),0)",
    "set vl_c=vl_c-(vl_c/10)*10",
    "if zzVL_jw[vl_c*10]!=0 then",
    "call RemoveItem(vl_it)",
    "set vl_it=CreateItem(zzVL_jw[vl_c*10+GetRandomInt(0,5)],vl_x,vl_y)",
    "endif",
    "endif",
    "call SaveInteger(zzVL_ht,GetHandleId(vl_it),73,1)",
    "return vl_it",
    "endif",
    "call RemoveItem(vl_it)",
    "set vl_n=vl_n+1",
    "exitwhen vl_n>=10",
    "endloop",
    "return null",
    "endfunction",
]


def table():
    rows = []
    for iid, slot, tier, name in items():
        if iid in NOT_GEAR:
            continue
        slot = SLOT_FIX.get(iid, slot)
        tier = TIER_FIX.get(iid, tier)
        rows.append("call SaveInteger(zzVL_ht,'%s',0,%d)" % (iid, slot * 10 + tier))
    # auto-cast table written by skills.py
    rows += open(os.path.join(ROOT, "build", "skills_table.j"), encoding="utf-8").read().splitlines()
    rows += open(os.path.join(ROOT, "build", "tranphai_table.j"), encoding="utf-8").read().splitlines()
    rows += open(os.path.join(ROOT, "build", "kskill_table.j"), encoding="utf-8").read().splitlines()
    rows += prices()
    rows = [r for r in rows if r]
    # gear by tier (extra drops in the Thien Kiem areas)
    gear = {}
    for iid, slot, tier, name in items():
        if iid not in NOT_GEAR:
            gear.setdefault(TIER_FIX.get(iid, tier), []).append(iid)
    for jid, kind, tier, name in jewels():
        rows.append("call SaveInteger(zzVL_ht,'%s',0,%d)" % (jid, kind * 10 + tier))
        rows.append("call SaveInteger(zzVL_ht,'%s',41,%d)" % (jid, 60 * tier))
        rows.append("set zzVL_jw[%d]='%s'" % (tier * 10 + kind - 5, jid))
        gear.setdefault(tier, []).append(jid)
    for tier, ids in sorted(gear.items()):
        for k, iid in enumerate(ids):
            rows.append("set zzVL_gear[%d]='%s'" % (tier * 200 + k, iid))
        rows.append("set zzVL_gearN[%d]=%d" % (tier, len(ids)))
    # starting set: the first tier-1 hat, armor, weapon and boots
    start = {}
    for iid, slot, tier, name in items():
        slot = SLOT_FIX.get(iid, slot)
        if iid not in NOT_GEAR and TIER_FIX.get(iid, tier) == 1 and 1 <= slot <= 4:
            start.setdefault(slot, iid)
    for slot, iid in sorted(start.items()):
        rows.append("set zzVL_start[%d]='%s'" % (slot, iid))
    # Thien Kiem areas (build\zones.txt from expand.py): name, rect, entry, camps
    camp_types = {1: (["n006", "n009", "n00D", "n00A"], "n005"), 2: (["n00A", "n00E", "n00B", "n00E"], "n002")}
    c = 0
    zones = [l.rstrip(chr(10)).split(chr(9)) for l in open(os.path.join(os.path.dirname(SRC), "..", "build", "zones.txt"), encoding="utf-8")]
    for z, f in enumerate(zones, 1):
        rows += ['set zzVL_zName[%d]="%s"' % (z, f[0]), "set zzVL_zEx[%d]=%s." % (z, f[5]), "set zzVL_zEy[%d]=%s." % (z, f[6])]
        normal, elite = camp_types[min(z, 2)]
        for k, pt in enumerate(f[7].split()):
            x, y = pt.split(":")
            rows += ["set zzVL_cX[%d]=%s." % (c, x), "set zzVL_cY[%d]=%s." % (c, y), "set zzVL_cZone[%d]=%d" % (c, z)]
            types = normal if k % 3 else [elite] + normal[:3]
            for j, ut in enumerate(types):
                rows.append("set zzVL_cType[%d]='%s'" % (c * 4 + j, ut))
            c += 1
    rows += ["set zzVL_zN=%d" % len(zones), "set zzVL_cN=%d" % c]
    for i, b in enumerate(BIPHO):
        rows.append("call SaveInteger(zzVL_ht,'%s',53,1)" % b)
    for i, m in enumerate(MATS):
        rows.append("set zzVL_mat[%d]='%s'" % (i, m))
    rows.append("set zzVL_matN=%d" % len(MATS))
    # Bi Pho with the same product (3 pairs): either copy counts for the recipe (key 59 = the recipe's id)
    ver_, tabs_ = objdata.parse(open(os.path.join(SRC, "war3map.w3t"), "rb").read(), ".w3t")
    prod_of = {}
    for ti, tab in enumerate(tabs_):
        for o, n, sets in tab:
            iid = (o if ti == 0 else n).decode("latin1")
            if iid in BIPHO:
                d = {x[0]: x[4] for x in sets[0]}
                prod_of[iid] = bipho_product(d.get(b"ides", b"").decode("utf-8") + " " + d.get(b"utub", b"").decode("utf-8"))
    used = {m for pr, ms in craft_recipes() for m in ms if m in BIPHO}
    for b in BIPHO:
        canon = next((u for u in sorted(used) if prod_of.get(u) and prod_of.get(u) == prod_of.get(b)), b)
        rows.append("call SaveInteger(zzVL_ht,'%s',59,'%s')" % (b, canon))
    pages = page_lists(MAT_SHOP + [MAT_EXTRA])
    rows.append("call SaveInteger(zzVL_ht,'n00M',70,%d)" % len(pages))
    for pi, pg in enumerate(pages):
        rows.append("call SaveInteger(zzVL_ht,'n00M',%d,%d)" % (100 + pi, len(pg)))
        for k, it in enumerate(pg):
            rows.append("call SaveInteger(zzVL_ht,'n00M',%d,'%s')" % (72 + pi * 12 + k, it))
    k = 0
    for e, (el, rep_id, heroes) in enumerate(PICK):
        for i, h in enumerate(heroes):
            cid = "h0S" + "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[k]
            k += 1
            rows.append("call SaveInteger(zzVL_ht,'%s',80,'%s')" % (cid, h))
            rows.append("call SaveInteger(zzVL_ht,'h0E%d',%d,'%s')" % (e + 1, 81 + i, cid))
    for iid, sl, tier, nm in items():
        if SLOT_FIX.get(iid, sl) == 3:
            rows.append("call SaveInteger(zzVL_ht,'%s',66,%d)" % (iid, weapon_element(iid)))
    for prod, mats in craft_recipes():
        rows.append("call SaveInteger(zzVL_ht,'%s',60,%d)" % (prod, len(mats)))
        for k, mt in enumerate(mats):
            rows.append("call SaveInteger(zzVL_ht,'%s',%d,'%s')" % (prod, 61 + k, mt))
    for iid, (lv, amount, abil) in POTIONS.items():
        rows.append("call SaveInteger(zzVL_ht,'%s',57,%d)" % (iid, lv))
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H020', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H021', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H022', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H023', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H024', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H025', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H026', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H027', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H028', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H029', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H02A', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    rows.append("set zzVL_pickU = CreateUnit(Player(15), 'H02B', 0, 0, 0)")
    rows.append("call ShowUnit(zzVL_pickU, false)")
    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")
    for i, c in enumerate(CLOAKS):
        rows.append("set zzVL_cloak[%d]='%s'" % (i + 1, c[0]))
        rows.append("call SaveInteger(zzVL_ht,'%s',1,1)" % c[0])
    return rows


# 10-slot equipment (KVCT style): the 6 kinds the map did not have. Worn in the hidden slots zzVL_equip[pid*10+slot]
# of the character panel (C), stats by script (gameplay_02_farm.j zzVL_JewelBase, same numbers as the text here).
# kind -> (10-slot index, kind name, 5 tier names, stat text by tier)
JEWELS = {
    5: (2, "Yêu Đái", ["Bố Yêu Đái", "Bì Yêu Đái", "Ngân Yêu Đái", "Kim Ti Yêu Đái", "Bàn Long Yêu Đái"],
        lambda t: "+%d sinh lực, +%d%% kháng độc, +%d%% kháng thủy" % (80 * t, 2 * t, 2 * t)),
    6: (3, "Hộ Uyển", ["Bố Hộ Uyển", "Bì Hộ Uyển", "Ngân Hộ Uyển", "Kim Hộ Uyển", "Long Lân Hộ Uyển"],
        lambda t: "+%d%% tốc đánh, +%d%% kháng hỏa, +%d%% kháng lôi" % (2 * t, 2 * t, 2 * t)),
    7: (6, "Hạng Liên", ["Mộc Hạng Liên", "Đồng Hạng Liên", "Ngân Hạng Liên", "Phỉ Thúy Hạng Liên", "Thiên Châu Hạng Liên"],
        lambda t: "+%d%% bạo kích, +%d STVL nội công, +%d%% tốc độ xuất chiêu" % (t, 10 * t, t)),
    8: (7, "Giới Chỉ", ["Thiết Giới Chỉ", "Đồng Giới Chỉ", "Ngân Giới Chỉ", "Kim Giới Chỉ", "Huyết Ngọc Giới Chỉ"],
        lambda t: "+%d điểm đánh trúng, +%d%% hút sinh lực, +%d%% sát thương" % (20 * t, (t + 1) // 2, t)),
    9: (8, "Ngọc Bội", ["Thạch Ngọc Bội", "Thanh Ngọc Bội", "Bạch Ngọc Bội", "Mặc Ngọc Bội", "Long Phượng Ngọc Bội"],
        lambda t: "+%d%% hút nội lực, +%d%% kháng vật lý, độc, thủy, hỏa, lôi" % ((t + 1) // 2, t)),
    10: (9, "Hộ Thân Phù", ["Bình An Phù", "Trấn Tà Phù", "Hộ Mệnh Phù", "Kim Cang Phù", "Càn Khôn Phù"],
         lambda t: "+%d sinh lực, giảm %d%% sát thương nhận" % (100 * t, (t + 1) // 2)),
}
TIER_COLOR = ["|cffffffff", "|cff00ff00", "|cff4080ff", "|cffc080ff", "|cffff8000"]


def jewels():
    """(id, kind, tier, name): ids IJ<kind 5..A><tier 1..5>"""
    return [("IJ" + "56789A"[kind - 5] + str(t), kind, t, JEWELS[kind][2][t - 1])
            for kind in sorted(JEWELS) for t in range(1, 6)]


BIPHO = ["I06N", "I06O", "I06R", "I06T", "I06V", "I06X", "I06Y", "I00L",
         "I00N", "I00Q", "I00T", "I016", "I018", "I019", "I01A", "I01B"]
MATS = ["I06M", "I06L", "I06K", "I06J", "I06W", "I06S", "I06Q", "I00S", "I017", "I00R", "I00P", "I06P", "I06U"]


WEAPON_WORDS = {"kiem", "dao", "mau", "thuong", "con", "phien", "chuy", "truong", "phach", "soc", "phu", "hoan", "tien"}


def bipho_product(ides):
    m = re.search(r"chế tạo được\s*(?:\|c\w{8})?([^|\r\n]+)", ides)
    return m.group(1).strip().rstrip(".") if m else ""


def bipho_kinds():
    """Bi Pho id lists (weapons, armor/other) and their names 'Bi Pho - product' in two colours"""
    pt = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(pt, "rb").read(), ".w3t")
    weapons, gear = [], []
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            iid = (o if ti == 0 else n).decode("latin1")
            if iid not in BIPHO:
                continue
            ms = sets[0]
            d = {x[0]: x[4] for x in ms}
            prod = bipho_product(d.get(b"ides", b"").decode("utf-8") + " " + d.get(b"utub", b"").decode("utf-8"))
            is_w = bool(set(re.findall(r"[a-z]+", plain(prod))) & WEAPON_WORDS)
            (weapons if is_w else gear).append(iid)
            if prod:
                nm = ("|cffff8040Bí Phổ vũ khí|r - " if is_w else "|cff40c0ffBí Phổ trang bị|r - ") + prod
                for key in (b"unam", b"utip"):
                    x = next((x for x in ms if x[0] == key), None)
                    if x is None:
                        ms.append(mod(key, 3, nm))
                    else:
                        x[3], x[4] = 3, nm.encode("utf-8")
    open(pt, "wb").write(objdata.write(ver, tabs, ".w3t"))
    print("bi pho: %d vu khi, %d trang bi" % (len(weapons), len(gear)))
    return weapons, gear


def craft_recipes():
    """[(product, [materials])] from zzVL_Craft in gameplay.j (the author's recipes)"""
    j = open(os.path.join(os.path.dirname(__file__), "gameplay.j"), encoding="utf-8").read()
    f = j[j.index("function zzVL_Craft"):]
    f = f[:f.index("endfunction")]
    return [(prod, [m for m in re.findall(r"'(\w{4})'", cond) if m not in BIPHO])
            for cond, prod in re.findall(r"if (UnitHasItemOfTypeBJ[^\n]*?) then.*?CreateItem\('(\w{4})'", f, re.S)]


# Tang Bao Cac (was the Tiem tap hoa): the materials; Bo De Moc is sold by the Bi Pho (trang bi) NPC (12 per shop)
MAT_SHOP = ["I06M", "I06L", "I06K", "I06J", "I06W", "I06S", "I06Q", "I017", "I00R", "I00P", "I06P", "I06U"]
MAT_EXTRA = "I00S"


PAGE_ITEM = "I0PG"


def page_lists(lst):
    """a shop sells 12: longer lists get pages of 11 + the 'Trang tiep' item"""
    if len(lst) <= 12:
        return [lst]
    return [lst[i:i + 11] + [PAGE_ITEM] for i in range(0, len(lst), 11)]


# ngu hanh of each weapon (gameplay.j: on-hit effect of normal attacks; describe.py: the line in its text)
ELEMENTS = ["Kim", "Mộc", "Thổ", "Thủy", "Hỏa"]
ELEMENT_TEXT = ["+8% sát thương, giảm 8% sát thương nhận, +300 sinh lực",
                "+8% sát thương, độc sát: đánh thường gây độc thêm 15% sát thương trong 5 giây",
                "+8% sát thương, đánh thường và kỹ năng 7% cơ hội gây choáng 0.7 giây",
                "+8% sát thương, đánh thường làm chậm 30% trong 2 giây, mỗi giây hồi 0.4% sinh lực và 0.8% nội lực",
                "+8% sát thương, hỏa sát: đánh thường đốt thêm 15% sát thương trong 5 giây"]
ELEMENT_COLOR = ["|cffffd700", "|cff40c040", "|cffc08040", "|cff4080ff", "|cffff4040"]


def weapon_element(iid):
    return sum(iid.encode("latin1")) % 5 + 1


# stat effects (war3mapMisc.txt): Suc manh mau / hoi mau, Than phap toc danh (ne: gameplay.j), Noi cong noi luc / hoi
MISC = {"StrHitPointBonus": "80.0", "StrRegenBonus": "0.06", "AgiAttackSpeedBonus": "0.02",
        "IntManaBonus": "35.0", "IntRegenBonus": "0.10"}


def misc():
    pm = os.path.join(SRC, "war3mapMisc.txt")
    t = open(pm, "rb").read().decode("utf-8")
    for k, v in MISC.items():
        t, n = re.subn(r"(?m)^%s=.*$" % k, "%s=%s" % (k, v), t)
        if not n:
            t += "\r\n%s=%s" % (k, v)
    open(pm, "wb").write(t.encode("utf-8"))


# hero pick by element: 5 NPCs (Player 15, shared control like the author's hall heroes) sell one card per
# hero; buying a card gives that hero through the author's hero selection (gameplay.j zzVL_OnCard)
PICK = [("Kim", "H002", ["H002", "H01F", "H00V", "H00Z", "H01E", "H00L"]),
        ("Mộc", "E000", ["E000", "H01L", "E003", "H01M", "E006", "H022", "H023", "H029", "H02A"]),
        ("Thủy", "E005", ["E005", "E002", "H021", "H024", "H027", "H028", "H02B"]),
        ("Hỏa", "H00A", ["H00A", "H014", "H01P", "H020"]),
        ("Thổ", "E001", ["E001", "H01S", "H009", "H01U", "H00U", "H025", "H026"])]
PICK_COLOR = ["|cffffd700", "|cff40c040", "|cff4080ff", "|cffff4040", "|cffc08040"]


def pick_cards():
    """unit types: cards h0S0.. (copies of the author's 'Chon' unit h001) and NPCs h0E1..h0E5"""
    pu = os.path.join(SRC, "war3map.w3u")
    uver, utabs = objdata.parse(open(pu, "rb").read(), ".w3u")
    mine = [b"h0E%d" % (k + 1) for k in range(5)]
    cards = []
    utabs[1][:] = [o for o in utabs[1] if not (o[1].startswith(b"h0S") or o[1] in mine)]
    by_id = {(o if ti == 0 else n): (o, sets) for ti, tab in enumerate(utabs) for o, n, sets in tab}
    sel = by_id[b"h001"]
    npc = by_id[b"h01N"]
    k = 0
    for e, (el, rep_id, heroes) in enumerate(PICK):
        hm = {x[0]: x[4] for x in by_id[rep_id.encode()][1][0]}
        for h in heroes:
            hd = {x[0]: x[4] for x in by_id[h.encode()][1][0]}
            cid = b"h0S%s" % "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[k].encode()
            k += 1
            mods = [list(x) for x in sel[1][0] if x[0] not in (b"unam", b"uico", b"utip", b"utub")]
            nm = hd.get(b"unam", b"").decode("utf-8")
            mods += [mod(b"unam", 3, nm), mod(b"uico", 3, hd.get(b"uico", b"").decode("latin1")),
                     mod(b"utip", 3, PICK_COLOR[e] + "[" + el + "]|r " + nm),
                     mod(b"utub", 3, "Chọn " + nm + " (hệ " + el + ").")]
            utabs[1].append([sel[0], cid, [mods]])
            cards.append((cid.decode(), h, e))
        mods = [list(x) for x in npc[1][0] if x[0] not in (b"unam", b"umdl", b"uico", b"usei", b"usca")]
        mods += [mod(b"unam", 3, PICK_COLOR[e] + "Hệ " + el + "|r - chọn tướng"),
                 mod(b"umdl", 3, hm.get(b"umdl", b"").decode("latin1")),
                 mod(b"uico", 3, hm.get(b"uico", b"").decode("latin1"))]
        utabs[1].append([npc[0], mine[e], [mods]])
    open(pu, "wb").write(objdata.write(uver, utabs, ".w3u"))
    return cards


def shops():
    """Tang Kinh Cac: two NPCs (8 Bi Pho each, 5000 gold) next to the Xa Phu of each base; Bi Pho no longer drop"""
    pu = os.path.join(SRC, "war3map.w3u")
    uver, utabs = objdata.parse(open(pu, "rb").read(), ".w3u")
    utabs[1][:] = [o for o in utabs[1] if o[1] not in (b"h0B1", b"h0B2")]
    npc = next(o for o in utabs[1] if o[1] == b"h01N")
    weapons, gear = bipho_kinds()
    for k, uid in enumerate((b"h0B1", b"h0B2")):
        mods = [list(m) for m in npc[2][0] if m[0] not in (b"usei", b"unam", b"uico", b"umdl")]
        mods += [mod(b"unam", 3, ("|cffff8040Tàng Kinh Các - Bí Phổ vũ khí|r", "|cff40c0ffTàng Kinh Các - Bí Phổ trang bị|r")[k]),
                 mod(b"usei", 3, ",".join((weapons, gear + [MAT_EXTRA])[k][:12])),
                 mod(b"umdl", 3, chr(92).join(["units", "human", "Jaina", "Jaina.mdl"])),
                 mod(b"uico", 3, chr(92).join(["ReplaceableTextures", "CommandButtons", "BTNJaina.blp"]))]
        utabs[1].append([npc[0], uid, [mods]])
    # crafted pieces: the weapon shop sells the crafted weapons, the armor shop the other crafted pieces;
    # buying one takes its materials (gameplay.j zzVL_OnCraftBuy)
    slot = {i: sl for i, sl, t, nm in items()}
    rec = craft_recipes()
    cw = [pr for pr, ms in rec if slot.get(pr) == 3 or pr == "I01H"]
    ca = [pr for pr, ms in rec if pr not in cw]
    names = {b"n00K": ("|cffff8040Cửa hàng vũ khí - vũ khí chế|r", cw), b"n00L": ("|cff40c0ffCửa hàng giáp trụ - trang bị chế|r", ca),
             b"n00M": ("|cffffcc00Tàng Bảo Các - nguyên liệu|r", page_lists(MAT_SHOP + [MAT_EXTRA])[0])}
    for o, n, sets in utabs[1]:
        if n in names:
            nm, lst = names[n]
            sets[0][:] = [x for x in sets[0] if x[0] not in (b"usei", b"unam")]
            sets[0] += [mod(b"unam", 3, nm), mod(b"usei", 3, ",".join(lst[:12]))]
    for o, n, sets in utabs[0]:                      # Duoc diem also sells the tier-5 potion
        x = next((x for x in sets[0] if x[0] == b"usei"), None)
        if x is not None and b"phea" in x[4] and b"pres" not in x[4]:
            x[4] = x[4].replace(b"pgma", b"pgma,pres")
    open(pu, "wb").write(objdata.write(uver, utabs, ".w3u"))
    pt = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(pt, "rb").read(), ".w3t")
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            iid_ = (o if ti == 0 else n).decode("latin1")
            stock = None
            if iid_ in MAT_SHOP or iid_ == MAT_EXTRA:
                stock = ((b"igol", 4000), (b"isto", 10), (b"istr", 20), (b"isst", 0))
            elif iid_ in [pr for pr, ms in craft_recipes()]:
                stock = ((b"igol", 5000), (b"isto", 5), (b"istr", 5), (b"isst", 0))
            if stock:
                for key, val in stock:
                    x = next((x for x in sets[0] if x[0] == key), None)
                    if x is None:
                        sets[0].append(mod(key, 0, val))
                    else:
                        x[3], x[4] = 0, struct.pack("<i", val)
            if (o if ti == 0 else n).decode("latin1") in BIPHO:
                ms = sets[0]
                for key, val in ((b"igol", 5000), (b"isto", 3), (b"istr", 60), (b"isst", 0), (b"ilum", 0)):
                    m = next((m for m in ms if m[0] == key), None)
                    if m is None:
                        ms.append(mod(key, 0, val))
                    else:
                        m[3], m[4] = 0, struct.pack("<i", val)
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            iid = (o if ti == 0 else n).decode("latin1")
            if iid in POTIONS:
                lv, amount, abil = POTIONS[iid]
                ms = sets[0]
                text = ("|c0087ceebDạng hòa bình|r|nHồi phục |cffffcc00%d|r sinh lực và |cffffcc00%d|r nội lực trong 15 giây, "
                        "không bị ngắt khi trúng đòn.|n|cffffcc00Yêu cầu cấp %d.|r" % (amount, amount, lv))
                for key, typ, val in ((b"iabi", 3, abil), (b"utub", 3, text), (b"ides", 3, text)):
                    x = next((x for x in ms if x[0] == key), None)
                    if x is None:
                        ms.append(mod(key, typ, val))
                    else:
                        x[3], x[4] = 3, val.encode("utf-8")
    tabs[1][:] = [o for o in tabs[1] if o[1] != PAGE_ITEM.encode()]
    tabs[1].append([b"ches", PAGE_ITEM.encode(), [[
        mod(b"unam", 3, "|cffffcc00>> Trang tiếp|r"), mod(b"utip", 3, "|cffffcc00>> Trang tiếp|r"),
        mod(b"utub", 3, "Xem trang hàng tiếp theo của cửa hàng (miễn phí)."),
        mod(b"ides", 3, "Xem trang hàng tiếp theo của cửa hàng (miễn phí)."),
        mod(b"iabi", 3, ""), mod(b"igol", 0, 0), mod(b"ilum", 0, 0), mod(b"isto", 0, 1), mod(b"istr", 0, 1),
        mod(b"isst", 0, 0), mod(b"ipow", 0, 1), mod(b"icla", 3, "PowerUp"),
        mod(b"iico", 3, chr(92).join(["ReplaceableTextures", "CommandButtons", "BTNReplay-Loop.blp"]))]]])
    open(pt, "wb").write(objdata.write(ver, tabs, ".w3t"))


# potions: hero level needed, life = mana healed in 15 s, item ability (tranphai.py sets the amounts)
POTIONS = {"phea": (1, 400, "A009"), "pghe": (40, 900, "A0CS"), "pman": (80, 1600, "A0CT"),
           "pgma": (120, 2500, "A0CW"), "pres": (160, 4000, "A0TB")}


def prices():
    """sell price in the bag (key 41): half the gold cost of the custom items; others use the item level"""
    ver, tabs = objdata.parse(open(os.path.join(SRC, "war3map.w3t"), "rb").read(), ".w3t")
    rows = []
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            g = next((struct.unpack("<i", x[4])[0] for x in sets[0] if x[0] == b"igol"), 0)
            if g > 1:
                rows.append("call SaveInteger(zzVL_ht,'%s',41,%d)" % ((o if ti == 0 else n).decode("latin1"), g // 2))
    return rows


# author's arena rect -> the Thien Kiem rect (Thien Kiem world coordinates) it moves to
ARENA_RECTS = {"la": (8736, 608, 10144, 1696), "Ka": (9280, 864, 9664, 1216),          # Tong room, arrival
               "Pa": (8768, 5184, 10144, 6176), "pa": (9280, 5536, 9664, 5888),        # Kim room, arrival
               "La": (9216, 2336, 9728, 2688), "ma": (9216, 4032, 9728, 4384),         # into the field
               "qa": (8480, 2080, 10496, 4608), "Ma": (9360, 3216, 9616, 3472)}        # field, its centre


def check_names(lines, mod):
    """the 1.31 game refuses a local/parameter named like a global of another type: keep them apart"""
    glob = set()
    for l in lines[1:lines.index("endglobals")]:
        m = re.match(r"(?:constant\s+)?\w+(?:\s+array)?\s+(\w+)", l)
        if m:
            glob.add(m.group(1))
    names = set(re.findall(r"^local \w+(?: array)? (\w+)", "\n".join(mod), re.M))
    for m in re.finditer(r"takes (.*?) returns", "\n".join(mod)):
        if m.group(1) != "nothing":
            names |= {a.split()[1] for a in m.group(1).split(",")}
    bad = sorted(names & glob)
    if bad:
        sys.exit("gameplay.j: locals named like globals: " + ", ".join(bad))


def script():
    s = open(JS, "rb").read().decode("utf-8")
    if "zzVL_Init" in s:
        sys.exit("gameplay already added: run convert_text.py and fix_script.py first")
    nl = "\r\n" if "\r\n" in s else ("\r" if "\r" in s else "\n")
    lines = s.split(nl)
    rows = table()
    jass_dir = os.path.join(os.path.dirname(__file__), "jass")
    if os.path.exists(jass_dir):
        files = sorted([f for f in os.listdir(jass_dir) if f.endswith(".j")])
        mod = []
        for f in files:
            mod += open(os.path.join(jass_dir, f), "rb").read().decode("utf-8").splitlines()
        try:
            open(os.path.join(os.path.dirname(__file__), "gameplay.j"), "w", encoding="utf-8").write("\n".join(mod))
        except Exception:
            pass
    else:
        mod = open(os.path.join(os.path.dirname(__file__), "gameplay.j"), "rb").read().decode("utf-8").splitlines()
    # comments stay in gameplay.j only: the map gets plain code (no stray ' or \ for the game's parser)
    mod = [l for l in mod if l.strip() and not l.lstrip().startswith("//")]
    ks = open(os.path.join(os.path.dirname(__file__), "kskill.j"), "rb").read().decode("utf-8").splitlines()
    ks = [l for l in ks if l.strip() and not l.lstrip().startswith("//")]
    i = mod.index("function zzVL_Init takes nothing returns nothing")
    mod[i:i] = ks
    ui = open(os.path.join(os.path.dirname(__file__), "vlui.j"), "rb").read().decode("utf-8").splitlines()
    ui = [l for l in ui if l.strip() and not l.lstrip().startswith("//")]
    i = mod.index("function zzVL_Init takes nothing returns nothing")
    mod[i:i] = ui

    # the table is long (KVCT skills): one thread per 1200 rows, each with its own operation limit
    items_fn, parts = [], []
    for k in range(0, len(rows), 1200):
        parts.append("zzVL_Items%d" % (k // 1200))
        items_fn += ["function %s takes nothing returns nothing" % parts[-1]] + rows[k:k + 1200] + ["endfunction"]
    items_fn += ["function zzVL_Items takes nothing returns nothing"] + ['call ExecuteFunc("%s")' % f for f in parts] + ["endfunction"]
    check_names(lines, mod)
    g = lines.index("endglobals")
    lines[g:g] = GLOBALS.split("\n")
    g = lines.index("endglobals")
    lines[g + 1:g + 1] = DROP_FN
    for i in range(len(lines)-1, -1, -1):
        if lines[i] == "call GroupClear(V)":
            lines.insert(i + 1, "call zzVL_ReviveArenaDead()")
        if lines[i] == "call GroupClear(E)":
            lines.insert(i + 1, "call zzVL_ReviveArenaDead()")
    for i in range(g + 1 + len(DROP_FN), len(lines)):
        lines[i] = lines[i].replace("PlaceRandomItem(", "zzVL_Drop(")
        # Thuy tinh: cuong hoa theo o (gameplay.j zzVL_CuongHoa) instead of the author's swap to the +1 item
        lines[i] = lines[i].replace("GetSpellAbilityId()=='A00N' and UnitHasItem", "GetSpellAbilityId()==0 and UnitHasItem")
    # arena: the author's arena rects moved onto the Thien Kiem arena grafted by expand.py (buildrena.txt)
    sx, sy, nx, ny = map(int, open(os.path.join(os.path.dirname(SRC), "..", "build", "arena.txt")).read().split())
    for var, (x0, y0, x1, y1) in ARENA_RECTS.items():
        dx, dy = nx - sx, ny - sy
        f = next(i for i, l in enumerate(lines) if l.startswith("set %s=Rect(" % var))
        lines[f] = "set %s=Rect(%d.,%d.,%d.,%d.)" % (var, x0 + dx, y0 + dy, x1 + dx, y1 + dy)
    # arena (Lien Dau): log every step at once (the game froze at the end of the first arena), and Wz
    # (a hero leaves / dies in the field) is not run again inside itself: moving the winners out made it
    # fire again for each of them, nested, with a 2 s wait inside
    for fn in ("Pz", "Uz", "Wz", "yz", "Tz", "uz", "Sz", "tz", "Qz"):
        f = lines.index("function %s takes nothing returns nothing" % fn)
        k = f + 1
        while lines[k].startswith("local "):
            k += 1
        lines[k:k] = ['set zzVL_logMsg="arena %s"' % fn, 'call ExecuteFunc("zzVL_LogNow")']
        if fn == "Pz":
            lines[k + 2:k + 2] = ['call ExecuteFunc("zzVL_BannerArena")']
    f_xS = lines.index("function xS takes nothing returns nothing")
    local_idx = f_xS + 1
    while lines[local_idx].startswith("local "):
        local_idx += 1
    lines.insert(local_idx, "if zzVL_InArena(GetTriggerUnit()) then")
    lines.insert(local_idx + 1, "if zzVL_deadArena==null then")
    lines.insert(local_idx + 2, "set zzVL_deadArena=CreateGroup()")
    lines.insert(local_idx + 3, "endif")
    lines.insert(local_idx + 4, "call GroupAddUnit(zzVL_deadArena,GetTriggerUnit())")
    lines.insert(local_idx + 5, "return")
    lines.insert(local_idx + 6, "endif")
    f = lines.index("function Wz takes nothing returns nothing")
    lines[f] = "function zzVL_Wz0 takes nothing returns nothing"
    e = lines.index("endfunction", f)
    lines[e + 1:e + 1] = ["function Wz takes nothing returns nothing",
                          "if zzVL_wzBusy then",
                          "if IsUnitInGroup(GetTriggerUnit(),V) then", "call GroupRemoveUnit(V,GetTriggerUnit())",
                          "elseif IsUnitInGroup(GetTriggerUnit(),E) then", "call GroupRemoveUnit(E,GetTriggerUnit())", "endif",
                          "return", "endif",
                          "set zzVL_wzBusy=true", "call zzVL_Wz0()", "set zzVL_wzBusy=false", "endfunction"]
    # the author's AI buys its first set at 800 gold: everyone starts with a set now (zzVL_TpTick)
    f = lines.index("function lM takes nothing returns boolean")
    lines[f + 1] = "return false"
    # the author's ground-item cleanup (every 100 s) leaked a group and a location per item
    # ... and ran every 100 s: now every 5 min, an item goes on its second pass (5-10 min on the ground)
    f = lines.index("call TriggerRegisterTimerEventPeriodic(nE,100.)")
    # every 60 s; an item still on the ground at its second pass is removed (60-120 s), units nearby or not:
    # camps kept creeps next to the drops, the ground filled up and the game froze around minute 13
    lines[f] = "call TriggerRegisterTimerEventPeriodic(nE,60.)"
    f = lines.index("function St takes nothing returns nothing")
    e = lines.index("endfunction", f)
    lines[f:f] = ["function zzVL_StLog takes nothing returns nothing", 'set zzVL_logMsg="don do dat"', 'call ExecuteFunc("zzVL_LogNow")', "endfunction"]
    f += 4
    e += 4
    t = lines.index("call EnumItemsInRectBJ(Wi,function St)")
    lines.insert(t, "call zzVL_StLog()")
    lines[f + 1:e] = ["if IsItemVisible(GetEnumItem()) and GetWidgetLife(GetEnumItem())>0 then",
                      "if LoadInteger(zzVL_ht,GetHandleId(GetEnumItem()),67)==1 then",
                      "call FlushChildHashtable(zzVL_ht,GetHandleId(GetEnumItem()))",
                      "call RemoveItem(GetEnumItem())", "else",
                      "call SaveInteger(zzVL_ht,GetHandleId(GetEnumItem()),67,1)", "endif", "endif"]
    m = lines.index("function main takes nothing returns nothing")
    lines[m:m] = items_fn + mod
    m = lines.index("function main takes nothing returns nothing")
    e = lines.index("endfunction", m)
    lines.insert(e, 'call ExecuteFunc("zzVL_Init")')      # own thread: the author's init already uses much of the limit
    open(JS, "wb").write(nl.join(lines).encode("utf-8"))
    return len(rows)


def mod(mid, typ, val):
    if typ == 3:
        return [mid, None, None, 3, val.encode("utf-8"), b"\0\0\0\0"]
    return [mid, None, None, 0, struct.pack("<i", val), b"\0\0\0\0"]


def objects():
    p = os.path.join(SRC, "war3map.w3t")
    ver, tabs = objdata.parse(open(p, "rb").read(), ".w3t")
    abil = {}
    for ti, tab in enumerate(tabs):
        for o, n, sets in tab:
            d = {m[0]: m[4] for m in sets[0]}
            abil[o if ti == 0 else n] = d
    for i, (cid, name, abis, stats, icon) in enumerate(CLOAKS):
        assert all(o[1] != cid.encode() for o in tabs[1])
        if stats is None:
            stats = abil[b"lgdh"][b"utub"].decode("utf-8").replace("|c008080ffTrang bị hoàng kim|r\r\n\r\n", "")
        col = "|cffff8000" if i == 4 else "|cffffcc00"
        tabs[1].append([b"clfm", cid.encode(), [[
            mod(b"unam", 3, col + name + "|r"),
            mod(b"utip", 3, col + name + "|r"),
            mod(b"utub", 3, stats + "|n|n|cff808080Nhận khi đạt quân hàm " + RANK[i] + ". Không bỏ, không bán được.|r"),
            mod(b"ides", 3, stats + "|n|n|cff808080Phi phong quân hàm " + RANK[i] + ". Không bỏ, không bán được.|r"),
            mod(b"iabi", 3, abis),
            mod(b"iico", 3, "ReplaceableTextures\\CommandButtons\\" + icon + ".blp"),
            mod(b"igol", 0, 0),
            mod(b"ilum", 0, 0),
            mod(b"idro", 0, 0),
            mod(b"idrp", 0, 0),
            mod(b"ipaw", 0, 0),
            mod(b"isel", 0, 0),
            mod(b"ilev", 0, 1 + i),
            mod(b"icla", 3, "Permanent"),
        ]]])
    for jid, kind, t, name in jewels():
        assert all(o[1] != jid.encode() for o in tabs[1]), jid
        slot, kname, _, stat = JEWELS[kind]
        col = TIER_COLOR[t - 1]
        text = ("|cffffcc00%s|r - phẩm %d/5" % (kname, t) + "|n|cffffcc00Cơ bản|r: " + stat(t) +
                "|n|n|cff9a9a9aMặc vào ô %s của bảng Nhân Vật (phím C), không chiếm túi đồ. "
                "Bấm trong Hành Trang (B) để mặc, bấm ô trên bảng Nhân Vật để tháo. "
                "Cường hóa ô bằng Thủy tinh, khảm được 2 lỗ.|r" % kname)
        tabs[1].append([b"clfm", jid.encode(), [[
            mod(b"unam", 3, col + name + "|r"),
            mod(b"utip", 3, col + name + "|r"),
            mod(b"utub", 3, text),
            mod(b"ides", 3, text),
            mod(b"iabi", 3, ""),
            mod(b"iico", 3, "war3mapImported\\vl_eq_%d.blp" % (slot + 1)),
            mod(b"igol", 0, 120 * t),
            mod(b"ilum", 0, 0),
            mod(b"idro", 0, 1),
            mod(b"ipaw", 0, 1),
            mod(b"isel", 0, 1),
            mod(b"ilev", 0, 2 * t),
            mod(b"icla", 3, "Permanent"),
        ]]])
    open(p, "wb").write(objdata.write(ver, tabs, ".w3t"))
    pu = os.path.join(SRC, "war3map.w3u")
    uver, utabs = objdata.parse(open(pu, "rb").read(), ".w3u")
    if all(o[1] != b"h0XP" for o in utabs[1]):
        npc = next(o for o in utabs[1] if o[1] == b"h01N")
        mods = [list(m) for m in npc[2][0] if m[0] not in (b"usei", b"unam", b"uico", b"umdl")]
        mods += [mod(b"unam", 3, "|cffffcc00Xa Phu|r"), mod(b"umdl", 3, chr(92).join(["units", "critters", "VillagerMan1", "VillagerMan1.mdl"])),
                 mod(b"uico", 3, chr(92).join(["ReplaceableTextures", "CommandButtons", "BTNVillagerMan1.blp"]))]
        utabs[1].append([npc[0], b"h0XP", [mods]])
        open(pu, "wb").write(objdata.write(uver, utabs, ".w3u"))
    shops()
    misc()
    pick_cards()
    # frame templates for the Hanh Trang panel (EscMenuBackdrop, ScriptDialogButton, ...)
    toc = os.path.join(SRC, "war3mapImported", "vltk.toc")
    os.makedirs(os.path.dirname(toc), exist_ok=True)
    lines = ["UI" + chr(92) + "FrameDef" + chr(92) + "UI" + chr(92) + "EscMenuTemplates.fdf",
             "UI" + chr(92) + "FrameDef" + chr(92) + "Glue" + chr(92) + "StandardTemplates.fdf", "", ""]
    open(toc, "wb").write("".join(x + chr(13) + chr(10) for x in lines).encode("ascii"))
    return len(CLOAKS)


if __name__ == "__main__":
    print("item table rows:", script())
    if "--script-only" not in sys.argv:
        print("cloaks:", objects())
