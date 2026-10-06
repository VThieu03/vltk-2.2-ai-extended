# ĐỐI SOÁT TOÀN DIỆN KỸ NĂNG KVCT vs BỘ MÁY VLTK RPG

## 1. TỔNG QUAN HỆ THỐNG
- **Tổng số môn phái**: 33 môn phái (21 phái VLTK gốc + 12 phái mới từ KVCT).
- **Tổng số kỹ năng**: 400 kỹ năng học theo cấp độ (1 - 200).
- **Kỹ năng đã có cấu hình OVR đặc thù**: 172 kỹ năng (bao gồm 100% các chiêu thức chủ động có code riêng trong KVCT).
- **Kỹ năng nội tại / tâm pháp / mật tịch RPG**: 228 kỹ năng (73 chiêu nhập môn, 52 tâm pháp, 42 mật tịch, 56 cửu âm/cửu dương, 7 hào quang aura, 4 thân pháp).

## 2. BẢNG SO SÁNH CÁC CƠ CHẾ KHÁC BIỆT & GIẢI PHÁP TƯƠNG ĐƯƠNG

| Cơ chế trong KVCT | Trạng thái trong VLTK | Nguyên nhân & Giải pháp chuyển đổi tương đương |
|---|---|---|
| **Hệ thống Độ Luyện** (cày số lần dùng để lên cấp chiêu) | **Đã lược bỏ (Học theo cấp 1-200)** | Cơ chế cày độ luyện làm loãng nhịp độ RPG hành động. VLTK chuyển sang tự động mở khóa theo mốc cấp (1, 6, 15, 25, 38...) và sát thương tự động tăng tiến theo cấp hero + 22 dòng trang bị. |
| **Triệu hồi Dummy Unit phức tạp / Phân thân độc lập** | **Thay bằng Multi-Hit / Area Engine** | Dummy unit liên tục gây leak memory và là nguyên nhân chính làm đơ map (freeze) trong combat lớn của War3. VLTK thay thế bằng hiệu ứng đạn bay đa đợt (2-40 hits), sấm sét nova, đẩy/kéo tức thời (`zzKS_Fx`). |
| **Trigger On-Damage phản đòn thời gian thực** | **Chuyển thành Hệ thống Chỉ Số RPG (`zzVL_af`)** | Thay vì tạo trigger theo dõi nhận đòn riêng cho 400 chiêu, các kỹ năng này được chuyển thành buff trực tiếp vào bảng 22 chỉ số: Kháng ngũ hành, Giảm sát thương %, Bạo kích, Hút máu, Hồi mana (`fx 4096`), Tích tầng sát thương (`fx 8192`). |
| **Bất tử tuyệt đối / Vô địch** | **Điều chỉnh thành Hộ Thuẫn (`kind 9`) / Miễn Khống (`kind 8`)** | Giữ cân bằng game trong chế độ Đấu trường / Liên Đấu / Lôi Đài tránh tình trạng tướng bất tử kéo dài làm vỡ trận. |

## 3. CHI TIẾT ĐỐI SOÁT 33 MÔN PHÁI

> Đang đối chiếu lại từng phái với code gốc KVCT (thứ tự theo `CLASS` trong `tools/kskill_data.py`). Phái có ghi "đã đối chiếu code KVCT" là đã kiểm tra từng chiêu; các phái còn lại vẫn là bảng tự sinh cũ (đoán theo mô tả, cột "Ghi chú" chưa đáng tin).

### Ngũ Độc Đao (NDD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `D:\kvct-dev\work\readable.j` (bảng kỹ năng của phái: `set Kuz[oY]="NDD"` + `SaveInteger(o8,eRS(oY,Ff),slot,...)`; hàm đánh Q/W/E: `JoX`, `JoR`/`Joy`, `Jsq`/`Jsg`; chiêu bấm: `J9u`, `eLM`, `elS`/`elq`, `Jst`), số liệu `AbilityData.slk`.
Bảng kỹ năng lấy từ bảng của KVCT: 13 chiêu, thêm **U Minh Khô Lâu (T, ô 14)** mà trước đây phái này thiếu.

Khác biệt chung (mọi chiêu): sát thương tính theo công thức của map (`zzKS_Hit`: công + chỉ số chính, tăng theo bậc chiêu), không dùng công thức vật công % + độc công + phát huy % của KVCT; bậc chiêu mở theo cấp tướng (bỏ độ luyện). "Độc sát N lần" của KVCT là độc mỗi giây trong N giây; ở map là độc 5 nhịp (`zzKS_Fx` bit 8), mỗi mục tiêu tối đa 1 lần / 5 giây.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Huyết Đao Độc Sát | Q (autocast) | Đánh thường trúng → 1 đạn bay thẳng 500, rộng 120, tối đa 7 mục tiêu; 30% định thân 1 giây; độc 3 giây | Đạn bay xuyên 500, tối đa 7; định thân 30% 1 giây; độc | Gần giống (độc 5 nhịp thay vì 3) |
| Ngũ Độc Đao Pháp | - | Bị động: chính xác, độc công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh (theo thang của map) | Gần giống (không có chính xác / độc công riêng) |
| Vô Hình Cổ | F | Bật / tắt: mỗi giây tốn 12 × bậc nội lực, gây độc lên tối đa 7 kẻ địch trong 700; hết nội lực thì tắt | Bật / tắt (kiểu mới 14): mỗi giây tốn 12 × bậc nội lực, đánh tối đa 7 kẻ địch trong 700; hết nội lực tự tắt; AI không tự tắt | Giống (sát thương mỗi giây = 35% công của map) |
| Bách Độc Xuyên Tâm | R | 1 tia độc bay chậm theo đường cong (~460), tối đa 10 mục tiêu; 25% định thân 1 giây; độc 5 giây; hồi 2 giây | Đạn bay thẳng 460, tối đa 10; định thân 25% 1 giây; độc; hồi 2 giây | Gần giống (bay thẳng, không cong) |
| Vạn Cổ Thực Tâm | - | Q/W/E trúng địch → giảm tất cả kháng (80 + 20/bậc) trong 30 giây | Q/W/E trúng địch → địch nhận thêm 15% sát thương trong 4 giây | Gần giống (map không có kháng riêng từng hệ cho chiêu; thời gian ngắn hơn) |
| Ngũ Độc Kỳ Kinh | - | Bị động: phát huy lực tấn công cơ bản / kỹ năng, tỉ lệ định thân, kháng choáng, độc sát | Bị động: sát thương % | Gần giống (chỉ có phần sát thương) |
| Huyền Âm Trảm | W (autocast) | 2 đợt cách 0,32 giây trên đường thẳng 800, mỗi đợt tối đa 7; đợt 1: 30% thọ thương 1 giây + độc 3 giây; đợt 2: 35% định thân 1 giây | 2 đợt cách 0,32 giây, đạn bay 800, tối đa 7; đợt 1 thọ thương 30% 1 giây + độc; đợt 2 định thân 35% 1 giây | Giống |
| Chu Cáp Thanh Minh | D | Trận tại điểm chọn (≤ 640), 5 nhịp mỗi 2 giây (10 giây), bán kính 350, tối đa 7: kéo 100 về tâm, 80% ngẫu nhiên choáng / tê liệt / hỗn loạn 2 giây, độc 3 giây; hồi 20 giây | Trận tại điểm (kiểu mới 13): 5 nhịp mỗi 2 giây, bán kính 350, tối đa 7, kéo 100 về tâm, choáng 80% 2 giây, độc; hồi 20 giây | Gần giống (tê liệt / hỗn loạn đều làm thành choáng) |
| Hóa Huyết Tiệt Mạch | - | Q và đợt đầu của W/E hút 1% × bậc sát thương thành sinh lực | Như KVCT (gắn vào Q/W/E) | Giống |
| Huyết Đỉnh Công | - | Bị động: sinh lực tối đa %, giảm sát thương nhận; khi bị đánh mà sinh lực < 95%: tăng công, miễn chậm / choáng 10 giây, hồi 25 giây | Bị động: sinh lực tối đa + giảm sát thương nhận | Khác một phần (chưa làm phần tự phát khi bị đánh) |
| U Hồn Phệ Ảnh | E (autocast) | 2 đợt cách 0,25 giây, đạn bay 900 (tới mục tiêu thì lượn rồi quay lại), tối đa 7; đợt 1: 30% thọ thương 1 giây + độc 3 giây; đợt 2: 40% định thân 1 giây | 2 đợt cách 0,25 giây, đạn bay thẳng 900, tối đa 7; đợt 1 thọ thương 30% + độc; đợt 2 định thân 40% | Gần giống (đạn không lượn / quay lại) |
| Thiên Thù Vạn Độc | - | Chí mạng; mỗi lần E trúng: +1 tầng Thất Tâm Cổ lên địch, đủ 3 tầng thì nổ sát thương | Chí mạng; E trúng cùng 1 địch 3 lần thì nổ thêm 1 lần sát thương | Giống (sát thương nổ = sát thương đòn E) |
| U Minh Khô Lâu | T | Bùa chú tại điểm, bán kính 200, tối đa 7: giảm kháng độc (19 + 1%/bậc), độc kéo dài thêm (28 + 2%/bậc), 15 giây; hồi 45 giây | Bùa chú tại điểm (kiểu mới 15), bán kính 200, tối đa 7: địch nhận thêm 15% sát thương trong 15 giây; hồi 45 giây | Gần giống (map không có kháng độc riêng) |

