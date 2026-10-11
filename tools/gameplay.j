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
// Công ngũ hành (10/10/2026): đối trọng tấn công của kháng ngũ hành (11..15) ở trên, cộng % sát thương theo hệ của
// CHIÊU đang đánh (không phải đòn đánh thường), lấy từ chiêu bị động KVCT ghi "X công" dạng cộng thẳng mà trước đó
// không có chỗ chứa (vd Côn Lôn Kiếm "lôi công +200"). Không có "công vật lý": hệ đó dùng chung sát thương % (stat 5).
// Công thức (gameplay_04_combat.j): sát thương x (1 + công_hệ/100) x (1 - kháng_hệ_của_địch/100).
constant function zzPS_CONG_DOC takes nothing returns integer
    return 27 // công độc %
endfunction
constant function zzPS_CONG_THUY takes nothing returns integer
    return 28 // công thủy %
endfunction
constant function zzPS_CONG_HOA takes nothing returns integer
    return 29 // công hỏa %
endfunction
constant function zzPS_CONG_LOI takes nothing returns integer
    return 30 // công lôi % (27..30 = 26 + hệ 2..5, bỏ hệ 1 vật lý vì dùng chung stat 5)
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
    return 3000 // số lỗ đã khảm; tách khỏi dòng chỉ số 30+k
endfunction
constant function zzIT_LO_KHAM takes nothing returns integer
    return 3010 // 3010 + i: loại vật phẩm bảo thạch đã khảm vào lỗ i
endfunction
constant function zzIT_LO_KHAM_CHU takes nothing returns integer
    return 3020 // 3020 + i: đoạn mô tả "[Khảm] ..." đã thêm cho lỗ i (để gỡ khi tách)
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
// Chỉ số buff/bị động thứ 3 (10/10/2026): thêm vì công ngũ hành (User: không được thế chỗ chỉ số cũ như chí mạng /
// tốc đánh, phải thêm riêng). Cùng cách dùng STAT1/STAT1_BASE/STAT1_PER ở trên.
constant function zzSK_STAT3 takes nothing returns integer
    return 260 // chỉ số 3
endfunction
constant function zzSK_STAT3_BASE takes nothing returns integer
    return 261 // chỉ số 3: giá trị gốc
endfunction
constant function zzSK_STAT3_PER takes nothing returns integer
    return 262 // chỉ số 3: thêm mỗi bậc
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
    return 69 // phần tốc chạy đã bị trừ khi làm chậm (trả lại khi hết)
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
// Shared cleanup tracker for every visible ground item. Kept in core so all item-drop modules can call it.
function zzDR_ExpireTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local item vl_it=LoadItemHandle(zzVL_ht,vl_id,0)
    call SaveReal(zzVL_ht,vl_id,2,LoadReal(zzVL_ht,vl_id,2)+.5)
    if vl_it!=null and GetItemTypeId(vl_it)!=0 and not IsItemOwned(vl_it) and LoadReal(zzVL_ht,vl_id,2)>=zzCF_DROP_EXPIRE_SECONDS() then
        call RemoveSavedBoolean(zzVL_ht,GetHandleId(vl_it),900)
        call RemoveItem(vl_it)
        set vl_it=null
    endif
    if vl_it==null or GetItemTypeId(vl_it)==0 or IsItemOwned(vl_it) or not IsItemVisible(vl_it) then
        if vl_it!=null then
            call RemoveSavedBoolean(zzVL_ht,GetHandleId(vl_it),900)
        endif
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_it=null
endfunction

function zzDR_TrackItem takes item vl_it returns nothing
    local timer vl_t
    if vl_it==null or GetItemTypeId(vl_it)==0 or IsItemOwned(vl_it) or not IsItemVisible(vl_it) or LoadBoolean(zzVL_ht,GetHandleId(vl_it),900) then
        return
    endif
    set vl_t=CreateTimer()
    call SaveBoolean(zzVL_ht,GetHandleId(vl_it),900,true)
    call SaveItemHandle(zzVL_ht,GetHandleId(vl_t),0,vl_it)
    call TimerStart(vl_t,.5,true,function zzDR_ExpireTick)
    set vl_t=null
endfunction

function zzDR_TrackEnumItem takes nothing returns nothing
    call zzDR_TrackItem(GetEnumItem())
endfunction

function zzDR_OnUnitDrop takes nothing returns nothing
    call zzDR_TrackItem(GetManipulatedItem())
endfunction

function zzDR_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_i=0
    call EnumItemsInRect(GetWorldBounds(),null,function zzDR_TrackEnumItem)
    loop
        exitwhen vl_i>bj_MAX_PLAYER_SLOTS-1
        call TriggerRegisterPlayerUnitEvent(vl_t,Player(vl_i),EVENT_PLAYER_UNIT_DROP_ITEM,null)
        set vl_i=vl_i+1
    endloop
    call TriggerAddAction(vl_t,function zzDR_OnUnitDrop)
    set vl_t=null
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
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        if zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]==vl_find then
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
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_it=zzVL_bag[vl_pid*zzCF_BAG_SLOTS()+vl_i]
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
    // Grant directly to the killer; never create a terrain item for Huyền Tinh.
    // Keep lifetime-earned accounting so the existing catch-up schedule stays balanced.
    call SaveInteger(zzVL_ht,6200+vl_pid,1,LoadInteger(zzVL_ht,6200+vl_pid,1)+vl_n)
    call zzGL_Give(vl_pid,vl_n)
    // Rate-limit text feedback to one notice every 2 seconds per player.
    set vl_stamp=TimerGetElapsed(zzVL_clock)
    if vl_stamp-LoadReal(zzVL_ht,6200+vl_pid,3)>=2. then
        call DisplayTimedTextToPlayer(Player(vl_pid),0.,0.,2.,"|cffffcc00Nhận Huyền Tinh +"+I2S(vl_n)+".|r")
        call SaveReal(zzVL_ht,6200+vl_pid,3,vl_stamp)
    endif
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
// Sức mạnh/Thân pháp/Nội công (8/9/10) trước chỉ rơi ở MỘT ô (7, Hạng Liên, chen với bạo kích) trong khi Sinh lực (7)
// rơi ở 2 ô (1,2) -> Nội công hiếm hẳn so với Sinh lực trên trang bị (User báo 10/10/2026, cấp 130 phái Võ Đang).
// Đã tách mỗi chỉ số thêm 1 ô riêng (3 Yêu Đái, 4 Hộ Uyển, 9 Ngọc Bội) để ngang tỉ lệ rơi với Sinh lực.
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
        return "37"
    elseif vl_k==9 then
        return "47"
    elseif vl_k==10 then
        return "97"
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
// Bậc cường hóa hiệu lực 0..10; Tần Lăng dùng hình cấp 11 nhưng chỉ số vẫn tính ở +10.
function zzEQ_Tier takes item vl_it returns integer
    if vl_it==null then
        return 0
    endif
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_it),93)==2 then
        return 10
    endif
    return zzIT_Get(GetHandleId(vl_it),zzIT_BAC())
endfunction

// Hệ số chỉ số (%) theo bậc t: 100 + 30*t; tối đa +10 = 400%, kể cả vũ khí Tần Lăng.
function zzEQ_Pct takes integer vl_t returns integer
    if vl_t<=0 then
        return 100
    endif
    if vl_t>10 then
        set vl_t=10
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
// Tần Lăng giữ hình cấp 11 nhưng bậc cường hóa và chỉ số hiệu lực tối đa là +10.
// Không làm gì với trang bị cũ của map (không có khóa 93).
function zzEQ_SetTier takes item vl_it,integer vl_t returns nothing
    local integer vl_type
    local integer vl_id
    local integer vl_len
    local integer vl_visualTier
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
    set vl_visualTier=vl_t
    if LoadInteger(zzVL_ht,vl_type,93)==2 then
        set vl_t=10
        set vl_visualTier=11
    elseif vl_t>10 then
        set vl_t=10
    endif
    if vl_t<0 then
        set vl_t=0
    endif
    call zzIT_Set(vl_id,zzIT_BAC(),vl_t)
    call zzIT_Set(vl_id,zzIT_BAC_DA_GAN(),1)
    set vl_nm=LoadStr(zzVL_ht,vl_type,120+vl_visualTier)
    if vl_nm!=null and vl_nm!="" then
        call BlzSetItemIconPath(vl_it,vl_nm)
    endif
    set vl_nm=GetItemName(vl_it)
    set vl_len=StringLength(vl_nm)
    if vl_len>=14 and SubString(vl_nm,vl_len-14,vl_len)==" |cff00ff00*|r" then
        set vl_star=" |cff00ff00*|r"
    endif
    set vl_nm=LoadStr(zzVL_ht,vl_type,100+vl_visualTier)
    if vl_nm!=null and vl_nm!="" then
        if vl_t>0 then
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
        call zzVL_Msg(vl_pid,"|cffff8000Vũ khí Tần Lăng|r đã đạt tối đa +10, không cường hóa thêm được.")
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

