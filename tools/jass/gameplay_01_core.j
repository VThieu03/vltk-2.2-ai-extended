// ===== Gameplay 1.31 (added for the 1.31 port, original map by vnakira) =====
// Bo trang bi theo he, cuong hoa +1..+10, ngu hanh cho don danh thuong, cong trang / quan ham,
// phi phong theo quan ham, cao thu xuat hien ngau nhien, nhat dao doat mang.
// Everything lasts one match. Player ids 0..9 (Tong 0-4, Kim 5-9), hero = Jx[pid+1].
// Elements are the author's groups: qx Kim, Qx Moc, tx Tho, sx Thuy, Sx Hoa; e khac e+1 (Hoa khac Kim).
// Every local / parameter starts with vl_: the 1.31 game rejects a local that has the name of a
// global of another type (the map's globals are 1-3 letter names), and then the lobby has no slots.

// ==========================================
// LỚP zzPS: CHỈ SỐ CỘNG THÊM CỦA NGƯỜI CHƠI (trang bị, cường hóa, buff), một "đối tượng" cho mỗi người chơi 0..9.
// Dữ liệu nằm trong hashtable zzVL_ht, khóa cha 1000+pid, khóa con là các "trường" dưới đây.
// Dùng: zzPS_Get(pid, zzPS_STVL_NOI()), call zzPS_Set(pid, trường, giá trị), call zzPS_Add(pid, trường, lượng).
constant function zzPS_KHANG_VL takes nothing returns integer
    return 11 // kháng vật lý %
endfunction
constant function zzPS_KHANG_DOC takes nothing returns integer
    return 12 // kháng độc %
endfunction
constant function zzPS_KHANG_THUY takes nothing returns integer
    return 13 // kháng thủy %
endfunction
constant function zzPS_KHANG_HOA takes nothing returns integer
    return 14 // kháng hỏa %
endfunction
constant function zzPS_KHANG_LOI takes nothing returns integer
    return 15 // kháng lôi % (11..15 = 10 + hệ ngũ hành 1..5)
endfunction
constant function zzPS_TOC_XUAT_CHIEU takes nothing returns integer
    return 16 // tốc xuất chiêu %
endfunction
constant function zzPS_STVL_NOI takes nothing returns integer
    return 17 // sát thương nội công (phẳng)
endfunction
constant function zzPS_STVL_NGOAI takes nothing returns integer
    return 18 // sát thương ngoại công (phẳng)
endfunction
constant function zzPS_DANH_TRUNG takes nothing returns integer
    return 19 // điểm đánh trúng
endfunction
constant function zzPS_NE_TRANH takes nothing returns integer
    return 20 // điểm né tránh (dòng trang bị)
endfunction
constant function zzPS_TOC_CHAY takes nothing returns integer
    return 21 // tốc chạy
endfunction
constant function zzPS_CAP_KY_NANG takes nothing returns integer
    return 22 // cấp kỹ năng cộng thêm
endfunction
constant function zzPS_NE_NGOAI_BUFF takes nothing returns integer
    return 25 // né ngoại công từ buff
endfunction
constant function zzPS_NE_NOI_BUFF takes nothing returns integer
    return 26 // né nội công từ buff
endfunction
function zzPS_Get takes integer vl_pid,integer vl_field returns integer
    return LoadInteger(zzVL_ht,1000+vl_pid,vl_field)
endfunction
function zzPS_Set takes integer vl_pid,integer vl_field,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,1000+vl_pid,vl_field,vl_v)
endfunction
function zzPS_Add takes integer vl_pid,integer vl_field,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,1000+vl_pid,vl_field,LoadInteger(zzVL_ht,1000+vl_pid,vl_field)+vl_v)
endfunction

// ==========================================
// LỚP zzIT: DỮ LIỆU RIÊNG CỦA MỘT VẬT PHẨM (trang bị) trong zzVL_ht, khóa cha = GetHandleId(item).
// Trường: dòng chỉ số k (1..22) ở 30+k; các trường khác dưới đây. Dùng: zzIT_Get(GetHandleId(it), zzIT_BAC()).
constant function zzIT_MOI_ROI takes nothing returns integer
    return 73 // 1 = vừa rơi ra, chưa xét tự mặc
endfunction
constant function zzIT_PHAM_CHAT takes nothing returns integer
    return 76 // 1 thường, 2 tốt, 3 tuyệt, 4 huyền thoại