Trước khi sửa: Chu Cáp Thanh Minh là nổ quanh thân (KVCT là trận tại điểm), Vô Hình Cổ là buff 15 giây (KVCT bật / tắt), Huyền Âm Trảm là quét nón; số hit / trạng thái trong bảng OVR không được dùng (lỗi `kskill.py`); Q/W/E tự động chỉ ra 1 đợt; ba bị động Vạn Cổ Thực Tâm / Hóa Huyết Tiệt Mạch / Thiên Thù Vạn Độc không tác động lên Q/W/E như KVCT; thiếu U Minh Khô Lâu.

### Thiên Vương Đao (TVD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TVD"`; Q/W/E: `er4`, `eH3`, `eAg`/`eAM`; chiêu bấm: `eOV`/`eO2`, `JKl`, `JeJ`), `AbilityData.slk`.
Bảng kỹ năng lấy từ bảng của KVCT: 13 chiêu. Trước đây phái chỉ có 8 chiêu mang tên TVD; nay có thêm 5 chiêu KVCT cho dùng chung với Thiên Vương Thương / Chùy: **Đoạn Hồn Thích (R), Kinh Lôi Phá Thiên, Thiên Vương Chiến Ý (D), Thiên Canh Chiến Khí, Thiên Mã Hành Không**.

Khác biệt chung: sát thương theo công thức của map (`zzKS_Hit`); chí mạng / kháng của KVCT là điểm, ở map là % nên chỉ số buff / bị động theo thang của map, trừ chỗ ghi số KVCT.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Kinh Lôi Trảm | Q (autocast) | Đánh thường trúng → chém lan bán kính 130 tại chỗ mục tiêu, tối đa 7; 30% thọ thương 1 giây | Đánh lan (kiểu mới 16) bán kính 130 tại mục tiêu, tối đa 7; thọ thương (khóa chiêu) 30% 1 giây | Giống |
| Thiên Vương Đao Pháp | - | Bị động: chính xác, vật công %, chí mạng; tốc đánh tối đa ngay từ đầu | Bị động: sát thương % + chí mạng | Gần giống (không có chính xác; không có tốc đánh tối đa) |
| Đoạn Hồn Thích | R | Lướt ≤ 700, **không gây sát thương**; quanh điểm cuối (200, tối đa 7): (30 + 6/bậc)% định thân 3 giây và (30 + 5/bậc)% thọ thương 2 giây; sau đó 2 giây miễn trạng thái; hồi 6 giây | Như KVCT (lướt không sát thương, 2 trạng thái tăng theo bậc, 2 giây miễn khống chế) | Giống |
| Kinh Lôi Phá Thiên | - | Bị động: sinh lực tối đa; sinh lực còn 40% thì 45% kích hoạt: miễn sát thương + miễn trạng thái 8 giây, giãn cách 80 giây | Bị động: sinh lực; dưới 40%: 45% mỗi giây kích hoạt miễn sát thương + miễn khống chế 8 giây, giãn cách 80 giây | Gần giống (KVCT tung khi bị đánh, map kiểm tra mỗi giây) |
| Thiên Vương Chiến Ý | D | Tướng phe ta trong 1000 (đồng đội 60%): vật công +70 + 30/bậc, chí mạng, tỉ lệ thọ thương; 300 giây | Buff phe ta 1000 (đồng đội 60%): vật công +70 + 30/bậc, chí mạng; 300 giây | Gần giống (không có tỉ lệ thọ thương) |
| Thiên Canh Chiến Khí | - | Bị động: phát huy lực tấn công, hồi phục, kháng định thân | Bị động: sát thương % | Gần giống |
| Phá Thiên Trảm | W (autocast) | 2 nhát cách 0,25 giây, chém lan 120 tại chỗ mục tiêu, tối đa 7; 35% thọ thương 1 giây | 2 nhát cách 0,25 giây, đánh lan 120 tại mục tiêu, tối đa 7; thọ thương 35% 1 giây | Giống |
| Tĩnh Tâm Quyết | - | Bị động: sinh khí, kháng tất cả, giảm thời gian bị khống chế | Bị động: giảm sát thương nhận | Gần giống (không giảm thời gian khống chế) |
| Phi Tinh Trảm Thích | - | Khi tấn công, 80%: chí mạng + phát huy lực tấn công 20 giây, giãn cách 40 giây | Như KVCT: đánh thường 80% → buff chí mạng + sát thương 20 giây, giãn cách 40 giây | Giống (không có "bỏ qua né tránh") |
| Tung Hoành Bát Hoang | F | (8 + bậc) giây miễn mọi trạng thái, chí mạng + sát thương chí mạng; hồi 40 giây | (8 + bậc) giây miễn khống chế + chí mạng; hồi 40 giây | Gần giống (không có sát thương chí mạng) |
| Hào Hùng Trảm | E (autocast) | 3 luồng đao cách 1/6 giây, bay 450 tiếp từ chỗ mục tiêu (rộng 150), mỗi luồng tối đa 7; 40% thọ thương 1 giây | 3 luồng cách 0,17 giây, bay 450 từ chỗ mục tiêu (rộng 120), tối đa 7; thọ thương 40% | Giống |
| Bát Phong Trảm | - | Bị động: sinh lực tối đa; Hào Hùng Trảm 50% phóng thêm 2 luồng đao (sát thương 35 + 5%/bậc) | Bị động: sinh lực; E 50% thêm 2 luồng | Gần giống (2 luồng thêm gây đủ sát thương) |
| Thiên Mã Hành Không | - | Bị động: chí mạng tối thiểu / tối đa, sát thương lên hệ Mộc, sinh khí | Bị động: chí mạng | Gần giống |

Trước khi sửa: Kinh Lôi Trảm / Phá Thiên Trảm là đánh 1 mục tiêu / quét nón (KVCT là chém lan tại mục tiêu), Hào Hùng Trảm là đạn bay từ tướng 1 đợt; thiếu 5 chiêu dùng chung; OVR gán sai Kinh Lôi Phá Thiên là buff, Thiên Canh Chiến Khí là nổ 3 hit (cả hai là bị động); Tung Hoành Bát Hoang không cộng chí mạng (kiểu 8 không gọi buff).

### Võ Đang Kiếm (VDK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="VDK"`; Q/W/E: `ei5`, `eZK`/`eZE`, `J9A`/`J9X`; chiêu bấm: `JfE`, `Jx3`/`JxK`/`JkQ`, `eN8`/`eNR`, `JeR`/`Jey`; Thái Nhất Chân Khí: chu kỳ `6.6 - 0.2 × bậc` giây), `AbilityData.slk`.
Bảng kỹ năng theo KVCT: 13 chiêu (trước đây 12, nay có thêm **Tọa Vọng Vô Ngã (D)** dùng chung với Võ Đang Khí).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tam Hoàn Sáo Nguyệt | Q (autocast) | 3 nhát cách 0,24 giây, chém lan 100 tại chỗ mục tiêu; 30% choáng 0,5 giây | 3 nhát cách 0,24 giây, đánh lan 100 tại mục tiêu; choáng 30% 0,5 giây | Giống |
| Võ Đang Kiếm Pháp | - | Bị động: chính xác, lôi công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Tọa Vọng Vô Ngã | D | 300 giây: khi nội lực > 15%, nội lực gánh (18 + 3/bậc)% sát thương nhận; kháng chậm | Buff 300 giây: giảm (18 + 3/bậc)% sát thương nhận | Gần giống (không trừ nội lực, không có kháng chậm) |
| Lưu Tinh Cản Nguyệt | R | Lướt ≤ 800, bản thân không gây sát thương; tới nơi tự thi triển Q, W, E lên kẻ địch quanh điểm cuối (200); sau đó miễn thọ thương / chậm / choáng, tốc đánh +40 | Lướt ≤ 800 không sát thương; tới nơi tung Q, W, E (bậc hiện có) lên từng kẻ địch quanh 200 (tối đa 7); 2 giây miễn khống chế | Gần giống (không có tốc đánh +40) |
| Thất Tinh Quyết | - | Vòng sáng: né tránh, chuyển sát thương thành sinh lực và nội lực, tốc chạy | Bị động: hút sinh lực + hút nội lực | Gần giống (không có né tránh, tốc chạy) |
| Kiếm Khí Tung Hoành | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương % | Gần giống |
| Nhân Kiếm Hợp Nhất | W (autocast) | 3 đạo kiếm khí cách 0,2 giây, dài 220 (rộng 100), mỗi đạo tối đa 7; 35% choáng 0,5 giây; 25% sát thương ×1,3 | 3 đạo cách 0,2 giây, dài 220, tối đa 7; choáng 35% 0,5 giây | Gần giống (không có 25% ×1,3) |
| Lưỡng Nghi Kiếm Pháp | F | 12 giây: mỗi 0,3 giây 2 đạo kiếm khí vào 2 kẻ địch ngẫu nhiên trong 800; 50% choáng 0,5 giây; né tránh +50%; hồi 30 giây | 40 nhịp × 0,3 giây (12 giây): mỗi nhịp đánh 2 kẻ địch ngẫu nhiên trong 800 (kiểu mới 17); choáng 50% 0,5 giây; hồi 30 giây | Gần giống (đánh thẳng vào địch, không phải đạn bay; không có né tránh +50%) |
| Thái Nhất Chân Khí | - | Bị động: nội lực tối đa +30%, né tránh, tốc đánh; mỗi (6,6 − 0,2 × bậc) giây: 1 giây miễn sát thương + miễn trạng thái | Bị động: tốc đánh; mỗi (6,6 − 0,2 × bậc) giây: 1 giây miễn sát thương + miễn khống chế | Giống (thiếu nội lực / né tránh) |
| Mê Tung Huyễn Ảnh | - | Né tránh tối đa, né đòn tầm xa; mỗi lần bị đánh +1 tầng (tối đa 16, 5 giây): phát huy lực tấn công, né tránh, kháng | Bị động: sát thương % | Khác (chưa làm cộng tầng khi bị đánh) |
| Vô Thượng Kiếm Đạo | E (autocast) | 3 đạo kiếm khí cách 0,2 giây, dài 390 (rộng 120), tối đa 7; 40% choáng 0,5 giây | 3 đạo cách 0,2 giây, dài 390, tối đa 7; choáng 40% 0,5 giây | Giống |
| Thái Cực Kiếm Pháp | - | Giảm sát thương ngũ hành nhận; E 40%: Kiếm Phi Kinh Thiên, 6 đạo (sát thương 58 + 2%/bậc), giãn cách 1,5 giây | Bị động: giảm sát thương nhận; E 40%: 6 đạo | Gần giống (6 đạo gây đủ sát thương; không có giãn cách 1,5 giây) |
| Tử Tiêu Hoành Vân | T | 20 giây: mỗi giây kẻ địch trong 800 (tối đa 7): tốc chạy −15% (cộng dồn), kháng lôi giảm, kéo dài 24 giây; hồi 60 giây | Vùng quanh thân 20 nhịp × 1 giây (kiểu mới 18), không sát thương, tối đa 7: làm chậm 24 giây + nhận thêm 15% sát thương 24 giây | Gần giống (chậm không cộng dồn; giảm kháng = nhận thêm sát thương) |

