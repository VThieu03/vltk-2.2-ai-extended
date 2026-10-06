// ===== Gameplay 1.31 (added for the 1.31 port, original map by vnakira) =====
// Bo trang bi theo he, cuong hoa +1..+10, ngu hanh cho don danh thuong, cong trang / quan ham,
// phi phong theo quan ham, cao thu xuat hien ngau nhien, nhat dao doat mang.
// Everything lasts one match. Player ids 0..9 (Tong 0-4, Kim 5-9), hero = Jx[pid+1].
// Elements are the author's groups: qx Kim, Qx Moc, tx Tho, sx Thuy, Sx Hoa; e khac e+1 (Hoa khac Kim).
// Every local / parameter starts with vl_: the 1.31 game rejects a local that has the name of a
// global of another type (the map's globals are 1-3 letter names), and then the lobby has no slots.

// Hiển thị tin nhắn văn bản trên màn hình chỉ cho riêng một người chơi cụ thể.
// ==========================================
// Hàm: zzVL_Msg
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_playerId (integer)
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_Msg takes integer vl_playerId,string vl_string returns nothing
    call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,10.,vl_string)
endfunction

// Hiển thị tin nhắn văn bản trên màn hình cho toàn bộ người chơi trong phòng.
// ==========================================
// Hàm: zzVL_All
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_All takes string vl_string returns nothing
    call DisplayTimedTextToForce(bj_FORCE_ALL_PLAYERS,10.,vl_string)
endfunction

// Tạo một đoạn chữ nổi (floating text) bay lên trên đầu của một Unit (ví dụ: báo sát thương, báo né tránh).
// Chữ sẽ tự động mờ dần và biến mất sau 1.5 giây để tránh kẹt màn hình.
// ==========================================
// Hàm: zzVL_Text
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_unit (unit)
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_Text takes unit vl_unit,string vl_string returns nothing
    local texttag vl_tt=CreateTextTag()
    call SetTextTagText(vl_tt,vl_string,.024)
    call SetTextTagPosUnit(vl_tt,vl_unit,60.)
    call SetTextTagVelocity(vl_tt,.0,.04)
    call SetTextTagPermanent(vl_tt,false)
    call SetTextTagLifespan(vl_tt,1.5)
    call SetTextTagFadepoint(vl_tt,1.)
    set vl_tt=null
endfunction

// Lấy thời gian trôi qua của trận đấu và chuyển đổi thành chuỗi định dạng Phút:Giây (VD: "12:05").
// ==========================================
// Hàm: zzVL_Clock
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Trả về dữ liệu kiểu: string
function zzVL_Clock takes nothing returns string
    local integer vl_t=R2I(TimerGetElapsed(zzVL_clock))
    local string vl_string=I2S(ModuloInteger(vl_t,60))
    if StringLength(vl_string)<2 then
        set vl_string="0"+vl_string
    endif
    return I2S(vl_t/60)+":"+vl_string
endfunction

// Hàm hỗ trợ ghi đè 80 dòng sự kiện mới nhất ra file thực tế (VLTK/log.txt) trong thư mục game.
// Sử dụng hàm Preload của Warcraft III để lách luật ghi file.
// ==========================================
// Hàm: zzVL_LogFile
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_LogFile takes nothing returns nothing
    local integer vl_i=zzVL_logN-80
    if vl_i<0 then
        set vl_i=0
    endif
    call PreloadGenClear()
    call PreloadGenStart()
    call Preload("VLTK log - game time "+zzVL_Clock())
    loop
        exitwhen vl_i>=zzVL_logN
        call Preload(zzVL_logS[ModuloInteger(vl_i,80)])
        set vl_i=vl_i+1
    endloop
    call PreloadGenEnd("VLTK\\log.txt")
endfunction

// Thêm một dòng thông báo vào mảng nhật ký hệ thống kèm theo thời gian hiện tại.
// Hàm này gọi LogFile nếu hệ thống đang không bận ghi file.
// ==========================================
// Hàm: zzVL_Log
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_Log takes string vl_string returns nothing
    set zzVL_logS[ModuloInteger(zzVL_logN,80)]=zzVL_Clock()+" "+vl_string
    set zzVL_logN=zzVL_logN+1
    if not zzVL_logBusy then
        set zzVL_logBusy=true
        call zzVL_LogFile()
        set zzVL_logBusy=false
    endif
endfunction

// Cập nhật giao diện đồng hồ thời gian và bảng tỉ số mạng Tống/Kim ở góc phải màn hình.
// Đồng thời in cảnh báo ra nhật ký nếu phát hiện có sự đột biến sát thương (trên 400 lần / 2 giây).
// ==========================================
// Hàm: zzVL_LogFlush
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_LogFlush takes nothing returns nothing
    if zzVL_dmgN>400 then
        call zzVL_Log("nhieu sat thuong: "+I2S(zzVL_dmgN)+" lan / 2 giay")
    endif
    set zzVL_dmgN=0
    if zzVL_fClock!=null then
        call BlzFrameSetText(zzVL_fClock,"|cffffcc00Thời gian|r "+zzVL_Clock())
        call BlzFrameSetText(zzVL_fScore,"|cffff4040Tống "+I2S(zzVL_teamK[0])+"|r - |cff4080ff"+I2S(zzVL_teamK[1])+" Kim|r|n|cffffcc00Hạ|r "+I2S(zzVL_kills[GetPlayerId(GetLocalPlayer())])+"   |cffffcc00Chết|r "+I2S(zzVL_deaths[GetPlayerId(GetLocalPlayer())]))
    endif
endfunction

// Hàm tiện ích: Ép hệ thống ghi thông báo gần nhất và cập nhật bảng điểm ngay lập tức.
// ==========================================
// Hàm: zzVL_LogNow
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_LogNow takes nothing returns nothing
    call zzVL_Log(zzVL_logMsg)
    call zzVL_LogFlush()
endfunction

// Kiểm tra và trả về mã số ngũ hành của một Unit (Tướng/Quái).
// Trả về: 1=Kim, 2=Mộc, 3=Thổ, 4=Thủy, 5=Hỏa. Trả về 0  chưa thuộc hệ nào.
// ==========================================
// Hàm: zzVL_HeU
// Chức năng dự kiến: Kiểm tra hệ/phe phái của mục tiêu.
// Tham số:
//   - vl_unit (unit)
// Trả về dữ liệu kiểu: integer
function zzVL_HeU takes unit vl_unit returns integer
    if vl_unit==null then
        return 0
    elseif IsUnitInGroup(vl_unit,qx) then
        return 1
    elseif IsUnitInGroup(vl_unit,Qx) then
        return 2
    elseif IsUnitInGroup(vl_unit,tx) then
        return 3
    elseif IsUnitInGroup(vl_unit,sx) then
        return 4
    elseif IsUnitInGroup(vl_unit,Sx) then
        return 5
    endif
    return 0
endfunction

// Trả về chuỗi Tên phe phái (Tống hoặc Kim) được tô màu của người chơi.
// Player(0) luôn là đại diện phe Tống.
// ==========================================
// Hàm: zzVL_Team
// Chức năng dự kiến: Kiểm tra hệ/phe phái của mục tiêu.
// Tham số:
//   - vl_playerId (integer)
// Trả về dữ liệu kiểu: string
function zzVL_Team takes integer vl_playerId returns string
    if IsPlayerAlly(Player(vl_playerId),Player(0)) then
        return "|cffff6060Tống|r"
    endif
    return "|cff60ff60Kim|r"
endfunction

// Trả về chuỗi đầy đủ bao gồm "Tên Phe + Tên Người chơi".
// ==========================================
// Hàm: zzVL_Name
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Trả về dữ liệu kiểu: string
function zzVL_Name takes integer vl_playerId returns string
    return zzVL_Team(vl_playerId)+" "+GetPlayerName(Player(vl_playerId))
endfunction

// Trả về đoạn chữ mô tả hiệu ứng khi kích hoạt ngũ hành dựa theo hệ (1..5) và cấp cường hóa (vl_lv).
// Được dùng hiển thị trên tooltip của vũ khí.
// ==========================================
// Hàm: zzVL_SetText
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_he (integer)
//   - vl_lv (integer)
// Trả về dữ liệu kiểu: string
// LƯU Ý: chữ ở đây phải khớp với công thức thật trong gameplay_04_combat.j
// (zzVL_OnDamageBody, zzVL_SetHit, zzVL_Tick). Sửa số ở đây mà không sửa bên đó thì chỉ đổi chữ.
function zzVL_SetText takes integer vl_he,integer vl_lv returns string
    if vl_he==1 then
        return "+"+I2S(5*vl_lv)+"% sát thương, đánh thường "+I2S(2*vl_lv)+"% làm choáng 0.5 giây"
    elseif vl_he==2 then
        return "hút "+I2S(3*vl_lv)+"% sát thương thành sinh lực, đánh thường gây độc ("+I2S(3*vl_lv)+"% sát thương trong 5 giây)"
    elseif vl_he==3 then
        return "giảm "+I2S(4*vl_lv)+"% sát thương nhận vào, phản "+I2S(2*vl_lv)+"% sát thương đánh thường, miễn choáng/chậm ngũ hành"
    elseif vl_he==4 then
        return "hồi "+R2SW(.5*vl_lv,1,1)+"% sinh lực mỗi giây, đánh thường làm chậm "+I2S(5*vl_lv)+"% trong 2 giây"
    elseif vl_he==5 then
        return I2S(4*vl_lv)+"% cơ hội gây sát thương gấp đôi, đòn gấp đôi thiêu đốt 3 giây (giảm 50% hồi máu)"
    endif
    return "không có hiệu ứng (tướng chưa có hệ)"
endfunction

// Hệ số hồi máu của một đơn vị: 0.5 nếu đang bị "Thiêu đốt" (bộ Hỏa), ngược lại 1.
// Thời điểm hết thiêu đốt được lưu trong hashtable: khóa 79 trên handle của đơn vị.
// Mọi chỗ hồi máu/hút máu nhân với hàm này để Hỏa khắc chế được Mộc và Thủy.
function zzVL_HealMul takes unit vl_u returns real
    if TimerGetElapsed(zzVL_clock)<LoadReal(zzVL_ht,GetHandleId(vl_u),79) then
        return .5
    endif
    return 1.
endfunction

