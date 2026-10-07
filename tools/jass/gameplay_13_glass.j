// ---- Huyền Tinh dạng điểm. Không tạo item thường trên terrain; số dư theo player, pity theo từng item handle.
// Config/runtime values are written by kvequip.py under parent 'zzGL'. Player values use parent 6200+pid:
// child 1 = lifetime points earned by the scheduled drop, 2 = spendable GlassPoint, 3 = last notice time.

function zzGL_Get takes integer vl_pid returns integer
    return LoadInteger(zzVL_ht,6200+vl_pid,2)
endfunction

function zzGL_Give takes integer vl_pid,integer vl_points returns nothing
    if vl_pid<0 or vl_pid>9 or vl_points<=0 then
        return
    endif
    call SaveInteger(zzVL_ht,6200+vl_pid,2,zzGL_Get(vl_pid)+vl_points)
endfunction

function zzGL_Spend takes integer vl_pid,integer vl_points returns boolean
    local integer vl_have=zzGL_Get(vl_pid)
    if vl_points<0 or vl_have<vl_points then
        return false
    endif
    call SaveInteger(zzVL_ht,6200+vl_pid,2,vl_have-vl_points)
    return true
endfunction

function zzGL_Cost takes integer vl_level returns integer
    return LoadInteger(zzVL_ht,'zzGL',20+vl_level)
endfunction

function zzGL_HasItemInBag takes integer vl_pid,item vl_find returns boolean
    local integer vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]==vl_find then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction

// Total visible currency: legacy crystals carried in the custom bag / hero / stash plus quest points.
function zzGL_Count takes integer vl_pid returns integer
    local integer vl_i=0
    local integer vl_n=zzGL_Get(vl_pid)
    local item vl_it
    local unit vl_h=Jx[vl_pid+1]
    local unit vl_tk=Er[vl_pid+1]
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_it=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=6
        set vl_it=UnitItemInSlot(vl_h,vl_i)
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' and not zzGL_HasItemInBag(vl_pid,vl_it) then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_it=UnitItemInSlot(vl_tk,vl_i)
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' and not zzGL_HasItemInBag(vl_pid,vl_it) then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
    set vl_h=null
    set vl_tk=null
    return vl_n
endfunction

function zzGL_Target takes real vl_min returns real
    local real vl20=LoadInteger(zzVL_ht,'zzGL',1)
    local real vl30=LoadInteger(zzVL_ht,'zzGL',2)
    local real vl40=LoadInteger(zzVL_ht,'zzGL',3)
    if vl_min<=20. then
        return vl20*vl_min/20.
    elseif vl_min<=30. then
        return vl20+(vl30-vl20)*(vl_min-20.)/10.
    elseif vl_min<=40. then
        return vl30+(vl40-vl30)*(vl_min-30.)/10.
    endif
    return vl40+(vl40-vl30)*(vl_min-40.)/10.
endfunction

function zzGL_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_pid
    local integer vl_minValue
    local integer vl_n
    local integer vl_cap=LoadInteger(zzVL_ht,'zzGL',5)
    local real vl_min
    local real vl_deficit
    local real vl_want
    local real vl_frac
    local real vl_stamp
    if vl_hero==null or LoadInteger(zzVL_ht,'zzGL',6)<=0 or LoadInteger(zzVL_ht,'zzGL',4)<=0 then
        return
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_pid<0 or vl_pid>9 then
        return
    endif
    set vl_min=TimerGetElapsed(zzVL_clock)/60.
    set vl_deficit=zzGL_Target(vl_min)-LoadInteger(zzVL_ht,6200+vl_pid,1)
    if vl_deficit<=0. then
        return
    endif
    if vl_kind<=0 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',7)
    elseif vl_kind==1 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',8)
    elseif vl_kind==2 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',9)
    elseif vl_kind>=4 then
        set vl_minValue=GetRandomInt(LoadInteger(zzVL_ht,'zzGL',12),LoadInteger(zzVL_ht,'zzGL',13))
    else
        set vl_minValue=GetRandomInt(LoadInteger(zzVL_ht,'zzGL',10),LoadInteger(zzVL_ht,'zzGL',11))
    endif
    set vl_want=vl_deficit/LoadInteger(zzVL_ht,'zzGL',4)
    if vl_want<I2R(vl_minValue) then
        if GetRandomReal(0.,1.)>=vl_want/I2R(vl_minValue) then
            return
        endif
        set vl_n=vl_minValue
    else
        set vl_n=R2I(vl_want)
        set vl_frac=vl_want-I2R(vl_n)
        if GetRandomReal(0.,1.)<vl_frac then
            set vl_n=vl_n+1
        endif
        if vl_n<vl_minValue then
            set vl_n=vl_minValue
        endif
    endif
    if vl_n>vl_cap then
        set vl_n=vl_cap
    endif
    if vl_n<=0 then
        return
    endif
    // Grant directly to the killer; never create a terrain item for Huyền Tinh.
    // Keep lifetime-earned accounting so the existing catch-up schedule stays balanced.
    call SaveInteger(zzVL_ht,6200+vl_pid,1,LoadInteger(zzVL_ht,6200+vl_pid,1)+vl_n)
    call zzGL_Give(vl_pid,vl_n)
    // Rate-limit text feedback to one notice every 2 seconds per player.
    set vl_stamp=TimerGetElapsed(zzVL_clock)
    if vl_stamp-LoadReal(zzVL_ht,6200+vl_pid,3)>=2. then
        call DisplayTimedTextToPlayer(Player(vl_pid),0.,0.,2.,"|cffffcc00Nhận Huyền Tinh +"+I2S(vl_n)+".|r")
        call SaveReal(zzVL_ht,6200+vl_pid,3,vl_stamp)
    endif
endfunction
