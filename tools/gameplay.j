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
// ---- Huyền Tinh dạng điểm. Không tạo item thường trên terrain; số dư theo player, pity theo từng item handle.
// Config/runtime values are written by kvequip.py under parent 'zzGL'. Player values use parent 6200+pid:
// child 1 = lifetime points earned by the scheduled drop, 2 = spendable GlassPoint, 3 = last notice time.

function zzGL_Get takes integer vl_pid returns integer
    return LoadInteger(zzVL_ht,6200+vl_pid,2)
endfunction

function zzGL_Give takes integer vl_pid,integer vl_points returns nothing
    if vl_pid<0 or vl_pid>9 or vl_points<=0 then
        return
    endif
    call SaveInteger(zzVL_ht,6200+vl_pid,2,zzGL_Get(vl_pid)+vl_points)
endfunction

function zzGL_Spend takes integer vl_pid,integer vl_points returns boolean
    local integer vl_have=zzGL_Get(vl_pid)
    if vl_points<0 or vl_have<vl_points then
        return false
    endif
    call SaveInteger(zzVL_ht,6200+vl_pid,2,vl_have-vl_points)
    return true
endfunction

function zzGL_Cost takes integer vl_level returns integer
    return LoadInteger(zzVL_ht,'zzGL',20+vl_level)
endfunction

function zzGL_HasItemInBag takes integer vl_pid,item vl_find returns boolean
    local integer vl_i=0
    loop
        exitwhen vl_i>=30
        if zzVL_bag[vl_pid*30+vl_i]==vl_find then
            return true
        endif
        set vl_i=vl_i+1
    endloop
    return false
endfunction

// Total visible currency: legacy crystals carried in the custom bag / hero / stash plus quest points.
function zzGL_Count takes integer vl_pid returns integer
    local integer vl_i=0
    local integer vl_n=zzGL_Get(vl_pid)
    local item vl_it
    local unit vl_h=Jx[vl_pid+1]
    local unit vl_tk=Er[vl_pid+1]
    loop
        exitwhen vl_i>=30
        set vl_it=zzVL_bag[vl_pid*30+vl_i]
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=6
        set vl_it=UnitItemInSlot(vl_h,vl_i)
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' and not zzGL_HasItemInBag(vl_pid,vl_it) then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_it=UnitItemInSlot(vl_tk,vl_i)
        if vl_it!=null and GetItemTypeId(vl_it)=='I00W' and not zzGL_HasItemInBag(vl_pid,vl_it) then
            set vl_n=vl_n+IMaxBJ(1,GetItemCharges(vl_it))
        endif
        set vl_i=vl_i+1
    endloop
    set vl_it=null
    set vl_h=null
    set vl_tk=null
    return vl_n
endfunction

function zzGL_Target takes real vl_min returns real
    local real vl20=LoadInteger(zzVL_ht,'zzGL',1)
    local real vl30=LoadInteger(zzVL_ht,'zzGL',2)
    local real vl40=LoadInteger(zzVL_ht,'zzGL',3)
    if vl_min<=20. then
        return vl20*vl_min/20.
    elseif vl_min<=30. then
        return vl20+(vl30-vl20)*(vl_min-20.)/10.
    elseif vl_min<=40. then
        return vl30+(vl40-vl30)*(vl_min-30.)/10.
    endif
    return vl40+(vl40-vl30)*(vl_min-40.)/10.
endfunction

function zzGL_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_pid
    local integer vl_minValue
    local integer vl_n
    local integer vl_cap=LoadInteger(zzVL_ht,'zzGL',5)
    local real vl_min
    local real vl_deficit
    local real vl_want
    local real vl_frac
    local real vl_stamp
    local item vl_crystal
    if vl_hero==null or LoadInteger(zzVL_ht,'zzGL',6)<=0 or LoadInteger(zzVL_ht,'zzGL',4)<=0 then
        return
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_pid<0 or vl_pid>9 then
        return
    endif
    set vl_min=TimerGetElapsed(zzVL_clock)/60.
    set vl_deficit=zzGL_Target(vl_min)-LoadInteger(zzVL_ht,6200+vl_pid,1)
    if vl_deficit<=0. then
        return
    endif
    if vl_kind<=0 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',7)
    elseif vl_kind==1 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',8)
    elseif vl_kind==2 then
        set vl_minValue=LoadInteger(zzVL_ht,'zzGL',9)
    elseif vl_kind>=4 then
        set vl_minValue=GetRandomInt(LoadInteger(zzVL_ht,'zzGL',12),LoadInteger(zzVL_ht,'zzGL',13))
    else
        set vl_minValue=GetRandomInt(LoadInteger(zzVL_ht,'zzGL',10),LoadInteger(zzVL_ht,'zzGL',11))
    endif
    set vl_want=vl_deficit/LoadInteger(zzVL_ht,'zzGL',4)
    if vl_want<I2R(vl_minValue) then
        if GetRandomReal(0.,1.)>=vl_want/I2R(vl_minValue) then
            return
        endif
        set vl_n=vl_minValue
    else
        set vl_n=R2I(vl_want)
        set vl_frac=vl_want-I2R(vl_n)
        if GetRandomReal(0.,1.)<vl_frac then
            set vl_n=vl_n+1
        endif
        if vl_n<vl_minValue then
            set vl_n=vl_minValue
        endif
    endif
    if vl_n>vl_cap then
        set vl_n=vl_cap
    endif
    if vl_n<=0 then
        return
    endif
    // Physical KVCT Huyền Tinh (I00W), stacked into one pickup to avoid item piles.
    set vl_crystal=CreateItem('I00W',vl_x+GetRandomReal(-32.,32.),vl_y+GetRandomReal(-32.,32.))
    if vl_crystal==null then
        return
    endif
    call SetItemCharges(vl_crystal,vl_n)
    call SaveInteger(zzVL_ht,6200+vl_pid,1,LoadInteger(zzVL_ht,6200+vl_pid,1)+vl_n)
    // Rate-limit text feedback to one notice every 2 seconds per player.
    set vl_stamp=TimerGetElapsed(zzVL_clock)
    if vl_stamp-LoadReal(zzVL_ht,6200+vl_pid,3)>=2. then
        call DisplayTimedTextToPlayer(Player(vl_pid),0.,0.,2.,"|cffffcc00Huyền Tinh x"+I2S(vl_n)+" rơi gần quái.|r")
        call SaveReal(zzVL_ht,6200+vl_pid,3,vl_stamp)
    endif
    set vl_crystal=null
endfunction
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
        call BlzSetItemName(vl_it,vl_nm+"|r"+vl_star)
    endif
    set vl_prev=LoadStr(zzVL_ht,vl_id,94)
    set vl_hd=zzEQ_Header(vl_type,vl_t)
    set vl_d=BlzGetItemDescription(vl_it)
    if vl_prev!=null and vl_prev!="" and SubString(vl_d,0,StringLength(vl_prev))==vl_prev then
        set vl_d=SubString(vl_d,StringLength(vl_prev),StringLength(vl_d))
    endif
    call BlzSetItemDescription(vl_it,vl_hd+vl_d)
    set vl_d=BlzGetItemExtendedTooltip(vl_it)
    if vl_prev!=null and vl_prev!="" and SubString(vl_d,0,StringLength(vl_prev))==vl_prev then
        set vl_d=SubString(vl_d,StringLength(vl_prev),StringLength(vl_d))
    endif
    call BlzSetItemExtendedTooltip(vl_it,vl_hd+vl_d)
    call SaveStr(zzVL_ht,vl_id,94,vl_hd)
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
// Tướng có được mặc món này không: vũ khí KVCT phải đúng loại của phái (bảng khóa 96 của loại tướng). Mọi món khác: được.
function zzEQ_CanUse takes unit vl_hero,item vl_it returns boolean
    local integer vl_type
    local integer vl_wt
    local integer vl_hw
    if vl_it==null then
        return true
    endif
    set vl_type=GetItemTypeId(vl_it)
    set vl_wt=zzEQ_WeaponType(vl_type)
    if vl_wt<0 or not zzEQ_IsKv(vl_type) then
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
    if Jx[vl_pid+1]!=null then
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",Jx[vl_pid+1],"origin"))
        call zzVL_Text(Jx[vl_pid+1],"|cffffcc00Cường hóa +"+I2S(vl_t+1)+"|r")
    endif
    call zzVL_Msg(vl_pid,"|cffffcc00Cường hóa|r "+GetItemName(vl_it)+": |cffffcc00+"+I2S(vl_t+1)+"|r (icon và chỉ số theo trùng sinh "+I2S(vl_t+1)+" của Kiếm Vũ Chí Tôn).")
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
        endif
    endif
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
// ---- Gem data API. Item metadata is populated by tools/kvgem.py (keys 110..114).
function zzGM_Type takes integer vl_itemType returns integer
    return LoadInteger(zzVL_ht,vl_itemType,110)
endfunction

function zzGM_Tier takes integer vl_itemType returns integer
    return LoadInteger(zzVL_ht,vl_itemType,111)
endfunction

function zzGM_Code takes integer vl_type,integer vl_tier returns integer
    if vl_type<1 or vl_type>6 or vl_tier<1 or vl_tier>9 then
        return 0
    endif
    return 73*16777216+71*65536+(48+vl_type)*256+48+vl_tier
endfunction

