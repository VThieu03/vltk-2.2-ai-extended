// ---- vung farm Thien Kiem: Xa Phu, bai quai, quai de danh hon, roi them do, dong thuoc tinh ngau nhien

// ==========================================
// Hàm: zzVL_AffixName
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_k (integer)
// Trả về dữ liệu kiểu: string
function zzVL_AffixName takes integer vl_k returns string
    if vl_k==1 then
        return "Hút sinh lực"
    elseif vl_k==2 then
        return "Hút nội lực"
    elseif vl_k==3 then
        return "Bạo kích"
    elseif vl_k==4 then
        return "Tốc đánh"
    elseif vl_k==5 then
        return "Sát thương"
    elseif vl_k==6 then
        return "Giảm sát thương nhận"
    elseif vl_k==7 then
        return "Sinh lực"
    elseif vl_k==8 then
        return "Sức mạnh"
    elseif vl_k==9 then
        return "Thân pháp"
    elseif vl_k==10 then
        return "Nội công"
    elseif vl_k==11 then
        return "Kháng vật lý"
    elseif vl_k==12 then
        return "Kháng độc"
    elseif vl_k==13 then
        return "Kháng thủy"
    elseif vl_k==14 then
        return "Kháng hỏa"
    elseif vl_k==15 then
        return "Kháng lôi"
    elseif vl_k==16 then
        return "Tốc độ xuất chiêu"
    elseif vl_k==17 then
        return "Sát thương vật lý nội công"
    elseif vl_k==18 then
        return "Sát thương vật lý ngoại công"
    elseif vl_k==19 then
        return "Điểm đánh trúng"
    elseif vl_k==20 then
        return "Né tránh"
    elseif vl_k==21 then
        return "Tốc độ di chuyển"
    elseif vl_k==22 then
        return "tất cả kỹ năng +1"
    endif
    return ""
endfunction

// ==========================================
// Hàm: zzVL_RollAffix
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_RollAffix takes item vl_item returns nothing
    local integer vl_id=GetHandleId(vl_item)
    local integer vl_n=0
    local integer vl_r=GetRandomInt(1,100)
    local integer vl_k
    local integer vl_v
    local string vl_string=""
    local integer vl_slot=zzEQ_Slot(GetItemTypeId(vl_item))
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10<1 or LoadInteger(zzVL_ht,vl_id,29)>0 then
        return
    endif
    call SaveInteger(zzVL_ht,vl_id,29,1)
    // 1-3 dòng ngẫu nhiên (zzEQ_LineCount), mỗi dòng có giá trị ngẫu nhiên min..max (zzEQ_AffixMin / zzEQ_AffixMax)
    set vl_n=zzEQ_LineCount()
    loop
        exitwhen vl_n<=0
        set vl_k=zzEQ_PickAffix(vl_slot)
        exitwhen vl_k==0
        if zzIT_Line(vl_id,vl_k)==0 then
            set vl_v=GetRandomInt(zzEQ_AffixMin(vl_k),zzEQ_AffixMax(vl_k))
            call zzIT_SetLine(vl_id,vl_k,vl_v)

            if vl_k == 22 then
                set vl_string=vl_string+"|n|cff00ff00"+zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+" cấp|r"
            elseif vl_k == 19 or vl_k == 20 then
                set vl_string=vl_string+"|n|cff00ff00"+zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+"|r"
            elseif vl_k == 17 or vl_k == 18 or vl_k == 21 then
                set vl_string=vl_string+"|n|cff00ff00"+zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+"|r"
            else
                set vl_string=vl_string+"|n|cff00ff00"+zzVL_AffixName(vl_k)+" +"+I2S(vl_v)+"%|r"
            endif
        endif
        set vl_n=vl_n-1
    endloop
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10!=3 then
        set vl_k=GetRandomInt(1,5)
        call zzIT_Set(vl_id,zzIT_DO_CO(),vl_k)
        set vl_string=vl_string+"|n|cffffcc00Hệ|r "+zzVL_hn[vl_k]+": giảm 3% sát thương nhận, +150 sinh lực, +2% sát thương"
    endif
    if vl_string!="" then
        call BlzSetItemName(vl_item,GetItemName(vl_item)+" |cff00ff00*|r")
        call BlzSetItemDescription(vl_item,BlzGetItemDescription(vl_item)+"|n"+vl_string)
        call BlzSetItemExtendedTooltip(vl_item,BlzGetItemExtendedTooltip(vl_item)+"|n"+vl_string)
    endif
endfunction

// ==========================================
// Hàm: zzVL_AiGear
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_hero (unit)
//   - vl_n (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_AiGear takes unit vl_hero,item vl_n returns nothing
    local integer vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_n),0)
    local integer vl_i=0
    local integer vl_o
    local item vl_item
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_v<10 or vl_v>=50 or GetPlayerController(GetOwningPlayer(vl_hero))!=MAP_CONTROL_COMPUTER or not IsUnitType(vl_hero,UNIT_TYPE_HERO) then
        return
    endif
    loop
        exitwhen vl_i>9
        set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
        if vl_item!=null and vl_item!=vl_n then
            set vl_o=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
            if vl_o/10==vl_v/10 then
                if vl_o-(vl_o/10)*10>vl_v-(vl_v/10)*10 then
                    call RemoveItem(vl_n)
                    set vl_item=null
                    return
                endif
                call RemoveItem(vl_item)
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_item=null
endfunction