// Bản clone chứa mesh vũ khí gốc và lớp sáng ôm đúng bề mặt. Hệ của món đang mặc
// chọn màu model; dùng cùng kích thước với vũ khí gốc để đầu sáng không vượt khỏi lưỡi.
// Lightning KGTR/KTAT chạy trong MDX. Khóa 612 được sinh từ ATCH thật của từng tướng;
// không dùng AddLightning/MoveLightning hay lưu vị trí cũ để vẽ sét khi di chuyển.
function zzEQ_UpdateWeaponGlow takes integer vl_pid returns nothing
    local unit vl_hero=Jx[vl_pid+1]
    local item vl_weapon=zzVL_equipItem[vl_pid*10+5]
    local integer vl_uid
    local integer vl_iid=0
    local integer vl_element=0
    local integer vl_tier=0
    local integer vl_weaponType
    local integer vl_oldItem
    local integer vl_oldElement
    local integer vl_oldTier
    local integer vl_type
    local string vl_model
    local string vl_point
    local real vl_scale
    local effect vl_fx
    if vl_hero==null then
        set vl_weapon=null
        return
    endif
    set vl_uid=GetHandleId(vl_hero)
    set vl_type=GetUnitTypeId(vl_hero)
    if vl_weapon!=null and zzEQ_Slot(GetItemTypeId(vl_weapon))==6 and GetWidgetLife(vl_hero)>.405 then
        set vl_iid=GetHandleId(vl_weapon)
        set vl_element=LoadInteger(zzVL_ht,GetItemTypeId(vl_weapon),66)
        set vl_tier=zzEQ_Tier(vl_weapon)
    elseif GetWidgetLife(vl_hero)>.405 then
        // Every sect keeps its default weapon before custom gear is equipped.
        set vl_weaponType=LoadInteger(zzVL_ht,vl_type,96)-1
        if vl_weaponType>=0 and vl_weaponType<=10 then
            set vl_iid=-vl_type
            if vl_weaponType<10 then
                set vl_element=LoadInteger(zzVL_ht,'ITV0'+vl_weaponType,66)
            else
                set vl_element=LoadInteger(zzVL_ht,'ITVA',66)
            endif
        endif
    endif
    set vl_oldItem=LoadInteger(zzVL_ht,vl_uid,590)
    set vl_oldElement=LoadInteger(zzVL_ht,vl_uid,591)
    set vl_oldTier=LoadInteger(zzVL_ht,vl_uid,592)
    if vl_iid!=vl_oldItem or vl_element!=vl_oldElement or vl_tier!=vl_oldTier then
        set vl_fx=LoadEffectHandle(zzVL_ht,vl_uid,593)
        if vl_fx!=null then
            call DestroyEffect(vl_fx)
            call RemoveSavedHandle(zzVL_ht,vl_uid,593)
        endif
        set vl_fx=LoadEffectHandle(zzVL_ht,vl_uid,599)
        if vl_fx!=null then
            call DestroyEffect(vl_fx)
            call RemoveSavedHandle(zzVL_ht,vl_uid,599)
        endif
        if LoadStr(zzVL_ht,vl_type,601)!=null then
            // Forearm sockets share the embedded blade matrices; no skin change or duplicate weapon mesh.
            if vl_iid!=0 and vl_element>=1 and vl_element<=5 then
                set vl_fx=AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_type,600+vl_element),vl_hero,"sprite,first")
                call BlzPlaySpecialEffect(vl_fx,ANIM_TYPE_STAND)
                call SaveEffectHandle(zzVL_ht,vl_uid,593,vl_fx)
                set vl_fx=AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_type,605+vl_element),vl_hero,"sprite,second")
                call BlzPlaySpecialEffect(vl_fx,ANIM_TYPE_STAND)
                call SaveEffectHandle(zzVL_ht,vl_uid,599,vl_fx)
            endif
        elseif vl_iid!=0 then
            set vl_model=null
            if vl_element>=1 and vl_element<=5 then
                set vl_model=LoadStr(zzVL_ht,vl_type,593+vl_element)
            endif
            if vl_model==null or vl_model=="" then
                set vl_model=LoadStr(zzVL_ht,vl_type,270)
            endif
            set vl_point=LoadStr(zzVL_ht,vl_type,612)
            if vl_model!=null and vl_model!="" and vl_point!=null and vl_point!="" then
                set vl_fx=AddSpecialEffectTarget(vl_model,vl_hero,vl_point)
                call BlzPlaySpecialEffect(vl_fx,ANIM_TYPE_STAND)
                set vl_scale=BlzGetUnitRealField(vl_hero,UNIT_RF_SCALING_VALUE)
                if vl_scale>1.05 then
                    call BlzSetSpecialEffectScale(vl_fx,1./vl_scale)
                endif
                call SaveEffectHandle(zzVL_ht,vl_uid,593,vl_fx)
                set vl_fx=null
            endif
        endif
        call SaveInteger(zzVL_ht,vl_uid,590,vl_iid)
        call SaveInteger(zzVL_ht,vl_uid,591,vl_element)
        call SaveInteger(zzVL_ht,vl_uid,592,vl_tier)
    endif
    set vl_fx=null
    set vl_weapon=null
    set vl_hero=null
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
    call zzEQ_UpdateWeaponGlow(vl_pid)
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
    local integer vl_kind=LoadInteger(zzVL_ht,vl_itemType,110)
    // Nhận diện trực tiếp mã IG<loại><bậc> để luồng khảm không phụ thuộc
    // việc bảng hashtable đã được nạp trước khi người chơi bấm bảo thạch.
    if vl_kind==0 and vl_itemType/65536==18759 then
        set vl_kind=ModuloInteger(vl_itemType/256,256)-48
        if vl_kind<1 or vl_kind>6 or ModuloInteger(vl_itemType,256)<49 or ModuloInteger(vl_itemType,256)>57 then
            return 0
        endif
    endif
    if vl_kind==0 and vl_itemType/16777216==75 then
        set vl_kind=100+(ModuloInteger(vl_itemType/65536,256)-48)*10+ModuloInteger(vl_itemType/256,256)-48
        if vl_kind<101 or vl_kind>122 or ModuloInteger(vl_itemType,256)<49 or ModuloInteger(vl_itemType,256)>51 then
            return 0
        endif
    endif
    return vl_kind
endfunction

function zzGM_Tier takes integer vl_itemType returns integer
    local integer vl_tier=LoadInteger(zzVL_ht,vl_itemType,111)
    if vl_tier==0 and zzGM_Type(vl_itemType)>0 then
        set vl_tier=ModuloInteger(vl_itemType,256)-48
    endif
    return vl_tier
endfunction

function zzGM_Code takes integer vl_type,integer vl_tier returns integer
    if vl_type>=101 and vl_type<=122 and vl_tier>=1 and vl_tier<=3 then
        return 75*16777216+(48+(vl_type-100)/10)*65536+(48+ModuloInteger(vl_type-100,10))*256+48+vl_tier
    endif
    if vl_type<1 or vl_type>6 or vl_tier<1 or vl_tier>9 then
        return 0
    endif
    return 73*16777216+71*65536+(48+vl_type)*256+48+vl_tier
endfunction

function zzGM_Stat takes integer vl_type,integer vl_tier returns integer
    local integer vl_value=LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),113)
    local integer vl_scale=1
    if vl_value>0 then
        return vl_value
    endif
    if vl_tier<1 or vl_tier>9 then
        return 0
    endif
    if vl_tier==2 then
        set vl_scale=2
    elseif vl_tier==3 then
        set vl_scale=3
    elseif vl_tier==4 then
        set vl_scale=5
    elseif vl_tier==5 then
        set vl_scale=8
    elseif vl_tier==6 then
        set vl_scale=12
    elseif vl_tier==7 then
        set vl_scale=18
    elseif vl_tier==8 then
        set vl_scale=27
    elseif vl_tier==9 then
        set vl_scale=40
    endif
    if vl_type==4 then
        return 120*vl_scale
    endif
    return vl_scale
