// ---- Hệ trang bị KVCT (nhóm DATA): 10 ô, 11 loại vũ khí, bậc cường hóa 0..10 (+ vũ khí Tần Lăng = bậc 11), phái <-> loại vũ khí.
// File này CHỈ phụ thuộc biến toàn cục (zzVL_ht, zzVL_equipItem, zzVL_af, zzVL_cuong, Jx) và gameplay_01_core.j (zzVL_Msg, zzVL_Text),
// nên khi ghép phải nằm SAU gameplay_01 và TRƯỚC gameplay_02 (gameplay_02 / 03 / 08 / 10 / 12 đều gọi zzEQ_*), xem docs/trangbi/DATA_VABAN.md.
//
// Bảng dữ liệu do tools/kvequip.py ghi (zzVL_Items), khóa hashtable zzVL_ht:
//   trên LOẠI vật phẩm (ITV0..ITVA, ITS1.., ITW0..ITWA):
//     0   = loại*10 + bậc nền (hệ cũ: loại 1 mũ, 2 áo, 3 vũ khí, 4 giày, 5 yêu đái, 6 hộ uyển, 7 hạng liên, 8 giới chỉ, 9 ngọc bội, 10 hộ thân phù)
//     91  = ô KVCT 1..10 (nón, áo, lưng, tay, giày, vũ khí, liên, nhẫn, bội, hộ phù)
//     92  = loại vũ khí + 1 (0..10 -> 1..11), 0 nếu không phải vũ khí
//     93  = 1 trang bị KVCT thường, 2 vũ khí Tần Lăng (luôn bậc 11)
//     66  = hệ ngũ hành vũ khí (khóa cũ của gameplay.py)
//     100+t (chuỗi) = tên (kèm mã màu, chưa đóng |r) ở bậc t; 120+t (chuỗi) = đường dẫn icon bậc t
//     139 = số chỉ số nền, 140+2j = mã chỉ số, 141+2j = giá trị nền (100%)
//   trên LOẠI tướng (E000, H014...): 96 = loại vũ khí chính + 1 (vũ khí khởi đầu), 400+w = 1 nếu phái mặc được loại vũ khí w
//   trên vật phẩm đang cầm (GetHandleId): 90 = bậc cường hóa, 94 (chuỗi) = tiêu đề bậc đang gắn ở đầu mô tả, 97 = đã khởi tạo
//
// Mã chỉ số (khớp kvequip_data.STAT_NAME): 1 hút sinh lực %, 2 hút nội lực %, 3 bạo kích %, 4 tốc đánh %, 5 sát thương %,
// 6 giảm sát thương nhận %, 7 sinh lực, 8 sức mạnh, 9 thân pháp, 10 nội công, 11..15 kháng vật lý/độc/thủy/hỏa/lôi %,
// 16 tốc độ xuất chiêu %, 17 STVL nội công, 18 STVL ngoại công, 19 điểm đánh trúng, 20 né tránh, 21 tốc chạy, 23 sát thương gốc, 24 giáp.

// ==========================================
// BẢNG DÒNG CHỈ SỐ NGẪU NHIÊN <-> Ô TRANG BỊ (một chỗ duy nhất, mỗi dòng k một dòng lệnh).
// Chuỗi trả về = các ô được phép rơi dòng k: ký tự '1'..'9','A' = ô 1..10 (nón, áo, lưng, tay, giày, vũ khí, liên, nhẫn, bội, hộ phù).
// Chuỗi rỗng = dòng đó KHÔNG BAO GIỜ rơi (chưa được người dùng phân ô). Thêm / bớt ô cho một dòng chỉ sửa đúng dòng của nó.
// k: 1 hút sinh lực, 2 hút nội lực, 3 bạo kích, 4 tốc đánh, 5 sát thương, 6 giảm sát thương nhận, 7 sinh lực, 8 sức mạnh, 9 thân pháp,
//    10 nội công, 11..15 kháng vật lý/độc/thủy/hỏa/lôi, 16 tốc độ xuất chiêu, 17 STVL nội công, 18 STVL ngoại công, 19 điểm đánh trúng,
//    20 né tránh, 21 tốc chạy, 22 +kỹ năng.
function zzEQ_AffixSlots takes integer vl_k returns string
    if vl_k==1 then
        return "6"
    elseif vl_k==2 then
        return "6"
    elseif vl_k==3 then
        return "7"
    elseif vl_k==4 then
        return "6"
    elseif vl_k==5 then
        return "6"
    elseif vl_k==6 then
        return "12"
    elseif vl_k==7 then
        return "12"
    elseif vl_k==8 then
        return "7"
    elseif vl_k==9 then
        return "7"
    elseif vl_k==10 then
        return "7"
    elseif vl_k>=11 and vl_k<=15 then
        return "123459A"
    elseif vl_k==16 then
        return "6"
    elseif vl_k==17 then
        return "6"
    elseif vl_k==18 then
        return "6"
    elseif vl_k==19 then
        return "6"
    elseif vl_k==20 then
        return "25"
    elseif vl_k==21 then
        return "5"
    elseif vl_k==22 then
        return "8"
    endif
    return ""