function zzGM_Stat takes integer vl_type,integer vl_tier returns integer
    return LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),113)
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
// Hàm: zzVL_Phe
// Hệ của tướng (config.py mục 15, khóa 99 trên loại tướng): 1 ngoại công, 2 nội công; 1 nếu không phải tướng có phái (quái tính là ngoại).
function zzVL_Phe takes unit vl_u returns integer
    if zzHT_He(vl_u)==2 then
        return 2
    endif
    return 1
endfunction

// ==========================================
// Hàm: zzVL_PheAtk
// Sức mạnh đòn kỹ năng theo hệ: % sát thương vũ khí + hệ số × Sức mạnh / Thân pháp / Nội công (khóa 0/450..457, ×100).
// Trả về -1 nếu tướng chưa có hệ (khi đó dùng cách cũ: vũ khí + chỉ số chính).
function zzVL_PheAtk takes unit vl_h,real vl_weapon returns real
    local integer vl_k
    if zzHT_He(vl_h)==0 or not IsUnitType(vl_h,UNIT_TYPE_HERO) then
        return -1.
    endif
    set vl_k=450+4*(zzVL_Phe(vl_h)-1)
    return vl_weapon*LoadInteger(zzVL_ht,0,vl_k)/100.+(GetHeroStr(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+1)+GetHeroAgi(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+2)+GetHeroInt(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+3))/100.
endfunction

// ==========================================
// Hàm: zzVL_PheDodge
// Né tránh (phần nghìn trước khi trừ đánh trúng) của tướng vl_t trước đòn hệ vl_phe:
// ngoại = Thân pháp/2 + dòng né tránh + khóa 25 (buff né ngoại); nội = Nội công × khóa 0/458 /100 + dòng né tránh + khóa 26 (buff né nội).
function zzVL_PheDodge takes unit vl_t,integer vl_pt,integer vl_phe returns integer
    if vl_phe==2 then
        return R2I(GetHeroInt(vl_t,true)*LoadInteger(zzVL_ht,0,458)/100.)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NOI_BUFF())
    endif
    return R2I(GetHeroAgi(vl_t,true)/2.0)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NGOAI_BUFF())
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
    if not zzVL_gotStart[vl_playerId] then
        set zzVL_gotStart[vl_playerId]=true
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
        if not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=null and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and vl_now-zzUS_Real(GetHandleId(vl_tgt),zzUS_TP_REFLECT_LAST())>=.3 then
            call zzUS_SetReal(GetHandleId(vl_tgt),zzUS_TP_REFLECT_LAST(),vl_now)
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
    // slot 5: number of ticks (KVCT doc sat N lan, kskill.j key 166); 5 when not given
    if (vl_n>=5 and LoadInteger(zzVL_ht,vl_id,5)==0) or (LoadInteger(zzVL_ht,vl_id,5)>0 and vl_n>=LoadInteger(zzVL_ht,vl_id,5)) or vl_unit==null or GetWidgetLife(vl_unit)<.405 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_hero=null
    set vl_unit=null
endfunction

// ==========================================
// Hàm: zzVL_CuongSlot
// Cường hóa trực tiếp theo ô trang bị (0..9)
function zzVL_CuongSlot takes unit vl_hero,integer vl_slot returns boolean
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))
    local string array vl_n
    if vl_playerId>9 or vl_hero!=Jx[vl_playerId+1] or vl_slot<0 or vl_slot>9 then
        return false
    endif
    if zzVL_cuong[vl_playerId*10+vl_slot]>=10 then
        call zzVL_Msg(vl_playerId,"Ô này đã cường hóa tối đa +10.")
        return false
    endif
    set zzVL_cuong[vl_playerId*10+vl_slot]=zzVL_cuong[vl_playerId*10+vl_slot]+1
    set vl_n[0]="Nón (+mọi chỉ số, sinh lực)"
    set vl_n[1]="Áo (giảm sát thương, kháng vật lý)"
    set vl_n[2]="Yêu Đái (sinh lực, kháng độc/thủy)"
    set vl_n[3]="Hộ Uyển (tốc đánh, kháng hỏa/lôi)"
    set vl_n[4]="Hài (tốc chạy, né tránh)"
    set vl_n[5]="Vũ Khí (sát thương %, STVL ngoại công)"
    set vl_n[6]="Hạng Liên (bạo kích, STVL nội công, xuất chiêu)"
    set vl_n[7]="Giới Chỉ (đánh trúng, hút máu, sát thương %)"
    set vl_n[8]="Ngọc Bội (hút mana, kháng 5 hệ)"
    set vl_n[9]="Hộ Thân Phù (sinh lực, giảm ST, +1 cấp kỹ năng khi +10)"
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",vl_hero,"origin"))
    call zzVL_Text(vl_hero,"|cffffcc00Cường hóa +"+I2S(zzVL_cuong[vl_playerId*10+vl_slot])+"|r")
    call zzVL_Msg(vl_playerId,"|cffffcc00Cường hóa|r "+vl_n[vl_slot]+": |cffffcc00+"+I2S(zzVL_cuong[vl_playerId*10+vl_slot])+"|r. Cấp cường hóa đi theo người.")
    call zzVL_AffixSum(vl_playerId)
    return true
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
    local integer vl_slot=0
    if vl_playerId>9 or vl_item==null or vl_hero!=Jx[vl_playerId+1] then
        return false
    endif
    set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)/10-1
    if vl_k==0 then
        set vl_slot=0
    elseif vl_k==1 then
        set vl_slot=1
    elseif vl_k==2 then
        set vl_slot=5
    elseif vl_k==3 then
        set vl_slot=4
    else
        set vl_slot=0
    endif
    return zzVL_CuongSlot(vl_hero,vl_slot)
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
        call zzGL_Give(GetPlayerId(GetOwningPlayer(vl_hero)),1)
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
                set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
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
        call SetUnitMoveSpeed(vl_unit,zzUS_Real(GetHandleId(vl_unit),zzUS_SLOW_SPEED()))
        call zzUS_SetInt(GetHandleId(vl_unit),zzUS_SLOWED(),0)
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
    elseif zzVL_wel[vl_ps]==4 and vl_atk and GetWidgetLife(vl_t)>.405 and zzUS_Int(GetHandleId(vl_t),zzUS_SLOWED())==0 then
        call zzUS_SetInt(GetHandleId(vl_t),zzUS_SLOWED(),1)
        call zzUS_SetReal(GetHandleId(vl_t),zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t))
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
        if GetRandomInt(1,100)<=2*vl_lv and vl_now>=zzUS_Real(vl_id,zzUS_KIM_STUN_CD()) and not IsUnitPaused(vl_t) and not zzVL_Steady(vl_t) then
            call zzUS_SetReal(vl_id,zzUS_KIM_STUN_CD(),vl_now+3.)
            call PauseUnit(vl_t,true)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_t,"overhead"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,.5,false,function zzVL_TpUnpause)
        endif
    elseif vl_a==2 then
        // Mộc - Độc: 5 lần, mỗi giây 0.6%/cấp sát thương đòn đánh (tổng 3%/cấp), không cộng dồn
        if vl_now>=zzUS_Real(vl_id,zzUS_MOC_POISON_CD()) then
            call zzUS_SetReal(vl_id,zzUS_MOC_POISON_CD(),vl_now+5.)
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
            call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.006*vl_lv)
            call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        endif
    elseif vl_a==4 then
        // Thủy - Băng sát: chậm 5%/cấp trong 2 giây, không cộng dồn với chậm khác
        if zzUS_Int(vl_id,zzUS_SLOWED())==0 and not zzVL_Steady(vl_t) then
            call zzUS_SetInt(vl_id,zzUS_SLOWED(),1)
            call zzUS_SetReal(vl_id,zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t))
            call SetUnitMoveSpeed(vl_t,GetUnitMoveSpeed(vl_t)*(1.-.05*vl_lv))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",vl_t,"chest"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,2.,false,function zzVL_SlowEnd)
        endif
    elseif vl_a==5 and vl_fire then
        // Hỏa - Thiêu đốt: đòn gấp đôi làm mục tiêu giảm 50% hồi máu/hút máu trong 3 giây
        call zzUS_SetReal(vl_id,zzUS_BURN_END(),vl_now+3.)
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
    local boolean vl_repl=false
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

    // Cộng thêm STVL Nội Công / Ngoại Công (phẳng) theo hệ của phái (config.py mục 15): phái ngoại chỉ hưởng
    // dòng STVL ngoại công (khóa 18), phái nội chỉ hưởng dòng STVL nội công (khóa 17), cho cả đánh thường lẫn kỹ năng
    if vl_ps<10 and vl_src==Jx[vl_ps+1] then
        if zzVL_Phe(vl_src)==2 then
            set vl_d=vl_d + zzPS_Get(vl_ps,zzPS_STVL_NOI())
        else
            set vl_d=vl_d + zzPS_Get(vl_ps,zzPS_STVL_NGOAI())
        endif
        if BlzGetEventDamageType()!=DAMAGE_TYPE_NORMAL then
            set vl_d=vl_d * (1.0 + zzPS_Get(vl_ps,zzPS_CAP_KY_NANG()) * 10.0 / 100.0)
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
            set vl_res = zzPS_Get(vl_pt,10 + vl_srcHe)
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
        set zzKS_repl=false
        call ExecuteFunc("zzKS_OnHit")
        // an autocast Q W E skill struck: the skill is the attack, the normal hit deals nothing
        if zzKS_repl then
            set zzKS_repl=false
            set vl_repl=true
        endif
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
            // né theo hệ của đòn: phái nội công → né tránh nội công, còn lại (phái ngoại, quái) → né tránh ngoại công
            set vl_evasion = zzVL_PheDodge(vl_tgt,vl_pt,zzVL_Phe(vl_src))
        else
            set vl_evasion = 50
        endif

        if vl_ps<10 and vl_src==Jx[vl_ps+1] then
            set vl_hit = zzPS_Get(vl_ps,zzPS_DANH_TRUNG())
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
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_VULN_END()) then
        set vl_d=vl_d*1.15
    endif
    // suy yeu (kskill.j zzKS_Weak): the source deals key 84 % less (at most 20)
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_src),zzUS_WEAK_END()) then
        set vl_d=vl_d*(1.-IMinBJ(20,zzUS_Int(GetHandleId(vl_src),zzUS_WEAK_PCT()))/100.)
    endif
    // bong (KVCT effect_bong, kskill.j status 5): 50% more damage
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_BONG_END()) then
        set vl_d=vl_d*1.5
    endif
    // KVCT "khi bi danh" passives (kskill.j zzKS_OnHurt, key 165)
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and vl_d>0. and not zzVL_inTp then
        set zzKS_hurt[vl_pt]=TimerGetElapsed(zzVL_clock)
        set zzKS_tgt=vl_tgt
        call ExecuteFunc("zzKS_OnHurt")
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
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_he[vl_pt]==3 and zzVL_set[vl_pt]>0 and vl_d>0. and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL and not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and TimerGetElapsed(zzVL_clock)-zzUS_Real(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST())>=.3 then
        call zzUS_SetReal(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST(),TimerGetElapsed(zzVL_clock))
        call zzVL_TpHit(vl_tgt,vl_src,vl_d*.02*zzVL_set[vl_pt])
    endif
    if vl_repl then
        set vl_d=0.
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
    if vl_hero!=null then
        call zzGL_Give(GetPlayerId(GetOwningPlayer(vl_hero)),vl_n)
    endif
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
    call zzVL_Msg(vl_playerId,"|cff00ff00Hoàn thành nhiệm vụ "+zzVL_QName(vl_t)+"!|r Nhận 1 Huyền tinh, "+I2S(vl_g)+" ngân lượng, 8 công trạng. Quay lại Sứ Giả Võ Lâm để nhận nhiệm vụ mới.")
    if ModuloInteger(zzVL_qDone[vl_playerId],5)==0 then
        call zzVL_QGiveTT(vl_hero,2)
        call zzVL_All(zzVL_Name(vl_playerId)+" đã hoàn thành "+I2S(zzVL_qDone[vl_playerId])+" nhiệm vụ của Sứ Giả Võ Lâm, nhận thêm 2 Huyền tinh.")
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
// ---- Nhóm GEMDROP: rơi bảo thạch IG<loại><bậc> theo lịch phút (docs/BAOTHACH_SPEC.md, tools/config.py mục 13)
// Phụ thuộc: gameplay_14_gem.j (zzGM_Code), zzVL_clock / zzVL_ht (gameplay_01_core.j). File này phải nối SAU gameplay_14_gem.j.
// Số liệu do Python ghi vào zzVL_ht (parent 0):
//   360 = rơi bù 1/N phần thiếu mỗi lần giết, 361 = tối đa viên mỗi lần giết (thường), 362 = tối đa viên mỗi lần giết (boss),
//   363 = bật (1) / tắt (0), 370+bậc = phút mở bậc, 380+bậc = tốc độ mục tiêu (viên/phút *1000), 390+bậc = số viên mục tiêu ngay lúc mở bậc.
// Số viên đã rơi cho từng người: zzVL_ht, 6300+người, khóa = bậc (1..9).

// Mục tiêu tích lũy (số viên) của một bậc tại phút vl_min: 0 trước khi mở, sau đó tăng đều theo phút.
function zzGD_Target takes integer vl_t,real vl_min returns real
    local real vl_open=I2R(LoadInteger(zzVL_ht,0,370+vl_t))
    if vl_min<vl_open then
        return 0.
    endif
    return LoadInteger(zzVL_ht,0,390+vl_t)+LoadInteger(zzVL_ht,0,380+vl_t)/1000.*(vl_min-vl_open)
endfunction

// Phần còn thiếu (>=0) của một bậc so với lịch.
function zzGD_Deficit takes integer vl_p,integer vl_t,real vl_min returns real
    local real vl_d=zzGD_Target(vl_t,vl_min)-LoadInteger(zzVL_ht,6300+vl_p,vl_t)
    if vl_d<0. then
        return 0.
    endif
    return vl_d
endfunction

// Chọn bậc rơi, trọng số = phần còn thiếu của từng bậc (bậc mới mở rơi ít viên nên hiếm, bậc cũ dồi dào). 0 = không cần rơi.
function zzGD_PickTier takes integer vl_p,real vl_min returns integer
    local real vl_sum=0.
    local real vl_r
    local integer vl_t=1
    loop
        exitwhen vl_t>9
        set vl_sum=vl_sum+zzGD_Deficit(vl_p,vl_t,vl_min)
        set vl_t=vl_t+1
    endloop
    if vl_sum<=0. then
        return 0
    endif
    set vl_r=GetRandomReal(0.,vl_sum)
    set vl_t=1
    loop
        exitwhen vl_t>9
        set vl_r=vl_r-zzGD_Deficit(vl_p,vl_t,vl_min)
        if vl_r<=0. then
            return vl_t
        endif
        set vl_t=vl_t+1
    endloop
    return 9
endfunction

// Hàm công khai: rơi bảo thạch theo mức (0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss) tại (x,y) cho tướng vl_hero. Gọi từ zzDR_DropKind.
function zzGD_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_p
    local real vl_min
    local real vl_sum=0.
    local real vl_want
    local integer vl_n
    local integer vl_max
    local integer vl_t
    local integer vl_code
    local item vl_it
    if vl_hero==null or LoadInteger(zzVL_ht,0,363)<=0 or LoadInteger(zzVL_ht,0,360)<=0 then
        return
    endif
    set vl_p=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_p>9 then
        return
    endif
    set vl_min=TimerGetElapsed(zzVL_clock)/60.
    set vl_t=1
    loop
        exitwhen vl_t>9
        set vl_sum=vl_sum+zzGD_Deficit(vl_p,vl_t,vl_min)
        set vl_t=vl_t+1
    endloop
    if vl_sum<=0. then
        return
    endif
    set vl_want=vl_sum/LoadInteger(zzVL_ht,0,360)
    set vl_max=LoadInteger(zzVL_ht,0,361)
    if vl_kind==1 then
        set vl_want=vl_want*1.5
    elseif vl_kind==2 then
        set vl_want=vl_want*2.
    elseif vl_kind>=3 then
        set vl_want=vl_want*3.
        set vl_max=LoadInteger(zzVL_ht,0,362)
    endif
    set vl_n=R2I(vl_want)
    if GetRandomReal(0.,1.)<vl_want-I2R(vl_n) then
        set vl_n=vl_n+1
    endif
    if vl_n>vl_max then
        set vl_n=vl_max
    endif
    loop
        exitwhen vl_n<=0
        set vl_t=zzGD_PickTier(vl_p,vl_min)
        exitwhen vl_t<=0
        set vl_code=zzGM_Code(GetRandomInt(1,6),vl_t)
        if vl_code!=0 then
            set vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
            set vl_it=null
        endif
        call SaveInteger(zzVL_ht,6300+vl_p,vl_t,LoadInteger(zzVL_ht,6300+vl_p,vl_t)+1)
        set vl_n=vl_n-1
    endloop
endfunction
// ---- Nhóm DROP: rơi trang bị kiểu KVCT (10 ô + vũ khí theo loại phái của người đánh)
// Phụ thuộc: gameplay_09_equip.j (zzEQ_*), zzVL_RollAffix (gameplay_02_farm.j). File này phải nối SAU gameplay_09_equip.j.
// Mức rơi: 0 = quái thường, 1 = Tinh Anh, 2 = Thủ Lĩnh, 3 = Boss.

// ==========================================
// BẢNG TỈ LỆ (sửa số ở đây; mỗi hàm trả về một hằng số)
// ==========================================

// Tỉ lệ (%) một con quái THƯỜNG rơi 1 món trang bị.
constant function zzDR_ChanceNormal takes nothing returns integer
return 3
endfunction

// Tỉ lệ (%) mỗi lần quay của Tinh Anh / Thủ Lĩnh.
constant function zzDR_ChanceElite takes nothing returns integer
return 40
endfunction

// Số lần quay: Tinh Anh 3, Thủ Lĩnh 6; Boss tạo 5 phôi chắc chắn.
constant function zzDR_RollsElite takes nothing returns integer
return 3
endfunction
constant function zzDR_RollsLeader takes nothing returns integer
return 6
endfunction
constant function zzDR_DropsBoss takes nothing returns integer
return 5
endfunction

// Tỉ lệ (%) món rơi là VŨ KHÍ (phần còn lại chia đều cho 9 ô: nón, áo, lưng, tay, giày, liên, nhẫn, bội, hộ phù).
constant function zzDR_ChanceWeapon takes nothing returns integer
return 20
endfunction

// ==========================================
// Mã vật phẩm
// ==========================================