// ==========================================
// Hàm: zzVL_GearScore
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_item (item)
// Trả về dữ liệu kiểu: integer
function zzVL_GearScore takes item vl_item returns integer
    local integer vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
    local integer vl_string=(vl_v-(vl_v/10)*10)*100
    local integer vl_k=1
    loop
        exitwhen vl_k>4
        set vl_string=vl_string+zzIT_Line(GetHandleId(vl_item),vl_k)
        set vl_k=vl_k+1
    endloop
    return vl_string+40*LoadInteger(zzVL_ht,GetHandleId(vl_item),43)+100*zzEQ_Tier(vl_item)
endfunction

// ==========================================
// Hàm: zzVL_TaiPhu
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_TaiPhu takes item vl_item returns nothing
    local integer vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
    local string vl_string
    if vl_v<10 or vl_v>=50 or zzIT_Get(GetHandleId(vl_item),zzIT_TAI_PHU())>0 then
        return
    endif
    call zzIT_Set(GetHandleId(vl_item),zzIT_TAI_PHU(),1)
    set vl_string="|n|cffffcc00Tài phú: "+I2S(zzVL_GearScore(vl_item))+"|r"
    call BlzSetItemDescription(vl_item,BlzGetItemDescription(vl_item)+vl_string)
    call BlzSetItemExtendedTooltip(vl_item,BlzGetItemExtendedTooltip(vl_item)+vl_string)
endfunction

// ==========================================
// Hàm: zzVL_AutoSellItem
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_playerId (integer)
//   - vl_hero (unit)
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_AutoSellItem takes integer vl_playerId,unit vl_hero,item vl_item returns nothing
    local integer vl_g=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),41)
    if vl_g<=0 then
        set vl_g=10+25*GetItemLevel(vl_item)
    endif
    call zzVL_Msg(vl_playerId,"Tự bán "+GetItemName(vl_item)+": |cffffcc00+"+I2S(vl_g)+"|r ngân lượng.")
    call UnitRemoveItem(vl_hero,vl_item)
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_item))
    call RemoveItem(vl_item)
    call AdjustPlayerStateBJ(vl_g,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
endfunction

// ==========================================
// Hàm: zzVL_AutoGear
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_hero (unit)
//   - vl_n (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_AutoGear takes unit vl_hero,item vl_n returns nothing
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_n),0)
    local integer vl_i=0
    local item vl_item
    local item vl_old=null
    local integer vl_o
    if vl_playerId>9 or not zzVL_autoSell[vl_playerId] or vl_hero!=Jx[vl_playerId+1] or vl_v<10 or vl_v>=50 or LoadInteger(zzVL_ht,GetItemTypeId(vl_n),1)>0 or zzIT_Get(GetHandleId(vl_n),zzIT_MOI_ROI())==0 then
        return
    endif
    call zzIT_Set(GetHandleId(vl_n),zzIT_MOI_ROI(),0)
    loop
        exitwhen vl_i>9
        set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
        if vl_item!=null and vl_item!=vl_n then
            set vl_o=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
            if vl_o/10==vl_v/10 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),1)==0 then
                set vl_old=vl_item
            endif
        endif
        set vl_i=vl_i+1
    endloop
    if vl_old==null then
        set vl_item=null
        return
    endif
    if zzVL_GearScore(vl_n)>zzVL_GearScore(vl_old) then
        call zzVL_Msg(vl_playerId,"|cff00ff00Đã mặc "+GetItemName(vl_n)+" (tài phú "+I2S(zzVL_GearScore(vl_n))+" > "+I2S(zzVL_GearScore(vl_old))+").|r")
        if LoadInteger(zzVL_ht,GetHandleId(vl_old),43)==0 then
            call zzVL_AutoSellItem(vl_playerId,vl_hero,vl_old)
        endif
    elseif LoadInteger(zzVL_ht,GetHandleId(vl_n),43)==0 then
        call zzVL_AutoSellItem(vl_playerId,vl_hero,vl_n)
    endif
    set vl_item=null
    set vl_old=null
endfunction

// ==========================================
// Hàm: zzVL_OnAffixPickup
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAffixPickup takes nothing returns nothing
    call zzEQ_Touch(GetManipulatedItem())
    call zzVL_AiGear(GetTriggerUnit(),GetManipulatedItem())
    call zzVL_RollAffix(GetManipulatedItem())
    call zzVL_TaiPhu(GetManipulatedItem())
    call zzVL_AutoGear(GetTriggerUnit(),GetManipulatedItem())
endfunction

// ==========================================
// Hàm: zzVL_CuongIcon
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_item (item)
//   - vl_lv (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_CuongIcon takes item vl_item,integer vl_lv returns nothing
    local integer vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
    local integer vl_t=vl_v-(vl_v/10)*10
    local integer vl_c=1+vl_lv/3
    local string vl_p
    if vl_lv>=10 then
        set vl_c=5
    endif
    if vl_c>vl_t then
        set vl_t=vl_c
    endif
    if vl_t>5 then
        set vl_t=5
    endif
    set vl_p=LoadStr(zzVL_ht,GetItemTypeId(vl_item),46+vl_t)
    if vl_p!=null and vl_p!="" and BlzGetItemIconPath(vl_item)!=vl_p then
        call BlzSetItemIconPath(vl_item,vl_p)
    endif
    set vl_p=null
endfunction

// ==========================================
// Hàm: zzVL_GetScale
// Chức năng dự kiến: Hệ số scale cường hóa (đơn vị: %)
// Tham số:
//   - vl_n (integer)
// Trả về dữ liệu kiểu: integer
function zzVL_GetScale takes integer vl_n returns integer
    if vl_n <= 0 then
        return 100
    endif
    return 100 + 30 * vl_n
endfunction

