# Bảng khóa hashtable `zzVL_ht` (tự sinh từ `tools/jass/gameplay_01_core.j`)

JASS không có class, nên mỗi "lớp" là một nhóm hàm có tiền tố chung; dữ liệu của đối tượng nằm trong hashtable `zzVL_ht`, khóa cha = id của đối tượng, khóa con = "trường". Luôn đọc / ghi qua hàm của lớp, không dùng số trần.

| Lớp | Đối tượng (khóa cha) | Phương thức |
|---|---|---|
| `zzPS` | chỉ số cộng thêm của người chơi (`1000+pid`) | `zzPS_Get / Set / Add(pid, trường, ...)` |
| `zzIT` | một vật phẩm (`GetHandleId(item)`) | `zzIT_Get / Set(h, trường)`; dòng chỉ số k: `zzIT_Line / SetLine / AddLine / ClearLine(h, k)` (khóa 30+k) |
| `zzHT` | loại tướng / môn phái (mã loại tướng) | `zzHT_He(u)` (khóa 99), `zzHT_MainWeapon(u)` (96), `zzHT_CanWear(u, w)` (400+w) |
| `zzSK` | một kỹ năng KVCT (mã ability) | `zzSK_Int / Str / Has(ab, trường)` |
| `zzUS` | trạng thái tạm của một unit (`GetHandleId(unit)`) | `zzUS_Real / SetReal`, `zzUS_Int / SetInt(h, trường)` |
| `zzEQ` | trang bị KVCT (gameplay_09_equip.j) | `zzEQ_Tier / SetTier / Enhance ...` (dựa trên `zzIT`) |

Không đặt tên: các khóa 0..10 trên **timer** (mỗi timer tự mang dữ liệu riêng của hàm tạo ra nó, ý nghĩa khác nhau theo từng hàm; xem chú thích tại hàm đó), và các bảng cấu hình trên khóa cha 0 (ghi bởi `tools/kvequip.py`, xem `tools/config.py`).