Trước khi sửa: Tam Hoàn Sáo Nguyệt là đánh 1 mục tiêu, Nhân Kiếm / Vô Thượng Kiếm là đánh mục tiêu / quét nón 1 đợt; Lưu Tinh Cản Nguyệt là lướt gây sát thương; Lưỡng Nghi Kiếm Pháp là nổ quanh thân 40 lần; Tử Tiêu Hoành Vân là nổ quanh thân 4 lần; thiếu Tọa Vọng Vô Ngã.

### Thúy Yên Đao (TYD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TYD"`; Q/W/E: `JxC`/`Jxx`, `Ja0`/`JaE`, `Ja4`/`Ja9`/`Jae`; chiêu bấm: `ebl`/`ebd`/`ebU`, `Je7`/`Jev`, `e_U`/`e_O`; bị động: `eBV`/`eBG` Đạp Tuyết Vô Ngấn), `AbilityData.slk`.
Bảng kỹ năng theo KVCT: 13 chiêu (trước 11; thêm **Tuyết Ảnh** và **Hộ Thể Hàn Băng** dùng chung với Thúy Yên Kiếm).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map. Các phái đã đối chiếu không còn giới hạn choáng 2 giây (dùng đúng thời gian KVCT).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Mục Dã Lưu Tinh | Q (autocast) | 3 đạo đao xòe quạt (−20°, 0, +20°), bay 500 (rộng 90), mỗi đạo tối đa 4; 30% làm chậm 2 giây | 3 đạn bay xòe 20°, 500, tối đa 4; chậm 30% 2 giây | Giống |
| Thúy Yên Đao Pháp | - | Bị động: chính xác, băng công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Tuyết Ảnh | - | Bị động: tốc độ di chuyển, kháng hỏa, giảm thời gian bỏng | Bị động: tốc chạy | Gần giống |
| Ngự Tuyết Ẩn | R | Ẩn thân 30 giây (hồi 32); đòn Q/W/E tiếp theo phá ẩn và kích hoạt Lưu Phong Hồi Tuyết (2,8 + 0,1 × bậc giây): tốc đánh +30 + 5 × bậc, phát huy lực tấn công +20 + 10 × bậc % | Ẩn thân thật 30 giây (kiểu mới 19); đòn đánh tiếp theo phá ẩn và cho buff 3 giây: tốc đánh +30 + 5 × bậc %, sát thương +20 + 10 × bậc % | Giống (thời gian buff cố định 3 giây) |
| Hộ Thể Hàn Băng | - | Bị động: sinh lực; khi sinh lực < 40% bị đánh: đóng băng mọi kẻ địch xung quanh 3,5 giây, tăng kháng 5 giây, giãn cách 30 giây | Bị động: sinh lực; sinh lực < 40%: đóng băng (choáng) mọi kẻ địch trong 400 trong 3,5 giây, giãn cách 30 giây | Gần giống (không tăng kháng; kiểm tra mỗi giây) |
| Băng Cơ Ngọc Cốt | - | Bị động: phát huy lực tấn công, tỉ lệ làm chậm, kháng bỏng | Bị động: sát thương % | Gần giống |
| Băng Tung Vô Ảnh | W (autocast) | 3 đạo xòe quạt (4 đạo từ bậc 3, 5 đạo từ bậc 5), bay 500 (rộng 90), mỗi đạo tối đa 3; 35% làm chậm 2 giây | Như KVCT: 3 / 4 / 5 đạn xòe 13° theo bậc, 500, tối đa 3; chậm 35% 2 giây | Giống |
| Đạp Tuyết Vô Ngấn | - | Khi đánh Q/W/E, (25 + 5 × bậc)%: miễn thọ thương / chậm / định thân / tê liệt / đẩy / kéo trong (4,1 + 0,1 × bậc) giây, giãn cách 15 giây | Khi đánh, (25 + 5 × bậc)%: miễn khống chế (4,1 + 0,1 × bậc) giây, giãn cách 15 giây | Giống |
| Hàn Nguyệt Yên Tỏa | - | Bị động: tốc đánh, chí mạng, sát thương chí mạng, phát huy | Bị động: tốc đánh + chí mạng | Gần giống |
| Tương Tư | D | Bật / tắt; khi bật mỗi 2 giây +1 tầng (tối đa 20), mỗi tầng +(10 + bậc)% phát huy lực tấn công; Q/W/E dùng hết tầng; tăng kháng thời gian trạng thái | Bật / tắt (kiểu mới 20): mỗi 2 giây +1 tầng (tối đa 20), mỗi tầng +(10 + bậc)% sát thương chiêu; Q/W/E kế tiếp dùng hết tầng | Gần giống (tầng chỉ tăng đợt đầu của chiêu; không có kháng thời gian trạng thái) |
| Băng Tước Việt Chi | E (autocast) | 1 đạo đao bay 600, chạm kẻ địch đầu tiên thì tách 5 luồng xòe 15° bay 600 (rộng 120), mỗi luồng tối đa 7; 40% làm chậm 2 giây | Tại chỗ mục tiêu tách 5 đạn xòe 15°, bay 600, tối đa 7; chậm 40% 2 giây | Gần giống (không có đạo bay đầu tiên) |
| Băng Tâm Thiến Ảnh | - | Bị động: sát thương chí mạng; E tăng sát thương, trúng địch cộng tầng sát thương chí mạng | Bị động: chí mạng | Khác một phần (chưa làm phần cho E) |
| Dạ Lai Tây Phong | F | Đóng băng mọi kẻ địch trong 400 (tối đa 10) trong (2,4 + 0,3 × bậc) giây, không sát thương; hồi 45 giây | Nổ quanh thân 400 không sát thương, tối đa 10: choáng 100% (2,4 + 0,3 × bậc) giây; hồi 45 giây | Giống |

Trước khi sửa: Q/W/E là 1 đạn bay xuyên; Ngự Tuyết Ẩn chỉ là buff (không ẩn thân, trạng thái 5 không có tác dụng); Tương Tư là buff sát thương 10 giây; Dạ Lai Tây Phong là nổ 4 lần làm chậm; thiếu Tuyết Ảnh và Hộ Thể Hàn Băng.