endfunction
constant function zzIT_TAI_PHU takes nothing returns integer
    return 74 // 1 = đã gắn dòng "Tài phú" vào mô tả
endfunction
constant function zzIT_DO_CO takes nothing returns integer
    return 75 // trang bị cổ (thêm chỉ số bộ), 0 = không
endfunction
constant function zzIT_BAC takes nothing returns integer
    return 90 // bậc cường hóa +0..+10 (11 = Tần Lăng)
endfunction
constant function zzIT_BAC_DA_GAN takes nothing returns integer
    return 97 // 1 = đã gắn tên / icon theo bậc
endfunction
constant function zzIT_BAO_HIEM takes nothing returns integer
    return 98 // số lần cường hóa thất bại liên tiếp (bảo hiểm)
endfunction
constant function zzIT_SO_LO_KHAM takes nothing returns integer
    return 43 // số lỗ đã khảm
endfunction
constant function zzIT_LO_KHAM takes nothing returns integer
    return 57 // 57 + i (i = 0, 1 ...): loại vật phẩm bảo thạch đã khảm vào lỗ i
endfunction
constant function zzIT_LO_KHAM_CHU takes nothing returns integer
    return 67 // 67 + i: đoạn mô tả "[Khảm] ..." đã thêm cho lỗ i (để gỡ khi tách)
endfunction
// Dựng lại mô tả trang bị KVCT (zzEQ_DescribeRun ở gameplay_08_ui.j); gọi được từ mọi module
function zzEQ_Redesc takes item vl_it returns nothing
    if vl_it!=null then
        call SaveItemHandle(zzVL_ht,0,499,vl_it)
        call ExecuteFunc("zzEQ_DescribeRun")
    endif
endfunction
constant function zzIT_DA_MO_TA takes nothing returns integer
    return 58 // 1 = đã dựng mô tả kiểu mới
endfunction
constant function zzIT_MO_TA_GOC takes nothing returns integer
    return 59 // (chuỗi) mô tả gốc của đồ cũ, chụp trước khi dựng lại
endfunction
constant function zzIT_CUONG_O takes nothing returns integer
    return 60 // cấp cường hóa ô của đồ cũ + 1 (0 = chưa gắn)
endfunction
// Món này đang được mặc (nằm ở một ô trang bị) không
function zzVL_IsEquipped takes integer vl_pid,item vl_it returns boolean
    local integer vl_i=0
    if vl_it==null or vl_pid<0 or vl_pid>9 then
        return false
    endif
    loop
        exitwhen vl_i>9
        if zzVL_equipItem[vl_pid*10+vl_i]==vl_it then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction
constant function zzIT_DA_VUT takes nothing returns integer
    return 61 // 1 = người chơi vừa vứt xuống đất (tự nhặt bỏ qua)
endfunction
// Chế độ Vứt của hành trang (khóa cha 7000+pid, trường 1): bật thì bấm món trong hành trang là vứt xuống đất
function zzVL_DropMode takes integer vl_pid returns boolean
    return LoadInteger(zzVL_ht,7000+vl_pid,1)>0
endfunction
function zzVL_SetDropMode takes integer vl_pid,boolean vl_on returns nothing
    if vl_on then
        call SaveInteger(zzVL_ht,7000+vl_pid,1,1)
    else
        call SaveInteger(zzVL_ht,7000+vl_pid,1,0)
    endif
endfunction
// Phi phong (15 bậc) và quan ấn (8 bậc) theo KVCT: dữ liệu ở zzVL_ht khóa cha 0 (tools/kvequip.py, config.py mục 18)
function zzVL_QAMax takes nothing returns integer
    return LoadInteger(zzVL_ht,0,659)
endfunction
function zzVL_QAName takes integer vl_i returns string
    if vl_i<=0 then
        return "Binh Sĩ"
    endif
    return LoadStr(zzVL_ht,0,660+vl_i)
endfunction
function zzVL_QAReq takes integer vl_i returns integer
    return LoadInteger(zzVL_ht,0,680+vl_i)
endfunction
function zzVL_PPMax takes nothing returns integer
    return LoadInteger(zzVL_ht,0,599)
endfunction
function zzVL_PPTitle takes integer vl_i returns string
    return LoadStr(zzVL_ht,0,600+vl_i)
endfunction
function zzVL_PPName takes integer vl_i returns string
    return LoadStr(zzVL_ht,0,620+vl_i)
