// ---- Hanh Trang (custom bag, players only; the computer AI keeps the normal inventory)
// Hero inventory = equipment: 0 hat, 1 armor, 2 weapon, 3 boots, 4 cloak, 5 quick (potions, Thuy tinh...).
// Bag: 30 hidden items per player (zzVL_bag[pid*zzCF_BAG_SLOTS()+i]). Panel (key B, button, -hd): equipment row (click =
// take off), 30 bag slots (click = wear / put in the quick slot, or send to the Thu Kho in send mode), the
// Thu Kho row (click = take back into the bag), send-mode and close buttons, info line.
// Frame codes (zzVL_ht key 7 of the frame handle id, stored +1): 0..29 bag, 30..35 equip, 36..41 Thu Kho,
// 42 send mode, 43 close, 44 open button.

// ==========================================
// Hàm: zzVL_EqSlot
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_item (item)
// Trả về dữ liệu kiểu: integer
function zzVL_EqSlot takes item vl_item returns integer
    local integer vl_v
    if vl_item==null then
        return -1
    endif
    // Share the canonical KVCT/legacy slot mapping used by enhancement and inheritance.
    set vl_v=zzEQ_Slot(GetItemTypeId(vl_item))
    if vl_v>0 then
        return vl_v-1
    endif
    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10
    if vl_v==1 then
        return 0
    elseif vl_v==2 then
        return 1
    elseif vl_v==3 then
        return 5
    elseif vl_v==4 then
        return 4
    elseif vl_v==5 then
        return 2
    elseif vl_v==6 then
        return 3
    elseif vl_v==7 then
        return 6
    elseif vl_v==8 then
        return 7
    elseif vl_v==9 then
        return 8
    elseif vl_v==10 then
        return 9
    endif
    return -1
endfunction

// Give every selected hero the new KVCT 10-slot starter set at +0; the weapon follows the hero's class.
// The original map's selection trigger stores the hero in zzEQ_starterHero then calls this through ExecuteFunc,
// since that trigger appears before generated gameplay modules in the compiled script.
function zzEQ_GiveStarter takes nothing returns nothing
    local integer vl_pid=0
    local integer vl_slot
    local integer vl_type
    local unit vl_hero
    local item vl_it
    loop
        exitwhen vl_pid>9
        set vl_hero=zzEQ_starterHero[vl_pid]
        if vl_hero!=null and not zzEQ_starterGiven[vl_pid] then
            set vl_slot=0
            loop
                exitwhen vl_slot>9
                if vl_slot==0 then
                    set vl_type='ITS1'
                elseif vl_slot==1 then
                    set vl_type='ITS2'
                elseif vl_slot==2 then
                    set vl_type='ITS3'
                elseif vl_slot==3 then
                    set vl_type='ITS4'
                elseif vl_slot==4 then
                    set vl_type='ITS5'
                elseif vl_slot==5 then
                    set vl_type=zzEQ_StartWeapon(vl_hero)
                elseif vl_slot==6 then
                    set vl_type='ITS7'
                elseif vl_slot==7 then
                    set vl_type='ITS8'
                elseif vl_slot==8 then
                    set vl_type='ITS9'
                else
                    set vl_type='ITSA'
                endif
                // ô đã có trang bị (nhặt trước khi được phát) thì giữ nguyên
                set vl_it=null
                if zzVL_equipItem[vl_pid*10+vl_slot]==null then
                    set vl_it=CreateItem(vl_type,GetUnitX(vl_hero),GetUnitY(vl_hero))
                endif
                if vl_it!=null then
                    call zzEQ_SetTier(vl_it,0)
                    call zzVL_TaiPhu(vl_it)
                    set zzVL_equipItem[vl_pid*10+vl_slot]=vl_it
                    call SetItemVisible(vl_it,false)
                elseif zzVL_equipItem[vl_pid*10+vl_slot]==null then
                    call zzVL_Log("starter item creation failed p"+I2S(vl_pid)+" slot"+I2S(vl_slot))
                endif
                set vl_slot=vl_slot+1
            endloop
            set zzEQ_starterGiven[vl_pid]=true
            call zzVL_AffixSum(vl_pid)
            call ExecuteFunc("zzVL_HeroTick")
            call zzVL_Log("starter gear equipped p"+I2S(vl_pid)+" (10 slots, +0)")
            set zzEQ_starterHero[vl_pid]=null
        endif
        set vl_pid=vl_pid+1
    endloop
    set vl_hero=null
    set vl_it=null
endfunction

// ==========================================
// Hàm: zzVL_IsBagUser
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
// Trả về dữ liệu kiểu: boolean
function zzVL_IsBagUser takes integer vl_playerId returns boolean
    return vl_playerId>=0 and vl_playerId<=9 and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER and Jx[vl_playerId+1]!=null
endfunction

// ==========================================
// Hàm: zzVL_BagPut
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_item (item)
// Trả về dữ liệu kiểu: boolean
function zzVL_BagPut takes integer vl_playerId,item vl_item returns boolean
    local integer vl_i=0
    if vl_item==null or GetItemTypeId(vl_item)==0 then
        return false
    endif
    call zzVL_CuongIcon(vl_item,0)
    if zzIT_Get(GetHandleId(vl_item),zzIT_CUONG_O())>1 then
        call zzVL_CuongTip(vl_item,1,0,0)
    endif
    // Một handle vật phẩm chỉ được nằm ở một ô túi/ô trang bị; pickup callbacks có thể chạy liền nhau.
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]==vl_item then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=10
        if zzVL_equipItem[vl_playerId*10+vl_i]==vl_item then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]==null then
            set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=vl_item
            call SetItemVisible(vl_item,false)
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction

// ==========================================
// Hàm: zzVL_BagAdd
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_item (item)
// Trả về dữ liệu kiểu: boolean
function zzVL_BagAdd takes integer vl_playerId,item vl_item returns boolean
    local integer vl_i=0
    local item vl_o
    if vl_item==null or GetItemTypeId(vl_item)==0 then
        return false
    endif
    // Bảo đảm một lần nhặt/tự nhặt chỉ thêm một handle, không cộng chồng cùng vật phẩm lần nữa.
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]==vl_item then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=10
        if zzVL_equipItem[vl_playerId*10+vl_i]==vl_item then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    if GetItemCharges(vl_item)==0 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10<1 then
        call SetItemCharges(vl_item,1)
    endif
    // Chỉ vật liệu/đồ dùng được cộng dồn; trang bị cùng mã vẫn là hai món riêng, không hiện x2.
    if GetItemCharges(vl_item)>0 and not zzEQ_IsGear(GetItemTypeId(vl_item)) then
        loop
            exitwhen vl_i>=zzCF_BAG_SLOTS()
            set vl_o=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
            if vl_o!=null and vl_o!=vl_item and GetItemTypeId(vl_o)==GetItemTypeId(vl_item) and GetItemCharges(vl_o)>0 then
                call SetItemCharges(vl_o,GetItemCharges(vl_o)+GetItemCharges(vl_item))
                call RemoveItem(vl_item)
                set vl_o=null
                return true
            endif
            set vl_i=vl_i+1
        endloop
    endif
    set vl_o=null
    return zzVL_BagPut(vl_playerId,vl_item)
endfunction

// ==========================================
// Hàm: zzVL_ToBag
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_unit (unit)
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_ToBag takes integer vl_playerId,unit vl_unit,item vl_item returns nothing
    call UnitRemoveItem(vl_unit,vl_item)
    if not zzVL_BagAdd(vl_playerId,vl_item) then
        call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy ("+I2S(zzCF_BAG_SLOTS())+" ô), đồ được để dưới chân tướng.|r")
    endif
endfunction

// ==========================================
// Hàm: zzVL_Sort
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_Sort takes integer vl_playerId returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_k=0
    local item vl_item
    if not zzVL_IsBagUser(vl_playerId) then
        set vl_hero=null
        return
    endif
    loop
        exitwhen vl_k>5
        set vl_item=UnitItemInSlot(vl_hero,vl_k)
        if vl_item!=null and GetItemType(vl_item)!=ITEM_TYPE_POWERUP then
            // trang bị và bảo thạch được cất vào hành trang (bảo thạch trước đây nằm lại trong 6 ô của tướng, không khảm được)
            if zzVL_EqSlot(vl_item)>=0 or zzGM_Type(GetItemTypeId(vl_item))>0 then
                call zzIT_Set(GetHandleId(vl_item),zzIT_DA_VUT(),0)
                call zzVL_ToBag(vl_playerId,vl_hero,vl_item)
            endif
        endif
        set vl_k=vl_k+1
    endloop
    set vl_hero=null
    set vl_item=null
endfunction

// ==========================================
// Hàm: zzVL_ItemTip
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_item (item)
// Trả về dữ liệu kiểu: string
function zzVL_ItemTip takes item vl_item returns string
    local string vl_string
    local string vl_ext
    if vl_item==null then
        return "Ô trống"
    endif
    set vl_string=GetItemName(vl_item)
    if GetItemCharges(vl_item)>0 then
        set vl_string=vl_string+" (x"+I2S(GetItemCharges(vl_item))+")"
    endif
    if zzEQ_IsGear(GetItemTypeId(vl_item)) and zzIT_Get(GetHandleId(vl_item),zzIT_DA_MO_TA())==0 then
        call zzEQ_Redesc(vl_item)
    endif
    set vl_ext=BlzGetItemExtendedTooltip(vl_item)
    if vl_ext==null or vl_ext=="" then
        set vl_ext=BlzGetItemDescription(vl_item)
    endif
    if vl_ext!=null and vl_ext!="" then
        set vl_string=vl_string+"|n"+vl_ext
    endif
    return vl_string
endfunction

// Tổng giá trị một chỉ số trên món: chỉ số nền theo cường hóa, dòng ngẫu nhiên và bảo thạch.
function zzVL_CompareStat takes item vl_item,integer vl_code returns integer
    local integer vl_type
    local integer vl_n
    local integer vl_i=0
    local integer vl_base=0
    local integer vl_gem
    local integer vl_gemN
    local integer vl_gemI=0
    local integer vl_gemType
    local integer vl_value
    if vl_item==null then
        return 0
    endif
    set vl_type=GetItemTypeId(vl_item)
    set vl_gem=0
    set vl_gemN=LoadInteger(zzVL_ht,GetHandleId(vl_item),43)
    loop
        exitwhen vl_gemI>=vl_gemN
        set vl_gemType=zzIT_Get(GetHandleId(vl_item),zzIT_LO_KHAM()+vl_gemI)
        if zzGM_Type(vl_gemType)>0 then
            if zzGM_StatCode(zzGM_Type(vl_gemType),zzGM_Tier(vl_gemType))==vl_code then
                set vl_gem=vl_gem+zzGM_Stat(zzGM_Type(vl_gemType),zzGM_Tier(vl_gemType))
            endif
        elseif LoadInteger(zzVL_ht,vl_gemType,44)==vl_code then
            set vl_gem=vl_gem+LoadInteger(zzVL_ht,vl_gemType,45)
        endif
        set vl_gemI=vl_gemI+1
    endloop
    set vl_value=zzEQ_LineValue(vl_item,vl_code,IMaxBJ(0,zzIT_Line(GetHandleId(vl_item),vl_code)-vl_gem))+vl_gem
    if zzEQ_IsKv(vl_type) then
        set vl_n=LoadInteger(zzVL_ht,vl_type,139)
        loop
            exitwhen vl_i>=vl_n
            if LoadInteger(zzVL_ht,vl_type,140+2*vl_i)==vl_code then
                set vl_base=vl_base+LoadInteger(zzVL_ht,vl_type,141+2*vl_i)*zzEQ_Pct(zzEQ_Tier(vl_item))/100
            endif
            set vl_i=vl_i+1
        endloop
    endif
    return vl_value+vl_base
endfunction

// Mô tả so sánh theo ô tương ứng. Dòng chỉ có ở một món được tô xanh trời.
function zzVL_ItemCompare takes item vl_item,item vl_worn returns string
    local integer vl_code=1
    local integer vl_new
    local integer vl_old
    local integer vl_diff
    local string vl_s
    local string vl_suffix
    if vl_worn==null then
        set vl_s="|n|n|cffffcc00So sánh: ô này chưa có trang bị đang mặc|r"
    else
        set vl_s="|n|n|cffffcc00So sánh với: "+GetItemName(vl_worn)+"|r"
    endif
    loop
        exitwhen vl_code>24
        set vl_new=zzVL_CompareStat(vl_item,vl_code)
        set vl_old=zzVL_CompareStat(vl_worn,vl_code)
        if vl_new!=vl_old and zzEQ_StatName(vl_code)!="" then
            set vl_suffix=""
            if (vl_code>=1 and vl_code<=6) or (vl_code>=11 and vl_code<=16) then
                set vl_suffix="%"
            endif
            if vl_old==0 then
                set vl_s=vl_s+"|n   |cff80dfff+"+I2S(vl_new)+vl_suffix+" "+zzEQ_StatName(vl_code)+"|r"
            elseif vl_new==0 then
                set vl_s=vl_s+"|n   |cff80dfff-"+I2S(vl_old)+vl_suffix+" "+zzEQ_StatName(vl_code)+"|r"
            else
                set vl_diff=vl_new-vl_old
                if vl_diff>0 then
                    set vl_s=vl_s+"|n   |cff00ff00↑ +"+I2S(vl_diff)+vl_suffix+" "+zzEQ_StatName(vl_code)+"|r"
                else
                    set vl_s=vl_s+"|n   |cffff4040↓ "+I2S(vl_diff)+vl_suffix+" "+zzEQ_StatName(vl_code)+"|r"
                endif
            endif
        endif
        set vl_code=vl_code+1
    endloop
    return vl_s
endfunction

// Tooltip tự vẽ để hover ô tùy biến luôn hiển thị đủ mô tả, affix, khảm và cường hóa.
// Số dòng chữ ước tính của một chuỗi hiển thị (|n xuống dòng, dòng dài tự gập theo zzCF_TIP_CHARS ký tự, bỏ mã màu |cAARRGGBB và |r)
function zzVL_TextLines takes string vl_s returns integer
    local integer vl_len=StringLength(vl_s)
    local integer vl_i=0
    local integer vl_lines=1
    local integer vl_cur=0
    local string vl_c
    loop
        exitwhen vl_i>=vl_len
        set vl_c=SubString(vl_s,vl_i,vl_i+1)
        if vl_c=="|" and vl_i+1<vl_len then
            set vl_c=SubString(vl_s,vl_i+1,vl_i+2)
            if vl_c=="n" or vl_c=="N" then
                set vl_lines=vl_lines+1+vl_cur/zzCF_TIP_CHARS()
                set vl_cur=0
                set vl_i=vl_i+2
            elseif vl_c=="c" or vl_c=="C" then
                set vl_i=vl_i+10
            else
                set vl_i=vl_i+2
            endif
        else
            set vl_cur=vl_cur+1
            set vl_i=vl_i+1
        endif
    endloop
    return vl_lines+vl_cur/zzCF_TIP_CHARS()
endfunction

function zzVL_ItemHoverOn takes nothing returns nothing
    local framehandle vl_frame=BlzGetTriggerFrame()
    local player vl_player=GetTriggerPlayer()
    local integer vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_frame),8)
    local integer vl_index=LoadInteger(zzVL_ht,GetHandleId(vl_frame),9)
    local integer vl_pid=GetPlayerId(vl_player)
    local item vl_item=null
    local item vl_worn=null
    local integer vl_slot=-1
    local string vl_tip
    local real vl_h
    if vl_kind==1 and vl_index>=0 and vl_index<zzCF_BAG_SLOTS() then
        set vl_item=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_index]
    elseif vl_kind==2 and vl_index>=0 and vl_index<10 then
        set vl_item=zzVL_equipItem[vl_pid*10+vl_index]
    elseif vl_kind==3 and vl_index>=0 and vl_index<10 then
        if Er[vl_pid+1]!=null then
            set vl_item=UnitItemInSlot(Er[vl_pid+1],vl_index)
        endif
    endif
    if vl_item!=null then
        set vl_tip=zzVL_ItemTip(vl_item)
        if vl_kind==1 and zzEQ_IsGear(GetItemTypeId(vl_item)) then
            set vl_slot=zzVL_EqSlot(vl_item)
            if vl_slot>=0 then
                set vl_worn=zzVL_equipItem[vl_pid*10+vl_slot]
                if vl_worn!=vl_item then
                    set vl_tip=vl_tip+zzVL_ItemCompare(vl_item,vl_worn)
                endif
            endif
        endif
        set vl_h=zzVL_TextLines(vl_tip)*zzCF_TIP_LINE_H()+.024
        if vl_h>.52 then
            set vl_h=.52
        endif
        if GetLocalPlayer()==vl_player then
            call BlzFrameSetText(zzVL_fItemHoverTxt,vl_tip)
            call BlzFrameSetSize(zzVL_fItemHover,zzCF_TIP_WIDTH(),vl_h)
            call BlzFrameSetSize(zzVL_fItemHoverTxt,zzCF_TIP_WIDTH()-.024,vl_h-.024)
            call BlzFrameSetVisible(zzVL_fItemHover,true)
        endif
    endif
    set vl_item=null
    set vl_worn=null
    set vl_player=null
    set vl_frame=null
endfunction

function zzVL_ItemHoverOff takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call BlzFrameSetVisible(zzVL_fItemHover,false)
    endif
endfunction

// ==========================================
// Hàm: zzVL_SetSlot
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_code (integer)
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_SetSlot takes integer vl_playerId,integer vl_code,item vl_item returns nothing
    local string vl_tex="UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"
    local string vl_tip=zzVL_ItemTip(vl_item)
    local string vl_c=""
    if vl_item!=null then
        set vl_tex=BlzGetItemIconPath(vl_item)
        if GetItemCharges(vl_item)>1 then
            set vl_c="|cffffffff"+I2S(GetItemCharges(vl_item))+"|r"
        endif
    endif
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetTexture(zzVL_fIco[vl_code],vl_tex,0,true)
        call BlzFrameSetText(zzVL_fTip[vl_code],vl_tip)
        call BlzFrameSetText(zzVL_fCnt[vl_code],vl_c)
    endif
endfunction

// ==========================================
// Hàm: zzVL_Refresh
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_BtnText takes string vl_s,boolean vl_on returns string
    if vl_on then
        return "|cffffffff"+vl_s+"|r"
    endif
    return vl_s