| Lớp | Trường | Khóa | Ý nghĩa |
|---|---|---|---|
| zzPS | `zzPS_KHANG_VL()` | 11 | kháng vật lý % |
| zzPS | `zzPS_KHANG_DOC()` | 12 | kháng độc % |
| zzPS | `zzPS_KHANG_THUY()` | 13 | kháng thủy % |
| zzPS | `zzPS_KHANG_HOA()` | 14 | kháng hỏa % |
| zzPS | `zzPS_KHANG_LOI()` | 15 | kháng lôi % (11..15 = 10 + hệ ngũ hành 1..5) |
| zzPS | `zzPS_TOC_XUAT_CHIEU()` | 16 | tốc xuất chiêu % |
| zzPS | `zzPS_STVL_NOI()` | 17 | sát thương nội công (phẳng) |
| zzPS | `zzPS_STVL_NGOAI()` | 18 | sát thương ngoại công (phẳng) |
| zzPS | `zzPS_DANH_TRUNG()` | 19 | điểm đánh trúng |
| zzPS | `zzPS_NE_TRANH()` | 20 | điểm né tránh (dòng trang bị) |
| zzPS | `zzPS_TOC_CHAY()` | 21 | tốc chạy |
| zzPS | `zzPS_CAP_KY_NANG()` | 22 | cấp kỹ năng cộng thêm |
| zzPS | `zzPS_NE_NGOAI_BUFF()` | 25 | né ngoại công từ buff |
| zzPS | `zzPS_NE_NOI_BUFF()` | 26 | né nội công từ buff |
| zzIT | `zzIT_MOI_ROI()` | 73 | 1 = vừa rơi ra, chưa xét tự mặc |
| zzIT | `zzIT_TAI_PHU()` | 74 | 1 = đã gắn dòng "Tài phú" vào mô tả |
| zzIT | `zzIT_DO_CO()` | 75 | trang bị cổ (thêm chỉ số bộ), 0 = không |
| zzIT | `zzIT_BAC()` | 90 | bậc cường hóa +0..+10 (11 = Tần Lăng) |
| zzIT | `zzIT_BAC_DA_GAN()` | 97 | 1 = đã gắn tên / icon theo bậc |
| zzIT | `zzIT_BAO_HIEM()` | 98 | số lần cường hóa thất bại liên tiếp (bảo hiểm) |
| zzSK | `zzSK_KIND()` | 240 | loại chiêu (bảng Kinds ở đầu kskill.j) |
| zzSK | `zzSK_HITS()` | 241 | số đòn / đợt / nhịp |
| zzSK | `zzSK_STATUS()` | 242 | trạng thái gây ra (1 thọ thương 2 định thân 3 choáng 4 chậm 5 bỏng) |
| zzSK | `zzSK_CHANCE()` | 243 | tỉ lệ % gây trạng thái |
| zzSK | `zzSK_STATUS_TIME()` | 244 | thời gian trạng thái (1/10 giây) |
| zzSK | `zzSK_PASSIVE_FX()` | 245 | bit hiệu ứng bị động thêm vào đòn Q W E |
| zzSK | `zzSK_BUFF_TIME()` | 246 | thời gian buff (giây) |
| zzSK | `zzSK_STAT1()` | 247 | chỉ số buff thứ nhất |
| zzSK | `zzSK_STAT2()` | 248 | chỉ số buff thứ hai |
| zzSK | `zzSK_PROC()` | 249 | 1 = tự phát khi đánh thường |
| zzSK | `zzSK_MODEL()` | 250 | model hiệu ứng chính |
| zzSK | `zzSK_ORDER_ON()` | 251 | lệnh bật autocast |
| zzSK | `zzSK_FX()` | 252 | bit hiệu ứng đòn (kéo, đẩy, hút máu...) |
| zzSK | `zzSK_STAT1_BASE()` | 253 | chỉ số 1: giá trị gốc |
| zzSK | `zzSK_STAT1_PER()` | 254 | chỉ số 1: thêm mỗi bậc |
| zzSK | `zzSK_STAT2_BASE()` | 255 | chỉ số 2: giá trị gốc |
| zzSK | `zzSK_STAT2_PER()` | 256 | chỉ số 2: thêm mỗi bậc |
| zzSK | `zzSK_RADIUS()` | 257 | bán kính / tầm |
| zzSK | `zzSK_GAP()` | 258 | giãn cách giữa các đòn (1/100 giây) |
| zzSK | `zzSK_MAX_TARGETS()` | 259 | số địch tối đa mỗi đòn |
| zzSK | `zzSK_CAST_MODEL()` | 280 | model trên tướng lúc tung |
| zzSK | `zzSK_TARGET_MODEL()` | 281 | model trên địch trúng |
| zzSK | `zzSK_CAST_MODEL2()` | 282 | model cast thứ hai |
| zzSK | `zzSK_TARGET_MODEL2()` | 283 | model target thứ hai |
| zzSK | `zzSK_BUFF_MODEL()` | 284 | model buff |
| zzSK | `zzSK_AREA_MODEL()` | 285 | model vùng |
| zzSK | `zzSK_AREA_MODEL2()` | 286 | model vùng thứ hai |
| zzSK | `zzSK_AURA_MODEL()` | 287 | model aura của bị động |
| zzSK | `zzSK_TARGET_GROUND()` | 288 | 1 = lớp target đặt trên đất |
| zzSK | `zzSK_CAST_GROUND()` | 289 | 1 = lớp cast đặt trên đất |
| zzSK | `zzSK_SCALE()` | 290 | cỡ hiệu ứng % (bảng hand "scale") |
| zzSK | `zzSK_MODEL_LOOP()` | 294 | 1 = model tự lặp |
| zzSK | `zzSK_AI_ORDER()` | 2 | lệnh (OrderId) để AI / autocast tung chiêu |
| zzSK | `zzSK_AI_TARGET()` | 3 | kiểu mục tiêu khi AI tung |
| zzSK | `zzSK_WEAK_RADIUS()` | 160 | suy yếu: bán kính vùng |
| zzSK | `zzSK_WEAK_TIME()` | 161 | suy yếu: thời gian |
| zzSK | `zzSK_WEAK_PCT()` | 162 | suy yếu: % giảm sát thương |
| zzSK | `zzSK_WAVE_TIME()` | 164 | thời gian một đợt (wdur) |
| zzSK | `zzSK_ONHURT()` | 165 | bị động khi bị đánh: 1 hồi máu thấp, 2 cộng tầng, 3 suy yếu quanh thân |
| zzSK | `zzSK_PULSE_SEC()` | 166 | giây mỗi nhịp (psec) |
| zzSK | `zzSK_WIDTH()` | 167 | độ rộng đạn / vùng quét |
| zzSK | `zzSK_LOW_CD_PER()` | 168 | máu thấp: giãn cách thêm mỗi bậc |
| zzSK | `zzSK_LOW_PCT_PER()` | 169 | máu thấp: tỉ lệ thêm mỗi bậc |
| zzSK | `zzSK_STACK_PCT()` | 170 | cộng tầng: % mỗi tầng |
| zzSK | `zzSK_STACK_TIME()` | 171 | cộng tầng: thời gian (giây) |
| zzSK | `zzSK_STACK_MAX_PER()` | 172 | cộng tầng: tầng tối đa thêm mỗi bậc |
| zzSK | `zzSK_STACK_MAX()` | 173 | cộng tầng: tầng tối đa gốc |
| zzSK | `zzSK_HIDE_BUFF_PER()` | 174 | buff sau ẩn thân: thêm mỗi bậc (1/10 giây) |
| zzSK | `zzSK_PROC_CHANCE_PER()` | 177 | đòn đặc biệt: tỉ lệ thêm mỗi bậc |
| zzSK | `zzSK_PROC_MUL_PER()` | 178 | đòn đặc biệt: % sát thương thêm mỗi bậc |
| zzSK | `zzSK_PROC_MUL()` | 179 | đòn đặc biệt: % sát thương gốc |
| zzSK | `zzSK_PROC_CHANCE()` | 180 | đòn đặc biệt: tỉ lệ gốc |
| zzSK | `zzSK_SUCK()` | 181 | hút địch vào tâm |
| zzSK | `zzSK_BUFF_HITS()` | 182 | buff hết sau số đòn này |
| zzSK | `zzSK_ALSO_QWE()` | 183 | chiêu cũng tung Q (1) W (2) E (3) của tướng |
| zzSK | `zzSK_DIMM_HITS()` | 184 | miễn sát thương: số đòn |
| zzSK | `zzSK_DIMM_TIME()` | 185 | miễn sát thương: thời gian |
| zzSK | `zzSK_FAN_RANK()` | 186 | quạt đạn: bậc bắt đầu thêm đạn |
| zzSK | `zzSK_STEAL_PCT()` | 187 | hút máu % sát thương |
| zzSK | `zzSK_LOW_AT()` | 189 | ngưỡng máu thấp % |
| zzSK | `zzSK_FAR()` | 194 | điểm xa nhất của vùng |
| zzSK | `zzSK_SELF_BUFF()` | 195 | buff bản thân sau khi tung |
| zzSK | `zzSK_RANGE_PER()` | 196 | tầm lướt thêm mỗi bậc |
| zzSK | `zzSK_CHARGE_PCT_PER()` | 197 | tích tầng: % mỗi tầng theo bậc |
| zzSK | `zzSK_CHARGE_PCT()` | 198 | tích tầng: % mỗi tầng |
| zzSK | `zzSK_HIDE_BUFF()` | 199 | buff sau ẩn thân (1/10 giây) |
| zzSK | `zzSK_STATUS_TIME_PER()` | 200 | thời gian trạng thái thêm mỗi bậc (1/10 giây) |
| zzSK | `zzSK_NO_STUN_CAP()` | 201 | 1 = không giới hạn choáng 2 giây |
| zzSK | `zzSK_PIMM_CHANCE()` | 202 | miễn khống chế: tỉ lệ mỗi bậc |
| zzSK | `zzSK_PIMM_TIME()` | 203 | miễn khống chế: thời gian (1/10 giây) |
| zzSK | `zzSK_FREEZE()` | 204 | máu thấp: đóng băng (1/10 giây) |
| zzSK | `zzSK_FAN_GROW()` | 205 | quạt đạn: thêm đạn theo bậc |
| zzSK | `zzSK_FAN_SPREAD()` | 206 | quạt đạn: góc tỏa |
| zzSK | `zzSK_FAN()` | 207 | quạt đạn: số đạn |
| zzSK | `zzSK_EXTRA_WAVE_CHANCE()` | 208 | bị động: tỉ lệ thêm đợt cho Q W E |
| zzSK | `zzSK_EXTRA_WAVES()` | 209 | bị động: số đợt thêm cho Q W E |
| zzSK | `zzSK_PERIOD_IMM()` | 211 | miễn định kỳ: thời gian |
| zzSK | `zzSK_PERIOD()` | 212 | miễn định kỳ: chu kỳ |
| zzSK | `zzSK_DASH_QWE()` | 214 | lướt xong tung Q W E |
| zzSK | `zzSK_FROM_TARGET()` | 215 | đạn bay từ điểm mục tiêu |
| zzSK | `zzSK_PROC_ON_ATTACK()` | 216 | tỉ lệ bị động tạo buff khi đánh |
| zzSK | `zzSK_LOW_5()` | 217 | máu thấp: tham số 5 |
| zzSK | `zzSK_LOW_FREE()` | 218 | máu thấp: giây miễn khống chế |
| zzSK | `zzSK_LOW_3()` | 219 | máu thấp: tham số 3 |
| zzSK | `zzSK_LOW_CD()` | 220 | máu thấp / bị động: thời gian hồi |
| zzSK | `zzSK_LOW_1()` | 221 | máu thấp: tham số 1 |
| zzSK | `zzSK_BUFF_TIME_PER()` | 222 | thời gian buff thêm mỗi bậc |
| zzSK | `zzSK_SELF_IMM()` | 223 | giây miễn khống chế sau khi tung |
| zzSK | `zzSK_CHANCE2_PER()` | 224 | tỉ lệ trạng thái 2 thêm mỗi bậc |
| zzSK | `zzSK_CHANCE_PER()` | 225 | tỉ lệ trạng thái thêm mỗi bậc |
| zzSK | `zzSK_NO_DAMAGE()` | 228 | 1 = không gây sát thương (lướt) |
| zzSK | `zzSK_LINK_STEAL()` | 231 | bị động: hút máu % mỗi bậc cho đòn liên kết |
| zzSK | `zzSK_MANA_PER_SEC()` | 232 | bật/tắt: nội lực mỗi giây mỗi bậc |
| zzSK | `zzSK_STATUS2()` | 234 | trạng thái thứ hai (các đợt sau) |
| zzSK | `zzSK_CHANCE2()` | 235 | tỉ lệ trạng thái thứ hai |
| zzSK | `zzSK_STATUS2_TIME()` | 236 | thời gian trạng thái thứ hai (1/10 giây) |
| zzSK | `zzSK_LINK()` | 239 | bị động áp vào Q (0) W (1) E (2) hay cả ba (3) |
| zzUS | `zzUS_SLOWED()` | 68 | 1 = đang bị làm chậm |
| zzUS | `zzUS_SLOW_SPEED()` | 69 | tốc chạy gốc lưu lại khi bị làm chậm |
| zzUS | `zzUS_VULN_END()` | 74 | hết bị thương: nhận thêm 15% sát thương (fx 512) |
| zzUS | `zzUS_POISON_CD()` | 75 | hết hồi độc sát KVCT (fx 8) |
| zzUS | `zzUS_HIT_COUNT()` | 76 | số đòn trúng liên tiếp (3 đòn nổ, fx 16384) |
| zzUS | `zzUS_KIM_STUN_CD()` | 76 | hết hồi choáng của hệ Kim |
| zzUS | `zzUS_SILENCE_END()` | 77 | hết thọ thương (khóa kỹ năng KVCT) |
| zzUS | `zzUS_BURN_END()` | 79 | hết thiêu đốt (hồi máu 50%) |
| zzUS | `zzUS_BONG_END()` | 81 | hết bỏng (nhận x1.5 sát thương) |
| zzUS | `zzUS_WEAK_END()` | 83 | hết suy yếu |
| zzUS | `zzUS_WEAK_PCT()` | 84 | % giảm sát thương khi suy yếu |
| zzUS | `zzUS_WEAK_SAVED_CD()` | 85 | tốc đánh gốc lưu lại khi suy yếu |
| zzUS | `zzUS_HIT_FX_CD()` | 86 | hết hồi model trúng đòn (0.4 giây) |
| zzUS | `zzUS_MOC_POISON_CD()` | 87 | hết hồi độc của hệ Mộc (tách khỏi 77) |
| zzUS | `zzUS_TP_REFLECT_LAST()` | 70 | lần cuối phản đòn của trấn phái (giãn 0.3 giây) |
| zzUS | `zzUS_THO_REFLECT_LAST()` | 78 | lần cuối phản chấn của bộ Thổ (giãn 0.3 giây) |