// Loại vũ khí 0..10 -> mã ITV0..ITVA (kiếm, đao, thương, chùy, triền thủ, côn, tụ tiễn, phi đao, trường đao, đại đao, phi tiêu).
function zzDR_WeaponCode takes integer vl_t returns integer
    if vl_t==0 then
        return 'ITV0'
    elseif vl_t==1 then
        return 'ITV1'
    elseif vl_t==2 then
        return 'ITV2'
    elseif vl_t==3 then
        return 'ITV3'
    elseif vl_t==4 then
        return 'ITV4'
    elseif vl_t==5 then
        return 'ITV5'
    elseif vl_t==6 then
        return 'ITV6'
    elseif vl_t==7 then
        return 'ITV7'
    elseif vl_t==8 then
        return 'ITV8'
    elseif vl_t==9 then
        return 'ITV9'
    endif
    return 'ITVA'
endfunction

// Chỉ số 0..8 -> ô không phải vũ khí: nón, áo, lưng, tay, giày, liên, nhẫn, bội, hộ phù.
function zzDR_SlotCode takes integer vl_i returns integer
    if vl_i==0 then
        return 'ITS1'
    elseif vl_i==1 then
        return 'ITS2'
    elseif vl_i==2 then
        return 'ITS3'
    elseif vl_i==3 then
        return 'ITS4'
    elseif vl_i==4 then
        return 'ITS5'
    elseif vl_i==5 then
        return 'ITS7'
    elseif vl_i==6 then
        return 'ITS8'
    elseif vl_i==7 then
        return 'ITS9'
    endif
    return 'ITSA'
endfunction

// ==========================================
// Loại vũ khí người chơi dùng được (thử từng loại bằng zzEQ_CanUse, nhớ theo mã tướng). -1 = không tìm ra.
function zzDR_HeroWeapon takes unit vl_hero returns integer
    local integer vl_pid
    local integer vl_t=0
    local integer vl_found=-1
    local item vl_it
    local boolean vl_ok
    if vl_hero==null then
        return -1
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_pid<10 and LoadInteger(zzVL_ht,6100+vl_pid,0)==GetUnitTypeId(vl_hero) then
        return LoadInteger(zzVL_ht,6100+vl_pid,1)-1
    endif
    loop
        exitwhen vl_t>10 or vl_found>=0
        set vl_it=CreateItem(zzDR_WeaponCode(vl_t),0.,0.)
        if vl_it!=null then
            set vl_ok=zzEQ_CanUse(vl_hero,vl_it)
            call RemoveItem(vl_it)
            set vl_it=null
            if vl_ok then
                set vl_found=vl_t
            endif
        endif
        set vl_t=vl_t+1
    endloop
    if vl_pid<10 then
        call SaveInteger(zzVL_ht,6100+vl_pid,0,GetUnitTypeId(vl_hero))
        call SaveInteger(zzVL_ht,6100+vl_pid,1,vl_found+1)
    endif
    return vl_found
endfunction

// Tướng của người đánh (kể cả khi sát thủ là lính / triệu hồi): tướng chính Jx của chủ sở hữu.
function zzDR_KillerHero takes unit vl_killer returns unit
    local integer vl_pid
    if vl_killer==null then
        return null
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_killer))
    if vl_pid<10 and Jx[vl_pid+1]!=null then
        return Jx[vl_pid+1]
    endif
    return null
endfunction

// Chọn mã vật phẩm rơi: vũ khí đúng loại phái (nếu tìm ra) hoặc một ô ngẫu nhiên.
function zzDR_PickCode takes unit vl_hero returns integer
    local integer vl_w=-1
    if GetRandomInt(1,100)<=zzDR_ChanceWeapon() then
        set vl_w=zzDR_HeroWeapon(vl_hero)
    endif
    if vl_w>=0 then
        return zzDR_WeaponCode(vl_w)
    endif
    return zzDR_SlotCode(GetRandomInt(0,8))
endfunction

// Đếm số dòng chỉ số ngẫu nhiên đã lăn trên món đồ (khóa 31..52 của hashtable).
function zzDR_CountAff takes item vl_it returns integer
    local integer vl_id=GetHandleId(vl_it)
    local integer vl_k=1
    local integer vl_n=0
    loop
        exitwhen vl_k>22
        if zzIT_Line(vl_id,vl_k)!=0 then
            set vl_n=vl_n+1
        endif
        set vl_k=vl_k+1
    endloop
    return vl_n
endfunction

// Quay chỉ số bằng zzVL_RollAffix (hệ cũ); nếu thiếu số dòng tối thiểu thì xóa và quay lại.
function zzDR_RollAffixMin takes item vl_it,integer vl_min returns nothing
    local integer vl_id=GetHandleId(vl_it)
    local string vl_name=GetItemName(vl_it)
    local string vl_desc=BlzGetItemDescription(vl_it)
    local string vl_tip=BlzGetItemExtendedTooltip(vl_it)
    local integer vl_tries=0
    local integer vl_k
    call zzVL_RollAffix(vl_it)
    loop
        exitwhen vl_min<=0 or vl_tries>=40 or zzDR_CountAff(vl_it)>=vl_min
        call BlzSetItemName(vl_it,vl_name)
        call BlzSetItemDescription(vl_it,vl_desc)
        call BlzSetItemExtendedTooltip(vl_it,vl_tip)
        set vl_k=1
        loop
            exitwhen vl_k>22
            call zzIT_ClearLine(vl_id,vl_k)
            set vl_k=vl_k+1
        endloop
        call zzIT_Set(vl_id,zzIT_DO_CO(),0)
        call RemoveSavedInteger(zzVL_ht,vl_id,29)
        call zzVL_RollAffix(vl_it)
        set vl_tries=vl_tries+1
    endloop
endfunction

// Tạo một phôi KVCT tại (x,y). Phôi luôn +0; zzEQ_Touch gắn icon/tên mặc định KVCT.
function zzDR_MakeOne takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_code=zzDR_PickCode(vl_hero)
    local item vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
    if vl_it==null then
        return
    endif
    call zzEQ_SetTier(vl_it,0)
    // khóa 73: đồ rơi từ quái, cho phép tự mặc / tự bán (giống hệ cũ).
    call zzIT_Set(GetHandleId(vl_it),zzIT_MOI_ROI(),1)
    set vl_it=null
endfunction

// ==========================================
// RƠI HUYỀN TINH THEO LỊCH (tools/config.py mục 11): mỗi tướng được rơi dần để đúng mốc phút có bấy nhiêu món +10.
// Số huyền tinh cần cho một món +10 = 10*base + 45*step (base / step của nút +, hashtable 0 / 340, 341).


function zzDR_Crystal takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    call zzGL_Drop(vl_kind,vl_x,vl_y,vl_hero)
endfunction

// ==========================================
// Hàm công khai 1: rơi theo mức (0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss) tại (x,y), vũ khí hợp phái của vl_hero.
function zzDR_DropKind takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_roll=0
    local integer vl_count=0
    // Chỉ Tinh Anh / Thủ Lĩnh và boss rơi phôi; quái thường chỉ rơi Huyền Tinh, bảo thạch.
    // Phôi luôn +0; cấp cường hóa được kế thừa khi mặc vào ô tương ứng.
    if vl_kind==1 then
        set vl_count=zzDR_RollsElite()
    elseif vl_kind==2 then
        set vl_count=zzDR_RollsLeader()
    elseif vl_kind>=3 then
        set vl_count=zzDR_DropsBoss()
    endif
    loop
        exitwhen vl_roll>=vl_count
        if vl_roll==0 or vl_kind>=3 or GetRandomInt(1,100)<=zzDR_ChanceElite() then
            call zzDR_MakeOne(vl_kind,vl_x,vl_y,vl_hero)
        endif
        set vl_roll=vl_roll+1
    endloop
    call zzDR_Crystal(vl_kind,vl_x,vl_y,vl_hero)
    call zzGD_Drop(vl_kind,vl_x,vl_y,vl_hero)
endfunction

