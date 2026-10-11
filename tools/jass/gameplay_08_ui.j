// ---- Hanh Trang (custom bag, players only; the computer AI keeps the normal inventory)
// Hero inventory = equipment: 0 hat, 1 armor, 2 weapon, 3 boots, 4 cloak, 5 quick (potions, Thuy tinh...).
// Bag: 60 hidden items per player (zzVL_bag[pid*zzCF_BAG_SLOTS()+i]). Panel (key B, button, -hd): equipment row (click =
// take off), 60 bag slots (click = wear / put in the quick slot, or send to the Thu Kho in send mode), the
// Thu Kho row (click = take back into the bag), send-mode and close buttons, info line.
// Frame codes (zzVL_ht key 7 of the frame handle id, stored +1): 0..59 bag, 60..65 equip, 66..71 Thu Kho,
// 42 send mode, 43 close, 44 open button.

// Tra vị trí trang bị (0-9) tương ứng với một loại vật phẩm: ưu tiên bảng ánh xạ KVCT dùng chung (zzEQ_Slot),
// rồi mới tới cờ loại đồ cũ của map (khóa hashtable /10); trả -1 nếu không phải trang bị mặc được.
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

// true nếu đây là người chơi (không phải máy) đang điều khiển một tướng và dùng được hệ thống hành trang tùy biến.
function zzVL_IsBagUser takes integer vl_playerId returns boolean
    return vl_playerId>=0 and vl_playerId<=9 and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER and Jx[vl_playerId+1]!=null
endfunction

// Đặt một vật phẩm vào ô túi trống đầu tiên (không gộp số lượng); nếu vật phẩm đã nằm sẵn trong túi/trang bị thì
// coi như thành công luôn, túi đầy thì đưa vào danh sách theo dõi đồ rơi dưới đất (zzDR_TrackItem).
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
    call zzDR_TrackItem(vl_item)
    return false
endfunction

// Thêm một vật phẩm vào hành trang: vật liệu/đồ dùng cùng loại được cộng dồn số lượng vào ô đã có, trang bị luôn
// chiếm một ô riêng (không gộp x2); cuối cùng gọi zzVL_BagPut để tìm ô trống nếu không gộp được.
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

// AutoGear calls this wrapper through ExecuteFunc (module 02 is assembled before the bag module).
// Socketed old gear goes directly into the 60-slot bag when possible; only a full bag leaves it on the ground.
function zzVL_StoreAutoGear takes nothing returns nothing
    local integer vl_pid=0
    local item vl_item
    local unit vl_hero
    loop
        exitwhen vl_pid>9
        set vl_item=LoadItemHandle(zzVL_ht,8800+vl_pid,0)
        if vl_item!=null then
            call RemoveSavedHandle(zzVL_ht,8800+vl_pid,0)
            if not zzVL_BagAdd(vl_pid,vl_item) then
                set vl_hero=Jx[vl_pid+1]
                call SetItemVisible(vl_item,true)
                if vl_hero!=null then
                    call SetItemPosition(vl_item,GetUnitX(vl_hero)+GetRandomReal(-80.,80.),GetUnitY(vl_hero)+GetRandomReal(-80.,80.))
                endif
                call zzDR_TrackItem(vl_item)
            endif
            set vl_hero=null
            set vl_item=null
            return
        endif
        set vl_pid=vl_pid+1
    endloop
    set vl_hero=null
    set vl_item=null
endfunction

// Chuyển một vật phẩm từ 6 ô hiện vật (Warcraft) của tướng/Thủ Khố sang 60 ô hành trang tùy biến; báo cho người
// chơi nếu hành trang đã đầy (vật phẩm vẫn ở trong 6 ô gốc).
function zzVL_ToBag takes integer vl_playerId,unit vl_unit,item vl_item returns nothing
    call UnitRemoveItem(vl_unit,vl_item)
    if not zzVL_BagAdd(vl_playerId,vl_item) then
        call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy ("+I2S(zzCF_BAG_SLOTS())+" ô), đồ được để dưới chân tướng.|r")
    endif
endfunction

// Dọn 6 ô hiện vật gốc của tướng mỗi khi mở hành trang: mọi vật phẩm (trừ power-up tự kích hoạt) được chuyển hết
// vào 60 ô hành trang, không để lẫn trong ô Warcraft gốc.
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
            // Túi 60 ô là sức chứa thật cho mọi đồ không được dùng tự động. Thuốc/đồ dùng nhanh
            // vẫn có thể đưa ra ô nhanh bằng chuột phải từ túi; không để chúng mắc kẹt trong 6 ô ẩn.
            call zzIT_Set(GetHandleId(vl_item),zzIT_DA_VUT(),0)
            call zzVL_ToBag(vl_playerId,vl_hero,vl_item)
        endif
        set vl_k=vl_k+1
    endloop
    set vl_hero=null
    set vl_item=null
endfunction

// Dựng chuỗi tooltip hiển thị khi rê chuột vào một vật phẩm: tên (+số lượng), tự sinh mô tả nếu trang bị KVCT
// chưa được mô tả lần nào, rồi ghép thêm phần mô tả mở rộng có sẵn.
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
    set vl_gemN=zzIT_Get(GetHandleId(vl_item),zzIT_SO_LO_KHAM())
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

// Khi rê chuột vào một ô (hành trang/trang bị/Thủ Khố): hiện khung tooltip tự vẽ với mô tả vật phẩm; nếu là ô
// hành trang có trang bị khác với món đang mặc cùng vị trí thì hiện thêm khung so sánh (zzVL_ItemCompare) bên trái.
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
    local string vl_tip2=""
    local real vl_h
    local real vl_h2=0.
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
                    // so sánh 2 khung: khung trái = món đang mặc cùng ô, khung phải = món trong hành trang
                    if vl_worn!=null then
                        set vl_tip2="|cffffcc00[ ĐANG MẶC ]|r|n"+zzVL_ItemTip(vl_worn)
                    else
                        set vl_tip2="|cffffcc00[ ĐANG MẶC ]|r|n|cff808080Ô này chưa mặc trang bị.|r"
                    endif
                    set vl_h2=zzVL_TextLines(vl_tip2)*zzCF_TIP_LINE_H()+.024
                    if vl_h2>.52 then
                        set vl_h2=.52
                    endif
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
            if vl_tip2!="" then
                call BlzFrameSetText(zzVL_fItemHover2Txt,vl_tip2)
                call BlzFrameSetSize(zzVL_fItemHover2,zzCF_TIP_WIDTH(),vl_h2)
                call BlzFrameSetSize(zzVL_fItemHover2Txt,zzCF_TIP_WIDTH()-.024,vl_h2-.024)
            endif
            call BlzFrameSetVisible(zzVL_fItemHover2,vl_tip2!="")
        endif
    endif
    set vl_item=null
    set vl_worn=null
    set vl_player=null
    set vl_frame=null
endfunction

// Rời chuột khỏi ô: ẩn cả hai khung tooltip tự vẽ.
function zzVL_ItemHoverOff takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call BlzFrameSetVisible(zzVL_fItemHover,false)
        call BlzFrameSetVisible(zzVL_fItemHover2,false)
    endif
endfunction

// Khung phẩm chất ô đồ: một BACKDROP zzVL_fQE[code] phủ ô, texture bo góc tools/qbframe.py (giữa trong suốt, icon không bị che)
// màu theo phẩm chất: 1 trắng Thường, 2 xanh Tốt, 3 tím Tuyệt, 4 vàng Huyền thoại (khớp màu tên trang bị)
function zzVL_QBSet takes integer vl_code,integer vl_q returns nothing
    if vl_q<1 then
        call BlzFrameSetVisible(zzVL_fQE[vl_code],false)
        return
    endif
    if vl_q>4 then
        set vl_q=4
    endif
    call BlzFrameSetTexture(zzVL_fQE[vl_code],"VLTK_data\\Textures\\UI\\zzQB"+I2S(vl_q)+".blp",0,true)
    call BlzFrameSetVisible(zzVL_fQE[vl_code],true)
endfunction

// Vẽ icon, tooltip, số lượng và khung phẩm chất của MỘT ô hành trang/trang bị theo vật phẩm đang có (null = ô trống).
function zzVL_SetSlot takes integer vl_playerId,integer vl_code,item vl_item returns nothing
    local string vl_tex="UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"
    local string vl_tip=zzVL_ItemTip(vl_item)
    local string vl_c=""
    local integer vl_q=0
    if vl_item!=null then
        set vl_q=zzIT_Get(GetHandleId(vl_item),zzIT_PHAM_CHAT())
        set vl_tex=BlzGetItemIconPath(vl_item)
        if GetItemCharges(vl_item)>1 then
            set vl_c="|cffffffff"+I2S(GetItemCharges(vl_item))+"|r"
        endif
    endif
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetTexture(zzVL_fIco[vl_code],vl_tex,0,true)
        call BlzFrameSetText(zzVL_fTip[vl_code],vl_tip)
        call BlzFrameSetText(zzVL_fCnt[vl_code],vl_c)
        // khung theo phẩm chất, cùng màu tên trang bị (chỉ trang bị)
        if zzEQ_IsGear(GetItemTypeId(vl_item)) then
            call zzVL_QBSet(vl_code,vl_q)
        else
            call zzVL_QBSet(vl_code,0)
        endif
    endif
endfunction

// Tô chữ nút xanh lá khi chế độ tương ứng (Bán/Tách/Khảm/Vứt/Chuyển/Tự bán) đang bật, để người chơi biết đang ở chế độ nào.
function zzVL_BtnText takes string vl_s,boolean vl_on returns string
    if vl_on then
        return "|cff00ff00"+vl_s+"|r"
    endif
    return vl_s
endfunction
// Vẽ một hàng ô hành trang; zzVL_Refresh gọi hàm này qua ExecuteFunc cho từng hàng để tránh giới hạn số lệnh
// một luồng (vẽ hết 60 ô cùng lúc sẽ bị cắt, các ô sau khoảng ô thứ 30 không hiện).
function zzVL_RefreshRow takes nothing returns nothing
    local integer vl_end=IMinBJ(zzCF_BAG_SLOTS(),zzVL_rowI+zzCF_BAG_COLS())
    loop
        exitwhen zzVL_rowI>=vl_end
        call zzVL_SetSlot(zzVL_rowP,zzVL_rowI,zzVL_bag[zzVL_rowP*zzCF_BAG_SLOTS()+zzVL_rowI])
        set zzVL_rowI=zzVL_rowI+1
    endloop
endfunction
// Vẽ lại toàn bộ bảng Hành Trang đang mở của một người chơi: dọn vật phẩm đang mặc khỏi danh sách túi, vẽ từng
// hàng ô, cập nhật vàng/bộ trang bị/quan ấn và trạng thái bật-tắt của các nút chế độ cùng bảng chọn người nhận.
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
    // vẽ ô theo từng hàng trong luồng riêng (ExecuteFunc): 60 ô x mô tả món vượt giới hạn lệnh một luồng, các ô sau ô ~30 không hiện
    set zzVL_rowP=vl_playerId
    set vl_i=0
    loop
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set zzVL_rowI=vl_i
        call ExecuteFunc("zzVL_RefreshRow")
        set vl_i=vl_i+zzCF_BAG_COLS()
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
        // Hiện trạng thái ngay trên nút để thao tác bật/tắt được nhận biết rõ.
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
            if vl_i!=vl_playerId and IsPlayerAlly(Player(vl_playerId),Player(vl_i)) and Jx[vl_i+1]!=null and GetWidgetLife(Jx[vl_i+1])>.405 and zzVL_IsBagUser(vl_i) then
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

// Bật/tắt hiển thị bảng Hành Trang; mở thì vẽ lại toàn bộ (zzVL_Refresh), đóng thì ẩn luôn bảng chọn người nhận chuyển đồ.
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

// Chạy từ timer 0 giây sau khi tướng người chơi nhặt đồ: dọn 6 ô hiện vật gốc (zzVL_Sort) cho người chơi vừa có
// yêu cầu, rồi vẽ lại bảng nếu đang mở.
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

// Sự kiện nhặt đồ của tướng người chơi: đánh dấu cần dọn ô hiện vật gốc rồi hẹn giờ 0 giây gọi zzVL_SortAll (không
// dọn ngay để tránh xung đột với các callback nhặt đồ khác chạy cùng lúc).
function zzVL_OnBagPickup takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if zzVL_IsBagUser(vl_playerId) and GetTriggerUnit()==Jx[vl_playerId+1] then
        set zzVL_sortReq[vl_playerId]=true
        call TimerStart(CreateTimer(),0.,false,function zzVL_SortAll)
    endif
endfunction

// Crafting can consume ingredients from either the 60-slot bag or the six temporary quick-use slots.
function zzVL_CraftHas takes unit vl_unit,integer vl_type returns boolean
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_unit))
    local integer vl_i=0
    local item vl_item
    loop
        exitwhen vl_i>=6
        set vl_item=UnitItemInSlot(vl_unit,vl_i)
        if vl_item!=null and GetItemTypeId(vl_item)==vl_type then
            set vl_item=null
            return true
        endif
        set vl_i=vl_i+1
    endloop
    if vl_unit==Jx[vl_pid+1] and vl_pid>=0 and vl_pid<=9 then
        set vl_i=0
        loop
            exitwhen vl_i>=zzCF_BAG_SLOTS()
            set vl_item=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]
            if vl_item!=null and GetItemTypeId(vl_item)==vl_type then
                set vl_item=null
                return true
            endif
            set vl_i=vl_i+1
        endloop
    endif
    set vl_item=null
    return false
endfunction

// Lấy ra (và xoá khỏi túi/ô nhanh) một vật phẩm nguyên liệu đúng loại, dùng khi chế đồ đã xác nhận đủ nguyên liệu.
function zzVL_CraftTake takes unit vl_unit,integer vl_type returns item
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_unit))
    local integer vl_i=0
    local item vl_item
    loop
        exitwhen vl_i>=6
        set vl_item=UnitItemInSlot(vl_unit,vl_i)
        if vl_item!=null and GetItemTypeId(vl_item)==vl_type then
            call UnitRemoveItem(vl_unit,vl_item)
            return vl_item
        endif
        set vl_i=vl_i+1
    endloop
    if vl_unit==Jx[vl_pid+1] and vl_pid>=0 and vl_pid<=9 then
        set vl_i=0
        loop
            exitwhen vl_i>=zzCF_BAG_SLOTS()
            set vl_item=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]
            if vl_item!=null and GetItemTypeId(vl_item)==vl_type then
                set zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]=null
                return vl_item
            endif
            set vl_i=vl_i+1
        endloop
    endif
    return null
endfunction

// Giao thành phẩm chế đồ cho tướng: ưu tiên bỏ vào hành trang 60 ô, hết chỗ mới thử 6 ô hiện vật, hết cả hai thì
// để lại dưới đất (zzDR_TrackItem theo dõi hạn tự biến mất).
function zzVL_CraftOutput takes unit vl_unit,item vl_item returns nothing
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_unit))
    if vl_item==null then
        return
    endif
    if vl_pid>=0 and vl_pid<=9 and vl_unit==Jx[vl_pid+1] then
        if not zzVL_BagAdd(vl_pid,vl_item) then
            if not UnitAddItem(vl_unit,vl_item) then
                call zzDR_TrackItem(vl_item)
            endif
        endif
    else
        call UnitAddItem(vl_unit,vl_item)
    endif
endfunction