endfunction

function zzGM_StatCode takes integer vl_type,integer vl_tier returns integer
    local integer vl_stat=LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),112)
    if vl_stat>0 then
        return vl_stat
    endif
    if vl_type==1 then
        return 3
    elseif vl_type==2 then
        return 4
    elseif vl_type==3 then
        return 5
    elseif vl_type==4 then
        return 7
    elseif vl_type==5 then
        return 6
    elseif vl_type==6 then
        return 16
    endif
    return 0
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
        call zzEQ_Redesc(vl_item)
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
    // hệ thống trang bị cũ đã bỏ; máy tự mặc đồ KVCT qua zzVL_AutoGear
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
    return vl_string+40*zzIT_Get(GetHandleId(vl_item),zzIT_SO_LO_KHAM())+100*zzEQ_Tier(vl_item)
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
    call zzEQ_Redesc(vl_item)
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
    if zzVL_IsEquipped(vl_playerId,vl_item) then
        return
    endif
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
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_hero))
    local integer vl_type=GetItemTypeId(vl_n)
    local integer vl_slot
    local item vl_old
    local boolean vl_ai
    if vl_pid>9 or vl_hero!=Jx[vl_pid+1] or not zzEQ_IsKv(vl_type) or zzIT_Get(GetHandleId(vl_n),zzIT_MOI_ROI())==0 then
        return
    endif
    set vl_ai=GetPlayerController(Player(vl_pid))==MAP_CONTROL_COMPUTER
    if not zzVL_autoSell[vl_pid] and not vl_ai then
        return
    endif
    call zzIT_Set(GetHandleId(vl_n),zzIT_MOI_ROI(),0)
    set vl_slot=zzEQ_Slot(vl_type)-1
    if vl_slot<0 or vl_slot>9 then
        return
    endif
    set vl_old=zzVL_equipItem[vl_pid*10+vl_slot]
    if not zzEQ_CanUse(vl_hero,vl_n) then
        // vũ khí sai loại của phái: không mặc được, tự bán (trừ khi đã khảm)
        if zzIT_Get(GetHandleId(vl_n),zzIT_SO_LO_KHAM())<=0 then
            call zzVL_AutoSellItem(vl_pid,vl_hero,vl_n)
        endif
    elseif vl_old==null or zzVL_GearScore(vl_n)>zzVL_GearScore(vl_old) then
        // mặc món mới (nhận cấp cường hóa của ô), món cũ tự bán nếu chưa khảm, có khảm thì giữ lại ở dưới chân
        call zzEQ_InheritSlot(vl_pid,vl_slot,vl_n,vl_old)
        set zzVL_equipItem[vl_pid*10+vl_slot]=vl_n
        if UnitHasItem(vl_hero,vl_n) then
            call UnitRemoveItem(vl_hero,vl_n)
        endif
        call SetItemVisible(vl_n,false)
        call zzVL_Msg(vl_pid,"|cff00ff00Đã mặc "+GetItemName(vl_n)+"|r")
        if vl_old!=null then
            set zzVL_equipItem[vl_pid*10+vl_slot]=vl_n
            if zzIT_Get(GetHandleId(vl_old),zzIT_SO_LO_KHAM())<=0 then
                call zzVL_AutoSellItem(vl_pid,vl_hero,vl_old)
            else
                // món cũ chưa bao giờ bị UnitRemoveItem (lúc mặc chỉ ẩn đi, vẫn nằm trong túi gốc của tướng) -> dù
                // SetItemVisible(true) nó vẫn coi là "đang được sở hữu", nhặt lại không được, cứ nằm mãi dưới chân
                // (10/10/2026, User báo). Phải thả khỏi tướng trước thì mới thành vật phẩm tự do, nhặt lại được.
                if UnitHasItem(vl_hero,vl_old) then
                    call UnitRemoveItem(vl_hero,vl_old)
                endif
                // Cất vào túi 60 ô nếu còn chỗ; nếu đầy, wrapper mới thả lệch khỏi chân tướng và gắn hạn 60 giây.
                call SaveItemHandle(zzVL_ht,8800+vl_pid,0,vl_old)
                call ExecuteFunc("zzVL_StoreAutoGear")
            endif
        endif
        call ExecuteFunc("zzVL_HeroTick")
    elseif zzIT_Get(GetHandleId(vl_n),zzIT_SO_LO_KHAM())<=0 then
        call zzVL_AutoSellItem(vl_pid,vl_hero,vl_n)
    endif
    set vl_old=null
endfunction

// ==========================================
// Hàm: zzVL_OnAffixPickup
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAffixPickup takes nothing returns nothing
    if zzEQ_IsGear(GetItemTypeId(GetManipulatedItem())) and not zzEQ_IsKv(GetItemTypeId(GetManipulatedItem())) then
        // trang bị cũ của map: hệ thống đã bỏ, xóa khi nhặt
        call RemoveItem(GetManipulatedItem())
        return
    endif
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
    // đồ cũ: cấp cường hóa của ô đi vào mô tả kiểu mới (zzEQ_Describe), chỉ dựng lại khi cấp đổi
    if zzIT_Get(vl_id,zzIT_CUONG_O())==vl_n+1 then
        return
    endif
    call zzIT_Set(vl_id,zzIT_CUONG_O(),vl_n+1)
    call zzEQ_Redesc(vl_item)
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
    call zzEQ_SyncSlots(vl_playerId)
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
    // phi phong (bậc zzVL_cl, config GAME CLOAK_*_PER_TIER): phòng thủ, 3 chỉ số, sinh lực
    if zzVL_cl[vl_playerId]>0 then
        set zzVL_af[vl_playerId*16+11]=zzVL_af[vl_playerId*16+11]+zzCF_CLOAK_DEF_PER_TIER()*zzVL_cl[vl_playerId]
        set zzVL_af[vl_playerId*16+8]=zzVL_af[vl_playerId*16+8]+zzCF_CLOAK_STAT_PER_TIER()*zzVL_cl[vl_playerId]
        set zzVL_af[vl_playerId*16+9]=zzVL_af[vl_playerId*16+9]+zzCF_CLOAK_STAT_PER_TIER()*zzVL_cl[vl_playerId]
        set zzVL_af[vl_playerId*16+10]=zzVL_af[vl_playerId*16+10]+zzCF_CLOAK_STAT_PER_TIER()*zzVL_cl[vl_playerId]
        set zzVL_af[vl_playerId*16+7]=zzVL_af[vl_playerId*16+7]+zzCF_CLOAK_HP_PER_TIER()*zzVL_cl[vl_playerId]
    endif
    if zzVL_bcd[vl_playerId]<=0. then
        set zzVL_bcd[vl_playerId]=BlzGetUnitAttackCooldown(vl_hero,0)
    endif
    if zzVL_af[vl_playerId*16+4]!=zzVL_asNow[vl_playerId] and zzVL_bcd[vl_playerId]>0. then
        set zzVL_asNow[vl_playerId]=zzVL_af[vl_playerId*16+4]
        set vl_base=zzVL_bcd[vl_playerId]/(1.+zzVL_af[vl_playerId*16+4]/100.)
        // trần tốc đánh (đòn/giây) theo hệ, dù cộng tốc đánh % tới đâu cũng không vượt (khóa 0/462 ngoại, 0/463 nội
        // x100, config.py PHE_ATTACK_SPEED_CAP) - User 10/10/2026: tốc đánh cao làm chiêu autocast ra quá nhanh.
        // zzVL_Phe (gameplay_03_tranphai.j) nằm SAU module này khi ghép -> gọi thẳng zzHT_He (gameplay_01_core.j,
        // module đầu) tương đương, tránh lỗi "Undeclared function" (10/10/2026).
        if zzHT_He(vl_hero)==2 then
            set vl_base=RMaxBJ(vl_base,100./I2R(LoadInteger(zzVL_ht,0,463)))
        else
            set vl_base=RMaxBJ(vl_base,100./I2R(LoadInteger(zzVL_ht,0,462)))
        endif
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

    // Kinh nghiệm theo cấp bãi và loại quái, không tính theo cấp hiện tại của tướng.
    if vl_k!=null and GetPlayerId(GetOwningPlayer(vl_k))<10 and Jx[GetPlayerId(GetOwningPlayer(vl_k))+1]!=null and GetHeroLevel(Jx[GetPlayerId(GetOwningPlayer(vl_k))+1])<200 then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
        set vl_n=zzCF_KILL_XP_BASE()+zzCF_KILL_XP_PER_CAMP_LEVEL()*zzVL_cLevel[vl_c]
        if vl_elite==1 then
            set vl_n=vl_n*zzCF_KILL_XP_ELITE_MUL()+300
        elseif vl_elite==2 then
            set vl_n=vl_n*zzCF_KILL_XP_LEADER_MUL()+1500
        endif
        call AddHeroXP(Jx[vl_pk+1],vl_n,true)
        call zzVL_Text(Jx[vl_pk+1],"|cff9ad0ff+"+I2S(vl_n)+" kinh nghiệm|r")
    endif
    if vl_k!=null and GetPlayerId(GetOwningPlayer(vl_k))<10 then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
        if vl_elite == 1 then
            call AdjustPlayerStateBJ(200, Player(vl_pk), PLAYER_STATE_RESOURCE_GOLD)
        elseif vl_elite == 2 then
            call AdjustPlayerStateBJ(1000, Player(vl_pk), PLAYER_STATE_RESOURCE_GOLD)
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