endfunction

// Dòng k có được rơi trên ô vl_slot (1..10) không
function zzEQ_AffixOk takes integer vl_slot,integer vl_k returns boolean
    local string vl_s=zzEQ_AffixSlots(vl_k)
    local string vl_c=SubString("123456789A",vl_slot-1,vl_slot)
    local integer vl_i=0
    local integer vl_n=StringLength(vl_s)
    if vl_slot<1 or vl_slot>10 then
        return false
    endif
    loop
        exitwhen vl_i>=vl_n
        if SubString(vl_s,vl_i,vl_i+1)==vl_c then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction

// Chọn ngẫu nhiên một dòng được phép cho ô vl_slot; 0 nếu ô đó chưa có dòng nào
// ==========================================
// BẢNG DÒNG CHỈ SỐ NGẪU NHIÊN (một chỗ duy nhất để chỉnh)
// Giá trị mỗi dòng là số ngẫu nhiên từ zzEQ_AffixMin(k) đến zzEQ_AffixMax(k) (đơn vị như hiển thị: phần trăm hoặc điểm).
function zzEQ_AffixMin takes integer vl_k returns integer
    if vl_k==1 then
        return 2
    elseif vl_k==2 then
        return 2
    elseif vl_k==3 then
        return 3
    elseif vl_k==4 or vl_k==16 then
        return 5
    elseif vl_k>=11 and vl_k<=15 then
        return 5
    elseif vl_k==19 or vl_k==20 then
        return 50
    elseif vl_k==21 then
        return 10
    elseif vl_k==22 then
        return 1
    endif
    return 10
endfunction

function zzEQ_AffixMax takes integer vl_k returns integer
    if vl_k==1 then
        return 6
    elseif vl_k==2 then
        return 5
    elseif vl_k==3 then
        return 8
    elseif vl_k==4 or vl_k==16 then
        return 15
    elseif vl_k>=11 and vl_k<=15 then
        return 20
    elseif vl_k==19 or vl_k==20 then
        return 200
    elseif vl_k==21 then
        return 30
    elseif vl_k==22 then
        return 1
    endif
    return 50
endfunction

// Số dòng ngẫu nhiên của một món rơi: 1 dòng 50%, 2 dòng 35%, 3 dòng 15%.
function zzEQ_LineCount takes nothing returns integer
    local integer vl_r=GetRandomInt(1,100)
    if vl_r<=15 then
        return 3
    elseif vl_r<=50 then
        return 2
    endif
    return 1
endfunction

// Dòng "+ kỹ năng" (chỉ nhẫn) hiếm: mỗi lần quay chỉ có 15% ra dòng này, còn lại nhẫn không có dòng.
function zzEQ_SkillLineChance takes nothing returns integer
    return 15
endfunction

function zzEQ_PickAffix takes integer vl_slot returns integer
    local integer vl_k=1
    local integer vl_n=0
    local integer vl_r
    loop
        exitwhen vl_k>22
        if zzEQ_AffixOk(vl_slot,vl_k) then
            set vl_n=vl_n+1
        endif
        set vl_k=vl_k+1
    endloop
    if vl_n==0 then
        return 0
    endif
    set vl_r=GetRandomInt(1,vl_n)
    set vl_k=1
    loop
        exitwhen vl_k>22
        if zzEQ_AffixOk(vl_slot,vl_k) then
            set vl_r=vl_r-1
            if vl_r==0 then
                if vl_k==22 and GetRandomInt(1,100)>zzEQ_SkillLineChance() then
                    return 0
                endif
                return vl_k
            endif
        endif
        set vl_k=vl_k+1
    endloop
    return 0
endfunction