// Kiểm tra xem Tướng (Hero) có đang cầm vũ khí ở 6 ô đồ đầu tiên hay không.
// Mã số phân loại đồ: Chia lấy dư cho 10 == 3 tức là nhóm Vũ Khí.
// ==========================================
// Hàm: zzVL_HasWeapon
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_HasWeapon takes unit vl_hero returns boolean
    local integer vl_i=0
    loop
        exitwhen vl_i>5
        if UnitItemInSlot(vl_hero,vl_i)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),0)/10==3 then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction
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
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10<1 or LoadInteger(zzVL_ht,vl_id,29)>0 then
        return
    endif
    call SaveInteger(zzVL_ht,vl_id,29,1)
    if vl_r<=10 then
        set vl_n=2
    elseif vl_r<=55 then
        set vl_n=1
    endif
    loop
        exitwhen vl_n<=0
        set vl_k=GetRandomInt(1,16)
        if vl_k >= 5 then
            set vl_k=vl_k+6
        endif
        if LoadInteger(zzVL_ht,vl_id,30+vl_k)==0 then
            if vl_k==1 then
                set vl_v=GetRandomInt(2,6)
            elseif vl_k==2 then
                set vl_v=GetRandomInt(2,5)
            elseif vl_k==3 then
                set vl_v=GetRandomInt(3,8)
            elseif vl_k==4 or vl_k==16 then
                set vl_v=GetRandomInt(5,15)
            elseif vl_k>=11 and vl_k<=15 then
                set vl_v=GetRandomInt(5,20)
            elseif vl_k==19 or vl_k==20 then
                set vl_v=GetRandomInt(50,200)
            elseif vl_k==21 then
                set vl_v=GetRandomInt(10,30)
            elseif vl_k==22 then
                set vl_v=1
            else
                set vl_v=GetRandomInt(10,50)
            endif
            call SaveInteger(zzVL_ht,vl_id,30+vl_k,vl_v)
            
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
        call SaveInteger(zzVL_ht,vl_id,75,vl_k)
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
    if vl_v<10 or vl_v>=50 or GetPlayerController(GetOwningPlayer(vl_hero))!=MAP_CONTROL_COMPUTER or not IsUnitType(vl_hero,UNIT_TYPE_HERO) then
        return
    endif
    loop
        exitwhen vl_i>5
        set vl_item=UnitItemInSlot(vl_hero,vl_i)
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
        set vl_string=vl_string+LoadInteger(zzVL_ht,GetHandleId(vl_item),30+vl_k)
        set vl_k=vl_k+1
    endloop
    return vl_string+40*LoadInteger(zzVL_ht,GetHandleId(vl_item),43)
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
    if vl_v<10 or vl_v>=50 or LoadInteger(zzVL_ht,GetHandleId(vl_item),74)>0 then
        return
    endif
    call SaveInteger(zzVL_ht,GetHandleId(vl_item),74,1)
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
    if vl_playerId>9 or not zzVL_autoSell[vl_playerId] or vl_hero!=Jx[vl_playerId+1] or vl_v<10 or vl_v>=50 or LoadInteger(zzVL_ht,GetItemTypeId(vl_n),1)>0 or LoadInteger(zzVL_ht,GetHandleId(vl_n),73)==0 then
        return
    endif
    call RemoveSavedInteger(zzVL_ht,GetHandleId(vl_n),73)
    loop
        exitwhen vl_i>5
        set vl_item=UnitItemInSlot(vl_hero,vl_i)
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
    local integer vl_n
    local integer vl_i=0
    local integer vl_k
    local integer vl_id
    local real vl_base
    local integer vl_scale
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 11, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 12, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 13, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 14, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 15, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 16, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 17, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 18, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 19, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 20, 0)
    call SaveInteger(zzVL_ht, 1000+vl_playerId, 22, 0)
    loop
        exitwhen vl_i>13
        set zzVL_af[vl_playerId*16+vl_i]=zzKS_af[vl_playerId*16+vl_i]
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        if UnitItemInSlot(vl_hero,vl_i)!=null then
            set vl_id=GetHandleId(UnitItemInSlot(vl_hero,vl_i))
            set vl_k=1
            loop
                exitwhen vl_k>22
                if vl_k <= 10 then
                    set zzVL_af[vl_playerId*16+vl_k]=zzVL_af[vl_playerId*16+vl_k]+LoadInteger(zzVL_ht,vl_id,30+vl_k)
                elseif vl_k == 21 then
                    set zzVL_af[vl_playerId*16+13]=zzVL_af[vl_playerId*16+13]+LoadInteger(zzVL_ht,vl_id,30+vl_k)
                else
                    call SaveInteger(zzVL_ht, 1000+vl_playerId, vl_k, LoadInteger(zzVL_ht, 1000+vl_playerId, vl_k) + LoadInteger(zzVL_ht,vl_id,30+vl_k))
                endif
                set vl_k=vl_k+1
            endloop
            if LoadInteger(zzVL_ht,vl_id,75)>0 then
                set zzVL_af[vl_playerId*16+6]=zzVL_af[vl_playerId*16+6]+3
                set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+150
                set zzVL_af[vl_playerId*16+5]=zzVL_af[vl_playerId*16+5]+2
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        if UnitItemInSlot(vl_hero,vl_i)!=null then
            set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),0)/10
            if vl_k>=1 and vl_k<=4 then
                call zzVL_CuongIcon(UnitItemInSlot(vl_hero,vl_i),zzVL_cuong[vl_playerId*4+vl_k-1])
            endif
            set vl_t=LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),0)-vl_k*10
            if vl_k>=1 and vl_k<=4 then
                set vl_n=zzVL_cuong[vl_playerId*4+vl_k-1]
                call zzVL_CuongTip(UnitItemInSlot(vl_hero,vl_i),vl_k,vl_t,vl_n)
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
    set zzVL_wel[vl_playerId]=0
    set vl_i=0
    loop
        exitwhen vl_i>5
        if UnitItemInSlot(vl_hero,vl_i)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),66)>0 then
            set zzVL_wel[vl_playerId]=LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),66)
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
    call SetUnitTimeScale(vl_hero, 1.0 + LoadInteger(zzVL_ht, 1000+vl_playerId, 16) / 100.0)
    
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
// Hàm: zzVL_CampSpawn
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_c (integer)
//   - vl_type (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_CampSpawn takes integer vl_c,integer vl_type returns nothing
    local unit vl_unit=CreateUnit(Player(12),vl_type,zzVL_cX[vl_c]+GetRandomReal(-120,120),zzVL_cY[vl_c]+GetRandomReal(-120,120),GetRandomReal(0,360))
    local real vl_mul=0.6+TimerGetElapsed(zzVL_clock)/600.
    call SaveInteger(zzVL_ht,GetHandleId(vl_unit),9,vl_c+1)
    call BlzSetUnitMaxHP(vl_unit,R2I(GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE)*vl_mul))
    call SetWidgetLife(vl_unit,GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE))
    call BlzSetUnitBaseDamage(vl_unit,R2I(BlzGetUnitBaseDamage(vl_unit,0)*vl_mul),0)
    set vl_unit=null
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
    local timer vl_t
    local integer vl_tier
    local integer vl_n
    local integer vl_k
    local integer vl_i
    local integer vl_g
    if vl_c<0 then
        return
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_d))
    set vl_t=CreateTimer()
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),0,vl_c)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,GetUnitTypeId(vl_d))
    call TimerStart(vl_t,25.,false,function zzVL_CampRespawn)
    set vl_t=null
    if zzVL_matN>0 and GetRandomInt(1,100)<=18 then
        call CreateItem(zzVL_mat[GetRandomInt(0,zzVL_matN-1)],GetUnitX(vl_d)+GetRandomReal(-40,40),GetUnitY(vl_d)+GetRandomReal(-40,40))
    endif
    if GetRandomInt(1,100)<=20 then
        set vl_tier=GetRandomInt(zzVL_cZone[vl_c]*2-1,zzVL_cZone[vl_c]*2+1)
        set vl_n=zzVL_gearN[vl_tier]
        if vl_n>0 then
            set vl_k=GetRandomInt(0,vl_n-1)
            set vl_i=0
            loop
                exitwhen vl_i>=vl_n
                set vl_g=zzVL_gear[vl_tier*200+ModuloInteger(vl_k+vl_i,vl_n)]
                if LoadInteger(zzVL_ht,vl_g,42)<5 then
                    call SaveInteger(zzVL_ht,vl_g,42,LoadInteger(zzVL_ht,vl_g,42)+1)
                    call SaveInteger(zzVL_ht,GetHandleId(CreateItem(vl_g,GetUnitX(vl_d),GetUnitY(vl_d))),73,1)
                    set vl_i=vl_n
                endif
                set vl_i=vl_i+1
            endloop
        endif
    endif
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
    if GetOwningPlayer(vl_unit)==Player(12) and not IsUnitType(vl_unit,UNIT_TYPE_HERO) and GetUnitState(vl_unit,UNIT_STATE_MAX_LIFE)<5000. then
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
    set zzVL_dlgB[vl_playerId*5]=DialogAddButton(zzVL_dlg[vl_playerId],"Về căn cứ",0)
    loop
        exitwhen vl_z>zzVL_zN
        set zzVL_dlgB[vl_playerId*5+vl_z]=DialogAddButton(zzVL_dlg[vl_playerId],zzVL_zName[vl_z],0)
        set vl_z=vl_z+1
    endloop
    set zzVL_dlgB[vl_playerId*5+3]=DialogAddButton(zzVL_dlg[vl_playerId],"Lôi Đài (tỷ thí)",0)
    set zzVL_dlgB[vl_playerId*5+4]=DialogAddButton(zzVL_dlg[vl_playerId],"Thôi",0)
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
    if vl_b==zzVL_dlgB[vl_playerId*5] then
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
            if vl_b==zzVL_dlgB[vl_playerId*5+vl_i] then
                set vl_x=zzVL_zEx[vl_i]
                set vl_y=zzVL_zEy[vl_i]
            endif
            set vl_i=vl_i+1
        endloop
        if vl_b==zzVL_dlgB[vl_playerId*5+3] then
            set vl_x=-2848.
            set vl_y=5616.
            call zzVL_All(zzVL_Name(vl_playerId)+" lên |cffff8000Lôi Đài|r tỷ thí!")
        endif
        if vl_b==zzVL_dlgB[vl_playerId*5+4] then
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
        call CreateUnit(Player(15),zzVL_XAPHU,zzVL_zEx[vl_z]-150.,zzVL_zEy[vl_z]+150.,0.)
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
// ---- tuyet hoc tran phai (tranphai.py): skill of the hero's sect, given at level 15, level = (hero level-10)/5 up to 5.
// zzVL_tpEnd[pid*12+k]: end of the buff of skill k (0 Thuan Duong shield, 1 Duy Nga Doc Ton, 3 Kim Chung Trao)

// ==========================================
// Hàm: zzVL_MainStat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
// Trả về dữ liệu kiểu: real
function zzVL_MainStat takes unit vl_hero returns real
    local integer vl_string=GetHeroStr(vl_hero,true)
    if GetHeroAgi(vl_hero,true)>vl_string then
        set vl_string=GetHeroAgi(vl_hero,true)
    endif
    if GetHeroInt(vl_hero,true)>vl_string then
        set vl_string=GetHeroInt(vl_hero,true)
    endif
    return I2R(vl_string)
endfunction

// ==========================================
// Hàm: zzVL_TpFoe
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_unit (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_TpFoe takes unit vl_hero,unit vl_unit returns boolean
    return GetWidgetLife(vl_unit)>.405 and IsUnitEnemy(vl_unit,GetOwningPlayer(vl_hero)) and not IsUnitType(vl_unit,UNIT_TYPE_STRUCTURE)
endfunction

// ==========================================
// Hàm: zzVL_TpHit
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_unit (unit)
//   - vl_d (real)
// Không trả về giá trị (thực thi hành động).
function zzVL_TpHit takes unit vl_hero,unit vl_unit,real vl_d returns nothing
    set zzVL_inTp=true
    call UnitDamageTarget(vl_hero,vl_unit,vl_d,true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    set zzVL_inTp=false
endfunction

// ==========================================
// Hàm: zzVL_TpTick
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_playerId (integer)
//   - vl_hero (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_TpTick takes integer vl_playerId,unit vl_hero returns nothing
    local integer vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),50)
    local integer vl_lv=GetHeroLevel(vl_hero)
    local integer vl_w
    local integer vl_i=1
    if not zzVL_gotStart[vl_playerId] then
        set zzVL_gotStart[vl_playerId]=true
        loop
            exitwhen vl_i>4
            if zzVL_start[vl_i]!=0 then
                call UnitAddItem(vl_hero,CreateItem(zzVL_start[vl_i],GetUnitX(vl_hero),GetUnitY(vl_hero)))
            endif
            set vl_i=vl_i+1
        endloop
        set zzVL_potion=CreateItem('phea',GetUnitX(vl_hero),GetUnitY(vl_hero))
        call SetItemCharges(zzVL_potion,10)
        call UnitAddItem(vl_hero,zzVL_potion)
        set zzVL_potion=null
    endif
    if vl_ab!=0 and vl_lv>=75 then
        set vl_w=(vl_lv-50)/25
        if vl_w>5 then
            set vl_w=5
        endif
        if GetUnitAbilityLevel(vl_hero,vl_ab)==0 then
            call UnitAddAbility(vl_hero,vl_ab)
            call UnitMakeAbilityPermanent(vl_hero,true,vl_ab)
            if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER then
                call zzVL_Msg(vl_playerId,"|cffff8000Lĩnh ngộ tuyệt học trấn phái:|r "+GetObjectName(vl_ab)+" (ô giữa bảng lệnh). Lên cấp mỗi 25 cấp tướng.")
            endif
        endif
        if GetUnitAbilityLevel(vl_hero,vl_ab)!=vl_w then
            call SetUnitAbilityLevel(vl_hero,vl_ab,vl_w)
        endif
    endif
    if zzVL_wel[vl_playerId]==4 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*zzVL_HealMul(vl_hero))
        call SetUnitState(vl_hero,UNIT_STATE_MANA,GetUnitState(vl_hero,UNIT_STATE_MANA)+GetUnitState(vl_hero,UNIT_STATE_MAX_MANA)*.008)
    endif
    set vl_lv=GetUnitAbilityLevel(vl_hero,'A0TA')
    if vl_lv>0 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*vl_lv)
    endif
endfunction

// ==========================================
// Hàm: zzVL_TpDef
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_src (unit)
//   - vl_tgt (unit)
//   - vl_pt (integer)
//   - vl_d (real)
// Trả về dữ liệu kiểu: real
function zzVL_TpDef takes unit vl_src,unit vl_tgt,integer vl_pt,real vl_d returns real
    local real vl_now=TimerGetElapsed(zzVL_clock)
    local real vl_a
    local integer vl_lv
    if vl_pt>9 or vl_tgt!=Jx[vl_pt+1] then
        return vl_d
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12+1] then
        set vl_d=vl_d*(.85-.05*GetUnitAbilityLevel(vl_tgt,'A0T1'))
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12+3] then
        set vl_lv=GetUnitAbilityLevel(vl_tgt,'A0T3')
        set vl_d=vl_d*(.85-.05*vl_lv)
        if not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=null and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and vl_now-LoadReal(zzVL_ht,GetHandleId(vl_tgt),70)>=.3 then
            call SaveReal(zzVL_ht,GetHandleId(vl_tgt),70,vl_now)
            call zzVL_TpHit(vl_tgt,vl_src,vl_d*.1*vl_lv)
        endif
    endif
    if vl_now<zzVL_tpEnd[vl_pt*12] and zzVL_shield[vl_pt]>0. then
        set vl_a=vl_d
        if vl_a>zzVL_shield[vl_pt] then
            set vl_a=zzVL_shield[vl_pt]
        endif
        set zzVL_shield[vl_pt]=zzVL_shield[vl_pt]-vl_a
        set vl_d=vl_d-vl_a
    endif
    return vl_d
endfunction

// ==========================================
// Hàm: zzVL_TpUnpause
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_TpUnpause takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    call PauseUnit(LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0),false)
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_TpPoison
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_TpPoison takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_hero=LoadUnitHandle(zzVL_ht,vl_id,0)
    local unit vl_unit=LoadUnitHandle(zzVL_ht,vl_id,1)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)+1
    if vl_hero!=null and vl_unit!=null and GetWidgetLife(vl_unit)>.405 then
        call zzVL_TpHit(vl_hero,vl_unit,LoadReal(zzVL_ht,vl_id,2))
        if LoadInteger(zzVL_ht,vl_id,4)==1 then
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl",vl_unit,"chest"))
        else
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",vl_unit,"chest"))
        endif
    endif
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    if vl_n>=5 or vl_unit==null or GetWidgetLife(vl_unit)<.405 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_hero=null
    set vl_unit=null
endfunction

// ==========================================
// Hàm: zzVL_CuongDo
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_item (item)
// Trả về dữ liệu kiểu: boolean
function zzVL_CuongDo takes unit vl_hero,item vl_item returns boolean
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_k
    local string array vl_n
    if vl_playerId>9 or vl_item==null or vl_hero!=Jx[vl_playerId+1] then
        return false
    endif
    set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10-1
    if vl_k<0 or vl_k>3 then
        call zzVL_Msg(vl_playerId,"Thủy tinh chỉ dùng lên mũ, áo, vũ khí, giày.")
        return false
    endif
    if zzVL_cuong[vl_playerId*4+vl_k]>=10 then
        call zzVL_Msg(vl_playerId,"Ô này đã cường hóa tối đa +10.")
        return false
    endif
    set zzVL_cuong[vl_playerId*4+vl_k]=zzVL_cuong[vl_playerId*4+vl_k]+1
    set vl_n[0]="Mũ (mọi chỉ số theo bậc mũ)"
    set vl_n[1]="Áo (giáp theo bậc áo, -2% sát thương nhận)"
    set vl_n[2]="Vũ khí (+4% sát thương, sát thương gốc theo bậc vũ khí)"
    set vl_n[3]="Giày (sinh lực theo bậc giày, +3 tốc chạy)"
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_hero,"origin"))
    call zzVL_Text(vl_hero,"|cffffcc00Cường hóa +"+I2S(zzVL_cuong[vl_playerId*4+vl_k])+"|r")
    call zzVL_Msg(vl_playerId,"|cffffcc00Cường hóa|r "+vl_n[vl_k]+": |cffffcc00+"+I2S(zzVL_cuong[vl_playerId*4+vl_k])+"|r. Cấp cường hóa đi theo người, thay món mới vẫn giữ.")
    call zzVL_AffixSum(vl_playerId)
    return true
