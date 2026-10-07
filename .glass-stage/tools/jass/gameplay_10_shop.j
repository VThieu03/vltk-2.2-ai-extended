// ==========================================
// gameplay_10_shop.j - Vũ khí Tần Lăng (trùng sinh 11): bán trong tiệm, mua tốn vàng + vũ khí +10 + Tần Lăng Hòa Thị Bích.
// Nhóm SHOP. Phụ thuộc: zzEQ_* (gameplay_09_equip.j), zzVL_FindMat / zzVL_Msg / zzVL_bag / zzVL_equipItem (gameplay_08_ui.j).
// Dữ liệu do gameplay.py ghi vào zzVL_ht (số lấy từ tools/config.py mục 8):
//   - key 95 trên mã ITW0..ITWA = giá vàng một món
//   - key 95 = 1 trên mã đơn vị cửa hàng (config.TANLANG_SHOP_UNIT) = đánh dấu đây là tiệm bán vũ khí Tần Lăng
// Cách móc: trong zzVL_Init thêm  call ExecuteFunc("zzSH_Init")  (xem docs/trangbi/SHOP_VABAN.md).
// ==========================================

// Mã vật phẩm vũ khí Tần Lăng theo loại 0..10 (ITW0..ITW9, ITWA).
function zzSH_Id takes integer vl_k returns integer
    if vl_k<10 then
        return 'ITW0'+vl_k
    endif
    return 'ITWA'
endfunction

// Có đủ điều kiện dùng loại vũ khí này không (đúng loại của phái người chơi): tạo vật phẩm tạm để hỏi zzEQ_CanUse.
function zzSH_CanUseType takes unit vl_hero,integer vl_t returns boolean
    local item vl_it
    local boolean vl_ok=false
    if vl_hero==null then
        return false
    endif
    set vl_it=CreateItem(vl_t,GetUnitX(vl_hero),GetUnitY(vl_hero))
    if vl_it!=null then
        set vl_ok=zzEQ_CanUse(vl_hero,vl_it)
        call RemoveItem(vl_it)
    endif
    set vl_it=null
    return vl_ok
endfunction

// Tìm (và nếu vl_take thì lấy đi) một vũ khí +10 cùng loại vl_wt: ưu tiên trong hành trang, sau đó đang mặc.
// vl_skip = vật phẩm vừa mua (không được tính).
function zzSH_FindPlus10 takes integer vl_playerId,integer vl_wt,boolean vl_take,item vl_skip returns boolean
    local unit vl_tk=Er[vl_playerId+1]
    local item vl_it
    local integer vl_i=0
    loop
        exitwhen vl_i>29
        set vl_it=zzVL_bag[vl_playerId*30+vl_i]
        if vl_it!=null and vl_it!=vl_skip and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
            if vl_take then
                set zzVL_bag[vl_playerId*30+vl_i]=null
                call RemoveItem(vl_it)
            endif
            set vl_it=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        set vl_it=zzVL_equipItem[vl_playerId*10+vl_i]
        if (vl_it==null or vl_it==vl_skip) and vl_tk!=null and vl_i<6 then
            set vl_it=UnitItemInSlot(vl_tk,vl_i)
        endif
        if vl_it!=null and vl_it!=vl_skip and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
            if vl_take then
                if zzVL_equipItem[vl_playerId*10+vl_i]==vl_it then
                    set zzVL_equipItem[vl_playerId*10+vl_i]=null
                endif
                call RemoveItem(vl_it)
            endif
            set vl_it=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
    set vl_tk=null
    return false
endfunction

// Người chơi chọn tiệm: chỉ bày bán loại vũ khí Tần Lăng đúng với phái của người đó.
function zzSH_OnSelect takes nothing returns nothing
    local unit vl_shop=GetTriggerUnit()
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local unit vl_hero
    local integer vl_k=0
    local integer vl_t
    if vl_playerId>9 or LoadInteger(zzVL_ht,GetUnitTypeId(vl_shop),95)!=1 then
        set vl_shop=null
        return
    endif
    set vl_hero=Jx[vl_playerId+1]
    loop
        exitwhen vl_k>10
        set vl_t=zzSH_Id(vl_k)
        call RemoveItemFromStock(vl_shop,vl_t)
        if zzSH_CanUseType(vl_hero,vl_t) then
            call AddItemToStock(vl_shop,vl_t,10,10)
        endif
        set vl_k=vl_k+1
    endloop
    set vl_shop=null
    set vl_hero=null
endfunction

// Mua một món: engine đã trừ vàng (giá item = config.TANLANG_WEAPON_GOLD). Đủ điều kiện thì trừ vũ khí +10 và Hòa Thị Bích,
// đặt bậc 11; thiếu thì hủy món vừa mua, hoàn vàng và báo còn thiếu gì.
function zzSH_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_b=GetBuyingUnit()
    local integer vl_t=GetItemTypeId(vl_item)
    local integer vl_gold=LoadInteger(zzVL_ht,vl_t,95)
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_b))
    local integer vl_wt
    local unit vl_hero
    local string vl_miss=""
    if vl_gold<=0 or vl_playerId>9 then
        set vl_item=null
        set vl_b=null
        return
    endif
    set vl_hero=Jx[vl_playerId+1]
    set vl_wt=zzEQ_WeaponType(vl_t)
    if not zzSH_CanUseType(vl_hero,vl_t) then
        set vl_miss=" phái của bạn không dùng được loại vũ khí này;"
    else
        if not zzSH_FindPlus10(vl_playerId,vl_wt,false,vl_item) then
            set vl_miss=vl_miss+" 1 vũ khí +10 cùng loại (trong hành trang hoặc đang mặc);"
        endif
        if not zzVL_FindMat(vl_playerId,'ITHB',false) then
            set vl_miss=vl_miss+" 1 Tần Lăng Hòa Thị Bích;"
        endif
    endif
    if vl_miss!="" then
        call RemoveItem(vl_item)
        call AdjustPlayerStateBJ(vl_gold,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
        call zzVL_Msg(vl_playerId,"|cffff8000Không thể mua "+GetObjectName(vl_t)+" (đã hoàn "+I2S(vl_gold)+" vàng). Còn thiếu:|r"+vl_miss)
    else
        call zzSH_FindPlus10(vl_playerId,vl_wt,true,vl_item)
        call zzVL_FindMat(vl_playerId,'ITHB',true)
        call zzEQ_SetTier(vl_item,11)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_b,"origin"))
        call zzVL_Msg(vl_playerId,"|cff00ff00Mua thành công|r "+GetItemName(vl_item)+" (đã trừ "+I2S(vl_gold)+" vàng, 1 vũ khí +10 và 1 Tần Lăng Hòa Thị Bích).")
    endif
    set vl_item=null
    set vl_b=null
    set vl_hero=null
endfunction

// Khởi tạo: gọi một lần từ zzVL_Init bằng ExecuteFunc("zzSH_Init") (sau khi zzVL_ht và bảng dữ liệu đã nạp).
function zzSH_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerUnitEvent(vl_t,Player(vl_i),EVENT_PLAYER_UNIT_SELECTED,null)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzSH_OnSelect)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzSH_OnBuy)
    set vl_t=null
endfunction