// ==========================================
// Hàm: zzEQ_Slot
// Ô KVCT 1..10 của một loại vật phẩm (nón, áo, lưng, tay, giày, vũ khí, liên, nhẫn, bội, hộ phù); 0 nếu không phải trang bị.
// Trang bị cũ của map (không có khóa 91) lấy theo khóa 0.
function zzEQ_Slot takes integer vl_type returns integer
    local integer vl_s=LoadInteger(zzVL_ht,vl_type,91)
    local integer vl_k
    if vl_s>0 then
        return vl_s
    endif
    set vl_k=LoadInteger(zzVL_ht,vl_type,0)/10
    if vl_k==1 or vl_k==2 then
        return vl_k
    elseif vl_k==3 then
        return 6
    elseif vl_k==4 then
        return 5
    elseif vl_k==5 then
        return 3
    elseif vl_k==6 then
        return 4
    elseif vl_k>=7 and vl_k<=10 then
        return vl_k
    endif
    return 0
endfunction

// ==========================================
// Hàm: zzEQ_WeaponType
// Loại vũ khí 0..10 (kiếm, đao, thương, chùy, triền thủ, côn, tụ tiễn, phi đao, trường đao, đại đao, phi tiêu); -1 nếu không phải vũ khí KVCT.
// Vũ khí cũ của map (không có khóa 92) trả -1: không bị hạn chế phái và không dùng làm nguyên liệu mua Tần Lăng.
function zzEQ_WeaponType takes integer vl_type returns integer
    return LoadInteger(zzVL_ht,vl_type,92)-1
endfunction

// Có phải trang bị KVCT mới (ITV / ITS / ITW) không
function zzEQ_IsKv takes integer vl_type returns boolean
    return LoadInteger(zzVL_ht,vl_type,93)>0
endfunction

// Mọi trang bị mặc được: trang bị KVCT và đồ cũ của map (phôi / trang sức, khóa 0 = loại*10 + phẩm >= 10)
function zzEQ_IsGear takes integer vl_type returns boolean
    return LoadInteger(zzVL_ht,vl_type,93)>0 or LoadInteger(zzVL_ht,vl_type,0)>=10
endfunction

// ==========================================
// Hàm: zzEQ_Tier
// Bậc cường hóa 0..10 của vật phẩm đang cầm; vũ khí Tần Lăng luôn là 11.
function zzEQ_Tier takes item vl_it returns integer
    if vl_it==null then
        return 0
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==2 then
        return 11
    endif
    return zzIT_Get(GetHandleId(vl_it),zzIT_BAC())
endfunction

// Hệ số chỉ số (%) theo bậc t: 100 + 30*t (+10 = 400%), Tần Lăng (bậc 11) = 500%. Trùng công thức kvequip_data.pct.
function zzEQ_Pct takes integer vl_t returns integer
    if vl_t>=11 then
        return 500
    endif
    if vl_t<=0 then
        return 100
    endif
    return 100+30*vl_t
endfunction

// Tên loại vũ khí
function zzEQ_WName takes integer vl_w returns string
    if vl_w==0 then
        return "Kiếm"
    elseif vl_w==1 then
        return "Đao"
    elseif vl_w==2 then
        return "Thương"
    elseif vl_w==3 then
        return "Chùy"
    elseif vl_w==4 then
        return "Triền Thủ"
    elseif vl_w==5 then
        return "Côn"
    elseif vl_w==6 then
        return "Tụ Tiễn"
    elseif vl_w==7 then
        return "Phi Đao"
    elseif vl_w==8 then
        return "Trường Đao"
    elseif vl_w==9 then
        return "Đại Đao"
    elseif vl_w==10 then
        return "Phi Tiêu"
    endif
    return "?"
endfunction

// Tên chỉ số theo mã
function zzEQ_StatName takes integer vl_code returns string
    if vl_code==1 then
        return "Hút sinh lực"
    elseif vl_code==2 then
        return "Hút nội lực"
    elseif vl_code==3 then
        return "Bạo kích"
    elseif vl_code==4 then
        return "Tốc đánh"
    elseif vl_code==5 then
        return "Sát thương"
    elseif vl_code==6 then
        return "Giảm sát thương nhận"
    elseif vl_code==7 then
        return "Sinh lực"
    elseif vl_code==8 then
        return "Sức mạnh"
    elseif vl_code==9 then
        return "Thân pháp"
    elseif vl_code==10 then
        return "Nội công"
    elseif vl_code==11 then
        return "Kháng vật lý"
    elseif vl_code==12 then
        return "Kháng độc"
    elseif vl_code==13 then
        return "Kháng thủy"
    elseif vl_code==14 then
        return "Kháng hỏa"
    elseif vl_code==15 then
        return "Kháng lôi"
    elseif vl_code==16 then
        return "Tốc độ xuất chiêu"
    elseif vl_code==17 then
        return "STVL nội công"
    elseif vl_code==18 then
        return "STVL ngoại công"
    elseif vl_code==19 then
        return "Điểm đánh trúng"
    elseif vl_code==20 then
        return "Né tránh"
    elseif vl_code==21 then
        return "Tốc chạy"
    elseif vl_code==23 then
        return "Sát thương gốc"
    elseif vl_code==24 then
        return "Giáp"
    endif
    return ""