endfunction

// ==========================================
// Hàm: zzVL_CuongHoa
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_item (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_CuongHoa takes unit vl_hero,item vl_item returns nothing
    if not zzVL_CuongDo(vl_hero,vl_item) and vl_hero!=null then
        call UnitAddItem(vl_hero,CreateItem('I00W',GetUnitX(vl_hero),GetUnitY(vl_hero)))
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnTpCast
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnTpCast takes nothing returns nothing
    local unit vl_hero=GetTriggerUnit()
    local integer vl_ab=GetSpellAbilityId()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
    local real vl_st=zzVL_MainStat(vl_hero)
    local real vl_now=TimerGetElapsed(zzVL_clock)
    local real vl_x
    local real vl_y
    local real vl_a
    local real vl_d
    local unit vl_unit
    local unit vl_t=GetSpellTargetUnit()
    local group vl_g
    local timer vl_tm
    call zzVL_Log("skill "+GetObjectName(GetSpellAbilityId())+" - "+GetUnitName(GetTriggerUnit()))
    if vl_playerId>9 then
        set vl_hero=null
        set vl_t=null
        return
    endif
    if vl_ab=='A00N' then
        call zzVL_CuongHoa(vl_hero,GetSpellTargetItem())
    elseif vl_ab=='A0T0' then
        set zzVL_shield[vl_playerId]=GetUnitState(vl_hero,UNIT_STATE_MANA)*(.4+.15*vl_lv)
        set zzVL_tpEnd[vl_playerId*12]=vl_now+12.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl",vl_hero,"origin"))
        call zzVL_Text(vl_hero,"|cff80c0ffLá chắn "+I2S(R2I(zzVL_shield[vl_playerId]))+"|r")
    elseif vl_ab=='A0T1' then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*(.15+.05*vl_lv))
        set zzVL_tpEnd[vl_playerId*12+1]=vl_now+8.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",vl_hero,"origin"))
    elseif vl_ab=='A0T3' then
        set zzVL_tpEnd[vl_playerId*12+3]=vl_now+8.
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl",vl_hero,"origin"))
    elseif vl_ab=='A0T4' or vl_ab=='A0T8' then
        set vl_g=CreateGroup()
        if vl_ab=='A0T4' then
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),800.,null)
        else
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),450.,null)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",GetUnitX(vl_hero),GetUnitY(vl_hero)))
        endif
        loop
            set vl_unit=FirstOfGroup(vl_g)
            exitwhen vl_unit==null
            call GroupRemoveUnit(vl_g,vl_unit)
            if vl_ab=='A0T4' then
                if GetWidgetLife(vl_unit)>.405 and IsUnitAlly(vl_unit,GetOwningPlayer(vl_hero)) and IsUnitType(vl_unit,UNIT_TYPE_HERO) then
                    call SetWidgetLife(vl_unit,GetWidgetLife(vl_unit)+200.*vl_lv+2.*GetHeroInt(vl_hero,true))
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl",vl_unit,"origin"))
                endif
            elseif zzVL_TpFoe(vl_hero,vl_unit) then
                call zzVL_TpHit(vl_hero,vl_unit,100.*vl_lv+2.*vl_st)
                if GetWidgetLife(vl_unit)>.405 and not IsUnitPaused(vl_unit) then
                    call PauseUnit(vl_unit,true)
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl",vl_unit,"origin"))
                    set vl_tm=CreateTimer()
                    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_unit)
                    call TimerStart(vl_tm,1.+.25*vl_lv,false,function zzVL_TpUnpause)
                endif
            endif
        endloop
        call DestroyGroup(vl_g)
    elseif vl_ab=='A0T5' or vl_ab=='A0T7' then
        set vl_x=GetSpellTargetX()
        set vl_y=GetSpellTargetY()
        set vl_a=Atan2(vl_y-GetUnitY(vl_hero),vl_x-GetUnitX(vl_hero))
        set vl_g=CreateGroup()
        if vl_ab=='A0T5' then
            set vl_d=150.*vl_lv+3.*vl_st
            call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,300.,null)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",vl_x,vl_y))
        else
            set vl_d=120.*vl_lv+3.*vl_st
            call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_hero),GetUnitY(vl_hero),800.,null)
        endif
        loop
            set vl_unit=FirstOfGroup(vl_g)
            exitwhen vl_unit==null
            call GroupRemoveUnit(vl_g,vl_unit)
            if zzVL_TpFoe(vl_hero,vl_unit) then
                if vl_ab=='A0T5' then
                    call zzVL_TpHit(vl_hero,vl_unit,vl_d)
                    set vl_x=Atan2(GetUnitY(vl_unit)-GetSpellTargetY(),GetUnitX(vl_unit)-GetSpellTargetX())
                    call SetUnitPosition(vl_unit,GetUnitX(vl_unit)+180.*Cos(vl_x),GetUnitY(vl_unit)+180.*Sin(vl_x))
                else
                    set vl_x=Atan2(GetUnitY(vl_unit)-GetUnitY(vl_hero),GetUnitX(vl_unit)-GetUnitX(vl_hero))-vl_a
                    if Cos(vl_x)>=.866 then
                        call zzVL_TpHit(vl_hero,vl_unit,vl_d)
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\WardenMissile\\WardenMissile.mdl",vl_unit,"chest"))
                    endif
                endif
            endif
        endloop
        call DestroyGroup(vl_g)
    elseif vl_ab=='A0T6' and vl_t!=null then
        set vl_d=130.*vl_lv+3.*vl_st
        call zzVL_TpHit(vl_hero,vl_t,vl_d)
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+vl_d*.5)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",vl_t,"chest"))
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.1)
        call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
    elseif vl_ab=='A0T9' and vl_t!=null then
        set vl_a=GetWidgetLife(vl_hero)*.15
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)-vl_a)
        call zzVL_TpHit(vl_hero,vl_t,150.*vl_lv+4.*vl_st+vl_a)
        call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl",vl_t,"origin"))
    endif
    set vl_hero=null
    set vl_t=null
    set vl_unit=null
    set vl_g=null
    set vl_tm=null
endfunction

// ==========================================
// Hàm: zzVL_TpAi
// Chức năng dự kiến: Kỹ năng Trấn Phái.
// Tham số:
//   - vl_hero (unit)
//   - vl_t (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_TpAi takes unit vl_hero,unit vl_t returns boolean
    local integer vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),50)
    local integer vl_lv
    local integer vl_k
    local integer vl_o
    if vl_ab==0 or vl_t==null then
        return false
    endif
    set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
    if vl_lv==0 or BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)>.01 or GetUnitState(vl_hero,UNIT_STATE_MANA)<BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
        return false
    endif
    set vl_k=LoadInteger(zzVL_ht,vl_ab,51)
    set vl_o=LoadInteger(zzVL_ht,vl_ab,52)
    if vl_k==1 then
        return IssueTargetOrderById(vl_hero,vl_o,vl_t)
    elseif vl_k==2 then
        return IssuePointOrderById(vl_hero,vl_o,GetUnitX(vl_t),GetUnitY(vl_t))
    elseif vl_k==0 and (IsUnitInRange(vl_hero,vl_t,400.) or GetWidgetLife(vl_hero)<GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.6) then
        return IssueImmediateOrderById(vl_hero,vl_o)
    endif
    return false
endfunction
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
            set vl_best[1]=0
            set vl_best[2]=0
            set vl_best[3]=0
            set vl_best[4]=0
            set vl_i=0
            loop
                exitwhen vl_i>5
                set vl_item=UnitItemInSlot(vl_hero,vl_i)
                if vl_item!=null then
                    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
                    if vl_v>0 then
                        set vl_string=vl_v/10
                        if vl_v-vl_string*10>vl_best[vl_string] then
                            set vl_best[vl_string]=vl_v-vl_string*10
                        endif
                    endif
                endif
                set vl_i=vl_i+1
            endloop
            set vl_lv=vl_best[1]
            set vl_i=2
            loop
                exitwhen vl_i>4
                if vl_best[vl_i]<vl_lv then
                    set vl_lv=vl_best[vl_i]
                endif
                set vl_i=vl_i+1
            endloop
            if vl_lv!=zzVL_set[vl_playerId] then
                if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER then
                    if vl_lv>0 then
                        call zzVL_Msg(vl_playerId,"|cffffcc00Bộ trang bị "+zzVL_hn[zzVL_he[vl_playerId]]+" cấp "+I2S(vl_lv)+"/5|r: "+zzVL_SetText(zzVL_he[vl_playerId],vl_lv))
                    else
                        call zzVL_Msg(vl_playerId,"|cffff8000Bộ trang bị không còn đủ 4 món (mũ, áo, vũ khí, giày)|r")
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
        call SetUnitMoveSpeed(vl_unit,LoadReal(zzVL_ht,GetHandleId(vl_unit),69))
        call SaveInteger(zzVL_ht,GetHandleId(vl_unit),68,0)
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
    elseif zzVL_wel[vl_ps]==4 and vl_atk and GetWidgetLife(vl_t)>.405 and LoadInteger(zzVL_ht,GetHandleId(vl_t),68)==0 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_t),68,1)
        call SaveReal(zzVL_ht,GetHandleId(vl_t),69,GetUnitMoveSpeed(vl_t))
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
        if GetRandomInt(1,100)<=2*vl_lv and vl_now>=LoadReal(zzVL_ht,vl_id,76) and not IsUnitPaused(vl_t) and not zzVL_Steady(vl_t) then
            call SaveReal(zzVL_ht,vl_id,76,vl_now+3.)
            call PauseUnit(vl_t,true)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_t,"overhead"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,.5,false,function zzVL_TpUnpause)
        endif
    elseif vl_a==2 then
        // Mộc - Độc: 5 lần, mỗi giây 0.6%/cấp sát thương đòn đánh (tổng 3%/cấp), không cộng dồn
        if vl_now>=LoadReal(zzVL_ht,vl_id,77) then
            call SaveReal(zzVL_ht,vl_id,77,vl_now+5.)
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
            call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.006*vl_lv)
            call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        endif
    elseif vl_a==4 then
        // Thủy - Băng sát: chậm 5%/cấp trong 2 giây, không cộng dồn với chậm khác
        if LoadInteger(zzVL_ht,vl_id,68)==0 and not zzVL_Steady(vl_t) then
            call SaveInteger(zzVL_ht,vl_id,68,1)
            call SaveReal(zzVL_ht,vl_id,69,GetUnitMoveSpeed(vl_t))
            call SetUnitMoveSpeed(vl_t,GetUnitMoveSpeed(vl_t)*(1.-.05*vl_lv))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",vl_t,"chest"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,2.,false,function zzVL_SlowEnd)
        endif
    elseif vl_a==5 and vl_fire then
        // Hỏa - Thiêu đốt: đòn gấp đôi làm mục tiêu giảm 50% hồi máu/hút máu trong 3 giây
        call SaveReal(zzVL_ht,vl_id,79,vl_now+3.)
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
    if vl_src==null or vl_tgt==null or vl_d<=0. or not IsUnitEnemy(vl_tgt,GetOwningPlayer(vl_src)) then
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
            set vl_m=vl_m+.05*vl_lv
        elseif vl_lv>0 and vl_a==5 and GetRandomInt(1,100)<=4*vl_lv then
            set vl_m=vl_m+1.
            set vl_crit=true
            set vl_fire=true
        endif
        set vl_m=vl_m+.02*zzVL_rank[vl_ps]
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
    
    // Cộng thêm STVL Nội Công / Ngoại Công (phẳng)
    if vl_ps<10 and vl_src==Jx[vl_ps+1] then
        if BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
            set vl_d=vl_d + LoadInteger(zzVL_ht, 1000+vl_ps, 18)
        else
            set vl_d=vl_d + LoadInteger(zzVL_ht, 1000+vl_ps, 17)
            set vl_d=vl_d * (1.0 + LoadInteger(zzVL_ht, 1000+vl_ps, 22) * 10.0 / 100.0)
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
            set vl_res = LoadInteger(zzVL_ht, 1000 + vl_pt, 10 + vl_srcHe)
            if vl_res > 0 then
                if vl_res > 80 then
                    set vl_res = 80
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
        call ExecuteFunc("zzKS_OnHit")
    endif
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_wel[vl_ps]>0 and not zzVL_inTp then
        set vl_d=vl_d*1.08
        if BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
            call zzVL_WeaponHit(vl_ps,vl_src,vl_tgt,vl_d,true)
        else
            call zzVL_WeaponHit(vl_ps,vl_src,vl_tgt,vl_d,false)
        endif
    endif
    if BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
        if vl_pt<10 and vl_tgt==Jx[vl_pt+1] then
            set vl_evasion = R2I(GetHeroAgi(vl_tgt,true)/2.0) + LoadInteger(zzVL_ht, 1000+vl_pt, 20)
        else
            set vl_evasion = 50
        endif
        
        if vl_ps<10 and vl_src==Jx[vl_ps+1] then
            set vl_hit = LoadInteger(zzVL_ht, 1000+vl_ps, 19)
        else
            set vl_hit = 50
        endif
        
        if vl_evasion > 0 then
            set vl_chance = vl_evasion - vl_hit
            if vl_chance < 0 then
                set vl_chance = 0
            endif
            if vl_chance > 500 then
                set vl_chance = 500
            endif
            
            if GetRandomInt(1,1000) <= vl_chance then
                set vl_d=0.
                call zzVL_Text(vl_tgt,"|cff80ff80Né|r")
            endif
        endif
    endif
    set vl_d=zzVL_TpDef(vl_src,vl_tgt,vl_pt,vl_d)
    if TimerGetElapsed(zzVL_clock)<LoadReal(zzVL_ht,GetHandleId(vl_tgt),74) then
        set vl_d=vl_d*1.15
    endif
    // bong (KVCT effect_bong, kskill.j status 5): 50% more damage
    if TimerGetElapsed(zzVL_clock)<LoadReal(zzVL_ht,GetHandleId(vl_tgt),81) then
        set vl_d=vl_d*1.5
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
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_he[vl_pt]==3 and zzVL_set[vl_pt]>0 and vl_d>0. and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL and not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and TimerGetElapsed(zzVL_clock)-LoadReal(zzVL_ht,GetHandleId(vl_tgt),78)>=.3 then
        call SaveReal(zzVL_ht,GetHandleId(vl_tgt),78,TimerGetElapsed(zzVL_clock))
        call zzVL_TpHit(vl_tgt,vl_src,vl_d*.02*zzVL_set[vl_pt])
    endif
    call BlzSetEventDamage(vl_d)
    if vl_crit then
        call zzVL_Text(vl_tgt,"|cffff4000"+I2S(R2I(vl_d))+"!|r")
    endif
    // Hiệu ứng trạng thái bộ ngũ hành: chỉ đòn đánh thường của chính tướng, không tính sát thương phụ (độc, phản...)
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_set[vl_ps]>0 and not zzVL_inTp and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL then
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
    local integer vl_r=zzVL_rank[vl_playerId]
    if vl_hero==null or vl_r<1 then
        set vl_hero=null
        return
    endif
    if zzVL_tag[vl_playerId]==null then
        set zzVL_tag[vl_playerId]=CreateTextTag()
        call SetTextTagPermanent(zzVL_tag[vl_playerId],true)
    endif
    call SetTextTagText(zzVL_tag[vl_playerId],zzVL_tn[vl_r],.026)
    call zzVL_All(zzVL_Name(vl_playerId)+" nhận danh hiệu "+zzVL_tn[vl_r])
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
    set zzVL_ct[vl_playerId]=IMaxBJ(0,zzVL_ct[vl_playerId]+vl_n)
    loop
        exitwhen vl_r>=5 or zzVL_ct[vl_playerId]<zzVL_rq[vl_r+1]
        set vl_r=vl_r+1
    endloop
    if vl_r>zzVL_rank[vl_playerId] then
        set zzVL_rank[vl_playerId]=vl_r
        call zzVL_All(zzVL_Name(vl_playerId)+" thăng quân hàm |cffffcc00"+zzVL_rn[vl_r]+"|r (+"+I2S(2*vl_r)+"% sát thương)")
        if vl_hero!=null then
            if zzVL_pn[vl_playerId]==null then
                set zzVL_pn[vl_playerId]=GetHeroProperName(vl_hero)
            endif
            call BlzSetHeroProperName(vl_hero,"|cffffcc00"+zzVL_rn[vl_r]+"|r "+zzVL_pn[vl_playerId])
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",vl_hero,"origin"))
            call zzVL_GiveCloak(vl_playerId)
            call zzVL_AffixSum(vl_playerId)
        endif
    endif
    set vl_hero=null