// ---- hệ phái ngoại/nội công + hàm dùng chung cho sát thương kỹ năng KVCT (TpHit/TpFoe...). Tuyệt học trấn phái kiểu Thiên Kiếm đã bỏ:
// trấn phái = skill ô 11 của KVCT (kskill). zzVL_tpEnd[pid*12] / zzVL_shield: hộ thuẫn kind 9 của KVCT.

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
// Sức mạnh đòn kỹ năng theo hệ: % sát thương vũ khí + hệ số × Sức mạnh / Thân pháp / Nội công + % × Nội lực tối đa
// (khóa 0/450..459, ×100; phái nội công dùng Nội lực tối đa làm sức mạnh, xem config.py mục 15 PHE_SKILL_SCALE).
// Trả về -1 nếu tướng chưa có hệ (khi đó dùng cách cũ: vũ khí + chỉ số chính).
function zzVL_PheAtk takes unit vl_h,real vl_weapon returns real
    local integer vl_k
    if zzHT_He(vl_h)==0 or not IsUnitType(vl_h,UNIT_TYPE_HERO) then
        return -1.
    endif
    set vl_k=450+5*(zzVL_Phe(vl_h)-1)
    return vl_weapon*LoadInteger(zzVL_ht,0,vl_k)/100.+(GetHeroStr(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+1)+GetHeroAgi(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+2)+GetHeroInt(vl_h,true)*LoadInteger(zzVL_ht,0,vl_k+3))/100.+GetUnitState(vl_h,UNIT_STATE_MAX_MANA)*LoadInteger(zzVL_ht,0,vl_k+4)/100./100.
endfunction

// ==========================================
// Hàm: zzVL_PheDodge
// Né tránh (phần nghìn trước khi trừ đánh trúng) của tướng vl_t trước đòn hệ vl_phe:
// ngoại = Thân pháp/2 + dòng né tránh + khóa 25 (buff né ngoại); nội = Nội công × khóa 0/458 /100 + dòng né tránh + khóa 26 (buff né nội).
function zzVL_PheDodge takes unit vl_t,integer vl_pt,integer vl_phe returns integer
    if vl_phe==2 then
        return R2I(GetHeroInt(vl_t,true)*LoadInteger(zzVL_ht,0,460)/100.)+zzPS_Get(vl_pt,zzPS_NE_TRANH())+zzPS_Get(vl_pt,zzPS_NE_NOI_BUFF())
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
    if not zzVL_gotStart[vl_playerId] then
        set zzVL_gotStart[vl_playerId]=true
        set zzVL_potion=CreateItem('phea',GetUnitX(vl_hero),GetUnitY(vl_hero))
        call SetItemCharges(zzVL_potion,10)
        call UnitAddItem(vl_hero,zzVL_potion)
        set zzVL_potion=null
    endif
    if zzVL_wel[vl_playerId]==4 and GetWidgetLife(vl_hero)>.405 then
        call SetWidgetLife(vl_hero,GetWidgetLife(vl_hero)+GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.004*zzVL_HealMul(vl_hero))
        call SetUnitState(vl_hero,UNIT_STATE_MANA,GetUnitState(vl_hero,UNIT_STATE_MANA)+GetUnitState(vl_hero,UNIT_STATE_MAX_MANA)*.008)
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
    if vl_pt>9 or vl_tgt!=Jx[vl_pt+1] then
        return vl_d
    endif
    // hộ thuẫn (kind 9 của KVCT, kskill.j): zzVL_shield hấp thụ sát thương tới hết zzVL_tpEnd
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
    call zzVL_Msg(vl_playerId,"|cffffcc00Cường hóa|r "+vl_n[vl_slot]+": |cffffcc00+"+I2S(zzVL_cuong[vl_playerId*10+vl_slot])+"|r")
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
// Hàm: zzVL_OnCuongHoaCast
// Chức năng: Thủy tinh (ability A00N) cường hóa trang bị theo ô (zzVL_CuongHoa). Hệ tuyệt học trấn phái kiểu
// Thiên Kiếm (A0T0-A0TA) đã bỏ: trấn phái = skill ô 11 của KVCT (kskill), xem docs/KIEN_TRUC_CODE.md.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnCuongHoaCast takes nothing returns nothing
    local unit vl_hero=GetTriggerUnit()
    if GetSpellAbilityId()=='A00N' and GetPlayerId(GetOwningPlayer(vl_hero))<=9 then
        call zzVL_CuongHoa(vl_hero,GetSpellTargetItem())
    endif
    set vl_hero=null
endfunction
// ---- set bonus, element fix-up, Thuy regeneration: every second

// Bù cấp theo mốc (config.py CATCHUP_*): mỗi CATCHUP_MINUTES phút lấy cấp trung bình của 5 tướng người chơi THẤP NHẤT;
// tướng thấp hơn mức đó được kéo lên đúng mức đó, tướng bằng / cao hơn không được cấp mà được CATCHUP_GOLD vàng.
function zzVL_CatchUp takes nothing returns nothing
    local integer vl_p=0
    local integer vl_n=0
    local integer vl_i
    local integer vl_j
    local integer vl_x
    local integer vl_sum=0
    local integer vl_avg
    local integer array vl_lv
    loop
        exitwhen vl_p>9
        if Jx[vl_p+1]!=null and IsUnitType(Jx[vl_p+1],UNIT_TYPE_HERO) and GetPlayerSlotState(Player(vl_p))==PLAYER_SLOT_STATE_PLAYING then
            set vl_lv[vl_n]=GetHeroLevel(Jx[vl_p+1])
            set vl_n=vl_n+1
        endif
        set vl_p=vl_p+1
    endloop
    if vl_n==0 then
        return
    endif
    // sắp xếp tăng dần (tối đa 10 phần tử)
    set vl_i=0
    loop
        exitwhen vl_i>=vl_n
        set vl_j=vl_i+1
        loop
            exitwhen vl_j>=vl_n
            if vl_lv[vl_j]<vl_lv[vl_i] then
                set vl_x=vl_lv[vl_i]
                set vl_lv[vl_i]=vl_lv[vl_j]
                set vl_lv[vl_j]=vl_x
            endif
            set vl_j=vl_j+1
        endloop
        set vl_i=vl_i+1
    endloop
    set vl_i=0
    loop
        exitwhen vl_i>=IMinBJ(5,vl_n)
        set vl_sum=vl_sum+vl_lv[vl_i]
        set vl_i=vl_i+1
    endloop
    set vl_avg=vl_sum/IMinBJ(5,vl_n)
    set vl_p=0
    loop
        exitwhen vl_p>9
        if Jx[vl_p+1]!=null and IsUnitType(Jx[vl_p+1],UNIT_TYPE_HERO) and GetPlayerSlotState(Player(vl_p))==PLAYER_SLOT_STATE_PLAYING then
            if GetHeroLevel(Jx[vl_p+1])<vl_avg then
                call SetHeroLevel(Jx[vl_p+1],vl_avg,true)
                call zzVL_Msg(vl_p,"|cff9ad0ffBù cấp:|r tướng được nâng lên cấp "+I2S(vl_avg)+" (trung bình 5 tướng thấp nhất).")
            else
                call SetPlayerState(Player(vl_p),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_p),PLAYER_STATE_RESOURCE_GOLD)+zzCF_CATCHUP_GOLD())
                call zzVL_Msg(vl_p,"|cffffcc00Bù cấp:|r tướng đã vượt mức "+I2S(vl_avg)+", nhận "+I2S(zzCF_CATCHUP_GOLD())+" vàng.")
            endif
        endif
        set vl_p=vl_p+1
    endloop
