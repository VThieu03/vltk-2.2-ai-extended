// Kỳ Trân Các: ba lựa chọn phẩm chất, 22 dòng thuộc tính, đá dùng chung icon KVCT.
// Mua món KTRx mở danh sách; chỉ trừ vàng khi chọn thuộc tính và đưa đá vào túi thành công.
function zzKTC_Show takes integer vl_pid,integer vl_page returns nothing
    local integer vl_start=(vl_page-1)*9+1
    local integer vl_end=IMinBJ(22,vl_start+8)
    local integer vl_stat=vl_start
    local button vl_b
    set zzKTC_page[vl_pid]=vl_page
    call DialogClear(zzKTC_dialog[vl_pid])
    call DialogSetMessage(zzKTC_dialog[vl_pid],"Chọn dòng thuộc tính - phẩm chất "+I2S(zzKTC_grade[vl_pid])+" (trang "+I2S(vl_page)+"/3)")
    loop
        exitwhen vl_stat>vl_end
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],GetObjectName(zzGM_Code(100+vl_stat,zzKTC_grade[vl_pid])),0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,vl_stat)
        set vl_stat=vl_stat+1
    endloop
    if vl_page>1 then
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"<< Trước",0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-2)
    endif
    if vl_page<3 then
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"Tiếp >>",0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-1)
    endif
    set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"Hủy",0)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-3)
    call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],true)
    set vl_b=null
endfunction

function zzKTC_OnDialog takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    local button vl_b=GetClickedButton()
    local integer vl_choice=LoadInteger(zzVL_ht,GetHandleId(vl_b),170)
    local integer vl_grade=zzKTC_grade[vl_pid]
    local integer vl_price=LoadInteger(zzVL_ht,'zzKT',10+vl_grade)
    local integer vl_type
    local item vl_stone
    local unit vl_hero=Jx[vl_pid+1]
    local string vl_name
    if vl_choice==-1 then
        call zzKTC_Show(vl_pid,IMinBJ(3,zzKTC_page[vl_pid]+1))
    elseif vl_choice==-2 then
        call zzKTC_Show(vl_pid,IMaxBJ(1,zzKTC_page[vl_pid]-1))
    elseif vl_choice>0 and vl_choice<=22 then
        if vl_hero==null or GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)<vl_price then
            call zzVL_Msg(vl_pid,"Không đủ vàng hoặc chưa có tướng để mua đá.")
        else
            set vl_type=zzGM_Code(100+vl_choice,vl_grade)
            set vl_stone=CreateItem(vl_type,GetUnitX(vl_hero),GetUnitY(vl_hero))
            set vl_name=GetItemName(vl_stone)
            if zzVL_BagAdd(vl_pid,vl_stone) then
                call SetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)-vl_price)
                call zzVL_Msg(vl_pid,"Đã mua "+vl_name+" với giá "+I2S(vl_price)+" vàng.")
                if zzVL_bagOpen[vl_pid] then
                    call zzVL_Refresh(vl_pid)
                endif
            else
                call RemoveItem(vl_stone)
                call zzVL_Msg(vl_pid,"Hành trang đã đầy; không trừ vàng.")
            endif
        endif
        call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],false)
    else
        call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],false)
    endif
    set vl_hero=null
    set vl_stone=null
    set vl_name=null
    set vl_b=null
endfunction

function zzKTC_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_shop=GetSellingUnit()
    local unit vl_buyer=GetBuyingUnit()
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_buyer))
    local integer vl_type=GetItemTypeId(vl_item)
    local integer vl_grade=0
    local integer vl_price
    if vl_type=='KTR1' then
        set vl_grade=1
    elseif vl_type=='KTR2' then
        set vl_grade=2
    elseif vl_type=='KTR3' then
        set vl_grade=3
    endif
    if vl_pid<10 and vl_grade>0 and GetUnitTypeId(vl_shop)==LoadInteger(zzVL_ht,'zzKT',5) then
        set vl_price=LoadInteger(zzVL_ht,'zzKT',10+vl_grade)
        call RemoveItem(vl_item)
        call SetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)+vl_price)
        set zzKTC_grade[vl_pid]=vl_grade
        call zzKTC_Show(vl_pid,1)
    endif
    set vl_item=null
    set vl_shop=null
    set vl_buyer=null
endfunction

function zzKTC_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_pid=0
    set zzKTC_dialog[0]=null
    loop
        exitwhen vl_pid>9
        set zzKTC_dialog[vl_pid]=DialogCreate()
        call TriggerRegisterDialogEvent(vl_t,zzKTC_dialog[vl_pid])
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKTC_OnDialog)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzKTC_OnBuy)
    set vl_t=null
endfunction