### Đường Môn Phi Tiêu (DMPT) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DMPT"`; Q/W/E: `JCf`/`JC3`, `JDP`/`JD7`, `Jai`/`JaQ`; chiêu bấm: `e1U`/`e1O`, `e1T`/`e1z`, `eLG`, `JKg`/`JKA`), `AbilityData.slk`.
Bảng kỹ năng theo KVCT: 13 chiêu (trước 6; thêm 6 chiêu dùng chung với Đường Môn Tụ Tiễn / Phi Đao: **Mê Ảnh Tung (F), Tôi Độc Thuật, Mãn Thiên Hoa Vũ (R), Tâm Nhãn, Hàm Sa Xạ Ảnh, Ảnh Tung Trận (D)**).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map; phi tiêu KVCT bay đi rồi quay về (mỗi địch trúng 1 lần), ở map chỉ bay đi.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tán Hoa Tiêu | Q (autocast) | 5 phi tiêu xòe 12°, bay 500 rồi quay về (rộng 110), mỗi tiêu tối đa 4; 30% định thân 1 giây; độc 1 lần | 5 đạn xòe 12°, 500, tối đa 4; định thân 30% 1 giây; độc | Gần giống (không quay về) |
| Đường Môn Ám Khí | - | Bị động: chính xác, độc công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Mê Ảnh Tung | F | Lướt 300 + 40 × bậc, không sát thương; sau đó Xuất Kỳ Bất Ý 5 giây: phát huy lực tấn công +(12 + 3 × bậc)%; hồi 10 giây | Lướt 300 + 40 × bậc không sát thương; buff 5 giây sát thương +(12 + 3 × bậc)% | Giống |
| Tôi Độc Thuật | - | Vòng sáng: vật công, độc công %, sát thương chí mạng | Bị động: sát thương % + chí mạng | Gần giống |
| Mãn Thiên Hoa Vũ | R | Tại điểm chọn (≤ 740) 3 nhịp mỗi 1 giây, bán kính 300, tối đa 7: 50% định thân 1 giây, độc 2 lần; hồi 6 giây | Trận tại điểm (≤ 740) 3 nhịp mỗi 1 giây, 300, tối đa 7; định thân 50% 1 giây; độc | Giống |
| Tâm Nhãn | - | Bị động: phát huy lực tấn công, tỉ lệ định thân, kháng choáng | Bị động: sát thương % | Gần giống |
| Cửu Cung Phi Tinh | W (autocast) | 5 kim tiền tiêu (1 thẳng, rồi 2 + 2 lượn cong cách 0,16 giây), bay 800 rồi quay về (rộng 80), tối đa 3; 35% định thân 1 giây; độc | 5 đạn xòe 10° cùng lúc, 800, tối đa 3; định thân 35% 1 giây; độc | Gần giống (không lượn cong / quay về) |
| Hàm Sa Xạ Ảnh | - | Bị động: tốc đánh, chí mạng, độc sát | Bị động: tốc đánh + chí mạng | Gần giống |
| Mê Hồn Trận | - | Khi bị đánh: kẻ địch xung quanh −20% tốc đánh, −20% sát thương, giảm kháng chí mạng 6 giây, giãn cách 20 giây | Bị động: giảm sát thương nhận | Khác (chưa làm phần phát động khi bị đánh) |
| Ảnh Tung Trận | D | Trận 16 giây (bán kính 500): đứng trong trận mỗi 2 giây được (27 + 3 × bậc)% bỏ qua sát thương + miễn khống chế; Mê Ảnh Tung hồi còn 0,2 giây; hồi 60 giây | 16 giây miễn khống chế + giảm (27 + 3 × bậc)% sát thương nhận | Gần giống (không cần đứng trong trận; không giảm hồi Mê Ảnh Tung) |
| Càn Khôn Nhất Trịch | E (autocast) | 5 phi tiêu (±8°, ±16°), bay 800 (rộng 100), mỗi tiêu tối đa 3; 40% định thân 1 giây; độc | 5 đạn xòe 8°, 800, tối đa 3; định thân 40% 1 giây; độc | Giống |
| Truy Hồn Đoạt Mệnh | - | Bị động: chí mạng, sát thương chí mạng, né tránh; mỗi phi tiêu của E 30%: sát thương ×(1,18 + 0,03 × bậc) | Bị động: chí mạng; mỗi đạn của E 30%: thêm 25% sát thương | Gần giống (tỉ lệ cố định 25%) |
| Thiết Tỏa Hoành Giang | T | Kẻ địch trong 650 (tối đa 10): kháng vật công −(20 + bậc)%, tốc chạy / tốc đánh −99% trong 9 giây; không sát thương; hồi 30 giây | Nổ quanh thân 650 không sát thương, tối đa 10: định thân 9 giây + nhận thêm 15% sát thương 9 giây | Gần giống (không giảm tốc đánh) |

Trước khi sửa: thiếu 6 chiêu dùng chung; Q/E là 1 đạn bay, W là nổ quanh thân 9 lần; Mê Hồn Trận (bị động) bị làm thành nổ 3 lần; Thiết Tỏa Hoành Giang là đánh 1 mục tiêu 3 lần.

### Thiếu Lâm Quyền (TLQ) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TLQ"`; Q/W/E: `etn`, `eSG`/`eSm`, `e_z`/`e_w`; chiêu bấm: `eiz`/`eiP`, `elV`/`elG`, `ery`, `JKG`), `AbilityData.slk`.
Bảng kỹ năng theo KVCT: 13 chiêu (trước 10; thêm **Dịch Cân Kinh, Bồ Đề Tâm Pháp (D), Như Lai Thiên Diệp** dùng chung với Thiếu Lâm Đao / Bổng).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map. Mới: chỉ số **kháng thời gian trạng thái** (`zzKS_af` 14) — rút ngắn thọ thương / định thân / choáng / chậm nhận vào (tối đa 80%).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Long Trảo Hổ Trảo | Q (autocast) | 2 đòn cách 0,2 giây, đánh lan 120 tại chỗ mục tiêu, tối đa 7; 30% thọ thương 0,5 giây | 2 đòn cách 0,2 giây, đánh lan 120 tại mục tiêu, tối đa 7; thọ thương 30% 0,5 giây | Giống |
| Thiếu Lâm Quyền Pháp | - | Bị động: vật công %, chí mạng, tốc đánh | Bị động: sát thương % + chí mạng | Gần giống |
| Dịch Cân Kinh | - | Bị động: sinh lực tối đa % | Bị động: sinh lực | Giống |
| Sư Tử Hống | R | Kẻ địch trong 600 (tối đa 10): sát thương, (36 + 4 × bậc)% thọ thương 3 giây và (36 + 4 × bậc)% định thân 3 giây; hồi 12 giây | Nổ quanh thân 600, tối đa 10; thọ thương + định thân (36 + 4 × bậc)% 3 giây | Giống |
| Bồ Đề Tâm Pháp | D | 300 giây: kháng thời gian thọ thương / định thân / chậm / choáng +(17 + 3 × bậc)%, kháng độc | Buff 300 giây: kháng thời gian trạng thái +(17 + 3 × bậc)% | Giống (không có kháng độc) |
| Như Lai Thiên Diệp | - | Bị động: phát huy lực tấn công, tỉ lệ thọ thương, kháng định thân | Bị động: sát thương % | Gần giống |
| Kim Cương Phục Ma | W (autocast) | 2 đòn (giây 0 và 0,625), đánh lan 250 tại chỗ mục tiêu, tối đa 7; 35% thọ thương 0,5 giây | 2 đòn cách 0,63 giây, đánh lan 250, tối đa 7; thọ thương 35% 0,5 giây | Giống |
| La Hán Kim Thân | F | 30 giây: tốc đánh +(17 + 3 × bậc), phát huy lực tấn công +(10 + 10 × bậc)%; hồi 60 giây | Buff 30 giây: tốc đánh +(17 + 3 × bậc)%, sát thương +(10 + 10 × bậc)% | Giống |
| Đạt Ma Võ Kinh | - | Bị động: vật công nội, sát thương chí mạng, tốc đánh | Bị động: sát thương % + tốc đánh | Gần giống |
| Hỗn Nguyên Nhất Khí | - | Bị động: hóa giải % sát thương nhận (tối đa 36% sinh lực), tỉ lệ bỏ qua trạng thái | Bị động: giảm sát thương nhận + kháng thời gian trạng thái | Gần giống |
| Đại Lực Kim Cang Chưởng | E (autocast) | 3 đạo chưởng cách 1/6 giây, bay 900 (rộng 150), tối đa 7; 40% thọ thương 1 giây | 3 đạo cách 0,17 giây, 900, tối đa 7; thọ thương 40% 1 giây | Giống |
| Vô Tướng Thần Công | - | Bị động: sinh lực; E 40% phát động Như Lai Chưởng (sát thương ×(1,27 + 0,03 × bậc)) | Bị động: sinh lực; E 30% thêm 25% sát thương | Gần giống (tỉ lệ / mức tăng chung của map) |
| Thiên Thủ Như Lai Ấn | T | 60 giây: vật công +(4,55 + 0,65 × bậc)%, sát thương lên hệ Mộc, miễn thọ thương / chậm / bất động; hồi 180 giây | 60 giây miễn khống chế + sát thương +(5 + bậc)%; hồi 180 giây | Gần giống (không có sát thương lên hệ Mộc) |

Trước khi sửa: Q/W là đánh 1 mục tiêu / quét nón, Sư Tử Hống là nổ 3 lần choáng 2 giây (KVCT: 1 lần, thọ thương + định thân 3 giây), La Hán Kim Thân 15 giây, Thiên Thủ Như Lai Ấn 20 giây; Bồ Đề Tâm Pháp là buff phòng thủ; thiếu 3 chiêu dùng chung.