endfunction
function zzVL_PPReq takes integer vl_i returns integer
    return LoadInteger(zzVL_ht,0,640+vl_i)
endfunction
function zzIT_Get takes integer vl_h,integer vl_field returns integer
    return LoadInteger(zzVL_ht,vl_h,vl_field)
endfunction
function zzIT_Set takes integer vl_h,integer vl_field,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,vl_h,vl_field,vl_v)
endfunction
function zzIT_Line takes integer vl_h,integer vl_k returns integer
    return LoadInteger(zzVL_ht,vl_h,30+vl_k)
endfunction
function zzIT_SetLine takes integer vl_h,integer vl_k,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,vl_h,30+vl_k,vl_v)
endfunction
function zzIT_AddLine takes integer vl_h,integer vl_k,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,vl_h,30+vl_k,LoadInteger(zzVL_ht,vl_h,30+vl_k)+vl_v)
endfunction
function zzIT_ClearLine takes integer vl_h,integer vl_k returns nothing
    call RemoveSavedInteger(zzVL_ht,vl_h,30+vl_k)
endfunction

// Khóa một nhịp đánh để auto skill không chèn chiêu tấn công vào hoạt ảnh autocast Q/W/E.
function zzVL_ActionBusy takes integer vl_p returns boolean
    return vl_p>=0 and vl_p<10 and LoadReal(zzVL_ht,7400+vl_p,0)>TimerGetElapsed(zzVL_clock)
endfunction

// Các loại nội tại, buff và toggle không bị khóa bởi bộ ưu tiên đòn đánh.
function zzVL_ActionUtility takes integer vl_ab returns boolean
    local integer vl_k=LoadInteger(zzVL_ht,vl_ab,240)
    return vl_k==0 or vl_k==6 or vl_k==7 or vl_k==8 or vl_k==9 or vl_k==14 or vl_k==19 or vl_k==20 or vl_k==21
endfunction

// ==========================================
// LỚP zzHT: DỮ LIỆU THEO LOẠI TƯỚNG (môn phái), khóa cha = mã loại tướng; ghi bởi tools/kvequip.py từ lớp Python Phai.
function zzHT_He takes unit vl_u returns integer
    return LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),99) // 1 ngoại công, 2 nội công, 0 chưa có (không phải tướng phái)
endfunction
function zzHT_MainWeapon takes unit vl_u returns integer
    return LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),96)-1 // loại vũ khí chính 0..10, -1 nếu không có
endfunction
function zzHT_CanWear takes unit vl_u,integer vl_w returns boolean
    return LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),400+vl_w)>0 // phái mặc được loại vũ khí vl_w
endfunction

// ==========================================
// LỚP zzSK: DỮ LIỆU MỘT KỸ NĂNG KVCT (khóa cha = mã ability X000.., ghi bởi tools/kskill.py vào build/kskill_table.j).
// Mọi trường đều có tên dưới đây (giải thích thêm ở đầu tools/kskill.j; bảng tra docs/JASS_KHOA.md).
// Dùng: zzSK_Int(vl_ab, zzSK_KIND()), zzSK_Str(vl_ab, zzSK_MODEL()), zzSK_Has(vl_ab, zzSK_STAT1_BASE()).
constant function zzSK_KIND takes nothing returns integer
    return 240 // loại chiêu (bảng Kinds ở đầu kskill.j)
endfunction
constant function zzSK_HITS takes nothing returns integer
    return 241 // số đòn / đợt / nhịp
endfunction
constant function zzSK_STATUS takes nothing returns integer
    return 242 // trạng thái gây ra (1 thọ thương 2 định thân 3 choáng 4 chậm 5 bỏng)
endfunction
constant function zzSK_CHANCE takes nothing returns integer
    return 243 // tỉ lệ % gây trạng thái
endfunction
constant function zzSK_STATUS_TIME takes nothing returns integer
    return 244 // thời gian trạng thái (1/10 giây)
endfunction
constant function zzSK_PASSIVE_FX takes nothing returns integer
    return 245 // bit hiệu ứng bị động thêm vào đòn Q W E
endfunction
constant function zzSK_BUFF_TIME takes nothing returns integer
    return 246 // thời gian buff (giây)
endfunction
constant function zzSK_STAT1 takes nothing returns integer
    return 247 // chỉ số buff thứ nhất