// ==========================================
// Hàm: zzVL_CuongTip
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_item (item)
//   - vl_k (integer)
//   - vl_t (integer)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_CuongTip takes item vl_item,integer vl_k,integer vl_t,integer vl_n returns nothing
    local integer vl_id=GetHandleId(vl_item)
    local string vl_string
    if LoadInteger(zzVL_ht,vl_id,55)==vl_n+1 then
        return
    endif
    if LoadInteger(zzVL_ht,vl_id,55)==-1 and vl_n<=0 and vl_t==0 then
        call SaveInteger(zzVL_ht,vl_id,55,1)
        call BlzSetItemDescription(vl_item,LoadStr(zzVL_ht,vl_id,54))
        call BlzSetItemExtendedTooltip(vl_item,LoadStr(zzVL_ht,vl_id,56))
        return
    endif
    if LoadInteger(zzVL_ht,vl_id,55)==0 then
        call SaveStr(zzVL_ht,vl_id,54,BlzGetItemDescription(vl_item))
        call SaveStr(zzVL_ht,vl_id,56,BlzGetItemExtendedTooltip(vl_item))
    endif
    call SaveInteger(zzVL_ht,vl_id,55,vl_n+1)
    if vl_k==1 then
        set vl_string="|n|cffffcc00Cơ bản|r: +"+I2S((2+vl_t)*2 * zzVL_GetScale(vl_n) / 100)+" Sức mạnh, Thân pháp, Nội công"
    elseif vl_k==2 then
        set vl_string="|n|cffffcc00Cơ bản|r: +"+I2S(vl_t * zzVL_GetScale(vl_n) / 100)+" giáp, giảm "+I2S(2 * zzVL_GetScale(vl_n) / 100)+"% sát thương nhận"
    elseif vl_k==3 then
        set vl_string="|n|cffffcc00Cơ bản|r: +"+I2S(6*vl_t * zzVL_GetScale(vl_n) / 100)+" sát thương gốc, +"+I2S(4 * zzVL_GetScale(vl_n) / 100)+"% sát thương"
    elseif vl_k==4 then
        set vl_string="|n|cffffcc00Cơ bản|r: +"+I2S(100*vl_t * zzVL_GetScale(vl_n) / 100)+" sinh lực, +"+I2S(5 * zzVL_GetScale(vl_n) / 100)+" tốc chạy"
    else
        set vl_string=""
    endif
    if vl_n > 0 then
        set vl_string = "|n|cff00ffff[Cường hóa +"+I2S(vl_n)+"]|r (Hệ số: "+I2S(zzVL_GetScale(vl_n))+"%)" + vl_string
    endif
    call BlzSetItemDescription(vl_item,LoadStr(zzVL_ht,vl_id,54)+vl_string)
    call BlzSetItemExtendedTooltip(vl_item,LoadStr(zzVL_ht,vl_id,56)+vl_string)
    set vl_string=null
endfunction