endfunction
// ---- nhiem vu Su Gia Vo Lam (h01N, one per base): select him with the hero nearby to take a quest.
// 1 Tru Hai Giang Ho: kill creeps; 2 Diet Cuong Dich: kill creeps of level >= 10; 3 Tranh Hung: kill or
// assist on enemy heroes. Done at once: Thuy tinh + gold + cong trang; every 5th quest 2 more Thuy tinh.

// ==========================================
// Hàm: zzVL_QName
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_t (integer)
// Trả về dữ liệu kiểu: string
function zzVL_QName takes integer vl_t returns string
    if vl_t==1 then
        return "Trừ Hại Giang Hồ"
    elseif vl_t==2 then
        return "Diệt Cường Địch"
    endif
    return "Tranh Hùng"
endfunction

// ==========================================
// Hàm: zzVL_QGoal
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_t (integer)
//   - vl_n (integer)
// Trả về dữ liệu kiểu: string
function zzVL_QGoal takes integer vl_t,integer vl_n returns string
    if vl_t==1 then
        return "diệt "+I2S(vl_n)+" quái"
    elseif vl_t==2 then
        return "hạ "+I2S(vl_n)+" quái từ cấp 10 trở lên"
    endif
    return "hạ hoặc hỗ trợ hạ "+I2S(vl_n)+" tướng địch"
endfunction

// ==========================================
// Hàm: zzVL_QShow
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QShow takes integer vl_playerId returns nothing
    if zzVL_qType[vl_playerId]==0 then
        call zzVL_Msg(vl_playerId,"Chưa có nhiệm vụ. Đưa tướng tới gần |cffffcc00Sứ Giả Võ Lâm|r (cạnh căn cứ) rồi bấm chọn ông ấy để nhận. Đã hoàn thành: "+I2S(zzVL_qDone[vl_playerId]))
    else
        call zzVL_Msg(vl_playerId,"|cffffcc00Nhiệm vụ "+zzVL_QName(zzVL_qType[vl_playerId])+"|r: "+zzVL_QGoal(zzVL_qType[vl_playerId],zzVL_qNeed[vl_playerId])+" - "+I2S(zzVL_qHave[vl_playerId])+"/"+I2S(zzVL_qNeed[vl_playerId]))
    endif
endfunction

// ==========================================
// Hàm: zzVL_QGiveTT
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QGiveTT takes unit vl_hero,integer vl_n returns nothing
    local integer vl_i=0
    local item vl_item
    loop
        exitwhen vl_i>=vl_n
        set vl_item=CreateItem('I00W',GetUnitX(vl_hero),GetUnitY(vl_hero))
        call UnitAddItem(vl_hero,vl_item)
        set vl_i=vl_i+1
    endloop
    set vl_item=null
endfunction

// ==========================================
// Hàm: zzVL_QProgress
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_t (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QProgress takes integer vl_playerId,integer vl_t returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_g
    if zzVL_qType[vl_playerId]!=vl_t or vl_hero==null then
        set vl_hero=null
        return
    endif
    set zzVL_qHave[vl_playerId]=zzVL_qHave[vl_playerId]+1
    if zzVL_qHave[vl_playerId]<zzVL_qNeed[vl_playerId] then
        if vl_t!=1 or ModuloInteger(zzVL_qHave[vl_playerId],5)==0 then
            call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,3.,"Nhiệm vụ "+zzVL_QName(vl_t)+": "+I2S(zzVL_qHave[vl_playerId])+"/"+I2S(zzVL_qNeed[vl_playerId]))
        endif
        set vl_hero=null
        return
    endif
    set zzVL_qDone[vl_playerId]=zzVL_qDone[vl_playerId]+1
    set zzVL_qType[vl_playerId]=0
    set vl_g=400+100*zzVL_qDone[vl_playerId]
    call AdjustPlayerStateBJ(vl_g,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
    call zzVL_QGiveTT(vl_hero,1)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",vl_hero,"origin"))
    call zzVL_Msg(vl_playerId,"|cff00ff00Hoàn thành nhiệm vụ "+zzVL_QName(vl_t)+"!|r Nhận 1 Thủy tinh, "+I2S(vl_g)+" ngân lượng, 8 công trạng. Quay lại Sứ Giả Võ Lâm để nhận nhiệm vụ mới.")
    if ModuloInteger(zzVL_qDone[vl_playerId],5)==0 then
        call zzVL_QGiveTT(vl_hero,2)
        call zzVL_All(zzVL_Name(vl_playerId)+" đã hoàn thành "+I2S(zzVL_qDone[vl_playerId])+" nhiệm vụ của Sứ Giả Võ Lâm, nhận thêm 2 Thủy tinh.")
    endif
    call zzVL_AddCT(vl_playerId,8)
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_OnSelect
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnSelect takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local unit vl_npc=GetTriggerUnit()
    local unit vl_hero
    local integer vl_t
    if GetUnitTypeId(vl_npc)!='h01N' or vl_playerId>9 then
        set vl_npc=null
        return
    endif
    set vl_hero=Jx[vl_playerId+1]
    if vl_hero==null or GetWidgetLife(vl_hero)<.405 or not IsUnitInRange(vl_hero,vl_npc,700.) then
        call zzVL_Msg(vl_playerId,"|cffffcc00Sứ Giả Võ Lâm|r: hãy đưa tướng tới gần ta để nhận nhiệm vụ.")
    elseif zzVL_qType[vl_playerId]!=0 then
        call zzVL_QShow(vl_playerId)
    else
        set vl_t=GetRandomInt(1,3)
        set zzVL_qType[vl_playerId]=vl_t
        set zzVL_qHave[vl_playerId]=0
        if vl_t==1 then
            set zzVL_qNeed[vl_playerId]=IMinBJ(15+2*zzVL_qDone[vl_playerId],30)
        elseif vl_t==2 then
            set zzVL_qNeed[vl_playerId]=5
        else
            set zzVL_qNeed[vl_playerId]=2
        endif
        call zzVL_Msg(vl_playerId,"|cffffcc00Sứ Giả Võ Lâm|r giao nhiệm vụ |cffffcc00"+zzVL_QName(vl_t)+"|r: "+zzVL_QGoal(vl_t,zzVL_qNeed[vl_playerId])+". Gõ -nv để xem tiến độ.")
    endif
    set vl_npc=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_OnQuestChat
// Chức năng dự kiến: Hệ thống nhiệm vụ (Sứ Giả Võ Lâm).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnQuestChat takes nothing returns nothing
    call zzVL_QShow(GetPlayerId(GetTriggerPlayer()))
endfunction
// ---- cao thu xuat hien ngau nhien (names from the author's Thien Kiem)

// ==========================================
// Hàm: zzVL_IsCreep
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_unit (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_IsCreep takes unit vl_unit returns boolean
    local integer vl_t=GetUnitTypeId(vl_unit)
    return GetWidgetLife(vl_unit)>.405 and (vl_t=='n001' or vl_t=='n004' or vl_t=='n006' or vl_t=='n007' or vl_t=='n009' or vl_t=='n00A' or vl_t=='n00B' or vl_t=='n00D' or vl_t=='n00E')
endfunction

// ==========================================
// Hàm: zzVL_BossSpawn
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BossSpawn takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local integer vl_n=0
    local integer vl_min=R2I(TimerGetElapsed(zzVL_clock)/60.)
    local integer vl_k
    local integer vl_bid
    call zzVL_Log("boss xuat hien")
    set zzVL_logMsg="|cffff4040TUYỆT ĐẠI CAO THỦ|r xuất hiện ở khu quái!"
    call ExecuteFunc("zzVL_BannerMsg")
    if zzVL_boss!=null and GetWidgetLife(zzVL_boss)>.405 then
        call DestroyGroup(vl_g)
        set vl_g=null
        return
    endif
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
    if vl_pick==null then
        return
    endif
    set vl_k=GetRandomInt(1,5)
    if vl_k==1 then
        set vl_bid='o001'
    elseif vl_k==2 then
        set vl_bid='h01F'
    elseif vl_k==3 then
        set vl_bid='n0TK'
    elseif vl_k==4 then
        set vl_bid='e003'
    else
        set vl_bid='n018'
    endif
    set zzVL_boss=CreateUnit(Player(12),vl_bid,GetUnitX(vl_pick),GetUnitY(vl_pick),GetRandomReal(0,360))
    call SetUnitPosition(zzVL_boss,GetUnitX(vl_pick)-350.,GetUnitY(vl_pick)+250.)
    call BlzSetUnitName(zzVL_boss,"|cffff8000"+zzVL_bn[vl_k]+"|r")
    call BlzSetUnitMaxHP(zzVL_boss,8000+1500*vl_min)
    call SetWidgetLife(zzVL_boss,8000.+1500.*vl_min)
    call BlzSetUnitBaseDamage(zzVL_boss,60+8*vl_min,0)
    call BlzSetUnitArmor(zzVL_boss,10.+vl_min)
    call SetUnitScale(zzVL_boss,2.3,2.3,2.3)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_boss),GetUnitY(zzVL_boss)))
    call zzVL_All("|cffffcc00Chú ý|r: Tuyệt đại cao thủ |cffff8000"+zzVL_bn[vl_k]+"|r tái xuất giang hồ! Hạ được: |cffffcc002 Thủy tinh|r, 1000 ngân lượng, 25 công trạng.")
    call PingMinimapEx(GetUnitX(zzVL_boss),GetUnitY(zzVL_boss),5.,255,128,0,true)
    set vl_pick=null
endfunction

// ==========================================
// Hàm: zzVL_BossKilled
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Tham số:
//   - vl_pk (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_BossKilled takes integer vl_pk returns nothing
    local integer vl_i=0
    call zzVL_All(zzVL_Name(vl_pk)+" đã hạ tuyệt đại cao thủ "+GetUnitName(zzVL_boss)+"!")
    call AdjustPlayerStateBJ(1000,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
    loop
        exitwhen vl_i>9
        if vl_i!=vl_pk and IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
            call AdjustPlayerStateBJ(300,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
        endif
        set vl_i=vl_i+1
    endloop
    call CreateItem('I00W',GetUnitX(zzVL_boss),GetUnitY(zzVL_boss))
    call CreateItem('I00W',GetUnitX(zzVL_boss),GetUnitY(zzVL_boss))
    call zzVL_AddCT(vl_pk,25)
    set zzVL_boss=null
endfunction

// ==========================================
// Hàm: zzVL_AddUD
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_AddUD takes integer vl_playerId,integer vl_n returns nothing
    if Oo then
        return
    endif
    if IsPlayerAlly(Player(vl_playerId),Player(0)) then
        set ro[$B]=ro[$B]+vl_n
    else
        set ro[$C]=ro[$C]+vl_n
    endif
    call MultiboardSetItemValueBJ(eo,3,$C,I2S(ro[$B]))
    call MultiboardSetItemValueBJ(eo,3,$D,I2S(ro[$C]))
    call ConditionalTriggerExecute(IE)
    call ConditionalTriggerExecute(AE)
endfunction

// ==========================================
// Hàm: zzVL_SpawnMC
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_SpawnMC takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local integer vl_n=0
    call zzVL_Log("minh chu xuat hien")
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
    if vl_pick==null then
        return
    endif
    set zzVL_mc=CreateUnit(Player(12),'n008',GetUnitX(vl_pick),GetUnitY(vl_pick),GetRandomReal(0,360))
    call BlzSetUnitName(zzVL_mc,"|cffff0000Võ Lâm Minh Chủ|r")
    call BlzSetUnitMaxHP(zzVL_mc,200000)
    call SetWidgetLife(zzVL_mc,200000.)
    call BlzSetUnitBaseDamage(zzVL_mc,700,0)
    call BlzSetUnitArmor(zzVL_mc,60.)
    call SetUnitScale(zzVL_mc,2.2,2.2,2.2)
    call SetUnitVertexColor(zzVL_mc,255,60,60,255)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_mc),GetUnitY(zzVL_mc)))
    call PingMinimapEx(GetUnitX(zzVL_mc),GetUnitY(zzVL_mc),8.,255,0,0,true)
    call zzVL_All("|cffff0000VÕ LÂM MINH CHỦ|r đã xuất hiện! Phe nào hạ được nhận |cffffcc00+10 uy danh|r, mỗi người 1000 ngân lượng.")
    set vl_pick=null
