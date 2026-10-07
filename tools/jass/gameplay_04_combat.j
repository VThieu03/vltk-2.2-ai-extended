// ---- set bonus, element fix-up, Thuy regeneration: every second

// ==========================================
// Hàm: zzVL_Tick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Tick takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_i
    local integer vl_v
    local integer vl_string
    local integer vl_lv
    local integer array vl_best
    local unit vl_hero
    local item vl_item
    local real vl_xg
    call zzVL_Log("tick "+I2S(GetPlayerState(Player(0),PLAYER_STATE_RESOURCE_GOLD)))
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null then
            // cap 200 sau khoang 20 phut: kinh nghiem nhanh hon khi tuong cham hon nhip, cham lai khi vuot nhip
            set vl_xg=200.*TimerGetElapsed(zzVL_clock)/1200.-I2R(GetHeroLevel(vl_hero))
            call SetPlayerHandicapXP(Player(vl_playerId),RMinBJ(15.,RMaxBJ(.25,1.+.25*vl_xg)))
            if vl_xg>3. and GetHeroLevel(vl_hero)<200 and GetWidgetLife(vl_hero)>.405 then
                call AddHeroXP(vl_hero,R2I(15.*I2R(GetHeroLevel(vl_hero))*(vl_xg-3.)),true)
            endif
            if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_COMPUTER then
                call SetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)+4)
            endif
            if zzVL_pn[vl_playerId]==null then
                set zzVL_pn[vl_playerId]=GetHeroProperName(vl_hero)
            endif
            call zzVL_TpTick(vl_playerId,vl_hero)
            // the author left two heroes out of the element groups
            if zzVL_HeU(vl_hero)==0 then
                if GetUnitTypeId(vl_hero)=='H00V' then
                    call GroupAddUnit(qx,vl_hero)
                elseif GetUnitTypeId(vl_hero)=='E006' then
                    call GroupAddUnit(Qx,vl_hero)
                endif
            endif
            set zzVL_he[vl_playerId]=zzVL_HeU(vl_hero)
            call zzVL_AffixSum(vl_playerId)
            // cấp bộ ngũ hành = món thấp nhất trong đủ 10 ô trang bị (thiếu 1 ô: 0). Trang bị KVCT tính theo bậc cường hóa
            // (config.py GAME: BO_CAP_BAC_*), đồ cũ của map tính theo cấp ghi trong khóa 0 (1..5)
            set vl_lv=5
            set vl_i=0
            loop
                exitwhen vl_i>9
                set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
                if vl_item==null then
                    set vl_lv=0
                elseif zzEQ_IsKv(GetItemTypeId(vl_item)) then
                    set vl_v=zzEQ_Tier(vl_item)
                    if vl_v>=zzCF_BO_CAP5_TU_BAC() then
                        set vl_v=5
                    elseif vl_v>=zzCF_BO_CAP4_TU_BAC() then
                        set vl_v=4
                    elseif vl_v>=zzCF_BO_CAP3_TU_BAC() then
                        set vl_v=3
                    elseif vl_v>=zzCF_BO_CAP2_TU_BAC() then
                        set vl_v=2
                    else
                        set vl_v=1
                    endif
                    set vl_lv=IMinBJ(vl_lv,vl_v)
                else
                    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
                    set vl_lv=IMinBJ(vl_lv,IMaxBJ(0,vl_v-(vl_v/10)*10))
                endif
                set vl_i=vl_i+1
            endloop
            if vl_lv!=zzVL_set[vl_playerId] then
                if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER then
                    if vl_lv>0 then
                        call zzVL_Msg(vl_playerId,"|cffffcc00Bộ trang bị "+zzVL_hn[zzVL_he[vl_playerId]]+" cấp "+I2S(vl_lv)+"/5|r: "+zzVL_SetText(zzVL_he[vl_playerId],vl_lv))
                    else
                        call zzVL_Msg(vl_playerId,"|cffff8000Bộ trang bị không còn đủ 10 món|r")
                    endif
                endif
                set zzVL_set[vl_playerId]=vl_lv
            endif
            // Bộ Thủy: hồi 0.5% sinh lực tối đa mỗi giây cho mỗi cấp bộ (giảm một nửa nếu đang bị Thiêu đốt)
            if zzVL_he[vl_playerId]==4 and vl_lv>0 and GetWidgetLife(vl_hero)>.405 then
                call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.005*vl_lv*zzVL_HealMul(vl_hero))
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
    set vl_item=null
