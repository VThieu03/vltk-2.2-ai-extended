// ==========================================
// gameplay_10_shop.j - Đổi vũ khí +10 cùng loại và Hòa Thị Bích lấy vũ khí Tần Lăng (+10), giữ vị trí và ngũ hành.
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

// Tìm vũ khí +10 cùng loại trong hành trang hoặc đang mặc.
function zzSH_FindPlus10 takes integer vl_playerId,integer vl_wt returns item
    local unit vl_tk=Er[vl_playerId+1]
    local unit vl_hero=Jx[vl_playerId+1]
    local item vl_it
    local integer vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_it=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
        if vl_it!=null and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
            set vl_it=null
            set vl_tk=null
            set vl_hero=null
            return zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        set vl_it=zzVL_equipItem[vl_playerId*10+vl_i]
        if vl_it!=null and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
            set vl_it=null
            set vl_tk=null
            set vl_hero=null
            return zzVL_equipItem[vl_playerId*10+vl_i]
        endif
        set vl_i=vl_i+1
    endloop
    if vl_tk!=null then
        set vl_i=0
        loop
            exitwhen vl_i>=6
            set vl_it=UnitItemInSlot(vl_tk,vl_i)
            if vl_it!=null and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
                set vl_tk=null
                set vl_hero=null
                return vl_it
            endif
            set vl_i=vl_i+1
        endloop
    endif
    set vl_i=0
    if vl_hero!=null then
        loop
            exitwhen vl_i>=6
            set vl_it=UnitItemInSlot(vl_hero,vl_i)
            if vl_it!=null and zzEQ_IsPlus10Weapon(vl_it) and zzEQ_WeaponType(GetItemTypeId(vl_it))==vl_wt then
                set vl_tk=null
                set vl_hero=null
                return vl_it
            endif
            set vl_i=vl_i+1
        endloop
    endif
    set vl_it=null
    set vl_tk=null
    set vl_hero=null
    return null
endfunction

// Thay đúng handle +10 bằng handle Tần Lăng mới; thiết bị tiếp tục nằm đúng ô hành trang/trang bị.
function zzSH_ReplaceSource takes integer vl_playerId,item vl_source,item vl_new returns boolean
    local integer vl_i=0
    local integer vl_idx
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    local item vl_it
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_idx=vl_playerId*zzCF_BAG_SLOTS()+vl_i
        if zzVL_bag[vl_idx]==vl_source then
            set zzVL_bag[vl_idx]=vl_new
            call SetItemVisible(vl_new,false)
            call RemoveItem(vl_source)
            set vl_hero=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=10
        set vl_idx=vl_playerId*10+vl_i
        if zzVL_equipItem[vl_idx]==vl_source then
            set zzVL_equipItem[vl_idx]=vl_new
            set zzVL_cuong[vl_idx]=10
            call SetItemVisible(vl_new,false)
            call RemoveItem(vl_source)
            set vl_hero=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    if vl_hero!=null and UnitHasItem(vl_hero,vl_source) then
        call UnitRemoveItem(vl_hero,vl_source)
        call SetItemVisible(vl_new,false)
        if not zzVL_BagAdd(vl_playerId,vl_new) then
            call SetItemVisible(vl_new,true)
            call UnitAddItem(vl_hero,vl_source)
            set vl_hero=null
            set vl_tk=null
            return false
        endif
        call RemoveItem(vl_source)
        set vl_hero=null
        set vl_tk=null
        return true
    endif
    if vl_tk!=null and UnitHasItem(vl_tk,vl_source) then
        call UnitRemoveItem(vl_tk,vl_source)
        if UnitAddItem(vl_tk,vl_new) then
            call RemoveItem(vl_source)
            set vl_hero=null
            set vl_tk=null
            return true
        endif
        call UnitAddItem(vl_tk,vl_source)
        set vl_hero=null
        set vl_tk=null
        return false
    endif
    set vl_hero=null
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

// Đổi vũ khí +10 bằng món Tần Lăng cùng loại, giữ nguyên vị trí và dùng hệ số +10 (400%).
function zzSH_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_b=GetBuyingUnit()
    local integer vl_t=GetItemTypeId(vl_item)
    local integer vl_gold=LoadInteger(zzVL_ht,vl_t,95)
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_b))
    local integer vl_wt
    local unit vl_hero
    local item vl_source
    local string vl_miss=""
    if vl_t<'ITW0' or vl_t>'ITWA' or vl_playerId>9 then
        set vl_item=null
        set vl_b=null
        return
    endif
    if vl_gold<=0 then
        set vl_gold=zzCF_TANLANG_WEAPON_GOLD()
    endif
    call zzVL_Log("mua vu khi Tan Lang: "+GetObjectName(vl_t))
    set vl_hero=Jx[vl_playerId+1]
    set vl_wt=zzEQ_WeaponType(vl_t)
    set vl_source=zzSH_FindPlus10(vl_playerId,vl_wt)
    if GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)<vl_gold then
        set vl_miss=vl_miss+" "+I2S(vl_gold)+" vàng;"
    endif
    if not zzSH_CanUseType(vl_hero,vl_t) then
        set vl_miss=" phái của bạn không dùng được loại vũ khí này;"
    else
        if vl_source==null then
            set vl_miss=vl_miss+" 1 vũ khí +10 cùng loại (trong hành trang hoặc đang mặc);"
        endif
        if not zzVL_FindMat(vl_playerId,'ITHB',false) then
            set vl_miss=vl_miss+" 1 Tần Lăng Hòa Thị Bích;"
        endif
    endif
    if vl_miss!="" then
        call RemoveItem(vl_item)
        call zzVL_Msg(vl_playerId,"|cffff8000Không thể đổi "+GetObjectName(vl_t)+". Còn thiếu:|r"+vl_miss)
    else
        if vl_b!=null and UnitHasItem(vl_b,vl_item) then
            call UnitRemoveItem(vl_b,vl_item)
        endif
        if not zzSH_ReplaceSource(vl_playerId,vl_source,vl_item) then
            call RemoveItem(vl_item)
            call zzVL_Msg(vl_playerId,"|cffff8000Giao dịch thất bại, không mất vàng; vũ khí +10 được giữ nguyên.|r")
        else
            call AdjustPlayerStateBJ(-vl_gold,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
            call zzVL_FindMat(vl_playerId,'ITHB',true)
            call zzEQ_SetTier(vl_item,10)
            call zzVL_AffixSum(vl_playerId)
            call ExecuteFunc("zzVL_HeroTick")
            if zzVL_heroOpen[vl_playerId] then
                call zzVL_HeroShow(vl_playerId,true)
            endif
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_b,"origin"))
            call zzVL_Msg(vl_playerId,"|cff00ff00Đổi thành công|r: vũ khí +10 đã thành "+GetItemName(vl_item)+" (+10), giữ nguyên ngũ hành.")
        endif
    endif
    set vl_item=null
    set vl_b=null
    set vl_hero=null
    set vl_source=null
endfunction

// Khởi tạo: gọi một lần từ zzVL_Init bằng ExecuteFunc("zzSH_Init") (sau khi zzVL_ht và bảng dữ liệu đã nạp).
function zzSH_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_i=0
    // hàng bày sẵn trong dữ liệu đơn vị (gameplay.py); không lọc theo người chọn nữa vì kho tiệm dùng chung mọi người chơi
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzSH_OnBuy)
    set vl_t=null
endfunction