endfunction

// ==========================================
// Hàm: zzVL_McKilled
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_pk (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_McKilled takes integer vl_pk returns nothing
    local integer vl_i=0
    call zzVL_All(zzVL_Name(vl_pk)+" đã hạ |cffff0000Võ Lâm Minh Chủ|r! Phe "+zzVL_Team(vl_pk)+" nhận +10 uy danh.")
    loop
        exitwhen vl_i>9
        if IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
            call AdjustPlayerStateBJ(1000,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
        endif
        set vl_i=vl_i+1
    endloop
    call zzVL_AddCT(vl_pk,30)
    set zzVL_mc=null
    call zzVL_AddUD(vl_pk,10)
endfunction
// ---- su kien: tuyet dai cao thu moi 7 phut (7', 14', 21'...), Vo Lam Minh Chu moi 18 phut (neu con song thi bo qua);
// moi tinh nang co tu dau tran, tran ket thuc theo moc uy danh nhu ban goc

// ==========================================
// Hàm: zzVL_CountUnits
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Trả về dữ liệu kiểu: integer
function zzVL_CountUnits takes nothing returns integer
    local group vl_g=CreateGroup()
    local integer vl_n
    call GroupEnumUnitsInRect(vl_g,bj_mapInitialPlayableArea,null)
    set vl_n=CountUnitsInGroup(vl_g)
    call DestroyGroup(vl_g)
    set vl_g=null
    return vl_n
endfunction

// ==========================================
// Hàm: zzVL_EventTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_EventTick takes nothing returns nothing
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    if ModuloInteger(R2I(TimerGetElapsed(zzVL_clock)),60)==0 then
        call zzVL_Log("-- phut "+I2S(vl_m)+", don vi: "+I2S(zzVL_CountUnits()))
    endif
    if vl_m>=zzVL_nextBoss then
        set zzVL_nextBoss=zzVL_nextBoss+7
        call zzVL_BossSpawn()
    endif
    if vl_m>=zzVL_nextMc then
        set zzVL_nextMc=zzVL_nextMc+18
        if zzVL_mc==null or GetWidgetLife(zzVL_mc)<.405 then
            call zzVL_SpawnMC()
        endif
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnEventChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnEventChat takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,15.,"|cffffcc00Phút "+I2S(vl_m)+"|r - uy danh: Tống "+I2S(ro[$B])+" - Kim "+I2S(ro[$C])+" (mốc thắng "+I2S(Do)+")|nTuyệt đại cao thủ kế tiếp: phút "+I2S(zzVL_nextBoss)+"|nVõ Lâm Minh Chủ kế tiếp: phút "+I2S(zzVL_nextMc))
endfunction
// ---- quai: ca phe cung huong, khong can danh phat cuoi. Nguoi ha van nhan tien thuong goc; dong doi
// nhan vang ~ tien thuong (3+2*cap), dong doi o xa (ngoai 1200, game khong chia kinh nghiem) nhan 10+8*cap kinh nghiem

// ==========================================
// Hàm: zzVL_ShareCreep
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_pk (integer)
//   - vl_d (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_ShareCreep takes integer vl_pk,unit vl_d returns nothing
    local integer vl_i=0
    local integer vl_lv=GetUnitLevel(vl_d)
    local integer vl_g=3+2*vl_lv
    local integer vl_x=10+8*vl_lv
    local unit vl_hero
    loop
        exitwhen vl_i>9
        set vl_hero=Jx[vl_i+1]
        if vl_i!=vl_pk and vl_hero!=null and IsPlayerAlly(Player(vl_i),Player(vl_pk)) and GetPlayerSlotState(Player(vl_i))==PLAYER_SLOT_STATE_PLAYING then
            call AdjustPlayerStateBJ(vl_g,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
            if GetWidgetLife(vl_hero)>.405 and not IsUnitInRange(vl_hero,vl_d,1200.) then
                call AddHeroXP(vl_hero,vl_x,true)
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_CheckWin
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_CheckWin takes nothing returns nothing
    local integer vl_i=0
    local player vl_wp=null
    if zzVL_winKills>0 then
        if zzVL_teamK[0]>=zzVL_winKills then
            set vl_wp=Player(0)
        elseif zzVL_teamK[1]>=zzVL_winKills then
            set vl_wp=Player(5)
        endif
    endif
    if vl_wp!=null then
        loop
            exitwhen vl_i>9
            if IsPlayerAlly(Player(vl_i),vl_wp) then
                call CustomVictoryBJ(Player(vl_i),true,true)
            else
                call CustomDefeatBJ(Player(vl_i),"Thất bại!")
            endif
            set vl_i=vl_i+1
        endloop
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnWinChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnWinChat takes nothing returns nothing
    local string vl_string=GetEventPlayerChatString()
    local string vl_args=SubString(vl_string,5,StringLength(vl_string))
    set zzVL_winKills=S2I(vl_args)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10.,"|cffffcc00Mốc mạng chiến thắng thay đổi thành: |r"+I2S(zzVL_winKills)+" mạng.")
endfunction

// ==========================================
// Hàm: zzVL_OnDeath
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnDeath takes nothing returns nothing
    local unit vl_d=GetDyingUnit()
    local unit vl_k=GetKillingUnit()
    local integer vl_pk
    local integer vl_pd
    local integer vl_i=0
    if vl_d!=null then
        call zzVL_CampDeath(vl_d)
    endif
    if vl_d!=null and IsUnitType(vl_d,UNIT_TYPE_HERO) and GetPlayerId(GetOwningPlayer(vl_d))<10 and vl_d==Jx[GetPlayerId(GetOwningPlayer(vl_d))+1] then
        set zzVL_deaths[GetPlayerId(GetOwningPlayer(vl_d))]=zzVL_deaths[GetPlayerId(GetOwningPlayer(vl_d))]+1
        if vl_k!=null and GetPlayerId(GetOwningPlayer(vl_k))<10 and IsUnitEnemy(vl_d,GetOwningPlayer(vl_k)) then
            set zzVL_kills[GetPlayerId(GetOwningPlayer(vl_k))]=zzVL_kills[GetPlayerId(GetOwningPlayer(vl_k))]+1
            if IsPlayerAlly(GetOwningPlayer(vl_k),Player(0)) then
                set zzVL_teamK[0]=zzVL_teamK[0]+1
            else
                set zzVL_teamK[1]=zzVL_teamK[1]+1
            endif
            call zzVL_CheckWin()
        endif
        call zzVL_Log("tuong chet p"+I2S(GetPlayerId(GetOwningPlayer(vl_d))))
    endif
    if vl_k!=null and vl_d!=null then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
        set vl_pd=GetPlayerId(GetOwningPlayer(vl_d))
        if vl_pd<10 and vl_d==Jx[vl_pd+1] and vl_pk>=10 then
            // bi the luc ngoai dao danh bai
            call zzVL_AddCT(vl_pd,-3)
            call zzVL_Msg(vl_pd,"|cffff8000Bị thế lực ngoại đạo đánh bại, công trạng giảm 3.|r")
        elseif vl_pk<10 and Jx[vl_pk+1]!=null and IsUnitEnemy(vl_d,Player(vl_pk)) then
            if vl_pd>=10 and not IsUnitType(vl_d,UNIT_TYPE_HERO) and not IsUnitType(vl_d,UNIT_TYPE_STRUCTURE) then
                call zzVL_ShareCreep(vl_pk,vl_d)
                call zzVL_QProgress(vl_pk,1)
                if GetUnitLevel(vl_d)>=10 then
                    call zzVL_QProgress(vl_pk,2)
                endif
            endif
            if vl_d==zzVL_mc then
                call zzVL_McKilled(vl_pk)
            elseif vl_d==zzVL_boss then
                call zzVL_BossKilled(vl_pk)
            elseif vl_pd<10 and vl_d==Jx[vl_pd+1] then
                if not zzVL_fb then
                    set zzVL_fb=true
                    call zzVL_All("|cffff4000Nhất đao đoạt mạng!|r "+zzVL_Name(vl_pk)+" hạ "+GetPlayerName(Player(vl_pd))+" đầu tiên, nhận thêm 500 ngân lượng và 10 công trạng.")
                    call AdjustPlayerStateBJ(500,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
                    call zzVL_AddCT(vl_pk,10)
                endif
                call zzVL_AddCT(vl_pk,10)
                call zzVL_QProgress(vl_pk,3)
                call AdjustPlayerStateBJ(300,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
                loop
                    exitwhen vl_i>9
                    if vl_i!=vl_pk and IsPlayerAlly(Player(vl_i),Player(vl_pk)) and Jx[vl_i+1]!=null and GetWidgetLife(Jx[vl_i+1])>.405 and IsUnitInRange(Jx[vl_i+1],vl_d,1200.) then
                        call zzVL_AddCT(vl_i,4)
                        call zzVL_QProgress(vl_i,3)
                    endif
                    set vl_i=vl_i+1
                endloop
            elseif vl_pd>=10 and GetUnitState(vl_d,UNIT_STATE_MAX_LIFE)>=5000. then
                call zzVL_AddCT(vl_pk,15)
            endif
        endif
    endif
    set vl_d=null
    set vl_k=null
endfunction
// ---- a cloak picked up by another player's hero goes back to its owner

// ==========================================
// Hàm: zzVL_OnItem
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnItem takes nothing returns nothing
    local item vl_item=GetManipulatedItem()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    call RemoveSavedInteger(zzVL_ht,GetHandleId(vl_item),67)
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),1)>0 and GetItemUserData(vl_item)!=vl_playerId+1 then
        call UnitRemoveItem(GetTriggerUnit(),vl_item)
        call zzVL_Msg(vl_playerId,"Phi phong này đã có chủ.")
    endif
    set vl_item=null
endfunction
// ---- tu thi trien: skills with a cooldown <= 15 s (table from tools\skills.py: hero type key 10.. = skill,
// skill key 2 = order id, key 3 = 0 none / 1 unit / 2 point) cast themselves on the hero's current target
// while a player's hero fights; never while the player is moving the hero; ultimates stay manual. -auto toggles.

// ==========================================
// Hàm: zzVL_OnAttack
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAttack takes nothing returns nothing
    local unit vl_a=GetAttacker()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_a))
    if vl_playerId<10 and vl_a==Jx[vl_playerId+1] then
        set zzVL_tgt[vl_playerId]=GetTriggerUnit()
        set zzVL_tgtT[vl_playerId]=TimerGetElapsed(zzVL_clock)
    endif
    set vl_a=null
endfunction