endfunction
function zzVL_Refresh takes integer vl_playerId returns nothing
    local integer vl_i=0
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    local string vl_string
    if not zzVL_IsBagUser(vl_playerId) or zzVL_fMain==null then
        set vl_hero=null
        set vl_tk=null
        return
    endif
    // món đang mặc không được hiện trong hành trang
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]!=null and zzVL_IsEquipped(vl_playerId,zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]) then
            set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        call zzVL_SetSlot(vl_playerId,vl_i,zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i])
        set vl_i=vl_i+1
    endloop
    set vl_string="|cffffcc00Vàng:|r "+I2S(GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD))+"   |cffffcc00Bộ:|r "
    if zzVL_set[vl_playerId]>0 then
        set vl_string=vl_string+zzVL_hn[zzVL_he[vl_playerId]]+" "+I2S(zzVL_set[vl_playerId])+"/5"
    else
        set vl_string=vl_string+"chưa đủ"
    endif
    set vl_string=vl_string+"   |cffffcc00Quan ấn:|r "+zzVL_QAName(zzVL_rank[vl_playerId])
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetText(zzVL_fInfo,vl_string)
        // nút đang bật: chữ trắng (không sáng viền); tắt: màu mặc định
        call BlzFrameSetText(zzVL_fMode,zzVL_BtnText("Chuyển",zzVL_sendTK[vl_playerId]))
        call BlzFrameSetText(zzVL_fSell,zzVL_BtnText("Bán",zzVL_sellMode[vl_playerId]))
        call BlzFrameSetText(zzVL_fSplit,zzVL_BtnText("Tách",zzVL_splitMode[vl_playerId]))
        call BlzFrameSetText(zzVL_fKham,zzVL_BtnText("Khảm",zzVL_khamMode[vl_playerId]))
        call BlzFrameSetText(zzVL_fDrop,zzVL_BtnText("Vứt",zzVL_DropMode(vl_playerId)))
        call BlzFrameSetText(zzVL_fAuto,zzVL_BtnText("Tự bán",zzVL_autoSell[vl_playerId]))
        call BlzFrameSetVisible(zzKT_targetPanel,zzVL_sendTK[vl_playerId])
        set vl_i=0
        loop
            exitwhen vl_i>9
            if vl_i!=vl_playerId and IsPlayerAlly(Player(vl_playerId),Player(vl_i)) and Jx[vl_i+1]!=null and GetWidgetLife(Jx[vl_i+1])>.405 then
                call BlzFrameSetText(zzKT_targetBtn[vl_i],zzVL_BtnText(GetUnitName(Jx[vl_i+1])+" - "+GetPlayerName(Player(vl_i)),zzKT_target[vl_playerId]==vl_i))
                call BlzFrameSetVisible(zzKT_targetBtn[vl_i],true)
            else
                call BlzFrameSetVisible(zzKT_targetBtn[vl_i],false)
            endif
            set vl_i=vl_i+1
        endloop
    endif
    set vl_hero=null
    set vl_tk=null
endfunction

// ==========================================
// Hàm: zzVL_BagShow
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_on (boolean)
// Không trả về giá trị (thực thi hành động).
function zzVL_BagShow takes integer vl_playerId,boolean vl_on returns nothing
    set zzVL_bagOpen[vl_playerId]=vl_on
    if vl_on then
        call zzVL_Refresh(vl_playerId)
    endif
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetVisible(zzVL_fMain,vl_on)
        if not vl_on then
            call BlzFrameSetVisible(zzKT_targetPanel,false)
        endif
        if not vl_on then
            call BlzFrameSetVisible(zzKT_targetPanel,false)
        endif
    endif
endfunction

// ==========================================
// Hàm: zzVL_SortAll
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_SortAll takes nothing returns nothing
    local integer vl_playerId=0
    loop
        exitwhen vl_playerId>9
        if zzVL_sortReq[vl_playerId] then
            set zzVL_sortReq[vl_playerId]=false
            call zzVL_Sort(vl_playerId)
            if zzVL_bagOpen[vl_playerId] then
                call zzVL_Refresh(vl_playerId)
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    call DestroyTimer(GetExpiredTimer())
endfunction

// ==========================================
// Hàm: zzVL_OnBagPickup
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnBagPickup takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if zzVL_IsBagUser(vl_playerId) and GetTriggerUnit()==Jx[vl_playerId+1] then
        set zzVL_sortReq[vl_playerId]=true
        call TimerStart(CreateTimer(),0.,false,function zzVL_SortAll)
    endif
endfunction

// ==========================================
// Hàm: zzVL_Craft
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - c (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_Craft takes unit c returns nothing
    local player p=GetOwningPlayer(c)
    local real X=GetUnitX(c)
    local real Y=GetUnitY(c)
    local item i
    local integer ic=40
    local integer ir=GetRandomInt(1,'d')
    if UnitHasItemOfTypeBJ(c,'I06K') and UnitHasItemOfTypeBJ(c,'I06N') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06K'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06N'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I05A',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06K') and UnitHasItemOfTypeBJ(c,'I06X') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06K'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06X'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I05B',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06K') and UnitHasItemOfTypeBJ(c,'I06Y') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06K'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I05C',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06J') and UnitHasItemOfTypeBJ(c,'I06N') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06J'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06N'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I04Y',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06J') and UnitHasItemOfTypeBJ(c,'I06X') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06J'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06X'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I04Z',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06J') and UnitHasItemOfTypeBJ(c,'I06Y') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06J'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I050',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06L') and UnitHasItemOfTypeBJ(c,'I06N') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06L'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06N'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('rat3',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06L') and UnitHasItemOfTypeBJ(c,'I06X') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06L'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06X'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I04Q',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06L') and UnitHasItemOfTypeBJ(c,'I06Y') and UnitHasItemOfTypeBJ(c,'I06M') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06L'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        set i=CreateItem('I04U',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06Q') and UnitHasItemOfTypeBJ(c,'I00Q') and UnitHasItemOfTypeBJ(c,'I00P') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06Q'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00Q'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00P'))
        set i=CreateItem('mcou',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06Q') and UnitHasItemOfTypeBJ(c,'I06T') and UnitHasItemOfTypeBJ(c,'I06U') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06Q'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06T'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06U'))
        set i=CreateItem('kpin',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06S') and UnitHasItemOfTypeBJ(c,'I06R') and UnitHasItemOfTypeBJ(c,'I06U') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06S'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06R'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06U'))
        set i=CreateItem('I004',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I06P') and UnitHasItemOfTypeBJ(c,'I06V') and UnitHasItemOfTypeBJ(c,'I06W') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06P'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06V'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06W'))
        set i=CreateItem('rugt',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I019') and UnitHasItemOfTypeBJ(c,'I00R') and UnitHasItemOfTypeBJ(c,'I017') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I019'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00R'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I017'))
        set i=CreateItem('rhth',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I00T') and UnitHasItemOfTypeBJ(c,'I06M') and UnitHasItemOfTypeBJ(c,'I00R') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00T'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06M'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00R'))
        set i=CreateItem('tmsc',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I016') and UnitHasItemOfTypeBJ(c,'I06P') and UnitHasItemOfTypeBJ(c,'I00R') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I016'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06P'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00R'))
        set i=CreateItem('rde1',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I018') and UnitHasItemOfTypeBJ(c,'I00S') and UnitHasItemOfTypeBJ(c,'I017') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I018'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I00S'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I017'))
        set i=CreateItem('hcun',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I01A') and UnitHasItemOfTypeBJ(c,'I06U') and UnitHasItemOfTypeBJ(c,'I017') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01A'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06U'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I017'))
        set i=CreateItem('Igdh',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I01B') and UnitHasItemOfTypeBJ(c,'I06S') and UnitHasItemOfTypeBJ(c,'I06K') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01B'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06S'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I06K'))
        set i=CreateItem('srbd',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif UnitHasItemOfTypeBJ(c,'I01E') and UnitHasItemOfTypeBJ(c,'I01F') and UnitHasItemOfTypeBJ(c,'I01D') and UnitHasItemOfTypeBJ(c,'I01G') then
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01D'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01E'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01F'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(c,'I01G'))
        set i=CreateItem('I01H',X,Y)
        call UnitAddItem(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    else
        call DisplayTextToPlayer(p,1,1,"|cffffcc00Không du nguyên liêu")
        call PlaySoundOnUnitBJ(xn,'d',c)
    endif
    set c=null
    set p=null
    set i=null
endfunction

// ==========================================
// Hàm: zzVL_Sell
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_code (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_Sell takes integer vl_playerId,integer vl_code returns nothing
    local item vl_item=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]
    local integer vl_g=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),41)
    local integer vl_c=GetItemCharges(vl_item)
    if zzVL_IsEquipped(vl_playerId,vl_item) then
        // món đang mặc không được nằm trong hành trang: bỏ khỏi hành trang, không bán
        set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
        call zzVL_Msg(vl_playerId,"Món này đang được mặc, không bán được.")
        set vl_item=null
        return
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),1)>0 then
        call zzVL_Msg(vl_playerId,"Phi phong không bán được.")
        set vl_item=null
        return
    endif
    if vl_g<=0 then
        set vl_g=10+25*GetItemLevel(vl_item)
    endif
    if vl_c>1 then
        set vl_g=vl_g*vl_c
    endif
    set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
    call zzVL_Msg(vl_playerId,"Đã bán "+GetItemName(vl_item)+": |cffffcc00+"+I2S(vl_g)+"|r ngân lượng.")
    call RemoveItem(vl_item)
    call AdjustPlayerStateBJ(vl_g,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
    if GetLocalPlayer()==Player(vl_playerId) then
        call StartSound(bj_questItemAcquiredSound)
    endif
    set vl_item=null
endfunction

// ==========================================
// Hàm: zzVL_Split
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_code (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_Split takes integer vl_playerId,integer vl_code returns nothing
    local item vl_item=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]
    local integer vl_c=GetItemCharges(vl_item)
    local item vl_n
    if vl_c<2 then
        call zzVL_Msg(vl_playerId,"Chỉ tách được đồ có từ 2 cái trở lên.")
        set vl_item=null
        return
    endif
    set vl_n=CreateItem(GetItemTypeId(vl_item),GetUnitX(Jx[vl_playerId+1]),GetUnitY(Jx[vl_playerId+1]))
    call SetItemCharges(vl_n,vl_c/2)
    call SetItemCharges(vl_item,vl_c-vl_c/2)
    if not zzVL_BagPut(vl_playerId,vl_n) then
        call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy, phần tách ra để dưới chân tướng.|r")
    endif
    set vl_item=null
    set vl_n=null
endfunction

// ==========================================
// Hàm: zzVL_KhamInit
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_KhamInit takes nothing returns nothing
    call SaveInteger(zzVL_ht,'I06M',44,1)
    call SaveInteger(zzVL_ht,'I06M',45,3)
    call SaveInteger(zzVL_ht,'I06L',44,2)
    call SaveInteger(zzVL_ht,'I06L',45,3)
    call SaveInteger(zzVL_ht,'I06K',44,3)
    call SaveInteger(zzVL_ht,'I06K',45,4)
    call SaveInteger(zzVL_ht,'I06J',44,4)
    call SaveInteger(zzVL_ht,'I06J',45,8)
    call SaveInteger(zzVL_ht,'I06W',44,5)
    call SaveInteger(zzVL_ht,'I06W',45,5)
    call SaveInteger(zzVL_ht,'I06S',44,5)
    call SaveInteger(zzVL_ht,'I06S',45,6)
    call SaveInteger(zzVL_ht,'I06Q',44,6)
    call SaveInteger(zzVL_ht,'I06Q',45,4)
    call SaveInteger(zzVL_ht,'I00S',44,6)
    call SaveInteger(zzVL_ht,'I00S',45,3)
    call SaveInteger(zzVL_ht,'I017',44,7)
    call SaveInteger(zzVL_ht,'I017',45,400)
    call SaveInteger(zzVL_ht,'I00R',44,7)
    call SaveInteger(zzVL_ht,'I00R',45,250)
    call SaveInteger(zzVL_ht,'I00P',44,8)
    call SaveInteger(zzVL_ht,'I00P',45,8)
    call SaveInteger(zzVL_ht,'I06P',44,9)
    call SaveInteger(zzVL_ht,'I06P',45,8)
    call SaveInteger(zzVL_ht,'I06U',44,10)
    call SaveInteger(zzVL_ht,'I06U',45,8)

    // New Gems (IDs: I101 to I10C)
    call SaveInteger(zzVL_ht,'I101',44,11)
    call SaveInteger(zzVL_ht,'I101',45,15)
    call SaveInteger(zzVL_ht,'I102',44,12)
    call SaveInteger(zzVL_ht,'I102',45,15)
    call SaveInteger(zzVL_ht,'I103',44,13)
    call SaveInteger(zzVL_ht,'I103',45,15)
    call SaveInteger(zzVL_ht,'I104',44,14)
    call SaveInteger(zzVL_ht,'I104',45,15)
    call SaveInteger(zzVL_ht,'I105',44,15)
    call SaveInteger(zzVL_ht,'I105',45,15)

    call SaveInteger(zzVL_ht,'I106',44,16)
    call SaveInteger(zzVL_ht,'I106',45,10)
    call SaveInteger(zzVL_ht,'I107',44,17)
    call SaveInteger(zzVL_ht,'I107',45,50)
    call SaveInteger(zzVL_ht,'I108',44,18)
    call SaveInteger(zzVL_ht,'I108',45,50)

    call SaveInteger(zzVL_ht,'I109',44,19)
    call SaveInteger(zzVL_ht,'I109',45,200)
    call SaveInteger(zzVL_ht,'I10A',44,20)
    call SaveInteger(zzVL_ht,'I10A',45,200)

    call SaveInteger(zzVL_ht,'I10B',44,21)
    call SaveInteger(zzVL_ht,'I10B',45,40)
    call SaveInteger(zzVL_ht,'I10C',44,22)
    call SaveInteger(zzVL_ht,'I10C',45,1)
endfunction

// ==========================================
// Hàm: zzVL_StrCut
// Bỏ lần xuất hiện đầu tiên của vl_part khỏi vl_s (dùng gỡ dòng "[Khảm] ..." khỏi mô tả trang bị).
function zzVL_StrCut takes string vl_s,string vl_part returns string
    local integer vl_n=StringLength(vl_part)
    local integer vl_len=StringLength(vl_s)
    local integer vl_i=0
    if vl_n==0 or vl_s==null then
        return vl_s
    endif
    loop
        exitwhen vl_i+vl_n>vl_len
        if SubString(vl_s,vl_i,vl_i+vl_n)==vl_part then
            return SubString(vl_s,0,vl_i)+SubString(vl_s,vl_i+vl_n,vl_len)
        endif
        set vl_i=vl_i+1
    endloop
    return vl_s
endfunction

// ==========================================
// Hàm: zzVL_KhamText
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_k (integer)
//   - vl_v (integer)
// Trả về dữ liệu kiểu: string
function zzVL_KhamText takes integer vl_k,integer vl_v returns string
    if vl_k == 22 then
        return zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+" cấp"
    elseif vl_k == 19 or vl_k == 20 or vl_k == 17 or vl_k == 18 or vl_k == 21 or (vl_k >= 7 and vl_k <= 10) then
        return zzVL_AffixName(vl_k)+" +"+I2S(vl_v)
    endif
    return zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+"%"
endfunction

// ==========================================
// Hàm: zzEQ_KhamPart
// Giá trị chỉ số vl_k mà các viên khảm trên trang bị đang cộng (để tách phần dòng ngẫu nhiên ra khỏi tổng).
function zzEQ_KhamPart takes integer vl_id,integer vl_k returns integer
    local integer vl_i=0
    local integer vl_type
    local integer vl_sum=0
    loop
        exitwhen vl_i>=LoadInteger(zzVL_ht,vl_id,43)
        set vl_type=zzIT_Get(vl_id,zzIT_LO_KHAM()+vl_i)
        if vl_type!=0 then
            if zzGM_Type(vl_type)>0 and LoadInteger(zzVL_ht,vl_type,112)==vl_k then
                set vl_sum=vl_sum+zzGM_Stat(zzGM_Type(vl_type),zzGM_Tier(vl_type))
            elseif zzGM_Type(vl_type)<=0 and LoadInteger(zzVL_ht,vl_type,44)==vl_k then
                set vl_sum=vl_sum+LoadInteger(zzVL_ht,vl_type,45)
            endif
        endif
        set vl_i=vl_i+1
    endloop
    return vl_sum
endfunction

// ==========================================
// Hàm: zzEQ_Describe
// Dựng lại mô tả trang bị KVCT từ dữ liệu: chỉ số gốc ĐÃ nhân theo bậc cường hóa (số thật, không ghi %), các dòng ngẫu nhiên
// (đã tăng theo bậc), dòng hệ, các dòng [Khảm], tài phú, rồi phần cố định của loại vật phẩm (khóa 97: loại vũ khí, ngũ hành, tiến cử).
function zzEQ_Describe takes item vl_it returns nothing
    local integer vl_type=GetItemTypeId(vl_it)
    local integer vl_id=GetHandleId(vl_it)
    local integer vl_t=zzEQ_Tier(vl_it)
    local integer vl_p=zzEQ_Pct(vl_t)
    local integer vl_n=LoadInteger(zzVL_ht,vl_type,139)
    local integer vl_j=0
    local integer vl_v
    local string vl_s
    local string vl_x=""
    local boolean vl_kv=zzEQ_IsKv(vl_type)
    local integer vl_ph=LoadInteger(zzVL_ht,vl_type,0)-(LoadInteger(zzVL_ht,vl_type,0)/10)*10
    if not vl_kv then
        // đồ cũ của map: chụp mô tả gốc (tên - phẩm, Cơ bản) một lần, rồi dựng cùng bố cục
        if LoadStr(zzVL_ht,vl_id,zzIT_MO_TA_GOC())=="" or LoadStr(zzVL_ht,vl_id,zzIT_MO_TA_GOC())==null then
            call SaveStr(zzVL_ht,vl_id,zzIT_MO_TA_GOC(),BlzGetItemDescription(vl_it))
        endif
        set vl_t=IMinBJ(5,IMaxBJ(0,vl_ph))
    endif
    // sao theo bậc (vàng = đã cường hóa, xám = còn lại; Tần Lăng: 10 sao đỏ)
    if not vl_kv then
        set vl_s="|cffffcc00"
        set vl_j=0
        loop
            exitwhen vl_j>=5
            if vl_j==vl_t then
                set vl_s=vl_s+"|r|cff505050"
            endif
            set vl_s=vl_s+"*"
            set vl_j=vl_j+1
        endloop
        set vl_s=vl_s+"|r"
    elseif vl_t>=11 then
        set vl_s="|cffff4040**********|r"
    else
        set vl_s="|cffffcc00"
        loop
            exitwhen vl_j>=10
            if vl_j==vl_t then
                set vl_s=vl_s+"|r|cff505050"
            endif
            set vl_s=vl_s+"*"
            set vl_j=vl_j+1
        endloop
        set vl_s=vl_s+"|r"
    endif
    if vl_kv then
    set vl_s=vl_s+"|n|cff00ff00Tài phú: "+I2S(zzVL_GearScore(vl_it))+"|r|n|n"+LoadStr(zzVL_ht,vl_type,97)
        if vl_t>=11 then
            set vl_s=vl_s+"|n|cff9a9a9aCấp trang bị:|r |cffff4040Tần Lăng|r"
        else
            set vl_s=vl_s+"|n|cff9a9a9aCấp trang bị:|r |cffffcc00+"+I2S(vl_t)+"|r / 10"
        endif
        // chỉ số cơ bản (đã nhân theo bậc)
        set vl_s=vl_s+"|n|n|cffffcc00Chỉ số cơ bản|r"
        set vl_j=0
        loop
            exitwhen vl_j>=vl_n
            set vl_s=vl_s+"|n   |cffffffff"+zzEQ_StatFmt(LoadInteger(zzVL_ht,vl_type,140+2*vl_j),LoadInteger(zzVL_ht,vl_type,141+2*vl_j)*vl_p/100)+"|r"
            set vl_j=vl_j+1
        endloop
    else
        set vl_s=vl_s+"|n|cff00ff00Tài phú: "+I2S(zzVL_GearScore(vl_it))+"|r|n|n"+LoadStr(zzVL_ht,vl_id,zzIT_MO_TA_GOC())
        if zzIT_Get(vl_id,zzIT_CUONG_O())>1 then
            set vl_s=vl_s+"|n|cff9a9a9aCường hóa ô:|r |cffffcc00+"+I2S(zzIT_Get(vl_id,zzIT_CUONG_O())-1)+"|r"
        endif
    endif
    // dòng ngẫu nhiên (tăng theo bậc) + hệ
    set vl_j=1
    loop
        exitwhen vl_j>22
        set vl_v=zzIT_Line(vl_id,vl_j)-zzEQ_KhamPart(vl_id,vl_j)
        if vl_v>0 then
            set vl_x=vl_x+"|n   |cff00ff00"+zzVL_KhamText(vl_j,zzEQ_LineValue(vl_it,vl_j,vl_v))+"|r"
        endif
        set vl_j=vl_j+1
    endloop
    if zzIT_Get(vl_id,zzIT_DO_CO())>0 then
        set vl_x=vl_x+"|n   |cffffcc00Hệ|r "+zzVL_hn[zzIT_Get(vl_id,zzIT_DO_CO())]+": giảm 3% sát thương nhận, +150 sinh lực, +2% sát thương"
    endif
    if vl_x!="" then
        set vl_s=vl_s+"|n|n|cff00ff00Thuộc tính ẩn|r"+vl_x
    endif
    // khảm: các lỗ, lỗ trống in xám
    set vl_s=vl_s+"|n|n|cff80c0ffKhảm ("+I2S(LoadInteger(zzVL_ht,vl_id,43))+"/"+I2S(zzCF_KHAM_SO_LO())+")|r"
    set vl_j=0
    loop
        exitwhen vl_j>=zzCF_KHAM_SO_LO()
        if vl_j<LoadInteger(zzVL_ht,vl_id,43) and LoadStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_j)!=null then
            set vl_s=vl_s+"|n   "+SubString(LoadStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_j),2,StringLength(LoadStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_j)))
        else
            set vl_s=vl_s+"|n   |cff505050( lỗ trống )|r"
        endif
        set vl_j=vl_j+1
    endloop
    // cường hóa: bậc hiện tại, chỉ số bậc kế tiếp in xám (chỉ trang bị KVCT)
    if not vl_kv then
    elseif vl_t<10 then
        set vl_s=vl_s+"|n|n|cffff8000Cường hóa (+"+I2S(vl_t)+"/10)|r|n   |cff707070Bậc +"+I2S(vl_t+1)+": "+zzEQ_StatText(vl_type,zzEQ_Pct(vl_t+1))+"|r"
    elseif vl_t==10 then
        set vl_s=vl_s+"|n|n|cffff8000Cường hóa (+10/10)|r |cffffcc00tối đa|r"
    endif
    set vl_s=vl_s+"|n|n|cffffcc00Bán với giá cửa hàng: "+I2S(LoadInteger(zzVL_ht,vl_type,41))+" vàng|r"
    call BlzSetItemDescription(vl_it,vl_s)
    call BlzSetItemExtendedTooltip(vl_it,vl_s)
    call zzIT_Set(vl_id,zzIT_DA_MO_TA(),1)