endfunction
// ---- damage: set bonus, cuong hoa, quan ham, ngu hanh on normal attacks

// ==========================================
// Hàm: zzVL_SlowEnd
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_SlowEnd takes nothing returns nothing
    local timer vl_tm=GetExpiredTimer()
    local unit vl_unit=LoadUnitHandle(zzVL_ht,GetHandleId(vl_tm),0)
    if vl_unit!=null then
        call SetUnitMoveSpeed(vl_unit,zzUS_Real(GetHandleId(vl_unit),zzUS_SLOW_SPEED()))
        call zzUS_SetInt(GetHandleId(vl_unit),zzUS_SLOWED(),0)
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_tm))
    call DestroyTimer(vl_tm)
    set vl_tm=null
    set vl_unit=null
endfunction

// ==========================================
// Hàm: zzVL_WeaponHit
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_ps (integer)
//   - vl_hero (unit)
//   - vl_t (unit)
//   - vl_d (real)
//   - vl_atk (boolean)
// Không trả về giá trị (thực thi hành động).
function zzVL_WeaponHit takes integer vl_ps,unit vl_hero,unit vl_t,real vl_d,boolean vl_atk returns nothing
    local timer vl_tm
    if (zzVL_wel[vl_ps]==2 or zzVL_wel[vl_ps]==5) and vl_atk and GetWidgetLife(vl_t)>.405 then
        set vl_tm=CreateTimer()
        if zzVL_wel[vl_ps]==5 then
            call SaveInteger(zzVL_ht,GetHandleId(vl_tm),4,1)
        endif
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.03)
        call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        set vl_tm=null
    elseif zzVL_wel[vl_ps]==3 and GetRandomInt(1,100)<=7 and GetWidgetLife(vl_t)>.405 and not IsUnitPaused(vl_t) and not IsUnitType(vl_t,UNIT_TYPE_STRUCTURE) then
        call PauseUnit(vl_t,true)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_t,"overhead"))
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
        call TimerStart(vl_tm,.7,false,function zzVL_TpUnpause)
        set vl_tm=null
    elseif zzVL_wel[vl_ps]==4 and vl_atk and GetWidgetLife(vl_t)>.405 and zzUS_Int(GetHandleId(vl_t),zzUS_SLOWED())==0 then
        call zzUS_SetInt(GetHandleId(vl_t),zzUS_SLOWED(),1)
        call zzUS_SetReal(GetHandleId(vl_t),zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t))
        call SetUnitMoveSpeed(vl_t,GetUnitMoveSpeed(vl_t)*.7)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",vl_t,"chest"))
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
        call TimerStart(vl_tm,2.,false,function zzVL_SlowEnd)
        set vl_tm=null
    endif
endfunction

// Trả về true nếu vl_u là tướng người chơi đang kích hoạt bộ Thổ (Kiên định):
// miễn nhiễm choáng của bộ Kim và làm chậm của bộ Thủy.
function zzVL_Steady takes unit vl_u returns boolean
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_u))
    return vl_p<10 and vl_u==Jx[vl_p+1] and zzVL_he[vl_p]==3 and zzVL_set[vl_p]>0
endfunction