// ==========================================
// Hàm: zzVL_AutoTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AutoTick takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_k
    local integer vl_ab
    local integer vl_lv
    local integer vl_ord
    local integer vl_kind
    local integer vl_cur
    local boolean vl_ok
    local unit vl_hero
    local unit vl_t
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        set vl_t=zzVL_tgt[vl_playerId]
        if vl_hero!=null and vl_t!=null and not zzVL_autoOff[vl_playerId] and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER and GetWidgetLife(vl_hero)>.405 then
            set vl_cur=GetUnitCurrentOrder(vl_hero)
            if GetWidgetLife(vl_t)>.405 and IsUnitEnemy(vl_t,Player(vl_playerId)) and IsUnitVisible(vl_t,Player(vl_playerId)) and IsUnitInRange(vl_hero,vl_t,900.) and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]<3. and (vl_cur==0 or vl_cur==851983 or vl_cur==851971) then
                set vl_ok=false
                set vl_k=10
                loop
                    set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),vl_k)
                    exitwhen vl_ab==0 or vl_ok
                    set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
                    if vl_lv>0 and BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)<=.01 and BlzGetAbilityCooldown(vl_ab,vl_lv-1)<=15. and GetUnitState(vl_hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
                        set vl_ord=LoadInteger(zzVL_ht,vl_ab,2)
                        set vl_kind=LoadInteger(zzVL_ht,vl_ab,3)
                        // 4: a KVCT toggle (kskill.j zzKS_Toggle), cast only while it is off
                        if vl_kind==4 and HaveSavedHandle(zzVL_ht,GetHandleId(vl_hero),vl_ab) then
                            set vl_ok=false
                        elseif vl_kind==1 then
                            set vl_ok=IssueTargetOrderById(vl_hero,vl_ord,vl_t)
                        elseif vl_kind==2 then
                            set vl_ok=IssuePointOrderById(vl_hero,vl_ord,GetUnitX(vl_t),GetUnitY(vl_t))
                        else
                            set vl_ok=IssueImmediateOrderById(vl_hero,vl_ord)
                        endif
                    endif
                    set vl_k=vl_k+1
                endloop
                if vl_ok then
                    set zzVL_reatk[vl_playerId]=true
                elseif zzVL_reatk[vl_playerId] and vl_cur==0 then
                    set zzVL_reatk[vl_playerId]=false
                    call IssueTargetOrderById(vl_hero,851983,vl_t)
                endif
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_OnAutoChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAutoChat takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    set zzVL_autoOff[vl_playerId]=not zzVL_autoOff[vl_playerId]
    if zzVL_autoOff[vl_playerId] then
        call zzVL_Msg(vl_playerId,"Tự thi triển: |cffff4040TẮT|r. Gõ -auto để bật lại.")
    else
        call zzVL_Msg(vl_playerId,"Tự thi triển: |cff00ff00BẬT|r - chiêu hồi chiêu dưới 15 giây tự ra khi giao chiến, tuyệt chiêu vẫn bấm tay.")
    endif
endfunction
// ---- AI may thong minh hon (runs next to the author's AI, which keeps lanes, retreat at 35% and items):
// focus the weakest enemy hero in range, cast every quick skill, ultimate when 2+ enemy heroes are close or
// the target is below 50%, and go for the tuyet dai cao thu / Minh Chu while healthy.

// ==========================================
// Hàm: zzVL_TryCast
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_t (unit)
//   - vl_key (integer)
// Trả về dữ liệu kiểu: boolean
function zzVL_TryCast takes unit vl_hero,unit vl_t,integer vl_key returns boolean
    local integer vl_ab
    local integer vl_lv
    local integer vl_kind
    local integer vl_ord
    loop
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),vl_key)
        exitwhen vl_ab==0
        set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
        if vl_lv>0 and BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)<=.01 and GetUnitState(vl_hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
            set vl_ord=LoadInteger(zzVL_ht,vl_ab,2)
            set vl_kind=LoadInteger(zzVL_ht,vl_ab,3)
            if vl_kind==1 and IssueTargetOrderById(vl_hero,vl_ord,vl_t) then
                return true
            elseif vl_kind==2 and IssuePointOrderById(vl_hero,vl_ord,GetUnitX(vl_t),GetUnitY(vl_t)) then
                return true
            elseif vl_kind==0 and IssueImmediateOrderById(vl_hero,vl_ord) then
                return true
            elseif vl_kind==4 and not HaveSavedHandle(zzVL_ht,GetHandleId(vl_hero),vl_ab) and IssueImmediateOrderById(vl_hero,vl_ord) then
                return true
            endif
        endif
        set vl_key=vl_key+1
    endloop
    return false
endfunction

// ==========================================
// Hàm: zzVL_AiFight
// Chức năng dự kiến: Trí tuệ nhân tạo (AI) điều khiển bot.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AiFight takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_i
    local integer vl_n
    local integer vl_cur
    local real vl_best
    local real vl_pct
    local unit vl_hero
    local unit vl_e
    local unit vl_t
    local boolean vl_ok
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_COMPUTER and GetWidgetLife(vl_hero)>.405 and GetWidgetLife(vl_hero)>GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.35 then
            set vl_cur=GetUnitCurrentOrder(vl_hero)
            set vl_t=null
            set vl_best=2.
            set vl_n=0
            set vl_i=0
            loop
                exitwhen vl_i>9
                set vl_e=Jx[vl_i+1]
                if vl_e!=null and IsPlayerEnemy(Player(vl_i),Player(vl_playerId)) and GetWidgetLife(vl_e)>.405 and IsUnitVisible(vl_e,Player(vl_playerId)) and IsUnitInRange(vl_hero,vl_e,800.) then
                    set vl_n=vl_n+1
                    set vl_pct=GetWidgetLife(vl_e)/GetUnitState(vl_e,UNIT_STATE_MAX_LIFE)
                    if vl_pct<vl_best then
                        set vl_best=vl_pct
                        set vl_t=vl_e
                    endif
                endif
                set vl_i=vl_i+1
            endloop
            if vl_t==null and zzVL_tgt[vl_playerId]!=null and GetWidgetLife(zzVL_tgt[vl_playerId])>.405 and IsUnitInRange(vl_hero,zzVL_tgt[vl_playerId],800.) and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]<3. then
                set vl_t=zzVL_tgt[vl_playerId]
            endif
            if vl_t!=null and (vl_cur==0 or vl_cur==851983 or vl_cur==851971) then
                set vl_ok=false
                if IsUnitType(vl_t,UNIT_TYPE_HERO) and (vl_n>=2 or vl_best<.5) then
                    set vl_ok=zzVL_TryCast(vl_hero,vl_t,20)
                endif
                if not vl_ok then
                    set vl_ok=zzVL_TpAi(vl_hero,vl_t)
                endif
                if not vl_ok then
                    set vl_ok=zzVL_TryCast(vl_hero,vl_t,10)
                endif
                if not vl_ok and IsUnitType(vl_t,UNIT_TYPE_HERO) and (vl_t!=zzVL_aiTgt[vl_playerId] or vl_cur==0) then
                    set zzVL_aiTgt[vl_playerId]=vl_t
                    call IssueTargetOrderById(vl_hero,851983,vl_t)
                endif
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
    set vl_e=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_AiToBoss
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Tham số:
//   - vl_b (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_AiToBoss takes unit vl_b returns nothing
    local integer vl_playerId=0
    local unit vl_hero
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_COMPUTER and GetWidgetLife(vl_hero)>GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.6 and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]>5. then
            call IssuePointOrderById(vl_hero,851983,GetUnitX(vl_b),GetUnitY(vl_b))
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_AiBossTick
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AiBossTick takes nothing returns nothing
    if zzVL_mc!=null and GetWidgetLife(zzVL_mc)>.405 then
        call zzVL_AiToBoss(zzVL_mc)
    elseif zzVL_boss!=null and GetWidgetLife(zzVL_boss)>.405 then
        call zzVL_AiToBoss(zzVL_boss)
    endif