endfunction
constant function zzSK_STAT2 takes nothing returns integer
    return 248 // chỉ số buff thứ hai
endfunction
constant function zzSK_PROC takes nothing returns integer
    return 249 // 1 = tự phát khi đánh thường
endfunction
constant function zzSK_MODEL takes nothing returns integer
    return 250 // model hiệu ứng chính
endfunction
constant function zzSK_ORDER_ON takes nothing returns integer
    return 251 // lệnh bật autocast
endfunction
constant function zzSK_FX takes nothing returns integer
    return 252 // bit hiệu ứng đòn (kéo, đẩy, hút máu...)
endfunction
constant function zzSK_STAT1_BASE takes nothing returns integer
    return 253 // chỉ số 1: giá trị gốc
endfunction
constant function zzSK_STAT1_PER takes nothing returns integer
    return 254 // chỉ số 1: thêm mỗi bậc
endfunction
constant function zzSK_STAT2_BASE takes nothing returns integer
    return 255 // chỉ số 2: giá trị gốc
endfunction
constant function zzSK_STAT2_PER takes nothing returns integer
    return 256 // chỉ số 2: thêm mỗi bậc
endfunction
constant function zzSK_RADIUS takes nothing returns integer
    return 257 // bán kính / tầm
endfunction
constant function zzSK_GAP takes nothing returns integer
    return 258 // giãn cách giữa các đòn (1/100 giây)
endfunction
constant function zzSK_MAX_TARGETS takes nothing returns integer
    return 259 // số địch tối đa mỗi đòn
endfunction
constant function zzSK_CAST_MODEL takes nothing returns integer
    return 280 // model trên tướng lúc tung
endfunction
constant function zzSK_TARGET_MODEL takes nothing returns integer
    return 281 // model trên địch trúng
endfunction
constant function zzSK_CAST_MODEL2 takes nothing returns integer
    return 282 // model cast thứ hai
endfunction
constant function zzSK_TARGET_MODEL2 takes nothing returns integer
    return 283 // model target thứ hai
endfunction
constant function zzSK_BUFF_MODEL takes nothing returns integer
    return 284 // model buff
endfunction
constant function zzSK_AREA_MODEL takes nothing returns integer
    return 285 // model vùng
endfunction
constant function zzSK_AREA_MODEL2 takes nothing returns integer
    return 286 // model vùng thứ hai
endfunction
constant function zzSK_AURA_MODEL takes nothing returns integer
    return 287 // model aura của bị động
endfunction
constant function zzSK_TARGET_GROUND takes nothing returns integer
    return 288 // 1 = lớp target đặt trên đất
endfunction
constant function zzSK_CAST_GROUND takes nothing returns integer
    return 289 // 1 = lớp cast đặt trên đất
endfunction
constant function zzSK_SCALE takes nothing returns integer
    return 290 // cỡ hiệu ứng % (bảng hand "scale")
endfunction
constant function zzSK_MODEL_LOOP takes nothing returns integer
    return 294 // 1 = model tự lặp
endfunction
constant function zzSK_AI_ORDER takes nothing returns integer
    return 2 // lệnh (OrderId) để AI / autocast tung chiêu
endfunction
constant function zzSK_AI_TARGET takes nothing returns integer
    return 3 // kiểu mục tiêu khi AI tung
endfunction
constant function zzSK_WEAK_RADIUS takes nothing returns integer
    return 160 // suy yếu: bán kính vùng
endfunction
constant function zzSK_WEAK_TIME takes nothing returns integer
    return 161 // suy yếu: thời gian
endfunction
constant function zzSK_WEAK_PCT takes nothing returns integer
    return 162 // suy yếu: % giảm sát thương
endfunction
constant function zzSK_WAVE_TIME takes nothing returns integer
    return 164 // thời gian một đợt (wdur)
endfunction
constant function zzSK_ONHURT takes nothing returns integer
    return 165 // bị động khi bị đánh: 1 hồi máu thấp, 2 cộng tầng, 3 suy yếu quanh thân
endfunction
constant function zzSK_PULSE_SEC takes nothing returns integer
    return 166 // giây mỗi nhịp (psec)
endfunction
constant function zzSK_WIDTH takes nothing returns integer
    return 167 // độ rộng đạn / vùng quét
endfunction
constant function zzSK_LOW_CD_PER takes nothing returns integer
    return 168 // máu thấp: giãn cách thêm mỗi bậc