// Hiệu ứng trạng thái của bộ ngũ hành, gọi khi tướng (vl_hero, người chơi vl_ps) đánh thường trúng vl_t.
// vl_d là sát thương cuối cùng của đòn; vl_fire = true nếu đòn này vừa nổ gấp đôi nhờ bộ Hỏa.
// Khóa hashtable trên đơn vị bị đánh: 76 = lúc được choáng tiếp (Kim), 77 = lúc hết độc (Mộc),
// 68/69 = đang chậm / tốc chạy gốc (dùng chung với vũ khí Thủy), 79 = lúc hết thiêu đốt (Hỏa).
// Các hiệu ứng không cộng dồn để tránh tạo quá nhiều timer (nguyên nhân dễ gây giật/treo).
function zzVL_SetHit takes integer vl_ps,unit vl_hero,unit vl_t,real vl_d,boolean vl_fire returns nothing
    local integer vl_lv=zzVL_set[vl_ps]
    local integer vl_a=zzVL_he[vl_ps]
    local integer vl_id=GetHandleId(vl_t)
    local real vl_now=TimerGetElapsed(zzVL_clock)
    local timer vl_tm
    if vl_lv<1 or vl_d<=0. or GetWidgetLife(vl_t)<=.405 or IsUnitType(vl_t,UNIT_TYPE_STRUCTURE) then
        return
    endif
    if vl_a==1 then
        // Kim - Choáng: 2%/cấp, 0.5 giây, mỗi mục tiêu tối đa 1 lần / 3 giây
        if GetRandomInt(1,100)<=zzCF_KIM_CHOANG_PCT_MOI_CAP()*vl_lv and vl_now>=zzUS_Real(vl_id,zzUS_KIM_STUN_CD()) and not IsUnitPaused(vl_t) and not zzVL_Steady(vl_t) then
            call zzUS_SetReal(vl_id,zzUS_KIM_STUN_CD(),vl_now+zzCF_KIM_CHOANG_HOI())
            call PauseUnit(vl_t,true)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_t,"overhead"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,zzCF_KIM_CHOANG_GIAY(),false,function zzVL_TpUnpause)
        endif
    elseif vl_a==2 then
        // Mộc - Độc: 5 lần, mỗi giây 0.6%/cấp sát thương đòn đánh (tổng 3%/cấp), không cộng dồn
        if vl_now>=zzUS_Real(vl_id,zzUS_MOC_POISON_CD()) then
            call zzUS_SetReal(vl_id,zzUS_MOC_POISON_CD(),vl_now+zzCF_MOC_DOC_GIAY())
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
            call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*zzCF_MOC_DOC_MOI_CAP()*vl_lv)
            call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        endif
    elseif vl_a==4 then
        // Thủy - Băng sát: chậm 5%/cấp trong 2 giây, không cộng dồn với chậm khác
        if zzUS_Int(vl_id,zzUS_SLOWED())==0 and not zzVL_Steady(vl_t) then
            call zzUS_SetInt(vl_id,zzUS_SLOWED(),1)
            call zzUS_SetReal(vl_id,zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t))
            call SetUnitMoveSpeed(vl_t,GetUnitMoveSpeed(vl_t)*(1.-zzCF_THUY_CHAM_MOI_CAP()*vl_lv))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",vl_t,"chest"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,zzCF_THUY_CHAM_GIAY(),false,function zzVL_SlowEnd)
        endif
    elseif vl_a==5 and vl_fire then
        // Hỏa - Thiêu đốt: đòn gấp đôi làm mục tiêu giảm 50% hồi máu/hút máu trong 3 giây
        call zzUS_SetReal(vl_id,zzUS_BURN_END(),vl_now+zzCF_HOA_THIEU_DOT_GIAY())
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl",vl_t,"chest"))
    endif
    set vl_tm=null
endfunction

