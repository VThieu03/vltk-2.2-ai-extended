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
    // ghi file nhat ky toi da 1 lan / 3 giay (moi lan ghi la mot lan dung hinh)
    if not zzVL_logBusy and TimerGetElapsed(zzVL_clock)>=zzVL_logT then
        set zzVL_logT=TimerGetElapsed(zzVL_clock)+3.
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
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_i=0
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)/10==3 then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction
