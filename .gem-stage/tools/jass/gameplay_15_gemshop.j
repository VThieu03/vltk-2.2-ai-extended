// ==========================================
// gameplay_15_gemshop.j - Tiệm tạp hóa nâng bậc bảo thạch (đơn vị n00M, config.GEM_SHOP_UNIT).
// Nhóm GEMSHOP. Phụ thuộc: zzGM_Type / zzGM_Tier / zzGM_Code (gameplay_14_gem.j), zzVL_bag / zzVL_Msg (gameplay_08_ui.j / 01_core.j).
// Dữ liệu do gameplay.py ghi vào zzVL_ht (số lấy từ tools/config.py mục 12), khóa cha là mã 'zzGS':
//   ('zzGS',1) = GEM_UP_BASE, ('zzGS',2) = GEM_UP_STEP, ('zzGS',3) = GEM_UP_GOLD, ('zzGS',4) = mã đơn vị tiệm.
// Cách chơi: chọn tiệm -> tiệm bày 6 bảo thạch (mỗi loại một viên) ở bậc "sẽ nhận được". Mua viên nào = nâng bậc t lên t+1 cho loại đó:
//   trừ N(t) = BASE + STEP*(t-1) viên cùng loại cùng bậc t (trong hành trang / Thủ Khố / người) và GEM_UP_GOLD vàng (giá món hàng = GEM_UP_GOLD).
//   Viên vừa mua chính là viên bậc t+1 nhận được. Thiếu viên thì hủy món vừa mua, hoàn vàng, báo rõ.
// Cách móc: trong zzVL_Init thêm  call ExecuteFunc("zzGS_Init")  (xem docs/baothach/GEMSHOP_VABAN.md).
// ==========================================

// Số viên cần để nâng từ bậc t lên t+1 (t = 1..8).
function zzGS_Need takes integer vl_tier returns integer
    return LoadInteger(zzVL_ht,'zzGS',1)+LoadInteger(zzVL_ht,'zzGS',2)*(vl_tier-1)
endfunction

// Số viên bảo thạch loại vl_code người chơi có (hành trang + vật phẩm trên Thủ Khố + trên tướng), không tính vl_skip.
function zzGS_Count takes integer vl_playerId,integer vl_code,item vl_skip returns integer
    local unit vl_tk=Er[vl_playerId+1]
    local unit vl_hero=Jx[vl_playerId+1]
    local item vl_it
    local integer vl_i=0
    local integer vl_n=0
    loop
        exitwhen vl_i>29
        set vl_it=zzVL_bag[vl_playerId*30+vl_i]
        if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
            if GetItemCharges(vl_it)>1 then
                set vl_n=vl_n+GetItemCharges(vl_it)
            else
                set vl_n=vl_n+1
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        if vl_tk!=null then
            set vl_it=UnitItemInSlot(vl_tk,vl_i)
            if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
                if GetItemCharges(vl_it)>1 then
                    set vl_n=vl_n+GetItemCharges(vl_it)
                else
                    set vl_n=vl_n+1
                endif
            endif
        endif
        if vl_hero!=null and vl_hero!=vl_tk then
            set vl_it=UnitItemInSlot(vl_hero,vl_i)
            if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
                if GetItemCharges(vl_it)>1 then
                    set vl_n=vl_n+GetItemCharges(vl_it)
                else
                    set vl_n=vl_n+1
                endif
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
    set vl_tk=null
    set vl_hero=null
    return vl_n
endfunction

// Lấy đi một phần vl_n viên từ vật phẩm vl_it (giảm số lượng hoặc xóa). Trả về số viên còn phải lấy.
function zzGS_TakeFrom takes item vl_it,integer vl_n returns integer
    local integer vl_c=GetItemCharges(vl_it)
    if vl_c<1 then
        set vl_c=1
    endif
    if vl_c>vl_n then
        call SetItemCharges(vl_it,vl_c-vl_n)
        return 0
    endif
    call RemoveItem(vl_it)
    return vl_n-vl_c
endfunction

// Trừ vl_n viên bảo thạch loại vl_code (hành trang trước, rồi Thủ Khố, rồi tướng), không đụng vl_skip. Gọi sau khi zzGS_Count đã đủ.
function zzGS_Take takes integer vl_playerId,integer vl_code,integer vl_n,item vl_skip returns nothing
    local unit vl_tk=Er[vl_playerId+1]
    local unit vl_hero=Jx[vl_playerId+1]
    local item vl_it
    local integer vl_i=0
    local integer vl_c
    local integer vl_old
    loop
        exitwhen vl_i>29 or vl_n<=0
        set vl_it=zzVL_bag[vl_playerId*30+vl_i]
        if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
            set vl_c=GetItemCharges(vl_it)
            if vl_c<1 then
                set vl_c=1
            endif
            set vl_old=vl_n
            set vl_n=zzGS_TakeFrom(vl_it,vl_n)
            if vl_c<=vl_old then
                set zzVL_bag[vl_playerId*30+vl_i]=null
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5 or vl_n<=0
        if vl_tk!=null then
            set vl_it=UnitItemInSlot(vl_tk,vl_i)
            if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
                set vl_n=zzGS_TakeFrom(vl_it,vl_n)
            endif
        endif
        if vl_n>0 and vl_hero!=null and vl_hero!=vl_tk then
            set vl_it=UnitItemInSlot(vl_hero,vl_i)
            if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
                set vl_n=zzGS_TakeFrom(vl_it,vl_n)
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
    set vl_tk=null
    set vl_hero=null