// Hàm công khai 2: gọi từ sự kiện chết. Đọc mức từ hashtable (khóa 10 của đơn vị chết, phải gọi TRƯỚC FlushChildHashtable)
// hoặc Boss khi vl_dead==zzVL_boss.
function zzDR_Drop takes unit vl_dead,unit vl_killer returns nothing
    local integer vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_dead),10)
    if vl_dead==zzVL_boss then
        set vl_kind=3
    endif
    call zzDR_DropKind(vl_kind,GetUnitX(vl_dead),GetUnitY(vl_dead),zzDR_KillerHero(vl_killer))
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
// ==========================================
// Hàm: zzVL_BossCastSpell
// Chức năng: Boss tự động xuất chiêu AoE theo hệ
function zzVL_BossCastSpell takes nothing returns nothing
    local timer vl_t = GetExpiredTimer()
    local unit vl_u = LoadUnitHandle(zzVL_ht, GetHandleId(vl_t), 1)
    local integer vl_type = GetUnitTypeId(vl_u)
    local real vl_x
    local real vl_y
    local group vl_g
    local unit vl_target

    if vl_u == null or GetWidgetLife(vl_u) < 0.405 then
        call FlushChildHashtable(zzVL_ht, GetHandleId(vl_t))
        call DestroyTimer(vl_t)
        return
    endif

    set vl_x = GetUnitX(vl_u)
    set vl_y = GetUnitY(vl_u)
    call SetUnitAnimation(vl_u, "spell")

    if vl_type == 'H00Z' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", vl_x, vl_y))
    elseif vl_type == 'E000' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", vl_x, vl_y))
    elseif vl_type == 'H021' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", vl_x, vl_y))
    elseif vl_type == 'H00A' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", vl_x, vl_y))
    elseif vl_type == 'E001' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", vl_x, vl_y))
    elseif vl_type == 'n008' then
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", vl_x, vl_y))
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", vl_x, vl_y))
    endif

    set vl_g = CreateGroup()
    call GroupEnumUnitsInRange(vl_g, vl_x, vl_y, 600.0, null)
    loop
        set vl_target = FirstOfGroup(vl_g)
        exitwhen vl_target == null
        call GroupRemoveUnit(vl_g, vl_target)
        if IsUnitEnemy(vl_target, GetOwningPlayer(vl_u)) and GetWidgetLife(vl_target) > 0.405 and not IsUnitType(vl_target, UNIT_TYPE_MAGIC_IMMUNE) then
            call UnitDamageTarget(vl_u, vl_target, BlzGetUnitBaseDamage(vl_u, 0) * 3.0, true, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, null)
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g = null
    set vl_target = null
    set vl_t = null
    set vl_u = null
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
    local timer vl_t
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
        set vl_bid='H00Z' // Kim
    elseif vl_k==2 then
        set vl_bid='E000' // Mộc
    elseif vl_k==3 then
        set vl_bid='H021' // Thủy
    elseif vl_k==4 then
        set vl_bid='H00A' // Hỏa
    else
        set vl_bid='E001' // Thổ
    endif
    set zzVL_boss=CreateUnit(Player(12),vl_bid,GetUnitX(vl_pick),GetUnitY(vl_pick),GetRandomReal(0,360))
    call SetUnitPosition(zzVL_boss,GetUnitX(vl_pick)-350.,GetUnitY(vl_pick)+250.)
    call BlzSetUnitName(zzVL_boss,"|cffff8000"+zzVL_bn[vl_k]+"|r")
    call BlzSetUnitMaxHP(zzVL_boss,80000+15000*vl_min)
    call SetWidgetLife(zzVL_boss,80000.+15000.*vl_min)
    call BlzSetUnitBaseDamage(zzVL_boss,600+80*vl_min,0)
    call BlzSetUnitArmor(zzVL_boss,50.+5.*vl_min)
    call SetUnitScale(zzVL_boss,5.0,5.0,5.0)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_boss),GetUnitY(zzVL_boss)))
    call zzVL_All("|cffffcc00Chú ý|r: Tuyệt đại cao thủ |cffff8000"+zzVL_bn[vl_k]+"|r tái xuất giang hồ! Hạ được: |cffffcc002 Huyền tinh|r, 1000 ngân lượng, 25 công trạng.")
    call PingMinimapEx(GetUnitX(zzVL_boss),GetUnitY(zzVL_boss),5.,255,128,0,true)

    // Start spell timer
    set vl_t = CreateTimer()
    call SaveUnitHandle(zzVL_ht, GetHandleId(vl_t), 1, zzVL_boss)
    call TimerStart(vl_t, 6.0, true, function zzVL_BossCastSpell)

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
    call zzDR_DropKind(4,GetUnitX(zzVL_boss),GetUnitY(zzVL_boss),Jx[vl_pk+1])
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
    local timer vl_t
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
    call BlzSetUnitMaxHP(zzVL_mc,2000000)
    call SetWidgetLife(zzVL_mc,2000000.)
    call BlzSetUnitBaseDamage(zzVL_mc,7000,0)
    call BlzSetUnitArmor(zzVL_mc,300.)
    call SetUnitScale(zzVL_mc,5.0,5.0,5.0)
    call SetUnitVertexColor(zzVL_mc,255,60,60,255)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_mc),GetUnitY(zzVL_mc)))
    call PingMinimapEx(GetUnitX(zzVL_mc),GetUnitY(zzVL_mc),8.,255,0,0,true)
    call zzVL_All("|cffff0000VÕ LÂM MINH CHỦ|r đã xuất hiện! Phe nào hạ được nhận |cffffcc00+10 uy danh|r, mỗi người 1000 ngân lượng.")

    // Start spell timer
    set vl_t = CreateTimer()
    call SaveUnitHandle(zzVL_ht, GetHandleId(vl_t), 1, zzVL_mc)
    call TimerStart(vl_t, 4.5, true, function zzVL_BossCastSpell)

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
    call zzDR_DropKind(4,GetUnitX(zzVL_mc),GetUnitY(zzVL_mc),Jx[vl_pk+1])
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
    local integer vl_kind
    if vl_d!=null then
        set vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_d),10)
        if LoadInteger(zzVL_ht,GetHandleId(vl_d),9)>0 then
            call zzDR_DropKind(vl_kind,GetUnitX(vl_d),GetUnitY(vl_d),zzDR_KillerHero(vl_k))
        endif
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
                        set vl_ord=zzSK_Int(vl_ab,zzSK_AI_ORDER())
                        set vl_kind=zzSK_Int(vl_ab,zzSK_AI_TARGET())
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
            set vl_ord=zzSK_Int(vl_ab,zzSK_AI_ORDER())
            set vl_kind=zzSK_Int(vl_ab,zzSK_AI_TARGET())
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
    local item vl_item
    if not zzVL_IsBagUser(vl_playerId) then
        set vl_hero=null
        return
    endif
    loop
        exitwhen vl_k>5
        set vl_item=UnitItemInSlot(vl_hero,vl_k)
        if vl_item!=null and GetItemType(vl_item)!=ITEM_TYPE_POWERUP then
            if zzVL_EqSlot(vl_item)>=0 then
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
    set vl_ext=BlzGetItemExtendedTooltip(vl_item)
    if vl_ext==null or vl_ext=="" then
        set vl_ext=BlzGetItemDescription(vl_item)
    endif
    if vl_ext!=null and vl_ext!="" then
        set vl_string=vl_string+"|n"+vl_ext
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)<50 then
        set vl_string=vl_string+"|n|cffffcc00Tài phú: "+I2S(zzVL_GearScore(vl_item))+"|r"
    endif
    return vl_string
endfunction

// Tooltip tự vẽ để hover ô tùy biến luôn hiển thị đủ mô tả, affix, khảm và cường hóa.
function zzVL_ItemHoverOn takes nothing returns nothing
    local framehandle vl_frame=BlzGetTriggerFrame()
    local player vl_player=GetTriggerPlayer()
    local integer vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_frame),8)
    local integer vl_index=LoadInteger(zzVL_ht,GetHandleId(vl_frame),9)
    local integer vl_pid=GetPlayerId(vl_player)
    local item vl_item=null
    if vl_kind==1 and vl_index>=0 and vl_index<30 then
        set vl_item=zzVL_bag[vl_pid*30+vl_index]
    elseif vl_kind==2 and vl_index>=0 and vl_index<10 then
        set vl_item=zzVL_equipItem[vl_pid*10+vl_index]
    elseif vl_kind==3 and vl_index>=0 and vl_index<10 then
        if Er[vl_pid+1]!=null then
            set vl_item=UnitItemInSlot(Er[vl_pid+1],vl_index)
        endif
    endif
    if GetLocalPlayer()==vl_player and vl_item!=null then
        call BlzFrameSetText(zzVL_fItemHoverTxt,zzVL_ItemTip(vl_item))
        call BlzFrameSetVisible(zzVL_fItemHover,true)
    endif
    set vl_item=null
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
        exitwhen vl_i>9
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
    if zzGM_Type(GetItemTypeId(vl_m))>0 then
        set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(vl_m),112)
        set vl_v=zzGM_Stat(zzGM_Type(GetItemTypeId(vl_m)),zzGM_Tier(GetItemTypeId(vl_m)))
    endif
    call SaveInteger(zzVL_ht,vl_id,43,LoadInteger(zzVL_ht,vl_id,43)+1)
    call zzIT_AddLine(vl_id,vl_k,vl_v)
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
        exitwhen vl_i>=30
        if zzVL_bag[vl_playerId*30+vl_i]==vl_t then
            set zzVL_bag[vl_playerId*30+vl_i]=null
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
                call zzVL_Msg(vl_playerId,"Đã chọn |cffffff00Huyền tinh|r. Bấm vào trang bị (mũ, áo, yêu đái, hộ uyển, hài, vũ khí, hạng liên, giới chỉ, ngọc bội, hộ thân phù) để cường hóa.")
            elseif zzVL_sendTK[vl_playerId] then
                if vl_tk!=null and UnitInventoryCount(vl_tk)<6 then
                    set zzVL_bag[vl_playerId*30+vl_code]=null
                    call SetItemVisible(vl_item,true)
                    call SetItemPosition(vl_item,GetUnitX(vl_tk),GetUnitY(vl_tk))
                    call UnitAddItem(vl_tk,vl_item)
                else
                    call zzVL_Msg(vl_playerId,"Thủ Khố đã đầy (6 ô).")
                endif
            else
                set vl_w=zzVL_EqSlot(vl_item)
                if vl_w>=0 and vl_w<=9 and not zzEQ_CheckWear(vl_hero,vl_item) then
                    set vl_w=-2
                endif
                if vl_w>=0 and vl_w<=9 then
                    set vl_old=zzVL_equipItem[vl_playerId*10+vl_w]
                    call zzEQ_InheritSlot(vl_playerId,vl_w,vl_item,vl_old)
                    set zzVL_bag[vl_playerId*30+vl_code]=null
                    if vl_old!=null then
                        set zzVL_bag[vl_playerId*30+vl_code]=vl_old
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
                        set zzVL_bag[vl_playerId*30+vl_code]=null
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
    elseif vl_code<40 then
        set vl_item=zzVL_equipItem[vl_playerId*10+vl_code-30]
        if vl_item!=null and zzVL_khamMode[vl_playerId] and zzVL_kSel[vl_playerId]==0 and LoadInteger(zzVL_ht,GetItemTypeId(vl_item),44)>0 then
            set zzVL_kSel[vl_playerId]=1
            set zzVL_kItem[vl_playerId]=vl_item
            call zzVL_Msg(vl_playerId,"Đã chọn "+GetItemName(vl_item)+". Bấm vào trang bị để khảm.")
        elseif vl_item!=null and zzVL_khamMode[vl_playerId] then
            call zzVL_Kham(vl_playerId,vl_item)
        elseif vl_item!=null and zzVL_tSel[vl_playerId]!=null then
            call zzVL_TtUse(vl_playerId,vl_item)
        elseif vl_item!=null then
            if zzVL_BagAdd(vl_playerId,vl_item) then
                set zzVL_equipItem[vl_playerId*10+vl_code-30]=null
                call zzVL_AffixSum(vl_playerId)
                call ExecuteFunc("zzVL_HeroTick")
            else
                call zzVL_Msg(vl_playerId,"|cffff8000Hành trang phụ đã đầy, không thể tháo đồ.|r")
            endif
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
    if vl_code>=100 and vl_code<110 then
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
    local framehandle vl_b=BlzCreateFrameByType("BUTTON","",zzVL_fMain,"",0)
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
    call BlzFrameSetVisible(vl_bg,false)
    // Item details are rendered by the shared hover frame; keep native tooltip from overlaying adjacent controls.
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),7,vl_code+1)
    if vl_code<30 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),8,1)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),9,vl_code)
    elseif vl_code>=36 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),8,3)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),9,vl_code-36)
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
        if zzVL_equipItem[vl_playerId*10+vl_i]!=null and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)<50 then
            set vl_tp=vl_tp+zzVL_GearScore(zzVL_equipItem[vl_playerId*10+vl_i])
        endif
        set vl_i=vl_i+1
    endloop
    set vl_string="|cffffcc00"+GetHeroProperName(vl_hero)+"|r - "+GetUnitName(vl_hero)+"|nCấp "+I2S(GetHeroLevel(vl_hero))+"  |  "+zzVL_hn[zzVL_he[vl_playerId]]+"  |  "+zzVL_rn[zzVL_rank[vl_playerId]]
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
    loop
        exitwhen vl_playerId>9
        // lưới an toàn: tướng có rồi mà chưa được phát bộ +0 (hook chọn tướng không chạy) thì phát ở đây
        if not zzEQ_starterGiven[vl_playerId] and Jx[vl_playerId+1]!=null and IsUnitType(Jx[vl_playerId+1],UNIT_TYPE_HERO) then
            set zzEQ_starterHero[vl_playerId]=Jx[vl_playerId+1]
            call zzEQ_GiveStarter()
        endif
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
        exitwhen vl_i>=30
        set vl_item=zzVL_bag[vl_playerId*30+vl_i]
        if vl_item!=null and GetItemTypeId(vl_item)=='I00W' then
            set vl_n=IMaxBJ(1,GetItemCharges(vl_item))
            call zzGL_Give(vl_playerId,vl_n)
            set zzVL_bag[vl_playerId*30+vl_i]=null
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
    local real vl_x0=.495
    local trigger vl_t
    local framehandle vl_b
    local framehandle vl_x
    call BlzLoadTOCFile("war3mapImported\\vltk.toc")
    set zzVL_tClick=CreateTrigger()
    call TriggerAddAction(zzVL_tClick,function zzVL_OnFrameClick)
    set zzVL_tItemHoverOn=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOn,function zzVL_ItemHoverOn)
    set zzVL_tItemHoverOff=CreateTrigger()
    call TriggerAddAction(zzVL_tItemHoverOff,function zzVL_ItemHoverOff)
    set zzVL_fMain=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_TOPLEFT,.475,.565)
    call BlzFrameSetAbsPoint(zzVL_fMain,FRAMEPOINT_BOTTOMRIGHT,.785,.185)
    call zzVL_Panel(zzVL_fMain,.478,.562,.782,.188,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fMain,.495,.548,.27,"|cffffcc00HÀNH TRANG|r  (phím B)")
    call zzVL_MakeText(zzVL_fMain,.495,.520,.27,"Hành trang - bấm để mặc / dùng")
    set vl_i=0
    loop
        exitwhen vl_i>29
        call zzVL_MakeSlot(vl_i,vl_x0+ModuloInteger(vl_i,6)*.045,.505-(vl_i/6)*.038)
        set vl_i=vl_i+1
    endloop
    call zzVL_MakeText(zzVL_fMain,.495,.312,.27,"Thủ Khố (chế đồ) - bấm để lấy về")
    set vl_i=0
    loop
        exitwhen vl_i>5
        call zzVL_MakeSlot(36+vl_i,vl_x0+vl_i*.045,.296)
        set vl_i=vl_i+1
    endloop
    set zzVL_fMode=zzVL_MakeButton(42,zzVL_fMain,.495,.255,.075,"Gửi đồ: TẮT")
    set zzVL_fSell=zzVL_MakeButton(46,zzVL_fMain,.571,.255,.045,"Bán")
    set zzVL_fSplit=zzVL_MakeButton(47,zzVL_fMain,.617,.255,.045,"Tách")
    set zzVL_fKham=zzVL_MakeButton(48,zzVL_fMain,.663,.255,.05,"Khảm")
    set zzVL_fHl[0]=zzVL_MakeHl(zzVL_fMode)
    set zzVL_fHl[1]=zzVL_MakeHl(zzVL_fSell)
    set zzVL_fHl[2]=zzVL_MakeHl(zzVL_fSplit)
    set zzVL_fHl[3]=zzVL_MakeHl(zzVL_fKham)
    call zzVL_MakeButton(45,zzVL_fMain,.714,.255,.032,"|cff00ffffChế|r")
    call zzVL_MakeButton(43,zzVL_fMain,.747,.255,.03,"X")
    set zzVL_fAuto=zzVL_MakeButton(49,zzVL_fMain,.495,.23,.11,"Tự bán: TẮT")
    set zzVL_fHl[4]=zzVL_MakeHl(zzVL_fAuto)
    set zzVL_fInfo=zzVL_MakeText(zzVL_fMain,.495,.205,.28,"")
    call BlzFrameSetVisible(zzVL_fMain,false)
    set zzVL_fScore=zzVL_MakeText(vl_ui,.685,.52,.10,"")
    call BlzFrameSetSize(zzVL_fScore,.10,.03)
    call BlzFrameSetTextAlignment(zzVL_fScore,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
    set zzVL_fClock=zzVL_MakeText(vl_ui,.67,.548,.12,"|cffffcc00Thời gian|r 0:00")
    set zzVL_fOpen=zzVL_MakeIconButton(44,vl_ui,.232,.566,.045,"war3mapImported\\vl_ui_bag.blp")
    call zzVL_MakeIconButton(50,vl_ui,.280,.566,.045,"war3mapImported\\vl_ui_hero.blp")
    set zzVL_fHero=BlzCreateFrame("EscMenuBackdrop",vl_ui,0,0)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_TOPLEFT,.015,.535)
    call BlzFrameSetAbsPoint(zzVL_fHero,FRAMEPOINT_BOTTOMRIGHT,.365,.155)
    call zzVL_Panel(zzVL_fHero,.018,.532,.362,.158,"war3mapImported\\vl_ui_panel.blp",245)
    call zzVL_MakeText(zzVL_fHero,.085,.520,.20,"|cffffcc00NHÂN VẬT & TRANG BỊ|r  (phím C)")
    set zzVL_fHeroTxt=zzVL_MakeText(zzVL_fHero,.083,.502,.211,"")
    call BlzFrameSetSize(zzVL_fHeroTxt,.211,.33)
    call BlzFrameSetScale(zzVL_fHeroTxt,.88)
    set vl_i=0
    loop
        exitwhen vl_i>4
        set zzVL_fEqBtn[vl_i]=BlzCreateFrameByType("BUTTON","",zzVL_fHero,"",0)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),7,30+vl_i+1)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),8,2)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[vl_i]),9,vl_i)
        call BlzFrameSetSize(zzVL_fEqBtn[vl_i],.032,.032)
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[vl_i],FRAMEPOINT_TOPLEFT,.025,.482-vl_i*.048)
        set zzVL_fEqIco[vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[vl_i],"",0)
        call BlzFrameSetAllPoints(zzVL_fEqIco[vl_i],zzVL_fEqBtn[vl_i])
        call BlzFrameSetTexture(zzVL_fEqIco[vl_i],"war3mapImported\\vl_eq_"+I2S(vl_i+1)+".blp",0,true)
        set zzVL_fEqTxt[vl_i]=BlzCreateFrameByType("TEXT","",zzVL_fEqBtn[vl_i],"",0)
        call BlzFrameSetAbsPoint(zzVL_fEqTxt[vl_i],FRAMEPOINT_BOTTOMRIGHT,.025+.032,.482-vl_i*.048-.032)
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
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),7,35+vl_i+1)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),8,2)
        call SaveInteger(zzVL_ht,GetHandleId(zzVL_fEqBtn[5+vl_i]),9,5+vl_i)
        call BlzFrameSetSize(zzVL_fEqBtn[5+vl_i],.032,.032)
        call BlzFrameSetAbsPoint(zzVL_fEqBtn[5+vl_i],FRAMEPOINT_TOPLEFT,.322,.482-vl_i*.048)
        set zzVL_fEqIco[5+vl_i]=BlzCreateFrameByType("BACKDROP","",zzVL_fEqBtn[5+vl_i],"",0)
        call BlzFrameSetAllPoints(zzVL_fEqIco[5+vl_i],zzVL_fEqBtn[5+vl_i])
        call BlzFrameSetTexture(zzVL_fEqIco[5+vl_i],"war3mapImported\\vl_eq_"+I2S(6+vl_i)+".blp",0,true)
        set zzVL_fEqTxt[5+vl_i]=BlzCreateFrameByType("TEXT","",zzVL_fEqBtn[5+vl_i],"",0)
        call BlzFrameSetAbsPoint(zzVL_fEqTxt[5+vl_i],FRAMEPOINT_BOTTOMRIGHT,.322+.032,.482-vl_i*.048-.032)
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
            call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,.061,.484-vl_i*.048)
        else
            call BlzFrameSetAbsPoint(vl_b,FRAMEPOINT_TOPLEFT,.293,.484-(vl_i-5)*.048)
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
    call QuestSetDescription(vl_q,"|cffffcc00Bộ trang bị|r: đủ mũ, áo, vũ khí, giày. Cấp bộ = món thấp nhất (thường 1, +1..+3 là 2..4, hoàng kim 5). Kim +5% sát thương/cấp và 2%/cấp làm choáng, Mộc hút 3%/cấp và gây độc, Thổ giảm 4% sát thương nhận/cấp, phản 2%/cấp và miễn choáng/chậm ngũ hành, Thủy hồi 0.5% sinh lực/giây/cấp và làm chậm 5%/cấp, Hỏa 4%/cấp gây gấp đôi kèm thiêu đốt (giảm 50% hồi máu).|n|cffffcc00Ngũ hành|r: đánh thường vào hệ bị khắc +20%.|n|cffffcc00Quân hàm|r: hạ tướng +10, hỗ trợ +4, hạ trùm +15, bị quái hạ -3. Mỗi bậc +2% sát thương và tự động nâng cấp chỉ số phi phong ẩn.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Hành trang và nhiệm vụ")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Hành trang|r: bấm phím B (hoặc nút Hành Trang, gõ -hd). Túi tướng là 6 ô trang bị: mũ, áo, vũ khí, giày, phi phong, ô dùng nhanh (thuốc, Huyền tinh). Đồ khác nằm trong hành trang 30 ô, bấm để mặc. Chế đồ: bật Gửi Thủ Khố rồi bấm nguyên liệu.|n|cffffcc00Nhiệm vụ|r: đưa tướng tới gần Sứ Giả Võ Lâm (cạnh căn cứ) rồi bấm chọn ông ấy. Xong được Huyền tinh, ngân lượng, công trạng; cứ 5 nhiệm vụ thêm 2 Huyền tinh. Gõ -nv để xem.|n|cffffcc00Đánh quái|r: cả phe cùng nhận vàng, đồng đội ở xa cũng nhận kinh nghiệm, không cần đánh phát cuối.")
    set vl_q=CreateQuest()
    call QuestSetTitle(vl_q,"Phi phong và cao thủ (1.31)")
    call QuestSetIconPath(vl_q,"ReplaceableTextures\\CommandButtons\\BTNCloak.blp")
    call QuestSetRequired(vl_q,false)
    call QuestSetDescription(vl_q,"|cffffcc00Phi phong|r: mỗi quân hàm tự động nâng cấp chỉ số phi phong ẩn (tăng sinh lực, giáp, thuộc tính) và nhận danh hiệu trên đầu: Hiệu Úy - Siêu Phàm, Thống Lĩnh - Xuất Trần, Phó Tướng - Kinh Thế, Đại Tướng - Ỷ Thiên, Nguyên Soái - |cffff6000Chí Tôn|r. Phi phong tự gắn vào nhân vật, không chiếm ô hành trang.|n|cffffcc00Tuyệt đại cao thủ|r: cứ 7 phút xuất hiện một lần ở khu quái (có chấm trên bản đồ nhỏ). Hạ được: 2 Huyền tinh, 1000 ngân lượng (đồng đội 300), 25 công trạng.|n|cffffcc00Võ Lâm Minh Chủ|r: cứ 18 phút xuất hiện một lần (nếu Minh Chủ trước đã bị hạ). Phe hạ được +10 uy danh, mỗi người 1000 ngân lượng.|n|cffffcc00Hạ tướng|r: mỗi lần +300 ngân lượng. |cffffcc00Nhất đao đoạt mạng|r: hạ tướng đầu tiên của trận thêm 500 ngân lượng, 10 công trạng.")
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
    call ExecuteFunc("zzGS_Init")
    call ExecuteFunc("zzSH_Init")
    call ExecuteFunc("zzTL_Init")
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
// ---- Boss Tan Thuy Hoang (KVCT): xuat hien dinh ky o khu quai, ha duoc roi "Tan Lang Hoa Thi Bich" ('ITHB').
// Don vi 'n0TL' do tools/tanlang.py tao trong war3map.w3u. Khong dung bien toan cuc moi: trang thai nam trong
// zzVL_ht, khoa cha 'n0TL' (1 = boss dang song, 2 = phut xuat hien ke tiep, 3 = da noi gian chua).
// Hook can them: trong zzVL_Init them dong  call ExecuteFunc("zzTL_Init")  (xem docs/trangbi/BOSS_VABAN.md).