endfunction

function zzEQ_DescribeRun takes nothing returns nothing
    local item vl_it=LoadItemHandle(zzVL_ht,0,499)
    if vl_it!=null and zzEQ_IsGear(GetItemTypeId(vl_it)) then
        call zzEQ_Describe(vl_it)
    endif
    set vl_it=null
endfunction

// ==========================================
// Hàm: zzVL_Kham
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_g (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_Kham takes integer vl_playerId,item vl_g returns nothing
    local item vl_m=zzVL_kItem[vl_playerId]
    local integer vl_k
    local integer vl_v
    local integer vl_id
    local integer vl_i=0
    local string vl_string
    set zzVL_kSel[vl_playerId]=0
    set zzVL_kItem[vl_playerId]=null
    if vl_m==null or vl_g==null or vl_m==vl_g or GetItemTypeId(vl_m)==0 then
        set vl_m=null
        return
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_g),0)/10<1 or LoadInteger(zzVL_ht,GetItemTypeId(vl_g),1)>0 then
        call zzVL_Msg(vl_playerId,"Chỉ khảm được vào trang bị.")
        set vl_m=null
        return
    endif
    set vl_id=GetHandleId(vl_g)
    if not zzVL_bagOpen[vl_playerId] or not zzVL_heroOpen[vl_playerId] then
        call zzVL_Msg(vl_playerId,"Khảm cần mở cả |cffffcc00Hành trang (B)|r và |cffffcc00Nhân vật (I)|r.")
        set vl_m=null
        return
    endif
    if LoadInteger(zzVL_ht,vl_id,43)>=zzCF_KHAM_SO_LO() then
        call zzVL_Msg(vl_playerId,"Món này đã khảm đủ "+I2S(zzCF_KHAM_SO_LO())+" lỗ. Bật |cff00ff00Tách|r rồi bấm món này để tháo bảo thạch ("+I2S(zzCF_KHAM_TACH_VANG())+" vàng / viên).")
        set vl_m=null
        return
    endif
    set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_m),44)
    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_m),45)
    if zzGM_Type(GetItemTypeId(vl_m))>0 then
        set vl_k=zzGM_StatCode(zzGM_Type(GetItemTypeId(vl_m)),zzGM_Tier(GetItemTypeId(vl_m)))
        set vl_v=zzGM_Stat(zzGM_Type(GetItemTypeId(vl_m)),zzGM_Tier(GetItemTypeId(vl_m)))
    endif
    call zzIT_AddLine(vl_id,vl_k,vl_v)
    set vl_string="|n|cff80c0ff[Khảm] "+GetItemName(vl_m)+": "+zzVL_KhamText(vl_k,vl_v)+"|r"
    // ghi lại viên ở lỗ này để Tách trả về đúng viên và gỡ đúng dòng mô tả
    call zzIT_Set(vl_id,zzIT_LO_KHAM()+LoadInteger(zzVL_ht,vl_id,43),GetItemTypeId(vl_m))
    call SaveStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+LoadInteger(zzVL_ht,vl_id,43),vl_string)
    call SaveInteger(zzVL_ht,vl_id,43,LoadInteger(zzVL_ht,vl_id,43)+1)
    if zzEQ_IsGear(GetItemTypeId(vl_g)) then
        call zzEQ_Describe(vl_g)
    elseif LoadInteger(zzVL_ht,vl_id,55)>0 then
        call SaveStr(zzVL_ht,vl_id,54,LoadStr(zzVL_ht,vl_id,54)+vl_string)
        call SaveStr(zzVL_ht,vl_id,56,LoadStr(zzVL_ht,vl_id,56)+vl_string)
        call SaveInteger(zzVL_ht,vl_id,55,-1)
    else
        call BlzSetItemDescription(vl_g,BlzGetItemDescription(vl_g)+vl_string)
        call BlzSetItemExtendedTooltip(vl_g,BlzGetItemExtendedTooltip(vl_g)+vl_string)
    endif
    call zzVL_Log("kham p"+I2S(vl_playerId))
    call zzVL_Msg(vl_playerId,"|cff80c0ffKhảm thành công|r "+GetItemName(vl_m)+" vào "+GetItemName(vl_g)+": "+zzVL_KhamText(vl_k,vl_v)+" (lỗ "+I2S(LoadInteger(zzVL_ht,vl_id,43))+"/"+I2S(zzCF_KHAM_SO_LO())+")")
    if GetItemCharges(vl_m)>1 then
        call SetItemCharges(vl_m,GetItemCharges(vl_m)-1)
    else
        loop
            exitwhen vl_i>=zzCF_BAG_SLOTS()
            if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]==vl_m then
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
            endif
            set vl_i=vl_i+1
        endloop
        call RemoveItem(vl_m)
    endif
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",Jx[vl_playerId+1],"origin"))
    call zzVL_AffixSum(vl_playerId)
    set vl_m=null
endfunction

// ==========================================
// Hàm: zzVL_Tach
// Tách mọi bảo thạch khỏi trang bị vl_g: trừ zzCF_KHAM_TACH_VANG() vàng mỗi viên, gỡ dòng chỉ số và dòng "[Khảm]" khỏi mô tả,
// trả các viên về hành trang (đầy thì để dưới chân); trang bị trống lỗ để khảm viên mới. Trả về true nếu đã xử lý.
function zzVL_Tach takes integer vl_playerId,item vl_g returns boolean
    local integer vl_id=GetHandleId(vl_g)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,43)
    local integer vl_cost=zzCF_KHAM_TACH_VANG()*vl_n
    local integer vl_i=0
    local integer vl_type
    local integer vl_k
    local integer vl_v
    local string vl_part
    local item vl_m
    local unit vl_hero=Jx[vl_playerId+1]
    if vl_g==null or vl_n<=0 then
        set vl_hero=null
        return false
    endif
    if GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)<vl_cost then
        call zzVL_Msg(vl_playerId,"Tách "+I2S(vl_n)+" viên cần |cffffcc00"+I2S(vl_cost)+"|r vàng.")
        set vl_hero=null
        return true
    endif
    call SetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)-vl_cost)
    loop
        exitwhen vl_i>=vl_n
        set vl_type=zzIT_Get(vl_id,zzIT_LO_KHAM()+vl_i)
        if vl_type!=0 then
            set vl_k=LoadInteger(zzVL_ht,vl_type,44)
            set vl_v=LoadInteger(zzVL_ht,vl_type,45)
            if zzGM_Type(vl_type)>0 then
                set vl_k=LoadInteger(zzVL_ht,vl_type,112)
                set vl_v=zzGM_Stat(zzGM_Type(vl_type),zzGM_Tier(vl_type))
            endif
            call zzIT_AddLine(vl_id,vl_k,-vl_v)
            set vl_part=LoadStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_i)
            if LoadInteger(zzVL_ht,vl_id,55)!=0 then
                call SaveStr(zzVL_ht,vl_id,54,zzVL_StrCut(LoadStr(zzVL_ht,vl_id,54),vl_part))
                call SaveStr(zzVL_ht,vl_id,56,zzVL_StrCut(LoadStr(zzVL_ht,vl_id,56),vl_part))
            endif
            call BlzSetItemDescription(vl_g,zzVL_StrCut(BlzGetItemDescription(vl_g),vl_part))
            call BlzSetItemExtendedTooltip(vl_g,zzVL_StrCut(BlzGetItemExtendedTooltip(vl_g),vl_part))
            set vl_m=CreateItem(vl_type,GetUnitX(vl_hero),GetUnitY(vl_hero))
            if not zzVL_BagPut(vl_playerId,vl_m) then
                call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy, bảo thạch để dưới chân tướng.|r")
            endif
            call zzIT_Set(vl_id,zzIT_LO_KHAM()+vl_i,0)
            call RemoveSavedString(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_i)
        endif
        set vl_i=vl_i+1
    endloop
    call SaveInteger(zzVL_ht,vl_id,43,0)
    if zzEQ_IsGear(GetItemTypeId(vl_g)) then
        call zzEQ_Describe(vl_g)
    endif
    call zzVL_AffixSum(vl_playerId)
    call ExecuteFunc("zzVL_HeroTick")
    call zzVL_Msg(vl_playerId,"|cff00ff00Đã tách|r "+I2S(vl_n)+" bảo thạch khỏi "+GetItemName(vl_g)+" (-"+I2S(vl_cost)+" vàng). Có thể khảm viên mới.")
    call zzVL_Log("tach p"+I2S(vl_playerId))
    set vl_m=null
    set vl_hero=null
    return true
endfunction

// ==========================================
// Hàm: zzVL_TtUse
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_g (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_TtUse takes integer vl_playerId,item vl_g returns nothing
    local item vl_t=zzVL_tSel[vl_playerId]
    local integer vl_i=0
    local integer vl_n
    local boolean vl_ok
    set zzVL_tSel[vl_playerId]=null
    if vl_t==null or GetItemTypeId(vl_t)!='I00W' then
        set vl_t=null
        return
    endif
    if vl_g==null or (not zzEQ_IsKv(GetItemTypeId(vl_g)) and zzVL_EqSlot(vl_g)<0) then
        call zzVL_Msg(vl_playerId,"Hãy dùng Huyền Tinh lên một món trang bị hợp lệ.")
        set vl_t=null
        return
    endif
    set vl_n=IMaxBJ(1,GetItemCharges(vl_t))
    call zzGL_Give(vl_playerId,vl_n)
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]==vl_t then
            set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
        endif
        set vl_i=vl_i+1
    endloop
    call RemoveItem(vl_t)
    set vl_t=null
    if zzEQ_IsKv(GetItemTypeId(vl_g)) then
        set vl_ok=zzEQ_TryEnhance(vl_playerId,vl_g)
    else
        set vl_ok=zzEQ_TrySlotEnhance(vl_playerId,zzVL_EqSlot(vl_g),vl_g)
    endif
    if vl_ok then
        call zzVL_AffixSum(vl_playerId)
        call ExecuteFunc("zzVL_HeroTick")
    endif
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_FindMat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_t (integer)
//   - vl_take (boolean)
// Trả về dữ liệu kiểu: boolean
function zzVL_FindMat takes integer vl_playerId,integer vl_t,boolean vl_take returns boolean
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    local integer vl_i=0
    local item vl_item
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_item=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
        if vl_item!=null and (GetItemTypeId(vl_item)==vl_t or LoadInteger(zzVL_ht,GetItemTypeId(vl_item),59)==vl_t) then
            if vl_take then
                if GetItemCharges(vl_item)>1 then
                    call SetItemCharges(vl_item,GetItemCharges(vl_item)-1)
                else
                    set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
                    call RemoveItem(vl_item)
                endif
            endif
            set vl_item=null
            set vl_hero=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
        if vl_item==null or (GetItemTypeId(vl_item)!=vl_t and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),59)!=vl_t) then
            set vl_item=UnitItemInSlot(vl_tk,vl_i)
        endif
        if vl_item!=null and (GetItemTypeId(vl_item)==vl_t or LoadInteger(zzVL_ht,GetItemTypeId(vl_item),59)==vl_t) then
            if vl_take then
                if GetItemCharges(vl_item)>1 then
                    call SetItemCharges(vl_item,GetItemCharges(vl_item)-1)
                else
                    call RemoveItem(vl_item)
                endif
            endif
            set vl_item=null
            set vl_hero=null
            set vl_tk=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    set vl_item=null
    set vl_hero=null
    set vl_tk=null
    return false
endfunction

// ==========================================
// Hàm: zzVL_ShopPage
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_string (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_ShopPage takes unit vl_string returns nothing
    local integer vl_t=GetUnitTypeId(vl_string)
    local integer vl_n=LoadInteger(zzVL_ht,vl_t,70)
    local integer vl_p=LoadInteger(zzVL_ht,GetHandleId(vl_string),71)
    local integer vl_i=0
    call zzVL_Log("doi trang cua hang")
    if vl_n<2 then
        return
    endif
    loop
        exitwhen vl_i>=LoadInteger(zzVL_ht,vl_t,100+vl_p)
        call RemoveItemFromStock(vl_string,LoadInteger(zzVL_ht,vl_t,72+vl_p*12+vl_i))
        set vl_i=vl_i+1
    endloop
    set vl_p=ModuloInteger(vl_p+1,vl_n)
    call SaveInteger(zzVL_ht,GetHandleId(vl_string),71,vl_p)
    set vl_i=0
    loop
        exitwhen vl_i>=LoadInteger(zzVL_ht,vl_t,100+vl_p)
        call AddItemToStock(vl_string,LoadInteger(zzVL_ht,vl_t,72+vl_p*12+vl_i),10,10)
        set vl_i=vl_i+1
    endloop
endfunction

// ==========================================
// Hàm: zzVL_OnCraftBuy
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnCraftBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_b=GetBuyingUnit()
    local integer vl_t=GetItemTypeId(vl_item)
    local integer vl_n=LoadInteger(zzVL_ht,vl_t,60)
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_b))
    local integer vl_k=0
    local string vl_miss=""
    call zzVL_Log("mua do che")
    if vl_t=='I0PG' then
        call RemoveItem(vl_item)
        call zzVL_ShopPage(GetSellingUnit())
        set vl_item=null
        set vl_b=null
        return
    endif
    if vl_n<=0 or vl_playerId>9 then
        set vl_item=null
        set vl_b=null
        return
    endif
    loop
        exitwhen vl_k>=vl_n
        if not zzVL_FindMat(vl_playerId,LoadInteger(zzVL_ht,vl_t,61+vl_k),false) then
            set vl_miss=vl_miss+" "+GetObjectName(LoadInteger(zzVL_ht,vl_t,61+vl_k))+";"
        endif
        set vl_k=vl_k+1
    endloop
    if vl_miss!="" then
        call RemoveItem(vl_item)
        call AdjustPlayerStateBJ(5000,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
        call zzVL_Msg(vl_playerId,"|cffff8000Chưa đủ nguyên liệu (đã hoàn 5000 vàng) để nhận "+GetObjectName(vl_t)+". Còn thiếu:|r"+vl_miss)
    else
        set vl_k=0
        loop
            exitwhen vl_k>=vl_n
            call zzVL_FindMat(vl_playerId,LoadInteger(zzVL_ht,vl_t,61+vl_k),true)
            set vl_k=vl_k+1
        endloop
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_b,"origin"))
        call zzVL_Msg(vl_playerId,"|cff00ff00Chế thành công|r "+GetItemName(vl_item)+" (đã trừ nguyên liệu).")
    endif
    set vl_item=null
    set vl_b=null
endfunction

// ==========================================
// Chuyển đồ: bật "Chuyển đồ", bấm chọn tướng ĐỒNG MINH (trên bản đồ), rồi bấm món trong hành trang: món được chuyển sang
// hành trang của người đó. Tướng đồng minh được chọn gần nhất lưu ở hashtable 7100+pid, trường 1.
function zzVL_OnAllySelect takes nothing returns nothing
    local unit vl_u=GetTriggerUnit()
    local integer vl_p=GetPlayerId(GetTriggerPlayer())
    local integer vl_o=GetPlayerId(GetOwningPlayer(vl_u))
    if vl_p<10 and vl_o<10 and vl_o!=vl_p and Jx[vl_o+1]==vl_u and IsPlayerAlly(Player(vl_o),Player(vl_p)) then
        call SaveUnitHandle(zzVL_ht,7100+vl_p,1,vl_u)
        if zzVL_sendTK[vl_p] then
            call zzVL_Msg(vl_p,"Đã chọn đồng đội |cffffcc00"+GetUnitName(vl_u)+"|r. Bấm món trong hành trang để chuyển.")
        endif
    endif
    set vl_u=null
endfunction

function zzVL_Transfer takes integer vl_pid,integer vl_code returns nothing
    local item vl_it=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_code]
    local integer vl_tp=zzKT_target[vl_pid]
    local unit vl_u=null
    if vl_tp<0 or vl_tp>9 then
        call zzVL_Msg(vl_pid,"Hãy bấm Chuyển và chọn một đồng minh trong danh sách trước.")
        set vl_it=null
        return
    endif
    set vl_u=Jx[vl_tp+1]
    if vl_it==null then
        set vl_u=null
        return
    endif
    if vl_u==null or GetWidgetLife(vl_u)<.405 then
        call zzVL_Msg(vl_pid,"Hãy bấm Chuyển và chọn một đồng minh trong danh sách trước.")
        set vl_u=null
        set vl_it=null
        return
    endif
    set vl_tp=GetPlayerId(GetOwningPlayer(vl_u))
    if vl_tp>9 or vl_tp==vl_pid or Jx[vl_tp+1]!=vl_u or not IsPlayerAlly(Player(vl_tp),Player(vl_pid)) or not zzVL_IsBagUser(vl_tp) then
        call zzVL_Msg(vl_pid,"Người này không nhận được đồ (phải là tướng đồng minh của người chơi khác).")
    elseif zzVL_IsEquipped(vl_pid,vl_it) then
        set zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_code]=null
    elseif zzVL_BagAdd(vl_tp,vl_it) then
        set zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_code]=null
        call zzVL_Msg(vl_pid,"Đã chuyển "+GetItemName(vl_it)+" cho |cffffcc00"+GetUnitName(vl_u)+"|r.")
        call zzVL_Msg(vl_tp,"|cffffcc00"+GetPlayerName(Player(vl_pid))+"|r chuyển cho bạn: "+GetItemName(vl_it))
        if zzVL_bagOpen[vl_tp] then
            call zzVL_Refresh(vl_tp)
        endif
    else
        call zzVL_Msg(vl_pid,"Hành trang của người này đã đầy.")
    endif
    set vl_u=null
    set vl_it=null
endfunction

// ==========================================
// Hàm: zzVL_BagClick
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_code (integer)
// Không trả về giá trị (thực thi hành động).
function zzKT_PotionAmount takes integer vl_type returns integer
    return LoadInteger(zzVL_ht,vl_type,602)
endfunction

function zzKT_ConsumeBest takes integer vl_pid returns integer
    local unit vl_hero=Jx[vl_pid+1]
    local item vl_it=null
    local integer vl_best=0
    local integer vl_value
    local integer vl_i=0
    local integer vl_slot=-1
    local boolean vl_fromBag=false
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_it=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]
        if vl_it!=null then
            set vl_value=zzKT_PotionAmount(GetItemTypeId(vl_it))
            if vl_value>vl_best and LoadInteger(zzVL_ht,GetItemTypeId(vl_it),57)<=GetHeroLevel(vl_hero) then
                set vl_best=vl_value
                set vl_slot=vl_i
                set vl_fromBag=true
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=6
        set vl_it=UnitItemInSlot(vl_hero,vl_i)
        if vl_it!=null then
            set vl_value=zzKT_PotionAmount(GetItemTypeId(vl_it))
            if vl_value>vl_best and LoadInteger(zzVL_ht,GetItemTypeId(vl_it),57)<=GetHeroLevel(vl_hero) then
                set vl_best=vl_value
                set vl_slot=vl_i
                set vl_fromBag=false
            endif
        endif
        set vl_i=vl_i+1
    endloop
    if vl_best>0 then
        if vl_fromBag then
            set vl_it=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_slot]
            if GetItemCharges(vl_it)>1 then
                call SetItemCharges(vl_it,GetItemCharges(vl_it)-1)
            else
                set zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_slot]=null
                call RemoveItem(vl_it)
            endif
        else
            set vl_it=UnitItemInSlot(vl_hero,vl_slot)
            if GetItemCharges(vl_it)>1 then
                call SetItemCharges(vl_it,GetItemCharges(vl_it)-1)
            else
                call UnitRemoveItem(vl_hero,vl_it)
                call RemoveItem(vl_it)
            endif
        endif
    endif
    set vl_it=null
    set vl_hero=null
    return vl_best
endfunction

function zzKT_Use takes integer vl_pid returns nothing
    local unit vl_hero=Jx[vl_pid+1]
    local integer vl_amount
    if vl_hero==null or GetWidgetLife(vl_hero)<=.405 then
        return
    endif
    if zzKT_hotTick[vl_pid]>0 then
        call zzVL_Msg(vl_pid,"Bình hồi phục đang có hiệu lực, hãy chờ hồi xong.")
        set vl_hero=null
        return
    endif
    set vl_amount=zzKT_ConsumeBest(vl_pid)
    if vl_amount<=0 then
        call zzVL_Msg(vl_pid,"Không có bình hồi máu phù hợp cấp độ trong hành trang.")
    else
        set zzKT_hotAmount[vl_pid]=vl_amount
        set zzKT_hotTick[vl_pid]=0
        set zzKT_hotApplied[vl_pid]=0
        call zzVL_Msg(vl_pid,"Đã dùng bình hồi phục: hồi "+I2S(vl_amount)+" sinh lực và nội lực trong 4 giây.")
    endif
    set vl_hero=null
endfunction

function zzKT_OnPotionKey takes nothing returns nothing
    call zzKT_Use(GetPlayerId(GetTriggerPlayer()))
endfunction

function zzKT_ControlDown takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    if BlzGetTriggerPlayerKey()==OSKEY_LCONTROL then
        set zzKT_ctrlLeft[vl_pid]=true
    else
        set zzKT_ctrlRight[vl_pid]=true
    endif
    set zzKT_ctrl[vl_pid]=zzKT_ctrlLeft[vl_pid] or zzKT_ctrlRight[vl_pid]
endfunction

function zzKT_ControlUp takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    if BlzGetTriggerPlayerKey()==OSKEY_LCONTROL then
        set zzKT_ctrlLeft[vl_pid]=false
    else
        set zzKT_ctrlRight[vl_pid]=false
    endif
    set zzKT_ctrl[vl_pid]=zzKT_ctrlLeft[vl_pid] or zzKT_ctrlRight[vl_pid]
endfunction

function zzKT_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_buyer=GetBuyingUnit()
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_buyer))
    local integer vl_type=GetItemTypeId(vl_item)
    local integer vl_cost=LoadInteger(zzVL_ht,vl_type,600)
    local integer vl_cap=LoadInteger(zzVL_ht,'zzKT',4)
    local integer vl_extra=0
    local integer vl_charges
    local integer vl_gold
    if vl_pid<10 and zzKT_ctrl[vl_pid] and vl_cost>0 and vl_item!=null then
        set vl_charges=IMaxBJ(1,GetItemCharges(vl_item))
        set vl_gold=GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)
        set vl_extra=IMinBJ(LoadInteger(zzVL_ht,'zzKT',3)-1,IMinBJ(vl_cap-vl_charges,vl_gold/vl_cost))
        if vl_extra>0 then
            call SetItemCharges(vl_item,vl_charges+vl_extra)
            call SetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD,vl_gold-vl_extra*vl_cost)
            call zzVL_Msg(vl_pid,"Đã mua gộp "+I2S(vl_extra+1)+" bình (tối đa 10/ô).")
        endif
    endif
    set vl_item=null
    set vl_buyer=null
endfunction

function zzKT_OnChat takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    local string vl_text=GetEventPlayerChatString()
    local integer vl_space=StringLength("-autohp ")
    local integer vl_value
    if vl_text=="-autohp" then
        set zzKT_auto[vl_pid]=not zzKT_auto[vl_pid]
        if zzKT_auto[vl_pid] then
            call zzVL_Msg(vl_pid,"Tự bơm máu: |cff00ff00BẬT|r khi sinh lực dưới "+I2S(zzKT_threshold[vl_pid])+"%.")
        else
            call zzVL_Msg(vl_pid,"Tự bơm máu: |cffff4040TẮT|r.")
        endif
    elseif StringLength(vl_text)>vl_space then
        set vl_value=S2I(SubString(vl_text,vl_space,StringLength(vl_text)))
        if vl_value>=1 and vl_value<=100 then
            set zzKT_threshold[vl_pid]=vl_value
            set zzKT_auto[vl_pid]=true
            call zzVL_Msg(vl_pid,"Tự bơm máu bật ở mức sinh lực dưới "+I2S(vl_value)+"%.")
        else
            call zzVL_Msg(vl_pid,"Cú pháp: -autohp để bật/tắt, hoặc -autohp 1 đến 100 để đặt ngưỡng.")
        endif
    endif
    set vl_text=null
endfunction

function zzKT_Tick takes nothing returns nothing
    local integer vl_pid=0
    local unit vl_hero
    local integer vl_target
    local integer vl_delta
    local integer vl_amount
    local real vl_life
    local real vl_mana
    loop
        exitwhen vl_pid>9
        set vl_hero=Jx[vl_pid+1]
        if vl_hero!=null and GetWidgetLife(vl_hero)>.405 then
            if zzKT_hotTick[vl_pid]>0 then
                set zzKT_hotTick[vl_pid]=zzKT_hotTick[vl_pid]+1
                set vl_target=zzKT_hotAmount[vl_pid]*zzKT_hotTick[vl_pid]/16
                set vl_delta=vl_target-zzKT_hotApplied[vl_pid]
                if vl_delta>0 then
                    set vl_life=GetWidgetLife(vl_hero)+I2R(vl_delta)
                    if vl_life>GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE) then
                        set vl_life=GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)
                    endif
                    call SetWidgetLife(vl_hero,vl_life)
                    set vl_mana=GetUnitState(vl_hero,UNIT_STATE_MANA)+I2R(vl_delta)
                    if vl_mana>GetUnitState(vl_hero,UNIT_STATE_MAX_MANA) then
                        set vl_mana=GetUnitState(vl_hero,UNIT_STATE_MAX_MANA)
                    endif
                    call SetUnitState(vl_hero,UNIT_STATE_MANA,vl_mana)
                    set zzKT_hotApplied[vl_pid]=vl_target
                endif
                if zzKT_hotTick[vl_pid]>=16 then
                    set zzKT_hotTick[vl_pid]=0
                    set zzKT_hotAmount[vl_pid]=0
                    set zzKT_hotApplied[vl_pid]=0
                endif
            elseif zzKT_auto[vl_pid] and GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)>0. and GetWidgetLife(vl_hero)*100.<=GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*I2R(zzKT_threshold[vl_pid]) then
                set vl_amount=zzKT_ConsumeBest(vl_pid)
                if vl_amount>0 then
                    set zzKT_hotAmount[vl_pid]=vl_amount
                    set zzKT_hotTick[vl_pid]=0
                    set zzKT_hotApplied[vl_pid]=0
                endif
            endif
        endif
        set vl_pid=vl_pid+1
    endloop
    set vl_hero=null
endfunction

function zzKT_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_pid=0
    loop
        exitwhen vl_pid>9
        set zzKT_auto[vl_pid]=true
        set zzKT_threshold[vl_pid]=LoadInteger(zzVL_ht,'zzKT',1)
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_pid),OSKEY_1,0,true)
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKT_OnPotionKey)
    set vl_t=CreateTrigger()
    set vl_pid=0
    loop
        exitwhen vl_pid>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_pid),OSKEY_LCONTROL,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_pid),OSKEY_RCONTROL,0,true)
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKT_ControlDown)
    set vl_t=CreateTrigger()
    set vl_pid=0
    loop
        exitwhen vl_pid>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_pid),OSKEY_LCONTROL,0,false)
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_pid),OSKEY_RCONTROL,0,false)
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKT_ControlUp)
    set vl_t=CreateTrigger()
    set vl_pid=0
    loop
        exitwhen vl_pid>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_pid),"-autohp",false)
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKT_OnChat)
    call TimerStart(CreateTimer(),.25,true,function zzKT_Tick)
    set vl_t=null
endfunction
// Khinh công chủ động: lao theo hướng mặt, để lại tàn ảnh KVCT và miễn sát thương trong lúc lướt.
function zzVL_KinhCongTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,1)
    local real vl_a=LoadReal(zzVL_ht,vl_id,2)
    local real vl_s=LoadReal(zzVL_ht,vl_id,3)
    local real vl_x
    local real vl_y
    if vl_h==null or GetWidgetLife(vl_h)<.405 then
        set vl_n=0
    else
        set vl_x=GetUnitX(vl_h)+vl_s*Cos(vl_a)
        set vl_y=GetUnitY(vl_h)+vl_s*Sin(vl_a)
        if not IsTerrainPathable(vl_x,vl_y,PATHING_TYPE_WALKABILITY) then
            if ModuloInteger(vl_n,3)==0 then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl",vl_h,"origin"))
            endif
            call SetUnitX(vl_h,vl_x)
            call SetUnitY(vl_h,vl_y)
            set vl_n=vl_n-1
        else
            set vl_n=0
        endif
    endif
    call SaveInteger(zzVL_ht,vl_id,1,vl_n)
    if vl_n<=0 then
        if vl_h!=null then
            call ResetUnitAnimation(vl_h)
        endif
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
endfunction

function zzVL_KinhCong takes integer vl_pid returns nothing
    local unit vl_h
    local timer vl_t
    local integer vl_steps
    local real vl_now
    local real vl_a
    if vl_pid<0 or vl_pid>9 then
        return
    endif
    set vl_h=Jx[vl_pid+1]
    if vl_h==null or GetWidgetLife(vl_h)<.405 or IsUnitPaused(vl_h) then
        call zzVL_Msg(vl_pid,"Không thể khinh công lúc này.")
        set vl_h=null
        return
    endif
    set vl_now=TimerGetElapsed(zzVL_clock)
    if vl_now<zzUS_Real(GetHandleId(vl_h),zzUS_DASH_COOLDOWN_END()) then
        set vl_h=null
        return
    endif
    set vl_a=GetUnitFacing(vl_h)*bj_DEGTORAD
    set vl_steps=IMaxBJ(1,R2I(zzCF_KHINH_CONG_TIME()/.03125))
    call zzUS_SetReal(GetHandleId(vl_h),zzUS_DASH_COOLDOWN_END(),vl_now+zzCF_KHINH_CONG_COOLDOWN())
    call zzUS_SetReal(GetHandleId(vl_h),zzUS_DASH_IMMUNE_END(),vl_now+zzCF_KHINH_CONG_IMMUNE())
    call SetUnitFacing(vl_h,vl_a*bj_RADTODEG)
    call SetUnitAnimation(vl_h,"walk")
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_h)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,vl_steps)
    call SaveReal(zzVL_ht,GetHandleId(vl_t),2,vl_a)
    call SaveReal(zzVL_ht,GetHandleId(vl_t),3,zzCF_KHINH_CONG_DISTANCE()/I2R(vl_steps))
    call TimerStart(vl_t,.03125,true,function zzVL_KinhCongTick)
    call zzVL_Msg(vl_pid,"|cff80c0ffKhinh công!|r Miễn sát thương trong lúc lướt.")
    set vl_t=null
    set vl_h=null
endfunction