endfunction
// ---- Hanh Trang (custom bag, players only; the computer AI keeps the normal inventory)
// Hero inventory = equipment: 0 hat, 1 armor, 2 weapon, 3 boots, 4 cloak, 5 quick (potions, Thuy tinh...).
// Bag: 30 hidden items per player (zzVL_bag[pid*30+i]). Panel (key B, button, -hd): equipment row (click =
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
        return 5
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),1)>0 then
        return 4
    endif
    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10
    if vl_v>=1 and vl_v<=4 then
        return vl_v-1
    endif
    return 5
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
    call zzVL_CuongIcon(vl_item,0)
    if LoadInteger(zzVL_ht,GetHandleId(vl_item),55)>1 or LoadInteger(zzVL_ht,GetHandleId(vl_item),55)==-1 then
        call zzVL_CuongTip(vl_item,1,0,0)
    endif
    loop
        exitwhen vl_i>29
        if zzVL_bag[vl_playerId*30+vl_i]==null then
            set zzVL_bag[vl_playerId*30+vl_i]=vl_item
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
    if GetItemCharges(vl_item)==0 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10<1 then
        call SetItemCharges(vl_item,1)
    endif
    if GetItemCharges(vl_item)>0 then
        loop
            exitwhen vl_i>29
            set vl_o=zzVL_bag[vl_playerId*30+vl_i]
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
        call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy (30 ô), đồ được để dưới chân tướng.|r")
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
    local integer vl_w
    local item vl_item
    if not zzVL_IsBagUser(vl_playerId) then
        set vl_hero=null
        return
    endif
    loop
        exitwhen vl_k>5
        set vl_item=UnitItemInSlot(vl_hero,vl_k)
        if vl_item!=null and GetItemType(vl_item)!=ITEM_TYPE_POWERUP then
            set vl_w=zzVL_EqSlot(vl_item)
            if vl_w!=vl_k then
                if UnitItemInSlot(vl_hero,vl_w)==null then
                    call UnitDropItemSlot(vl_hero,vl_item,vl_w)
                else
                    call zzVL_ToBag(vl_playerId,vl_hero,vl_item)
                endif
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
    if vl_item==null then
        return "Ô trống"
    endif
    set vl_string=GetItemName(vl_item)
    if GetItemCharges(vl_item)>0 then
        set vl_string=vl_string+" (x"+I2S(GetItemCharges(vl_item))+")"
    endif
    set vl_string=vl_string+"|n"+BlzGetItemDescription(vl_item)
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)<50 then
        set vl_string=vl_string+"|n|cffffcc00Tài phú: "+I2S(zzVL_GearScore(vl_item))+"|r"
    endif
    return vl_string
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
    loop
        exitwhen vl_i>29
        call zzVL_SetSlot(vl_playerId,vl_i,zzVL_bag[vl_playerId*30+vl_i])
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>5
        call zzVL_SetSlot(vl_playerId,30+vl_i,UnitItemInSlot(vl_hero,vl_i))
        if vl_tk!=null then
            call zzVL_SetSlot(vl_playerId,36+vl_i,UnitItemInSlot(vl_tk,vl_i))
        else
            call zzVL_SetSlot(vl_playerId,36+vl_i,null)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_string="|cffffcc00Vàng:|r "+I2S(GetPlayerState(Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD))+"   |cffffcc00Bộ:|r "
    if zzVL_set[vl_playerId]>0 then
        set vl_string=vl_string+zzVL_hn[zzVL_he[vl_playerId]]+" "+I2S(zzVL_set[vl_playerId])+"/5"
    else
        set vl_string=vl_string+"chưa đủ"
    endif
    set vl_string=vl_string+"   |cffffcc00Quân hàm:|r "+zzVL_rn[zzVL_rank[vl_playerId]]+"|n|cffffcc00Cường hóa:|r mũ +"+I2S(zzVL_cuong[vl_playerId*4])+", áo +"+I2S(zzVL_cuong[vl_playerId*4+1])+", vũ khí +"+I2S(zzVL_cuong[vl_playerId*4+2])+", giày +"+I2S(zzVL_cuong[vl_playerId*4+3])
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetText(zzVL_fInfo,vl_string)
        if zzVL_sendTK[vl_playerId] then
            call BlzFrameSetText(zzVL_fMode,"|cff00ff00Gửi đồ: BẬT|r")
        else
            call BlzFrameSetText(zzVL_fMode,"Gửi đồ: TẮT")
        endif
        if zzVL_autoSell[vl_playerId] then
            call BlzFrameSetText(zzVL_fAuto,"|cff00ff00Tự bán: BẬT|r")
        else
            call BlzFrameSetText(zzVL_fAuto,"Tự bán: TẮT")
        endif
        call BlzFrameSetVisible(zzVL_fHl[4],zzVL_autoSell[vl_playerId])
        if zzVL_sellMode[vl_playerId] then
            call BlzFrameSetText(zzVL_fSell,"|cffffcc00Bán|r")
        else
            call BlzFrameSetText(zzVL_fSell,"Bán")
        endif
        if zzVL_splitMode[vl_playerId] then
            call BlzFrameSetText(zzVL_fSplit,"|cff00ff00Tách|r")
        else
            call BlzFrameSetText(zzVL_fSplit,"Tách")
        endif
        if zzVL_khamMode[vl_playerId] then
            call BlzFrameSetText(zzVL_fKham,"|cff80c0ffKhảm|r")
        else
            call BlzFrameSetText(zzVL_fKham,"Khảm")
        endif
        call BlzFrameSetVisible(zzVL_fHl[0],zzVL_sendTK[vl_playerId])
        call BlzFrameSetVisible(zzVL_fHl[1],zzVL_sellMode[vl_playerId])
        call BlzFrameSetVisible(zzVL_fHl[2],zzVL_splitMode[vl_playerId])
        call BlzFrameSetVisible(zzVL_fHl[3],zzVL_khamMode[vl_playerId])
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
    local item vl_item=zzVL_bag[vl_playerId*30+vl_code]
    local integer vl_g=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),41)
    local integer vl_c=GetItemCharges(vl_item)
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
    set zzVL_bag[vl_playerId*30+vl_code]=null
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
    local item vl_item=zzVL_bag[vl_playerId*30+vl_code]
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
        call zzVL_Msg(vl_playerId,"Chỉ khảm được vào trang bị (mũ, áo, vũ khí, giày).")
        set vl_m=null
        return
    endif
    set vl_id=GetHandleId(vl_g)
    if LoadInteger(zzVL_ht,vl_id,43)>=2 then
        call zzVL_Msg(vl_playerId,"Món này đã khảm đủ 2 lỗ.")
        set vl_m=null
        return
    endif
    set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_m),44)
    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_m),45)
    call SaveInteger(zzVL_ht,vl_id,43,LoadInteger(zzVL_ht,vl_id,43)+1)
    call SaveInteger(zzVL_ht,vl_id,30+vl_k,LoadInteger(zzVL_ht,vl_id,30+vl_k)+vl_v)
    set vl_string="|n|cff80c0ff[Khảm] "+GetItemName(vl_m)+": "+zzVL_KhamText(vl_k,vl_v)+"|r"
    if LoadInteger(zzVL_ht,vl_id,55)>0 then
        call SaveStr(zzVL_ht,vl_id,54,LoadStr(zzVL_ht,vl_id,54)+vl_string)
        call SaveStr(zzVL_ht,vl_id,56,LoadStr(zzVL_ht,vl_id,56)+vl_string)
        call SaveInteger(zzVL_ht,vl_id,55,-1)
    else
        call BlzSetItemDescription(vl_g,BlzGetItemDescription(vl_g)+vl_string)
        call BlzSetItemExtendedTooltip(vl_g,BlzGetItemExtendedTooltip(vl_g)+vl_string)
    endif
    call zzVL_Log("kham p"+I2S(vl_playerId))
    call zzVL_Msg(vl_playerId,"|cff80c0ffKhảm thành công|r "+GetItemName(vl_m)+" vào "+GetItemName(vl_g)+": "+zzVL_KhamText(vl_k,vl_v)+" (lỗ "+I2S(LoadInteger(zzVL_ht,vl_id,43))+"/2)")
    if GetItemCharges(vl_m)>1 then
        call SetItemCharges(vl_m,GetItemCharges(vl_m)-1)
    else
        loop
            exitwhen vl_i>29
            if zzVL_bag[vl_playerId*30+vl_i]==vl_m then
                set zzVL_bag[vl_playerId*30+vl_i]=null
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
// Hàm: zzVL_TtUse
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_g (item)
// Không trả về giá trị (thực thi hành động).
function zzVL_TtUse takes integer vl_playerId,item vl_g returns nothing
    local item vl_t=zzVL_tSel[vl_playerId]
    local integer vl_i=0
    set zzVL_tSel[vl_playerId]=null
    if vl_t==null or GetItemTypeId(vl_t)!='I00W' then
        set vl_t=null
        return
    endif
    if zzVL_CuongDo(Jx[vl_playerId+1],vl_g) then
        if GetItemCharges(vl_t)>1 then
            call SetItemCharges(vl_t,GetItemCharges(vl_t)-1)
        else
            loop
                exitwhen vl_i>29
                if zzVL_bag[vl_playerId*30+vl_i]==vl_t then
                    set zzVL_bag[vl_playerId*30+vl_i]=null
                endif
                set vl_i=vl_i+1
            endloop
            call RemoveItem(vl_t)
        endif
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
        exitwhen vl_i>29
        set vl_item=zzVL_bag[vl_playerId*30+vl_i]
        if vl_item!=null and (GetItemTypeId(vl_item)==vl_t or LoadInteger(zzVL_ht,GetItemTypeId(vl_item),59)==vl_t) then
            if vl_take then
                if GetItemCharges(vl_item)>1 then
                    call SetItemCharges(vl_item,GetItemCharges(vl_item)-1)
                else
                    set zzVL_bag[vl_playerId*30+vl_i]=null
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
        set vl_item=UnitItemInSlot(vl_hero,vl_i)
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
// Hàm: zzVL_BagClick
// Chức năng dự kiến: Xử lý giao diện Hành Trang và UI.
// Tham số:
//   - vl_playerId (integer)
//   - vl_code (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_BagClick takes integer vl_playerId,integer vl_code returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local unit vl_tk=Er[vl_playerId+1]
    local item vl_item
    local item vl_old
    local integer vl_w
    call zzVL_Log("bag p"+I2S(vl_playerId)+" o "+I2S(vl_code))
    if vl_code==50 then
        set zzVL_heroOpen[vl_playerId]=not zzVL_heroOpen[vl_playerId]
        call ExecuteFunc("zzVL_HeroTick")
        set vl_hero=null
        set vl_tk=null
        return
    endif
    if vl_code==49 then
        set zzVL_autoSell[vl_playerId]=not zzVL_autoSell[vl_playerId]
        if zzVL_autoSell[vl_playerId] then
            call zzVL_Msg(vl_playerId,"Tự bán: |cff00ff00BẬT|r - đồ nhặt được mạnh hơn sẽ tự mặc, đồ yếu hơn tự bán (đồ đã khảm giữ lại).")
        else
            call zzVL_Msg(vl_playerId,"Tự bán: |cffff4040TẮT|r")
        endif
        call zzVL_Refresh(vl_playerId)
        set vl_hero=null
        set vl_tk=null
        return
    endif
    if vl_code<30 then
        set vl_item=zzVL_bag[vl_playerId*30+vl_code]
        if vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 then
            if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 then
                set zzVL_kSel[vl_playerId]=1
                set zzVL_kItem[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị (đang mặc hoặc trong hành trang) để khảm.")
            else
                call zzVL_Msg(vl_playerId,"Món này không phải nguyên liệu khảm. Nguyên liệu: các loại Bảo Thạch, Kim Cương, Nữ Oa Tinh Thạch, Long Nguyên, Sa Nhung, Bồ Đề Mộc, Thiên Niên Cổ Vật.")
            endif
        elseif vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif vl_item!=null then
            if zzVL_sellMode[vl_playerId] then
                call zzVL_Sell(vl_playerId,vl_code)
            elseif zzVL_splitMode[vl_playerId] then
                call zzVL_Split(vl_playerId,vl_code)
            elseif zzVL_tSel[vl_playerId]!=null and zzVL_tSel[vl_playerId]!=vl_item and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10>=1 then
                call zzVL_TtUse(vl_playerId,vl_item)
            elseif GetItemTypeId(vl_item)=='I00W' and not zzVL_sendTK[vl_playerId] then
                set zzVL_tSel[vl_playerId]=vl_item
                call zzVL_Msg(vl_playerId,"Đã chọn |cffffff00Thủy tinh|r. Bấm vào mũ, áo, vũ khí hoặc giày để cường hóa ô đó.")
            elseif zzVL_sendTK[vl_playerId] then
                if vl_tk!=null and UnitInventoryCount(vl_tk)<6 then
                    set zzVL_bag[vl_playerId*30+vl_code]=null
                    call SetItemVisible(vl_item,true)
                    call SetItemPosition(vl_item,GetUnitX(vl_tk),GetUnitY(vl_tk))
                    call UnitAddItem(vl_tk,vl_item)
                else
                    call zzVL_Msg(vl_playerId,"Thủ Khố đã đầy (6 ô).")
                endif
            elseif GetItemCharges(vl_item)>1 and zzVL_EqSlot(vl_item)==5 and (UnitItemInSlot(vl_hero,5)==null or GetItemTypeId(UnitItemInSlot(vl_hero,5))==GetItemTypeId(vl_item)) then
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
                set vl_w=zzVL_EqSlot(vl_item)
                set vl_old=UnitItemInSlot(vl_hero,vl_w)
                set zzVL_bag[vl_playerId*30+vl_code]=null
                if vl_old!=null then
                    call UnitRemoveItem(vl_hero,vl_old)
                    set zzVL_bag[vl_playerId*30+vl_code]=vl_old
                    call SetItemVisible(vl_old,false)
                endif
                call SetItemVisible(vl_item,true)
                call SetItemPosition(vl_item,GetUnitX(vl_hero),GetUnitY(vl_hero))
                if UnitAddItem(vl_hero,vl_item) then
                    call UnitDropItemSlot(vl_hero,vl_item,vl_w)
                else
                    call zzVL_Msg(vl_playerId,"Không mặc được món này lúc này.")
                    if not zzVL_BagAdd(vl_playerId,vl_item) then
                        call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy, đồ được để dưới chân tướng.|r")
                    endif
                endif
            endif
        endif
    elseif vl_code<36 then
        set vl_item=UnitItemInSlot(vl_hero,vl_code-30)
        if vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 then
            set zzVL_kSel[vl_playerId]=1
            set zzVL_kItem[vl_playerId]=vl_item
            call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị để khảm.")
        elseif vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif vl_item!=null and zzVL_tSel[vl_playerId]!=null then
            call zzVL_TtUse(vl_playerId,vl_item)
        elseif vl_item!=null then
            call zzVL_ToBag(vl_playerId,vl_hero,vl_item)
        endif
    elseif vl_code<42 then
        if vl_tk!=null then
            set vl_item=UnitItemInSlot(vl_tk,vl_code-36)
            if vl_item!=null then
                call zzVL_ToBag(vl_playerId,vl_tk,vl_item)
            endif
        endif
    elseif vl_code==42 then
        set zzVL_sendTK[vl_playerId]=not zzVL_sendTK[vl_playerId]
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==48 then
        set zzVL_khamMode[vl_playerId]=not zzVL_khamMode[vl_playerId]
        set zzVL_kSel[vl_playerId]=0
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        if zzVL_khamMode[vl_playerId] then
            call zzVL_Msg(vl_playerId,"|cff80c0ffKhảm|r: bấm nguyên liệu trong hành trang, rồi bấm trang bị. Mỗi trang bị 2 lỗ.")
        endif
    elseif vl_code==46 then
        set zzVL_sellMode[vl_playerId]=not zzVL_sellMode[vl_playerId]
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_splitMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==47 then
        set zzVL_splitMode[vl_playerId]=not zzVL_splitMode[vl_playerId]
        set zzVL_sendTK[vl_playerId]=false
        set zzVL_sellMode[vl_playerId]=false
        set zzVL_khamMode[vl_playerId]=false
        set zzVL_kSel[vl_playerId]=0
    elseif vl_code==45 then
        if vl_tk!=null then
            call zzVL_Craft(vl_tk)
        endif
    elseif vl_code==43 then
        call zzVL_BagShow(vl_playerId,false)
    elseif vl_code==44 then
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
function zzVL_OnFrameClick takes nothing returns nothing
    local framehandle vl_f=BlzGetTriggerFrame()
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_code=LoadInteger(zzVL_ht,GetHandleId(vl_f),7)-1
    if GetLocalPlayer()==GetTriggerPlayer() then
        call BlzFrameSetEnable(vl_f,false)
        call BlzFrameSetEnable(vl_f,true)
    endif
    if vl_code>=0 and zzVL_IsBagUser(vl_playerId) then
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
    if zzVL_lootN<8 and IsItemVisible(vl_item) and not IsItemOwned(vl_item) and GetItemType(vl_item)!=ITEM_TYPE_POWERUP and IsUnitInRangeXY(vl_hero,GetItemX(vl_item),GetItemY(vl_item),150.) then
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
                    call zzVL_Msg(vl_playerId,"|cffff8000Hành trang đã đầy (30 ô).|r")
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
function zzVL_MakeSlot takes integer vl_code,real vl_x,real vl_y returns nothing
    local framehandle vl_b=BlzCreateFrameByType("GLUEBUTTON","",zzVL_fMain,"ScoreScreenTabButtonTemplate",0)
    local framehandle vl_i=BlzCreateFrameByType("BACKDROP","",vl_b,"",0)
    local framehandle vl_bg=BlzCreateFrame("EscMenuBackdrop",vl_b,0,0)
    local framehandle vl_t=BlzCreateFrameByType("TEXT","",vl_bg,"",0)
    call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,vl_x,vl_y)
    call BlzFrameSetSize(vl_b,.034,.034)
    call BlzFrameSetAllPoints(vl_i,vl_b)
    call BlzFrameSetTexture(vl_i,"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp",0,true)
    call BlzFrameSetSize(vl_t,.24,0.)
    call BlzFrameSetAbsPoint(vl_t,FRAMEPOINT_TOPRIGHT,.455,.55)
    call BlzFrameSetPoint(vl_bg,FRAMEPOINT_TOPLEFT,vl_t,FRAMEPOINT_TOPLEFT,-.012,.012)
    call BlzFrameSetPoint(vl_bg,FRAMEPOINT_BOTTOMRIGHT,vl_t,FRAMEPOINT_BOTTOMRIGHT,.012,-.012)
    call BlzFrameSetTooltip(vl_b,vl_bg)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    call BlzTriggerRegisterFrameEvent(zzVL_tClick,vl_b,FRAMEEVENT_CONTROL_CLICK)
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
    call BlzFrameSetSize(vl_b,vl_w,.03)
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
        if UnitItemInSlot(vl_hero,vl_i)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_hero,vl_i)),0)<50 then
            set vl_tp=vl_tp+zzVL_GearScore(UnitItemInSlot(vl_hero,vl_i))
        endif
        set vl_i=vl_i+1
    endloop
    set vl_string="|cffffcc00"+GetHeroProperName(vl_hero)+"|r  -  "+GetUnitName(vl_hero)+"|nCấp |cff00ff00"+I2S(GetHeroLevel(vl_hero))+"|r   Hệ "+zzVL_hn[zzVL_he[vl_playerId]]+"   Quân hàm "+zzVL_rn[zzVL_rank[vl_playerId]]
    set vl_string=vl_string+"|n|n|cffffcc00Sinh lực|r "+I2S(R2I(GetWidgetLife(vl_hero)))+" / "+I2S(BlzGetUnitMaxHP(vl_hero))+"|n|cff6aa0ffNội lực|r "+I2S(R2I(GetUnitState(vl_hero,UNIT_STATE_MANA)))+" / "+I2S(BlzGetUnitMaxMana(vl_hero))
    set vl_string=vl_string+"|n|cffffcc00Công kích|r "+I2S(BlzGetUnitBaseDamage(vl_hero,0)+BlzGetUnitDiceNumber(vl_hero,0))+" - "+I2S(BlzGetUnitBaseDamage(vl_hero,0)+BlzGetUnitDiceNumber(vl_hero,0)*BlzGetUnitDiceSides(vl_hero,0))+"   |cffffcc00Phòng thủ|r "+I2S(R2I(BlzGetUnitArmor(vl_hero)))
    set vl_string=vl_string+"|n|cffff8080Sức mạnh|r "+I2S(GetHeroStr(vl_hero,true))+"   |cff80ff80Thân pháp|r "+I2S(GetHeroAgi(vl_hero,true))+"   |cff80c0ffNội công|r "+I2S(GetHeroInt(vl_hero,true))
    set vl_string=vl_string+"|n|n|cffffcc00Thuộc tính trang bị|r|nHút sinh lực "+I2S(zzVL_af[vl_playerId*16+1])+"%   Hút nội lực "+I2S(zzVL_af[vl_playerId*16+2])+"%|nBạo kích "+I2S(zzVL_af[vl_playerId*16+3])+"%   Tốc đánh +"+I2S(zzVL_af[vl_playerId*16+4])+"%   Tốc độ xuất chiêu +"+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 16))+"%|nSát thương +"+I2S(zzVL_af[vl_playerId*16+5])+"%   Giảm sát thương "+I2S(zzVL_af[vl_playerId*16+6])+"%"
    set vl_string=vl_string+"|nSTVL nội công +"+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 17))+"   STVL ngoại công +"+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 18))+"   Kỹ năng +"+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 22))+" cấp"
    set vl_string=vl_string+"|nKháng: Vật "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 11))+"% Độc "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 12))+"% Thủy "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 13))+"% Hỏa "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 14))+"% Lôi "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 15))+"%"
    set vl_string=vl_string+"|nĐiểm đánh trúng: "+I2S(LoadInteger(zzVL_ht, 1000+vl_playerId, 19))+"   Né tránh: "+I2S(R2I(GetHeroAgi(vl_hero,true)/2.0) + LoadInteger(zzVL_ht, 1000+vl_playerId, 20))+"   Tốc chạy +"+I2S(zzVL_af[vl_playerId*16+13])
    set vl_string=vl_string+"|n|n|cffffcc00Cường hóa|r  mũ +"+I2S(zzVL_cuong[vl_playerId*4])+"  áo +"+I2S(zzVL_cuong[vl_playerId*4+1])+"  vũ khí +"+I2S(zzVL_cuong[vl_playerId*4+2])+"  giày +"+I2S(zzVL_cuong[vl_playerId*4+3])
    set vl_string=vl_string+"|n|cffffcc00Tài phú|r "+I2S(vl_tp)+"|n|cffffcc00Hạ|r "+I2S(zzVL_kills[vl_playerId])+"   |cffffcc00Chết|r "+I2S(zzVL_deaths[vl_playerId])
    set vl_hero=null
    return vl_string
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
    local integer vl_ab
    set zzVL_heroOpen[vl_playerId]=vl_on
    if GetLocalPlayer()==Player(vl_playerId) then
        call BlzFrameSetText(zzVL_fHeroTxt,vl_string)
        if vl_hero!=null and vl_on then
            loop
                set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),200+vl_i)
                exitwhen vl_ab==0 or vl_j>5
                if LoadInteger(zzVL_ht,vl_ab,240)==0 and GetUnitAbilityLevel(vl_hero,vl_ab)>0 then
                    call BlzFrameSetTexture(zzVL_fPassIco[vl_j],BlzGetAbilityIcon(vl_ab),0,true)
                    call BlzFrameSetText(zzVL_fPassTTxt[vl_j],"|cffffcc00"+GetObjectName(vl_ab)+"|r|n"+BlzGetAbilityExtendedTooltip(vl_ab,GetUnitAbilityLevel(vl_hero,vl_ab)-1))
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
    loop
        exitwhen vl_playerId>9
        call zzVL_HeroShow(vl_playerId,zzVL_heroOpen[vl_playerId])
        set vl_playerId=vl_playerId+1
    endloop
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
function zzVL_BagUI takes nothing returns nothing
    local framehandle vl_ui=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local integer vl_i=0
    local real vl_x0=.495
    call BlzLoadTOCFile("war3mapImported\\vltk.toc")
    set zzVL_tClick=CreateTrigger()
    call TriggerAddAction(zzVL_tClick,function zzVL_OnFrameClick)
    set zzVL_fMain=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_TOPLEFT,.475,.565)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_BOTTOMRIGHT,.785,.135)
    call zzVL_Panel(zzVL_fMain,.478,.562,.782,.138,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fMain,.495,.548,.27,"|cffffcc00HÀNH TRANG|r  (phím B)")
    call zzVL_MakeText(zzVL_fMain,.495,.528,.27,"Trang bị - bấm để tháo ra")
    loop
        exitwhen vl_i>5
        call zzVL_MakeSlot(30+vl_i,vl_x0+vl_i*.045,.512)
        set vl_i=vl_i+1
    endloop
    call zzVL_MakeText(zzVL_fMain,.495,.47,.27,"Hành trang - bấm để mặc / dùng")
    set vl_i=0
    loop
        exitwhen vl_i>29
        call zzVL_MakeSlot(vl_i,vl_x0+ModuloInteger(vl_i,6)*.045,.455-(vl_i/6)*.038)
        set vl_i=vl_i+1
    endloop
    call zzVL_MakeText(zzVL_fMain,.495,.262,.27,"Thủ Khố (chế đồ) - bấm để lấy về")
    set vl_i=0
    loop
        exitwhen vl_i>5
        call zzVL_MakeSlot(36+vl_i,vl_x0+vl_i*.045,.246)
        set vl_i=vl_i+1
    endloop
    set zzVL_fMode=zzVL_MakeButton(42,zzVL_fMain,.495,.205,.075,"Gửi đồ: TẮT")
    set zzVL_fSell=zzVL_MakeButton(46,zzVL_fMain,.571,.205,.045,"Bán")
    set zzVL_fSplit=zzVL_MakeButton(47,zzVL_fMain,.617,.205,.045,"Tách")
    set zzVL_fKham=zzVL_MakeButton(48,zzVL_fMain,.663,.205,.05,"Khảm")
    set zzVL_fHl[0]=zzVL_MakeHl(zzVL_fMode)
    set zzVL_fHl[1]=zzVL_MakeHl(zzVL_fSell)
    set zzVL_fHl[2]=zzVL_MakeHl(zzVL_fSplit)
    set zzVL_fHl[3]=zzVL_MakeHl(zzVL_fKham)
    call zzVL_MakeButton(45,zzVL_fMain,.714,.205,.032,"|cff00ffffChế|r")
    call zzVL_MakeButton(43,zzVL_fMain,.747,.205,.03,"X")
    set zzVL_fAuto=zzVL_MakeButton(49,zzVL_fMain,.495,.18,.11,"Tự bán: TẮT")
    set zzVL_fHl[4]=zzVL_MakeHl(zzVL_fAuto)
    set zzVL_fInfo=zzVL_MakeText(zzVL_fMain,.495,.155,.28,"")
    call BlzFrameSetVisible(zzVL_fMain,false)
    set zzVL_fScore=zzVL_MakeText(vl_ui,.685,.52,.10,"")
    call BlzFrameSetSize(zzVL_fScore,.10,.03)
    call BlzFrameSetTextAlignment(zzVL_fScore,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
    set zzVL_fClock=zzVL_MakeText(vl_ui,.67,.548,.12,"|cffffcc00Thời gian|r 0:00")
    set zzVL_fOpen=zzVL_MakeIconButton(44,vl_ui,.232,.566,.045,"war3mapImported\\vl_ui_bag.blp")
    call zzVL_MakeIconButton(50,vl_ui,.280,.566,.045,"war3mapImported\\vl_ui_hero.blp")
    set zzVL_fHero=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_TOPLEFT,.02,.52)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_BOTTOMRIGHT,.30,.18)
    call zzVL_Panel(zzVL_fHero,.023,.517,.297,.183,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fHero,.04,.505,.24,"|cffffcc00NHÂN VẬT|r  (phím C)")
    set zzVL_fHeroTxt=zzVL_MakeText(zzVL_fHero,.04,.48,.245,"")
    call BlzFrameSetSize(zzVL_fHeroTxt,.245,.25)
    set vl_i=0
    loop
        exitwhen vl_i>5
        set zzVL_fPassBtn[vl_i]=BlzCreateFrameByType("GLUEBUTTON","",zzVL_fHero,"ScoreScreenTabButtonTemplate",0)
        call BlzFrameSetSize(zzVL_fPassBtn[vl_i],.03,.03)
        call BlzFrameSetAbsPoint(zzVL_fPassBtn[vl_i],FRAMEPOINT_BOTTOMLEFT,.04+vl_i*.035,.19)
        set zzVL_fPassIco[vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fPassBtn[vl_i],"",0)
        call BlzFrameSetAllPoints(zzVL_fPassIco[vl_i],zzVL_fPassBtn[vl_i])
        set zzVL_fPassTT[vl_i]=BlzCreateFrame("BoxedText",zzVL_fPassBtn[vl_i],0,vl_i+10)
        set zzVL_fPassTTxt[vl_i]=BlzGetFrameByName("BoxedTextValue",vl_i+10)
        call BlzFrameSetTooltip(zzVL_fPassBtn[vl_i],zzVL_fPassTT[vl_i])
        call BlzFrameSetVisible(zzVL_fPassBtn[vl_i],false)
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
        set vl_string=vl_string+"|nBộ trang bị: chưa đủ 4 món (mũ, áo, vũ khí, giày)"
    endif
    set vl_string=vl_string+"|nCông trạng: "+I2S(zzVL_ct[vl_playerId])+" - quân hàm "+zzVL_rn[vl_r]+" (+"+I2S(2*vl_r)+"% sát thương)"
    if vl_r<5 then
        set vl_string=vl_string+", cần "+I2S(zzVL_rq[vl_r+1])+" để lên "+zzVL_rn[vl_r+1]
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
    call QuestSetDescription(vl_q,"|cffffcc00Bộ trang bị|r: đủ mũ, áo, vũ khí, giày. Cấp bộ = món thấp nhất (thường 1, +1..+3 là 2..4, hoàng kim 5). Kim +5% sát thương/cấp và 2%/cấp làm choáng, Mộc hút 3%/cấp và gây độc, Thổ giảm 4% sát thương nhận/cấp, phản 2%/cấp và miễn choáng/chậm ngũ hành, Thủy hồi 0.5% sinh lực/giây/cấp và làm chậm 5%/cấp, Hỏa 4%/cấp gây gấp đôi kèm thiêu đốt (giảm 50% hồi máu).|n|cffffcc00Ngũ hành|r: đánh thường vào hệ bị khắc +20%.|n|cffffcc00Quân hàm|r: hạ tướng +10, hỗ trợ +4, hạ trùm +15, bị quái hạ -3. Mỗi bậc +2% sát thương và tự động nâng cấp chỉ số phi phong ẩn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Hành trang và nhiệm vụ")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: bấm phím B (hoặc nút Hành Trang, gõ -hd). Túi tướng là 6 ô trang bị: mũ, áo, vũ khí, giày, phi phong, ô dùng nhanh (thuốc, Thủy tinh). Đồ khác nằm trong hành trang 30 ô, bấm để mặc. Chế đồ: bật Gửi Thủ Khố rồi bấm nguyên liệu.|n|cffffcc00Nhiệm vụ|r: đưa tướng tới gần Sứ Giả Võ Lâm (cạnh căn cứ) rồi bấm chọn ông ấy. Xong được Thủy tinh, ngân lượng, công trạng; cứ 5 nhiệm vụ thêm 2 Thủy tinh. Gõ -nv để xem.|n|cffffcc00Đánh quái|r: cả phe cùng nhận vàng, đồng đội ở xa cũng nhận kinh nghiệm, không cần đánh phát cuối.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Phi phong và cao thủ (1.31)")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNCloak.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Phi phong|r: mỗi quân hàm tự động nâng cấp chỉ số phi phong ẩn (tăng sinh lực, giáp, thuộc tính) và nhận danh hiệu trên đầu: Hiệu Úy - Siêu Phàm, Thống Lĩnh - Xuất Trần, Phó Tướng - Kinh Thế, Đại Tướng - Ỷ Thiên, Nguyên Soái - |cffff6000Chí Tôn|r. Phi phong tự gắn vào nhân vật, không chiếm ô hành trang.|n|cffffcc00Tuyệt đại cao thủ|r: cứ 7 phút xuất hiện một lần ở khu quái (có chấm trên bản đồ nhỏ). Hạ được: 2 Thủy tinh, 1000 ngân lượng (đồng đội 300), 25 công trạng.|n|cffffcc00Võ Lâm Minh Chủ|r: cứ 18 phút xuất hiện một lần (nếu Minh Chủ trước đã bị hạ). Phe hạ được +10 uy danh, mỗi người 1000 ngân lượng.|n|cffffcc00Hạ tướng|r: mỗi lần +300 ngân lượng. |cffffcc00Nhất đao đoạt mạng|r: hạ tướng đầu tiên của trận thêm 500 ngân lượng, 10 công trạng.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Trấn phái, rơi đồ, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNSpell_ThuanDuongVoCuc.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Tuyệt học trấn phái|r: tướng cấp 75 lĩnh ngộ kỹ năng thứ 5 của môn phái, mỗi 25 cấp tướng lên một cấp (tối đa 5). Võ Đang Thuần Dương Vô Cực Công, Thiên Vương Duy Ngã Độc Tôn, Côn Luân Vô Nhân Vô Ngã, Thiếu Lâm Kim Chung Tráo, Nga My Cửu Âm Chân Kinh, Cái Bang Hàng Long Thập Bát Chưởng, Ngũ Độc Cửu Âm Bạch Cốt Trảo, Đường Môn Bạo Vũ Lê Hoa Châm, Thúy Yên Băng Tâm Tiên Tử, Thiên Nhẫn Thiên Ma Giải Thể, Đại Lý Cửu Dương Thần Công.|n|cffffcc00Rơi đồ|r: mỗi món trang bị chỉ rơi 5 lần mỗi trận, sau đó rơi món khác. Nguyên liệu rơi không giới hạn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Cường hóa, khảm, hành trang")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNInventory.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: nguyên liệu cùng loại tự cộng dồn. Bật Tách rồi bấm để chia đôi, bật Bán rồi bấm để bán ngay. |cffffcc00Cường hóa|r: dùng Thủy tinh lên mũ/áo/vũ khí/giày để tăng cấp cường hóa của ô đó (tối đa +10), thay món mới vẫn giữ. Bật Khảm, bấm nguyên liệu rồi bấm trang bị: mỗi trang bị 2 lỗ, mỗi loại nguyên liệu một thuộc tính (Bảo Thạch hút máu, bạo kích, tốc đánh..., Kim Cương sát thương, Nữ Oa sinh lực...).")
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

