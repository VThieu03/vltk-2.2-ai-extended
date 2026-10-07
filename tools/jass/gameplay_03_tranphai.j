// ---- tuyet hoc tran phai (tranphai.py): skill of the hero's sect, given at level 15, level = (hero level-10)/5 up to 5.
// zzVL_tpEnd[pid*12+k]: end of the buff of skill k (0 Thuan Duong shield, 1 Duy Nga Doc Ton, 3 Kim Chung Trao)

// ==========================================
// Hàm: zzVL_MainStat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
// Trả về dữ liệu kiểu: real
function zzVL_MainStat takes unit vl_hero returns real
    local integer vl_string=GetHeroStr(vl_hero,true)
    if GetHeroAgi(vl_hero,true)>vl_string then
        set vl_string=GetHeroAgi(vl_hero,true)
    endif
    if GetHeroInt(vl_hero,true)>vl_string then
        set vl_string=GetHeroInt(vl_hero,true)
    endif
    return I2R(vl_string)
endfunction

// ==========================================
// Hàm: zzVL_Phe
// Hệ của tướng (config.py mục 15, khóa 99 trên loại tướng): 1 ngoại công, 2 nội công; 1 nếu không phải tướng có phái (quái tính là ngoại).
function zzVL_Phe takes unit vl_u returns integer
    if zzHT_He(vl_u)==2 then
        return 2
    endif
    return 1
endfunction

// ==========================================
// Hàm: zzVL_PheAtk
// Sức mạnh đòn kỹ năng theo hệ: % sát thương vũ khí + hệ số × Sức mạnh / Thân pháp / Nội công (khóa 0/450..457, ×100).
// Trả về -1 nếu tướng chưa có hệ (khi đó dùng cách cũ: vũ khí + chỉ số chính).
function zzVL_PheAtk takes unit vl_h,real vl_weapon returns real
    local integer vl_k
    if zzHT_He(vl_h)==0 or not IsUnitType(vl_h,UNIT_TYPE_HERO) then
        return -1.
    endif
    set vl_k=450+4*(zzVL_Phe(vl_h)-1)
    return vl_weapon*LoadInteger(zzVL_ht,0,vl_k)/100.+(GetHeroStr(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+1)+GetHeroAgi(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+2)+GetHeroInt(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+3))/100.
endfunction

// ==========================================
// Hàm: zzVL_PheDodge
// Né tránh (phần nghìn trước khi trừ đánh trúng) của tướng vl_t trước đòn hệ vl_phe:
// ngoại = Thân pháp/2 + dòng né tránh + khóa 25 (buff né ngoại); nội = Nội công × khóa 0/458 /100 + dòng né tránh + khóa 26 (buff né nội).
function zzVL_PheDodge takes unit vl_t,integer vl_pt,integer vl_phe returns integer
    if vl_phe==2 then
        return R2I(GetHeroInt(vl_t,true)*LoadInteger(zzVL_ht,0,458)/100.)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NOI_BUFF())
    endif
    return R2I(GetHeroAgi(vl_t,true)/2.0)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NGOAI_BUFF())
endfunction

// ==========================================
// Hàm: zzVL_TpFoe
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_unit (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_TpFoe takes unit vl_hero,unit vl_unit returns boolean
    return GetWidgetLife(vl_unit)>.405 and IsUnitEnemy(vl_unit,GetOwningPlayer(vl_hero)) and not IsUnitType(vl_unit,UNIT_TYPE_STRUCTURE)
endfunction

// ==========================================
// Hàm: zzVL_TpHit
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_unit (unit)
//   - vl_d (real)
// Không trả về giá trị (thực thi hành động).
function zzVL_TpHit takes unit vl_hero,unit vl_unit,real vl_d returns nothing
    set zzVL_inTp=true
    call UnitDamageTarget(vl_hero,vl_unit,vl_d,true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    set zzVL_inTp=false
endfunction

// ==========================================
// Hàm: zzVL_TpTick
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_playerId (integer)
//   - vl_hero (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_TpTick takes integer vl_playerId,unit vl_hero returns nothing
    local integer vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),50)
    local integer vl_lv=GetHeroLevel(vl_hero)
    local integer vl_w
    if not zzVL_gotStart[vl_playerId] then
        set zzVL_gotStart[vl_playerId]=true
        set zzVL_potion=CreateItem('phea',GetUnitX(vl_hero),GetUnitY(vl_hero))
        call SetItemCharges(zzVL_potion,10)
        call UnitAddItem(vl_hero,zzVL_potion)
        set zzVL_potion=null
    endif
    if vl_ab!=0 and vl_lv>=75 then
        set vl_w=(vl_lv-50)/25
        if vl_w>5 then
            set vl_w=5
        endif
        if GetUnitAbilityLevel(vl_hero,vl_ab)==0 then
            call UnitAddAbility(vl_hero,vl_ab)
            call UnitMakeAbilityPermanent(vl_hero,true,vl_ab)
            if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER then
                call zzVL_Msg(vl_playerId,"|cffff8000Lĩnh ngộ tuyệt học trấn phái:|r "+GetObjectName(vl_ab)+" (ô giữa bảng lệnh). Lên cấp mỗi 25 cấp tướng.")
            endif
        endif
        if GetUnitAbilityLevel(vl_hero,vl_ab)!=vl_w then
            call SetUnitAbilityLevel(vl_hero,vl_ab,vl_w)
        endif
    endif
    if zzVL_wel[vl_playerId]==4 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*zzVL_HealMul(vl_hero))
        call SetUnitState(vl_hero,UNIT_STATE_MANA,GetUnitState(vl_hero,UNIT_STATE_MANA)+GetUnitState(vl_hero,UNIT_STATE_MAX_MANA)*.008)
    endif
    set vl_lv=GetUnitAbilityLevel(vl_hero,'A0TA')
    if vl_lv>0 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*vl_lv)
    endif