function zzVL_BagClick takes integer vl_playerId,integer vl_code returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    local item vl_item
    local item vl_old
    local integer vl_w
    call zzVL_Log("bag p"+I2S(vl_playerId)+" o "+I2S(vl_code))
    if vl_code==251 then
        call zzVL_KinhCong(vl_playerId)
        set vl_hero=null
        set vl_tk=null
        return
    endif
    if vl_code==250 then
        set zzVL_heroOpen[vl_playerId]=not zzVL_heroOpen[vl_playerId]
        call ExecuteFunc("zzVL_HeroTick")
        set vl_hero=null
        set vl_tk=null
        return
    endif
    if vl_code==249 then
        set zzVL_autoSell[vl_playerId]=not zzVL_autoSell[vl_playerId]
        if zzVL_autoSell[vl_playerId] then
            call zzVL_Msg(vl_playerId,"Tự bán: |cff00ff00BẬT|r - đồ nhặt mạnh hơn tự mặc, yếu hơn tự bán (đồ đã khảm giữ lại).")
        else
            call zzVL_Msg(vl_playerId,"Tự bán: |cffff4040TẮT|r")
        endif
        call zzVL_Refresh(vl_playerId)
        set vl_hero=null
        set vl_tk=null
        return
    endif
    if vl_code<zzCF_BAG_SLOTS() then
        set vl_item=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]
        if zzKT_target[vl_playerId]>=0 and zzVL_sendTK[vl_playerId] and not zzVL_khamMode[vl_playerId] and not zzVL_sellMode[vl_playerId] and not zzVL_splitMode[vl_playerId] and not zzVL_DropMode(vl_playerId) then
            if vl_item!=null then
                call zzVL_Transfer(vl_playerId,vl_code)
                call zzVL_Refresh(vl_playerId)
                set vl_hero=null
                set vl_tk=null
                set vl_item=null
                set vl_old=null
                return
            endif
        endif
        if zzVL_bagSel[vl_playerId]>0 and not zzVL_khamMode[vl_playerId] and not zzVL_sellMode[vl_playerId] and not zzVL_splitMode[vl_playerId] and not zzVL_DropMode(vl_playerId) and not zzVL_sendTK[vl_playerId] and zzVL_tSel[vl_playerId]==null then
            set vl_w=zzVL_bagSel[vl_playerId]-1
            if vl_w!=vl_code then
                set vl_old=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_w]
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_w]=vl_item
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=vl_old
                set zzVL_bagSel[vl_playerId]=0
                call zzVL_Msg(vl_playerId,"Đã đổi vị trí vật phẩm trong hành trang.")
                call zzVL_Refresh(vl_playerId)
                set vl_hero=null
                set vl_tk=null
                set vl_item=null
                set vl_old=null
                return
            endif
            set zzVL_bagSel[vl_playerId]=0
        elseif vl_item!=null and not zzVL_khamMode[vl_playerId] and not zzVL_sellMode[vl_playerId] and not zzVL_splitMode[vl_playerId] and not zzVL_DropMode(vl_playerId) and not zzVL_sendTK[vl_playerId] and zzVL_tSel[vl_playerId]==null then
            set zzVL_bagSel[vl_playerId]=vl_code+1
            call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Chọn ô đích để đổi/chuyển vị trí; bấm lại món để sử dụng như bình thường.")
            call zzVL_Refresh(vl_playerId)
            set vl_hero=null
            set vl_tk=null
            set vl_item=null
            set vl_old=null
            return
        endif
        if vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 then
            if (LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 or zzGM_Type(GetItemTypeId(vl_item))>0) then
                set zzVL_kSel[vl_playerId]=1
                set zzVL_kItem[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị (đang mặc hoặc trong hành trang) để khảm.")
            else
                call zzVL_Msg(vl_playerId,"Món này không phải nguyên liệu khảm. Nguyên liệu: các loại Bảo Thạch, Kim Cương, Nữ Oa Tinh Thạch, Long Nguyên, Sa Nhung, Bồ Đề Mộc, Thiên Niên Cổ Vật.")
            endif
        elseif vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif vl_item!=null and zzVL_DropMode(vl_playerId) then
            if zzVL_IsEquipped(vl_playerId,vl_item) then
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
            else
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
                call zzIT_Set(GetHandleId(vl_item),zzIT_DA_VUT(),1)
                call SetItemVisible(vl_item,true)
                call SetItemPosition(vl_item,GetUnitX(vl_hero)+230.*Cos(GetUnitFacing(vl_hero)*bj_DEGTORAD),GetUnitY(vl_hero)+230.*Sin(GetUnitFacing(vl_hero)*bj_DEGTORAD))
                call zzVL_Msg(vl_playerId,"Đã vứt "+GetItemName(vl_item))
            endif
        elseif vl_item!=null then
            if zzVL_sellMode[vl_playerId] then
                call zzVL_Sell(vl_playerId,vl_code)
            elseif zzVL_splitMode[vl_playerId] then
                // trang bị đã khảm: tách bảo thạch; đồ cộng dồn: chia đôi như cũ
                if LoadInteger(zzVL_ht,GetHandleId(vl_item),43)<=0 or not zzVL_Tach(vl_playerId,vl_item) then
                    call zzVL_Split(vl_playerId,vl_code)
                endif
            elseif zzVL_tSel[vl_playerId]!=null and zzVL_tSel[vl_playerId]!=vl_item and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10>=1 then
                call zzVL_TtUse(vl_playerId,vl_item)
            elseif GetItemTypeId(vl_item)=='I00W' and not zzVL_sendTK[vl_playerId] then
                set zzVL_tSel[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn |cffffff00Huyền tinh|r.")
            elseif zzVL_sendTK[vl_playerId] then
                call zzVL_Transfer(vl_playerId,vl_code)
            else
                set vl_w=zzVL_EqSlot(vl_item)
                if vl_w>=0 and vl_w<=9 and not zzEQ_CheckWear(vl_hero,vl_item) then
                    set vl_w=-2
                endif
                if vl_w>=0 and vl_w<=9 then
                    set vl_old=zzVL_equipItem[vl_playerId*10+vl_w]
                    call zzEQ_InheritSlot(vl_playerId,vl_w,vl_item,vl_old)
                    set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
                    if vl_old!=null then
                        set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=vl_old
                    endif
                    set zzVL_equipItem[vl_playerId*10+vl_w]=vl_item
                    if UnitHasItem(vl_hero,vl_item) then
                        call UnitRemoveItem(vl_hero,vl_item)
                    endif
                    call SetItemVisible(vl_item,false)
                    call zzVL_AffixSum(vl_playerId)
                    call ExecuteFunc("zzVL_HeroTick")
                elseif vl_w==-2 then
                    set vl_old=null
                else
                    if GetItemCharges(vl_item)>1 and (UnitItemInSlot(vl_hero,5)==null or GetItemTypeId(UnitItemInSlot(vl_hero,5))==GetItemTypeId(vl_item)) then
                        if UnitItemInSlot(vl_hero,5)!=null then
                            call SetItemCharges(UnitItemInSlot(vl_hero,5),GetItemCharges(UnitItemInSlot(vl_hero,5))+1)
                        else
                            set vl_old=CreateItem(GetItemTypeId(vl_item),GetUnitX(vl_hero),GetUnitY(vl_hero))
                            call SetItemCharges(vl_old,1)
                            if UnitAddItem(vl_hero,vl_old) then
                                call UnitDropItemSlot(vl_hero,vl_old,5)
                            endif
                        endif
                        call SetItemCharges(vl_item,GetItemCharges(vl_item)-1)
                    else
                        set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
                        call SetItemVisible(vl_item,true)
                        call SetItemPosition(vl_item,GetUnitX(vl_hero),GetUnitY(vl_hero))
                        if not UnitAddItem(vl_hero,vl_item) then
                            call zzVL_Msg(vl_playerId,"Không thể mang món này (Hành trang trên người đã đầy).")
                            if not zzVL_BagAdd(vl_playerId,vl_item) then
                                call zzVL_Msg(vl_playerId,"|cffff8000Hành trang phụ đã đầy, đồ được để dưới chân.|r")
                            endif
                        endif
                    endif
                endif
            endif
        endif
    elseif vl_code<240 then
        set vl_item=zzVL_equipItem[vl_playerId*10+vl_code-230]
        if vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 and (LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 or zzGM_Type(GetItemTypeId(vl_item))>0) then
            set zzVL_kSel[vl_playerId]=1
            set zzVL_kItem[vl_playerId]=vl_item
            call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị để khảm.")
        elseif vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif vl_item!=null and zzVL_splitMode[vl_playerId] then
            if LoadInteger(zzVL_ht,GetHandleId(vl_item),43)>0 then
                call zzVL_Tach(vl_playerId,vl_item)
            else
                call zzVL_Msg(vl_playerId,"Món này chưa khảm bảo thạch.")
            endif
        elseif vl_item!=null and zzVL_tSel[vl_playerId]!=null then
            call zzVL_TtUse(vl_playerId,vl_item)
        elseif vl_item!=null then
            if zzVL_BagAdd(vl_playerId,vl_item) then
                set zzVL_equipItem[vl_playerId*10+vl_code-230]=null
                call zzVL_AffixSum(vl_playerId)
                call ExecuteFunc("zzVL_HeroTick")
            else
                call zzVL_Msg(vl_playerId,"|cffff8000Hành trang phụ đã đầy, không thể tháo đồ.|r")
            endif
        endif
    elseif vl_code<242 then
        if vl_tk!=null then
            set vl_item=UnitItemInSlot(vl_tk,vl_code-236)
            if vl_item!=null then
                call zzVL_ToBag(vl_playerId,vl_tk,vl_item)
            endif
        endif
    elseif vl_code==242 then
        call zzVL_SetDropMode(vl_playerId,false)
        set zzVL_sendTK[vl_playerId]=not zzVL_sendTK[vl_playerId]
        set zzVL_bagSel[vl_playerId]=0
        if zzVL_sendTK[vl_playerId] then
            set zzKT_target[vl_playerId]=-1
        endif
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==248 then
        call zzVL_SetDropMode(vl_playerId,false)
        set zzVL_khamMode[vl_playerId]=not zzVL_khamMode[vl_playerId]
        set zzVL_kSel[vl_playerId]=0
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        if zzVL_khamMode[vl_playerId] then
            if not zzVL_heroOpen[vl_playerId] then
                call zzVL_Msg(vl_playerId,"Mở thêm bảng |cffffcc00Nhân vật (I)|r để khảm vào đồ đang mặc.")
            endif
            call zzVL_Msg(vl_playerId,"|cff80c0ffKhảm|r: bấm bảo thạch trong hành trang, rồi bấm trang bị (ô nhân vật hoặc hành trang). Mỗi trang bị "+I2S(zzCF_KHAM_SO_LO())+" lỗ. Muốn thay viên: bật |cff00ff00Tách|r rồi bấm trang bị ("+I2S(zzCF_KHAM_TACH_VANG())+" vàng / viên).")
        endif
    elseif vl_code==246 then
        call zzVL_SetDropMode(vl_playerId,false)
        set zzVL_sellMode[vl_playerId]=not zzVL_sellMode[vl_playerId]
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==247 then
        call zzVL_SetDropMode(vl_playerId,false)
        set zzVL_splitMode[vl_playerId]=not zzVL_splitMode[vl_playerId]
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==245 then
        call zzVL_SetDropMode(vl_playerId,not zzVL_DropMode(vl_playerId))
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
        if zzVL_DropMode(vl_playerId) then
            call zzVL_Msg(vl_playerId,"|cffff6040Vứt|r: bấm món trong hành trang để vứt xuống đất (không mất, nhặt lại được).")
        endif
    elseif vl_code==243 then
        call zzVL_BagShow(vl_playerId,false)
    elseif vl_code==244 then
        call zzVL_BagShow(vl_playerId,not zzVL_bagOpen[vl_playerId])
    endif
    if zzVL_bagOpen[vl_playerId] then
        call zzVL_Refresh(vl_playerId)
    endif
    set vl_hero=null
    set vl_tk=null
    set vl_item=null
    set vl_old=null
endfunction

// ==========================================
// Hàm: zzVL_OnFrameClick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzKT_TargetClick takes integer vl_pid,integer vl_target returns nothing
    if vl_pid>=0 and vl_pid<10 and vl_target>=0 and vl_target<10 and vl_target!=vl_pid and IsPlayerAlly(Player(vl_pid),Player(vl_target)) and Jx[vl_target+1]!=null and GetWidgetLife(Jx[vl_target+1])>.405 then
        set zzKT_target[vl_pid]=vl_target
        call zzVL_Msg(vl_pid,"Đã chọn người nhận: "+GetPlayerName(Player(vl_target))+" - "+GetUnitName(Jx[vl_target+1])+". Bấm món đồ để chuyển.")
        call zzVL_Refresh(vl_pid)
    endif
endfunction

function zzVL_OnFrameClick takes nothing returns nothing
    local framehandle vl_f=BlzGetTriggerFrame()
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_code=LoadInteger(zzVL_ht,GetHandleId(vl_f),7)-1
    if vl_code>=300 and vl_code<310 then
        call zzKT_TargetClick(vl_playerId,vl_code-300)
    elseif vl_code>=100 and vl_code<110 then
        // the small + beside an equipment slot of the character panel (zzVL_PlusDo, defined after zzVL_HeroShow)
        set zzVL_plusP=vl_playerId
        set zzVL_plusS=vl_code-100
        call ExecuteFunc("zzVL_PlusDo")
    elseif vl_code>=0 and zzVL_IsBagUser(vl_playerId) then
        call zzVL_BagClick(vl_playerId,vl_code)
    endif
    set vl_f=null
endfunction

// ==========================================
// Hàm: zzVL_OnBagKey
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnBagKey takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    if zzVL_IsBagUser(vl_playerId) then
        call zzVL_BagShow(vl_playerId,not zzVL_bagOpen[vl_playerId])
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnItemOrder
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnItemOrder takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    local integer vl_o=GetIssuedOrderId()
    local item vl_item
    local integer vl_lv
    if vl_o>=852008 and vl_o<=852013 and IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO) then
        set vl_item=UnitItemInSlot(GetTriggerUnit(),vl_o-852008)
        set vl_lv=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),57)
        if vl_item!=null and vl_lv>GetHeroLevel(GetTriggerUnit()) then
            call PauseUnit(GetTriggerUnit(),true)
            call IssueImmediateOrderById(GetTriggerUnit(),851972)
            call PauseUnit(GetTriggerUnit(),false)
            if vl_playerId<=9 then
                call zzVL_Msg(vl_playerId,"|cffff8000"+GetItemName(vl_item)+" cần tướng cấp "+I2S(vl_lv)+".|r")
            endif
        endif
        set vl_item=null
        return
    endif
    if GetOrderTargetItem()!=null and zzVL_IsBagUser(vl_playerId) and GetTriggerUnit()==Jx[vl_playerId+1] then
        set zzVL_want[vl_playerId]=GetOrderTargetItem()
    else
        set zzVL_want[vl_playerId]=null
    endif
endfunction

// ==========================================
// Hàm: zzVL_LootEnum
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_LootEnum takes nothing returns nothing
    local item vl_item=GetEnumItem()
    local unit vl_hero=Jx[zzVL_lootPid+1]
    if zzVL_lootN<8 and IsItemVisible(vl_item) and not IsItemOwned(vl_item) and zzIT_Get(GetHandleId(vl_item),zzIT_DA_VUT())==0 and GetItemType(vl_item)!=ITEM_TYPE_POWERUP and IsUnitInRangeXY(vl_hero,GetItemX(vl_item),GetItemY(vl_item),150.) then
        set zzVL_lootIt[zzVL_lootN]=vl_item
        set zzVL_lootN=zzVL_lootN+1
    endif
    set vl_item=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_AutoLoot
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AutoLoot takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_i
    local string vl_string
    local unit vl_hero
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if zzVL_IsBagUser(vl_playerId) and vl_hero!=null and GetWidgetLife(vl_hero)>.405 and UnitInventoryCount(vl_hero)>=6 then
            set zzVL_lootPid=vl_playerId
            set zzVL_lootN=0
            call SetRect(zzVL_lootR,GetUnitX(vl_hero)-160.,GetUnitY(vl_hero)-160.,GetUnitX(vl_hero)+160.,GetUnitY(vl_hero)+160.)
            call EnumItemsInRect(zzVL_lootR,null,function zzVL_LootEnum)
            set vl_i=0
            loop
                exitwhen vl_i>=zzVL_lootN
                call zzVL_RollAffix(zzVL_lootIt[vl_i])
                set vl_string=GetItemName(zzVL_lootIt[vl_i])
                if zzVL_BagAdd(vl_playerId,zzVL_lootIt[vl_i]) then
                    call zzVL_Msg(vl_playerId,"Tự nhặt vào hành trang: "+vl_string)
                    call zzVL_Log("tu nhat p"+I2S(vl_playerId))
                endif
                set zzVL_lootIt[vl_i]=null
                set vl_i=vl_i+1
            endloop
            if zzVL_lootN>0 and zzVL_bagOpen[vl_playerId] then
                call zzVL_Refresh(vl_playerId)
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_WantTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_WantTick takes nothing returns nothing
    local integer vl_playerId=0
    local item vl_item
    local unit vl_hero
    loop
        exitwhen vl_playerId>9
        set vl_item=zzVL_want[vl_playerId]
        set vl_hero=Jx[vl_playerId+1]
        if vl_item!=null then
            if GetItemTypeId(vl_item)==0 or not IsItemVisible(vl_item) or IsItemOwned(vl_item) or vl_hero==null or GetWidgetLife(vl_hero)<.405 then
                set zzVL_want[vl_playerId]=null
            elseif UnitInventoryCount(vl_hero)>=6 and IsUnitInRangeXY(vl_hero,GetItemX(vl_item),GetItemY(vl_item),180.) and GetItemType(vl_item)!=ITEM_TYPE_POWERUP then
                set zzVL_want[vl_playerId]=null
                call IssueImmediateOrderById(vl_hero,851972)
                call zzVL_RollAffix(vl_item)
                if zzVL_BagAdd(vl_playerId,vl_item) then
                    call zzVL_Msg(vl_playerId,"Đã cất vào hành trang: "+GetItemName(vl_item))
                    if zzVL_bagOpen[vl_playerId] then
                        call zzVL_Refresh(vl_playerId)
                    endif
                else
                    call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy ("+I2S(zzCF_BAG_SLOTS())+" ô).|r")
                endif
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_item=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_BagTick
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BagTick takes nothing returns nothing
    local integer vl_playerId=0
    loop
        exitwhen vl_playerId>9
        if zzVL_bagOpen[vl_playerId] then
            call zzVL_Refresh(vl_playerId)
        endif
        set vl_playerId=vl_playerId+1
    endloop
endfunction

// ==========================================
// Hàm: zzVL_MakeText
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_parent (framehandle)
//   - vl_x (real)
//   - vl_y (real)
//   - vl_w (real)
//   - vl_string (string)
// Trả về dữ liệu kiểu: framehandle
function zzVL_MakeText takes framehandle vl_parent,real vl_x,real vl_y,real vl_w,string vl_string returns framehandle
    local framehandle vl_t=BlzCreateFrameByType("TEXT","",vl_parent,"",0)
    call BlzFrameSetAbsPoint(vl_t,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_t,vl_w,.016)
    call BlzFrameSetText(vl_t,vl_string)
    return vl_t
endfunction

// ==========================================
// Hàm: zzVL_MakeSlot
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_code (integer)
//   - vl_x (real)
//   - vl_y (real)
// Không trả về giá trị (thực thi hành động).
function zzVL_MakeSlot takes integer vl_code,real vl_x,real vl_y,real vl_size returns nothing
    local framehandle vl_b=BlzCreateFrameByType("BUTTON","",zzVL_fMain,"",0)
    local framehandle vl_i=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    local framehandle vl_bg=BlzCreateFrame("EscMenuBackdrop",vl_b,0,0)
    local framehandle vl_t=BlzCreateFrameByType("TEXT","",vl_bg,"",0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_b,vl_size,vl_size)
    call BlzFrameSetAllPoints(vl_i,vl_b)
    call BlzFrameSetTexture(vl_i,"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp",0,true)
    call BlzFrameSetSize(vl_t,.24,0.)
    call BlzFrameSetAbsPoint(vl_t,FRAMEPOINT_TOPRIGHT,.455,.55)
    call BlzFrameSetPoint(vl_bg,FRAMEPOINT_TOPLEFT,vl_t,FRAMEPOINT_TOPLEFT,-.012,.012)
    call BlzFrameSetPoint(vl_bg,FRAMEPOINT_BOTTOMRIGHT,vl_t,FRAMEPOINT_BOTTOMRIGHT,.012,-.012)
    call BlzFrameSetVisible(vl_bg,false)
    // Item details are rendered by the shared hover frame; keep native tooltip from overlaying adjacent controls.
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    if vl_code<zzCF_BAG_SLOTS() then
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),8,1)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),9,vl_code)
    elseif vl_code>=236 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),8,3)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),9,vl_code-236)
    endif
    call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOn,vl_b,FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOff,vl_b,FRAMEEVENT_MOUSE_LEAVE)
    set zzVL_fIco[vl_code]=vl_i
    set zzVL_fTip[vl_code]=vl_t
    set zzVL_fCnt[vl_code]=BlzCreateFrameByType("TEXT","",vl_b,"",0)
    call BlzFrameSetPoint(zzVL_fCnt[vl_code],FRAMEPOINT_BOTTOMRIGHT,vl_b,FRAMEPOINT_BOTTOMRIGHT,-.002,.002)
    call BlzFrameSetSize(zzVL_fCnt[vl_code],.03,.012)
    call BlzFrameSetTextAlignment(zzVL_fCnt[vl_code],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
    call BlzFrameSetEnable(zzVL_fCnt[vl_code],false)
    call BlzFrameSetText(zzVL_fCnt[vl_code],"")
    set vl_b=null
    set vl_i=null
    set vl_bg=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_MakeButton
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_code (integer)
//   - vl_parent (framehandle)
//   - vl_x (real)
//   - vl_y (real)
//   - vl_w (real)
//   - vl_string (string)
// Trả về dữ liệu kiểu: framehandle
function zzVL_MakeButton takes integer vl_code,framehandle vl_parent,real vl_x,real vl_y,real vl_w,string vl_string returns framehandle
    local framehandle vl_b=BlzCreateFrame("ScriptDialogButton",vl_parent,0,0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_b,vl_w,.024)
    call BlzFrameSetText(vl_b,vl_string)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
    return vl_b
endfunction

// ==========================================
// Hàm: zzVL_MakeHl
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_b (framehandle)
// Trả về dữ liệu kiểu: framehandle
function zzVL_MakeHl takes framehandle vl_b returns framehandle
    local framehandle vl_hero=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    call BlzFrameSetPoint(vl_hero,FRAMEPOINT_TOPLEFT,vl_b,FRAMEPOINT_TOPLEFT,-.004,.004)
    call BlzFrameSetPoint(vl_hero,FRAMEPOINT_BOTTOMRIGHT,vl_b,FRAMEPOINT_BOTTOMRIGHT,.004,-.004)
    call BlzFrameSetTexture(vl_hero,"UI\\Widgets\\Console\\Human\\CommandButton\\human-activebutton.blp",0,true)
    call BlzFrameSetAlpha(vl_hero,180)
    call BlzFrameSetVisible(vl_hero,false)
    return vl_hero
endfunction

// ==========================================
// Hàm: zzVL_MakeIconButton
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_code (integer)
//   - vl_parent (framehandle)
//   - vl_x (real)
//   - vl_y (real)
//   - vl_string (real)
//   - vl_tex (string)
// Trả về dữ liệu kiểu: framehandle
function zzVL_MakeIconButton takes integer vl_code,framehandle vl_parent,real vl_x,real vl_y,real vl_string,string vl_tex returns framehandle
    local framehandle vl_b=BlzCreateFrameByType("BUTTON","",vl_parent,"",0)
    local framehandle vl_i=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_b,vl_string,vl_string)
    call BlzFrameSetAllPoints(vl_i,vl_b)
    call BlzFrameSetTexture(vl_i,vl_tex,0,true)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
    return vl_b
endfunction

// ==========================================
// Hàm: zzVL_Panel
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_parent (framehandle)
//   - vl_x0 (real)
//   - vl_y0 (real)
//   - vl_x1 (real)
//   - vl_y1 (real)
//   - vl_tex (string)
//   - vl_a (integer)
// Trả về dữ liệu kiểu: framehandle
function zzVL_Panel takes framehandle vl_parent,real vl_x0,real vl_y0,real vl_x1,real vl_y1,string vl_tex,integer vl_a returns framehandle
    local framehandle vl_b=BlzCreateFrameByType("BACKDROP","",vl_parent,"",0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x0,vl_y0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_BOTTOMRIGHT,vl_x1,vl_y1)
    call BlzFrameSetTexture(vl_b,vl_tex,0,true)
    call BlzFrameSetAlpha(vl_b,vl_a)
    call BlzFrameSetEnable(vl_b,false)
    return vl_b
endfunction

// ==========================================
// Hàm: zzVL_HeroText
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_playerId (integer)
// Trả về dữ liệu kiểu: string
function zzVL_HeroText takes integer vl_playerId returns string
    local unit vl_hero=Jx[vl_playerId+1]
    local string vl_string
    local integer vl_i=0
    local integer vl_tp=0
    if vl_hero==null then
        return "Chưa chọn tướng."
    endif
    loop
        exitwhen vl_i>5
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)<50 then
            set vl_tp=vl_tp+zzVL_GearScore(zzVL_equipItem[vl_playerId*10+vl_i])
        endif
        set vl_i=vl_i+1
    endloop
    set vl_string="|cffffcc00"+GetHeroProperName(vl_hero)+"|r - "+GetUnitName(vl_hero)+"|nCấp "+I2S(GetHeroLevel(vl_hero))+"  |  "+zzVL_hn[zzVL_he[vl_playerId]]+"  |  "+zzVL_QAName(zzVL_rank[vl_playerId])
    set vl_string=vl_string+"|n|n|cffffcc00SINH LỰC|r  "+I2S(R2I(GetWidgetLife(vl_hero)))+" / "+I2S(BlzGetUnitMaxHP(vl_hero))+"|n|cff6aa0ffNỘI LỰC|r  "+I2S(R2I(GetUnitState(vl_hero,UNIT_STATE_MANA)))+" / "+I2S(BlzGetUnitMaxMana(vl_hero))
    set vl_string=vl_string+"|n|cffffcc00CÔNG KÍCH|r  "+I2S(BlzGetUnitBaseDamage(vl_hero,0)+BlzGetUnitDiceNumber(vl_hero,0))+" - "+I2S(BlzGetUnitBaseDamage(vl_hero,0)+BlzGetUnitDiceNumber(vl_hero,0)*BlzGetUnitDiceSides(vl_hero,0))+"|n|cffffcc00PHÒNG THỦ|r  "+I2S(R2I(BlzGetUnitArmor(vl_hero)))
    set vl_string=vl_string+"|n|n|cffff8080SỨC MẠNH|r  "+I2S(GetHeroStr(vl_hero,true))+"|n|cff80ff80THÂN PHÁP|r  "+I2S(GetHeroAgi(vl_hero,true))+"|n|cff80c0ffNỘI CÔNG|r  "+I2S(GetHeroInt(vl_hero,true))
    set vl_string=vl_string+"|n|n|cffffcc00THUỘC TÍNH CHIẾN ĐẤU|r"
    set vl_string=vl_string+"|nHút sinh lực: "+I2S(zzVL_af[vl_playerId*16+1])+"%   Hút nội lực: "+I2S(zzVL_af[vl_playerId*16+2])+"%"
    set vl_string=vl_string+"|nBạo kích: "+I2S(zzVL_af[vl_playerId*16+3])+"%"
    set vl_string=vl_string+"|nTốc đánh: +"+I2S(zzVL_af[vl_playerId*16+4])+"%   Sát thương: +"+I2S(zzVL_af[vl_playerId*16+5])+"%"
    set vl_string=vl_string+"|nGiảm sát thương nhận: "+I2S(zzVL_af[vl_playerId*16+6])+"%"
    set vl_string=vl_string+"|nTốc xuất chiêu: +"+I2S(zzPS_Get(vl_playerId,zzPS_TOC_XUAT_CHIEU()))+"%"
    if zzVL_Phe(vl_hero)==2 then
        set vl_string=vl_string+"|nHệ: |cff66ccffNội công|r (hưởng STVL nội công, kỹ năng theo Nội công)"
        set vl_string=vl_string+"|nSát thương nội công: +"+I2S(zzPS_Get(vl_playerId,zzPS_STVL_NOI()))+"   |cff808080STVL ngoại công: +"+I2S(zzPS_Get(vl_playerId,zzPS_STVL_NGOAI()))+" (không tác dụng)|r"
    else
        set vl_string=vl_string+"|nHệ: |cffff9933Ngoại công|r (hưởng STVL ngoại công, kỹ năng theo Sức mạnh / vũ khí)"
        set vl_string=vl_string+"|nSát thương ngoại công: +"+I2S(zzPS_Get(vl_playerId,zzPS_STVL_NGOAI()))+"   |cff808080STVL nội công: +"+I2S(zzPS_Get(vl_playerId,zzPS_STVL_NOI()))+" (không tác dụng)|r"
    endif
    set vl_string=vl_string+"|nCấp kỹ năng: +"+I2S(zzPS_Get(vl_playerId,zzPS_CAP_KY_NANG()))+"   Đánh trúng: "+I2S(zzPS_Get(vl_playerId,zzPS_DANH_TRUNG()))
    set vl_string=vl_string+"|nNé ngoại công: "+I2S(zzVL_PheDodge(vl_hero,vl_playerId,1))+"   Né nội công: "+I2S(zzVL_PheDodge(vl_hero,vl_playerId,2))+"   Tốc chạy: +"+I2S(zzVL_af[vl_playerId*16+13])
    set vl_string=vl_string+"|nKháng vật lý: "+I2S(zzPS_Get(vl_playerId,zzPS_KHANG_VL()))+"%"
    set vl_string=vl_string+"|nKháng độc: "+I2S(zzPS_Get(vl_playerId,zzPS_KHANG_DOC()))+"%   Kháng thủy: "+I2S(zzPS_Get(vl_playerId,zzPS_KHANG_THUY()))+"%"
    set vl_string=vl_string+"|nKháng hỏa: "+I2S(zzPS_Get(vl_playerId,zzPS_KHANG_HOA()))+"%   Kháng lôi: "+I2S(zzPS_Get(vl_playerId,zzPS_KHANG_LOI()))+"%"
    set vl_string=vl_string+"|n|n|cffffcc00TRANG BỊ (10 Ô)|r  Cấp cường hóa hiển thị trên từng ô"
    set vl_string=vl_string+"|n|cffffcc00Tài phú|r "+I2S(vl_tp)+"|n|cffffcc00Hạ|r "+I2S(zzVL_kills[vl_playerId])+"   |cffffcc00Chết|r "+I2S(zzVL_deaths[vl_playerId])
    set vl_string=vl_string+"|n|n|cffffcc00HUYỀN TINH|r  "+I2S(zzGL_Count(vl_playerId))+" viên"
    set vl_hero=null
    return vl_string
endfunction

// ==========================================
// Hàm: zzVL_EquipSlotName
// Tên gọi 10 vị trí trang bị nhân vật
function zzVL_EquipSlotName takes integer vl_slot returns string
    if vl_slot==0 then
        return "Nón"
    elseif vl_slot==1 then
        return "Áo"
    elseif vl_slot==2 then
        return "Yêu Đái"
    elseif vl_slot==3 then
        return "Hộ Uyển"
    elseif vl_slot==4 then
        return "Hài"
    elseif vl_slot==5 then
        return "Vũ Khí"
    elseif vl_slot==6 then
        return "Hạng Liên"
    elseif vl_slot==7 then
        return "Giới Chỉ"
    elseif vl_slot==8 then
        return "Ngọc Bội"
    elseif vl_slot==9 then
        return "Hộ Thân Phù"
    endif
    return ""
endfunction

// ==========================================
// Hàm: zzVL_EquipSlotStat
// Mô tả thuộc tính và cấp cường hóa của ô trang bị
function zzVL_EquipSlotStat takes integer vl_slot,integer vl_ch returns string
    local string s=""
    if vl_slot==0 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Sức mạnh, Thân pháp, Nội công\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*2)+" mọi chỉ số, +"+I2S(vl_ch*100)+" Sinh lực"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==1 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Phòng thủ, Kháng vật lý\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r Giảm "+I2S(vl_ch)+"% sát thương nhận, +"+I2S(vl_ch*2)+"% Kháng vật lý"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==2 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Sinh lực, Kháng Độc, Kháng Thủy\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*150)+" Sinh lực, +"+I2S(vl_ch*2)+"% Kháng độc/thủy"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==3 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Tốc đánh, Kháng Hỏa, Kháng Lôi\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*3)+"% Tốc đánh, +"+I2S(vl_ch*2)+"% Kháng hỏa/lôi"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==4 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Tốc độ di chuyển, Né tránh\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*3)+" Tốc chạy, +"+I2S(vl_ch*15)+" Né tránh"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==5 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Công kích, Sát thương %, Ngũ hành vũ khí\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*3)+"% Sát thương, +"+I2S(vl_ch*20)+" STVL ngoại công"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==6 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Bạo kích, STVL nội công, Tốc độ xuất chiêu\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch)+"% Bạo kích, +"+I2S(vl_ch*20)+" STVL nội công, +"+I2S(vl_ch*2)+"% Tốc độ xuất chiêu"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==7 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Điểm đánh trúng, Hút sinh lực\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*15)+" Điểm đánh trúng, +"+I2S(vl_ch)+"% Hút sinh lực, +"+I2S(vl_ch)+"% Sát thương"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==8 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Hút nội lực, Kháng toàn bộ ngũ hành\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch)+"% Hút nội lực, +"+I2S(vl_ch)+"% Kháng tất cả 5 hệ"
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    elseif vl_slot==9 then
        set s="|cffffcc00Thuộc tính cơ bản:|r Sinh lực, Kỹ năng môn phái\n"
        if vl_ch>0 then
            set s=s+"|cff00ff00Cường hóa +"+I2S(vl_ch)+":|r +"+I2S(vl_ch*200)+" Sinh lực, Giảm "+I2S(vl_ch)+"% ST nhận"
            if vl_ch>=10 then
                set s=s+", Tất cả kỹ năng +1 cấp"
            endif
        else
            set s=s+"|cff9a9a9aChưa cường hóa (dùng Huyền Tinh để tăng cấp)|r"
        endif
    endif
    return s
endfunction

// ==========================================
// Hàm: zzVL_HeroShow
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_on (boolean)
// Không trả về giá trị (thực thi hành động).
function zzVL_HeroShow takes integer vl_playerId,boolean vl_on returns nothing
    local string vl_string=zzVL_HeroText(vl_playerId)
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_i=0
    local integer vl_j=0
    local integer vl_ch=0
    local integer vl_ab
    set zzVL_heroOpen[vl_playerId]=vl_on
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetText(zzVL_fHeroTxt,vl_string)
        if vl_hero!=null and vl_on then
            loop
                set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),200+vl_i)
                exitwhen vl_ab==0 or vl_i>=14 or vl_j>5
                if zzSK_Int(vl_ab,zzSK_KIND())==0 and GetUnitAbilityLevel(vl_hero,vl_ab)>0 then
                    call BlzFrameSetTexture(zzVL_fPassIco[vl_j],BlzGetAbilityIcon(vl_ab),0,true)
                    call BlzFrameSetText(zzVL_fPassTTxt[vl_j],"|cffffcc00"+GetObjectName(vl_ab)+"|r|n"+BlzGetAbilityExtendedTooltip(vl_ab,GetUnitAbilityLevel(vl_hero,vl_ab)-1))
                    call SaveInteger(zzVL_ht,GetHandleId(zzVL_fPassBtn[vl_j]),8,vl_ab)
                    call BlzFrameSetVisible(zzVL_fPassBtn[vl_j],true)
                    set vl_j=vl_j+1
                endif
                set vl_i=vl_i+1
            endloop
        endif
        loop
            exitwhen vl_j>5
            call BlzFrameSetVisible(zzVL_fPassBtn[vl_j],false)
            set vl_j=vl_j+1
        endloop
        set vl_j=0
        loop
            exitwhen vl_j>9
            set vl_ch=zzEQ_SlotLv(vl_playerId,vl_j)
            if vl_ch>0 then
                call BlzFrameSetText(zzVL_fEqTxt[vl_j],"|cffffcc00+"+I2S(vl_ch)+"|r")
            elseif zzVL_equipItem[vl_playerId*10+vl_j]!=null and zzEQ_IsKv(GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_j])) then
                call BlzFrameSetText(zzVL_fEqTxt[vl_j],"|cffffcc00+0|r")
            else
                call BlzFrameSetText(zzVL_fEqTxt[vl_j],"")
            endif
            if zzVL_equipItem[vl_playerId*10+vl_j] != null then
                call BlzFrameSetTexture(zzVL_fEqIco[vl_j], BlzGetItemIconPath(zzVL_equipItem[vl_playerId*10+vl_j]), 0, true)
                call BlzFrameSetText(zzVL_fEqTTxt[vl_j], "|cffffcc00[Trang Bị: "+zzVL_EquipSlotName(vl_j)+"]|r\n"+GetItemName(zzVL_equipItem[vl_playerId*10+vl_j])+"\n"+BlzGetItemExtendedTooltip(zzVL_equipItem[vl_playerId*10+vl_j]))
            else
                call BlzFrameSetTexture(zzVL_fEqIco[vl_j], "war3mapImported\\vl_eq_"+I2S(vl_j+1)+".blp", 0, true)
                call BlzFrameSetText(zzVL_fEqTTxt[vl_j],"|cffffcc00[Trang Bị: "+zzVL_EquipSlotName(vl_j)+"]|r\n"+zzVL_EquipSlotStat(vl_j,vl_ch))
            endif
            set vl_j=vl_j+1
        endloop
        call BlzFrameSetVisible(zzVL_fHero,vl_on)
    endif
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_HeroTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_HeroTick takes nothing returns nothing
    local integer vl_playerId=0
    local item vl_potion
    loop
        exitwhen vl_playerId>9
        // lưới an toàn: tướng có rồi mà chưa được phát bộ +0 (hook chọn tướng không chạy) thì phát ở đây
        if not zzEQ_starterGiven[vl_playerId] and Jx[vl_playerId+1]!=null and IsUnitType(Jx[vl_playerId+1],UNIT_TYPE_HERO) then
            set zzEQ_starterHero[vl_playerId]=Jx[vl_playerId+1]
            call zzEQ_GiveStarter()
        endif
        if not zzKT_starter[vl_playerId] and Jx[vl_playerId+1]!=null and IsUnitType(Jx[vl_playerId+1],UNIT_TYPE_HERO) then
            set vl_potion=CreateItem('phea',GetUnitX(Jx[vl_playerId+1]),GetUnitY(Jx[vl_playerId+1]))
            call SetItemCharges(vl_potion,10)
            if zzVL_BagAdd(vl_playerId,vl_potion) then
                set zzKT_starter[vl_playerId]=true
                call zzVL_Msg(vl_playerId,"Tặng 10 bình hồi máu cấp thấp (cấp 1). Phím 1 dùng bình; -autohp bật/tắt, -autohp 1..100 đặt ngưỡng tự bơm.")
            else
                call RemoveItem(vl_potion)
            endif
            set vl_potion=null
        endif
        call zzVL_HeroShow(vl_playerId,zzVL_heroOpen[vl_playerId])
        set vl_playerId=vl_playerId+1
    endloop
    set vl_potion=null
endfunction

// ==========================================
// Hàm: zzVL_OnHeroKey
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnHeroKey takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    call zzVL_HeroShow(vl_playerId,not zzVL_heroOpen[vl_playerId])
endfunction

// ==========================================
// Hàm: zzVL_BannerHide
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BannerHide takes nothing returns nothing
    call BlzFrameSetVisible(zzVL_fBannerBg,false)
endfunction

// ==========================================
// Hàm: zzVL_Banner
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_Banner takes string vl_string returns nothing
    if zzVL_fBanner==null then
        return
    endif
    call BlzFrameSetText(zzVL_fBanner,vl_string)
    call BlzFrameSetVisible(zzVL_fBannerBg,true)
    call TimerStart(zzVL_bannerT,5.,false,function zzVL_BannerHide)
endfunction

// ==========================================
// Hàm: zzVL_BannerMsg
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BannerMsg takes nothing returns nothing
    call zzVL_Banner(zzVL_logMsg)
endfunction

// ==========================================
// Hàm: zzVL_BannerArena
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BannerArena takes nothing returns nothing
    call zzVL_Banner("|cffff8000LIÊN ĐẤU|r bắt đầu - các cao thủ vào đấu trường!")
endfunction

// ==========================================
// Hàm: zzVL_BagUI
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
// hover over a passive icon of the character panel: one shared tooltip box above the icons shows the skill text
function zzVL_PassTipOn takes nothing returns nothing
    local integer vl_ab=LoadInteger(zzVL_ht,GetHandleId(BlzGetTriggerFrame()),8)
    local player vl_pl=GetTriggerPlayer()
    local unit vl_hero=Jx[GetPlayerId(vl_pl)+1]
    if vl_ab!=0 and vl_hero!=null and GetLocalPlayer()==vl_pl then
        call BlzFrameSetText(zzVL_fPassTipTxt,"|cffffcc00"+GetObjectName(vl_ab)+"|r|n"+BlzGetAbilityExtendedTooltip(vl_ab,IMaxBJ(1,GetUnitAbilityLevel(vl_hero,vl_ab))-1))
        call BlzFrameSetVisible(zzVL_fPassTip,true)
    endif
    set vl_pl=null
    set vl_hero=null
endfunction
function zzVL_PassTipOff takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call BlzFrameSetVisible(zzVL_fPassTip,false)
    endif