// ==========================================
// Hàm: zzVL_Init
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_Init takes nothing returns nothing
    local trigger vl_t
    local integer vl_i=0
    set zzVL_ht=InitHashtable()
    call zzVL_Items()
    call TimerStart(CreateTimer(),3.,false,function zzVL_Music)
    call ExecuteFunc("zzKS_Init")
    call ExecuteFunc("zzUI_Setup")
    call zzVL_KhamInit()
    set zzVL_hn[0]="Chưa có"
    set zzVL_hn[1]="|cffffd700Kim|r"
    set zzVL_hn[2]="|cff40c040Mộc|r"
    set zzVL_hn[3]="|cffc08040Thổ|r"
    set zzVL_hn[4]="|cff4080ffThủy|r"
    set zzVL_hn[5]="|cffff4040Hỏa|r"
    set zzVL_rn[0]="Binh Sĩ"
    set zzVL_rn[1]="Hiệu Úy"
    set zzVL_rn[2]="Thống Lĩnh"
    set zzVL_rn[3]="Phó Tướng"
    set zzVL_rn[4]="Đại Tướng"
    set zzVL_rn[5]="Nguyên Soái"
    set zzVL_rq[0]=0
    set zzVL_rq[1]=20
    set zzVL_rq[2]=50
    set zzVL_rq[3]=100
    set zzVL_rq[4]=170
    set zzVL_rq[5]=260
    set zzVL_tn[1]="|cffc0c0c0[Siêu Phàm]|r"
    set zzVL_tn[2]="|cff40c0ff[Xuất Trần]|r"
    set zzVL_tn[3]="|cff40ff40[Kinh Thế]|r"
    set zzVL_tn[4]="|cffffcc00[Ỷ Thiên]|r"
    set zzVL_tn[5]="|cffff6000[Chí Tôn]|r"
    set zzVL_bn[1]="Cửu Như"
    set zzVL_bn[2]="Lam Vũ"
    set zzVL_bn[3]="Diệp Thanh"
    set zzVL_bn[4]="Lâm Tú Nhi"
    set zzVL_bn[5]="Lãnh Như Băng"
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
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzVL_OnGmCheat)
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
    call TriggerAddAction(vl_t,function zzVL_OnTabKey)
    set vl_t=CreateTrigger()
    set vl_i=0
    loop
        exitwhen vl_i>9
        call BlzTriggerRegisterPlayerKeyEvent(vl_t,Player(vl_i),OSKEY_TAB,0,true)
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