endfunction

// ==========================================
// Hàm: zzVL_TpDef
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_src (unit)
//   - vl_tgt (unit)
//   - vl_pt (integer)
//   - vl_d (real)
// Trả về dữ liệu kiểu: real
function zzVL_TpDef takes unit vl_src,unit vl_tgt,integer vl_pt,real vl_d returns real
    local real vl_now=TimerGetElapsed(zzVL_clock)
    local real vl_a
    local integer vl_lv
    if vl_pt>9 or vl_tgt!=Jx[vl_pt+1] then
        return vl_d
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12+1] then
        set vl_d=vl_d*(.85-.05*GetUnitAbilityLevel(vl_tgt,'A0T1'))
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12+3] then
        set vl_lv=GetUnitAbilityLevel(vl_tgt,'A0T3')
        set vl_d=vl_d*(.85-.05*vl_lv)
        if not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=null and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and vl_now-zzUS_Real(GetHandleId(vl_tgt),zzUS_TP_REFLECT_LAST())>=.3 then
            call zzUS_SetReal(GetHandleId(vl_tgt),zzUS_TP_REFLECT_LAST(),vl_now)
            call zzVL_TpHit(vl_tgt,vl_src,vl_d*.1*vl_lv)
        endif
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12] and zzVL_shield[vl_pt]>0. then
        set vl_a=vl_d
        if vl_a>zzVL_shield[vl_pt] then
            set vl_a=zzVL_shield[vl_pt]
        endif
        set zzVL_shield[vl_pt]=zzVL_shield[vl_pt]-vl_a
        set vl_d=vl_d-vl_a
    endif
    return vl_d
endfunction

// ==========================================
// Hàm: zzVL_TpUnpause
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_TpUnpause takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    call PauseUnit(LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0),false)
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_TpPoison
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_TpPoison takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_hero=LoadUnitHandle(zzVL_ht,vl_id,0)
    local unit vl_unit=LoadUnitHandle(zzVL_ht,vl_id,1)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)+1
    if vl_hero!=null and vl_unit!=null and GetWidgetLife(vl_unit)>.405 then
        call zzVL_TpHit(vl_hero,vl_unit,LoadReal(zzVL_ht,vl_id,2))
        if LoadInteger(zzVL_ht,vl_id,4)==1 then
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl",vl_unit,"chest"))
        else
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",vl_unit,"chest"))
        endif
    endif
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    // slot 5: number of ticks (KVCT doc sat N lan, kskill.j key 166); 5 when not given
    if (vl_n>=5 and LoadInteger(zzVL_ht,vl_id,5)==0) or (LoadInteger(zzVL_ht,vl_id,5)>0 and vl_n>=LoadInteger(zzVL_ht,vl_id,5)) or vl_unit==null or GetWidgetLife(vl_unit)<.405 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_hero=null
    set vl_unit=null
endfunction