endfunction
constant function zzSK_LOW_PCT_PER takes nothing returns integer
    return 169 // máu thấp: tỉ lệ thêm mỗi bậc
endfunction
constant function zzSK_STACK_PCT takes nothing returns integer
    return 170 // cộng tầng: % mỗi tầng
endfunction
constant function zzSK_STACK_TIME takes nothing returns integer
    return 171 // cộng tầng: thời gian (giây)
endfunction
constant function zzSK_STACK_MAX_PER takes nothing returns integer
    return 172 // cộng tầng: tầng tối đa thêm mỗi bậc
endfunction
constant function zzSK_STACK_MAX takes nothing returns integer
    return 173 // cộng tầng: tầng tối đa gốc
endfunction
constant function zzSK_HIDE_BUFF_PER takes nothing returns integer
    return 174 // buff sau ẩn thân: thêm mỗi bậc (1/10 giây)
endfunction
constant function zzSK_PROC_CHANCE_PER takes nothing returns integer
    return 177 // đòn đặc biệt: tỉ lệ thêm mỗi bậc
endfunction
constant function zzSK_PROC_MUL_PER takes nothing returns integer
    return 178 // đòn đặc biệt: % sát thương thêm mỗi bậc
endfunction
constant function zzSK_PROC_MUL takes nothing returns integer
    return 179 // đòn đặc biệt: % sát thương gốc
endfunction
constant function zzSK_PROC_CHANCE takes nothing returns integer
    return 180 // đòn đặc biệt: tỉ lệ gốc
endfunction
constant function zzSK_SUCK takes nothing returns integer
    return 181 // hút địch vào tâm
endfunction
constant function zzSK_BUFF_HITS takes nothing returns integer
    return 182 // buff hết sau số đòn này
endfunction
constant function zzSK_ALSO_QWE takes nothing returns integer
    return 183 // chiêu cũng tung Q (1) W (2) E (3) của tướng
endfunction
constant function zzSK_DIMM_HITS takes nothing returns integer
    return 184 // miễn sát thương: số đòn
endfunction
constant function zzSK_DIMM_TIME takes nothing returns integer
    return 185 // miễn sát thương: thời gian
endfunction
constant function zzSK_FAN_RANK takes nothing returns integer
    return 186 // quạt đạn: bậc bắt đầu thêm đạn
endfunction
constant function zzSK_STEAL_PCT takes nothing returns integer
    return 187 // hút máu % sát thương
endfunction
constant function zzSK_LOW_AT takes nothing returns integer
    return 189 // ngưỡng máu thấp %
endfunction
constant function zzSK_FAR takes nothing returns integer
    return 194 // điểm xa nhất của vùng
endfunction
constant function zzSK_SELF_BUFF takes nothing returns integer
    return 195 // buff bản thân sau khi tung
endfunction
constant function zzSK_RANGE_PER takes nothing returns integer
    return 196 // tầm lướt thêm mỗi bậc
endfunction
constant function zzSK_CHARGE_PCT_PER takes nothing returns integer
    return 197 // tích tầng: % mỗi tầng theo bậc
endfunction
constant function zzSK_CHARGE_PCT takes nothing returns integer
    return 198 // tích tầng: % mỗi tầng
endfunction
constant function zzSK_HIDE_BUFF takes nothing returns integer
    return 199 // buff sau ẩn thân (1/10 giây)
endfunction
constant function zzSK_STATUS_TIME_PER takes nothing returns integer
    return 200 // thời gian trạng thái thêm mỗi bậc (1/10 giây)
endfunction
constant function zzSK_NO_STUN_CAP takes nothing returns integer
    return 201 // 1 = không giới hạn choáng 2 giây
endfunction
constant function zzSK_PIMM_CHANCE takes nothing returns integer
    return 202 // miễn khống chế: tỉ lệ mỗi bậc
endfunction
constant function zzSK_PIMM_TIME takes nothing returns integer
    return 203 // miễn khống chế: thời gian (1/10 giây)
endfunction
constant function zzSK_FREEZE takes nothing returns integer
    return 204 // máu thấp: đóng băng (1/10 giây)
endfunction
constant function zzSK_FAN_GROW takes nothing returns integer
    return 205 // quạt đạn: thêm đạn theo bậc
endfunction
constant function zzSK_FAN_SPREAD takes nothing returns integer
    return 206 // quạt đạn: góc tỏa