endfunction

// "+12% Bạo kích" hoặc "+30 Sinh lực"
function zzEQ_StatFmt takes integer vl_code,integer vl_v returns string
    if (vl_code>=1 and vl_code<=6) or (vl_code>=11 and vl_code<=16) then
        return "+"+I2S(vl_v)+"% "+zzEQ_StatName(vl_code)
    endif
    return "+"+I2S(vl_v)+" "+zzEQ_StatName(vl_code)
endfunction

// Dòng chỉ số của một loại vật phẩm ở hệ số vl_p (%)
function zzEQ_StatText takes integer vl_type,integer vl_p returns string
    local integer vl_n=LoadInteger(zzVL_ht,vl_type,139)
    local integer vl_j=0
    local string vl_s=""
    loop
        exitwhen vl_j>=vl_n
        if vl_j>0 then
            set vl_s=vl_s+", "
        endif
        set vl_s=vl_s+zzEQ_StatFmt(LoadInteger(zzVL_ht,vl_type,140+2*vl_j),LoadInteger(zzVL_ht,vl_type,141+2*vl_j)*vl_p/100)
        set vl_j=vl_j+1
    endloop
    return vl_s
endfunction

// Tiêu đề bậc gắn ở ĐẦU mô tả (bậc 0: không có)
function zzEQ_Header takes integer vl_type,integer vl_t returns string
    if vl_t<=0 then
        return ""
    endif
    if vl_t>=11 then
        return "|cffff8000[Trùng sinh 11 - Vũ khí Tần Lăng]|r Hệ số chỉ số |cffffcc00"+I2S(zzEQ_Pct(vl_t))+"%|r:|n"+zzEQ_StatText(vl_type,zzEQ_Pct(vl_t))+"|n"
    endif
    return "|cff00ffff[Cường hóa +"+I2S(vl_t)+"]|r Hệ số chỉ số |cffffcc00"+I2S(zzEQ_Pct(vl_t))+"%|r:|n"+zzEQ_StatText(vl_type,zzEQ_Pct(vl_t))+"|n"
endfunction

// ==========================================
// Hàm: zzEQ_SetTier
// Đặt bậc cường hóa: đổi icon (BlzSetItemIconPath, icon trùng sinh t của KVCT), tên (tên KVCT của bậc), tiêu đề + chỉ số ở đầu mô tả.
// Chỉ số thật được cộng trong zzEQ_AddStats (nền * zzEQ_Pct(bậc) / 100). Vũ khí Tần Lăng luôn bậc 11; trang bị khác tối đa 10.
// Không làm gì với trang bị cũ của map (không có khóa 93).
function zzEQ_SetTier takes item vl_it,integer vl_t returns nothing
    local integer vl_type
    local integer vl_id
    local integer vl_len
    local string vl_nm
    local string vl_star=""
    local string vl_prev
    local string vl_hd
    local string vl_d
    local integer vl_quality=zzIT_Get(GetHandleId(vl_it),zzIT_PHAM_CHAT())
    local string vl_qualityPrefix=""
    if vl_it==null then
        return
    endif
    set vl_type=GetItemTypeId(vl_it)
    if not zzEQ_IsKv(vl_type) then
        return
    endif
    set vl_id=GetHandleId(vl_it)
    if LoadInteger(zzVL_ht,vl_type,93)==2 then
        set vl_t=11
    elseif vl_t>10 then
        set vl_t=10
    endif
    if vl_t<0 then
        set vl_t=0
    endif
    call zzIT_Set(vl_id,zzIT_BAC(),vl_t)
    call zzIT_Set(vl_id,zzIT_BAC_DA_GAN(),1)
    set vl_nm=LoadStr(zzVL_ht,vl_type,120+vl_t)
    if vl_nm!=null and vl_nm!="" then
        call BlzSetItemIconPath(vl_it,vl_nm)
    endif
    set vl_nm=GetItemName(vl_it)
    set vl_len=StringLength(vl_nm)
    if vl_len>=14 and SubString(vl_nm,vl_len-14,vl_len)==" |cff00ff00*|r" then
        set vl_star=" |cff00ff00*|r"
    endif
    set vl_nm=LoadStr(zzVL_ht,vl_type,100+vl_t)
    if vl_nm!=null and vl_nm!="" then
        if vl_t>0 and vl_t<11 then
            set vl_nm=vl_nm+" +"+I2S(vl_t)
        endif
        if vl_quality==1 then
            set vl_qualityPrefix="|cffffffff[Thường] "
        elseif vl_quality==2 then
            set vl_qualityPrefix="|cff4080ff[Tốt] "
        elseif vl_quality==3 then
            set vl_qualityPrefix="|cffc040ff[Tuyệt] "
        elseif vl_quality>=4 then
            set vl_qualityPrefix="|cffffcc00[Huyền thoại] "
        endif
        call BlzSetItemName(vl_it,vl_qualityPrefix+vl_nm+"|r"+vl_star)
    endif
    // mô tả dựng lại từ dữ liệu: chỉ số đúng bậc, dòng ngẫu nhiên, khảm (gameplay_08_ui.j zzEQ_Describe)
    call zzEQ_Redesc(vl_it)