endfunction
// ==========================================
// Cường hóa bằng nút +, trả giá bằng GlassPoint. Tinh thể I00W cũ được đổi sang điểm trước khi nâng.
function zzVL_PlusCount takes integer vl_playerId returns integer
    return zzGL_Get(vl_playerId)
endfunction

function zzVL_PlusConvertLegacy takes integer vl_playerId returns nothing
    local integer vl_i=0
    local integer vl_n
    local item vl_item
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_item=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
        if vl_item!=null and GetItemTypeId(vl_item)=='I00W' then
            set vl_n=IMaxBJ(1,GetItemCharges(vl_item))
            call zzGL_Give(vl_playerId,vl_n)
            set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
            call RemoveItem(vl_item)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=6 or vl_hero==null
        set vl_item=UnitItemInSlot(vl_hero,vl_i)
        if vl_item!=null and GetItemTypeId(vl_item)=='I00W' then
            set vl_n=IMaxBJ(1,GetItemCharges(vl_item))
            call zzGL_Give(vl_playerId,vl_n)
            call RemoveItem(vl_item)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=6 or vl_tk==null
        set vl_item=UnitItemInSlot(vl_tk,vl_i)
        if vl_item!=null and GetItemTypeId(vl_item)=='I00W' then
            set vl_n=IMaxBJ(1,GetItemCharges(vl_item))
            call zzGL_Give(vl_playerId,vl_n)
            call RemoveItem(vl_item)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_item=null
    set vl_hero=null
    set vl_tk=null
    set zzVL_tSel[vl_playerId]=null
endfunction

function zzVL_PlusDo takes nothing returns nothing
    local integer vl_p=zzVL_plusP
    local integer vl_s=zzVL_plusS
    local item vl_it=zzVL_equipItem[vl_p*10+vl_s]
    local boolean vl_ok
    if not zzVL_IsBagUser(vl_p) then
        return
    endif
    if vl_it==null then
        call zzVL_Msg(vl_p,"Ô này chưa có trang bị để cường hóa.")
        return
    endif
    // Do not consume any crystals unless there is a valid equipped target.
    call zzVL_PlusConvertLegacy(vl_p)
    if zzVL_bagOpen[vl_p] then
        call zzVL_Refresh(vl_p)
    endif
    if zzEQ_IsKv(GetItemTypeId(vl_it)) then
        set vl_ok=zzEQ_TryEnhance(vl_p,vl_it)
    else
        set vl_ok=zzEQ_TrySlotEnhance(vl_p,vl_s,vl_it)
    endif
    if vl_ok then
        call zzVL_AffixSum(vl_p)
        call ExecuteFunc("zzVL_HeroTick")
        call zzVL_HeroShow(vl_p,true)
    endif
    set vl_it=null
endfunction

function zzVL_BagUI takes nothing returns nothing
    local framehandle vl_ui=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local integer vl_i=0
    local real vl_x0
    local real vl_pitch=(zzCF_BAG_W()-.016)/I2R(zzCF_BAG_COLS())
    local real vl_gb
    local real vl_bw
    local trigger vl_t
    local framehandle vl_b
    local framehandle vl_x
    local framehandle vl_tip
    local framehandle vl_tipTxt
    call BlzLoadTOCFile("war3mapImported\\vltk.toc")
    set zzVL_tClick=CreateTrigger()
    call TriggerAddAction(zzVL_tClick,function zzVL_OnFrameClick)
    set zzVL_tItemHoverOn=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOn,function zzVL_ItemHoverOn)
    set zzVL_tItemHoverOff=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOff,function zzVL_ItemHoverOff)
    // khung hành trang: 60 ô chia đều (config.py GAME BAG_*), mọi tọa độ tính từ góc trên-trái và bề rộng
    set vl_gb=zzCF_BAG_Y()-.030-I2R((zzCF_BAG_SLOTS()+zzCF_BAG_COLS()-1)/zzCF_BAG_COLS())*vl_pitch
    set zzVL_fMain=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_TOPLEFT,zzCF_BAG_X(),zzCF_BAG_Y())
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_BOTTOMRIGHT,zzCF_BAG_X()+zzCF_BAG_W(),vl_gb-.092)
    call zzVL_Panel(zzVL_fMain,zzCF_BAG_X()+.003,zzCF_BAG_Y()-.003,zzCF_BAG_X()+zzCF_BAG_W()-.003,vl_gb-.089,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fMain,zzCF_BAG_X()+.012,zzCF_BAG_Y()-.012,zzCF_BAG_W()-.03,"|cffffcc00HÀNH TRANG|r  (phím B)")
    set vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        call zzVL_MakeSlot(vl_i,zzCF_BAG_X()+.008+ModuloInteger(vl_i,zzCF_BAG_COLS())*vl_pitch,zzCF_BAG_Y()-.030-(vl_i/zzCF_BAG_COLS())*vl_pitch,vl_pitch*.9)
        set vl_i=vl_i+1
    endloop
    // 2 hàng nút chia đều đúng bề rộng lưới ô (cols * pitch): hàng 1 = 4 nút, hàng 2 = 3 nút
    set vl_x0=zzCF_BAG_X()+.008
    set vl_bw=I2R(zzCF_BAG_COLS())*vl_pitch
    set zzKT_targetPanel=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzKT_targetPanel,FRAMEPOINT_TOPLEFT,zzCF_BAG_X()+zzCF_BAG_W()+.004,zzCF_BAG_Y())
    call BlzFrameSetSize(zzKT_targetPanel,.172,.285)
    set vl_i=0
    loop
        exitwhen vl_i>9
        set zzKT_targetBtn[vl_i]=BlzCreateFrame("ScriptDialogButton",zzKT_targetPanel,0,0)
        call BlzFrameSetPoint(zzKT_targetBtn[vl_i],FRAMEPOINT_TOPLEFT,zzKT_targetPanel,FRAMEPOINT_TOPLEFT,.008,-.008-vl_i*.026)
        call BlzFrameSetSize(zzKT_targetBtn[vl_i],.156,.023)
        call SaveInteger(zzVL_ht,GetHandleId(zzKT_targetBtn[vl_i]),7,301+vl_i)
        call BlzTriggerRegisterFrameEvent(zzVL_tClick,zzKT_targetBtn[vl_i],FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(zzKT_targetBtn[vl_i],false)
        set vl_i=vl_i+1
    endloop
    call BlzFrameSetVisible(zzKT_targetPanel,false)
    set zzVL_fMode=zzVL_MakeButton(242,zzVL_fMain,vl_x0,vl_gb-.006,(vl_bw-.012)/4.,"Chuyển")
    set zzVL_fSell=zzVL_MakeButton(246,zzVL_fMain,vl_x0+(vl_bw+.004)/4.,vl_gb-.006,(vl_bw-.012)/4.,"Bán")
    set zzVL_fSplit=zzVL_MakeButton(247,zzVL_fMain,vl_x0+(vl_bw+.004)/2.,vl_gb-.006,(vl_bw-.012)/4.,"Tách")
    set zzVL_fKham=zzVL_MakeButton(248,zzVL_fMain,vl_x0+(vl_bw+.004)*.75,vl_gb-.006,(vl_bw-.012)/4.,"Khảm")
    set zzVL_fDrop=zzVL_MakeButton(245,zzVL_fMain,vl_x0,vl_gb-.031,(vl_bw-.008)/3.,"Vứt")
    set zzVL_fAuto=zzVL_MakeButton(249,zzVL_fMain,vl_x0+(vl_bw+.004)/3.,vl_gb-.031,(vl_bw-.008)/3.,"Tự bán")
    call zzVL_MakeButton(243,zzVL_fMain,vl_x0+(vl_bw+.004)*2./3.,vl_gb-.031,(vl_bw-.008)/3.,"Đóng")
    set zzVL_fInfo=zzVL_MakeText(zzVL_fMain,vl_x0+.002,vl_gb-.058,vl_bw,"")
    // chọn đồng đội để chuyển đồ
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerSelectionEventBJ(vl_t,Player(vl_i),true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnAllySelect)
    call BlzFrameSetVisible(zzVL_fMain,false)
    set zzVL_fScore=zzVL_MakeText(vl_ui,.685,.52,.10,"")
    call BlzFrameSetSize(zzVL_fScore,.10,.03)
    call BlzFrameSetTextAlignment(zzVL_fScore,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
    set zzVL_fClock=zzVL_MakeText(vl_ui,.67,.548,.12,"|cffffcc00Thời gian|r 0:00")
    set zzVL_fOpen=zzVL_MakeIconButton(244,vl_ui,.232,.566,.045,"war3mapImported\\vl_ui_bag.blp")
    call zzVL_MakeIconButton(250,vl_ui,.280,.566,.045,"war3mapImported\\vl_ui_hero.blp")
    set vl_b=zzVL_MakeIconButton(251,vl_ui,.328,.566,.045,"ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp")
    set vl_tip=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,71)
    call BlzFrameSetSize(vl_tip,.17,.045)
    set vl_tipTxt=BlzCreateFrameByType("TEXT","",vl_tip,"",0)
    call BlzFrameSetPoint(vl_tipTxt,FRAMEPOINT_TOPLEFT,vl_tip,FRAMEPOINT_TOPLEFT,.008,-.008)
    call BlzFrameSetSize(vl_tipTxt,.154,.03)
    call BlzFrameSetText(vl_tipTxt,"Khinh Công (C)|nLướt tới trước, miễn sát thương. Hồi 4 giây.")
    call BlzFrameSetTooltip(vl_b,vl_tip)
    set zzVL_fHero=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_TOPLEFT,.015,.535)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_BOTTOMRIGHT,.365,.155)
    call zzVL_Panel(zzVL_fHero,.018,.532,.362,.158,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fHero,.085,.520,.20,"|cffffcc00NHÂN VẬT & TRANG BỊ|r  (phím I)")
    set zzVL_fHeroTxt=zzVL_MakeText(zzVL_fHero,.083,.502,.211,"")
    call BlzFrameSetSize(zzVL_fHeroTxt,.211,.33)
    call BlzFrameSetScale(zzVL_fHeroTxt,.88)
    set vl_i=0
    loop
        exitwhen vl_i>4
        set zzVL_fEqBtn[vl_i]=BlzCreateFrameByType("BUTTON","",zzVL_fHero,"",0)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),7,230+vl_i+1)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),8,2)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),9,vl_i)
        call BlzFrameSetSize(zzVL_fEqBtn[vl_i],LoadReal(zzVL_ht,0,472),LoadReal(zzVL_ht,0,472))
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,470),LoadReal(zzVL_ht,0,471)-vl_i*LoadReal(zzVL_ht,0,473))
        set zzVL_fEqIco[vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[vl_i],"",0)
        // icon thụt vào inset mỗi cạnh (config.py mục 16 EQUIP_UI) để nằm gọn giữa khung ô
        call BlzFrameSetPoint(zzVL_fEqIco[vl_i],FRAMEPOINT_TOPLEFT,zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,474),-LoadReal(zzVL_ht,0,474))
        call BlzFrameSetPoint(zzVL_fEqIco[vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[vl_i],FRAMEPOINT_BOTTOMRIGHT,-LoadReal(zzVL_ht,0,474),LoadReal(zzVL_ht,0,474))
        call BlzFrameSetTexture(zzVL_fEqIco[vl_i],"war3mapImported\\vl_eq_"+I2S(vl_i+1)+".blp",0,true)
        set zzVL_fEqTxt[vl_i]=BlzCreateFrameByType("TEXT","",zzVL_fEqBtn[vl_i],"",0)
        call BlzFrameSetPoint(zzVL_fEqTxt[vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[vl_i],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
        call BlzFrameSetTextAlignment(zzVL_fEqTxt[vl_i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
        set zzVL_fEqTT[vl_i]=BlzCreateFrame("BoxedText",zzVL_fEqBtn[vl_i],0,vl_i+20)
        set zzVL_fEqTTxt[vl_i]=BlzGetFrameByName("BoxedTextValue",vl_i+20)
        call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOn,zzVL_fEqBtn[vl_i],FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOff,zzVL_fEqBtn[vl_i],FRAMEEVENT_MOUSE_LEAVE)
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>4
        set zzVL_fEqBtn[5+vl_i]=BlzCreateFrameByType("BUTTON","",zzVL_fHero,"",0)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),7,235+vl_i+1)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),8,2)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),9,5+vl_i)
        call BlzFrameSetSize(zzVL_fEqBtn[5+vl_i],LoadReal(zzVL_ht,0,482),LoadReal(zzVL_ht,0,482))
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[5+vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,480),LoadReal(zzVL_ht,0,481)-vl_i*LoadReal(zzVL_ht,0,483))
        set zzVL_fEqIco[5+vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[5+vl_i],"",0)
        // icon thụt vào inset mỗi cạnh (config.py mục 16 EQUIP_UI) để nằm gọn giữa khung ô
        call BlzFrameSetPoint(zzVL_fEqIco[5+vl_i],FRAMEPOINT_TOPLEFT,zzVL_fEqBtn[5+vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,484),-LoadReal(zzVL_ht,0,484))
        call BlzFrameSetPoint(zzVL_fEqIco[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,-LoadReal(zzVL_ht,0,484),LoadReal(zzVL_ht,0,484))
        call BlzFrameSetTexture(zzVL_fEqIco[5+vl_i],"war3mapImported\\vl_eq_"+I2S(6+vl_i)+".blp",0,true)
        set zzVL_fEqTxt[5+vl_i]=BlzCreateFrameByType("TEXT","",zzVL_fEqBtn[5+vl_i],"",0)
        call BlzFrameSetPoint(zzVL_fEqTxt[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
        call BlzFrameSetTextAlignment(zzVL_fEqTxt[5+vl_i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
        set zzVL_fEqTT[5+vl_i]=BlzCreateFrame("BoxedText",zzVL_fEqBtn[5+vl_i],0,vl_i+25)
        set zzVL_fEqTTxt[5+vl_i]=BlzGetFrameByName("BoxedTextValue",vl_i+25)
        call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOn,zzVL_fEqBtn[5+vl_i],FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOff,zzVL_fEqBtn[5+vl_i],FRAMEEVENT_MOUSE_LEAVE)
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        set zzVL_fPassBtn[vl_i]=BlzCreateFrameByType("GLUEBUTTON","",zzVL_fHero,"ScoreScreenTabButtonTemplate",0)
        call BlzFrameSetSize(zzVL_fPassBtn[vl_i],.026,.026)
        call BlzFrameSetAbsPoint(zzVL_fPassBtn[vl_i],FRAMEPOINT_BOTTOMLEFT,.085+vl_i*.033,.165)
        set zzVL_fPassIco[vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fPassBtn[vl_i],"",0)
        call BlzFrameSetAllPoints(zzVL_fPassIco[vl_i],zzVL_fPassBtn[vl_i])
        set zzVL_fPassTT[vl_i]=BlzCreateFrame("BoxedText",zzVL_fPassBtn[vl_i],0,vl_i+10)
        set zzVL_fPassTTxt[vl_i]=BlzGetFrameByName("BoxedTextValue",vl_i+10)
        call BlzFrameSetVisible(zzVL_fPassBtn[vl_i],false)
        set vl_i=vl_i+1
    endloop
    // the hover tooltip is a shared box shown by the mouse enter / leave events of the icons (BlzFrameSetTooltip showed nothing here)
    set zzVL_fPassTip=BlzCreateFrame("EscMenuBackdrop",zzVL_fHero,0,61)
    call BlzFrameSetAbsPoint(zzVL_fPassTip,FRAMEPOINT_BOTTOMLEFT,.06,.21)
    call BlzFrameSetSize(zzVL_fPassTip,.34,.15)
    set zzVL_fPassTipTxt=BlzCreateFrameByType("TEXT","",zzVL_fPassTip,"",0)
    call BlzFrameSetPoint(zzVL_fPassTipTxt,FRAMEPOINT_TOPLEFT,zzVL_fPassTip,FRAMEPOINT_TOPLEFT,.012,-.012)
    call BlzFrameSetSize(zzVL_fPassTipTxt,.316,.126)
    call BlzFrameSetVisible(zzVL_fPassTip,false)
    set zzVL_fItemHover=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,62)
    call BlzFrameSetAbsPoint(zzVL_fItemHover,FRAMEPOINT_TOPLEFT,.39,.57)
    call BlzFrameSetSize(zzVL_fItemHover,.34,.235)
    set zzVL_fItemHoverTxt=BlzCreateFrameByType("TEXT","",zzVL_fItemHover,"",0)
    call BlzFrameSetPoint(zzVL_fItemHoverTxt,FRAMEPOINT_TOPLEFT,zzVL_fItemHover,FRAMEPOINT_TOPLEFT,.012,-.012)
    call BlzFrameSetSize(zzVL_fItemHoverTxt,.316,.211)
    call BlzFrameSetTextAlignment(zzVL_fItemHoverTxt,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(zzVL_fItemHoverTxt,.82)
    call BlzFrameSetVisible(zzVL_fItemHover,false)
    call BlzFrameSetEnable(zzVL_fItemHover,false)
    call BlzFrameSetEnable(zzVL_fItemHoverTxt,false)
    // the + beside each equipment slot (left column: right of the slot, right column: left of the slot): enhance +1.
    // Big enough to hit (.028 square) and raised above the panel so nothing covers it.
    set vl_i=0
    loop
        exitwhen vl_i>9
        set vl_b=BlzCreateFrameByType("GLUEBUTTON","",zzVL_fHero,"ScoreScreenTabButtonTemplate",0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,100+vl_i+1)
        call BlzFrameSetSize(vl_b,.028,.028)
        if vl_i<5 then
            call BlzFrameSetPoint(vl_b,FRAMEPOINT_TOPLEFT,zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPRIGHT,.004,.002) // đi theo ô (config mục 16)
        else
            call BlzFrameSetPoint(vl_b,FRAMEPOINT_TOPRIGHT,zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,-.001,.002) // đi theo ô (config mục 16)
        endif
        call BlzFrameSetLevel(vl_b,8)
        set vl_x=BlzCreateFrameByType("TEXT","",vl_b,"",0)
        call BlzFrameSetAllPoints(vl_x,vl_b)
        call BlzFrameSetTextAlignment(vl_x,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(vl_x,1.8)
        call BlzFrameSetEnable(vl_x,false)
        call BlzFrameSetText(vl_x,"|cffffcc00+|r")
        call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        set vl_t=CreateTrigger()
        call BlzTriggerRegisterFrameEvent(vl_t,zzVL_fPassBtn[vl_i],FRAMEEVENT_MOUSE_ENTER)
        call TriggerAddAction(vl_t,function zzVL_PassTipOn)
        set vl_t=CreateTrigger()
        call BlzTriggerRegisterFrameEvent(vl_t,zzVL_fPassBtn[vl_i],FRAMEEVENT_MOUSE_LEAVE)
        call TriggerAddAction(vl_t,function zzVL_PassTipOff)
        set vl_i=vl_i+1
    endloop
    call BlzFrameSetVisible(zzVL_fHero,false)
    call zzVL_Panel(vl_ui,.66,.552,.79,.528,"war3mapImported\\vl_ui_tile.blp",200)
    call zzVL_Panel(vl_ui,.68,.524,.79,.484,"war3mapImported\\vl_ui_tile.blp",200)
    set zzVL_fBannerBg=zzVL_Panel(vl_ui,.2,.47,.6,.43,"war3mapImported\\vl_ui_tile.blp",220)
    set zzVL_fBanner=BlzCreateFrameByType("TEXT","",zzVL_fBannerBg,"",0)
    call BlzFrameSetAllPoints(zzVL_fBanner,zzVL_fBannerBg)
    call BlzFrameSetTextAlignment(zzVL_fBanner,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(zzVL_fBanner,1.4)
    call BlzFrameSetVisible(zzVL_fBannerBg,false)
    set zzVL_bannerT=CreateTimer()
    call DestroyTimer(GetExpiredTimer())
    set vl_ui=null
endfunction

// ==========================================
// Hàm: zzVL_OnBagChat
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnBagChat takes nothing returns nothing
    call zzVL_OnBagKey()
endfunction
// ---- -tt: what the player has

// ==========================================
// Hàm: zzVL_OnChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnChat takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_he=zzVL_he[vl_playerId]
    local integer vl_r=zzVL_rank[vl_playerId]
    local string vl_string
    if Jx[vl_playerId+1]==null then
        call zzVL_Msg(vl_playerId,"Chưa chọn tướng.")
        return
    endif
    set vl_string="|cffffcc00== Thông tin ==|r|nHệ: "+zzVL_hn[vl_he]
    if vl_he>0 then
        set vl_string=vl_string+" (khắc "+zzVL_hn[ModuloInteger(vl_he,5)+1]+", bị "+zzVL_hn[ModuloInteger(vl_he+3,5)+1]+" khắc)"
    endif
    if zzVL_set[vl_playerId]>0 then
        set vl_string=vl_string+"|nBộ trang bị: cấp "+I2S(zzVL_set[vl_playerId])+"/5 - "+zzVL_SetText(vl_he,zzVL_set[vl_playerId])
    else
        set vl_string=vl_string+"|nBộ trang bị: chưa đủ 10 món"
    endif
    set vl_string=vl_string+"|nCông trạng: "+I2S(zzVL_ct[vl_playerId])+" - quan ấn "+zzVL_QAName(vl_r)+" (+"+I2S(R2I(zzCF_QUAN_HAM_SAT_THUONG()*100.*vl_r))+"% sát thương), phi phong bậc "+I2S(zzVL_cl[vl_playerId])+"/"+I2S(zzVL_PPMax())
    if vl_r<zzVL_QAMax() then
        set vl_string=vl_string+"|nQuan ấn kế: "+zzVL_QAName(vl_r+1)+" cần "+I2S(zzVL_QAReq(vl_r+1))
    endif
    if zzVL_cl[vl_playerId]<zzVL_PPMax() then
        set vl_string=vl_string+"|nPhi phong kế: "+zzVL_PPName(zzVL_cl[vl_playerId]+1)+" cần "+I2S(zzVL_PPReq(zzVL_cl[vl_playerId]+1))
    endif
    call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,20.,vl_string)
endfunction

// ==========================================
// Hàm: zzVL_Hello
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Hello takes nothing returns nothing
    call zzVL_All("|cffffcc00Võ Lâm Truyền Kỳ 1.31|r: có thêm |cff00ccffbộ trang bị theo hệ|r, |cff00ccffngũ hành cho đánh thường|r, |cff00ccffquân hàm và phi phong|r, |cff00ccffcao thủ xuất hiện ngẫu nhiên|r, |cff00ccffnhiệm vụ của Sứ Giả Võ Lâm|r (bấm chọn ông ấy cạnh căn cứ). Chiêu hồi nhanh |cff00ccfftự thi triển|r khi giao chiến (-auto bật/tắt). Gõ |cffffcc00-tt|r (bản thân), |cffffcc00-gd|r (sự kiện), F9 để đọc hướng dẫn.")
endfunction

// ==========================================
// Hàm: zzVL_OnFastBuy
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnFastBuy takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local unit hero = Jx[pid+1]
    local string msg = GetEventPlayerChatString()
    local string cmd = SubString(msg, 0, 4)
    local integer amount = S2I(SubString(msg, 4, StringLength(msg)))
    local integer cost = amount
    local integer current_knb = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
    if hero == null then
        call zzVL_Msg(pid, "Chưa chọn tướng.")
        return
    endif
    if amount <= 0 then
        return
    endif
    if current_knb < cost then
        call zzVL_Msg(pid, "Không đủ " + I2S(cost) + " KNB.")
        return
    endif
    call SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, current_knb - cost)
    if cmd == "-sm " then
        call SetHeroStr(hero, GetHeroStr(hero, false) + amount, true)
        call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Sức mạnh.")
    elseif cmd == "-tp " then
        call SetHeroAgi(hero, GetHeroAgi(hero, false) + amount, true)
        call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Thân pháp.")
    elseif cmd == "-tt " then
        call SetHeroInt(hero, GetHeroInt(hero, false) + amount, true)
        call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Nội công / Trí tuệ.")
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnGmCheat
// Lệnh GM / Test: -lvl [cấp], -maxlvl, -rex, -gold [số], -knb [số]
function zzVL_OnGmCheat takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local unit hero = Jx[pid+1]
    local string msg = GetEventPlayerChatString()
    local integer lvl = 200
    local integer gold = 100000
    local integer knb = 1000
    local integer len = StringLength(msg)

    if hero == null then
        call zzVL_Msg(pid, "Chưa chọn tướng.")
        return
    endif

    if msg == "-lvl" or msg == "-maxlvl" or msg == "-rex" then
        call SetHeroLevel(hero, 200, true)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Đã nâng cấp tướng lên cấp tối đa (200)!")
    elseif len >= 5 and SubString(msg, 0, 5) == "-lvl " then
        set lvl = S2I(SubString(msg, 5, len))
        if lvl <= 0 then
            set lvl = 200
        elseif lvl > 200 then
            set lvl = 200
        endif
        call SetHeroLevel(hero, lvl, true)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Đã đặt cấp độ tướng thành: " + I2S(lvl) + "!")
    elseif msg == "-gold" then
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + 100000)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Nhận thêm 100,000 ngân lượng!")
    elseif len >= 6 and SubString(msg, 0, 6) == "-gold " then
        set gold = S2I(SubString(msg, 6, len))
        if gold <= 0 then
            set gold = 100000
        endif
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + gold)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Nhận thêm " + I2S(gold) + " ngân lượng!")
    elseif msg == "-knb" then
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + 1000)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Nhận thêm 1,000 Kim Nguyên Bảo!")
    elseif len >= 5 and SubString(msg, 0, 5) == "-knb " then
        set knb = S2I(SubString(msg, 5, len))
        if knb <= 0 then
            set knb = 1000
        endif
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + knb)
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Nhận thêm " + I2S(knb) + " Kim Nguyên Bảo!")
    elseif msg == "-fullcuong" then
        set lvl = 0
        loop
            exitwhen lvl >= 10
            set zzVL_cuong[pid*10 + lvl] = 10
            set lvl = lvl + 1
        endloop
        call zzEQ_GmFull(pid)
        call zzVL_AffixSum(pid)
        if zzVL_heroOpen[pid] then
            call zzVL_HeroShow(pid, true)
        endif
        call zzVL_Msg(pid, "|cff00ff00[GM]|r Đã cường hóa tối đa +10 cho toàn bộ 10 ô trang bị!")
    elseif msg == "-fullht" then
        call SaveInteger(zzVL_ht,6200+pid,2,1000000000)
        if zzVL_heroOpen[pid] then
            call zzVL_HeroShow(pid,true)
        endif
        call zzVL_Msg(pid,"|cff00ff00[GM]|r Đã đặt Huyền Tinh thành 1.000.000.000 điểm để kiểm thử.")
    elseif len >= 7 and SubString(msg, 0, 7) == "-cuong " then
        set lvl = S2I(SubString(msg, 7, len))
        if lvl >= 1 and lvl <= 10 then
            if zzEQ_EnhanceSlot(pid, lvl - 1) then
                call zzVL_AffixSum(pid)
            else
                call zzVL_CuongSlot(hero, lvl - 1)
            endif
            if zzVL_heroOpen[pid] then
                call zzVL_HeroShow(pid, true)
            endif
        else
            call zzVL_Msg(pid, "|cffffcc00[Cú pháp]|r -cuong <1-10> (1: Nón, 2: Áo, 3: Yêu Đái, 4: Hộ Uyển, 5: Hài, 6: Vũ Khí, 7: Hạng Liên, 8: Giới Chỉ, 9: Ngọc Bội, 10: Hộ Thân Phù)")
        endif
    endif
endfunction

// ==========================================
// Hàm: zzVL_Quest
// Chức năng dự kiến: Hệ thống nhiệm vụ (Sứ Giả Võ Lâm).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Quest takes nothing returns nothing
    local quest vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Hệ thống mới (1.31)")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Bộ trang bị|r: đủ 10 món (mũ, áo, yêu đái, hộ uyển, hài, vũ khí, hạng liên, giới chỉ, ngọc bội, hộ thân phù). Cấp bộ = món thấp nhất: +0 cấp 1, +1..+3 cấp 2, +4..+6 cấp 3, +7..+9 cấp 4, +10 cấp 5. Kim +5% sát thương/cấp và 2%/cấp làm choáng, Mộc hút 3%/cấp và gây độc, Thổ giảm 4% sát thương nhận/cấp, phản 2%/cấp và miễn choáng/chậm ngũ hành, Thủy hồi 0.5% sinh lực/giây/cấp và làm chậm 5%/cấp, Hỏa 4%/cấp gây gấp đôi kèm thiêu đốt (giảm 50% hồi máu).|n|cffffcc00Ngũ hành|r: đánh thường vào hệ bị khắc +20%.|n|cffffcc00Quân hàm|r: hạ tướng +10, hỗ trợ +4, hạ trùm +15, bị quái hạ -3. Mỗi bậc +2% sát thương và tự động nâng cấp chỉ số phi phong ẩn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Hành trang và nhiệm vụ")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: bấm phím B (hoặc nút Hành Trang, gõ -hd). Túi tướng là 6 ô trang bị: mũ, áo, vũ khí, giày, phi phong, ô dùng nhanh (thuốc, Huyền tinh). Đồ khác nằm trong hành trang 30 ô, bấm để mặc. Chế đồ: bật Gửi Thủ Khố rồi bấm nguyên liệu.|n|cffffcc00Nhiệm vụ|r: đưa tướng tới gần Sứ Giả Võ Lâm (cạnh căn cứ) rồi bấm chọn ông ấy. Xong được Huyền tinh, ngân lượng, công trạng; cứ 5 nhiệm vụ thêm 2 Huyền tinh. Gõ -nv để xem.|n|cffffcc00Đánh quái|r: cả phe cùng nhận vàng, đồng đội ở xa cũng nhận kinh nghiệm, không cần đánh phát cuối.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Phi phong và cao thủ (1.31)")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNCloak.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Phi phong|r (15 bậc: Siêu Phàm ... Thần Thoại) và |cffffcc00Quan ấn|r (8 bậc: Trí Sự ... Hoàng Đế) lên bậc theo công trạng; phi phong cộng sinh lực, phòng thủ, thuộc tính và hiện danh hiệu trên đầu, quan ấn cộng sát thương. Gõ -tt để xem mốc kế tiếp.|n|cffffcc00Tuyệt đại cao thủ|r: cứ 7 phút xuất hiện một lần ở khu quái (có chấm trên bản đồ nhỏ). Hạ được: 2 Huyền tinh, 1000 ngân lượng (đồng đội 300), 25 công trạng.|n|cffffcc00Võ Lâm Minh Chủ|r: cứ 18 phút xuất hiện một lần (nếu Minh Chủ trước đã bị hạ). Phe hạ được +10 uy danh, mỗi người 1000 ngân lượng.|n|cffffcc00Hạ tướng|r: mỗi lần +300 ngân lượng. |cffffcc00Nhất đao đoạt mạng|r: hạ tướng đầu tiên của trận thêm 500 ngân lượng, 10 công trạng.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Trấn phái, rơi đồ, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNSpell_ThuanDuongVoCuc.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Tuyệt học trấn phái|r: tướng cấp 75 lĩnh ngộ kỹ năng thứ 5 của môn phái, mỗi 25 cấp tướng lên một cấp (tối đa 5). Võ Đang Thuần Dương Vô Cực Công, Thiên Vương Duy Ngã Độc Tôn, Côn Luân Vô Nhân Vô Ngã, Thiếu Lâm Kim Chung Tráo, Nga My Cửu Âm Chân Kinh, Cái Bang Hàng Long Thập Bát Chưởng, Ngũ Độc Cửu Âm Bạch Cốt Trảo, Đường Môn Bạo Vũ Lê Hoa Châm, Thúy Yên Băng Tâm Tiên Tử, Thiên Nhẫn Thiên Ma Giải Thể, Đại Lý Cửu Dương Thần Công.|n|cffffcc00Rơi đồ|r: mỗi món trang bị chỉ rơi 5 lần mỗi trận, sau đó rơi món khác. Nguyên liệu rơi không giới hạn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Cường hóa, khảm, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNInventory.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: nguyên liệu cùng loại tự cộng dồn. Bật Tách rồi bấm để chia đôi, bật Bán rồi bấm để bán ngay. |cffffcc00Cường hóa|r: nhặt Huyền Tinh, mở Nhân Vật bằng C rồi bấm nút + cạnh ô đồ. Tối đa +10; thất bại không tụt cấp và bảo hiểm tính riêng từng món. Bật Khảm, bấm nguyên liệu rồi bấm trang bị: mỗi trang bị 2 lỗ.")
    set vl_q=null
endfunction
// ---- tien khoi dau: moi nguoi choi 1000 vang

// ==========================================
// Hàm: zzVL_StartGold
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_StartGold takes nothing returns nothing
    local integer vl_i=0
    loop
        exitwhen vl_i>9
        call SetPlayerState(Player(vl_i),PLAYER_STATE_RESOURCE_GOLD,1000)
        call SetCameraFieldForPlayer(Player(vl_i),CAMERA_FIELD_TARGET_DISTANCE,2800.,0.)
        set vl_i=vl_i+1
    endloop
    call DestroyTimer(GetExpiredTimer())
endfunction

// ==========================================
// Hàm: zzVL_Music
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Music takes nothing returns nothing
    call SetMusicVolume(127)
    call ClearMapMusic()
    call SetMapMusic("war3mapImported\\vl_nhacnen.mp3",true,0)
    call PlayMusic("war3mapImported\\vl_nhacnen.mp3")
    call zzVL_Log("nhac: PlayMusic")
    call DestroyTimer(GetExpiredTimer())
endfunction

// ==========================================
// Hàm: zzVL_OnTabKey
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnTabKey takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call ClearTextMessages()
    endif
endfunction

function zzVL_OnKinhCongKey takes nothing returns nothing
    call zzVL_KinhCong(GetPlayerId(GetTriggerPlayer()))
endfunction

// ==========================================
// Hàm: zzVL_Init
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Init takes nothing returns nothing
    local trigger vl_t
    local integer vl_i=0
    set zzVL_ht=InitHashtable()
    set vl_i=0
    loop
        exitwhen vl_i>9
        set zzKT_target[vl_i]=-1
        set vl_i=vl_i+1
    endloop
    call zzVL_Items()
    call zzKT_Init()
    call TimerStart(CreateTimer(),3.,false,function zzVL_Music)
    call ExecuteFunc("zzKS_Init")
    call ExecuteFunc("zzUI_Setup")
    call zzVL_KhamInit()
    call ExecuteFunc("zzGS_Init")
    call ExecuteFunc("zzKTC_Init")
    call ExecuteFunc("zzSH_Init")
    call ExecuteFunc("zzTL_Init")
    set zzVL_hn[0]="Chưa có"
    set zzVL_hn[1]="|cffffd700Kim|r"
    set zzVL_hn[2]="|cff40c040Mộc|r"
    set zzVL_hn[3]="|cffc08040Thổ|r"
    set zzVL_hn[4]="|cff4080ffThủy|r"
    set zzVL_hn[5]="|cffff4040Hỏa|r"
    set zzVL_bn[1]="Thiếu Lâm Thần Tăng" // Kim
    set zzVL_bn[2]="Ngũ Độc Giáo Chủ"    // Mộc
    set zzVL_bn[3]="Nga My Sư Thái"      // Thủy
    set zzVL_bn[4]="Cái Bang Bang Chủ"   // Hỏa
    set zzVL_bn[5]="Võ Đang Chân Nhân"   // Thổ
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_DAMAGED)
    call TriggerAddAction(vl_t,function zzVL_OnDamage)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(vl_t,function zzVL_OnDeath)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(vl_t,function zzVL_OnTpCast)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzVL_OnCraftBuy)
    call TriggerAddAction(vl_t,function zzKT_OnBuy)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(vl_t,function zzVL_OnItem)
    set vl_t=CreateTrigger()
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-tt",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnWinChat)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-sm ",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-tp ",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-tt ",false)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnFastBuy)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-lvl",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-maxlvl",true)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-rex",true)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-gold",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-knb",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-cuong",false)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-fullcuong",true)
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-fullht",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnGmCheat)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_M,0,true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_XpKey)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-win ",false)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnChat)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-gd",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnEventChat)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-auto",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnAutoChat)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerSelectionEventBJ(vl_t,Player(vl_i),true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnSelect)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-nv",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnQuestChat)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddAction(vl_t,function zzVL_OnAttack)
    call TimerStart(CreateTimer(),.1,false,function zzVL_BagUI)
    call zzVL_FarmInit()
    call TimerStart(CreateTimer(),.5,true,function zzVL_BagTick)
    call TimerStart(CreateTimer(),.15,true,function zzVL_WantTick)
    set zzVL_lootR=Rect(0.,0.,1.,1.)
    call TimerStart(CreateTimer(),.2,true,function zzVL_AutoLoot)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddAction(vl_t,function zzVL_OnItemOrder)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(vl_t,function zzVL_OnBagPickup)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_B,0,true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnBagKey)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_C,0,true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnKinhCongKey)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_TAB,0,true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnTabKey)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_I,0,true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnHeroKey)
    call TimerStart(CreateTimer(),1.,true,function zzVL_HeroTick)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-hd",true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnBagChat)
    call TimerStart(CreateTimer(),.35,true,function zzVL_AutoTick)
    call TimerStart(CreateTimer(),.5,true,function zzVL_AiFight)
    call TimerStart(CreateTimer(),20.,true,function zzVL_AiBossTick)
    set zzVL_clock=CreateTimer()
    call TimerStart(zzVL_clock,99999.,false,null)
    call TimerStart(CreateTimer(),0.,false,function zzVL_StartGold)
    call TimerStart(CreateTimer(),1.,true,function zzVL_Tick)
    call TimerStart(CreateTimer(),.04,true,function zzVL_TagTick)
    call TimerStart(CreateTimer(),20.,false,function zzVL_Hello)
    call TimerStart(CreateTimer(),1.,true,function zzVL_EventTick)
    call TimerStart(CreateTimer(),2.,true,function zzVL_LogFlush)
    call zzVL_Quest()
    set vl_t=null
endfunction
// ===== end gameplay 1.31 =====