endfunction

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
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null then
            // kinh nghiệm chỉ từ farm quái (không còn tự tăng theo thời gian); bù cấp mỗi CATCHUP_MINUTES phút ở zzVL_CatchUp
            call SetPlayerHandicapXP(Player(vl_playerId),zzCF_XP_HANDICAP())
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
            // cấp bộ ngũ hành = món thấp nhất trong đủ 10 ô trang bị (thiếu 1 ô: 0). Trang bị KVCT tính theo bậc cường hóa
            // (config.py GAME: BO_CAP_BAC_*), đồ cũ của map tính theo cấp ghi trong khóa 0 (1..5)
            set vl_lv=5
            set vl_i=0
            loop
                exitwhen vl_i>9
                set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]
                if vl_item==null then
                    set vl_lv=0
                elseif zzEQ_IsKv(GetItemTypeId(vl_item)) then
                    set vl_v=zzEQ_Tier(vl_item)
                    if vl_v>=zzCF_BO_CAP5_TU_BAC() then
                        set vl_v=5
                    elseif vl_v>=zzCF_BO_CAP4_TU_BAC() then
                        set vl_v=4
                    elseif vl_v>=zzCF_BO_CAP3_TU_BAC() then
                        set vl_v=3
                    elseif vl_v>=zzCF_BO_CAP2_TU_BAC() then
                        set vl_v=2
                    else
                        set vl_v=1
                    endif
                    set vl_lv=IMinBJ(vl_lv,vl_v)
                else
                    set vl_v=LoadInteger(zzVL_ht,GetItemTypeId(vl_item),0)
                    set vl_lv=IMinBJ(vl_lv,IMaxBJ(0,vl_v-(vl_v/10)*10))
                endif
                set vl_i=vl_i+1
            endloop
            if vl_lv!=zzVL_set[vl_playerId] then
                if GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER then
                    if vl_lv>0 then
                        call zzVL_Msg(vl_playerId,"|cffffcc00Bộ trang bị "+zzVL_hn[zzVL_he[vl_playerId]]+" cấp "+I2S(vl_lv)+"/5|r: "+zzVL_SetText(zzVL_he[vl_playerId],vl_lv))
                    else
                        call zzVL_Msg(vl_playerId,"|cffff8000Bộ trang bị không còn đủ 10 món|r")
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
        // trả lại đúng phần tốc chạy đã trừ (không ghi đè tốc chạy cũ: tốc từ trang bị đổi giữa lúc chậm vẫn giữ đúng)
        call SetUnitMoveSpeed(vl_unit,GetUnitMoveSpeed(vl_unit)+zzUS_Real(GetHandleId(vl_unit),zzUS_SLOW_SPEED()))
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
        // không cộng dồn: mỗi mục tiêu chỉ 1 timer độc của vũ khí (trước đây mỗi đòn đánh 1 timer)
        if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_t),zzUS_WEAPON_POISON_END()) then
            return
        endif
        call zzUS_SetReal(GetHandleId(vl_t),zzUS_WEAPON_POISON_END(),TimerGetElapsed(zzVL_clock)+5.)
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
        call zzUS_SetReal(GetHandleId(vl_t),zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t)*.3)
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
        if GetRandomInt(1,100)<=zzCF_KIM_CHOANG_PCT_MOI_CAP()*vl_lv and vl_now>=zzUS_Real(vl_id,zzUS_KIM_STUN_CD()) and not IsUnitPaused(vl_t) and not zzVL_Steady(vl_t) then
            call zzUS_SetReal(vl_id,zzUS_KIM_STUN_CD(),vl_now+zzCF_KIM_CHOANG_HOI())
            call PauseUnit(vl_t,true)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_t,"overhead"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,zzCF_KIM_CHOANG_GIAY(),false,function zzVL_TpUnpause)
        endif
    elseif vl_a==2 then
        // Mộc - Độc: 5 lần, mỗi giây 0.6%/cấp sát thương đòn đánh (tổng 3%/cấp), không cộng dồn
        if vl_now>=zzUS_Real(vl_id,zzUS_MOC_POISON_CD()) then
            call zzUS_SetReal(vl_id,zzUS_MOC_POISON_CD(),vl_now+zzCF_MOC_DOC_GIAY())
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_hero)
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
            call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*zzCF_MOC_DOC_MOI_CAP()*vl_lv)
            call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        endif
    elseif vl_a==4 then
        // Thủy - Băng sát: chậm 5%/cấp trong 2 giây, không cộng dồn với chậm khác
        if zzUS_Int(vl_id,zzUS_SLOWED())==0 and not zzVL_Steady(vl_t) then
            call zzUS_SetInt(vl_id,zzUS_SLOWED(),1)
            call zzUS_SetReal(vl_id,zzUS_SLOW_SPEED(),GetUnitMoveSpeed(vl_t)*zzCF_THUY_CHAM_MOI_CAP()*vl_lv)
            call SetUnitMoveSpeed(vl_t,GetUnitMoveSpeed(vl_t)*(1.-zzCF_THUY_CHAM_MOI_CAP()*vl_lv))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",vl_t,"chest"))
            set vl_tm=CreateTimer()
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_t)
            call TimerStart(vl_tm,zzCF_THUY_CHAM_GIAY(),false,function zzVL_SlowEnd)
        endif
    elseif vl_a==5 and vl_fire then
        // Hỏa - Thiêu đốt: đòn gấp đôi làm mục tiêu giảm 50% hồi máu/hút máu trong 3 giây
        call zzUS_SetReal(vl_id,zzUS_BURN_END(),vl_now+zzCF_HOA_THIEU_DOT_GIAY())
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
    // Khinh công: mọi nguồn sát thương đều bị chặn trong cửa sổ lướt.
    if IsUnitType(vl_tgt,UNIT_TYPE_HERO) and TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_DASH_IMMUNE_END()) then
        call BlzSetEventDamage(0.)
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
            set vl_m=vl_m+zzCF_KIM_SAT_THUONG_MOI_CAP()*vl_lv
        elseif vl_lv>0 and vl_a==5 and GetRandomInt(1,100)<=zzCF_HOA_GAP_DOI_PCT_MOI_CAP()*vl_lv then
            set vl_m=vl_m+1.
            set vl_crit=true
            set vl_fire=true
        endif
        set vl_m=vl_m+zzCF_QUAN_HAM_SAT_THUONG()*zzVL_rank[vl_ps]
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
            set vl_d=vl_d * (1.0 + zzPS_Get(vl_ps,zzPS_CAP_KY_NANG()) * zzCF_CAP_KY_NANG_PCT() / 100.0)
        endif
    endif

    // Công ngũ hành (10/10/2026, đối trọng kháng ngũ hành 11..15 ở trên): chỉ lên sát thương KỸ NĂNG, lấy từ chiêu bị
    // động KVCT (kskill.j zzKS_Tick, khóa 27..30 trên zzPS). Mỗi hệ độc lập: dmg x (1+công/100) x (1-kháng địch/100).
    // Phái thường chỉ có công đúng 1 hệ (theo chủ đề chiêu), không cần biết chiêu nào đang đánh thuộc hệ gì.
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and BlzGetEventDamageType()!=DAMAGE_TYPE_NORMAL then
        if zzPS_Get(vl_ps,zzPS_CONG_DOC())>0 then
            set vl_d=vl_d*(1.+zzPS_Get(vl_ps,zzPS_CONG_DOC())/100.)*(1.-IMinBJ(zzCF_KHANG_TOI_DA(),zzPS_Get(vl_pt,zzPS_KHANG_DOC()))/100.)
        endif
        if zzPS_Get(vl_ps,zzPS_CONG_THUY())>0 then
            set vl_d=vl_d*(1.+zzPS_Get(vl_ps,zzPS_CONG_THUY())/100.)*(1.-IMinBJ(zzCF_KHANG_TOI_DA(),zzPS_Get(vl_pt,zzPS_KHANG_THUY()))/100.)
        endif
        if zzPS_Get(vl_ps,zzPS_CONG_HOA())>0 then
            set vl_d=vl_d*(1.+zzPS_Get(vl_ps,zzPS_CONG_HOA())/100.)*(1.-IMinBJ(zzCF_KHANG_TOI_DA(),zzPS_Get(vl_pt,zzPS_KHANG_HOA()))/100.)
        endif
        if zzPS_Get(vl_ps,zzPS_CONG_LOI())>0 then
            set vl_d=vl_d*(1.+zzPS_Get(vl_ps,zzPS_CONG_LOI())/100.)*(1.-IMinBJ(zzCF_KHANG_TOI_DA(),zzPS_Get(vl_pt,zzPS_KHANG_LOI()))/100.)
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
                if vl_res > zzCF_KHANG_TOI_DA() then
                    set vl_res = zzCF_KHANG_TOI_DA()
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
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_wel[vl_ps]>0 and (not zzVL_inTp or zzVL_skHit) and not vl_repl then
        set vl_d=vl_d*zzCF_NGU_HANH_VU_KHI_NHAN()
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
            set vl_evasion = zzCF_NE_QUAI()
        endif

        if vl_ps<10 and vl_src==Jx[vl_ps+1] then
            set vl_hit = zzPS_Get(vl_ps,zzPS_DANH_TRUNG())
        else
            set vl_hit = zzCF_DANH_TRUNG_QUAI()
        endif

        if vl_evasion > 0 then
            set vl_chance = vl_evasion - vl_hit
            if vl_chance < 0 then
                set vl_chance = 0
            endif
            if vl_chance > zzCF_NE_TOI_DA() then
                set vl_chance = zzCF_NE_TOI_DA()
            endif

            if GetRandomInt(1,1000) <= vl_chance then
                set vl_d=0.
                call zzVL_Text(vl_tgt,"|cff80ff80Né|r")
            endif
        endif
    endif
    set vl_d=zzVL_TpDef(vl_src,vl_tgt,vl_pt,vl_d)
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_VULN_END()) then
        set vl_d=vl_d*zzCF_BI_THUONG_NHAN()
    endif
    // suy yeu (kskill.j zzKS_Weak): the source deals key 84 % less (at most 20)
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_src),zzUS_WEAK_END()) then
        set vl_d=vl_d*(1.-IMinBJ(zzCF_SUY_YEU_TOI_DA(),zzUS_Int(GetHandleId(vl_src),zzUS_WEAK_PCT()))/100.)
    endif
    // bong (KVCT effect_bong, kskill.j status 5): 50% more damage
    if TimerGetElapsed(zzVL_clock)<zzUS_Real(GetHandleId(vl_tgt),zzUS_BONG_END()) then
        set vl_d=vl_d*zzCF_BONG_NHAN()
    endif
    // Tướng có thêm thời gian phản ứng trong giao tranh; sát thương lên quái không đổi.
    // Kỹ năng chịu thêm hệ số riêng vì burst nhiều hit là nguyên nhân chính khiến combat kết thúc tức thì.
    if IsUnitType(vl_tgt,UNIT_TYPE_HERO) then
        set vl_d=vl_d*zzCF_HERO_DMG_NHAN()
        if BlzGetEventDamageType()!=DAMAGE_TYPE_NORMAL then
            set vl_d=vl_d*zzCF_HERO_SKILL_DMG_NHAN()
        endif
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
    if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and zzVL_he[vl_pt]==3 and zzVL_set[vl_pt]>0 and vl_d>0. and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL and not zzVL_inTp and zzVL_dmgDepth<=1 and vl_src!=vl_tgt and GetWidgetLife(vl_src)>.405 and TimerGetElapsed(zzVL_clock)-zzUS_Real(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST())>=zzCF_THO_PHAN_CHAN_HOI() then
        call zzUS_SetReal(GetHandleId(vl_tgt),zzUS_THO_REFLECT_LAST(),TimerGetElapsed(zzVL_clock))
        call zzVL_TpHit(vl_tgt,vl_src,vl_d*zzCF_THO_PHAN_CHAN_MOI_CAP()*zzVL_set[vl_pt])
    endif
    if vl_repl then
        set vl_d=0.
    endif
    call BlzSetEventDamage(vl_d)
    if vl_crit then
        call zzVL_Text(vl_tgt,"|cffff4000"+I2S(R2I(vl_d))+"!|r")
    endif
    // Hiệu ứng trạng thái bộ ngũ hành: chỉ đòn đánh thường của chính tướng, không tính sát thương phụ (độc, phản...)
    // đòn đánh thường HOẶC đòn của kỹ năng (zzVL_skHit); đòn đánh thường đã bị kỹ năng thay thế thì không kích hoạt
    if vl_ps<10 and vl_src==Jx[vl_ps+1] and zzVL_set[vl_ps]>0 and not vl_repl and ((not zzVL_inTp and BlzGetEventDamageType()==DAMAGE_TYPE_NORMAL) or zzVL_skHit) then
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
    local integer vl_r=zzVL_cl[vl_playerId]
    if vl_hero==null or vl_r<1 then
        set vl_hero=null
        return
    endif
    if zzVL_tag[vl_playerId]==null then
        set zzVL_tag[vl_playerId]=CreateTextTag()
        call SetTextTagPermanent(zzVL_tag[vl_playerId],true)
    endif
    // danh hiệu phi phong trên đầu tướng (không báo lên màn hình)
    call SetTextTagText(zzVL_tag[vl_playerId],zzVL_PPTitle(vl_r),.026)
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
    local integer vl_c=zzVL_cl[vl_playerId]
    set zzVL_ct[vl_playerId]=IMaxBJ(0,zzVL_ct[vl_playerId]+vl_n)
    // quan ấn (8 bậc): chức quan trước tên tướng
    loop
        exitwhen vl_r>=zzVL_QAMax() or zzVL_ct[vl_playerId]<zzVL_QAReq(vl_r+1)
        set vl_r=vl_r+1
    endloop
    // phi phong (15 bậc): danh hiệu trên đầu + chỉ số
    loop
        exitwhen vl_c>=zzVL_PPMax() or zzVL_ct[vl_playerId]<zzVL_PPReq(vl_c+1)
        set vl_c=vl_c+1
    endloop
    if vl_r>zzVL_rank[vl_playerId] or vl_c>zzVL_cl[vl_playerId] then
        set zzVL_rank[vl_playerId]=vl_r
        set zzVL_cl[vl_playerId]=vl_c
        // không báo lên màn hình khi thăng cấp (chỉ báo ai hạ ai); xem ở bảng Nhân vật (TAB)
        if vl_hero!=null then
            if zzVL_pn[vl_playerId]==null then
                set zzVL_pn[vl_playerId]=GetHeroProperName(vl_hero)
            endif
            if vl_r>0 then
                call BlzSetHeroProperName(vl_hero,zzVL_QAName(vl_r)+" "+zzVL_pn[vl_playerId])
            endif
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
        exitwhen vl_i>=zzCF_BAG_SLOTS()
        set vl_it=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
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
        exitwhen vl_i>=zzCF_BAG_SLOTS() or vl_n<=0
        set vl_it=zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]
        if vl_it!=null and vl_it!=vl_skip and GetItemTypeId(vl_it)==vl_code then
            set vl_c=GetItemCharges(vl_it)
            if vl_c<1 then
                set vl_c=1
            endif
            set vl_old=vl_n
            set vl_n=zzGS_TakeFrom(vl_it,vl_n)
            if vl_c<=vl_old then
                set zzVL_bag[vl_playerId*zzCF_BAG_SLOTS()+vl_i]=null
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
    local integer vl_gold=LoadInteger(zzVL_ht,'zzGS',3)+LoadInteger(zzVL_ht,'zzGS',5)*IMaxBJ(0,zzGM_Tier(vl_code)-2)
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
// ---- Nhóm GEMDROP: rơi bảo thạch IG<loại><bậc> giống Huyền tinh (tools/config.py mục 13): không mở khóa theo phút,
// mỗi lần giết có tỉ lệ rơi theo loại quái, loại (1..6) và bậc ngẫu nhiên trong khoảng của loại quái đó.
// Phụ thuộc: gameplay_14_gem.j (zzGM_Code). File này phải nối SAU gameplay_14_gem.j.
// Số liệu do tools/kvequip.py ghi vào zzVL_ht (khóa cha 0), vl_kind = 0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss:
//   363 bật (1) / tắt (0), 370+kind bậc thấp nhất, 380+kind bậc cao nhất, 390+kind tỉ lệ %, 365+kind số viên.