// ==========================================
// Hàm: zzVL_AffixSum
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_AffixSum takes integer vl_playerId returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_t
    local integer vl_v
    local integer vl_n
    local integer vl_i=0
    local integer vl_k
    local integer vl_id
    local real vl_base
    local integer vl_scale
    call zzPS_Set(vl_playerId,zzPS_KHANG_VL(),0)
    call zzPS_Set(vl_playerId,zzPS_KHANG_DOC(),0)
    call zzPS_Set(vl_playerId,zzPS_KHANG_THUY(),0)
    call zzPS_Set(vl_playerId,zzPS_KHANG_HOA(),0)
    call zzPS_Set(vl_playerId,zzPS_KHANG_LOI(),0)
    call zzPS_Set(vl_playerId,zzPS_TOC_XUAT_CHIEU(),0)
    call zzPS_Set(vl_playerId,zzPS_STVL_NOI(),0)
    call zzPS_Set(vl_playerId,zzPS_STVL_NGOAI(),0)
    call zzPS_Set(vl_playerId,zzPS_DANH_TRUNG(),0)
    call zzPS_Set(vl_playerId,zzPS_NE_TRANH(),0)
    call zzPS_Set(vl_playerId,zzPS_CAP_KY_NANG(),0)
    loop
        exitwhen vl_i>13
        set zzVL_af[vl_playerId*16+vl_i]=zzKS_af[vl_playerId*16+vl_i]
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null then
            set vl_id=GetHandleId(zzVL_equipItem[vl_playerId*10+vl_i])
            set vl_k=1
            loop
                exitwhen vl_k>22
                // random lines grow with the enhancement of the item (zzEQ_LineValue)
                set vl_v=zzEQ_LineValue(zzVL_equipItem[vl_playerId*10+vl_i],vl_k,zzIT_Line(vl_id,vl_k))
                if vl_k <= 10 then
                    set zzVL_af[vl_playerId*16+vl_k]=zzVL_af[vl_playerId*16+vl_k]+vl_v
                elseif vl_k == 21 then
                    set zzVL_af[vl_playerId*16+13]=zzVL_af[vl_playerId*16+13]+vl_v
                else
                    call zzPS_Add(vl_playerId,vl_k,vl_v)
                endif
                set vl_k=vl_k+1
            endloop
            if zzIT_Get(vl_id,zzIT_DO_CO())>0 then
                set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+3
                set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+150
                set zzVL_af[vl_playerId*16+5]=zzVL_af[vl_playerId*16+5]+2
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and zzEQ_IsKv(GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i])) then
            call zzEQ_AddStats(vl_playerId,zzVL_equipItem[vl_playerId*10+vl_i])
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and not zzEQ_IsKv(GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i])) then
            set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)/10
            if vl_k>=1 and vl_k<=4 then
                if vl_k==1 then
                    call zzVL_CuongIcon(zzVL_equipItem[vl_playerId*10+vl_i],zzVL_cuong[vl_playerId*10+0])
                elseif vl_k==2 then
                    call zzVL_CuongIcon(zzVL_equipItem[vl_playerId*10+vl_i],zzVL_cuong[vl_playerId*10+1])
                elseif vl_k==3 then
                    call zzVL_CuongIcon(zzVL_equipItem[vl_playerId*10+vl_i],zzVL_cuong[vl_playerId*10+5])
                elseif vl_k==4 then
                    call zzVL_CuongIcon(zzVL_equipItem[vl_playerId*10+vl_i],zzVL_cuong[vl_playerId*10+4])
                endif
            endif
            set vl_t=LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)-vl_k*10
            if vl_k>=1 and vl_k<=4 then
                if vl_k==1 then
                    set vl_n=zzVL_cuong[vl_playerId*10+0]
                elseif vl_k==2 then
                    set vl_n=zzVL_cuong[vl_playerId*10+1]
                elseif vl_k==3 then
                    set vl_n=zzVL_cuong[vl_playerId*10+5]
                elseif vl_k==4 then
                    set vl_n=zzVL_cuong[vl_playerId*10+4]
                endif
                call zzVL_CuongTip(zzVL_equipItem[vl_playerId*10+vl_i],vl_k,vl_t,vl_n)
                set vl_scale = zzVL_GetScale(vl_n)
            endif
            if vl_k==1 then
                set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+(2+vl_t)*2 * vl_scale / 100
                set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+(2+vl_t)*2 * vl_scale / 100
                set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+(2+vl_t)*2 * vl_scale / 100
            elseif vl_k==2 then
                set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+2 * vl_scale / 100
                set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+vl_t * vl_scale / 100
            elseif vl_k==3 then
                set zzVL_af[vl_playerId*16+5]=zzVL_af[vl_playerId*16+5]+4 * vl_scale / 100
                set zzVL_af[vl_playerId*16+12]=zzVL_af[vl_playerId*16+12]+6*vl_t * vl_scale / 100
            elseif vl_k==4 then
                set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+100*vl_t * vl_scale / 100
                set zzVL_af[vl_playerId*16+13]=zzVL_af[vl_playerId*16+13]+5 * vl_scale / 100
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_n=zzEQ_SlotLv(vl_playerId,0)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+vl_n*2
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+vl_n*2
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+vl_n*2
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+vl_n*100
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,1)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+vl_n*1
        call zzPS_Add(vl_playerId,zzPS_KHANG_VL(),vl_n*2)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,2)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+vl_n*150
        call zzPS_Add(vl_playerId,zzPS_KHANG_DOC(),vl_n*2)
        call zzPS_Add(vl_playerId,zzPS_KHANG_THUY(),vl_n*2)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,3)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+4]=zzVL_af[vl_playerId*16+4]+vl_n*3
        call zzPS_Add(vl_playerId,zzPS_KHANG_HOA(),vl_n*2)
        call zzPS_Add(vl_playerId,zzPS_KHANG_LOI(),vl_n*2)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,4)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+13]=zzVL_af[vl_playerId*16+13]+vl_n*3
        call zzPS_Add(vl_playerId,zzPS_NE_TRANH(),vl_n*15)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,5)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+5]=zzVL_af[vl_playerId*16+5]+vl_n*3
        call zzPS_Add(vl_playerId,zzPS_STVL_NGOAI(),vl_n*20)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,6)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+3]=zzVL_af[vl_playerId*16+3]+vl_n*1
        call zzPS_Add(vl_playerId,zzPS_STVL_NOI(),vl_n*20)
        call zzPS_Add(vl_playerId,zzPS_TOC_XUAT_CHIEU(),vl_n*2)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,7)
    if vl_n>0 then
        call zzPS_Add(vl_playerId,zzPS_DANH_TRUNG(),vl_n*15)
        set zzVL_af[vl_playerId*16+1]=zzVL_af[vl_playerId*16+1]+vl_n*1
        set zzVL_af[vl_playerId*16+5]=zzVL_af[vl_playerId*16+5]+vl_n*1
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,8)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+2]=zzVL_af[vl_playerId*16+2]+vl_n*1
        call zzPS_Add(vl_playerId,zzPS_KHANG_VL(),vl_n*1)
        call zzPS_Add(vl_playerId,zzPS_KHANG_DOC(),vl_n*1)
        call zzPS_Add(vl_playerId,zzPS_KHANG_THUY(),vl_n*1)
        call zzPS_Add(vl_playerId,zzPS_KHANG_HOA(),vl_n*1)
        call zzPS_Add(vl_playerId,zzPS_KHANG_LOI(),vl_n*1)
    endif
    set vl_n=zzEQ_SlotLv(vl_playerId,9)
    if vl_n>0 then
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+vl_n*200
        set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+vl_n*1
        if vl_n>=10 then
            call zzPS_Add(vl_playerId,zzPS_CAP_KY_NANG(),1)
        endif
    endif
    set zzVL_wel[vl_playerId]=0
    set vl_i=0
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),66)>0 then
            set zzVL_wel[vl_playerId]=LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),66)
        endif
        set vl_i=vl_i+1
    endloop
    if zzVL_wel[vl_playerId]==1 then
        set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+8
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+300
    endif
    if zzVL_rank[vl_playerId]==1 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+4
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+1
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+1
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+1
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+200
    elseif zzVL_rank[vl_playerId]==2 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+8
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+2
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+2
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+2
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+400
    elseif zzVL_rank[vl_playerId]==3 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+12
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+4
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+4
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+4
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+400
    elseif zzVL_rank[vl_playerId]==4 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+16
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+6
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+6
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+6
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+600
    elseif zzVL_rank[vl_playerId]==5 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+20
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+8
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+8
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+8
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+800
    endif
    if zzVL_bcd[vl_playerId]<=0. then
        set zzVL_bcd[vl_playerId]=BlzGetUnitAttackCooldown(vl_hero,0)
    endif
    if zzVL_af[vl_playerId*16+4]!=zzVL_asNow[vl_playerId] and zzVL_bcd[vl_playerId]>0. then
        set zzVL_asNow[vl_playerId]=zzVL_af[vl_playerId*16+4]
        set vl_base=zzVL_bcd[vl_playerId]/(1.+zzVL_af[vl_playerId*16+4]/100.)
        call BlzSetUnitAttackCooldown(vl_hero,vl_base,0)
    endif

    // Tốc độ xuất chiêu (16)
    call SetUnitTimeScale(vl_hero, 1.0 + zzPS_Get(vl_playerId,zzPS_TOC_XUAT_CHIEU()) / 100.0)

    set vl_k=7
    loop
        exitwhen vl_k>13
        set vl_i=zzVL_af[vl_playerId*16+vl_k]-zzVL_kNow[vl_playerId*16+vl_k]
        if vl_i!=0 and GetWidgetLife(vl_hero)>.405 then
            set zzVL_kNow[vl_playerId*16+vl_k]=zzVL_af[vl_playerId*16+vl_k]
            if vl_k==7 then
                call BlzSetUnitMaxHP(vl_hero,BlzGetUnitMaxHP(vl_hero)+vl_i)
            elseif vl_k==8 then
                call SetHeroStr(vl_hero,GetHeroStr(vl_hero,false)+vl_i,true)
            elseif vl_k==9 then
                call SetHeroAgi(vl_hero,GetHeroAgi(vl_hero,false)+vl_i,true)
            elseif vl_k==10 then
                call SetHeroInt(vl_hero,GetHeroInt(vl_hero,false)+vl_i,true)
            elseif vl_k==11 then
                call BlzSetUnitArmor(vl_hero,BlzGetUnitArmor(vl_hero)+vl_i)
            elseif vl_k==12 then
                call BlzSetUnitBaseDamage(vl_hero,BlzGetUnitBaseDamage(vl_hero,0)+vl_i,0)
            else
                call SetUnitMoveSpeed(vl_hero,GetUnitMoveSpeed(vl_hero)+vl_i)
            endif
        endif
        set vl_k=vl_k+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_DropGear