// ==========================================
// Cau hinh (so mac dinh dat o day, vi khong sua config.py)
// ==========================================
// KVCT: cong Tan Lang mo moi 30 phut (1800 giay), mo keo dai 20 phut, Tan Thuy Hoang hien khi cong con 10 phut
// (tuc phut 40, 70, 100...). Map nay ngan hon nen lay phut dau 30 (tu suy), cach nhau 30 phut (theo KVCT).
function zzTL_FirstMinute takes nothing returns integer
    return 20
endfunction

function zzTL_Interval takes nothing returns integer
    return 5
endfunction

// Chi so (tu suy, dua tren khung boss co san: Minh Chu 2.000.000 mau / 7000 sat thuong / 300 giap phut 18).
function zzTL_Hp takes integer vl_min returns integer
    return 1500000+40000*vl_min
endfunction

function zzTL_Damage takes integer vl_min returns integer
    return 2500+100*vl_min
endfunction

function zzTL_Armor takes integer vl_min returns real
    return 150.+4.*vl_min
endfunction

// ==========================================
// Ham: zzTL_Alive
// Chuc nang: boss con song khong
function zzTL_Alive takes nothing returns boolean
    local unit vl_b=LoadUnitHandle(zzVL_ht,'n0TL',1)
    local boolean vl_r=(vl_b!=null and GetWidgetLife(vl_b)>.405)
    set vl_b=null
    return vl_r
endfunction