// Hàm công khai: rơi bảo thạch theo loại quái tại (x,y). Gọi từ zzDR_DropKind.
function zzGD_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_k=IMinBJ(3,IMaxBJ(0,vl_kind))
    local integer vl_n
    local integer vl_code
    local item vl_it
    if vl_hero==null or LoadInteger(zzVL_ht,0,363)<=0 then
        return
    endif
    if GetRandomInt(1,100)>LoadInteger(zzVL_ht,0,390+vl_k) then
        return
    endif
    set vl_n=IMaxBJ(1,LoadInteger(zzVL_ht,0,365+vl_k))
    loop
        exitwhen vl_n<=0
        set vl_code=zzGM_Code(GetRandomInt(1,6),GetRandomInt(LoadInteger(zzVL_ht,0,370+vl_k),LoadInteger(zzVL_ht,0,380+vl_k)))
        if vl_code!=0 then
            set vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
            call zzDR_TrackItem(vl_it)
            set vl_it=null
        endif
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

// Chấm phẩm chất bằng số dòng và độ cao mỗi dòng so với min/max riêng của chính chỉ số đó.
// Điểm = 20 mỗi dòng + tổng phần trăm roll trong min..max. Dòng min luôn cho 0 điểm roll.
// Ngưỡng: <100 thường, 100..179 tốt, 180..259 tuyệt, >=260 huyền thoại.
function zzDR_Quality takes item vl_it returns integer
    local integer vl_id=GetHandleId(vl_it)
    local integer vl_k=1
    local integer vl_n=0
    local integer vl_value
    local integer vl_min
    local integer vl_max
    local integer vl_roll=0
    local integer vl_score
    loop
        exitwhen vl_k>22
        set vl_value=zzIT_Line(vl_id,vl_k)
        if vl_value>0 then
            set vl_n=vl_n+1
            set vl_min=zzEQ_AffixMin(vl_k)
            set vl_max=zzEQ_AffixMax(vl_k)
            if vl_max>vl_min then
                set vl_roll=vl_roll+(vl_value-vl_min)*100/(vl_max-vl_min)
            else
                set vl_roll=vl_roll+100
            endif
        endif
        set vl_k=vl_k+1
    endloop
    if vl_n<=0 then
        return 1
    endif
    set vl_score=vl_n*20+vl_roll
    if vl_score>=260 then
        return 4
    elseif vl_score>=180 then
        return 3
    elseif vl_score>=100 then
        return 2
    endif
    return 1
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