// Chức năng: Rớt ngẫu nhiên trang bị theo tier
function zzVL_DropGear takes integer vl_tier, integer vl_drops, real vl_x, real vl_y returns nothing
    local integer vl_n = zzVL_gearN[vl_tier]
    local integer vl_k_loop
    local integer vl_i
    local integer vl_g
    if vl_n <= 0 then
        return
    endif
    loop
        exitwhen vl_drops <= 0
        set vl_k_loop = GetRandomInt(0, vl_n - 1)
        set vl_i = 0
        loop
            exitwhen vl_i >= vl_n
            set vl_g = zzVL_gear[vl_tier * 200 + ModuloInteger(vl_k_loop + vl_i, vl_n)]
            if LoadInteger(zzVL_ht, vl_g, 42) < 5 then
                call SaveInteger(zzVL_ht, vl_g, 42, LoadInteger(zzVL_ht, vl_g, 42) + 1)
                call SaveInteger(zzVL_ht, GetHandleId(CreateItem(vl_g, vl_x + GetRandomReal(-40, 40), vl_y + GetRandomReal(-40, 40))), 73, 1)
                set vl_i = vl_n
            endif
            set vl_i = vl_i + 1
        endloop
        set vl_drops = vl_drops - 1
    endloop
endfunction

// ==========================================
// Hàm: zzVL_CampSpawn
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_c (integer)
//   - vl_type (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_CampSpawn takes integer vl_c,integer vl_type returns nothing
    local unit vl_unit=CreateUnit(Player(12),vl_type,zzVL_cX[vl_c]+GetRandomReal(-120,120),zzVL_cY[vl_c]+GetRandomReal(-120,120),GetRandomReal(0,360))
    local integer vl_level=zzVL_cLevel[vl_c]
    local real vl_hpMul=1.
    local real vl_dmgMul=1.
    local real vl_hp=500.+I2R(vl_level)*110.
    local real vl_dmg=10.+I2R(vl_level)*2.
    local integer vl_specialKey=12000+vl_c
    local integer vl_rand=100
    local integer vl_elite = 0
    local effect vl_eff

    call SaveInteger(zzVL_ht,GetHandleId(vl_unit),9,vl_c+1)

    // Mỗi bãi chỉ có tối đa một Tinh Anh / Thủ Lĩnh còn sống trong cùng một đợt spawn.
    if LoadInteger(zzVL_ht,vl_specialKey,0)==0 then
        set vl_rand=GetRandomInt(1,100)
    endif
    if vl_rand <= 2 then
        set vl_elite = 2
        call SaveInteger(zzVL_ht,vl_specialKey,0,1)
        set vl_hpMul=4.0
        set vl_dmgMul=2.2
        call SetUnitScale(vl_unit, 1.5, 1.5, 1.5)
        call SetUnitVertexColor(vl_unit, 255, 100, 100, 255)
        set vl_eff = AddSpecialEffectTarget("Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget.mdl", vl_unit, "overhead")
        call SaveEffectHandle(zzVL_ht, GetHandleId(vl_unit), 11, vl_eff)
    elseif vl_rand <= 12 then
        set vl_elite = 1
        call SaveInteger(zzVL_ht,vl_specialKey,0,1)
        set vl_hpMul=2.0
        set vl_dmgMul=1.5
        call SetUnitScale(vl_unit, 1.25, 1.25, 1.25)
        call SetUnitVertexColor(vl_unit, 100, 255, 100, 255)
        set vl_eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl", vl_unit, "origin")
        call SaveEffectHandle(zzVL_ht, GetHandleId(vl_unit), 11, vl_eff)
    endif

    if vl_elite > 0 then
        call SaveInteger(zzVL_ht, GetHandleId(vl_unit), 10, vl_elite)
    endif

    call BlzSetUnitDiceNumber(vl_unit,0,0)
    call BlzSetUnitDiceSides(vl_unit,0,0)
    call BlzSetUnitMaxHP(vl_unit,R2I(vl_hp*vl_hpMul))
    call SetWidgetLife(vl_unit,GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE))
    call BlzSetUnitBaseDamage(vl_unit,R2I(vl_dmg*vl_dmgMul),0)
    call BlzSetUnitArmor(vl_unit,2+vl_level/20)

    set vl_unit=null
    set vl_eff=null
endfunction

// ==========================================
// Hàm: zzVL_CampRespawn
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_CampRespawn takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    call zzVL_CampSpawn(LoadInteger(zzVL_ht,vl_id,0),LoadInteger(zzVL_ht,vl_id,1))
    call FlushChildHashtable(zzVL_ht,vl_id)
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_CampInit
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_CampInit takes nothing returns nothing
    local integer vl_c=0
    local integer vl_k
    loop
        exitwhen vl_c>=zzVL_cN
        set vl_k=0
        loop
            exitwhen vl_k>3
            call zzVL_CampSpawn(vl_c,zzVL_cType[vl_c*4+vl_k])
            set vl_k=vl_k+1
        endloop
        set vl_c=vl_c+1
    endloop
    call DestroyTimer(GetExpiredTimer())
endfunction

// ==========================================
// Hàm: zzVL_CampDeath
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_d (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_CampDeath takes unit vl_d returns nothing
    local integer vl_c=LoadInteger(zzVL_ht,GetHandleId(vl_d),9)-1
    local integer vl_specialKey=12000+vl_c
    local integer vl_elite=LoadInteger(zzVL_ht,GetHandleId(vl_d),10)
    local effect vl_eff=LoadEffectHandle(zzVL_ht,GetHandleId(vl_d),11)
    local unit vl_k=GetKillingUnit()
    local integer vl_pk
    local timer vl_t
    local integer vl_tier
    local integer vl_n
    local integer vl_k_loop
    local integer vl_i
    local integer vl_g
    local integer vl_drops=1
    local real vl_x
    local real vl_y

    if vl_c<0 then
        return
    endif

    if vl_eff!=null then
        call DestroyEffect(vl_eff)
    endif
    if vl_elite>0 then
        call SaveInteger(zzVL_ht,vl_specialKey,0,0)
    endif

    if vl_k!=null and GetPlayerId(GetOwningPlayer(vl_k))<10 then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
        if vl_elite == 1 then
            call AdjustPlayerStateBJ(200, Player(vl_pk), PLAYER_STATE_RESOURCE_GOLD)
            if Jx[vl_pk+1]!=null then
                call AddHeroXP(Jx[vl_pk+1], 300, true)
            endif
        elseif vl_elite == 2 then
            call AdjustPlayerStateBJ(1000, Player(vl_pk), PLAYER_STATE_RESOURCE_GOLD)
            if Jx[vl_pk+1]!=null then
                call AddHeroXP(Jx[vl_pk+1], 1500, true)
            endif
            call zzVL_Msg(vl_pk, "|cffffcc00Đã tiêu diệt Thủ Lĩnh! Nhận thưởng lớn.|r")
        endif
    endif

    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_d))
    set vl_t=CreateTimer()
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),0,vl_c)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,GetUnitTypeId(vl_d))
    call TimerStart(vl_t,25.,false,function zzVL_CampRespawn)
    set vl_t=null

    if vl_elite == 1 then
        set vl_drops = 3
    elseif vl_elite == 2 then
        set vl_drops = 6
    endif


    // the equipment drop of the monster is zzDR_DropKind (gameplay_12_drop.j), called from zzVL_OnDeath before this function
    set vl_eff=null
    set vl_k=null
endfunction

// ==========================================
// Hàm: zzVL_OnCreepEnter
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnCreepEnter takes nothing returns nothing
    local unit vl_unit=GetTriggerUnit()
    local real vl_f=TimerGetElapsed(zzVL_clock)/900.
    if vl_f>1. then
        set vl_f=1.
    endif
    if GetOwningPlayer(vl_unit)==Player(12) and LoadInteger(zzVL_ht,GetHandleId(vl_unit),9)==0 and not IsUnitType(vl_unit,UNIT_TYPE_HERO) and GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE)<5000. then
        call BlzSetUnitMaxHP(vl_unit,R2I(GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE)*.75*(.7+.3*vl_f)))
        call BlzSetUnitBaseDamage(vl_unit,R2I(BlzGetUnitBaseDamage(vl_unit,0)*(.6+.4*vl_f)),0)
        call SetWidgetLife(vl_unit,GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE))
    endif
    set vl_unit=null
endfunction

