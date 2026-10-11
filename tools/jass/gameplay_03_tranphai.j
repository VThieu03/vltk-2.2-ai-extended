// ---- hệ phái ngoại/nội công + hàm dùng chung cho sát thương kỹ năng KVCT (TpHit/TpFoe...). Tuyệt học trấn phái kiểu Thiên Kiếm đã bỏ:
// trấn phái = skill ô 11 của KVCT (kskill). zzVL_tpEnd[pid*12] / zzVL_shield: hộ thuẫn kind 9 của KVCT.

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
// Sức mạnh đòn kỹ năng theo hệ: % sát thương vũ khí + hệ số × Sức mạnh / Thân pháp / Nội công + % × Nội lực tối đa
// (khóa 0/450..459, ×100; phái nội công dùng Nội lực tối đa làm sức mạnh, xem config.py mục 15 PHE_SKILL_SCALE).
// Trả về -1 nếu tướng chưa có hệ (khi đó dùng cách cũ: vũ khí + chỉ số chính).
function zzVL_PheAtk takes unit vl_h,real vl_weapon returns real
    local integer vl_k
    if zzHT_He(vl_h)==0 or not IsUnitType(vl_h,UNIT_TYPE_HERO) then
        return -1.
    endif
    set vl_k=450+5*(zzVL_Phe(vl_h)-1)
    return vl_weapon*LoadInteger(zzVL_ht,0,vl_k)/100.+(GetHeroStr(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+1)+GetHeroAgi(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+2)+GetHeroInt(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+3))/100.+GetUnitState(vl_h,UNIT_STATE_MAX_MANA)*LoadInteger(zzVL_ht,0,vl_k+4)/100./100.
endfunction

// ==========================================
// Hàm: zzVL_PheDodge
// Né tránh (phần nghìn trước khi trừ đánh trúng) của tướng vl_t trước đòn hệ vl_phe:
// ngoại = Thân pháp/2 + dòng né tránh + khóa 25 (buff né ngoại); nội = Nội công × khóa 0/458 /100 + dòng né tránh + khóa 26 (buff né nội).
function zzVL_PheDodge takes unit vl_t,integer vl_pt,integer vl_phe returns integer
    if vl_phe==2 then
        return R2I(GetHeroInt(vl_t,true)*LoadInteger(zzVL_ht,0,460)/100.)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NOI_BUFF())
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
    if not zzVL_gotStart[vl_playerId] then
        set zzVL_gotStart[vl_playerId]=true
        set zzVL_potion=CreateItem('phea',GetUnitX(vl_hero),GetUnitY(vl_hero))
        call SetItemCharges(zzVL_potion,10)
        call UnitAddItem(vl_hero,zzVL_potion)
        set zzVL_potion=null
    endif
    if zzVL_wel[vl_playerId]==4 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*zzVL_HealMul(vl_hero))
        call SetUnitState(vl_hero,UNIT_STATE_MANA,GetUnitState(vl_hero,UNIT_STATE_MANA)+GetUnitState(vl_hero,UNIT_STATE_MAX_MANA)*.008)
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
    if vl_pt>9 or vl_tgt!=Jx[vl_pt+1] then
        return vl_d
    endif
    // hộ thuẫn (kind 9 của KVCT, kskill.j): zzVL_shield hấp thụ sát thương tới hết zzVL_tpEnd
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
// Hàm: zzVL_OnCuongHoaCast
// Chức năng: Thủy tinh (ability A00N) cường hóa trang bị theo ô (zzVL_CuongHoa). Hệ tuyệt học trấn phái kiểu
// Thiên Kiếm (A0T0-A0TA) đã bỏ: trấn phái = skill ô 11 của KVCT (kskill), xem docs/KIEN_TRUC_CODE.md.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnCuongHoaCast takes nothing returns nothing
    local unit vl_hero=GetTriggerUnit()
    if GetSpellAbilityId()=='A00N' and GetPlayerId(GetOwningPlayer(vl_hero))<=9 then
        call zzVL_CuongHoa(vl_hero,GetSpellTargetItem())
    endif
    set vl_hero=null
endfunction