endfunction

// Gắn tiêu đề / icon bậc lần đầu cho trang bị KVCT chưa qua zzEQ_SetTier (nhặt, mặc)
function zzEQ_Touch takes item vl_it returns nothing
    if vl_it==null then
        return
    endif
    if zzEQ_IsKv(GetItemTypeId(vl_it)) and zzIT_Get(GetHandleId(vl_it),zzIT_BAC_DA_GAN())==0 then
        call zzEQ_SetTier(vl_it,zzEQ_Tier(vl_it))
    endif
endfunction

// ==========================================
// Hàm: zzEQ_CanUse
// Tướng có được mặc món này không: MỌI vũ khí (KVCT và đồ cũ có loại, khóa 92) phải đúng loại của phái (bảng khóa 96 / 400+w của loại tướng). Món khác: được.
function zzEQ_CanUse takes unit vl_hero,item vl_it returns boolean
    local integer vl_type
    local integer vl_wt
    local integer vl_hw
    if vl_it==null then
        return true
    endif
    set vl_type=GetItemTypeId(vl_it)
    set vl_wt=zzEQ_WeaponType(vl_type)
    if vl_wt<0 then
        return true
    endif
    set vl_hw=zzHT_MainWeapon(vl_hero)
    if vl_hw<0 then
        return true
    endif
    return zzHT_CanWear(vl_hero,vl_wt)
endfunction

// Danh sách loại vũ khí phái của tướng dùng được ("Đao, Trường Đao, Đại Đao")
function zzEQ_UseList takes unit vl_hero returns string
    local integer vl_w=0
    local string vl_s=""
    loop
        exitwhen vl_w>10
        if zzHT_CanWear(vl_hero,vl_w) then
            if vl_s!="" then
                set vl_s=vl_s+", "
            endif
            set vl_s=vl_s+zzEQ_WName(vl_w)
        endif
        set vl_w=vl_w+1
    endloop
    return vl_s
endfunction

// Như zzEQ_CanUse nhưng báo cho người chơi (tiếng Việt) khi bị từ chối
function zzEQ_CheckWear takes unit vl_hero,item vl_it returns boolean
    if zzEQ_CanUse(vl_hero,vl_it) then
        return true
    endif
    call zzVL_Msg(GetPlayerId(GetOwningPlayer(vl_hero)),"|cffff4040Không thể mặc:|r phái "+GetUnitName(vl_hero)+" chỉ dùng vũ khí loại |cffffcc00"+zzEQ_UseList(vl_hero)+"|r, "+GetItemName(vl_it)+" là vũ khí loại |cffffcc00"+zzEQ_WName(zzEQ_WeaponType(GetItemTypeId(vl_it)))+"|r.")
    return false
endfunction

// Loại vật phẩm vũ khí khởi đầu đúng loại của phái (ITV0..ITVA); 0 nếu không biết phái
function zzEQ_StartWeapon takes unit vl_hero returns integer
    local integer vl_w=zzHT_MainWeapon(vl_hero)
    if vl_w<0 then
        return 0
    endif
    if vl_w>9 then
        return 'ITVA'
    endif
    return 'ITV0'+vl_w
endfunction

// ==========================================
// Hàm: zzEQ_IsPlus10Weapon
// Vũ khí KVCT (không phải Tần Lăng) đã cường hóa +10: nguyên liệu mua vũ khí Tần Lăng.
function zzEQ_IsPlus10Weapon takes item vl_it returns boolean
    local integer vl_type
    if vl_it==null then
        return false
    endif
    set vl_type=GetItemTypeId(vl_it)
    return LoadInteger(zzVL_ht,vl_type,93)==1 and zzEQ_Slot(vl_type)==6 and zzEQ_Tier(vl_it)>=10
endfunction