// ==========================================
// Hàm: zzVL_XpBuild
// Chức năng dự kiến: Chức năng Xa Phu (dịch chuyển).
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_XpBuild takes integer vl_playerId returns nothing
    local integer vl_z=1
    call DialogClear(zzVL_dlg[vl_playerId])
    call DialogSetMessage(zzVL_dlg[vl_playerId],"Xa Phu - đi đâu?")
    set zzVL_dlgB[vl_playerId*16]=DialogAddButton(zzVL_dlg[vl_playerId],"Về căn cứ",0)
    loop
        exitwhen vl_z>zzVL_zN
        if zzVL_zTele[vl_z]>0 then
            set zzVL_dlgB[vl_playerId*16+vl_z+5]=DialogAddButton(zzVL_dlg[vl_playerId],zzVL_zName[vl_z],0)
        endif
        set vl_z=vl_z+1
    endloop
    set zzVL_dlgB[vl_playerId*16+3]=DialogAddButton(zzVL_dlg[vl_playerId],"Lôi Đài (tỷ thí)",0)
    set zzVL_dlgB[vl_playerId*16+4]=DialogAddButton(zzVL_dlg[vl_playerId],"Thôi",0)
endfunction

// ==========================================
// Hàm: zzVL_XpSelect
// Chức năng dự kiến: Chức năng Xa Phu (dịch chuyển).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_XpSelect takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local unit vl_npc=GetTriggerUnit()
    local unit vl_hero
    local integer vl_i=1
    if GetUnitTypeId(vl_npc)!=zzVL_XAPHU or vl_playerId>9 then
        set vl_npc=null
        return
    endif
    set vl_hero=Jx[vl_playerId+1]
    if vl_hero==null or GetWidgetLife(vl_hero)<.405 or not IsUnitInRange(vl_hero,vl_npc,700.) then
        call zzVL_Msg(vl_playerId,"|cffffcc00Xa Phu|r: đưa tướng tới gần ta để đi xe.")
    else
        call zzVL_XpBuild(vl_playerId)
        call DialogDisplay(Player(vl_playerId),zzVL_dlg[vl_playerId],true)
    endif
    set vl_npc=null
    set vl_hero=null
endfunction

// M mở cùng menu Xa Phu ở mọi nơi, không cần vật phẩm Truyền Tống Phù.
function zzVL_XpKey takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local unit vl_hero=Jx[vl_playerId+1]
    if vl_playerId>9 or vl_hero==null or GetWidgetLife(vl_hero)<.405 then
        if vl_playerId<=9 then
            call zzVL_Msg(vl_playerId,"Chưa có tướng sống để truyền tống.")
        endif
    else
        call zzVL_XpBuild(vl_playerId)
        call DialogDisplay(Player(vl_playerId),zzVL_dlg[vl_playerId],true)
    endif
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_XpGo
// Chức năng dự kiến: Chức năng Xa Phu (dịch chuyển).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_XpGo takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local button vl_b=GetClickedButton()
    local unit vl_hero=Jx[vl_playerId+1]
    local real vl_x=0.
    local real vl_y=0.
    local integer vl_i=0
    call zzVL_Log("xa phu")
    if vl_hero==null then
        set vl_b=null
        return
    endif
    if vl_b==zzVL_dlgB[vl_playerId*16] then
        if IsPlayerAlly(Player(vl_playerId),Player(0)) then
            set vl_x=zzVL_homeX[0]
            set vl_y=zzVL_homeY[0]
        else
            set vl_x=zzVL_homeX[1]
            set vl_y=zzVL_homeY[1]
        endif
    else
        set vl_x=GetUnitX(vl_hero)
        set vl_y=GetUnitY(vl_hero)
        set vl_i=1
        loop
            exitwhen vl_i>zzVL_zN
            if zzVL_zTele[vl_i]>0 and vl_b==zzVL_dlgB[vl_playerId*16+vl_i+5] then
                set vl_x=zzVL_zEx[vl_i]
                set vl_y=zzVL_zEy[vl_i]
            endif
            set vl_i=vl_i+1
        endloop
        if vl_b==zzVL_dlgB[vl_playerId*16+3] then
            set vl_x=-2848.
            set vl_y=5616.
            call zzVL_All(zzVL_Name(vl_playerId)+" lên |cffff8000Lôi Đài|r tỷ thí!")
        endif
        if vl_b==zzVL_dlgB[vl_playerId*16+4] then
            set vl_b=null
            set vl_hero=null
            return
        endif
    endif
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(vl_hero),GetUnitY(vl_hero)))
    call SetUnitPosition(vl_hero,vl_x,vl_y)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",vl_x,vl_y))
    if GetLocalPlayer()==Player(vl_playerId) then
        call PanCameraToTimed(vl_x,vl_y,0.)
    endif
    set vl_b=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_PickFind
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_PickFind takes nothing returns nothing
    if GetUnitTypeId(GetEnumUnit())==zzVL_pickT then
        set zzVL_pickU=GetEnumUnit()
    endif
endfunction

// ==========================================
// Hàm: zzVL_PickOpen
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_PickOpen takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_t=GetUnitTypeId(GetTriggerUnit())
    local integer vl_i=0
    local integer vl_c
    if vl_t<'h0E1' or vl_t>'h0E5' or vl_playerId>9 then
        return
    endif
    if Ge==null or de[vl_playerId]!=null then
        call zzVL_Msg(vl_playerId,"Bạn đã có tướng rồi.")
        return
    endif
    call DialogClear(zzVL_pickD[vl_playerId])
    call DialogSetMessage(zzVL_pickD[vl_playerId],GetUnitName(GetTriggerUnit()))
    loop
        set vl_c=LoadInteger(zzVL_ht,vl_t,81+vl_i)
        exitwhen vl_c==0 or vl_i>10
        set zzVL_pickH[vl_playerId*12+vl_i]=LoadInteger(zzVL_ht,vl_c,80)
        set zzVL_pickB[vl_playerId*12+vl_i]=DialogAddButton(zzVL_pickD[vl_playerId],GetObjectName(zzVL_pickH[vl_playerId*12+vl_i]),0)
        set vl_i=vl_i+1
    endloop
    set zzVL_pickB[vl_playerId*12+11]=DialogAddButton(zzVL_pickD[vl_playerId],"Thôi",0)
    set zzVL_pickH[vl_playerId*12+vl_i]=0
    call DialogDisplay(Player(vl_playerId),zzVL_pickD[vl_playerId],true)