// ==========================================
// Ham: zzTL_Blast
// Chuc nang: boss danh phep dien rong quanh minh (ke thu = thu dich cua phe quai, khong mien phep)
function zzTL_Blast takes unit vl_boss,real vl_radius,real vl_mult,string vl_fx returns nothing
    local real vl_x=GetUnitX(vl_boss)
    local real vl_y=GetUnitY(vl_boss)
    local real vl_dmg=I2R(BlzGetUnitBaseDamage(vl_boss,0))*vl_mult
    local group vl_g=CreateGroup()
    local unit vl_u
    call SetUnitAnimation(vl_boss,"spell")
    call DestroyEffect(AddSpecialEffect(vl_fx,vl_x,vl_y))
    call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,vl_radius,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if IsUnitEnemy(vl_u,GetOwningPlayer(vl_boss)) and GetWidgetLife(vl_u)>.405 and not IsUnitType(vl_u,UNIT_TYPE_MAGIC_IMMUNE) then
            call UnitDamageTarget(vl_boss,vl_u,vl_dmg,true,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    set vl_u=null
endfunction

// ==========================================
// Ham: zzTL_Cast
// Chuc nang: timer chieu cua boss, 3 chieu xoay vong: Hoang Uy (AoE gan), Vuong Dao (AoE rong), Van Quan Phuc Thu (AoE xa);
// duoi 50% mau hoa "ban than" (BienThan), tang sat thuong 30%, tung chieu nhanh hon.
function zzTL_Cast takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_b=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),1)
    local integer vl_n
    local integer vl_m
    if vl_b==null or GetWidgetLife(vl_b)<.405 then
        call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
        call DestroyTimer(vl_t)
        set vl_t=null
        set vl_b=null
        return
    endif
    set vl_n=LoadInteger(zzVL_ht,GetHandleId(vl_t),2)+1
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),2,vl_n)
    if LoadInteger(zzVL_ht,'n0TL',3)==0 and GetWidgetLife(vl_b)<GetUnitState(vl_b,UNIT_STATE_MAX_LIFE)*.5 then
        call SaveInteger(zzVL_ht,'n0TL',3,1)
        call BlzSetUnitBaseDamage(vl_b,R2I(I2R(BlzGetUnitBaseDamage(vl_b,0))*1.3),0)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\BienThan_tanthuyhoang.mdx",vl_b,"origin"))
        call zzVL_All("|cffffcc07Tần Thủy Hoàng|r nổi giận, hóa thân Chân Long! Sát thương tăng 30%.")
        call TimerStart(vl_t,3.5,true,function zzTL_Cast)
    endif
    set vl_m=ModuloInteger(vl_n,3)
    if vl_m==0 then
        call zzTL_Blast(vl_b,550.,2.,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
    elseif vl_m==1 then
        call zzTL_Blast(vl_b,800.,1.5,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl")
    else
        call zzTL_Blast(vl_b,1100.,1.,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    endif
    set vl_t=null
    set vl_b=null
endfunction

// ==========================================
// Ham: zzTL_Spawn
// Chuc nang: sinh boss tai mot quai rung ngau nhien (khung giong zzVL_BossSpawn), thong bao cho moi nguoi choi
function zzTL_Spawn takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local unit vl_b
    local timer vl_t
    local integer vl_n=0
    local integer vl_min=R2I(TimerGetElapsed(zzVL_clock)/60.)
    local real vl_x=GetRectCenterX(bj_mapInitialPlayableArea)
    local real vl_y=GetRectCenterY(bj_mapInitialPlayableArea)
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
    if vl_pick!=null then
        set vl_x=GetUnitX(vl_pick)
        set vl_y=GetUnitY(vl_pick)
    endif
    set vl_b=CreateUnit(Player(12),'n0TL',vl_x,vl_y,GetRandomReal(0.,360.))
    if vl_b==null then
        set vl_pick=null
        return
    endif
    call SaveUnitHandle(zzVL_ht,'n0TL',1,vl_b)
    call SaveInteger(zzVL_ht,'n0TL',3,0)
    call BlzSetUnitName(vl_b,"|cffffcc07Tần Thủy Hoàng|r")
    call BlzSetUnitMaxHP(vl_b,zzTL_Hp(vl_min))
    call SetWidgetLife(vl_b,I2R(zzTL_Hp(vl_min)))
    call BlzSetUnitBaseDamage(vl_b,zzTL_Damage(vl_min),0)
    call BlzSetUnitArmor(vl_b,zzTL_Armor(vl_min))
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",vl_x,vl_y))
    call PingMinimapEx(vl_x,vl_y,8.,255,200,0,true)
    set zzVL_logMsg="|cffffcc07TẦN THỦY HOÀNG|r xuất hiện ở khu quái!"
    call ExecuteFunc("zzVL_BannerMsg")
    call zzVL_All("|cffffcc07Tần Thủy Hoàng|r đã xuất hiện! Kẻ hạ được hắn sẽ nhận |cffffcc00Tần Lăng Hòa Thị Bích|r.")
    call zzVL_Log("tan thuy hoang xuat hien")
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),1,vl_b)
    call TimerStart(vl_t,5.,true,function zzTL_Cast)
    set vl_t=null
    set vl_b=null
    set vl_pick=null
endfunction

// ==========================================
// Ham: zzTL_Tick
// Chuc nang: moi giay: den phut hen va boss chua song thi sinh boss, dat phut ke tiep
function zzTL_Tick takes nothing returns nothing
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    if vl_m>=LoadInteger(zzVL_ht,'n0TL',2) then
        call SaveInteger(zzVL_ht,'n0TL',2,vl_m+zzTL_Interval())
        if not zzTL_Alive() then
            call zzTL_Spawn()
        endif
    endif
endfunction

// ==========================================
// Buff đội hạ Tần Thủy Hoàng: +20% chỉ số thuộc tính chính (cao nhất trong Sức mạnh / Thân pháp / Nội công) trong zzTL_BuffSeconds giây.
// Trạng thái lưu trên tướng (zzVL_ht, handle tướng): 41 = mã phiên (chống hết hạn nhầm khi nhận lại buff), 42 = loại chỉ số, 43 = số cộng.
function zzTL_BuffPercent takes nothing returns integer
    return 20
endfunction

function zzTL_BuffSeconds takes nothing returns integer
    return 180
endfunction

function zzTL_BuffRemove takes unit vl_h returns nothing
    local integer vl_amount=LoadInteger(zzVL_ht,GetHandleId(vl_h),43)
    if vl_amount>0 then
        call ModifyHeroStat(LoadInteger(zzVL_ht,GetHandleId(vl_h),42),vl_h,bj_MODIFYMETHOD_SUB,vl_amount)
        call SaveInteger(zzVL_ht,GetHandleId(vl_h),43,0)
    endif
endfunction

function zzTL_BuffEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_h=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0)
    if vl_h!=null and LoadInteger(zzVL_ht,GetHandleId(vl_h),41)==LoadInteger(zzVL_ht,GetHandleId(vl_t),1) then
        call zzTL_BuffRemove(vl_h)
        call zzVL_Text(vl_h,"|cff808080Hết buff Tần Thủy Hoàng|r")
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
    set vl_h=null
endfunction

function zzTL_Buff takes unit vl_h returns nothing
    local integer vl_str
    local integer vl_agi
    local integer vl_int
    local integer vl_stat
    local integer vl_amount
    local integer vl_token
    local timer vl_t
    if vl_h==null or GetWidgetLife(vl_h)<.405 then
        return
    endif
    call zzTL_BuffRemove(vl_h)
    set vl_str=GetHeroStr(vl_h,true)
    set vl_agi=GetHeroAgi(vl_h,true)
    set vl_int=GetHeroInt(vl_h,true)
    set vl_stat=bj_HEROSTAT_STR
    set vl_amount=vl_str
    if vl_agi>vl_amount then
        set vl_stat=bj_HEROSTAT_AGI
        set vl_amount=vl_agi
    endif
    if vl_int>vl_amount then
        set vl_stat=bj_HEROSTAT_INT
        set vl_amount=vl_int
    endif
    set vl_amount=vl_amount*zzTL_BuffPercent()/100
    call ModifyHeroStat(vl_stat,vl_h,bj_MODIFYMETHOD_ADD,vl_amount)
    set vl_token=LoadInteger(zzVL_ht,GetHandleId(vl_h),41)+1
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),41,vl_token)
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),42,vl_stat)
    call SaveInteger(zzVL_ht,GetHandleId(vl_h),43,vl_amount)
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_h)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,vl_token)
    call TimerStart(vl_t,I2R(zzTL_BuffSeconds()),false,function zzTL_BuffEnd)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget.mdl",vl_h,"overhead"))
    call zzVL_Text(vl_h,"|cffffcc00Buff Tần Thủy Hoàng: +"+I2S(zzTL_BuffPercent())+"% chỉ số chính|r")
    set vl_t=null
endfunction

// ==========================================
// Ham: zzTL_OnDeath
// Chuc nang: boss chet: thuong vang cho phe nguoi ha, cong trang, roi 'ITHB' tai cho boss chet
function zzTL_OnDeath takes nothing returns nothing
    local unit vl_d=GetTriggerUnit()
    local unit vl_k=GetKillingUnit()
    local real vl_x
    local real vl_y
    local integer vl_pk=-1
    local integer vl_i=0
    if GetUnitTypeId(vl_d)!='n0TL' then
        set vl_d=null
        set vl_k=null
        return
    endif
    set vl_x=GetUnitX(vl_d)
    set vl_y=GetUnitY(vl_d)
    if vl_k!=null then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
    endif
    call FlushChildHashtable(zzVL_ht,'n0TL')
    call SaveInteger(zzVL_ht,'n0TL',2,R2I(TimerGetElapsed(zzVL_clock)/60.)+zzTL_Interval())
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",vl_x,vl_y))
    call PingMinimapEx(vl_x,vl_y,5.,255,200,0,true)
    if vl_pk>=0 and vl_pk<=9 then
        call zzDR_DropKind(4,vl_x,vl_y,Jx[vl_pk+1])
        call zzVL_All(zzVL_Name(vl_pk)+" đã hạ |cffffcc07Tần Thủy Hoàng|r! Bảo thạch và Huyền Tinh đã rơi.")
        loop
            exitwhen vl_i>9
            if IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
                call AdjustPlayerStateBJ(1500,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
                call zzTL_Buff(Jx[vl_i+1])
            endif
            set vl_i=vl_i+1
        endloop
        call zzVL_AddCT(vl_pk,40)
    else
        call zzVL_All("|cffffcc07Tần Thủy Hoàng|r đã bị hạ! |cffffcc00Tần Lăng Hòa Thị Bích|r rơi xuống đất.")
    endif
    set vl_d=null
    set vl_k=null
endfunction

// ==========================================
// Ham: zzTL_Init
// Chuc nang: dat dong ho su kien va trigger chet cua boss. Goi mot lan tu zzVL_Init: call ExecuteFunc("zzTL_Init")
function zzTL_Init takes nothing returns nothing
    local trigger vl_trg=CreateTrigger()
    call SaveInteger(zzVL_ht,'n0TL',2,zzTL_FirstMinute())
    call TriggerRegisterAnyUnitEventBJ(vl_trg,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(vl_trg,function zzTL_OnDeath)
    call TimerStart(CreateTimer(),1.,true,function zzTL_Tick)
    set vl_trg=null
endfunction