// ==========================================
// Hàm: zzEQ_Enhance
// Cường hóa một món trang bị KVCT lên 1 bậc (Huyền tinh). Trả true nếu thành công (người gọi trừ Huyền tinh và gọi zzVL_AffixSum).
function zzEQ_Enhance takes integer vl_pid,item vl_it returns boolean
    local integer vl_t
    if vl_it==null then
        return false
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==2 then
        call zzVL_Msg(vl_pid,"|cffff8000Vũ khí Tần Lăng|r đã ở cực phẩm (trùng sinh 11), không cường hóa thêm được.")
        return false
    endif
    set vl_t=zzEQ_Tier(vl_it)
    if vl_t>=10 then
        call zzVL_Msg(vl_pid,"Món này đã cường hóa tối đa +10.")
        return false
    endif
    call zzEQ_SetTier(vl_it,vl_t+1)
    call zzIT_Set(GetHandleId(vl_it),zzIT_BAO_HIEM(),0)
    // cấp của Ô được nhớ theo người chơi (zzVL_cuong): đồ nhặt mặc vào ô này sẽ nhận đúng cấp / icon, kể cả đồ cũ của map
    if zzEQ_Slot(GetItemTypeId(vl_it))>0 and zzVL_equipItem[vl_pid*10+zzEQ_Slot(GetItemTypeId(vl_it))-1]==vl_it then
        set zzVL_cuong[vl_pid*10+zzEQ_Slot(GetItemTypeId(vl_it))-1]=IMinBJ(10,vl_t+1)
    endif
    if Jx[vl_pid+1]!=null then
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",Jx[vl_pid+1],"origin"))
        call zzVL_Text(Jx[vl_pid+1],"|cffffcc00Cường hóa +"+I2S(vl_t+1)+"|r")
    endif
    call zzVL_Msg(vl_pid,"|cffffcc00Cường hóa|r "+GetItemName(vl_it)+" |cffffcc00+"+I2S(vl_t+1)+"|r")
    return true
endfunction

// Attempt one item enhancement. Points are consumed on success or failure; no downgrade. Pity belongs to this item handle.
function zzEQ_TryEnhance takes integer vl_pid,item vl_it returns boolean
    local integer vl_t
    local integer vl_level
    local integer vl_cost
    local integer vl_pity
    local integer vl_required
    local integer vl_rate
    if vl_it==null or not zzEQ_IsKv(GetItemTypeId(vl_it)) then
        return false
    endif
    set vl_t=zzEQ_Tier(vl_it)
    if vl_t>=10 or LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==2 then
        call zzVL_Msg(vl_pid,"Món này không thể cường hóa thêm.")
        return false
    endif
    set vl_level=vl_t+1
    set vl_cost=zzGL_Cost(vl_level)
    if zzGL_Get(vl_pid)<vl_cost then
        call zzVL_Msg(vl_pid,"Cần "+I2S(vl_cost)+" Huyền Tinh, hiện có "+I2S(zzGL_Get(vl_pid))+".")
        return false
    endif
    call zzGL_Spend(vl_pid,vl_cost)
    set vl_pity=zzIT_Get(GetHandleId(vl_it),zzIT_BAO_HIEM())
    set vl_required=LoadInteger(zzVL_ht,'zzGL',60+vl_level)
    set vl_rate=LoadInteger(zzVL_ht,'zzGL',40+vl_level)
    if vl_pity>=vl_required or GetRandomInt(1,100)<=vl_rate then
        call zzEQ_Enhance(vl_pid,vl_it)
        return true
    endif
    call zzIT_Set(GetHandleId(vl_it),zzIT_BAO_HIEM(),vl_pity+1)
    call zzVL_Msg(vl_pid,"|cffff8040Cường hóa thất bại.|r Trang bị giữ nguyên +"+I2S(vl_t)+"; đã mất "+I2S(vl_cost)+" Huyền Tinh. Bảo hiểm món này: "+I2S(vl_pity+1)+"/"+I2S(vl_required)+" lần.")
    return true
endfunction