endfunction

// ==========================================
// Hàm: zzVL_PickClick
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_PickClick takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local button vl_b=GetClickedButton()
    local integer vl_i=0
    local integer vl_hero=0
    call zzVL_Log("chon tuong p"+I2S(vl_playerId))
    loop
        exitwhen vl_i>10 or zzVL_pickH[vl_playerId*12+vl_i]==0
        if vl_b==zzVL_pickB[vl_playerId*12+vl_i] then
            set vl_hero=zzVL_pickH[vl_playerId*12+vl_i]
        endif
        set vl_i=vl_i+1
    endloop
    set vl_b=null
    if vl_hero==0 or Ge==null or de[vl_playerId]!=null then
        return
    endif
    set zzVL_pickT=vl_hero
    set zzVL_pickU=null
    call ForGroup(Ge,function zzVL_PickFind)
    if zzVL_pickU!=null then
        call jH(zzVL_pickU,Player(vl_playerId))
    endif
    set zzVL_pickU=null
endfunction

// ==========================================
// Hàm: zzVL_HideHall
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_HideHall takes nothing returns nothing
    call ShowUnit(GetEnumUnit(),false)
endfunction

// ==========================================
// Hàm: zzVL_PickInit
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_PickInit takes nothing returns nothing
    local integer vl_e=1
    local integer vl_i
    local unit vl_n
    local trigger vl_t=CreateTrigger()
    call DestroyTimer(GetExpiredTimer())
    set zzVL_tPick=CreateTrigger()
    if Ge==null then
        set vl_t=null
        return
    endif
    call ForGroup(Ge,function zzVL_HideHall)
    loop
        exitwhen vl_e>5
        set vl_n=CreateUnit(Player(15),'h0E1'+vl_e-1,-2450.+200.*(vl_e-1),-3000.,270.)
        call SetUnitInvulnerable(vl_n,true)
        call SaveUnitHandle(zzVL_ht,'h0E0',vl_e,vl_n)
        set vl_e=vl_e+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>9
        set zzVL_pickD[vl_i]=DialogCreate()
        call TriggerRegisterDialogEvent(vl_t,zzVL_pickD[vl_i])
        call TriggerRegisterPlayerSelectionEventBJ(zzVL_tPick,Player(vl_i),true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_PickClick)
    call TriggerAddAction(zzVL_tPick,function zzVL_PickOpen)
    set vl_n=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_PickEnd
// Chức năng dự kiến: Xử lý giao diện chọn tướng (Hero Pick).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_PickEnd takes nothing returns nothing
    local integer vl_e=1
    call DestroyTimer(GetExpiredTimer())
    loop
        exitwhen vl_e>5
        call RemoveUnit(LoadUnitHandle(zzVL_ht,'h0E0',vl_e))
        set vl_e=vl_e+1
    endloop
endfunction

// ==========================================
// Hàm: zzVL_FarmInit
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_FarmInit takes nothing returns nothing
    local integer vl_i=0
    local integer vl_z
    local trigger vl_t=CreateTrigger()
    local unit vl_unit
    local region vl_r=CreateRegion()
    set zzVL_tXp=CreateTrigger()
    set zzVL_homeX[0]=1880.
    set zzVL_homeY[0]=-2100.
    set zzVL_homeX[1]=2050.
    set zzVL_homeY[1]=6200.
    call CreateUnit(Player(15),zzVL_XAPHU,1880.,-1800.,270.)
    call CreateUnit(Player(15),zzVL_XAPHU,2050.,6500.,270.)
    call CreateUnit(Player(15),zzVL_XAPHU,-2560.,5000.,180.)
    set vl_z=1
    loop
        exitwhen vl_z>zzVL_zN
        if zzVL_zTele[vl_z]>0 then
            call CreateUnit(Player(15),zzVL_XAPHU,zzVL_zEx[vl_z]-150.,zzVL_zEy[vl_z]+150.,0.)
        endif
        set vl_z=vl_z+1
    endloop
    loop
        exitwhen vl_i>9
        set zzVL_dlg[vl_i]=DialogCreate()
        call TriggerRegisterDialogEvent(vl_t,zzVL_dlg[vl_i])
        call TriggerRegisterPlayerSelectionEventBJ(zzVL_tXp,Player(vl_i),true)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_XpGo)
    call TriggerAddAction(zzVL_tXp,function zzVL_XpSelect)
    call RegionAddRect(vl_r,GetWorldBounds())
    set vl_t=CreateTrigger()
    call TriggerRegisterEnterRegion(vl_t,vl_r,null)
    call TriggerAddAction(vl_t,function zzVL_OnCreepEnter)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(vl_t,function zzVL_OnAffixPickup)
    call TimerStart(CreateTimer(),3.,false,function zzVL_CampInit)
    call TimerStart(CreateTimer(),2.,false,function zzVL_PickInit)
    call TimerStart(CreateTimer(),150.,false,function zzVL_PickEnd)
    set vl_t=null
    set vl_r=null
    set vl_unit=null
endfunction
