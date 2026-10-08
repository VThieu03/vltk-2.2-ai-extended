// ---- Boss Tan Thuy Hoang (KVCT): xuat hien dinh ky o khu quai, ha duoc roi "Tan Lang Hoa Thi Bich" ('ITHB').
// Don vi 'n0TL' do tools/tanlang.py tao trong war3map.w3u. Khong dung bien toan cuc moi: trang thai nam trong
// zzVL_ht, khoa cha 'n0TL' (1 = boss dang song, 2 = phut xuat hien ke tiep, 3 = da noi gian chua).
// Hook can them: trong zzVL_Init them dong  call ExecuteFunc("zzTL_Init")  (xem docs/trangbi/BOSS_VABAN.md).

// ==========================================
// Cau hinh (so mac dinh dat o day, vi khong sua config.py)
// ==========================================
// KVCT: cong Tan Lang mo moi 30 phut (1800 giay), mo keo dai 20 phut, Tan Thuy Hoang hien khi cong con 10 phut
// (tuc phut 40, 70, 100...). Map nay ngan hon nen lay phut dau 30 (tu suy), cach nhau 30 phut (theo KVCT).
function zzTL_FirstMinute takes nothing returns integer
    return 20
endfunction

function zzTL_Interval takes nothing returns integer
    return 5
endfunction

// Chi so (tu suy, dua tren khung boss co san: Minh Chu 2.000.000 mau / 7000 sat thuong / 300 giap phut 18).
function zzTL_Hp takes integer vl_min returns integer
    return 1500000+40000*vl_min
endfunction

function zzTL_Damage takes integer vl_min returns integer
    return 2500+100*vl_min
endfunction

function zzTL_Armor takes integer vl_min returns real
    return 150.+4.*vl_min
endfunction

// ==========================================
// Ham: zzTL_Alive
// Chuc nang: boss con song khong
function zzTL_Alive takes nothing returns boolean
    local unit vl_b=LoadUnitHandle(zzVL_ht,'n0TL',1)
    local boolean vl_r=(vl_b!=null and GetWidgetLife(vl_b)>.405)
    set vl_b=null
    return vl_r
endfunction

// ==========================================
// Ham: zzTL_Blast
// Chuc nang: boss danh phep dien rong quanh minh (ke thu = thu dich cua phe quai, khong mien phep)
function zzTL_Blast takes unit vl_boss,real vl_radius,real vl_mult,string vl_fx returns nothing
    local real vl_x=GetUnitX(vl_boss)
    local real vl_y=GetUnitY(vl_boss)
    local real vl_dmg=I2R(BlzGetUnitBaseDamage(vl_boss,0))*vl_mult
    local group vl_g=CreateGroup()
    local unit vl_u
    call SetUnitAnimation(vl_boss,"spell")
    call DestroyEffect(AddSpecialEffect(vl_fx,vl_x,vl_y))
    call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,vl_radius,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if IsUnitEnemy(vl_u,GetOwningPlayer(vl_boss)) and GetWidgetLife(vl_u)>.405 and not IsUnitType(vl_u,UNIT_TYPE_MAGIC_IMMUNE) then
            call UnitDamageTarget(vl_boss,vl_u,vl_dmg,true,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    set vl_u=null
endfunction

// ==========================================
// Ham: zzTL_Cast
// Chuc nang: timer chieu cua boss, 3 chieu xoay vong: Hoang Uy (AoE gan), Vuong Dao (AoE rong), Van Quan Phuc Thu (AoE xa);
// duoi 50% mau hoa "ban than" (BienThan), tang sat thuong 30%, tung chieu nhanh hon.
function zzTL_Cast takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_b=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),1)
    local integer vl_n
    local integer vl_m
    if vl_b==null or GetWidgetLife(vl_b)<.405 then
        call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
        call DestroyTimer(vl_t)
        set vl_t=null
        set vl_b=null
        return
    endif
    set vl_n=LoadInteger(zzVL_ht,GetHandleId(vl_t),2)+1
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),2,vl_n)
    if LoadInteger(zzVL_ht,'n0TL',3)==0 and GetWidgetLife(vl_b)<GetUnitState(vl_b,UNIT_STATE_MAX_LIFE)*.5 then
        call SaveInteger(zzVL_ht,'n0TL',3,1)
        call BlzSetUnitBaseDamage(vl_b,R2I(I2R(BlzGetUnitBaseDamage(vl_b,0))*1.3),0)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\BienThan_tanthuyhoang.mdx",vl_b,"origin"))
        call zzVL_All("|cffffcc07Tần Thủy Hoàng|r nổi giận, hóa thân Chân Long! Sát thương tăng 30%.")
        call TimerStart(vl_t,3.5,true,function zzTL_Cast)
    endif
    set vl_m=ModuloInteger(vl_n,3)
    if vl_m==0 then
        call zzTL_Blast(vl_b,550.,2.,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
    elseif vl_m==1 then
        call zzTL_Blast(vl_b,800.,1.5,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl")
    else
        call zzTL_Blast(vl_b,1100.,1.,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    endif
    set vl_t=null
    set vl_b=null
endfunction

// ==========================================
// Ham: zzTL_Spawn
// Chuc nang: sinh boss tai mot quai rung ngau nhien (khung giong zzVL_BossSpawn), thong bao cho moi nguoi choi
function zzTL_Spawn takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local unit vl_b
    local timer vl_t
    local integer vl_n=0
    local integer vl_min=R2I(TimerGetElapsed(zzVL_clock)/60.)
    local real vl_x=GetRectCenterX(bj_mapInitialPlayableArea)
    local real vl_y=GetRectCenterY(bj_mapInitialPlayableArea)
    call GroupEnumUnitsOfPlayer(vl_g,Player(12),null)
    loop
        set vl_unit=FirstOfGroup(vl_g)
        exitwhen vl_unit==null
        call GroupRemoveUnit(vl_g,vl_unit)
        if zzVL_IsCreep(vl_unit) then
            set vl_n=vl_n+1
            if GetRandomInt(1,vl_n)==1 then
                set vl_pick=vl_unit
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    if vl_pick!=null then
        set vl_x=GetUnitX(vl_pick)
        set vl_y=GetUnitY(vl_pick)
    endif
    set vl_b=CreateUnit(Player(12),'n0TL',vl_x,vl_y,GetRandomReal(0.,360.))
    if vl_b==null then
        set vl_pick=null
        return
    endif
    call SaveUnitHandle(zzVL_ht,'n0TL',1,vl_b)
    call SaveInteger(zzVL_ht,'n0TL',3,0)
    call BlzSetUnitName(vl_b,"|cffffcc07Tần Thủy Hoàng|r")
    call BlzSetUnitMaxHP(vl_b,zzTL_Hp(vl_min))
    call SetWidgetLife(vl_b,I2R(zzTL_Hp(vl_min)))
    call BlzSetUnitBaseDamage(vl_b,zzTL_Damage(vl_min),0)
    call BlzSetUnitArmor(vl_b,zzTL_Armor(vl_min))
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",vl_x,vl_y))
    call PingMinimapEx(vl_x,vl_y,8.,255,200,0,true)
    set zzVL_logMsg="|cffffcc07TẦN THỦY HOÀNG|r xuất hiện ở khu quái!"
    call ExecuteFunc("zzVL_BannerMsg")
    call zzVL_All("|cffffcc07Tần Thủy Hoàng|r đã xuất hiện! Kẻ hạ được hắn sẽ nhận |cffffcc00Tần Lăng Hòa Thị Bích|r.")
    call zzVL_Log("tan thuy hoang xuat hien")
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),1,vl_b)
    call TimerStart(vl_t,5.,true,function zzTL_Cast)
    set vl_t=null
    set vl_b=null
    set vl_pick=null
endfunction

// ==========================================
// Ham: zzTL_Tick
// Chuc nang: moi giay: den phut hen va boss chua song thi sinh boss, dat phut ke tiep
function zzTL_Tick takes nothing returns nothing
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    if vl_m>=LoadInteger(zzVL_ht,'n0TL',2) then
        call SaveInteger(zzVL_ht,'n0TL',2,vl_m+zzTL_Interval())
        if not zzTL_Alive() then
            call zzTL_Spawn()
        endif
    endif
endfunction

// ==========================================
// Buff đội hạ Tần Thủy Hoàng: +20% chỉ số thuộc tính chính (cao nhất trong Sức mạnh / Thân pháp / Nội công) trong zzTL_BuffSeconds giây.
// Trạng thái lưu trên tướng (zzVL_ht, handle tướng): 41 = mã phiên (chống hết hạn nhầm khi nhận lại buff), 42 = loại chỉ số, 43 = số cộng.
function zzTL_BuffPercent takes nothing returns integer
    return 20
endfunction

function zzTL_BuffSeconds takes nothing returns integer
    return 180
endfunction

function zzTL_BuffRemove takes unit vl_h returns nothing
    local integer vl_amount=LoadInteger(zzVL_ht,GetHandleId(vl_h),43)
    if vl_amount>0 then
        call ModifyHeroStat(LoadInteger(zzVL_ht,GetHandleId(vl_h),42),vl_h,bj_MODIFYMETHOD_SUB,vl_amount)
        call SaveInteger(zzVL_ht,GetHandleId(vl_h),43,0)
    endif
endfunction

function zzTL_BuffEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_h=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0)
    if vl_h!=null and LoadInteger(zzVL_ht,GetHandleId(vl_h),41)==LoadInteger(zzVL_ht,GetHandleId(vl_t),1) then
        call zzTL_BuffRemove(vl_h)
        call zzVL_Text(vl_h,"|cff808080Hết buff Tần Thủy Hoàng|r")
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
    set vl_h=null