// ==========================================
// Hàm: zzVL_CuongSlot
// Cường hóa trực tiếp theo ô trang bị (0..9)
function zzVL_CuongSlot takes unit vl_hero,integer vl_slot returns boolean
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local string array vl_n
    if vl_playerId>9 or vl_hero!=Jx[vl_playerId+1] or vl_slot<0 or vl_slot>9 then
        return false
    endif
    if zzVL_cuong[vl_playerId*10+vl_slot]>=10 then
        call zzVL_Msg(vl_playerId,"Ô này đã cường hóa tối đa +10.")
        return false
    endif
    set zzVL_cuong[vl_playerId*10+vl_slot]=zzVL_cuong[vl_playerId*10+vl_slot]+1
    set vl_n[0]="Nón (+mọi chỉ số, sinh lực)"
    set vl_n[1]="Áo (giảm sát thương, kháng vật lý)"
    set vl_n[2]="Yêu Đái (sinh lực, kháng độc/thủy)"
    set vl_n[3]="Hộ Uyển (tốc đánh, kháng hỏa/lôi)"
    set vl_n[4]="Hài (tốc chạy, né tránh)"
    set vl_n[5]="Vũ Khí (sát thương %, STVL ngoại công)"
    set vl_n[6]="Hạng Liên (bạo kích, STVL nội công, xuất chiêu)"
    set vl_n[7]="Giới Chỉ (đánh trúng, hút máu, sát thương %)"
    set vl_n[8]="Ngọc Bội (hút mana, kháng 5 hệ)"
    set vl_n[9]="Hộ Thân Phù (sinh lực, giảm ST, +1 cấp kỹ năng khi +10)"
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_hero,"origin"))
    call zzVL_Text(vl_hero,"|cffffcc00Cường hóa +"+I2S(zzVL_cuong[vl_playerId*10+vl_slot])+"|r")
    call zzVL_Msg(vl_playerId,"|cffffcc00Cường hóa|r "+vl_n[vl_slot]+": |cffffcc00+"+I2S(zzVL_cuong[vl_playerId*10+vl_slot])+"|r")
    call zzVL_AffixSum(vl_playerId)
    return true
endfunction

// ==========================================
// Hàm: zzVL_CuongDo
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_item (item)
// Trả về dữ liệu kiểu: boolean
function zzVL_CuongDo takes unit vl_hero,item vl_item returns boolean
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_k
    local integer vl_slot=0
    if vl_playerId>9 or vl_item==null or vl_hero!=Jx[vl_playerId+1] then
        return false
    endif
    set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10-1
    if vl_k==0 then
        set vl_slot=0
    elseif vl_k==1 then
        set vl_slot=1
    elseif vl_k==2 then
        set vl_slot=5
    elseif vl_k==3 then
        set vl_slot=4
    else
        set vl_slot=0
    endif
    return zzVL_CuongSlot(vl_hero,vl_slot)
endfunction