endfunction
constant function zzSK_FAN takes nothing returns integer
    return 207 // quạt đạn: số đạn
endfunction
constant function zzSK_EXTRA_WAVE_CHANCE takes nothing returns integer
    return 208 // bị động: tỉ lệ thêm đợt cho Q W E
endfunction
constant function zzSK_EXTRA_WAVES takes nothing returns integer
    return 209 // bị động: số đợt thêm cho Q W E
endfunction
constant function zzSK_PERIOD_IMM takes nothing returns integer
    return 211 // miễn định kỳ: thời gian
endfunction
constant function zzSK_PERIOD takes nothing returns integer
    return 212 // miễn định kỳ: chu kỳ
endfunction
constant function zzSK_DASH_QWE takes nothing returns integer
    return 214 // lướt xong tung Q W E
endfunction
constant function zzSK_FROM_TARGET takes nothing returns integer
    return 215 // đạn bay từ điểm mục tiêu
endfunction
constant function zzSK_PROC_ON_ATTACK takes nothing returns integer
    return 216 // tỉ lệ bị động tạo buff khi đánh
endfunction
constant function zzSK_LOW_5 takes nothing returns integer
    return 217 // máu thấp: tham số 5
endfunction
constant function zzSK_LOW_FREE takes nothing returns integer
    return 218 // máu thấp: giây miễn khống chế
endfunction
constant function zzSK_LOW_3 takes nothing returns integer
    return 219 // máu thấp: tham số 3
endfunction
constant function zzSK_LOW_CD takes nothing returns integer
    return 220 // máu thấp / bị động: thời gian hồi
endfunction
constant function zzSK_LOW_1 takes nothing returns integer
    return 221 // máu thấp: tham số 1
endfunction
constant function zzSK_BUFF_TIME_PER takes nothing returns integer
    return 222 // thời gian buff thêm mỗi bậc
endfunction
constant function zzSK_SELF_IMM takes nothing returns integer
    return 223 // giây miễn khống chế sau khi tung
endfunction
constant function zzSK_CHANCE2_PER takes nothing returns integer
    return 224 // tỉ lệ trạng thái 2 thêm mỗi bậc
endfunction
constant function zzSK_CHANCE_PER takes nothing returns integer
    return 225 // tỉ lệ trạng thái thêm mỗi bậc
endfunction
constant function zzSK_NO_DAMAGE takes nothing returns integer
    return 228 // 1 = không gây sát thương (lướt)
endfunction
constant function zzSK_LINK_STEAL takes nothing returns integer
    return 231 // bị động: hút máu % mỗi bậc cho đòn liên kết
endfunction
constant function zzSK_MANA_PER_SEC takes nothing returns integer
    return 232 // bật/tắt: nội lực mỗi giây mỗi bậc
endfunction
constant function zzSK_STATUS2 takes nothing returns integer
    return 234 // trạng thái thứ hai (các đợt sau)
endfunction
constant function zzSK_CHANCE2 takes nothing returns integer
    return 235 // tỉ lệ trạng thái thứ hai
endfunction
constant function zzSK_STATUS2_TIME takes nothing returns integer
    return 236 // thời gian trạng thái thứ hai (1/10 giây)
endfunction
constant function zzSK_LINK takes nothing returns integer
    return 239 // bị động áp vào Q (0) W (1) E (2) hay cả ba (3)
endfunction
function zzSK_Int takes integer vl_ab,integer vl_field returns integer
    return LoadInteger(zzVL_ht,vl_ab,vl_field)
endfunction
function zzSK_Str takes integer vl_ab,integer vl_field returns string
    return LoadStr(zzVL_ht,vl_ab,vl_field)
endfunction
function zzSK_Has takes integer vl_ab,integer vl_field returns boolean
    return HaveSavedInteger(zzVL_ht,vl_ab,vl_field)
endfunction

// ==========================================
// LỚP zzUS: TRẠNG THÁI TẠM CỦA MỘT UNIT (khóa cha = GetHandleId(unit)); các mốc thời gian so với TimerGetElapsed(zzVL_clock).
// Trường số thực (zzUS_Real / zzUS_SetReal) và số nguyên (zzUS_Int / zzUS_SetInt) nằm ở hai kho riêng của hashtable.
constant function zzUS_SLOWED takes nothing returns integer
    return 68 // 1 = đang bị làm chậm