// Enhancement for legacy equipment still held in a character slot while the new KVCT shop is being adopted.
// The slot level is stored on the hero, so it survives replacing the item as in the original map system.
function zzEQ_TrySlotEnhance takes integer vl_pid,integer vl_slot,item vl_it returns boolean
    local integer vl_t=zzVL_cuong[vl_pid*10+vl_slot]
    local integer vl_level=vl_t+1
    local integer vl_cost
    local integer vl_pity
    local integer vl_required
    local integer vl_rate
    local integer vl_index=vl_pid*10+vl_slot
    if vl_it==null or vl_slot<0 or vl_slot>9 or zzEQ_IsKv(GetItemTypeId(vl_it)) then
        return false
    endif
    if vl_t>=10 then
        call zzVL_Msg(vl_pid,"Ô trang bị này đã đạt cường hóa +10.")
        return false
    endif
    set vl_cost=zzGL_Cost(vl_level)
    if zzGL_Get(vl_pid)<vl_cost then
        call zzVL_Msg(vl_pid,"Cần "+I2S(vl_cost)+" Huyền Tinh; bạn có "+I2S(zzGL_Get(vl_pid))+" điểm đã quy đổi.")
        return false
    endif
    call zzGL_Spend(vl_pid,vl_cost)
    set vl_pity=zzIT_Get(GetHandleId(vl_it),zzIT_BAO_HIEM())
    set vl_required=LoadInteger(zzVL_ht,'zzGL',60+vl_level)
    set vl_rate=LoadInteger(zzVL_ht,'zzGL',40+vl_level)
    if vl_pity>=vl_required or GetRandomInt(1,100)<=vl_rate then
        set zzVL_cuong[vl_index]=vl_level
        call zzIT_Set(GetHandleId(vl_it),zzIT_BAO_HIEM(),0)
        call zzVL_Msg(vl_pid,"|cffffcc00Cường hóa +"+I2S(vl_level)+" thành công.|r")
    else
        call zzIT_Set(GetHandleId(vl_it),zzIT_BAO_HIEM(),vl_pity+1)
        call zzVL_Msg(vl_pid,"|cffff8040Cường hóa thất bại.|r Không tụt cấp; bảo hiểm "+I2S(vl_pity+1)+"/"+I2S(vl_required)+".")
    endif
    return true
endfunction

// Cường hóa món KVCT đang mặc ở ô vl_slot (0..9) (lệnh GM -cuong). Trả true nếu ô đó đang mặc món KVCT (đã xử lý)
function zzEQ_EnhanceSlot takes integer vl_pid,integer vl_slot returns boolean
    local item vl_it=zzVL_equipItem[vl_pid*10+vl_slot]
    local boolean vl_r=false
    if vl_it!=null and zzEQ_IsKv(GetItemTypeId(vl_it)) then
        call zzEQ_Enhance(vl_pid,vl_it)
        set vl_r=true
    endif
    set vl_it=null
    return vl_r
endfunction

// Lệnh GM -fullcuong: mọi món KVCT đang mặc lên +10 (trừ Tần Lăng)
function zzEQ_GmFull takes integer vl_pid returns nothing
    local integer vl_i=0
    local item vl_it
    loop
        exitwhen vl_i>9
        set vl_it=zzVL_equipItem[vl_pid*10+vl_i]
        if vl_it!=null and LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==1 then
            call zzEQ_SetTier(vl_it,10)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
endfunction

// ==========================================
// Cấp cường hóa hiệu lực của ô vl_slot (0..9): bậc của món KVCT đang mặc ở đó, ngược lại cấp cường hóa theo ô cũ (zzVL_cuong).
function zzEQ_SlotLv takes integer vl_pid,integer vl_slot returns integer
    local item vl_it=zzVL_equipItem[vl_pid*10+vl_slot]
    local integer vl_r=zzVL_cuong[vl_pid*10+vl_slot]
    if vl_it!=null and zzEQ_IsKv(GetItemTypeId(vl_it)) then
        set vl_r=zzEQ_Tier(vl_it)
    endif
    set vl_it=null
    return vl_r
endfunction

// Chuyển cấp đang có của ô sang phôi KVCT mới. Cấp của món KVCT cũ được
// chuyển đi (món cũ về +0) để không nhân đôi cường hóa khi thay trang bị.
function zzEQ_InheritSlot takes integer vl_pid,integer vl_slot,item vl_new,item vl_old returns nothing
    local integer vl_index=vl_pid*10+vl_slot
    local integer vl_level=zzVL_cuong[vl_index]
    local integer vl_oldType=0
    local integer vl_newType=0
    if vl_old!=null then
        set vl_oldType=GetItemTypeId(vl_old)
        if LoadInteger(zzVL_ht,vl_oldType,93)==1 then
            set vl_level=IMaxBJ(vl_level,zzEQ_Tier(vl_old))
        endif
    endif
    if vl_new!=null then
        set vl_newType=GetItemTypeId(vl_new)
        if zzEQ_IsKv(vl_newType) then
            set vl_level=IMaxBJ(vl_level,zzEQ_Tier(vl_new))
            if vl_level>10 then
                set vl_level=10
            endif
            call zzEQ_SetTier(vl_new,vl_level)
            if vl_old!=null and vl_old!=vl_new and LoadInteger(zzVL_ht,vl_oldType,93)==1 then
                call zzEQ_SetTier(vl_old,0)
            endif
            set zzVL_cuong[vl_index]=vl_level
        else
            // đồ cũ của map mặc vào ô: giữ cấp của ô (icon + chỉ số theo cấp ô), món KVCT cũ trả về +0 để không nhân đôi
            set zzVL_cuong[vl_index]=IMinBJ(10,vl_level)
            if vl_old!=null and vl_old!=vl_new and LoadInteger(zzVL_ht,vl_oldType,93)==1 then
                call zzEQ_SetTier(vl_old,0)
            endif
        endif
    endif