// Thợ rèn/chế đồ: kiểm tra lần lượt từng bộ 3 nguyên liệu tương ứng (mỗi công thức là một nhánh elseif), đủ thì trừ
// nguyên liệu, tạo thành phẩm và phát hiệu ứng; không khớp công thức nào thì báo thiếu nguyên liệu và phát âm thanh từ chối.
function zzVL_Craft takes unit c returns nothing
    local player p=GetOwningPlayer(c)
    local real X=GetUnitX(c)
    local real Y=GetUnitY(c)
    local item i
    local integer ic=40
    local integer ir=GetRandomInt(1,'d')
    if zzVL_CraftHas(c,'I06K') and zzVL_CraftHas(c,'I06N') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06K'))
        call RemoveItem(zzVL_CraftTake(c,'I06N'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I05A',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06K') and zzVL_CraftHas(c,'I06X') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06K'))
        call RemoveItem(zzVL_CraftTake(c,'I06X'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I05B',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06K') and zzVL_CraftHas(c,'I06Y') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06K'))
        call RemoveItem(zzVL_CraftTake(c,'I06Y'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I05C',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06J') and zzVL_CraftHas(c,'I06N') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06J'))
        call RemoveItem(zzVL_CraftTake(c,'I06N'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I04Y',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06J') and zzVL_CraftHas(c,'I06X') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06J'))
        call RemoveItem(zzVL_CraftTake(c,'I06X'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I04Z',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06J') and zzVL_CraftHas(c,'I06Y') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06J'))
        call RemoveItem(zzVL_CraftTake(c,'I06Y'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I050',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06L') and zzVL_CraftHas(c,'I06N') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06L'))
        call RemoveItem(zzVL_CraftTake(c,'I06N'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('rat3',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06L') and zzVL_CraftHas(c,'I06X') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06L'))
        call RemoveItem(zzVL_CraftTake(c,'I06X'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I04Q',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06L') and zzVL_CraftHas(c,'I06Y') and zzVL_CraftHas(c,'I06M') then
        call RemoveItem(zzVL_CraftTake(c,'I06L'))
        call RemoveItem(zzVL_CraftTake(c,'I06Y'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        set i=CreateItem('I04U',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06Q') and zzVL_CraftHas(c,'I00Q') and zzVL_CraftHas(c,'I00P') then
        call RemoveItem(zzVL_CraftTake(c,'I06Q'))
        call RemoveItem(zzVL_CraftTake(c,'I00Q'))
        call RemoveItem(zzVL_CraftTake(c,'I00P'))
        set i=CreateItem('mcou',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06Q') and zzVL_CraftHas(c,'I06T') and zzVL_CraftHas(c,'I06U') then
        call RemoveItem(zzVL_CraftTake(c,'I06Q'))
        call RemoveItem(zzVL_CraftTake(c,'I06T'))
        call RemoveItem(zzVL_CraftTake(c,'I06U'))
        set i=CreateItem('kpin',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06S') and zzVL_CraftHas(c,'I06R') and zzVL_CraftHas(c,'I06U') then
        call RemoveItem(zzVL_CraftTake(c,'I06S'))
        call RemoveItem(zzVL_CraftTake(c,'I06R'))
        call RemoveItem(zzVL_CraftTake(c,'I06U'))
        set i=CreateItem('I004',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I06P') and zzVL_CraftHas(c,'I06V') and zzVL_CraftHas(c,'I06W') then
        call RemoveItem(zzVL_CraftTake(c,'I06P'))
        call RemoveItem(zzVL_CraftTake(c,'I06V'))
        call RemoveItem(zzVL_CraftTake(c,'I06W'))
        set i=CreateItem('rugt',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I019') and zzVL_CraftHas(c,'I00R') and zzVL_CraftHas(c,'I017') then
        call RemoveItem(zzVL_CraftTake(c,'I019'))
        call RemoveItem(zzVL_CraftTake(c,'I00R'))
        call RemoveItem(zzVL_CraftTake(c,'I017'))
        set i=CreateItem('rhth',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I00T') and zzVL_CraftHas(c,'I06M') and zzVL_CraftHas(c,'I00R') then
        call RemoveItem(zzVL_CraftTake(c,'I00T'))
        call RemoveItem(zzVL_CraftTake(c,'I06M'))
        call RemoveItem(zzVL_CraftTake(c,'I00R'))
        set i=CreateItem('tmsc',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I016') and zzVL_CraftHas(c,'I06P') and zzVL_CraftHas(c,'I00R') then
        call RemoveItem(zzVL_CraftTake(c,'I016'))
        call RemoveItem(zzVL_CraftTake(c,'I06P'))
        call RemoveItem(zzVL_CraftTake(c,'I00R'))
        set i=CreateItem('rde1',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I018') and zzVL_CraftHas(c,'I00S') and zzVL_CraftHas(c,'I017') then
        call RemoveItem(zzVL_CraftTake(c,'I018'))
        call RemoveItem(zzVL_CraftTake(c,'I00S'))
        call RemoveItem(zzVL_CraftTake(c,'I017'))
        set i=CreateItem('hcun',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I01A') and zzVL_CraftHas(c,'I06U') and zzVL_CraftHas(c,'I017') then
        call RemoveItem(zzVL_CraftTake(c,'I01A'))
        call RemoveItem(zzVL_CraftTake(c,'I06U'))
        call RemoveItem(zzVL_CraftTake(c,'I017'))
        set i=CreateItem('Igdh',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I01B') and zzVL_CraftHas(c,'I06S') and zzVL_CraftHas(c,'I06K') then
        call RemoveItem(zzVL_CraftTake(c,'I01B'))
        call RemoveItem(zzVL_CraftTake(c,'I06S'))
        call RemoveItem(zzVL_CraftTake(c,'I06K'))
        set i=CreateItem('srbd',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    elseif zzVL_CraftHas(c,'I01E') and zzVL_CraftHas(c,'I01F') and zzVL_CraftHas(c,'I01D') and zzVL_CraftHas(c,'I01G') then
        call RemoveItem(zzVL_CraftTake(c,'I01D'))
        call RemoveItem(zzVL_CraftTake(c,'I01E'))
        call RemoveItem(zzVL_CraftTake(c,'I01F'))
        call RemoveItem(zzVL_CraftTake(c,'I01G'))
        set i=CreateItem('I01H',X,Y)
        call zzVL_CraftOutput(c,i)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",X,Y))
    else
        call DisplayTextToPlayer(p,1,1,"|cffffcc00Không du nguyên liêu")
        call PlaySoundOnUnitBJ(xn,'d',c)
    endif
    set c=null
    set p=null
    set i=null
endfunction

// Trả lại bảo thạch đã khảm trước khi món đồ bị BÁN (khác "Tách": không tốn vàng, vì món đồ coi như mất luôn).
// Tạo lại từng viên theo loại lưu ở zzIT_LO_KHAM()+i vào hành trang, hết chỗ thì để dưới chân tướng.
function zzVL_RefundKham takes integer vl_playerId,item vl_item returns nothing
    local integer vl_id=GetHandleId(vl_item)
    local integer vl_n=zzIT_Get(vl_id,zzIT_SO_LO_KHAM())
    local integer vl_i=0
    local integer vl_type
    local item vl_m
    local unit vl_hero=Jx[vl_playerId+1]
    if vl_n<=0 or vl_hero==null then
        set vl_hero=null
        return
    endif
    loop
        exitwhen vl_i>=vl_n
        set vl_type=zzIT_Get(vl_id,zzIT_LO_KHAM()+vl_i)
        if vl_type!=0 then
            set vl_m=CreateItem(vl_type,GetUnitX(vl_hero),GetUnitY(vl_hero))
            if not zzVL_BagPut(vl_playerId,vl_m) then
                call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy, bảo thạch để dưới chân tướng.|r")
            endif
            set vl_m=null
        endif
        set vl_i=vl_i+1
    endloop
    call zzVL_Msg(vl_playerId,"|cff80c0ffĐã trả lại "+I2S(vl_n)+" viên bảo thạch đã khảm.|r")
    set vl_hero=null
endfunction
// Bán một món trong hành trang qua nút Bán: món đang mặc hoặc phi phong không bán được; giá lấy theo bảng (khóa 41)
// hoặc 10+25*cấp nếu chưa đặt, nhân theo số lượng; hoàn trả lại bảo thạch đã khảm trước khi xoá món.
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
    call zzVL_RefundKham(vl_playerId,vl_item)
    call RemoveItem(vl_item)
    call AdjustPlayerStateBJ(vl_g,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
    if GetLocalPlayer()==Player(vl_playerId) then
        call StartSound(bj_questItemAcquiredSound)
    endif
    set vl_item=null
endfunction

// Tách một chồng vật phẩm cộng dồn (nguyên liệu, bình thuốc...) làm đôi: phần dư ở lại ô cũ, nửa kia tạo ô mới trong túi.
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

// Khai báo bảng chỉ số (mã dòng + giá trị) cho từng loại bảo thạch khảm, cả bộ cũ (I06x) lẫn 12 loại bảo thạch mới (I101-I10C).
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

// Định dạng một dòng khảm thành chuỗi hiển thị: "+X cấp" cho tăng cấp kỹ năng, số nguyên trần cho vài chỉ số đặc
// biệt, còn lại mặc định hậu tố %.
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
        exitwhen vl_i>=zzIT_Get(vl_id,zzIT_SO_LO_KHAM())
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
    set vl_s=vl_s+"|n|n|cff80c0ffKhảm ("+I2S(zzIT_Get(vl_id,zzIT_SO_LO_KHAM()))+"/"+I2S(zzCF_KHAM_SO_LO())+")|r"
    set vl_j=0
    loop
        exitwhen vl_j>=zzCF_KHAM_SO_LO()
        if vl_j<zzIT_Get(vl_id,zzIT_SO_LO_KHAM()) and LoadStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+vl_j)!=null then
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

// Chạy zzEQ_Describe cho vật phẩm vừa lưu tạm vào hashtable (ExecuteFunc không truyền được tham số) khi cần dựng
// lại mô tả từ một nơi khác trong code.
function zzEQ_DescribeRun takes nothing returns nothing
    local item vl_it=LoadItemHandle(zzVL_ht,0,499)
    if vl_it!=null and zzEQ_IsGear(GetItemTypeId(vl_it)) then
        call zzEQ_Describe(vl_it)
    endif
    set vl_it=null
endfunction

// Khảm một viên bảo thạch (đã chọn trước) vào trang bị vl_g: cộng dòng chỉ số, ghi lại loại viên vào lỗ khảm để
// Tách trả đúng viên, dựng lại mô tả, trừ/xoá nguyên liệu rồi tính lại toàn bộ chỉ số của người chơi.
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
    // phòng hờ: tới đây bình thường cả 2 bảng đã mở sẵn (phải mở mới bấm được gem/trang bị); lỡ đóng mất
    // 1 trong 2 giữa chừng thì tự mở lại thay vì chặn, không bắt bấm lại từ đầu
    if not zzVL_bagOpen[vl_playerId] then
        call zzVL_BagShow(vl_playerId,true)
    endif
    if not zzVL_heroOpen[vl_playerId] then
        set zzVL_heroOpen[vl_playerId]=true
        call ExecuteFunc("zzVL_HeroTick")
    endif
    if zzIT_Get(vl_id,zzIT_SO_LO_KHAM())>=zzCF_KHAM_SO_LO() then
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
    call zzIT_Set(vl_id,zzIT_LO_KHAM()+zzIT_Get(vl_id,zzIT_SO_LO_KHAM()),GetItemTypeId(vl_m))
    call SaveStr(zzVL_ht,vl_id,zzIT_LO_KHAM_CHU()+zzIT_Get(vl_id,zzIT_SO_LO_KHAM()),vl_string)
    call zzIT_Set(vl_id,zzIT_SO_LO_KHAM(),zzIT_Get(vl_id,zzIT_SO_LO_KHAM())+1)
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
    call zzVL_Msg(vl_playerId,"|cff80c0ffKhảm thành công|r "+GetItemName(vl_m)+" vào "+GetItemName(vl_g)+": "+zzVL_KhamText(vl_k,vl_v)+" (lỗ "+I2S(zzIT_Get(vl_id,zzIT_SO_LO_KHAM()))+"/"+I2S(zzCF_KHAM_SO_LO())+")")
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
    local integer vl_n=zzIT_Get(vl_id,zzIT_SO_LO_KHAM())
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
    call zzIT_Set(vl_id,zzIT_SO_LO_KHAM(),0)
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

// Dùng Huyền Tinh (hoặc vật phẩm tăng điểm tương tự) đã chọn lên một món trang bị hợp lệ: quy đổi thành điểm Glass
// Point rồi gọi cường hóa KVCT hoặc cường hóa theo ô, tuỳ loại trang bị.
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

// Tìm một nguyên liệu chế đồ (theo mã gốc hoặc mã quy đổi, khóa 59) trong túi, 6 ô hiện vật của tướng hoặc Thủ Khố;
// vl_take=true thì trừ luôn (giảm số lượng hoặc xoá ô).
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

// Xoay trang hàng của một cửa hàng nhiều trang: gỡ hết vật phẩm trang hiện tại, chuyển sang trang kế (xoay vòng), nạp lại hàng.
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

// Sự kiện mua vật phẩm chế đồ ở cửa hàng: nút đổi trang (I0PG) thì gọi zzVL_ShopPage; còn lại kiểm tra đủ nguyên
// liệu (zzVL_FindMat) mới cho nhận, thiếu thì hoàn vàng và xoá vật phẩm vừa "mua".
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

// Chuyển một món trong hành trang cho đồng minh đang được chọn (qua nút Chuyển + chọn tướng trên bản đồ): kiểm
// tra còn sống, là đồng minh, có hệ thống hành trang, và hành trang người nhận còn chỗ.
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

// Lượng sinh lực/nội lực mà một loại bình (khóa 602) hồi phục; 0 nếu vật phẩm không phải bình hồi phục.
function zzKT_PotionAmount takes integer vl_type returns integer
    return LoadInteger(zzVL_ht,vl_type,602)
endfunction

// Tìm và dùng bình hồi phục mạnh nhất phù hợp cấp độ tướng (so cả túi lẫn 6 ô hiện vật), trừ/xoá vật phẩm rồi trả
// về lượng hồi phục để bắt đầu hiệu ứng hồi dần (zzKT_Tick).
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

// Xử lý phím 1 (dùng bình thủ công): chặn nếu đang hồi dần dở, báo nếu không có bình phù hợp cấp, còn lại dùng bình tốt nhất.
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

// Phím 1: dùng bình hồi phục.
function zzKT_OnPotionKey takes nothing returns nothing
    call zzKT_Use(GetPlayerId(GetTriggerPlayer()))
endfunction

// Ghi nhận phím Ctrl (trái/phải) đang giữ, dùng để mua gộp nhiều bình cùng lúc (zzKT_OnBuy).
function zzKT_ControlDown takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    if BlzGetTriggerPlayerKey()==OSKEY_LCONTROL then
        set zzKT_ctrlLeft[vl_pid]=true
    else
        set zzKT_ctrlRight[vl_pid]=true
    endif
    set zzKT_ctrl[vl_pid]=zzKT_ctrlLeft[vl_pid] or zzKT_ctrlRight[vl_pid]
endfunction

// Ghi nhận phím Ctrl vừa nhả.
function zzKT_ControlUp takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    if BlzGetTriggerPlayerKey()==OSKEY_LCONTROL then
        set zzKT_ctrlLeft[vl_pid]=false
    else
        set zzKT_ctrlRight[vl_pid]=false
    endif
    set zzKT_ctrl[vl_pid]=zzKT_ctrlLeft[vl_pid] or zzKT_ctrlRight[vl_pid]
endfunction

// Giữ Ctrl khi mua bình ở cửa hàng: tự mua gộp thêm cho đủ tối đa mỗi ô (giới hạn cấu hình zzKT), trừ thêm vàng tương ứng.
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

// Lệnh chat -autohp: bật/tắt tự động bơm bình khi sinh lực xuống dưới ngưỡng, hoặc -autohp N để đặt ngưỡng % (1-100).
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

// Mỗi .25 giây: hồi dần sinh lực/nội lực của bình đang dùng theo 16 nhịp (zzKT_hotTick), và tự kích hoạt dùng bình
// mới khi bật tự động bơm máu và sinh lực xuống dưới ngưỡng.
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

// Khởi tạo hệ thống bình hồi phục: ngưỡng tự bơm mặc định, đăng ký phím 1/Ctrl, lệnh chat -autohp và vòng lặp zzKT_Tick.
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

// theo dõi vị trí con trỏ chuột của từng người chơi trên mặt đất (zzVL_KinhCong dùng để lướt theo hướng chuột)
function zzVL_OnMouseMove takes nothing returns nothing
    local integer vl_p=GetPlayerId(GetTriggerPlayer())
    local location vl_loc
    if vl_p<0 or vl_p>9 then
        return
    endif
    set vl_loc=BlzGetTriggerPlayerMousePosition()
    set zzVL_mouseX[vl_p]=GetLocationX(vl_loc)
    set zzVL_mouseY[vl_p]=GetLocationY(vl_loc)
    set zzVL_mouseSet[vl_p]=true
    call RemoveLocation(vl_loc)
    set vl_loc=null
endfunction

// Thực thi khinh công cho một người chơi: kiểm tra còn sống/hết hồi, xác định hướng lướt theo chuột (hoặc hướng
// tướng đang quay nếu chưa rõ vị trí chuột), đặt mốc hồi chiêu/miễn sát thương rồi bắt đầu timer lướt (zzVL_KinhCongTick).
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
    // lướt theo hướng con trỏ chuột (theo dõi bằng zzVL_OnMouseMove); chưa có vị trí chuột thì lướt theo hướng tướng đang quay
    if vl_pid>=0 and vl_pid<10 and zzVL_mouseSet[vl_pid] then
        set vl_a=Atan2(zzVL_mouseY[vl_pid]-GetUnitY(vl_h),zzVL_mouseX[vl_pid]-GetUnitX(vl_h))
    else
        set vl_a=GetUnitFacing(vl_h)*bj_DEGTORAD
    endif
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

// Bộ xử lý trung tâm khi bấm vào một ô/nút của bảng Hành Trang, phân biệt theo dải số vl_code:
// < BAG_SLOTS: ô trong 60 ô túi (chuột phải = mang/dùng ngay bất kể chế độ; chuột trái = chọn/đổi chỗ với ô đã
//   chọn, hoặc thao tác theo chế độ đang bật: Chuyển cho đồng minh/Khảm/Bán/Tách/Vứt/dùng Huyền Tinh; không có
//   chế độ nào thì mặc trang bị vào đúng ô hoặc đưa đồ dùng ra ô nhanh của tướng);
// 230-239: ô trang bị đang mặc (bấm để tháo về túi, trừ khi đang khảm/tách/dùng Huyền Tinh thì thao tác tại chỗ);
// 240-241: ô Thủ Khố (lấy về hành trang); 242-251: các nút bật/tắt chế độ (Chuyển/Bán/Tách/Khảm/Vứt/Tự bán),
// đóng/mở bảng Hành Trang, mở bảng Nhân Vật, và nút Khinh Công.
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
        // chuột PHẢI (zzVL_rClick, xem zzVL_SlotMouseUp) = mang / dùng món ngay, bỏ qua mọi chế độ;
        // chuột TRÁI = chọn món rồi chọn ô khác để đổi chỗ (bấm lại món đang chọn thì bỏ chọn)
        if zzVL_rClick[vl_playerId] then
            set zzVL_bagSel[vl_playerId]=0
        endif
        if not zzVL_rClick[vl_playerId] and zzKT_target[vl_playerId]>=0 and zzVL_sendTK[vl_playerId] and not zzVL_khamMode[vl_playerId] and not zzVL_sellMode[vl_playerId] and not zzVL_splitMode[vl_playerId] and not zzVL_DropMode(vl_playerId) then
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
            call zzVL_Msg(vl_playerId,"Đã bỏ chọn.")
            call zzVL_Refresh(vl_playerId)
            set vl_hero=null
            set vl_tk=null
            set vl_item=null
            set vl_old=null
            return
        elseif not zzVL_rClick[vl_playerId] and vl_item!=null and not zzVL_khamMode[vl_playerId] and not zzVL_sellMode[vl_playerId] and not zzVL_splitMode[vl_playerId] and not zzVL_DropMode(vl_playerId) and not zzVL_sendTK[vl_playerId] and zzVL_tSel[vl_playerId]==null then
            set zzVL_bagSel[vl_playerId]=vl_code+1
            call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Chuột trái ô khác để đổi chỗ, bấm lại để bỏ chọn; chuột phải để mang / dùng.")
            call zzVL_Refresh(vl_playerId)
            set vl_hero=null
            set vl_tk=null
            set vl_item=null
            set vl_old=null
            return
        endif
        if not zzVL_rClick[vl_playerId] and vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 then
            if (LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 or zzGM_Type(GetItemTypeId(vl_item))>0) then
                set zzVL_kSel[vl_playerId]=1
                set zzVL_kItem[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị (đang mặc hoặc trong hành trang) để khảm.")
            else
                call zzVL_Msg(vl_playerId,"Món này không phải nguyên liệu khảm. Nguyên liệu: các loại Bảo Thạch, Kim Cương, Nữ Oa Tinh Thạch, Long Nguyên, Sa Nhung, Bồ Đề Mộc, Thiên Niên Cổ Vật.")
            endif
        elseif not zzVL_rClick[vl_playerId] and vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif not zzVL_rClick[vl_playerId] and vl_item!=null and zzVL_DropMode(vl_playerId) then
            if zzVL_IsEquipped(vl_playerId,vl_item) then
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
            else
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_code]=null
                call zzIT_Set(GetHandleId(vl_item),zzIT_DA_VUT(),1)
                call SetItemVisible(vl_item,true)
                call SetItemPosition(vl_item,GetUnitX(vl_hero)+230.*Cos(GetUnitFacing(vl_hero)*bj_DEGTORAD),GetUnitY(vl_hero)+230.*Sin(GetUnitFacing(vl_hero)*bj_DEGTORAD))
                call zzDR_TrackItem(vl_item)
                call zzVL_Msg(vl_playerId,"Đã vứt "+GetItemName(vl_item))
            endif
        elseif vl_item!=null then
            if not zzVL_rClick[vl_playerId] and zzVL_sellMode[vl_playerId] then
                call zzVL_Sell(vl_playerId,vl_code)
            elseif not zzVL_rClick[vl_playerId] and zzVL_splitMode[vl_playerId] then
                // trang bị đã khảm: tách bảo thạch; đồ cộng dồn: chia đôi như cũ
                if zzIT_Get(GetHandleId(vl_item),zzIT_SO_LO_KHAM())<=0 or not zzVL_Tach(vl_playerId,vl_item) then
                    call zzVL_Split(vl_playerId,vl_code)
                endif
            elseif not zzVL_rClick[vl_playerId] and zzVL_tSel[vl_playerId]!=null and zzVL_tSel[vl_playerId]!=vl_item and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10>=1 then
                call zzVL_TtUse(vl_playerId,vl_item)
            elseif not zzVL_rClick[vl_playerId] and GetItemTypeId(vl_item)=='I00W' and not zzVL_sendTK[vl_playerId] then
                set zzVL_tSel[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn |cffffff00Huyền tinh|r.")
            elseif not zzVL_rClick[vl_playerId] and zzVL_sendTK[vl_playerId] then
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
            if zzIT_Get(GetHandleId(vl_item),zzIT_SO_LO_KHAM())>0 then
                call zzVL_Tach(vl_playerId,vl_item)
            else
                call zzVL_Msg(vl_playerId,"Món này chưa khảm bảo thạch.")
            endif
        elseif vl_item!=null and zzVL_tSel[vl_playerId]!=null then
            call zzVL_TtUse(vl_playerId,vl_item)
        elseif vl_item!=null then
            // Tạm tháo khỏi ô trang bị trước để BagAdd không nhận nhầm đây là handle đã cất.
            set zzVL_equipItem[vl_playerId*10+vl_code-230]=null
            if zzVL_BagAdd(vl_playerId,vl_item) then
                call zzVL_AffixSum(vl_playerId)
                call ExecuteFunc("zzVL_HeroTick")
            else
                // Túi đầy: giữ món ở nguyên ô trang bị.
                set zzVL_equipItem[vl_playerId*10+vl_code-230]=vl_item
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
            // tự mở bảng Nhân vật để khảm được ngay vào đồ đang mặc, không cần tự bấm (I) trước
            // (zzVL_HeroShow khai báo sau trong file nên gọi qua ExecuteFunc như chỗ khác trong hàm này)
            if not zzVL_heroOpen[vl_playerId] then
                set zzVL_heroOpen[vl_playerId]=true
                call ExecuteFunc("zzVL_HeroTick")
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

// Chọn (hoặc bỏ chọn nếu bấm lại) một đồng minh làm người nhận khi chế độ Chuyển đồ đang bật.
function zzKT_TargetClick takes integer vl_pid,integer vl_target returns nothing
    if vl_pid>=0 and vl_pid<10 and vl_target>=0 and vl_target<10 and vl_target!=vl_pid and IsPlayerAlly(Player(vl_pid),Player(vl_target)) and Jx[vl_target+1]!=null and GetWidgetLife(Jx[vl_target+1])>.405 then
        // bấm lại người đang được chọn: bỏ chọn (không gửi nhầm liên tục)
        if zzKT_target[vl_pid]==vl_target then
            set zzKT_target[vl_pid]=-1
            call zzVL_Msg(vl_pid,"Đã bỏ chọn người nhận.")
        else
            set zzKT_target[vl_pid]=vl_target
            call zzVL_Msg(vl_pid,"Đã chọn người nhận: "+GetPlayerName(Player(vl_target))+" - "+GetUnitName(Jx[vl_target+1])+". Bấm món đồ để chuyển.")
        endif
        call zzVL_Refresh(vl_pid)
    endif
endfunction

// chuột phải trên ô hành trang: MOUSE_UP xong, đợi 1 nhịp (timer 0 giây); nếu cùng lúc không có CONTROL_CLICK (chuột trái)
// thì đó là chuột phải -> mang / dùng món ngay (zzVL_BagClick với zzVL_rClick = true)
function zzVL_SlotRight takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_p=LoadInteger(zzVL_ht,GetHandleId(vl_t),0)
    if zzVL_lastLeft[vl_p]<zzVL_upT[vl_p]-.001 and zzVL_IsBagUser(vl_p) then
        set zzVL_rClick[vl_p]=true
        call zzVL_BagClick(vl_p,zzVL_rSlot[vl_p])
        set zzVL_rClick[vl_p]=false
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction

// Ghi lại ô vừa thả chuột và thời điểm, rồi hẹn zzVL_SlotRight kiểm tra 1 nhịp sau xem có phải chuột phải không.
function zzVL_SlotMouseUp takes nothing returns nothing
    local integer vl_p=GetPlayerId(GetTriggerPlayer())
    local timer vl_t=CreateTimer()
    set zzVL_rSlot[vl_p]=LoadInteger(zzVL_ht,GetHandleId(BlzGetTriggerFrame()),7)-1
    set zzVL_upT[vl_p]=TimerGetElapsed(zzVL_clock)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),0,vl_p)
    call TimerStart(vl_t,0.,false,function zzVL_SlotRight)
    set vl_t=null
endfunction

// Điểm vào chung cho mọi cú bấm khung UI: định tuyến theo mã khung (vl_code) tới chọn người nhận Chuyển đồ (300+),
// nút + cường hóa cạnh ô trang bị (100+), hoặc bấm ô/nút hành trang (zzVL_BagClick).
function zzVL_OnFrameClick takes nothing returns nothing
    local framehandle vl_f=BlzGetTriggerFrame()
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_code=LoadInteger(zzVL_ht,GetHandleId(vl_f),7)-1
    set zzVL_lastLeft[vl_playerId]=TimerGetElapsed(zzVL_clock)
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

// Phím B: mở/đóng bảng Hành Trang; bỏ qua các lần lặp phím khi giữ (chỉ phản ứng lần nhấn đầu).
function zzVL_OnBagKey takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    // như phím I: bỏ các lần lặp phím khi giữ
    if not BlzGetTriggerPlayerIsKeyDown() then
        set zzVL_keyB[vl_playerId]=false
        return
    endif
    if zzVL_keyB[vl_playerId] then
        return
    endif
    set zzVL_keyB[vl_playerId]=true
    if zzVL_IsBagUser(vl_playerId) then
        call zzVL_BagShow(vl_playerId,not zzVL_bagOpen[vl_playerId])
    endif
endfunction

// Chặn tướng trang bị vật phẩm chưa đủ cấp yêu cầu (hủy lệnh, báo cấp cần có); đồng thời theo dõi vật phẩm người
// chơi vừa ra lệnh nhặt (zzVL_want) để zzVL_WantTick tự động cất vào hành trang khi nhặt xong.
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

// Callback liệt kê vật phẩm quanh tướng cho tự nhặt: gom tối đa 8 vật phẩm hợp lệ (không phải power-up, chưa ai sở
// hữu, chưa bị đánh dấu đã vứt, trong tầm 150) vào danh sách tạm.
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

// Mỗi .2 giây: với mỗi người chơi còn chỗ trong 6 ô hiện vật, quét vật phẩm quanh tướng (160 đơn vị) và tự nhặt
// thẳng vào hành trang 60 ô (random chỉ số trước khi nhặt).
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

// Theo dõi vật phẩm người chơi vừa ra lệnh nhặt (zzVL_want ghi từ zzVL_OnItemOrder): khi đủ gần và còn hợp lệ,
// huỷ lệnh nhặt vào ô Warcraft gốc và tự chuyển thẳng vào hành trang 60 ô.
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

// Mỗi .5 giây: vẽ lại bảng Hành Trang của những người chơi đang mở bảng (đồng bộ khi vật phẩm thay đổi từ nơi khác).
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

// Tạo một khung chữ (TEXT) đơn giản tại toạ độ cho trước, dùng để dựng nhãn/tiêu đề trong giao diện.
function zzVL_MakeText takes framehandle vl_parent,real vl_x,real vl_y,real vl_w,string vl_string returns framehandle
    local framehandle vl_t=BlzCreateFrameByType("TEXT","",vl_parent,"",0)
    call BlzFrameSetAbsPoint(vl_t,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_t,vl_w,.016)
    call BlzFrameSetText(vl_t,vl_string)
    return vl_t
endfunction

// Tạo một ô bấm được (icon + số lượng + khung phẩm chất) cho bảng Hành Trang/trang bị/Thủ Khố, đăng ký sự kiện
// bấm chuột trái (CONTROL_CLICK), chuột phải (MOUSE_UP) và rê chuột hiện tooltip.
function zzVL_MakeSlot takes integer vl_code,real vl_x,real vl_y,real vl_size returns nothing
    local framehandle vl_e
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
    if vl_code<zzCF_BAG_SLOTS() then
        // chuột phải: MOUSE_UP có cả trái lẫn phải, CONTROL_CLICK chỉ có trái -> zzVL_SlotMouseUp phân biệt
        call BlzTriggerRegisterFrameEvent(zzVL_tSlotUp,vl_b,FRAMEEVENT_MOUSE_UP)
    endif
    call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOn,vl_b,FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(zzVL_tItemHoverOff,vl_b,FRAMEEVENT_MOUSE_LEAVE)
    set zzVL_fIco[vl_code]=vl_i
    // khung phẩm chất (màu theo tên trang bị), đồ thường thì ẩn
    // khung phẩm chất: BACKDROP gắn thẳng vào nút ô (KHÔNG dùng FRAME phủ ô: nó chặn chuột), phủ đúng ô
    set vl_e=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    call BlzFrameSetAllPoints(vl_e,vl_b)
    call BlzFrameSetEnable(vl_e,false)
    call BlzFrameSetVisible(vl_e,false)
    set zzVL_fQE[vl_code]=vl_e
    set vl_e=null
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

// Tạo một nút bấm dạng chữ (vd Bán, Tách, Khảm, Đóng) tại toạ độ cho trước và đăng ký sự kiện bấm.
function zzVL_MakeButton takes integer vl_code,framehandle vl_parent,real vl_x,real vl_y,real vl_w,string vl_string returns framehandle
    local framehandle vl_b=BlzCreateFrame("ScriptDialogButton",vl_parent,0,0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_b,vl_w,.024)
    call BlzFrameSetText(vl_b,vl_string)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
    return vl_b
endfunction

// Tạo lớp viền sáng (ẩn sẵn) phủ quanh một khung, dùng làm hiệu ứng highlight khi cần.
function zzVL_MakeHl takes framehandle vl_b returns framehandle
    local framehandle vl_hero=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    call BlzFrameSetPoint(vl_hero,FRAMEPOINT_TOPLEFT,vl_b,FRAMEPOINT_TOPLEFT,-.004,.004)
    call BlzFrameSetPoint(vl_hero,FRAMEPOINT_BOTTOMRIGHT,vl_b,FRAMEPOINT_BOTTOMRIGHT,.004,-.004)
    call BlzFrameSetTexture(vl_hero,"UI\\Widgets\\Console\\Human\\CommandButton\\human-activebutton.blp",0,true)
    call BlzFrameSetAlpha(vl_hero,180)
    call BlzFrameSetVisible(vl_hero,false)
    return vl_hero
endfunction

// Tạo một nút bấm dạng icon vuông (vd nút mở Hành Trang, bảng Nhân Vật, Khinh Công) tại toạ độ cho trước.
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

// Tạo một khung nền (BACKDROP) trang trí, không bấm được, dùng làm panel/viền trong giao diện.
function zzVL_Panel takes framehandle vl_parent,real vl_x0,real vl_y0,real vl_x1,real vl_y1,string vl_tex,integer vl_a returns framehandle
    local framehandle vl_b=BlzCreateFrameByType("BACKDROP","",vl_parent,"",0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x0,vl_y0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_BOTTOMRIGHT,vl_x1,vl_y1)
    call BlzFrameSetTexture(vl_b,vl_tex,0,true)
    call BlzFrameSetAlpha(vl_b,vl_a)
    call BlzFrameSetEnable(vl_b,false)
    return vl_b
endfunction

// Dựng chuỗi hiển thị bảng Nhân Vật: tên/cấp/hệ/quan ấn, sinh lực-nội lực-công-thủ, 3 chỉ số gốc, toàn bộ thuộc
// tính chiến đấu đã cộng dồn (hút máu, bạo kích, tốc đánh, kháng/công ngũ hành, né tránh...), tài phú và số Huyền Tinh.
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
        set vl_string=vl_string+"|nHệ: |cff66ccffNội công|r (hưởng STVL nội công, kỹ năng theo Nội công / Nội lực tối đa)"
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
    if zzPS_Get(vl_playerId,zzPS_CONG_DOC())>0 or zzPS_Get(vl_playerId,zzPS_CONG_THUY())>0 or zzPS_Get(vl_playerId,zzPS_CONG_HOA())>0 or zzPS_Get(vl_playerId,zzPS_CONG_LOI())>0 then
        set vl_string=vl_string+"|nCông độc: +"+I2S(zzPS_Get(vl_playerId,zzPS_CONG_DOC()))+"%   Công thủy: +"+I2S(zzPS_Get(vl_playerId,zzPS_CONG_THUY()))+"%   Công hỏa: +"+I2S(zzPS_Get(vl_playerId,zzPS_CONG_HOA()))+"%   Công lôi: +"+I2S(zzPS_Get(vl_playerId,zzPS_CONG_LOI()))+"%"
    endif
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

// Bật/tắt bảng Nhân Vật: cập nhật nội dung chữ tổng quan, icon các chiêu bị động đang học, icon/tooltip và cấp
// cường hóa của từng ô trong 10 ô trang bị.
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
                call BlzFrameSetTexture(zzVL_fEqIco[vl_j], "VLTK_data\\war3mapImported\\vl_eq_"+I2S(vl_j+1)+".blp", 0, true)
                call BlzFrameSetText(zzVL_fEqTTxt[vl_j],"|cffffcc00[Trang Bị: "+zzVL_EquipSlotName(vl_j)+"]|r\n"+zzVL_EquipSlotStat(vl_j,vl_ch))
            endif
            set vl_j=vl_j+1
        endloop
        call BlzFrameSetVisible(zzVL_fHero,vl_on)
    endif
    set vl_hero=null
endfunction

// Chạy mỗi giây cho mọi người chơi: cập nhật số đếm hồi Khinh Công trên icon, phát bộ trang bị +0 nếu tướng vừa có
// mà chưa được phát (lưới an toàn), tặng bình hồi máu khởi đầu lần đầu, cộng sinh lực/cấp cho hệ nội công (qua
// ability ẩn 'AIl1' để không ăn vào công thức sát thương kỹ năng), rồi vẽ lại bảng Nhân Vật nếu đang mở.
function zzVL_HeroTick takes nothing returns nothing
    local integer vl_playerId=0
    local item vl_potion
    local integer vl_kcLeft
    local unit vl_h
    local ability vl_lifeAb
    loop
        exitwhen vl_playerId>9
        // số đếm hồi chiêu Khinh Công trên icon: còn hồi thì hiện 5 4 3 2 1, sẵn sàng thì tắt số (chỉ của riêng người chơi đang xem)
        if GetLocalPlayer()==Player(vl_playerId) and Jx[vl_playerId+1]!=null and zzVL_fKcTxt!=null then
            set vl_kcLeft=R2I(zzUS_Real(GetHandleId(Jx[vl_playerId+1]),zzUS_DASH_COOLDOWN_END())-TimerGetElapsed(zzVL_clock)+.999)
            if vl_kcLeft>0 then
                call BlzFrameSetText(zzVL_fKcTxt,"|cffffcc00"+I2S(vl_kcLeft)+"|r")
            else
                call BlzFrameSetText(zzVL_fKcTxt,"")
            endif
        endif
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
        // nội công: sinh lực +X mỗi cấp (config.py PHE_HP_PER_LEVEL_NOI, khóa 0/461 x100), qua ability 'AIl1' (Item Life
        // Bonus) chứ không qua Sức mạnh -> không ăn vào sát thương kỹ năng (zzVL_PheAtk dùng Sức mạnh riêng). Tính lại
        // từ đầu mỗi giây theo cấp hiện tại (giống zzKS_MainBonus), không cộng dồn sai nếu tướng chết/đổi/hồi sinh.
        set vl_h=Jx[vl_playerId+1]
        if vl_h!=null and IsUnitType(vl_h,UNIT_TYPE_HERO) and zzVL_Phe(vl_h)==2 then
            set vl_lifeAb=BlzGetUnitAbility(vl_h,'AIl1')
            if vl_lifeAb==null then
                call UnitAddAbility(vl_h,'AIl1')
                call BlzUnitHideAbility(vl_h,'AIl1',true)
                set vl_lifeAb=BlzGetUnitAbility(vl_h,'AIl1')
            endif
            if vl_lifeAb!=null then
                call BlzSetAbilityIntegerLevelField(vl_lifeAb,ABILITY_ILF_MAX_LIFE_GAINED,0,R2I(I2R(GetHeroLevel(vl_h))*LoadInteger(zzVL_ht,0,461)/100.))
            endif
        endif
        call zzVL_HeroShow(vl_playerId,zzVL_heroOpen[vl_playerId])
        set vl_playerId=vl_playerId+1
    endloop
    set vl_potion=null
    set vl_h=null
    set vl_lifeAb=null
endfunction

// Phím I: mở/đóng bảng Nhân Vật; bỏ qua các lần lặp phím khi giữ (chỉ phản ứng lần nhấn đầu).
function zzVL_OnHeroKey takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    // giữ phím thì Windows lặp phím xuống liên tục -> bảng bật/tắt loạn: chỉ đổi khi phím vừa được nhấn (đã nhả trước đó)
    if not BlzGetTriggerPlayerIsKeyDown() then
        set zzVL_keyI[vl_playerId]=false
        return
    endif
    if zzVL_keyI[vl_playerId] then
        return
    endif
    set zzVL_keyI[vl_playerId]=true
    call zzVL_HeroShow(vl_playerId,not zzVL_heroOpen[vl_playerId])
endfunction

// Ẩn banner thông báo giữa màn hình sau khi hết thời gian hiện.
function zzVL_BannerHide takes nothing returns nothing
    call BlzFrameSetVisible(zzVL_fBannerBg,false)
endfunction

// Hiện một dòng banner lớn giữa màn hình trong 5 giây (dùng cho thông báo sự kiện quan trọng như Liên Đấu bắt đầu).
function zzVL_Banner takes string vl_string returns nothing
    if zzVL_fBanner==null then
        return
    endif
    call BlzFrameSetText(zzVL_fBanner,vl_string)
    call BlzFrameSetVisible(zzVL_fBannerBg,true)
    call TimerStart(zzVL_bannerT,5.,false,function zzVL_BannerHide)
endfunction

// Hiện banner với nội dung log gần nhất (zzVL_logMsg).
function zzVL_BannerMsg takes nothing returns nothing
    call zzVL_Banner(zzVL_logMsg)
endfunction

// Hiện banner báo Liên Đấu bắt đầu.
function zzVL_BannerArena takes nothing returns nothing
    call zzVL_Banner("|cffff8000LIÊN ĐẤU|r bắt đầu - các cao thủ vào đấu trường!")
endfunction

// hover over a passive icon of the character panel: one shared tooltip box above the icons shows the skill text
function zzVL_PassTipOn takes nothing returns nothing
    local integer vl_ab=LoadInteger(zzVL_ht,GetHandleId(BlzGetTriggerFrame()),8)
    local player vl_pl=GetTriggerPlayer()
    local unit vl_hero=Jx[GetPlayerId(vl_pl)+1]
    if vl_ab!=0 and vl_hero!=null and GetLocalPlayer()==vl_pl then
        call BlzFrameSetText(zzVL_fPassTipTxt,"|cffffcc00"+GetObjectName(vl_ab)+"|r  |cff00ff00(đang ở cấp "+I2S(GetUnitAbilityLevel(vl_hero,vl_ab))+"/10, chỉ số dưới đây là đang cộng)|r|n"+BlzGetAbilityExtendedTooltip(vl_ab,IMaxBJ(1,GetUnitAbilityLevel(vl_hero,vl_ab))-1))
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

// Quy đổi mọi tinh thể Huyền Tinh (I00W) cũ còn sót trong túi/ô hiện vật/Thủ Khố sang điểm Glass Point trước khi cường hóa.
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

// Xử lý bấm nút + cạnh một ô trang bị: quy đổi Huyền Tinh cũ còn sót (nếu có), rồi cường hóa +1 ô vừa bấm (KVCT
// hoặc theo ô cũ tuỳ loại trang bị), cập nhật lại chỉ số và bảng Nhân Vật nếu thành công.
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

// nền đen đặc dưới tooltip chiêu gốc để che chữ bảng nhân vật phía sau
function zzVL_TipBgTick takes nothing returns nothing
    call BlzFrameSetVisible(zzVL_fTipBg,BlzFrameIsVisible(BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP,0)))
endfunction
function zzVL_TipBgInit takes nothing returns nothing
    local framehandle vl_tt=BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP,0)
    set zzVL_fTipBg=BlzCreateFrameByType("BACKDROP","zzTipBg",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetTexture(zzVL_fTipBg,"Textures\\Black32.blp",0,true)
    call BlzFrameSetPoint(zzVL_fTipBg,FRAMEPOINT_TOPLEFT,vl_tt,FRAMEPOINT_TOPLEFT,-.004,.004)
    call BlzFrameSetPoint(zzVL_fTipBg,FRAMEPOINT_BOTTOMRIGHT,vl_tt,FRAMEPOINT_BOTTOMRIGHT,.004,-.004)
    call BlzFrameSetEnable(zzVL_fTipBg,false)
    call BlzFrameSetLevel(zzVL_fTipBg,20)
    call BlzFrameSetLevel(vl_tt,21)
    call BlzFrameSetVisible(zzVL_fTipBg,false)
    call TimerStart(CreateTimer(),.03,true,function zzVL_TipBgTick)
    set vl_tt=null
endfunction

// Dựng toàn bộ khung giao diện tùy biến một lần lúc khởi động: bảng Hành Trang 60 ô + các nút chế độ, bảng chọn
// đồng minh để Chuyển đồ, các nút icon mở Hành Trang/Nhân Vật/Khinh Công, bảng Nhân Vật 10 ô trang bị + 6 icon
// chiêu bị động + khung tooltip món đang rê chuột, và banner thông báo giữa màn hình.
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
    call BlzLoadTOCFile("VLTK_data\\war3mapImported\\vltk.toc")
    set zzVL_tClick=CreateTrigger()
    call TriggerAddAction(zzVL_tClick,function zzVL_OnFrameClick)
    set zzVL_tSlotUp=CreateTrigger()
    call TriggerAddAction(zzVL_tSlotUp,function zzVL_SlotMouseUp)
    set zzVL_tItemHoverOn=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOn,function zzVL_ItemHoverOn)
    set zzVL_tItemHoverOff=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOff,function zzVL_ItemHoverOff)
    // khung hành trang: 60 ô chia đều (config.py GAME BAG_*), mọi tọa độ tính từ góc trên-trái và bề rộng
    set vl_gb=zzCF_BAG_Y()-.030-I2R((zzCF_BAG_SLOTS()+zzCF_BAG_COLS()-1)/zzCF_BAG_COLS())*vl_pitch
    set zzVL_fMain=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_TOPLEFT,zzCF_BAG_X(),zzCF_BAG_Y())
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_BOTTOMRIGHT,zzCF_BAG_X()+zzCF_BAG_W(),vl_gb-.092)
    call zzVL_Panel(zzVL_fMain,zzCF_BAG_X()+.003,zzCF_BAG_Y()-.003,zzCF_BAG_X()+zzCF_BAG_W()-.003,vl_gb-.089,"VLTK_data\\war3mapImported\\vl_ui_panel.blp",245)
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
    // hạ xuống dưới vùng bảng đếm giờ gốc của trò chơi (Liên Đấu / Đấu trường mở sau) để không bị đè lên nhau
    set zzVL_fScore=zzVL_MakeText(vl_ui,.685,.46,.10,"")
    call BlzFrameSetSize(zzVL_fScore,.10,.03)
    call BlzFrameSetTextAlignment(zzVL_fScore,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
    set zzVL_fClock=zzVL_MakeText(vl_ui,.67,.488,.12,"|cffffcc00Thời gian|r 0:00")
    call BlzFrameSetVisible(zzVL_fScore,false)
    call BlzFrameSetVisible(zzVL_fClock,false)
    set zzVL_fOpen=zzVL_MakeIconButton(244,vl_ui,.232,.566,.045,"VLTK_data\\war3mapImported\\vl_ui_bag.blp")
    call BlzFrameSetVisible(zzVL_fOpen,false)
    set vl_x=zzVL_MakeIconButton(250,vl_ui,.280,.566,.045,"VLTK_data\\war3mapImported\\vl_ui_hero.blp")
    call BlzFrameSetVisible(vl_x,false)
    set vl_b=zzVL_MakeIconButton(251,vl_ui,.328,.566,.01125,"ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp")
    call BlzFrameSetVisible(vl_b,false)
    // số đếm hồi chiêu (5 4 3 2 1) đè lên icon, lấy từ mốc hồi chiêu đã có sẵn (zzUS_DASH_COOLDOWN_END); hết hồi thì không hiện số
    set zzVL_fKcTxt=BlzCreateFrameByType("TEXT","",vl_b,"",0)
    call BlzFrameSetPoint(zzVL_fKcTxt,FRAMEPOINT_CENTER,vl_b,FRAMEPOINT_CENTER,0,0)
    call BlzFrameSetSize(zzVL_fKcTxt,.03,.03)
    call BlzFrameSetScale(zzVL_fKcTxt,1.3)
    call BlzFrameSetTextAlignment(zzVL_fKcTxt,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    set vl_tip=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,71)
    call BlzFrameSetSize(vl_tip,.17,.045)
    set vl_tipTxt=BlzCreateFrameByType("TEXT","",vl_tip,"",0)
    call BlzFrameSetPoint(vl_tipTxt,FRAMEPOINT_TOPLEFT,vl_tip,FRAMEPOINT_TOPLEFT,.008,-.008)
    call BlzFrameSetSize(vl_tipTxt,.154,.03)
    call BlzFrameSetText(vl_tipTxt,"Khinh Công (C)|nLướt tới trước, miễn sát thương. Hồi "+I2S(R2I(zzCF_KHINH_CONG_COOLDOWN()))+" giây.")
    call BlzFrameSetTooltip(vl_b,vl_tip)
    set zzVL_fHero=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_TOPLEFT,.015,.535)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_BOTTOMRIGHT,.365,.155)
    call zzVL_Panel(zzVL_fHero,.018,.532,.362,.158,"VLTK_data\\war3mapImported\\vl_ui_panel.blp",245)
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
        call BlzTriggerRegisterFrameEvent(zzVL_tClick,zzVL_fEqBtn[vl_i],FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetSize(zzVL_fEqBtn[vl_i],LoadReal(zzVL_ht,0,472),LoadReal(zzVL_ht,0,472))
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,470),LoadReal(zzVL_ht,0,471)-vl_i*LoadReal(zzVL_ht,0,473))
        set zzVL_fEqIco[vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[vl_i],"",0)
        // icon thụt vào inset mỗi cạnh (config.py mục 16 EQUIP_UI) để nằm gọn giữa khung ô
        call BlzFrameSetPoint(zzVL_fEqIco[vl_i],FRAMEPOINT_TOPLEFT,zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,474),-LoadReal(zzVL_ht,0,474))
        call BlzFrameSetPoint(zzVL_fEqIco[vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[vl_i],FRAMEPOINT_BOTTOMRIGHT,-LoadReal(zzVL_ht,0,474),LoadReal(zzVL_ht,0,474))
        call BlzFrameSetTexture(zzVL_fEqIco[vl_i],"VLTK_data\\war3mapImported\\vl_eq_"+I2S(vl_i+1)+".blp",0,true)
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
        call BlzTriggerRegisterFrameEvent(zzVL_tClick,zzVL_fEqBtn[5+vl_i],FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetSize(zzVL_fEqBtn[5+vl_i],LoadReal(zzVL_ht,0,482),LoadReal(zzVL_ht,0,482))
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[5+vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,480),LoadReal(zzVL_ht,0,481)-vl_i*LoadReal(zzVL_ht,0,483))
        set zzVL_fEqIco[5+vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[5+vl_i],"",0)
        // icon thụt vào inset mỗi cạnh (config.py mục 16 EQUIP_UI) để nằm gọn giữa khung ô
        call BlzFrameSetPoint(zzVL_fEqIco[5+vl_i],FRAMEPOINT_TOPLEFT,zzVL_fEqBtn[5+vl_i],FRAMEPOINT_TOPLEFT,LoadReal(zzVL_ht,0,484),-LoadReal(zzVL_ht,0,484))
        call BlzFrameSetPoint(zzVL_fEqIco[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,zzVL_fEqBtn[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,-LoadReal(zzVL_ht,0,484),LoadReal(zzVL_ht,0,484))
        call BlzFrameSetTexture(zzVL_fEqIco[5+vl_i],"VLTK_data\\war3mapImported\\vl_eq_"+I2S(6+vl_i)+".blp",0,true)
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
    // (nền đen riêng cho tooltip bị động đã bỏ: làm crash game lúc vào, 09/10/2026)
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
    // khung thứ 2 (món đang mặc) dính sát bên trái khung mô tả chính
    set zzVL_fItemHover2=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,63)
    call BlzFrameSetPoint(zzVL_fItemHover2,FRAMEPOINT_TOPRIGHT,zzVL_fItemHover,FRAMEPOINT_TOPLEFT,-.004,0.)
    call BlzFrameSetSize(zzVL_fItemHover2,.34,.235)
    set zzVL_fItemHover2Txt=BlzCreateFrameByType("TEXT","",zzVL_fItemHover2,"",0)
    call BlzFrameSetPoint(zzVL_fItemHover2Txt,FRAMEPOINT_TOPLEFT,zzVL_fItemHover2,FRAMEPOINT_TOPLEFT,.012,-.012)
    call BlzFrameSetSize(zzVL_fItemHover2Txt,.316,.211)
    call BlzFrameSetTextAlignment(zzVL_fItemHover2Txt,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(zzVL_fItemHover2Txt,.82)
    call BlzFrameSetVisible(zzVL_fItemHover2,false)
    call BlzFrameSetEnable(zzVL_fItemHover2,false)
    call BlzFrameSetEnable(zzVL_fItemHover2Txt,false)
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
    call zzVL_Panel(vl_ui,.66,.552,.79,.528,"VLTK_data\\war3mapImported\\vl_ui_tile.blp",200)
    call zzVL_Panel(vl_ui,.68,.524,.79,.484,"VLTK_data\\war3mapImported\\vl_ui_tile.blp",200)
    set zzVL_fBannerBg=zzVL_Panel(vl_ui,.2,.47,.6,.43,"VLTK_data\\war3mapImported\\vl_ui_tile.blp",220)
    set zzVL_fBanner=BlzCreateFrameByType("TEXT","",zzVL_fBannerBg,"",0)
    call BlzFrameSetAllPoints(zzVL_fBanner,zzVL_fBannerBg)
    call BlzFrameSetTextAlignment(zzVL_fBanner,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(zzVL_fBanner,1.4)
    call BlzFrameSetVisible(zzVL_fBannerBg,false)
    set zzVL_bannerT=CreateTimer()
    call DestroyTimer(GetExpiredTimer())
    set vl_ui=null
endfunction

// Lệnh chat -hd: coi như bấm phím B (mở/đóng Hành Trang).
function zzVL_OnBagChat takes nothing returns nothing
    call zzVL_OnBagKey()
endfunction
// ---- -tt: what the player has

// Lệnh chat -tt: hiện thông tin bản thân (hệ, bộ trang bị, công trạng, quan ấn, phi phong và mốc kế tiếp).
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

// Thông báo chào mừng gửi toàn server lúc đầu trận, giới thiệu các hệ thống mới của bản 1.31.
function zzVL_Hello takes nothing returns nothing
    call zzVL_All("|cffffcc00Võ Lâm Truyền Kỳ 1.31|r: có thêm |cff00ccffbộ trang bị theo hệ|r, |cff00ccffngũ hành cho đánh thường|r, |cff00ccffquân hàm và phi phong|r, |cff00ccffcao thủ xuất hiện ngẫu nhiên|r, |cff00ccffnhiệm vụ của Sứ Giả Võ Lâm|r (bấm chọn ông ấy cạnh căn cứ). Chiêu hồi nhanh |cff00ccfftự thi triển|r khi giao chiến (-auto bật/tắt). Gõ |cffffcc00-tt|r (bản thân), |cffffcc00-gd|r (sự kiện), F9 để đọc hướng dẫn.")
endfunction

// Lệnh chat -sm/-tp/-tt <số>: dùng Kim Nguyên Bảo mua thẳng Sức mạnh/Thân pháp/Nội công (1 KNB = 1 điểm).
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
// Lệnh GM / Test: -lvl [cấp], -maxlvl, -rex, -gold [số], -knb [số], -ithb (tặng Hòa Thị Bích)
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
    elseif msg == "-ithb" then
        if zzVL_BagAdd(pid,CreateItem('ITHB',GetUnitX(hero),GetUnitY(hero))) then
            call zzVL_Msg(pid,"|cff00ff00[GM]|r Đã tặng 1 Tần Lăng Hòa Thị Bích vào hành trang.")
        else
            call zzVL_Msg(pid,"|cffff0000Hành trang đã đầy; không thể nhận Hòa Thị Bích.|r")
        endif
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

// Khai báo các mục hiển thị trong bảng Quest (F9): hướng dẫn bộ trang bị/ngũ hành/quan ấn, hành trang/trang bị,
// phi phong/cao thủ, trấn phái/rơi đồ, cường hóa/khảm — toàn là văn bản mô tả, không có logic xử lý.
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
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: bấm phím B (hoặc nút Hành Trang, gõ -hd), 60 ô, bấm vào món để mặc hoặc dùng.|n|cffffcc00Trang bị|r: bấm phím I xem 10 ô trên người (Nón, Áo, Yêu Đái, Hộ Uyển, Hài, Vũ Khí, Hạng Liên, Giới Chỉ, Ngọc Bội, Hộ Thân Phù). Bấm nút + cạnh ô để cường hóa bằng Huyền tinh, bấm Khảm để gắn bảo thạch.|n|cffffcc00Nhiệm vụ|r: đưa tướng tới gần Sứ Giả Võ Lâm (cạnh căn cứ) rồi bấm chọn ông ấy. Xong được Huyền tinh, ngân lượng, công trạng; cứ 5 nhiệm vụ thêm 2 Huyền tinh. Gõ -nv để xem.|n|cffffcc00Đánh quái|r: cả phe cùng nhận vàng, đồng đội ở xa cũng nhận kinh nghiệm, không cần đánh phát cuối.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Phi phong và cao thủ (1.31)")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNCloak.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Phi phong|r (15 bậc: Siêu Phàm ... Thần Thoại) và |cffffcc00Quan ấn|r (8 bậc: Trí Sự ... Hoàng Đế) lên bậc theo công trạng; phi phong cộng sinh lực, phòng thủ, thuộc tính và hiện danh hiệu trên đầu, quan ấn cộng sát thương. Gõ -tt để xem mốc kế tiếp.|n|cffffcc00Tuyệt đại cao thủ|r: cứ 7 phút xuất hiện một lần ở khu quái (có chấm trên bản đồ nhỏ). Hạ được: 2 Huyền tinh, 1000 ngân lượng (đồng đội 300), 25 công trạng.|n|cffffcc00Võ Lâm Minh Chủ|r: cứ 18 phút xuất hiện một lần (nếu Minh Chủ trước đã bị hạ). Phe hạ được +10 uy danh, mỗi người 1000 ngân lượng.|n|cffffcc00Hạ tướng|r: mỗi lần +300 ngân lượng. |cffffcc00Nhất đao đoạt mạng|r: hạ tướng đầu tiên của trận thêm 500 ngân lượng, 10 công trạng.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Trấn phái, rơi đồ, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNScrollUber.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Trấn phái|r: kỹ năng thứ 11 của môn phái (võ công KVCT, tướng cấp 88 mở, mỗi cấp tự cộng điểm, tối đa cấp 10 khi tướng cấp 200) chính là kỹ năng trấn phái.|n|cffffcc00Rơi đồ|r: mỗi món trang bị chỉ rơi 5 lần mỗi trận, sau đó rơi món khác. Nguyên liệu rơi không giới hạn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Cường hóa, khảm, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNInventory.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: nguyên liệu cùng loại tự cộng dồn. Bật Tách rồi bấm để chia đôi, bật Bán rồi bấm để bán ngay. |cffffcc00Cường hóa|r: nhặt Huyền Tinh, mở Nhân Vật bằng C rồi bấm nút + cạnh ô đồ. Tối đa +10; thất bại không tụt cấp và bảo hiểm tính riêng từng món. Bật Khảm, bấm nguyên liệu rồi bấm trang bị: mỗi trang bị 2 lỗ.")
    set vl_q=null
endfunction
// ---- tien khoi dau: moi nguoi choi 1000 vang

// Lúc bắt đầu trận: phát 1000 vàng khởi điểm cho mỗi người chơi và chỉnh khoảng cách camera mặc định.
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

// Phát nhạc nền của map (gọi một lần sau 3 giây khi vào trận).
function zzVL_Music takes nothing returns nothing
    call SetMusicVolume(127)
    call ClearMapMusic()
    call SetMapMusic("VLTK_data\\war3mapImported\\vl_nhacnen.mp3",true,0)
    call PlayMusic("VLTK_data\\war3mapImported\\vl_nhacnen.mp3")
    call zzVL_Log("nhac: PlayMusic")
    call DestroyTimer(GetExpiredTimer())
endfunction

// Phím Tab: xoá hết tin nhắn/thông báo đang hiện trên màn hình của người chơi local.
function zzVL_OnTabKey takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call ClearTextMessages()
    endif
endfunction

// Phím C: thực thi khinh công cho tướng của người chơi bấm phím.
function zzVL_OnKinhCongKey takes nothing returns nothing
    call zzVL_KinhCong(GetPlayerId(GetTriggerPlayer()))
endfunction

// Điểm khởi tạo chính của toàn bộ hệ thống gameplay 1.31: tạo hashtable dùng chung, khởi tạo các module con (kỹ
// năng, UI, GM, Thủ Khố...), đăng ký mọi trigger sự kiện/phím tắt/lệnh chat, và bắt đầu các timer lặp định kỳ
// (hành trang, tự nhặt, auto-cast, AI, đồng hồ trận, log...).
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
    call ExecuteFunc("zzDR_Init")
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
    call TriggerAddAction(vl_t,function zzVL_OnCuongHoaCast)
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
        call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-ithb",true)
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
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_B,0,false)
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
        call TriggerRegisterPlayerEvent(vl_t,Player(vl_i),EVENT_PLAYER_MOUSE_MOVE)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnMouseMove)
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
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_I,0,false)
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
    call TimerStart(CreateTimer(),zzCF_CATCHUP_MINUTES()*60.,true,function zzVL_CatchUp)
    call TimerStart(CreateTimer(),.04,true,function zzVL_TagTick)
    call TimerStart(CreateTimer(),20.,false,function zzVL_Hello)
    call TimerStart(CreateTimer(),1.,true,function zzVL_EventTick)
    call TimerStart(CreateTimer(),2.,true,function zzVL_LogFlush)
    call zzVL_Quest()
    set vl_t=null
endfunction
// ===== end gameplay 1.31 =====