### Thiên Nhẫn Đao (TND) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TND"`; Q/W/E: `JDX`/`JD5`, `J0M`/`J0X`, `JhU`/`JhO`; chiêu bấm: `egJ`/`eg9`, `Js3`/`Js0`, `eZG`/`eZm`, `e1C`/`e1o`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

**Bỏng** trong KVCT (`effect_bong`, buff B008) không phải độc mỗi giây: kẻ địch bị bỏng **nhận thêm 50% sát thương** đòn đánh / chiêu. Map nay làm đúng như vậy (trạng thái 5, `gameplay_04_combat.j`). Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Đạn Chỉ Liệt Diệm | Q (autocast) | Đốm lửa tại chỗ mục tiêu, đốt 3 lần cách 0,95 giây, bán kính 120, tối đa 7; 30% bỏng 2 giây | Trận lửa tại mục tiêu 3 nhịp cách 0,95 giây, 120, tối đa 7; bỏng 30% 2 giây | Giống |
| Thiên Nhẫn Đao Pháp | - | Bị động: hỏa công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Hỏa Liên Phần Hoa | D | Hỏa trận tại điểm (≤ 740) 8 giây, mỗi 2 giây trong bán kính 270 + 30 × bậc (tối đa 7): hút kẻ địch cách tâm > 100 vào giữa, 100% bỏng 3 giây; không sát thương; hồi 15 giây | Trận tại điểm 4 nhịp × 2 giây, bán kính 270 + 30 × bậc, tối đa 7: kéo 100 về tâm, bỏng 100% 3 giây, không sát thương | Giống |
| Thôi Sơn Điền Hải | R | Hàng rào lửa (nhiều cột, số cột theo bậc mật tịch) tại điểm (≤ 600), đốt mỗi 0,5 giây trong 9 giây, tối đa 7; 35% bỏng 1 giây; hồi 3 giây | Trận tại điểm (≤ 600) 18 nhịp × 0,5 giây, bán kính 250, tối đa 7; bỏng 35% 1 giây | Gần giống (vùng tròn thay cho hàng rào) |
| Nhiếp Hồn Loạn Tâm | F | Bùa chú tại điểm, bán kính 300 (tối đa 7): (36 + 4 × bậc)% tê liệt 4 giây, tốc chạy −25% trong 20 giây; hồi 30 giây | Bùa chú tại điểm 300, tối đa 7: choáng (36 + 4 × bậc)% 4 giây + làm chậm 20 giây | Gần giống (tê liệt = choáng; chậm 40% thay vì 25%) |
| Xí Không Ma Diệm | - | Bị động: phát huy lực tấn công, tỉ lệ bỏng, kháng thọ thương | Bị động: sát thương % | Gần giống |
| Thiên Ngoại Lưu Tinh | W (autocast) | Cầu lửa rơi xuống mục tiêu (220) rồi mặt đất cháy (240), tối đa 7; 35% bỏng 2 giây | Trận lửa tại mục tiêu 3 nhịp cách 0,4 giây, 230, tối đa 7; bỏng 35% 2 giây | Giống |
| Thúc Phọc Chú | - | Bị động: kháng phản đòn, hỏa công; sinh lực < 95% khi bị đánh: miễn thọ thương / định thân / choáng + tốc chạy 10 giây, giãn cách 20 giây | Bị động: sát thương %; sinh lực < 95%: 10 giây miễn khống chế, giãn cách 20 giây | Gần giống (không có tốc chạy) |
| Nghịch Chuyển Tâm Kinh | - | W/E trúng địch: địch nhận thêm sát thương ngũ hành 10 giây | Q/W/E trúng địch: địch nhận thêm 15% sát thương 4 giây | Gần giống |
| Ma Đao Thôn Thần | T | Bật / tắt; mỗi 5 giây tự phóng 5 ma đao (0, ±22°, ±44°) bay 600 về phía trước; hút 5% sát thương thành sinh lực | Bật / tắt (kiểu mới 21): mỗi 5 giây phóng 5 đạn xòe 22° về kẻ địch gần nhất trong 600; hút 5% | Giống |
| Tật Hỏa Liêu Nguyên | E (autocast) | Hỏa Diệm Đao tại mục tiêu: 2 đòn cách 0,4 giây bán kính 250, tối đa 7, 40% bỏng 2 giây; sau đó đốt mỗi giây 4 giây | Trận tại mục tiêu 2 nhịp cách 0,4 giây, 250, tối đa 7; bỏng 40% 2 giây; độc / đốt 5 nhịp | Giống |
| Ma Diệm Thất Sát | - | Bị động: hỏa công, chí mạng; E tăng sát thương (17 + 3 × bậc)% | Bị động: chí mạng; E 30% thêm 25% sát thương | Gần giống |
| Huyền Minh Hấp Tinh | - | E: 18% phá (2,1 + 0,1 × bậc)% sinh lực hiện tại của thủ lĩnh, 21% phá (13 + bậc)% sinh lực hiện tại quái thường; không tác dụng lên người chơi | E: 21% phá 15% sinh lực hiện tại của mục tiêu không phải tướng | Gần giống (không phân biệt thủ lĩnh) |

Trước khi sửa: Q/W/E là quét nón / nổ quanh thân (KVCT là lửa tại chỗ mục tiêu), "bỏng" là độc mỗi giây; Thôi Sơn Điền Hải là lướt (KVCT là hàng rào lửa); Ma Đao Thôn Thần là 1 lần phóng 5 hit (KVCT là bật / tắt tự phóng); Nhiếp Hồn Loạn Tâm là đánh 1 mục tiêu.

### Cái Bang Chưởng (CBC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Hàng Long Hữu Hối | Q | đạn bay xuyên | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Cái Bang Chưởng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hóa Hiểm Vi Di | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn | Đạt chuẩn |
| Thời Thừa Lục Long | R | buff bản thân | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Túy Điệp Cuồng Vũ | - | đánh mục tiêu | Khuôn chuẩn | - | Đạt chuẩn |
| Tiềm Long Tại Uyên | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Phi Long Tại Thiên | W | đánh mục tiêu | Khuôn chuẩn | độc / bỏng mỗi giây, 4 đòn | Đạt chuẩn |
| Trảo Long Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | phát động khi máu dưới 40% | Đạt chuẩn |
| Thần Long Bài Vĩ | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bá Vương Tá Giáp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Long Du Thiên Địa | E | đánh mục tiêu | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Giáng Long Chưởng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Triệt Y Thập Bát Điệt | D | buff bản thân | OVR Đặc thù | giảm kháng (nhận thêm 15%) | Đạt chuẩn |

### Côn Lôn Kiếm (CLK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Cuồng Lôi Chấn Địa | Q | đánh mục tiêu | OVR Đặc thù | choáng 30% | Đạt chuẩn |
| Côn Lôn Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thanh Phong Phù | F | buff phe ta | OVR Đặc thù | làm chậm 35% | Đạt chuẩn |
| Thiên Tế Tấn Lôi | W | đánh mục tiêu | OVR Đặc thù | choáng 35%, 8 đòn | Đạt chuẩn |
| Đạo Cốt Tiên Phong | T | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Ngũ Lôi Chánh Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Lôi Động Cửu Thiên | E | đánh mục tiêu | OVR Đặc thù | choáng 80%, 9 đòn | Đạt chuẩn |
| Lôi Đình Quyết | - | nổ quanh thân | Khuôn chuẩn | - | Đạt chuẩn |
| Huyền Thiên Vô Cực | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Ngự Phong Thuật | D | đánh mục tiêu | OVR Đặc thù | choáng 90%, giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Thiên Lôi Chấn Nhạc | R | đánh mục tiêu | OVR Đặc thù | choáng 40%, 9 đòn | Đạt chuẩn |
| Hỗn Nguyên Càn Khôn | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hóa Tủy Vô Ý | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Thiếu Lâm Đao (TLD)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Phục Ma Đao Pháp | Q | đánh mục tiêu | OVR Đặc thù | thọ thương 30% | Đạt chuẩn |
| Thiếu Lâm Đao Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Dịch Cân Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| A La Hán Thần Công | - | đạn bay xuyên | Khuôn chuẩn | phản đòn | Đạt chuẩn |
| Bồ Đề Tâm Pháp | D | buff bản thân | OVR Đặc thù | làm chậm 35% | Đạt chuẩn |
| Như Lai Thiên Diệp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Trúc Tuyệt Đao | W | đánh mục tiêu | OVR Đặc thù | thọ thương 35% | Đạt chuẩn |
| Hàng Long Bất Vũ | F | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Đạt Ma Bế Tức | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Đại Thừa Như Lai Chú | R | đánh mục tiêu | OVR Đặc thù | kéo đối thủ, phản đòn | Đạt chuẩn |
| Quy Thiền Đao Pháp | E | đánh mục tiêu | OVR Đặc thù | thọ thương 40% | Đạt chuẩn |
| Thiền Nguyên Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Trảm Ma Đao Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Thiên Vương Thương (TVT)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Hồi Phong Lạc Nhạn | Q | đánh mục tiêu | OVR Đặc thù | thọ thương 30% | Đạt chuẩn |
| Thiên Vương Thương Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Đoạn Hồn Thích | R | xung kích | OVR Đặc thù | - | Đạt chuẩn |
| Kinh Lôi Phá Thiên | - | bị động (cộng chỉ số) | OVR Đặc thù | miễn nhiễm sát thương, phát động khi máu dưới 40% | Đạt chuẩn |
| Thiên Vương Chiến Ý | D | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Thiên Canh Chiến Khí | - | bị động (cộng chỉ số) | OVR Đặc thù | hồi máu | Đạt chuẩn |
| Truy Tinh Trục Nguyệt | W | quét phía trước | OVR Đặc thù | thọ thương 35%, 3 đòn | Đạt chuẩn |
| Bôn Lôi Toàn Long Thương | F | nổ quanh thân | OVR Đặc thù | thọ thương 100%, miễn nhiễm sát thương, 7 đòn | Đạt chuẩn |
| Liên Hoàn Đoạt Mệnh Thương | - | bị động (cộng chỉ số) | Khuôn chuẩn | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Hoành Hành Vô Kỵ | T | miễn khống chế | OVR Đặc thù | đẩy lùi, kéo đối thủ | Đạt chuẩn |
| Bá Vương Trạm Kim | E | quét phía trước | Khuôn chuẩn | thọ thương 40%, 4 đòn | Đạt chuẩn |
| Huyết Chiến Bát Phương | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Ngũ Độc Chưởng (NDC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Độc Sa Chưởng | Q | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Ngũ Độc Chưởng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Canh Địa Sát | R | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| Xuyên Tâm Độc Thích | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Bi Ma Huyết Quang | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Bách Cổ Độc Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Âm Phong Thực Cốt | W | đánh mục tiêu | OVR Đặc thù | định thân 35%, độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| Hóa Cốt Miên Chưởng | D | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| Truy Phong Độc Thích | - | bị động (cộng chỉ số) | OVR Đặc thù | - | Đạt chuẩn |
| Luyện Ngục Hủ Cổ | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%), cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| U Minh Quỷ Trảo | E | đánh mục tiêu | Khuôn chuẩn | định thân 40%, độc / bỏng mỗi giây, sát thương quanh mỗi giây, 2 đòn | Đạt chuẩn |
| Đoạn Cân Hủ Cốt | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| U Minh Khô Lâu | T | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |

### Đường Môn Tụ Tiễn (DMTT)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thiên La Địa Võng | Q | đạn bay xuyên | OVR Đặc thù | định thân 30%, độc / bỏng mỗi giây | Đạt chuẩn |
| Đường Môn Ám Khí | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Mê Ảnh Tung | F | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Tôi Độc Thuật | - | đánh mục tiêu | Khuôn chuẩn | - | Đạt chuẩn |
| Đoạn Cân Nhẫn | R | buff bản thân | OVR Đặc thù | giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Tâm Nhãn | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bạo Vũ Lê Hoa | W | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Xuyên Vân Tiễn | D | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, giảm kháng (nhận thêm 15%), 4 đòn | Đạt chuẩn |
| Thất Tuyệt Sát Quang | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tang Hồn Đinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Khổng Tước Vũ | E | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Tâm Ma | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Phù Quang Lược Ảnh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Nga My Chưởng (NMC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Tứ Tượng Đồng Quy | Q | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 2 đòn | Đạt chuẩn |
| Nga My Chưởng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Phật Tâm Từ Hựu | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bất Diệt Bất Tuyệt | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu, phát động khi máu dưới 40% | Đạt chuẩn |
| Phật Quang Chiến Khí | R | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Phật Pháp Vô Biên | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Phong Sương Toái Ảnh | W | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 3 đòn | Đạt chuẩn |
| Diệp Để Tàng Hoa | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Kim Đỉnh Miên Chưởng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Vạn Tướng Thần Công | D | buff bản thân | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Nguyệt Hoa Khuynh Tả | E | đánh mục tiêu | OVR Đặc thù | làm chậm 35%, 6 đòn | Đạt chuẩn |
| Vạn Phật Quy Tông | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Kim Đỉnh Phật Quang | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Thiên Nhẫn Kích (TNK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Tàn Dương Như Huyết | Q | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Thiên Nhẫn Mâu Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Liệt Hỏa Tinh Thiên | R | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 10 đòn | Đạt chuẩn |
| Ma Âm Phệ Phách | D | nổ quanh thân | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Bi Tô Thanh Phong | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Thiên Ma Giải Thể | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Vân Long Kích | W | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Phi Hồng Vô Tích | F | xung kích | OVR Đặc thù | độc / bỏng mỗi giây, miễn nhiễm sát thương | Đạt chuẩn |
| Cửu Khúc Hợp Thương | - | bị động (cộng chỉ số) | Khuôn chuẩn | miễn nhiễm sát thương, giảm kháng (nhận thêm 15%), cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Vân Long Tam Hiện | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Giang Hải Nộ Lan | E | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Ma Viêm Tại Thiên | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bích Nguyệt Phi Tinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Võ Đang Khí (VDQ)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Bác Cập Nhị Phục | Q | đánh mục tiêu | Khuôn chuẩn | choáng 30%, 2 đòn | Đạt chuẩn |
| Võ Đang Khí Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tọa Vọng Vô Ngã | D | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Chân Vũ Thất Tiệt | - | đánh mục tiêu | Khuôn chuẩn | - | Đạt chuẩn |
| Thuần Dương Vô Cực | F | hộ thuẫn | OVR Đặc thù | - | Đạt chuẩn |
| Thái Cực Vô Ý | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Địa Vô Cực | W | nổ quanh thân | OVR Đặc thù | choáng 35%, 3 đòn | Đạt chuẩn |
| Vạn Kiếm Quy Tông | R | đánh mục tiêu | OVR Đặc thù | choáng 80%, 5 đòn | Đạt chuẩn |
| Võ Đang Cửu Dương | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bát Quái Du Long | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Cửu Cung Bát Quái | E | nổ quanh thân | Khuôn chuẩn | choáng 40%, 3 đòn | Đạt chuẩn |
| Thái Cực Thần Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | 2 đòn | Đạt chuẩn |
| Lưỡng Nghi Tâm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi nội lực | Đạt chuẩn |

### Côn Lôn Đao (CLD)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Cuồng Phong Sậu Điện | Q | đánh mục tiêu | OVR Đặc thù | choáng 30% | Đạt chuẩn |
| Côn Lôn Đao Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tụ Nguyên Thuật | R | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Nhất Khí Tam Thanh | D | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Thiên Thanh Địa Trọc | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ngạo Tuyết Tiếu Phong | W | đánh mục tiêu | OVR Đặc thù | 2 đòn | Đạt chuẩn |
| Hồi Phong Phất Liễu | - | bị động (cộng chỉ số) | Khuôn chuẩn | 4 đòn | Đạt chuẩn |
| Lưỡng Nghi Chân Khí | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn | Đạt chuẩn |
| Phản Lưỡng Nghi Đao Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Cửu Thiên Canh Phong | E | đánh mục tiêu | OVR Đặc thù | 3 đòn | Đạt chuẩn |
| Vô Nhân Vô Ngã | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Sương Ngạo Côn Lôn | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Thiếu Lâm Bổng (TLB)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Phổ Độ Côn Pháp | Q | đánh mục tiêu | OVR Đặc thù | thọ thương 30% | Đạt chuẩn |
| Thiếu Lâm Côn Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bất Động Minh Vương | D | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Thất Tinh La Sát Côn | W | nổ quanh thân | OVR Đặc thù | thọ thương 35% | Đạt chuẩn |
| Túy Tiên Bát Côn | R | nổ quanh thân | OVR Đặc thù | - | Đạt chuẩn |
| Kim Cang Bất Hoại | - | bị động (cộng chỉ số) | Khuôn chuẩn | đẩy lùi, kéo đối thủ, miễn nhiễm sát thương | Đạt chuẩn |
| Như Ý Thúc Cốt Công | F | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Vi Đà Hiến Chử | E | nổ quanh thân | OVR Đặc thù | thọ thương 40%, 2 đòn | Đạt chuẩn |
| Ma Kha Vô Lượng | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu, giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Tẩy Tủy Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn | Đạt chuẩn |

### Đoàn Thị Khí (DTK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Kim Ngọc Mãn Đường | Q | đánh mục tiêu | OVR Đặc thù | làm chậm 35% | Đạt chuẩn |
| Đoàn Thị Tâm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bắc Minh Thần Công | - | đánh mục tiêu | Khuôn chuẩn | kéo đối thủ, độc / bỏng mỗi giây | Đạt chuẩn |
| Lục Kiếm Tề Phát | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu, phát động khi máu dưới 40% | Đạt chuẩn |
| Khô Vinh Thiền Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | phát động khi máu dưới 40% | Đạt chuẩn |
| Đoàn Gia Khí Kiếm | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Lục Mạch Thần Kiếm | W | đạn bay xuyên | OVR Đặc thù | choáng 25%, độc / bỏng mỗi giây, 6 đòn | Đạt chuẩn |
| Kinh Thiên Nhất Kiếm | R | quét phía trước | OVR Đặc thù | làm chậm 35%, 18 đòn | Đạt chuẩn |
| Bách Hồng Thực Nhật | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Luyện Khí Hoàn Thần | - | bị động (cộng chỉ số) | Khuôn chuẩn | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Khí Thôn Vạn Lý | E | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 2 đòn | Đạt chuẩn |
| Thiên Long Thần Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ám Hương Sơ Ảnh | - | bị động (cộng chỉ số) | Khuôn chuẩn | sát thương quanh mỗi giây, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |

### Thiên Vương Chùy (TVC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Hành Vân Quyết | Q | đánh mục tiêu | Khuôn chuẩn | thọ thương 35% | Đạt chuẩn |
| Thiên Vương Chùy Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Vương Bản Sinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | miễn nhiễm sát thương, phát động khi máu dưới 40%, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Kim Chung Tráo | F | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Bất Diệt Sát Ý | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu | Đạt chuẩn |
| Thừa Long Quyết | W | đánh mục tiêu | OVR Đặc thù | thọ thương 40%, 2 đòn | Đạt chuẩn |
| Trảm Long Quyết | D | xung kích | OVR Đặc thù | thọ thương 100%, kéo đối thủ | Đạt chuẩn |
| Càn Khôn Chùy | - | bị động (cộng chỉ số) | Khuôn chuẩn | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Hóa Kinh Quyết | - | đánh mục tiêu | Khuôn chuẩn | - | Đạt chuẩn |
| Tung Hoành Tứ Hải | E | quét phía trước | Khuôn chuẩn | thọ thương 45%, 3 đòn | Đạt chuẩn |
| Đảo Hư Thiên | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Mã Hành Không | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Đường Môn Phi Đao (DMPD)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Tiểu Lý Phi Đao | Q | đạn bay xuyên | OVR Đặc thù | định thân 30%, độc / bỏng mỗi giây | Đạt chuẩn |
| Đường Môn Ám Khí | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Mãn Thiên Hoa Vũ | R | nổ quanh thân | OVR Đặc thù | định thân 50%, độc / bỏng mỗi giây, sát thương quanh mỗi giây, 3 đòn | Đạt chuẩn |
| Nhiếp Hồn Nguyệt Ảnh | W | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Hàm Sa Xạ Ảnh | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Thực Cốt Huyết Nhẫn | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ảnh Tung Trận | D | miễn khống chế | OVR Đặc thù | đẩy lùi, kéo đối thủ, giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Vô Ảnh Xuyên | E | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 4 đòn | Đạt chuẩn |
| Tâm Phách | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| Bách Phát Bách Trúng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Cái Bang Bổng (CBB)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Bổng Đả Ác Cẩu | Q | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Cái Bang Bổng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tiêu Dao Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn, giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Ác Cẩu Lan Lộ | R | nổ quanh thân | OVR Đặc thù | độc / bỏng mỗi giây, 12 đòn | Đạt chuẩn |
| Bôn Lưu Đáo Hải | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Thiên Hạ Vô Cẩu | W | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Đả Cẩu Bổng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Minh Sát Thu Hào | D | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Tung Hạc Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | đẩy lùi | Đạt chuẩn |
| Bổng Quỷnh Lược Địa | E | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 6 đòn | Đạt chuẩn |
| Đả Cẩu Trận Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | 15 đòn | Đạt chuẩn |
| Hỗn Thiên Khí Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%) | Đạt chuẩn |

### Nga My Kiếm (NMK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thôi Song Vọng Nguyệt | Q | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 2 đòn | Đạt chuẩn |
| Từ Hàng Phổ Độ | R | buff phe ta | OVR Đặc thù | hồi máu, sát thương quanh mỗi giây | Đạt chuẩn |
| Thiên Phật Thiên Diệp | D | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Mộng Điệp | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu, hồi nội lực | Đạt chuẩn |
| Phật Tâm Từ Hựu | - | bị động (cộng chỉ số) | Khuôn chuẩn | miễn nhiễm sát thương | Đạt chuẩn |
| Ba La Tâm Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Kiếm Ảnh Phật Quang | W | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 3 đòn | Đạt chuẩn |
| Thanh Âm Phạn Xướng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thanh Tâm Tịnh Khí | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Liên Hoa Tâm Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Băng Sương Điện Phóng | E | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 5 đòn | Đạt chuẩn |
| Độ Nguyên Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu | Đạt chuẩn |
| Bế Nguyệt Phất Trần | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Minh Giáo Chùy (MGC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Khai Thiên Thức | Q | đánh mục tiêu | Khuôn chuẩn | thọ thương 30%, độc / bỏng mỗi giây | Đạt chuẩn |
| Minh Giáo Chùy Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Khốn Hổ Vân Tiếu | R | xung kích | OVR Đặc thù | định thân 50%, độc / bỏng mỗi giây | Đạt chuẩn |
| Kim Qua Thiết Mã | T | buff phe ta | OVR Đặc thù | - | Đạt chuẩn |
| Phách Địa Thế | D | đạn bay xuyên | OVR Đặc thù | định thân 80%, độc / bỏng mỗi giây | Đạt chuẩn |
| Ngự Mã Thuật | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Long Thôn Thức | W | đánh mục tiêu | OVR Đặc thù | thọ thương 35%, độc / bỏng mỗi giây | Đạt chuẩn |
| Hồn Phách Phi Dương | F | nổ quanh thân | OVR Đặc thù | - | Đạt chuẩn |
| Cửu Hi Hỗn Dương | - | bị động (cộng chỉ số) | Khuôn chuẩn | đẩy lùi, kéo đối thủ, hồi máu, sát thương quanh mỗi giây, phát động khi máu dưới 40% | Đạt chuẩn |
| Liệt Diệm Thao Thiên | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Khu Hổ Thức | E | quét phía trước | Khuôn chuẩn | thọ thương 40%, độc / bỏng mỗi giây, 2 đòn | Đạt chuẩn |
| Trấn Ngục Phá Thiên Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu, 3 đòn | Đạt chuẩn |
| Không Tuyệt Tâm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%) | Đạt chuẩn |

### Minh Giáo Kiếm (MGK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thánh Hỏa Phần Tâm | Q | đánh mục tiêu | Khuôn chuẩn | định thân 30%, độc / bỏng mỗi giây | Đạt chuẩn |
| Minh Giáo Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Di Khí Phiêu Tung | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Vạn Vật Câu Phần | W | đánh mục tiêu | OVR Đặc thù | định thân 50%, độc / bỏng mỗi giây, 2 đòn | Đạt chuẩn |
| Càn Khôn Đại Na Di | D | miễn khống chế | OVR Đặc thù | hút máu | Đạt chuẩn |
| Ly Hỏa Đại Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Thánh Hỏa Liêu Nguyên | E | nổ quanh thân | OVR Đặc thù | định thân 35%, độc / bỏng mỗi giây | Đạt chuẩn |
| Thánh Hỏa Lệnh Pháp | F | đánh mục tiêu | OVR Đặc thù | - | Đạt chuẩn |
| Nhân Huân Tử Khí | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hoang Hỏa Ngọc Phần | - | bị động (cộng chỉ số) | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Kiếm Đãng Bát Hoang | R | đánh mục tiêu | OVR Đặc thù | định thân 40%, độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Thánh Hỏa Thần Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Mục Dã Ưng Dương | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |

### Đoàn Thị Chỉ (DTC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thần Chỉ Điểm Huyệt | Q | đánh mục tiêu | OVR Đặc thù | thọ thương 30%, 2 đòn | Đạt chuẩn |
| Đoàn Thị Chỉ Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Nhất Dương Chỉ | R | đánh mục tiêu | OVR Đặc thù | định thân 80%, giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Lăng Ba Vi Bộ | F | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Từ Bi Quyết | - | bị động (cộng chỉ số) | Khuôn chuẩn | phát động khi máu dưới 40% | Đạt chuẩn |
| Kim Ngọc Chỉ Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Cản Dương Thần Chỉ | W | đánh mục tiêu | OVR Đặc thù | thọ thương 35%, 3 đòn | Đạt chuẩn |
| Huyền Băng Cửu Kiếp | D | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 9 đòn | Đạt chuẩn |
| Diệu Đề Chỉ | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thí Nguyên Quyết | - | bị động (cộng chỉ số) | Khuôn chuẩn | đẩy lùi, kéo đối thủ | Đạt chuẩn |
| Thiên Long Thần Chỉ | E | đánh mục tiêu | OVR Đặc thù | thọ thương 40%, 3 đòn | Đạt chuẩn |
| Càn Thiên Chỉ Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | giảm kháng (nhận thêm 15%) | Đạt chuẩn |
| Bách Bộ Xuyên Dương | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Cổ Mộ Châm (CMC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Biệt Tự | Q | đánh mục tiêu | OVR Đặc thù | choáng 30%, 2 đòn | Đạt chuẩn |
| Mộ Châm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Kinh Hồng Chiếu Ảnh | R | xung kích | OVR Đặc thù | choáng 50%, 6 đòn | Đạt chuẩn |
| Súc Thế Đãi Phát | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ngọc Phong Châm | D | đạn bay xuyên | OVR Đặc thù | choáng 40%, cộng dồn tầng (Cực hạn 5 tầng), 7 đòn | Đạt chuẩn |
| Lưu Vân Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ly Hận | W | đánh mục tiêu | OVR Đặc thù | choáng 35%, 3 đòn | Đạt chuẩn |
| Hoàng Tuyền Lảo Đảo | F | đánh mục tiêu | OVR Đặc thù | choáng 30%, 20 đòn | Đạt chuẩn |
| Hành Vân Đới Vũ | - | bị động (cộng chỉ số) | Khuôn chuẩn | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Vụ Tập Vân Hợp | T | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Bi Sầu | E | đánh mục tiêu | OVR Đặc thù | choáng 40%, 3 đòn | Đạt chuẩn |
| Phong Lưu Vân Tán | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Mê Thần Dẫn | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Cổ Mộ Kiếm (CMK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thu Nhạn Bàng Hoàng | Q | đánh mục tiêu | OVR Đặc thù | choáng 30% | Đạt chuẩn |
| Kiếm Mộ Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hồng Tụ Triền | R | đánh mục tiêu | OVR Đặc thù | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Tịnh Ảnh Trầm Bích | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu | Đạt chuẩn |
| Mộ Vân Ngưng Bích | - | bị động (cộng chỉ số) | Khuôn chuẩn | phát động khi máu dưới 40% | Đạt chuẩn |
| Ngọc Nữ Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Cô Nguyệt Bồi Hồi | W | đánh mục tiêu | OVR Đặc thù | choáng 35% | Đạt chuẩn |
| Chung Nam Vãn Chiếu | D | đánh mục tiêu | OVR Đặc thù | choáng 50%, cộng dồn tầng (Cực hạn 5 tầng), 3 đòn | Đạt chuẩn |
| Hàn Sơn Độc Lập | - | bị động (cộng chỉ số) | Khuôn chuẩn | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Phi Thiên Vũ | F | đánh mục tiêu | OVR Đặc thù | - | Đạt chuẩn |
| Cô Thân Chi Ảnh | E | đánh mục tiêu | OVR Đặc thù | choáng 40% | Đạt chuẩn |
| Ngọc Nữ Tâm Kinh | - | bị động (cộng chỉ số) | Khuôn chuẩn | 3 đòn | Đạt chuẩn |
| Bạch Vân Hồi Vọng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Hoa Sơn Khí (HSQ)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Thanh Vân Tống Sảng | Q | đánh mục tiêu | Khuôn chuẩn | choáng 30%, 2 đòn | Đạt chuẩn |
| Hoa Sơn Khí Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Long Nhiễu Thân | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Chân Khí Hộ Thể | R | hộ thuẫn | OVR Đặc thù | cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Hải Nạp Bách Xuyên | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Khí Chấn Sơn Hà | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Ma Vân Kiếm Khí | W | nổ quanh thân | Khuôn chuẩn | choáng 25%, 3 đòn | Đạt chuẩn |
| Khí Quán Trường Hồng | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tử Hà Chân Khí | D | buff bản thân | OVR Đặc thù | đẩy lùi, kéo đối thủ, sát thương quanh mỗi giây, hồi nội lực | Đạt chuẩn |
| Huyền Nhãn Yên Vân | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Phách Thạch Phá Ngọc | E | đạn bay xuyên | Khuôn chuẩn | choáng 25%, 3 đòn | Đạt chuẩn |
| Thần Quang Toàn Nhiễu | - | bị động (cộng chỉ số) | Khuôn chuẩn | 6 đòn | Đạt chuẩn |
| Tử Khí Đông Lai | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi nội lực | Đạt chuẩn |

### Hoa Sơn Kiếm (HSK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Bạch Hồng Quán Nhật | Q | đánh mục tiêu | Khuôn chuẩn | choáng 30%, 2 đòn | Đạt chuẩn |
| Kiếm Tông Tổng Quyết | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thiên Thân Đảo Huyền | E | nổ quanh thân | OVR Đặc thù | choáng 40%, 10 đòn | Đạt chuẩn |
| Kim Nhạn Hoành Không | R | buff bản thân | OVR Đặc thù | làm chậm 35%, sát thương quanh mỗi giây, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Hi Di Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Thương Tùng Nghênh Khách | W | đánh mục tiêu | OVR Đặc thù | choáng 35%, 3 đòn | Đạt chuẩn |
| Thái Nhạc Tam Thanh | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm | D | buff bản thân | OVR Đặc thù | - | Đạt chuẩn |
| Phá Kiếm Thức | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu, 3 đòn | Đạt chuẩn |
| Cửu Kiếm Hợp Nhất | - | bị động (cộng chỉ số) | Khuôn chuẩn | 9 đòn | Đạt chuẩn |
| Nhất Kiếm Phá Vạn Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | hút máu | Đạt chuẩn |
| Độc Cô Cửu Kiếm | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |

### Tiêu Dao Chưởng (TDC)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Dương Ca Thiên Quân | Q | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 2 đòn | Đạt chuẩn |
| Tiêu Dao Chưởng Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hàn Tụ Huyệt | R | đánh mục tiêu | OVR Đặc thù | định thân 90%, sát thương quanh mỗi giây, 4 đòn | Đạt chuẩn |
| Sưu Hồn Đại Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | kéo đối thủ, hút máu, phát động khi máu dưới 40% | Đạt chuẩn |
| Diệm Nguyên Luân Hồi | - | bị động (cộng chỉ số) | Khuôn chuẩn | đẩy lùi, kéo đối thủ, phản đòn | Đạt chuẩn |
| Phục Nhật Xuất Vân | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Bạch Nhật Sâm Thần | W | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Sinh Tử Phù | D | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, cộng dồn tầng (Cực hạn 5 tầng), 45 đòn | Đạt chuẩn |
| Hỗn Nhật Khí Quyết | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Thiên Tàm Cửu Biến | F | nổ quanh thân | OVR Đặc thù | hút máu | Đạt chuẩn |
| Bài Sơn Đảo Hải | E | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Thái Hư Thần Công | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tung Bộ Quan Hỏa | T | buff bản thân | OVR Đặc thù | giảm kháng (nhận thêm 15%) | Đạt chuẩn |

### Tiêu Dao Kiếm (TDK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Trảm Vân Kiếm | Q | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây | Đạt chuẩn |
| Tiêu Dao Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Đan Phượng Dẫn | R | nổ quanh thân | OVR Đặc thù | định thân 50%, độc / bỏng mỗi giây, sát thương quanh mỗi giây | Đạt chuẩn |
| Chân Hỏa Hộ Thể | - | bị động (cộng chỉ số) | Khuôn chuẩn | phản đòn | Đạt chuẩn |
| Sơ Hoa Dẫn | F | buff phe ta | OVR Đặc thù | phản đòn, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Đoản Ca Hành | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Tê Chiếu Phồn Thương | W | đánh mục tiêu | OVR Đặc thù | độc / bỏng mỗi giây, 3 đòn | Đạt chuẩn |
| Kiếm Chủng Dẫn | D | đánh mục tiêu | OVR Đặc thù | 25 đòn | Đạt chuẩn |
| Bính Nhược Quan Hỏa | - | bị động (cộng chỉ số) | Khuôn chuẩn | sát thương quanh mỗi giây, cộng dồn tầng (Cực hạn 5 tầng) | Đạt chuẩn |
| Ngang Nhật Đồ | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Bách Điểu Triều Phượng | E | đạn bay xuyên | OVR Đặc thù | độc / bỏng mỗi giây, 4 đòn | Đạt chuẩn |
| Phần Phách Tru Tâm | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Hỏa Hải Vô Nhai | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |

### Thúy Yên Kiếm (TYK)

| Chiêu | Phím | Khuôn Engine | Cấu hình OVR | Hiệu ứng đã làm | Ghi chú cơ chế |
|---|---|---|---|---|---|
| Phong Quyển Tàn Tuyết | Q | đạn bay xuyên | OVR Đặc thù | làm chậm 35% | Đạt chuẩn |
| Thúy Yên Kiếm Pháp | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tuyết Ảnh | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Vũ Đả Lê Hoa | R | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 16 đòn | Đạt chuẩn |
| Hộ Thể Hàn Băng | - | bị động (cộng chỉ số) | Khuôn chuẩn | phát động khi máu dưới 40% | Đạt chuẩn |
| Băng Cốt Tuyết Tâm | - | bị động (cộng chỉ số) | Khuôn chuẩn | độc / bỏng mỗi giây | Đạt chuẩn |
| Băng Tâm Tiên Tử | W | đánh mục tiêu | OVR Đặc thù | làm chậm 35%, 2 đòn | Đạt chuẩn |
| Phi Tự Phiêu Hoa | D | đánh mục tiêu | OVR Đặc thù | làm chậm 35%, 26 đòn | Đạt chuẩn |
| Phù Vân Tán Tuyết | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Băng Tâm Ngọc Lăng | F | buff bản thân | OVR Đặc thù | hồi máu | Đạt chuẩn |
| Thủy Ánh Mạn Tú | E | đạn bay xuyên | OVR Đặc thù | làm chậm 35%, 3 đòn | Đạt chuẩn |
| Thập Diện Mai Phục | - | bị động (cộng chỉ số) | Khuôn chuẩn | - | Đạt chuẩn |
| Tuyết Ánh Hồng Trần | - | bị động (cộng chỉ số) | Khuôn chuẩn | hồi máu, hồi nội lực | Đạt chuẩn |