// ==========================================
// Hàm: zzVL_OnDamageBody
// Chức năng dự kiến: Tính toán sát thương và các hiệu ứng đi kèm.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnDamageBody takes nothing returns nothing
    local unit vl_src=GetEventDamageSource()
    local unit vl_tgt=BlzGetEventDamageTarget()
    local real vl_d=GetEventDamage()
    local real vl_m=1.
    local integer vl_ps
    local integer vl_pt
    local integer vl_a
    local integer vl_lv
    local boolean vl_crit=false
    local boolean vl_fire=false
    local unit vl_hero
    local integer vl_srcHe = 0
    local integer vl_res = 0
    local integer vl_evasion = 0
    local integer vl_hit = 0
    local integer vl_chance = 0
    local boolean vl_repl=false
    if vl_src==null or vl_tgt==null or vl_d<=0. or not IsUnitEnemy(vl_tgt,GetOwningPlayer(vl_src)) then
        set vl_src=null
        set vl_tgt=null
        return
    endif
    // Khinh công: mọi nguồn sát thương đều bị chặn trong cửa sổ lướt.
    if IsUnitType(vl_tgt,UNIT_TYPE_HERO) and TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_DASH_IMMUNE_END()) then
        call BlzSetEventDamage(0.)
        set vl_src=null
        set vl_tgt=null
        return
    endif
    set vl_ps=GetPlayerId(GetOwningPlayer(vl_src))
    set vl_pt=GetPlayerId(GetOwningPlayer(vl_tgt))
    if vl_ps<10 and Jx[vl_ps+1]!=null then
        set vl_a=zzVL_he[vl_ps]
        set vl_lv=zzVL_set[vl_ps]
        // Bộ Kim: +5% sát thương/cấp. Bộ Hỏa: 4%/cấp cơ hội gấp đôi (đòn này sẽ gây Thiêu đốt)
        if vl_lv>0 and vl_a==1 then
            set vl_m=vl_m+zzCF_KIM_SAT_THUONG_MOI_CAP()*vl_lv
        elseif vl_lv>0 and vl_a==5 and GetRandomInt(1,100)<=zzCF_HOA_GAP_DOI_PCT_MOI_CAP()*vl_lv then
            set vl_m=vl_m+1.
            set vl_crit=true
            set vl_fire=true
        endif
        set vl_m=vl_m+zzCF_QUAN_HAM_SAT_THUONG()*zzVL_rank[vl_ps]
        if vl_src==Jx[vl_ps+1] and GetUnitAbilityLevel(vl_src,'A0T2')>0 then
            set vl_m=vl_m+.06*GetUnitAbilityLevel(vl_src,'A0T2')
            if GetRandomInt(1,100)<=3*GetUnitAbilityLevel(vl_src,'A0T2') then
                set vl_m=vl_m+1.
                set vl_crit=true
            endif
        endif
        if vl_src==Jx[vl_ps+1] then
            set vl_m=vl_m+.04*GetUnitAbilityLevel(vl_src,'A0TA')
        endif
        if zzVL_af[vl_ps*16+3]>0 and GetRandomInt(1,100)<=zzVL_af[vl_ps*16+3] then
            set vl_m=vl_m+1.
            set vl_crit=true
        endif
        if vl_a>0 and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL and IsUnitType(vl_tgt,UNIT_TYPE_HERO) and zzVL_HeU(vl_tgt)==ModuloInteger(vl_a,5)+1 then
            set vl_m=vl_m+.2
        endif
    endif
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_he[vl_pt]==3 and zzVL_set[vl_pt]>0 then
        set vl_m=vl_m*(1.-.04*zzVL_set[vl_pt])
    endif
    set vl_d=vl_d*vl_m

    // Cộng thêm STVL Nội Công / Ngoại Công (phẳng) theo hệ của phái (config.py mục 15): phái ngoại chỉ hưởng
    // dòng STVL ngoại công (khóa 18), phái nội chỉ hưởng dòng STVL nội công (khóa 17), cho cả đánh thường lẫn kỹ năng
    if vl_ps<10 and vl_src==Jx[vl_ps+1] then
        if zzVL_Phe(vl_src)==2 then
            set vl_d=vl_d + zzPS_Get(vl_ps,zzPS_STVL_NOI())
        else
            set vl_d=vl_d + zzPS_Get(vl_ps,zzPS_STVL_NGOAI())
        endif
        if BlzGetEventDamageType()!=DAMAGE_TYPE_NORMAL then
            set vl_d=vl_d * (1.0 + zzPS_Get(vl_ps,zzPS_CAP_KY_NANG()) * zzCF_CAP_KY_NANG_PCT() / 100.0)
        endif
    endif

    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_af[vl_ps*16+5]>0 then
        set vl_d=vl_d*(1.+zzVL_af[vl_ps*16+5]/100.)
    endif

    // Elemental Resistances
    if vl_pt<10 then
        if vl_ps<10 then
            set vl_srcHe = zzVL_he[vl_ps]
        else
            set vl_srcHe = zzVL_HeU(vl_src)
        endif

        if vl_srcHe > 0 then
            set vl_res = zzPS_Get(vl_pt,10 + vl_srcHe)
            if vl_res > 0 then
                if vl_res > zzCF_KHANG_TOI_DA() then
                    set vl_res = zzCF_KHANG_TOI_DA()
                endif
                set vl_d = vl_d * (1.0 - vl_res / 100.0)
            endif
        endif
    endif

    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_af[vl_pt*16+6]>0 then
        if zzVL_af[vl_pt*16+6]>=50 then
            set vl_d=vl_d*.5
        else
            set vl_d=vl_d*(1.-zzVL_af[vl_pt*16+6]/100.)
        endif
    endif
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and not zzVL_inTp and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
        set zzKS_src=vl_src
        set zzKS_tgt=vl_tgt
        set zzKS_repl=false
        call ExecuteFunc("zzKS_OnHit")
        // an autocast Q W E skill struck: the skill is the attack, the normal hit deals nothing
        if zzKS_repl then
            set zzKS_repl=false
            set vl_repl=true
        endif
    endif
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_wel[vl_ps]>0 and (not zzVL_inTp or zzVL_skHit) and not vl_repl then
        set vl_d=vl_d*zzCF_NGU_HANH_VU_KHI_NHAN()
        if BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
            call zzVL_WeaponHit(vl_ps,vl_src,vl_tgt,vl_d,true)
        else
            call zzVL_WeaponHit(vl_ps,vl_src,vl_tgt,vl_d,false)
        endif
    endif
    if BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
        if vl_pt<10 and vl_tgt==Jx[vl_pt+1] then
            // né theo hệ của đòn: phái nội công → né tránh nội công, còn lại (phái ngoại, quái) → né tránh ngoại công
            set vl_evasion = zzVL_PheDodge(vl_tgt,vl_pt,zzVL_Phe(vl_src))
        else
            set vl_evasion = zzCF_NE_QUAI()
        endif

        if vl_ps<10 and vl_src==Jx[vl_ps+1] then
            set vl_hit = zzPS_Get(vl_ps,zzPS_DANH_TRUNG())
        else
            set vl_hit = zzCF_DANH_TRUNG_QUAI()
        endif

        if vl_evasion > 0 then
            set vl_chance = vl_evasion - vl_hit
            if vl_chance < 0 then
                set vl_chance = 0
            endif
            if vl_chance > zzCF_NE_TOI_DA() then
                set vl_chance = zzCF_NE_TOI_DA()
            endif

            if GetRandomInt(1,1000) <= vl_chance then
                set vl_d=0.
                call zzVL_Text(vl_tgt,"|cff80ff80Né|r")
            endif
        endif
    endif
    set vl_d=zzVL_TpDef(vl_src,vl_tgt,vl_pt,vl_d)
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_VULN_END()) then
        set vl_d=vl_d*zzCF_BI_THUONG_NHAN()
    endif
    // suy yeu (kskill.j zzKS_Weak): the source deals key 84 % less (at most 20)
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_src),zzUS_WEAK_END()) then
        set vl_d=vl_d*(1.-IMinBJ(zzCF_SUY_YEU_TOI_DA(),zzUS_Int(GetHandleId(vl_src),zzUS_WEAK_PCT()))/100.)
    endif
    // bong (KVCT effect_bong, kskill.j status 5): 50% more damage
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_BONG_END()) then
        set vl_d=vl_d*zzCF_BONG_NHAN()
    endif
    // Tướng có thêm thời gian phản ứng trong giao tranh; sát thương lên quái không đổi.
    // Kỹ năng chịu thêm hệ số riêng vì burst nhiều hit là nguyên nhân chính khiến combat kết thúc tức thì.
    if IsUnitType(vl_tgt,UNIT_TYPE_HERO) then
        set vl_d=vl_d*zzCF_HERO_DMG_NHAN()
        if BlzGetEventDamageType()!=DAMAGE_TYPE_NORMAL then
            set vl_d=vl_d*zzCF_HERO_SKILL_DMG_NHAN()
        endif
    endif
    // KVCT "khi bi danh" passives (kskill.j zzKS_OnHurt, key 165)
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and vl_d>0. and not zzVL_inTp then
        set zzKS_hurt[vl_pt]=TimerGetElapsed(zzVL_clock)
        set zzKS_tgt=vl_tgt
        call ExecuteFunc("zzKS_OnHurt")
    endif
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and TimerGetElapsed(zzVL_clock)<zzKS_dimm[vl_pt] then
        set vl_d=0.
        // KVCT Hang Long Bat Vu: ends after a number of hits (kskill.j key 184)
        if zzKS_dimmN[vl_pt]>0 then
            set zzKS_dimmN[vl_pt]=zzKS_dimmN[vl_pt]-1
            if zzKS_dimmN[vl_pt]==0 then
                set zzKS_dimm[vl_pt]=0.
            endif
        endif
    endif
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzKS_refl[vl_pt]>0 and not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=null and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 then
        call zzVL_TpHit(vl_tgt,vl_src,vl_d*zzKS_refl[vl_pt]/100.)
    endif
    // Bộ Thổ - Phản chấn: trả lại 2%/cấp sát thương đánh thường cho kẻ tấn công (tối đa 1 lần / 0.3 giây)
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_he[vl_pt]==3 and zzVL_set[vl_pt]>0 and vl_d>0. and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL and not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and TimerGetElapsed(zzVL_clock)-zzUS_Real(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST())>=zzCF_THO_PHAN_CHAN_HOI() then
        call zzUS_SetReal(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST(),TimerGetElapsed(zzVL_clock))
        call zzVL_TpHit(vl_tgt,vl_src,vl_d*zzCF_THO_PHAN_CHAN_MOI_CAP()*zzVL_set[vl_pt])
    endif
    if vl_repl then
        set vl_d=0.
    endif
    call BlzSetEventDamage(vl_d)
    if vl_crit then
        call zzVL_Text(vl_tgt,"|cffff4000"+I2S(R2I(vl_d))+"!|r")
    endif
    // Hiệu ứng trạng thái bộ ngũ hành: chỉ đòn đánh thường của chính tướng, không tính sát thương phụ (độc, phản...)
    // đòn đánh thường HOẶC đòn của kỹ năng (zzVL_skHit); đòn đánh thường đã bị kỹ năng thay thế thì không kích hoạt
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_set[vl_ps]>0 and not vl_repl and ((not zzVL_inTp and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL) or zzVL_skHit) then
        call zzVL_SetHit(vl_ps,vl_src,vl_tgt,vl_d,vl_fire)
    endif
    if vl_ps<10 and Jx[vl_ps+1]!=null and GetWidgetLife(Jx[vl_ps+1])>.405 then
        if zzVL_af[vl_ps*16+1]>0 then
            call SetWidgetLife(Jx[vl_ps+1],GetWidgetLife(Jx[vl_ps+1])+vl_d*zzVL_af[vl_ps*16+1]/100.*zzVL_HealMul(Jx[vl_ps+1]))
        endif
        if zzVL_af[vl_ps*16+2]>0 then
            call SetUnitState(Jx[vl_ps+1],UNIT_STATE_MANA,GetUnitState(Jx[vl_ps+1],UNIT_STATE_MANA)+vl_d*zzVL_af[vl_ps*16+2]/100.)
        endif
    endif
    if vl_ps<10 and zzVL_he[vl_ps]==2 and zzVL_set[vl_ps]>0 then
        set vl_hero=Jx[vl_ps+1]
        if GetWidgetLife(vl_hero)>.405 then
            call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+vl_d*.03*zzVL_set[vl_ps]*zzVL_HealMul(vl_hero))
        endif
    endif
    set vl_src=null
    set vl_tgt=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_OnDamage
// Chức năng dự kiến: Tính toán sát thương và các hiệu ứng đi kèm.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnDamage takes nothing returns nothing
    if zzVL_dmgDepth>=4 then
        return
    endif
    set zzVL_dmgDepth=zzVL_dmgDepth+1
    set zzVL_dmgN=zzVL_dmgN+1
    call zzVL_OnDamageBody()
    set zzVL_dmgDepth=zzVL_dmgDepth-1
endfunction
// ---- phi phong: one cloak per rank (it cannot be dropped, sold or passed on), with its title
// shown above the hero (a text tag that follows the hero, hidden when the hero is dead or unseen)

// ==========================================
// Hàm: zzVL_TagTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_TagTick takes nothing returns nothing
    local integer vl_playerId=0
    local unit vl_hero
    loop
        exitwhen vl_playerId>9
        if zzVL_tag[vl_playerId]!=null then
            set vl_hero=Jx[vl_playerId+1]
            call SetTextTagPos(zzVL_tag[vl_playerId],GetUnitX(vl_hero)-70.,GetUnitY(vl_hero),260.)
            call SetTextTagVisibility(zzVL_tag[vl_playerId],GetWidgetLife(vl_hero)>.405 and IsUnitVisible(vl_hero,GetLocalPlayer()))
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_GiveCloak
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_GiveCloak takes integer vl_playerId returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_r=zzVL_cl[vl_playerId]
    if vl_hero==null or vl_r<1 then
        set vl_hero=null
        return
    endif
    if zzVL_tag[vl_playerId]==null then
        set zzVL_tag[vl_playerId]=CreateTextTag()
        call SetTextTagPermanent(zzVL_tag[vl_playerId],true)
    endif
    // danh hiệu phi phong trên đầu tướng (không báo lên màn hình)
    call SetTextTagText(zzVL_tag[vl_playerId],zzVL_PPTitle(vl_r),.026)
    set vl_hero=null