// ==========================================
// Hàm: zzVL_CuongHoa
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_CuongHoa takes unit vl_hero,item vl_item returns nothing
    if not zzVL_CuongDo(vl_hero,vl_item) and vl_hero!=null then
        call zzGL_Give(GetPlayerId(GetOwningPlayer(vl_hero)),1)
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnTpCast
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnTpCast takes nothing returns nothing
    local unit vl_hero=GetTriggerUnit()
    local integer vl_ab=GetSpellAbilityId()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
    local real vl_st=zzVL_MainStat(vl_hero)
    local real vl_now=TimerGetElapsed(zzVL_clock)
    local real vl_x
    local real vl_y
    local real vl_a
    local real vl_d
    local unit vl_unit
    local unit vl_t=GetSpellTargetUnit()
    local group vl_g
    local timer vl_tm
    call zzVL_Log("skill "+GetObjectName(GetSpellAbilityId())+" - "+GetUnitName(GetTriggerUnit()))
    if vl_playerId>9 then
        set vl_hero=null
        set vl_t=null
        return
    endif
    if vl_ab=='A00N' then
        call zzVL_CuongHoa(vl_hero,GetSpellTargetItem())
    elseif vl_ab=='A0T0' then
        set zzVL_shield[vl_playerId]=GetUnitState(vl_hero,UNIT_STATE_MANA)*(.4+.15*vl_lv)
        set zzVL_tpEnd[vl_playerId*12]=vl_now+12.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl",vl_hero,"origin"))
        call zzVL_Text(vl_hero,"|cff80c0ffLá chắn "+I2S(R2I(zzVL_shield[vl_playerId]))+"|r")
    elseif vl_ab=='A0T1' then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*(.15+.05*vl_lv))
        set zzVL_tpEnd[vl_playerId*12+1]=vl_now+8.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",vl_hero,"origin"))
    elseif vl_ab=='A0T3' then
        set zzVL_tpEnd[vl_playerId*12+3]=vl_now+8.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl",vl_hero,"origin"))
    elseif vl_ab=='A0T4' or vl_ab=='A0T8' then
        set vl_g=CreateGroup()
        if vl_ab=='A0T4' then
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),800.,null)
        else
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),450.,null)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",GetUnitX(vl_hero),GetUnitY(vl_hero)))
        endif
        loop
            set vl_unit=FirstOfGroup(vl_g)
            exitwhen vl_unit==null
            call GroupRemoveUnit(vl_g,vl_unit)
            if vl_ab=='A0T4' then
                if GetWidgetLife(vl_unit)>.405 and IsUnitAlly(vl_unit,GetOwningPlayer(vl_hero)) and IsUnitType(vl_unit,UNIT_TYPE_HERO) then
                    call SetWidgetLife(vl_unit,GetWidgetLife(vl_unit)+200.*vl_lv+2.*GetHeroInt(vl_hero,true))
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl",vl_unit,"origin"))
                endif
            elseif zzVL_TpFoe(vl_hero,vl_unit) then
                call zzVL_TpHit(vl_hero,vl_unit,100.*vl_lv+2.*vl_st)
                if GetWidgetLife(vl_unit)>.405 and not IsUnitPaused(vl_unit) then
                    call PauseUnit(vl_unit,true)
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl",vl_unit,"origin"))
                    set vl_tm=CreateTimer()
                    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_unit)
                    call TimerStart(vl_tm,1.+.25*vl_lv,false,function zzVL_TpUnpause)
                endif
            endif
        endloop
        call DestroyGroup(vl_g)
    elseif vl_ab=='A0T5' or vl_ab=='A0T7' then
        set vl_x=GetSpellTargetX()
        set vl_y=GetSpellTargetY()
        set vl_a=Atan2(vl_y-GetUnitY(vl_hero),vl_x-GetUnitX(vl_hero))
        set vl_g=CreateGroup()
        if vl_ab=='A0T5' then
            set vl_d=150.*vl_lv+3.*vl_st
            call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,300.,null)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",vl_x,vl_y))
        else
            set vl_d=120.*vl_lv+3.*vl_st
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),800.,null)
        endif
        loop
            set vl_unit=FirstOfGroup(vl_g)
            exitwhen vl_unit==null
            call GroupRemoveUnit(vl_g,vl_unit)
            if zzVL_TpFoe(vl_hero,vl_unit) then
                if vl_ab=='A0T5' then
                    call zzVL_TpHit(vl_hero,vl_unit,vl_d)
                    set vl_x=Atan2(GetUnitY(vl_unit)-GetSpellTargetY(),GetUnitX(vl_unit)-GetSpellTargetX())
                    call SetUnitPosition(vl_unit,GetUnitX(vl_unit)+180.*Cos(vl_x),GetUnitY(vl_unit)+180.*Sin(vl_x))
                else
                    set vl_x=Atan2(GetUnitY(vl_unit)-GetUnitY(vl_hero),GetUnitX(vl_unit)-GetUnitX(vl_hero))-vl_a
                    if Cos(vl_x)>=.866 then
                        call zzVL_TpHit(vl_hero,vl_unit,vl_d)
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\WardenMissile\\WardenMissile.mdl",vl_unit,"chest"))
                    endif
                endif
            endif
        endloop
        call DestroyGroup(vl_g)
    elseif vl_ab=='A0T6' and vl_t!=null then
        set vl_d=130.*vl_lv+3.*vl_st
        call zzVL_TpHit(vl_hero,vl_t,vl_d)
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+vl_d*.5)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",vl_t,"chest"))
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.1)
        call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
    elseif vl_ab=='A0T9' and vl_t!=null then
        set vl_a=GetWidgetLife(vl_hero)*.15
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)-vl_a)
        call zzVL_TpHit(vl_hero,vl_t,150.*vl_lv+4.*vl_st+vl_a)
        call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl",vl_t,"origin"))
    endif
    set vl_hero=null
    set vl_t=null
    set vl_unit=null
    set vl_g=null
    set vl_tm=null
endfunction

// ==========================================
// Hàm: zzVL_TpAi
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_t (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_TpAi takes unit vl_hero,unit vl_t returns boolean
    local integer vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),50)
    local integer vl_lv
    local integer vl_k
    local integer vl_o
    if vl_ab==0 or vl_t==null then
        return false
    endif
    set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
    if vl_lv==0 or BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)>.01 or GetUnitState(vl_hero,UNIT_STATE_MANA)<BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
        return false
    endif
    set vl_k=LoadInteger(zzVL_ht,vl_ab,51)
    set vl_o=LoadInteger(zzVL_ht,vl_ab,52)
    if vl_k==1 then
        return IssueTargetOrderById(vl_hero,vl_o,vl_t)
    elseif vl_k==2 then
        return IssuePointOrderById(vl_hero,vl_o,GetUnitX(vl_t),GetUnitY(vl_t))
    elseif vl_k==0 and (IsUnitInRange(vl_hero,vl_t,400.) or GetWidgetLife(vl_hero)<GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.6) then
        return IssueImmediateOrderById(vl_hero,vl_o)
    endif
    return false
endfunction