endfunction

// Cấp cường hóa là của Ô (zzVL_cuong), không phải của món: món KVCT đang mặc luôn mang đúng cấp của ô, bất kể mặc bằng cách nào
// (bấm trong hành trang, tự mặc, hoán đổi...). Gọi trong zzVL_AffixSum (mỗi giây).
function zzEQ_SyncSlots takes integer vl_pid returns nothing
    local integer vl_i=0
    local item vl_it
    local integer vl_idx
    local integer vl_t
    loop
        exitwhen vl_i>9
        set vl_it=zzVL_equipItem[vl_pid*10+vl_i]
        if vl_it!=null and LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==1 then
            set vl_idx=vl_pid*10+vl_i
            set vl_t=zzEQ_Tier(vl_it)
            if vl_t>zzVL_cuong[vl_idx] then
                set zzVL_cuong[vl_idx]=IMinBJ(10,vl_t)
            elseif vl_t<zzVL_cuong[vl_idx] then
                call zzEQ_SetTier(vl_it,zzVL_cuong[vl_idx])
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
endfunction

// Cộng một chỉ số (mã chỉ số ở đầu file) vào bảng chỉ số của người chơi (zzVL_af, khóa 1000+pid): cùng chỗ với zzVL_AffixSum
function zzEQ_AddOne takes integer vl_pid,integer vl_code,integer vl_v returns nothing
    local integer vl_b=vl_pid*16
    if vl_code>=1 and vl_code<=10 then
        set zzVL_af[vl_b+vl_code]=zzVL_af[vl_b+vl_code]+vl_v
    elseif vl_code==21 then
        set zzVL_af[vl_b+13]=zzVL_af[vl_b+13]+vl_v
    elseif vl_code==23 then
        set zzVL_af[vl_b+12]=zzVL_af[vl_b+12]+vl_v
    elseif vl_code==24 then
        set zzVL_af[vl_b+11]=zzVL_af[vl_b+11]+vl_v
    elseif vl_code>=11 and vl_code<=20 then
        call zzPS_Add(vl_pid,vl_code,vl_v)
    endif
endfunction

// ==========================================
// Giá trị một dòng chỉ số ngẫu nhiên của món sau khi cường hóa:
//  - các dòng thường tăng theo bậc như chỉ số nền (hệ số zzEQ_Pct: +10 là 400%);
//  - dòng "+ kỹ năng" (k22) tăng CỐ ĐỊNH 3/10 cấp mỗi bậc, tối đa +4 cấp ở bậc +10 (1 + bậc*3/10).
function zzEQ_LineValue takes item vl_it,integer vl_k,integer vl_base returns integer
    local integer vl_t=zzEQ_Tier(vl_it)
    if vl_base<=0 then
        return 0
    endif
    if vl_k==22 then
        if vl_t>10 then
            set vl_t=10
        endif
        return vl_base+vl_t*3/10
    endif
    return vl_base*zzEQ_Pct(vl_t)/100
endfunction

// ==========================================
// Hàm: zzEQ_AddStats
// Chỉ số nền của món KVCT đang mặc * hệ số bậc (zzEQ_Pct), cộng vào người chơi vl_pid. Gọi trong zzVL_AffixSum cho mỗi món KVCT đang mặc.
function zzEQ_AddStats takes integer vl_pid,item vl_it returns nothing
    local integer vl_type=GetItemTypeId(vl_it)
    local integer vl_n=LoadInteger(zzVL_ht,vl_type,139)
    local integer vl_p=zzEQ_Pct(zzEQ_Tier(vl_it))
    local integer vl_j=0
    call zzEQ_Touch(vl_it)
    loop
        exitwhen vl_j>=vl_n
        call zzEQ_AddOne(vl_pid,LoadInteger(zzVL_ht,vl_type,140+2*vl_j),LoadInteger(zzVL_ht,vl_type,141+2*vl_j)*vl_p/100)
        set vl_j=vl_j+1
    endloop
endfunction