endfunction
// ---- cong trang / quan ham

// ==========================================
// Hàm: zzVL_AddCT
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_AddCT takes integer vl_playerId,integer vl_n returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_r=zzVL_rank[vl_playerId]
    local integer vl_c=zzVL_cl[vl_playerId]
    set zzVL_ct[vl_playerId]=IMaxBJ(0,zzVL_ct[vl_playerId]+vl_n)
    // quan ấn (8 bậc): chức quan trước tên tướng
    loop
        exitwhen vl_r>=zzVL_QAMax() or zzVL_ct[vl_playerId]<zzVL_QAReq(vl_r+1)
        set vl_r=vl_r+1
    endloop
    // phi phong (15 bậc): danh hiệu trên đầu + chỉ số
    loop
        exitwhen vl_c>=zzVL_PPMax() or zzVL_ct[vl_playerId]<zzVL_PPReq(vl_c+1)
        set vl_c=vl_c+1
    endloop
    if vl_r>zzVL_rank[vl_playerId] or vl_c>zzVL_cl[vl_playerId] then
        set zzVL_rank[vl_playerId]=vl_r
        set zzVL_cl[vl_playerId]=vl_c
        // không báo lên màn hình khi thăng cấp (chỉ báo ai hạ ai); xem ở bảng Nhân vật (TAB)
        if vl_hero!=null then
            if zzVL_pn[vl_playerId]==null then
                set zzVL_pn[vl_playerId]=GetHeroProperName(vl_hero)
            endif
            if vl_r>0 then
                call BlzSetHeroProperName(vl_hero,zzVL_QAName(vl_r)+" "+zzVL_pn[vl_playerId])
            endif
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",vl_hero,"origin"))
            call zzVL_GiveCloak(vl_playerId)
            call zzVL_AffixSum(vl_playerId)
        endif
    endif
    set vl_hero=null
endfunction