endfunction

// Bậc cao nhất t (1..8) mà người chơi đủ viên để nâng; không có thì bậc cao nhất đang có viên, không có viên nào thì 1.
function zzGS_BestTier takes integer vl_playerId,integer vl_kind returns integer
    local integer vl_t=8
    local integer vl_have=1
    local integer vl_c
    loop
        exitwhen vl_t<1
        set vl_c=zzGS_Count(vl_playerId,zzGM_Code(vl_kind,vl_t),null)
        if vl_c>=zzGS_Need(vl_t) then
            return vl_t
        endif
        if vl_c>0 and vl_have==1 then
            set vl_have=vl_t
        endif
        set vl_t=vl_t-1
    endloop
    return vl_have
endfunction

// Người chơi chọn tiệm: bày 6 bảo thạch (mỗi loại một viên) ở bậc sẽ nhận được, báo công thức và số viên đang có.
function zzGS_OnSelect takes nothing returns nothing
    local unit vl_shop=GetTriggerUnit()
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_k=1
    local integer vl_t
    local integer vl_best
    local string vl_msg
    if vl_playerId>9 or vl_shop==null or LoadInteger(zzVL_ht,'zzGS',4)!=GetUnitTypeId(vl_shop) then
        set vl_shop=null
        return
    endif
    set vl_msg="|cffffcc00Nâng bảo thạch|r: nâng bậc t lên t+1 tốn "+I2S(zzGS_Need(1))+" viên bậc 1, rồi +"+I2S(LoadInteger(zzVL_ht,'zzGS',2))+" viên mỗi bậc (bậc 8 lên 9 tốn "+I2S(zzGS_Need(8))+" viên) cùng loại cùng bậc + "+I2S(LoadInteger(zzVL_ht,'zzGS',3))+" vàng. Mua viên nào = nâng loại đó."
    loop
        exitwhen vl_k>6
        set vl_best=zzGS_BestTier(vl_playerId,vl_k)
        set vl_t=2
        loop
            exitwhen vl_t>9
            call RemoveItemFromStock(vl_shop,zzGM_Code(vl_k,vl_t))
            set vl_t=vl_t+1
        endloop
        call AddItemToStock(vl_shop,zzGM_Code(vl_k,vl_best+1),10,10)
        set vl_msg=vl_msg+"|n"+GetObjectName(zzGM_Code(vl_k,vl_best+1))+": có "+I2S(zzGS_Count(vl_playerId,zzGM_Code(vl_k,vl_best),null))+"/"+I2S(zzGS_Need(vl_best))+" viên bậc "+I2S(vl_best)
        set vl_k=vl_k+1
    endloop
    call zzVL_Msg(vl_playerId,vl_msg)
    set vl_shop=null
endfunction

// Nâng bậc: vl_item = bảo thạch bậc đích vừa mua (đã bị engine trừ vàng GEM_UP_GOLD). Thành công trả true và giữ viên đó.
function zzGS_Upgrade takes integer vl_playerId,item vl_item,unit vl_b returns boolean
    local integer vl_code=GetItemTypeId(vl_item)
    local integer vl_kind=zzGM_Type(vl_code)
    local integer vl_tier=zzGM_Tier(vl_code)-1
    local integer vl_gold=LoadInteger(zzVL_ht,'zzGS',3)
    local integer vl_need
    local integer vl_have
    if vl_kind<1 or vl_tier<1 then
        return false
    endif
    set vl_need=zzGS_Need(vl_tier)
    set vl_have=zzGS_Count(vl_playerId,zzGM_Code(vl_kind,vl_tier),vl_item)
    if vl_have<vl_need then
        call RemoveItem(vl_item)
        call AdjustPlayerStateBJ(vl_gold,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
        call zzVL_Msg(vl_playerId,"|cffff8000Chưa đủ để nâng lên "+GetObjectName(vl_code)+" (đã hoàn "+I2S(vl_gold)+" vàng). Cần "+I2S(vl_need)+" viên "+GetObjectName(zzGM_Code(vl_kind,vl_tier))+", hiện có "+I2S(vl_have)+".|r")
        return false
    endif
    call zzGS_Take(vl_playerId,zzGM_Code(vl_kind,vl_tier),vl_need,vl_item)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_b,"origin"))
    call zzVL_Msg(vl_playerId,"|cff00ff00Nâng thành công|r "+GetItemName(vl_item)+" (đã trừ "+I2S(vl_need)+" viên bậc "+I2S(vl_tier)+" và "+I2S(vl_gold)+" vàng).")
    return true
endfunction

// Sự kiện mua hàng: chỉ xử lý khi mua ở tiệm nâng bảo thạch.
function zzGS_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_b=GetBuyingUnit()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_b))
    if vl_playerId<=9 and LoadInteger(zzVL_ht,'zzGS',4)==GetUnitTypeId(GetSellingUnit()) then
        call zzGS_Upgrade(vl_playerId,vl_item,vl_b)
    endif
    set vl_item=null
    set vl_b=null
endfunction

// Khởi tạo: gọi một lần từ zzVL_Init bằng ExecuteFunc("zzGS_Init") (sau khi zzVL_ht và bảng dữ liệu đã nạp).
function zzGS_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerUnitEvent(vl_t,Player(vl_i),EVENT_PLAYER_UNIT_SELECTED,null)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzGS_OnSelect)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzGS_OnBuy)
    set vl_t=null
endfunction