endfunction
constant function zzUS_SLOW_SPEED takes nothing returns integer
    return 69 // tốc chạy gốc lưu lại khi bị làm chậm
endfunction
constant function zzUS_VULN_END takes nothing returns integer
    return 74 // hết bị thương: nhận thêm 15% sát thương (fx 512)
endfunction
constant function zzUS_POISON_CD takes nothing returns integer
    return 75 // hết hồi độc sát KVCT (fx 8)
endfunction
constant function zzUS_HIT_COUNT takes nothing returns integer
    return 76 // số đòn trúng liên tiếp (3 đòn nổ, fx 16384)
endfunction
constant function zzUS_KIM_STUN_CD takes nothing returns integer
    return 76 // hết hồi choáng của hệ Kim
endfunction
constant function zzUS_SILENCE_END takes nothing returns integer
    return 77 // hết thọ thương (khóa kỹ năng KVCT)
endfunction
constant function zzUS_BURN_END takes nothing returns integer
    return 79 // hết thiêu đốt (hồi máu 50%)
endfunction
constant function zzUS_BONG_END takes nothing returns integer
    return 81 // hết bỏng (nhận x1.5 sát thương)
endfunction
constant function zzUS_WEAK_END takes nothing returns integer
    return 83 // hết suy yếu
endfunction
constant function zzUS_WEAK_PCT takes nothing returns integer
    return 84 // % giảm sát thương khi suy yếu
endfunction
constant function zzUS_WEAK_SAVED_CD takes nothing returns integer
    return 85 // tốc đánh gốc lưu lại khi suy yếu
endfunction
constant function zzUS_HIT_FX_CD takes nothing returns integer
    return 86 // hết hồi model trúng đòn (0.4 giây)
endfunction
constant function zzUS_MOC_POISON_CD takes nothing returns integer
    return 87 // hết hồi độc của hệ Mộc (tách khỏi 77)
endfunction
constant function zzUS_WEAPON_POISON_END takes nothing returns integer
    return 88 // hết độc / thiêu của vũ khí ngũ hành (1 timer mỗi mục tiêu)
endfunction
constant function zzUS_DASH_IMMUNE_END takes nothing returns integer
    return 90 // hết miễn sát thương khinh công
endfunction
constant function zzUS_DASH_COOLDOWN_END takes nothing returns integer
    return 91 // hết hồi chiêu khinh công
endfunction
constant function zzUS_TP_REFLECT_LAST takes nothing returns integer
    return 70 // lần cuối phản đòn của trấn phái (giãn 0.3 giây)
endfunction
constant function zzUS_THO_REFLECT_LAST takes nothing returns integer
    return 78 // lần cuối phản chấn của bộ Thổ (giãn 0.3 giây)
endfunction
function zzUS_Real takes integer vl_h,integer vl_field returns real
    return LoadReal(zzVL_ht,vl_h,vl_field)
endfunction
function zzUS_SetReal takes integer vl_h,integer vl_field,real vl_v returns nothing
    call SaveReal(zzVL_ht,vl_h,vl_field,vl_v)
endfunction
function zzUS_Int takes integer vl_h,integer vl_field returns integer
    return LoadInteger(zzVL_ht,vl_h,vl_field)
endfunction
function zzUS_SetInt takes integer vl_h,integer vl_field,integer vl_v returns nothing
    call SaveInteger(zzVL_ht,vl_h,vl_field,vl_v)
endfunction

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
// Chỉ ghi vào mảng; file được ghi trong zzVL_LogFlush (2 giây/lần, chỉ khi có dòng mới),
// vì mỗi lần ghi file là một lần đứng hình.
// ==========================================
// Hàm: zzVL_Log
// Chức năng dự kiến: Hiển thị thông báo hoặc ghi nhật ký.
// Tham số:
//   - vl_string (string)
// Không trả về giá trị (thực thi hành động).
function zzVL_Log takes string vl_string returns nothing
    set zzVL_logS[ModuloInteger(zzVL_logN,80)]=zzVL_Clock()+" "+vl_string
    set zzVL_logN=zzVL_logN+1
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
    if zzVL_logW!=zzVL_logN and not zzVL_logBusy then
        set zzVL_logW=zzVL_logN
        set zzVL_logBusy=true
        call zzVL_LogFile()
        set zzVL_logBusy=false
    endif
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
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_u),zzUS_BURN_END()) then
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