// Vầng sáng dưới trang bị rơi, màu theo phẩm chất (trắng thường, xanh tốt, tím tuyệt, vàng huyền thoại) để nhìn từ xa
// biết là đồ rơi và đồ xịn. Mỗi 0.5 giây kiểm tra: món đã được nhặt / mất / ẩn thì xóa vầng sáng.
function zzDR_GlowTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local item vl_it=LoadItemHandle(zzVL_ht,vl_id,0)
    // đồ nằm đất quá DROP_EXPIRE_SECONDS không ai nhặt thì tự xóa
    call SaveReal(zzVL_ht,vl_id,2,LoadReal(zzVL_ht,vl_id,2)+.5)
    if vl_it!=null and GetItemTypeId(vl_it)!=0 and not IsItemOwned(vl_it) and LoadReal(zzVL_ht,vl_id,2)>=zzCF_DROP_EXPIRE_SECONDS() then
        call FlushChildHashtable(zzVL_ht,GetHandleId(vl_it))
        call RemoveSavedBoolean(zzVL_ht,GetHandleId(vl_it),900)
        call RemoveItem(vl_it)
        set vl_it=null
    endif
    if vl_it==null or GetItemTypeId(vl_it)==0 or IsItemOwned(vl_it) or not IsItemVisible(vl_it) or GetWidgetLife(vl_it)<=0. then
        if vl_it!=null then
            call RemoveSavedBoolean(zzVL_ht,GetHandleId(vl_it),900)
        endif
        call DestroyEffect(LoadEffectHandle(zzVL_ht,vl_id,1))
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_it=null
endfunction

function zzDR_Glow takes item vl_it returns nothing
    local integer vl_q=zzIT_Get(GetHandleId(vl_it),zzIT_PHAM_CHAT())
    local effect vl_e=AddSpecialEffect(zzCF_DROP_GLOW_MODEL(),GetItemX(vl_it),GetItemY(vl_it))
    local timer vl_t=CreateTimer()
    call SaveBoolean(zzVL_ht,GetHandleId(vl_it),900,true)
    call BlzSetSpecialEffectScale(vl_e,zzCF_DROP_GLOW_SCALE())
    if vl_q==4 then
        call BlzSetSpecialEffectColor(vl_e,255,200,0)
    elseif vl_q==3 then
        call BlzSetSpecialEffectColor(vl_e,190,70,255)
    elseif vl_q==2 then
        call BlzSetSpecialEffectColor(vl_e,60,140,255)
    else
        call BlzSetSpecialEffectColor(vl_e,255,255,255)
    endif
    call SaveItemHandle(zzVL_ht,GetHandleId(vl_t),0,vl_it)
    call SaveEffectHandle(zzVL_ht,GetHandleId(vl_t),1,vl_e)
    call TimerStart(vl_t,.5,true,function zzDR_GlowTick)
    set vl_e=null
    set vl_t=null
endfunction

// Tạo một phôi KVCT +0, lăn chỉ số/phẩm chất ngay khi rơi để màu đã đúng trên mặt đất.
function zzDR_MakeOne takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_code=zzDR_PickCode(vl_hero)
    local item vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
    if vl_it==null then
        return
    endif
    // handle id của món đã xóa được game dùng lại: xóa dữ liệu cũ (số lỗ khảm 3000, đá, cờ 29 đã roll...) để đồ mới sạch, lỗ khảm = 0
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_it))
    // Giữ model/icon của chính món KVCT nhưng thu gọn vật thể trên mặt đất.
    call BlzSetItemRealField(vl_it,ITEM_RF_SCALING_VALUE,zzCF_DROP_ITEM_SCALE())
    // khóa 73: đồ rơi từ quái, cho phép tự mặc / tự bán (giống hệ cũ).
    call zzIT_Set(GetHandleId(vl_it),zzIT_MOI_ROI(),1)
    call zzVL_RollAffix(vl_it)
    call zzVL_TaiPhu(vl_it)
    call zzIT_Set(GetHandleId(vl_it),zzIT_PHAM_CHAT(),zzDR_Quality(vl_it))
    call zzEQ_SetTier(vl_it,0)
    call zzDR_Glow(vl_it)
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
    call SetUnitScale(zzVL_boss,2.5,2.5,2.5)
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
    call SetUnitScale(zzVL_mc,2.5,2.5,2.5)
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
    local location vl_l
    if ModuloInteger(R2I(TimerGetElapsed(zzVL_clock)),60)==0 then
        // handle: id của một location mới - 0x100000 ~ số handle đang sống; tăng đều mỗi phút = rò rỉ (crash hết bộ nhớ 10/10/2026)
        set vl_l=Location(0.,0.)
        call zzVL_Log("-- phut "+I2S(vl_m)+", don vi: "+I2S(zzVL_CountUnits())+", handle: "+I2S(GetHandleId(vl_l)-0x100000))
        call RemoveLocation(vl_l)
        set vl_l=null
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
    if vl_playerId<5 then
        call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,15.,"|cffffcc00Phút "+I2S(vl_m)+"|r - Phe ta: "+I2S(zzVL_teamK[0])+" / "+I2S(zzVL_winKills)+"; phe địch: "+I2S(zzVL_teamK[1])+" / "+I2S(zzVL_winKills)+"|nTuyệt đại cao thủ kế tiếp: phút "+I2S(zzVL_nextBoss)+"|nVõ Lâm Minh Chủ kế tiếp: phút "+I2S(zzVL_nextMc))
    else
        call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,15.,"|cffffcc00Phút "+I2S(vl_m)+"|r - Phe ta: "+I2S(zzVL_teamK[1])+" / "+I2S(zzVL_winKills)+"; phe địch: "+I2S(zzVL_teamK[0])+" / "+I2S(zzVL_winKills)+"|nTuyệt đại cao thủ kế tiếp: phút "+I2S(zzVL_nextBoss)+"|nVõ Lâm Minh Chủ kế tiếp: phút "+I2S(zzVL_nextMc))
    endif
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
    local integer vl_x=(zzCF_KILL_XP_BASE()+zzCF_KILL_XP_PER_CAMP_LEVEL()*vl_lv)/2
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