endfunction

function zzTL_Buff takes unit vl_h returns nothing
    local integer vl_str
    local integer vl_agi
    local integer vl_int
    local integer vl_stat
    local integer vl_amount
    local integer vl_token
    local timer vl_t
    if vl_h==null or GetWidgetLife(vl_h)<.405 then
        return
    endif
    call zzTL_BuffRemove(vl_h)
    set vl_str=GetHeroStr(vl_h,true)
    set vl_agi=GetHeroAgi(vl_h,true)
    set vl_int=GetHeroInt(vl_h,true)
    set vl_stat=bj_HEROSTAT_STR
    set vl_amount=vl_str
    if vl_agi>vl_amount then
        set vl_stat=bj_HEROSTAT_AGI
        set vl_amount=vl_agi
    endif
    if vl_int>vl_amount then
        set vl_stat=bj_HEROSTAT_INT
        set vl_amount=vl_int
    endif
    set vl_amount=vl_amount*zzTL_BuffPercent()/100
    call ModifyHeroStat(vl_stat,vl_h,bj_MODIFYMETHOD_ADD,vl_amount)
    set vl_token=LoadInteger(zzVL_ht,GetHandleId(vl_h),41)+1
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),41,vl_token)
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),42,vl_stat)
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),43,vl_amount)
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_h)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,vl_token)
    call TimerStart(vl_t,I2R(zzTL_BuffSeconds()),false,function zzTL_BuffEnd)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget.mdl",vl_h,"overhead"))
    call zzVL_Text(vl_h,"|cffffcc00Buff Tần Thủy Hoàng: +"+I2S(zzTL_BuffPercent())+"% chỉ số chính|r")
    set vl_t=null
endfunction

// ==========================================
// Ham: zzTL_OnDeath
// Chuc nang: boss chet: thuong vang cho phe nguoi ha, cong trang, roi 'ITHB' tai cho boss chet
function zzTL_OnDeath takes nothing returns nothing
    local unit vl_d=GetTriggerUnit()
    local unit vl_k=GetKillingUnit()
    local real vl_x
    local real vl_y
    local integer vl_pk=-1
    local integer vl_i=0
    if GetUnitTypeId(vl_d)!='n0TL' then
        set vl_d=null
        set vl_k=null
        return
    endif
    set vl_x=GetUnitX(vl_d)
    set vl_y=GetUnitY(vl_d)
    if vl_k!=null then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
    endif
    call FlushChildHashtable(zzVL_ht,'n0TL')
    call SaveInteger(zzVL_ht,'n0TL',2,R2I(TimerGetElapsed(zzVL_clock)/60.)+zzTL_Interval())
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",vl_x,vl_y))
    call PingMinimapEx(vl_x,vl_y,5.,255,200,0,true)
    if vl_pk>=0 and vl_pk<=9 then
        call zzDR_DropKind(4,vl_x,vl_y,Jx[vl_pk+1])
        call zzVL_All(zzVL_Name(vl_pk)+" đã hạ |cffffcc07Tần Thủy Hoàng|r! Bảo thạch và Huyền Tinh đã rơi.")
        loop
            exitwhen vl_i>9
            if IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
                call AdjustPlayerStateBJ(1500,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
                call zzTL_Buff(Jx[vl_i+1])
            endif
            set vl_i=vl_i+1
        endloop
        call zzVL_AddCT(vl_pk,40)
    else
        call zzVL_All("|cffffcc07Tần Thủy Hoàng|r đã bị hạ! |cffffcc00Tần Lăng Hòa Thị Bích|r rơi xuống đất.")
    endif
    set vl_d=null
    set vl_k=null
endfunction

// ==========================================
// Ham: zzTL_Init
// Chuc nang: dat dong ho su kien va trigger chet cua boss. Goi mot lan tu zzVL_Init: call ExecuteFunc("zzTL_Init")
function zzTL_Init takes nothing returns nothing
    local trigger vl_trg=CreateTrigger()
    call SaveInteger(zzVL_ht,'n0TL',2,zzTL_FirstMinute())
    call TriggerRegisterAnyUnitEventBJ(vl_trg,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(vl_trg,function zzTL_OnDeath)
    call TimerStart(CreateTimer(),1.,true,function zzTL_Tick)
    set vl_trg=null
endfunction