function zzVL_MainCreepXP takes unit vl_d,integer vl_pk returns nothing
    local integer vl_x
    if LoadInteger(zzVL_ht,GetHandleId(vl_d),9)>0 or GetPlayerId(GetOwningPlayer(vl_d))<10 or IsUnitType(vl_d,UNIT_TYPE_HERO) or IsUnitType(vl_d,UNIT_TYPE_STRUCTURE) or Jx[vl_pk+1]==null or GetHeroLevel(Jx[vl_pk+1])>=200 then
        return
    endif
    set vl_x=zzCF_KILL_XP_BASE()+zzCF_KILL_XP_PER_CAMP_LEVEL()*GetUnitLevel(vl_d)
    call AddHeroXP(Jx[vl_pk+1],vl_x,true)
    call zzVL_Text(Jx[vl_pk+1],"|cff9ad0ff+"+I2S(vl_x)+" kinh nghiệm|r")
endfunction

// ==========================================
// Hàm: zzVL_CheckWin
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_CheckWin takes nothing returns nothing
    local integer vl_i=0
    local integer vl_team=-1
    if zzVL_winKills>0 then
        if zzVL_teamK[0]>=zzVL_winKills then
            set vl_team=0
        elseif zzVL_teamK[1]>=zzVL_winKills then
            set vl_team=1
        endif
    endif
    if vl_team>=0 then
        loop
            exitwhen vl_i>9
            if (vl_i<5 and vl_team==0) or (vl_i>=5 and vl_team==1) then
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
            if GetPlayerId(GetOwningPlayer(vl_k))<5 then
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
        elseif vl_pk<10 and Jx[vl_pk+1]!=null and IsUnitEnemy(vl_d,Player(vl_pk)) then
            if vl_pd>=10 and not IsUnitType(vl_d,UNIT_TYPE_HERO) and not IsUnitType(vl_d,UNIT_TYPE_STRUCTURE) then
                call zzVL_MainCreepXP(vl_d,vl_pk)
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
                    call zzVL_All("|cffff4000Nhất đao đoạt mạng!|r "+zzVL_Name(vl_pk)+" hạ "+GetPlayerName(Player(vl_pd)))
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
                        // Q/W/E bật chuột phải được ưu tiên trọn nhịp đánh; khóa không chặn nội tại, buff hoặc toggle.
                        if zzVL_ActionBusy(vl_playerId) and not zzVL_ActionUtility(vl_ab) then
                            set vl_ok=false
                        // 4: a KVCT toggle (kskill.j zzKS_Toggle), cast only while it is off
                        elseif vl_kind==4 and HaveSavedHandle(zzVL_ht,GetHandleId(vl_hero),vl_ab) then
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
// Kỳ Trân Các: ba lựa chọn phẩm chất, 22 dòng thuộc tính, đá dùng chung icon KVCT.
// Mua món KTRx mở danh sách; chỉ trừ vàng khi chọn thuộc tính và đưa đá vào túi thành công.
function zzKTC_Show takes integer vl_pid,integer vl_page returns nothing
    local integer vl_start=(vl_page-1)*9+1
    local integer vl_end=IMinBJ(22,vl_start+8)
    local integer vl_stat=vl_start
    local button vl_b
    set zzKTC_page[vl_pid]=vl_page
    call DialogClear(zzKTC_dialog[vl_pid])
    call DialogSetMessage(zzKTC_dialog[vl_pid],"Chọn dòng thuộc tính - phẩm chất "+I2S(zzKTC_grade[vl_pid])+" (trang "+I2S(vl_page)+"/3)")
    loop
        exitwhen vl_stat>vl_end
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],GetObjectName(zzGM_Code(100+vl_stat,zzKTC_grade[vl_pid])),0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,vl_stat)
        set vl_stat=vl_stat+1
    endloop
    if vl_page>1 then
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"<< Trước",0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-2)
    endif
    if vl_page<3 then
        set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"Tiếp >>",0)
        call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-1)
    endif
    set vl_b=DialogAddButton(zzKTC_dialog[vl_pid],"Hủy",0)
    call SaveInteger(zzVL_ht,GetHandleId(vl_b),170,-3)
    call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],true)
    set vl_b=null
endfunction

function zzKTC_OnDialog takes nothing returns nothing
    local integer vl_pid=GetPlayerId(GetTriggerPlayer())
    local button vl_b=GetClickedButton()
    local integer vl_choice=LoadInteger(zzVL_ht,GetHandleId(vl_b),170)
    local integer vl_grade=zzKTC_grade[vl_pid]
    local integer vl_price=LoadInteger(zzVL_ht,'zzKT',10+vl_grade)
    local integer vl_type
    local item vl_stone
    local unit vl_hero=Jx[vl_pid+1]
    local string vl_name
    if vl_choice==-1 then
        call zzKTC_Show(vl_pid,IMinBJ(3,zzKTC_page[vl_pid]+1))
    elseif vl_choice==-2 then
        call zzKTC_Show(vl_pid,IMaxBJ(1,zzKTC_page[vl_pid]-1))
    elseif vl_choice>0 and vl_choice<=22 then
        if vl_hero==null or GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)<vl_price then
            call zzVL_Msg(vl_pid,"Không đủ vàng hoặc chưa có tướng để mua đá.")
        else
            set vl_type=zzGM_Code(100+vl_choice,vl_grade)
            set vl_stone=CreateItem(vl_type,GetUnitX(vl_hero),GetUnitY(vl_hero))
            set vl_name=GetItemName(vl_stone)
            if zzVL_BagAdd(vl_pid,vl_stone) then
                call SetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)-vl_price)
                call zzVL_Msg(vl_pid,"Đã mua "+vl_name+" với giá "+I2S(vl_price)+" vàng.")
                if zzVL_bagOpen[vl_pid] then
                    call zzVL_Refresh(vl_pid)
                endif
            else
                call RemoveItem(vl_stone)
                call zzVL_Msg(vl_pid,"Hành trang đã đầy; không trừ vàng.")
            endif
        endif
        call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],false)
    else
        call DialogDisplay(Player(vl_pid),zzKTC_dialog[vl_pid],false)
    endif
    set vl_hero=null
    set vl_stone=null
    set vl_name=null
    set vl_b=null
endfunction

function zzKTC_OnBuy takes nothing returns nothing
    local item vl_item=GetSoldItem()
    local unit vl_shop=GetSellingUnit()
    local unit vl_buyer=GetBuyingUnit()
    local integer vl_pid=GetPlayerId(GetOwningPlayer(vl_buyer))
    local integer vl_type=GetItemTypeId(vl_item)
    local integer vl_grade=0
    local integer vl_price
    if vl_type=='KTR1' then
        set vl_grade=1
    elseif vl_type=='KTR2' then
        set vl_grade=2
    elseif vl_type=='KTR3' then
        set vl_grade=3
    endif
    if vl_pid<10 and vl_grade>0 and GetUnitTypeId(vl_shop)==LoadInteger(zzVL_ht,'zzKT',5) then
        set vl_price=LoadInteger(zzVL_ht,'zzKT',10+vl_grade)
        call RemoveItem(vl_item)
        call SetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(vl_pid),PLAYER_STATE_RESOURCE_GOLD)+vl_price)
        set zzKTC_grade[vl_pid]=vl_grade
        call zzKTC_Show(vl_pid,1)
    endif
    set vl_item=null
    set vl_shop=null
    set vl_buyer=null
endfunction

function zzKTC_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    local integer vl_pid=0
    set zzKTC_dialog[0]=null
    loop
        exitwhen vl_pid>9
        set zzKTC_dialog[vl_pid]=DialogCreate()
        call TriggerRegisterDialogEvent(vl_t,zzKTC_dialog[vl_pid])
        set vl_pid=vl_pid+1
    endloop
    call TriggerAddAction(vl_t,function zzKTC_OnDialog)
    set vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddAction(vl_t,function zzKTC_OnBuy)
    set vl_t=null
endfunction
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
        call DestroyEffect(AddSpecialEffectTarget("VLTK_data\\war3mapImported\\BienThan_tanthuyhoang.mdx",vl_b,"origin"))
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
    // Tần Lăng Hòa Thị Bích: nguyên liệu mua vũ khí Tần Lăng (gameplay_10_shop.j)
    call CreateItem('ITHB',vl_x,vl_y)
    if vl_pk>=0 and vl_pk<=9 then
        call zzDR_DropKind(4,vl_x,vl_y,Jx[vl_pk+1])
        call zzVL_All(zzVL_Name(vl_pk)+" đã hạ |cffffcc07Tần Thủy Hoàng|r! |cffffcc00Tần Lăng Hòa Thị Bích|r và trang bị đã rơi.")
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