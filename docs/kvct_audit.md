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

### Cái Bang Chưởng (CBC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CBC"`; Q/W/E: `e6B`/`e6l`, `eHR`/`eHW`, `Jk1`/`JkN`; Bá Vương Tá Giáp: `edO`/`edd`; chiêu bấm: `J3f`/`J33`, `Jff`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map; bỏng = nhận thêm 50% sát thương (như KVCT).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Hàng Long Hữu Hối | Q (autocast) | Chưởng xòe quạt ~15°: 3 chưởng ở bậc 1–4, rồi (bậc − 1) chưởng (9 chưởng ở bậc 10), bay 528 (rộng 90), tối đa 7; 30% bỏng 1 giây | Như KVCT: 3 đạn, từ bậc 5 thành (bậc − 1) đạn, xòe 15°, 528, tối đa 7; bỏng 30% 1 giây | Giống |
| Cái Bang Chưởng Pháp | - | Bị động: hỏa công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Hóa Hiểm Vi Di | - | Bị động: né tránh, kháng phản đòn, tốc chạy | Bị động: tốc chạy | Gần giống |
| Thời Thừa Lục Long | R | 12 giây (hết sau 6 đòn): lực tấn công kỹ năng +60% (bậc 1), kéo dài bỏng; hồi 25 giây | Buff 12 giây: sát thương +(55 + 5 × bậc)% | Gần giống (không mất sau 6 đòn; không kéo dài bỏng) |
| Túy Điệp Cuồng Vũ | - | Vòng sáng: kháng tất cả, kháng thời gian thọ thương | Bị động: giảm sát thương nhận + kháng thời gian trạng thái | Gần giống |
| Tiềm Long Tại Uyên | - | Bị động: phát huy lực tấn công, tỉ lệ bỏng, kháng thọ thương | Bị động: sát thương % | Gần giống |
| Phi Long Tại Thiên | W (autocast) | 4 đòn liên tiếp lên mục tiêu (cách ~0,04 giây), tối đa 7; 35% bỏng 2 giây; 35% hỏa công +60% | 4 đòn đánh lan 150 tại mục tiêu, tối đa 7; bỏng 35% 2 giây; 30% thêm 25% sát thương | Gần giống |
| Trảo Long Công | - | Bị động: hỏa công; sinh lực < 50%: sát thương kỹ năng ×(1,1 + 0,02 × bậc) | Bị động: sát thương % | Khác một phần (chưa làm điều kiện máu < 50%) |
| Thần Long Bài Vĩ | - | Tỉ lệ (20 + bậc)% tự phát Trảo Long Công; mở rộng phạm vi Phi Long Tại Thiên | Không có hiệu quả | Khác (chưa làm) |
| Bá Vương Tá Giáp | - | Mỗi lần Q/W/E: 4 giây tốc đánh +15, phát huy lực tấn công +(10 + 2 × bậc)%, miễn trạng thái; giãn cách 10 giây | Mỗi đòn đánh: 4 giây tốc đánh +15%, sát thương +(10 + 2 × bậc)%, miễn khống chế; giãn cách 10 giây | Giống |
| Long Du Thiên Địa | E (autocast) | Du Long bay theo đường thẳng, trúng địch thì ra thức 2 (Long Đài Đầu), tối đa 7; 40% bỏng 3 giây; 35% hỏa công +60%; tự kích hoạt Thời Thừa Lục Long (Giáng Long Chưởng) | 2 đợt đạn bay 600 cách 0,3 giây, tối đa 7; bỏng 40% 3 giây; 30% thêm 25% sát thương | Gần giống (không tự kích hoạt Thời Thừa Lục Long) |
| Giáng Long Chưởng | - | Bị động: hỏa công; E tăng tỉ lệ Lục Long Đồng Du, 100% tự thi triển Thời Thừa Lục Long (giãn cách 15 giây) | Bị động: sát thương % | Khác một phần (chưa làm phần tự thi triển) |
| Triệt Y Thập Bát Điệt | D | 20 giây: sát thương lên hệ Kim +(20 + bậc)%, bỏ qua hỏa phòng +(9 + bậc)%, kháng tất cả +(80 + 20 × bậc); hồi 90 giây | Buff 20 giây: sát thương +(9 + bậc)% + giảm sát thương nhận | Gần giống |

Trước khi sửa: Q là quét nón 3 hit, W là đánh 1 mục tiêu 4 hit, Thời Thừa Lục Long là nổ quanh thân 6 hit (KVCT là buff), Triệt Y Thập Bát Điệt cộng vật công cố định.

### Côn Lôn Kiếm (CLK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CLK"`; Q: `e_E`/`eli`; chiêu bấm: `JKJ`/`JK9`, `etR`/`etW`, `JEU`/`JEl`, `eBe`/`eBK`, `ebR`/`ebW`, `J0n`/`J0u`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Lưu ý: trong KVCT chỉ Q của Côn Lôn Kiếm là đánh kèm đòn đánh; **W (Thiên Tế Tấn Lôi, hồi 2,5 giây) và E (Lôi Động Cửu Thiên, hồi 9 giây) là chiêu bấm**. Map giữ Q/W/E đều tự động (theo yêu cầu), dùng đúng thời gian hồi chiêu của KVCT. Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Cuồng Lôi Chấn Địa | Q (autocast) | Sét đánh tại mục tiêu, bán kính 120, tối đa 3; 30% choáng 1 giây | Đánh lan 120 tại mục tiêu, tối đa 3; choáng 30% 1 giây | Giống |
| Côn Lôn Kiếm Pháp | - | Bị động: lôi công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Thanh Phong Phù | F | Tướng phe ta trong 1000 (đồng đội 60%) 300 giây: tốc chạy +(5 + bậc), kháng thời gian chậm +(18 + 2 × bậc)% | Buff phe ta 300 giây: tốc chạy +(5 + bậc), kháng thời gian trạng thái +(18 + 2 × bậc)% | Giống |
| Thiên Tế Tấn Lôi | W (autocast) | Chiêu bấm (hồi 2,5 giây): trận sét tại điểm, 8 tia, bán kính 420, tối đa 7; 35% choáng 1 giây | Tự động khi đánh (hồi 2,5 giây): 8 tia cách 0,2 giây tại mục tiêu, 420, tối đa 7; choáng 35% 1 giây | Gần giống (tự động thay vì bấm) |
| Đạo Cốt Tiên Phong | T | Phe ta trong 1000 (đồng đội 60%) 300 giây: kháng vật / băng / hỏa / lôi +(45 + 15 × bậc), sát thương ngũ hành nhận −(10 + 2 × bậc)% | Buff phe ta 300 giây: giảm (10 + 2 × bậc)% sát thương nhận | Giống (map không có kháng từng hệ cho chiêu) |
| Ngũ Lôi Chánh Pháp | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương % | Gần giống |
| Lôi Động Cửu Thiên | E (autocast) | Chiêu bấm (hồi 9 giây): 9 tia sét lớn cách 0,3 giây vào kẻ địch ngẫu nhiên trong 1000; 80% choáng 1 giây | Tự động khi đánh (hồi 9 giây): 9 nhịp cách 0,3 giây, mỗi nhịp đánh 1 kẻ địch ngẫu nhiên trong 1000; choáng 80% 1 giây | Gần giống (tự động thay vì bấm) |
| Lôi Đình Quyết | - | Vòng sáng: kẻ địch xung quanh nhận thêm (14 + 2 × bậc)% sát thương từ chiêu Côn Lôn, tốc chạy −15% | Bị động: sát thương % | Gần giống (không làm chậm) |
| Huyền Thiên Vô Cực | - | Hóa giải % sát thương nhận, kháng phản đòn; bị đánh +1 tầng chí mạng (tối đa 5) | Bị động: giảm sát thương nhận + chí mạng | Gần giống (không cộng tầng) |
| Ngự Phong Thuật | D | Lốc xoáy bay thẳng 960 (rộng 220), không sát thương: 90% choáng 3 giây, giảm kháng lôi / kháng chí mạng 8 giây; hồi 20 giây | Đạn bay 960 không sát thương: choáng 90% 3 giây + nhận thêm 15% sát thương 8 giây | Gần giống |
| Thiên Lôi Chấn Nhạc | R | Bão sét tại điểm, 9 nhịp cách 0,12 giây, bán kính 400, tối đa 10; 40% choáng 1 giây; Hỗn Nguyên Càn Khôn: 20% Bạo Lôi tăng sát thương | Trận tại điểm 9 nhịp cách 0,12 giây, 400, tối đa 10; choáng 40% 1 giây; 30% thêm 25% sát thương | Giống |
| Hỗn Nguyên Càn Khôn | - | Bị động: lôi công, chí mạng, sát thương chí mạng; Bạo Lôi cho R | Bị động: chí mạng (Bạo Lôi gắn sẵn vào R) | Gần giống |
| Hóa Tủy Vô Ý | - | Sát thương lên hệ Thủy; giảm hồi chiêu E và R; tăng tấn công khi chí mạng | Bị động: chí mạng | Khác một phần (chưa giảm hồi chiêu) |

Trước khi sửa: Q là đánh mục tiêu 2 hit, W / E / R đều là nổ quanh thân (KVCT: sét tại điểm / vào địch ngẫu nhiên / bão tại điểm); Ngự Phong Thuật là đạn bay 3 hit làm chậm; Thanh Phong Phù / Đạo Cốt Tiên Phong kéo dài 25–30 giây (KVCT 300 giây).

### Thiếu Lâm Đao (TLD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TLD"`; Q/W/E: `eQs`, `JKw`/`JKv`, `eQr`/`eQq`; chiêu bấm: `eAz`, `e_R`/`e_W`, `elV` (Bồ Đề Tâm Pháp, xem Thiếu Lâm Quyền)), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 10; thêm **Dịch Cân Kinh, A La Hán Thần Công, Bồ Đề Tâm Pháp (D)**).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Phục Ma Đao Pháp | Q (autocast) | Đao khí theo đường thẳng 700 (rộng 180), tối đa 7; 30% thọ thương 1 giây | Đạn bay 700, tối đa 7; thọ thương 30% 1 giây | Giống |
| Thiếu Lâm Đao Pháp | - | Bị động: chính xác, vật công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Dịch Cân Kinh | - | Bị động: sinh lực tối đa % | Bị động: sinh lực | Giống |
| A La Hán Thần Công | - | Vòng sáng: phản đòn cận chiến / tầm xa; La Hán Trận phản đòn theo sinh khí | Bị động: phản đòn (2% × bậc sát thương nhận) | Gần giống |
| Bồ Đề Tâm Pháp | D | (như Thiếu Lâm Quyền) 300 giây kháng thời gian trạng thái +(17 + 3 × bậc)% | Như Thiếu Lâm Quyền | Giống |
| Như Lai Thiên Diệp | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Thiên Trúc Tuyệt Đao | W (autocast) | 2 đao khí theo đường thẳng cách 0,31 giây, tối đa 7; 35% thọ thương 1 giây; 30% lực tấn công +30% | 2 đợt cách 0,31 giây, 700, tối đa 7; thọ thương 35% 1 giây; 30% thêm 25% sát thương | Giống |
| Hàng Long Bất Vũ | F | 20 giây: triệt tiêu 99% sát thương nhận, miễn trạng thái, chí mạng, sát thương chí mạng; bị đánh 30 lần thì hết; hồi 60 giây | 20 giây miễn sát thương + miễn khống chế + chí mạng; hết sau 30 lần bị đánh; hồi 60 giây | Giống |
| Đạt Ma Bế Tức | - | Kháng tỉ lệ trạng thái; khi bị đánh 50%: hóa giải + miễn trạng thái 3 giây (giãn cách) | Bị động: kháng thời gian trạng thái; khi mất máu 50%: 3 giây miễn khống chế, giãn cách 15 giây | Gần giống (không hóa giải trạng thái đang dính) |
| Đại Thừa Như Lai Chú | R | Tại điểm chọn: kẻ địch trong 350 (tối đa 7) bị kéo 140 về điểm, 40% định thân 2 giây, chịu thêm sát thương phản đòn 15 giây; không sát thương; hồi 30 giây | Trận 1 nhịp tại điểm: 350, tối đa 7, kéo về tâm, định thân 40% 2 giây, nhận thêm 15% sát thương 15 giây; không sát thương | Gần giống |
| Quy Thiền Đao Pháp | E (autocast) | 3 đao khí cách 1/6 giây, tối đa 7; 40% thọ thương 1 giây; 30% lực tấn công +30% | 3 đợt cách 0,17 giây, 700, tối đa 7; thọ thương 40% 1 giây; 30% thêm 25% sát thương | Giống |
| Thiền Nguyên Công | - | Sức mạnh, thân pháp, sinh khí; E 40%: thức thứ ba phóng 6 đạo đao phong | Bị động: sát thương %; E 40% thêm 3 đợt | Gần giống |
| Trảm Ma Đao Pháp | - | Sát thương lên hệ Mộc, chí mạng, tấn công khi chí mạng, tỉ lệ hóa giải trạng thái | Bị động: chí mạng + kháng thời gian trạng thái | Gần giống |

Trước khi sửa: Q/W là quét nón, E là nổ quanh thân 3 hit, Đại Thừa Như Lai Chú là nổ quanh thân 6 hit (KVCT: kéo + định thân tại điểm, không sát thương), Hàng Long Bất Vũ là buff sát thương 300 giây (KVCT: 20 giây gần như bất tử); thiếu 3 chiêu dùng chung.

### Thiên Vương Thương (TVT) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TVT"`; Q/W/E: `Jow`, `Jsu`, `JaG`/`e69`; chiêu bấm: `Jag`/`JaA`, `egC`/`egx`; Đoạn Hồn Thích, Kinh Lôi Phá Thiên, Thiên Vương Chiến Ý, Thiên Canh Chiến Khí, Thiên Mã Hành Không: xem Thiên Vương Đao), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 12; thêm **Thiên Mã Hành Không**).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Hồi Phong Lạc Nhạn | Q (autocast) | Đánh lan 100 tại chỗ mục tiêu, tối đa 7; 30% thọ thương 1 giây | Đánh lan 100 tại mục tiêu, tối đa 7; thọ thương 30% 1 giây | Giống |
| Thiên Vương Thương Pháp | - | Bị động: chính xác, vật công %, chí mạng; tốc đánh tối đa ngay từ đầu | Bị động: sát thương % + chí mạng | Gần giống |
| Đoạn Hồn Thích | R | Như Thiên Vương Đao | Như Thiên Vương Đao | Giống |
| Kinh Lôi Phá Thiên | - | Như Thiên Vương Đao | Như Thiên Vương Đao | Gần giống |
| Thiên Vương Chiến Ý | D | Như Thiên Vương Đao | Như Thiên Vương Đao | Gần giống |
| Thiên Canh Chiến Khí | - | Như Thiên Vương Đao | Như Thiên Vương Đao | Gần giống |
| Truy Tinh Trục Nguyệt | W (autocast) | 3 nhát thương cách 1/6 giây, đánh lan 120 tại chỗ mục tiêu, tối đa 7; 35% thọ thương 1 giây | 3 nhát cách 0,17 giây, đánh lan 120, tối đa 7; thọ thương 35% 1 giây | Giống |
| Bôn Lôi Toàn Long Thương | F | 7 lần lướt cách 0,3125 giây tới kẻ địch chưa trúng trong 1000, 100% thọ thương 2 giây; miễn sát thương + miễn trạng thái khi thi triển; hồi 15 giây | Liên kích 7 lần lướt tới kẻ địch chưa trúng trong 1000 (bán kính đánh 350), thọ thương 100% 2 giây; miễn sát thương + khống chế khi lướt | Giống |
| Liên Hoàn Đoạt Mệnh Thương | - | Mỗi lần đánh trúng +1 tầng (phát huy lực tấn công +3%), 8 giây, tối đa (bậc + 5) tầng | Mỗi đòn đánh +1 tầng (sát thương +4%, chí mạng +2%), 6 giây, tối đa 5 tầng | Gần giống (số tầng tối đa cố định 5) |
| Hoành Hành Vô Kỵ | T | (8 + bậc) giây hóa giải + miễn thọ thương / định thân / chậm / choáng / đẩy / kéo; hồi 40 giây | (8 + bậc) giây miễn khống chế; hồi 40 giây | Giống |
| Bá Vương Trạm Kim | E (autocast) | 4 nhát cách 0,125 giây, đánh lan 270, tối đa 7; 40% thọ thương 1 giây | 4 nhát cách 0,13 giây, đánh lan 270 tại mục tiêu, tối đa 7; thọ thương 40% 1 giây | Giống |
| Huyết Chiến Bát Phương | - | Sinh lực tối đa; E 75% phóng thêm một mũi thương bay 900 (rộng 150, tối đa 7) | Bị động: sinh lực; E 30% thêm 25% sát thương | Khác một phần (không có mũi thương bay) |
| Thiên Mã Hành Không | - | Như Thiên Vương Đao | Như Thiên Vương Đao | Gần giống |

Trước khi sửa: Q là quét nón 2 hit, Truy Tinh Trục Nguyệt (W) bị gán nhầm là chiêu lướt, Hoành Hành Vô Kỵ 15 giây cố định; thiếu Thiên Mã Hành Không.

### Ngũ Độc Chưởng (NDC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="NDC"`; Q/W/E: `JDO`/`JDl`, `J4W`/`J4y`, `JF3`/`JFK`; chiêu bấm: `JCn`/`JCu`, `Jo0`/`JoE`, `Jst` (U Minh Khô Lâu, xem Ngũ Độc Đao)), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; độc của KVCT là độc mỗi giây trên từng mục tiêu, ở map các chiêu độc theo thời gian làm thành trận nhiều nhịp (mỗi nhịp gây sát thương cho kẻ địch đang đứng trong vùng).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Độc Sa Chưởng | Q (autocast) | Độc chưởng bay tới mục tiêu (800), nổ ở kẻ địch đầu tiên, bán kính 150, tối đa 7; độc 4 giây | Đánh lan 150 tại mục tiêu, tối đa 7; độc | Gần giống (không có đạn bay) |
| Ngũ Độc Chưởng Pháp | - | Bị động: độc công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Thiên Canh Địa Sát | R | Bùa chú tại điểm, bán kính 180, tối đa 4: độc mỗi giây trong 6 giây; hồi 10 giây | Trận tại điểm 6 nhịp × 1 giây, 180, tối đa 4 | Gần giống (độc theo vùng, không bám theo mục tiêu) |
| Xuyên Tâm Độc Thích | - | Bị động: độc sát gây ra +% | Bị động: sát thương % | Gần giống |
| Bi Ma Huyết Quang | - | Đánh trúng: kẻ địch giảm điểm chí mạng và kháng độc 30 giây | Q/W/E trúng: kẻ địch nhận thêm 15% sát thương 4 giây | Gần giống |
| Bách Cổ Độc Kinh | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Âm Phong Thực Cốt | W (autocast) | Tại mục tiêu 3 nhịp cách 0,5 giây, tối đa 7; 35% bất động 1 giây; độc 4 giây | Trận tại mục tiêu 3 nhịp cách 0,5 giây, 200, tối đa 7; định thân 35% 1 giây; độc | Giống |
| Hóa Cốt Miên Chưởng | D | Kẻ địch trong 200 quanh điểm (tối đa 7) trúng độc 8 giây, di chuyển càng nhiều độc càng mạnh (tối đa +100%); hồi 20 giây | Trận tại điểm 8 nhịp × 1 giây, 200, tối đa 7 | Gần giống (không tăng theo di chuyển) |
| Truy Phong Độc Thích | - | Khi đánh / tung chiêu có tỉ lệ: hóa giải + miễn thọ thương / chậm / choáng, giãn cách 15 giây | Khi đánh 30%: miễn khống chế ~3 giây, giãn cách 15 giây | Gần giống (tỉ lệ ước lượng) |
| Luyện Ngục Hủ Cổ | - | W rộng hơn; đánh trúng giảm kháng độc 12 giây (cộng dồn) | Q/W/E trúng: nhận thêm 15% sát thương | Gần giống |
| U Minh Quỷ Trảo | E (autocast) | Tại mục tiêu 2 đòn cách 0,48 giây, tối đa 7; 40% bất động 1 giây; độc 4 giây | Trận tại mục tiêu 2 nhịp cách 0,48 giây, 200, tối đa 7; định thân 40% 1 giây; độc | Giống |
| Đoạn Cân Hủ Cốt | - | Độc sát +%, E rộng hơn; E 75%: Hắc Hổ Đào Tâm độc thêm 3 giây | Bị động: sát thương %; E 30% thêm 25% sát thương | Gần giống |
| U Minh Khô Lâu | T | Như Ngũ Độc Đao | Như Ngũ Độc Đao | Gần giống |

Trước khi sửa: Q là quét nón, W là nổ quanh thân, Thiên Canh Địa Sát là đánh 1 mục tiêu 4 hit, Hóa Cốt Miên Chưởng là đạn bay; Truy Phong Độc Thích (bị động) bị làm thành nổ quanh thân 5 hit.

### Đường Môn Tụ Tiễn (DMTT) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DMTT"`; Q/W/E: `JCg`/`JCA`, `JaC`/`Jax`, `Jkm`/`Jkc`; chiêu bấm: `eOJ`/`eO9`, `JJz`/`JJP`; Mê Ảnh Tung, Tôi Độc Thuật, Tâm Nhãn: xem Đường Môn Phi Tiêu), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thiên La Địa Võng | Q (autocast) | Ám khí đuổi theo mục tiêu (900), 30% định thân 1 giây, trúng thì tỏa ra xung quanh; độc | Đánh lan 180 tại mục tiêu, tối đa 7; định thân 30% 1 giây; độc | Gần giống (không có đạn đuổi / tỏa) |
| Đường Môn Ám Khí | - | Bị động: chính xác, độc công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Mê Ảnh Tung | F | Như Đường Môn Phi Tiêu | Như Đường Môn Phi Tiêu | Giống |
| Tôi Độc Thuật | - | Như Đường Môn Phi Tiêu | Như Đường Môn Phi Tiêu | Gần giống |
| Đoạn Cân Nhẫn | R | 5 ám khí xòe 15°, bay 900 (rộng 90), tối đa 7, (25 + 5 × bậc)% định thân 2 giây, giảm kháng chí mạng 15 giây; hồi 10 giây | 5 đạn xòe 15°, 900, tối đa 7; định thân (25 + 5 × bậc)% 2 giây; nhận thêm 15% sát thương 15 giây | Giống |
| Tâm Nhãn | - | Như Đường Môn Phi Tiêu | Như Đường Môn Phi Tiêu | Gần giống |
| Bạo Vũ Lê Hoa | W (autocast) | Tại mục tiêu 3 lần nổ cách 0,4 giây, bán kính 180, tối đa 7, 35% định thân 1,5 giây; ám khí tỏa ra (25% thọ thương 0,5 giây); độc | Trận tại mục tiêu 3 nhịp cách 0,4 giây, 180, tối đa 7; định thân 35% 1,5 giây; độc | Gần giống (không có ám khí tỏa ra) |
| Xuyên Vân Tiễn | D | Tiễn đuổi theo mục tiêu, rồi thêm 3 đòn cách 0,3 giây; định thân (20 + cự li / 10)% 3 giây; độc 6 lần; hồi 20 giây | Đánh mục tiêu 4 đòn cách 0,3 giây; định thân 30% 3 giây; độc | Gần giống (tỉ lệ không tăng theo cự li) |
| Thất Tuyệt Sát Quang | - | Khi tấn công: tốc đánh, chí mạng, phát huy lực tấn công một lúc; giãn cách 30 giây | Khi đánh: buff tốc đánh + chí mạng 10 giây, giãn cách 30 giây | Gần giống |
| Tang Hồn Đinh | - | Chí mạng; khi tung Đoạn Cân Nhẫn thêm chí mạng 5 giây | Bị động: chí mạng | Khác một phần |
| Khổng Tước Vũ | E (autocast) | Tại mục tiêu 3 lần cách 0,3 giây, tối đa 7, 40% định thân 1,5 giây, 30% thọ thương; độc | Trận tại mục tiêu 3 nhịp cách 0,3 giây, 180, tối đa 7; định thân 40% 1,5 giây; độc | Gần giống |
| Tâm Ma | - | Né tránh; E mỗi 4 đòn phát động Truy Tinh Trục Điện tại mục tiêu | E trúng cùng 1 địch 3 lần thì nổ thêm 1 lần | Gần giống |
| Phù Quang Lược Ảnh | - | Khi chí mạng: vật công / độc công / sát thương chí mạng 20 giây, giãn cách 30 giây | Khi đánh 25%: buff sát thương + chí mạng 20 giây, giãn cách 30 giây | Gần giống (không cần chí mạng) |

Trước khi sửa: Q / W / E đều là nổ quanh thân (KVCT: tại chỗ mục tiêu), Đoạn Cân Nhẫn là quét nón, Xuyên Vân Tiễn là đạn bay xuyên.

### Nga My Chưởng (NMC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="NMC"`; Q/W/E: `Jsl`/`Jsd`, `JxH`/`JxZ`, `Jhd`/`Jhn`; chiêu bấm: `eH4`, `J9p`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tứ Tượng Đồng Quy | Q (autocast) | 2 đòn cách 0,15 giây tại chỗ mục tiêu, bán kính 200, tối đa 7, 30% làm chậm 2 giây; sau đó tia băng 400 sang kẻ địch lân cận (tối đa 4) | 2 đòn đánh lan 200 tại mục tiêu, tối đa 7; chậm 30% 2 giây | Gần giống (không có tia băng lan) |
| Nga My Chưởng Pháp | - | Bị động: băng công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Phật Tâm Từ Hựu | - | Bị động: sinh lực / nội lực tối đa % | Bị động: sinh lực | Gần giống |
| Bất Diệt Bất Tuyệt | - | Sinh lực < 50% khi bị đánh: mỗi 0,5 giây hồi máu cho bản thân và đồng đội quanh đó trong 5 giây; giãn cách 30 giây | Sinh lực < 50%: hồi 20% sinh lực tối đa cho bản thân; giãn cách 30 giây | Khác một phần (không hồi cho đồng đội) |
| Phật Quang Chiến Khí | R | Tướng phe ta trong 1000 (đồng đội 60%) 300 giây: vật công nội, sát thương chí mạng | Buff phe ta 300 giây: sát thương % + chí mạng | Gần giống |
| Phật Pháp Vô Biên | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Phong Sương Toái Ảnh | W (autocast) | Chưởng khí bay 400 tới mục tiêu rồi quay về (rộng 100), tối đa 7; 35% làm chậm 2 giây | 3 đợt đạn bay 400 cách 0,2 giây, tối đa 7; chậm 35% 2 giây | Gần giống (không quay về) |
| Diệp Để Tàng Hoa | - | W/E trúng: thêm 3 đòn trong phạm vi nhỏ, giãn cách (3,1 − 0,1 × bậc) giây | Q/W/E trúng: 30% thêm 25% sát thương | Gần giống |
| Kim Đỉnh Miên Chưởng | - | Khi tấn công: chí mạng + hóa giải và miễn trạng thái 3 giây, giãn cách 15 giây | Khi đánh: buff chí mạng + miễn khống chế 3 giây, giãn cách 15 giây | Giống |
| Vạn Tướng Thần Công | D | 300 giây: kháng tỉ lệ thọ thương / định thân / chậm / bỏng, phát huy lực tấn công | Buff 300 giây: kháng thời gian trạng thái + sát thương % | Gần giống |
| Nguyệt Hoa Khuynh Tả | E (autocast) | 3 đạo chưởng khí cách 1/6 giây đuổi mục tiêu (800, rộng 150), mỗi đạo trúng 2 lần (đi và về), tối đa 7; 40% làm chậm 2 giây | 6 đợt đạn bay 800 cách 0,17 giây, tối đa 7; chậm 40% 2 giây | Gần giống |
| Vạn Phật Quy Tông | - | Sát thương chí mạng, cường hóa / nhược hóa ngũ hành; E tăng sát thương ngẫu nhiên (18 + 2 × bậc)% – (36 + 4 × bậc)% | Bị động: chí mạng; E 30% thêm 25% sát thương | Gần giống |
| Kim Đỉnh Phật Quang | - | Sát thương lên hệ Hỏa, sinh lực tối đa; Kim Đỉnh Miên Chưởng mạnh hơn, giãn cách −3 giây | Bị động: sinh lực | Gần giống |

Trước khi sửa: Q là đạn bay, E là nổ quanh thân 6 hit, Vạn Tướng Thần Công là buff giảm sát thương, Phật Quang Chiến Khí 30 giây (KVCT 300 giây).

### Thiên Nhẫn Kích (TNK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TNK"`; Q/W/E: `eiS`/`eiq`, `J9F`/`J9s`, `eA2`/`eAm`; chiêu bấm: `etc`/`eth`/`ets`, `eNi`/`eNQ`, `eHs`/`eHC`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map; bỏng = nhận thêm 50% sát thương (như KVCT).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tàn Dương Như Huyết | Q (autocast) | Đánh lan 100 tại chỗ mục tiêu, tối đa 7; 30% thọ thương 1 giây + 30% bỏng 1,5 giây; hút 10% sát thương thành sinh / nội lực | Như KVCT (hút 10% thành sinh lực) | Giống |
| Thiên Nhẫn Mâu Pháp | - | Bị động: chính xác, hỏa công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Liệt Hỏa Tinh Thiên | R | 10 ngọn mâu lửa (cách 0,2 giây) phóng 560 ra xung quanh, 50% bỏng 2 giây; hồi 2 giây | Nổ quanh thân 560, 10 nhịp cách 0,2 giây, tối đa 7; bỏng 50% 2 giây | Gần giống (vùng tròn thay vì từng ngọn mâu) |
| Ma Âm Phệ Phách | D | Kẻ địch trong 500 (tối đa 7): (45 + 5 × bậc)% bỏng 4 giây, (36 + 4 × bậc)% hỗn loạn 5 giây, tốc đánh −25% 8 giây; không sát thương | Nổ quanh thân 500 không sát thương, tối đa 7: bỏng + choáng (hỗn loạn) theo đúng tỉ lệ / thời gian | Gần giống (hỗn loạn = choáng; không giảm tốc đánh) |
| Bi Tô Thanh Phong | - | Đánh trúng: giảm kháng vật / né tránh / chính xác của kẻ địch 30 giây | Q/W/E trúng: kẻ địch nhận thêm 15% sát thương 4 giây | Gần giống |
| Thiên Ma Giải Thể | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Vân Long Kích | W (autocast) | Đâm thẳng 200 (rộng 120), tối đa 7; 35% thọ thương 1 giây + 35% bỏng 1,5 giây; hút 15% | Đạn bay 200, tối đa 7; như KVCT | Giống |
| Phi Hồng Vô Tích | F | Xung kích 920, đánh kẻ địch trên đường đi (240), 100% bỏng 2 giây; miễn sát thương / trạng thái khi xung kích; hồi 24 giây | Lướt 920, đánh quanh điểm cuối (200); bỏng 100% 2 giây; miễn khống chế 1 giây | Gần giống (đánh ở điểm cuối, không dọc đường) |
| Cửu Khúc Hợp Thương | - | D cho 5 giây, F cho 3 giây miễn sát thương + miễn trạng thái + chí mạng tối đa | Không có hiệu quả | Khác (chưa làm) |
| Vân Long Tam Hiện | - | Vật công, né đòn ngoại công, tốc đánh; F dùng liên tiếp 2 lần | Bị động: tốc đánh | Khác một phần (F chưa dùng 2 lần) |
| Giang Hải Nộ Lan | E (autocast) | Mâu đâm xuyên hình quạt, 2 đợt cách 0,3 giây, tối đa 7; 40% thọ thương 1 giây / 40% bỏng 1,5 giây; hút 20% | 3 đạn xòe 20°, 2 đợt cách 0,3 giây, 400, tối đa 7; đợt 1 thọ thương, đợt 2 bỏng; hút 20% | Gần giống |
| Ma Viêm Tại Thiên | - | Giảm sát thương nhận, chí mạng, sát thương chí mạng; E tăng tấn công | Bị động: giảm sát thương nhận + chí mạng; E 30% thêm 25% sát thương | Gần giống |
| Bích Nguyệt Phi Tinh | - | Sát thương lên hệ Kim, chính xác, vật công ngoại | Bị động: sát thương % | Gần giống |

Trước khi sửa: Q/W là quét nón, Ma Âm Phệ Phách là nổ 3 lần làm chậm (KVCT: bỏng + hỗn loạn, không sát thương), không có hút máu ở Q/W/E.

### Võ Đang Khí (VDQ) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="VDQ"`; Q/W/E: `J4l`/`J4d`, `JCU`/`JCO`, `JDp`/`JDG`; chiêu bấm: `JsC`/`Jsx`, `J9k`/`J9o`, `JfE` (Tọa Vọng Vô Ngã, xem Võ Đang Kiếm)), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (không đổi danh sách).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Bác Cập Nhị Phục | Q (autocast) | 2 đòn cách 0,18 giây tại chỗ mục tiêu, bán kính 150, tối đa 7; 30% choáng 1 giây | Như KVCT | Giống |
| Võ Đang Khí Công | - | Bị động: lôi công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Tọa Vọng Vô Ngã | D | Như Võ Đang Kiếm | Như Võ Đang Kiếm | Gần giống |
| Chân Vũ Thất Tiệt | - | Vòng sáng: vật công nội, chuyển sát thương thành nội lực | Bị động: sát thương % + hút nội lực | Gần giống |
| Thuần Dương Vô Cực | F | 85% nội lực hiện có thành hộ thuẫn (bằng !% nội lực tối đa), 20 giây; hồi 30 giây | Như KVCT: 85% nội lực → hộ thuẫn (20 + 5 × bậc)% nội lực tối đa, 20 giây | Giống |
| Thái Cực Vô Ý | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Thiên Địa Vô Cực | W (autocast) | 3 đòn cách 0,3 giây tại chỗ mục tiêu, bán kính 250, tối đa 7; 35% choáng 1 giây | Như KVCT | Giống |
| Vạn Kiếm Quy Tông | R | 5 đợt kiếm (+1 cho mỗi 2 kẻ địch) cách 0,1 giây lên kẻ địch trong 1000 (tối đa 10), 80% choáng 1 giây; sau đó 15 giây cộng tầng chí mạng khi đánh; hồi 30 giây | Nổ quanh thân 1000, 5 nhịp cách 0,1 giây, tối đa 10; choáng 80% 1 giây; buff chí mạng 15 giây | Gần giống (số đợt không tăng theo số địch; chí mạng không cộng tầng) |
| Võ Đang Cửu Dương | - | Mỗi 4400 nội lực hiện có +1% sát thương (tối đa !%), tỉ lệ choáng | Bị động: sát thương % | Gần giống |
| Bát Quái Du Long | - | Trong Thuần Dương Vô Cực bị đánh thì phản kích; hết hộ thuẫn thì chí mạng + miễn trạng thái 5 giây | Không có hiệu quả | Khác (chưa làm) |
| Cửu Cung Bát Quái | E (autocast) | 3 đòn cách 0,25 giây tại chỗ mục tiêu, bán kính 280, tối đa 7; 40% choáng 1 giây | Như KVCT | Giống |
| Thái Cực Thần Công | - | Lôi công; E 75%: Vô Ngã Vô Kiếm thêm 2 đòn | Bị động: sát thương %; E 75% thêm 2 đòn | Giống |
| Lưỡng Nghi Tâm Pháp | - | Sát thương lên hệ Thủy, lôi công, hồi nội lực; hết Thuần Dương Vô Cực thì vô địch 4 giây | Bị động: sát thương % + hồi nội lực | Khác một phần (chưa có vô địch khi hết hộ thuẫn) |

Trước khi sửa: Q/E dùng mô tả đoán, Thiên Địa Vô Cực là đánh 1 mục tiêu 3 hit, Vạn Kiếm Quy Tông là 1 lần nổ 1000.

### Côn Lôn Đao (CLD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CLD"`; Q/W/E: `JDF`/`JDs`, `Jxc`/`JxF`, `JDR`/`JDW`; chiêu bấm: `Jem`/`JeF`, `eZJ`/`eZf`, `JEU` (Thanh Phong Phù, xem Côn Lôn Kiếm)), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 12; thêm **Thanh Phong Phù (F)** dùng chung với Côn Lôn Kiếm).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Cuồng Phong Sậu Điện | Q (autocast) | Đao khí theo đường thẳng 800 (rộng 150), tối đa 7; 30% choáng 1 giây | Đạn bay 800, tối đa 7; choáng 30% 1 giây | Giống |
| Côn Lôn Đao Pháp | - | Bị động: chính xác, lôi công, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống |
| Thanh Phong Phù | F | Như Côn Lôn Kiếm | Như Côn Lôn Kiếm | Giống |
| Tụ Nguyên Thuật | R | 300 giây: sinh lực tối đa +% | Buff 300 giây: sinh lực | Gần giống |
| Nhất Khí Tam Thanh | D | 300 giây: vật công ngoại (+20% công cơ bản), chính xác | Buff 300 giây: sát thương % | Gần giống |
| Thiên Thanh Địa Trọc | - | Bị động: phát huy lực tấn công | Bị động: sát thương % | Gần giống |
| Ngạo Tuyết Tiếu Phong | W (autocast) | Đao khí 800 (rộng 180), tối đa 7, 35% choáng 1 giây; rồi Tiếu Phong Liên Kích thêm 2 đòn cách 1/6 giây | 3 đợt đạn bay 800 cách 0,17 giây, tối đa 7; choáng 35% 1 giây | Gần giống |
| Hồi Phong Phất Liễu | - | W/E trúng mục tiêu đầu tiên: phong trận 6 nhịp × 0,4 giây hút kẻ địch về tâm, 50% thọ thương; giãn cách 2,4 giây | Q/W/E 30% thêm 25% sát thương | Khác (chưa có phong trận hút) |
| Lưỡng Nghi Chân Khí | - | Hóa giải % sát thương; khi tấn công: 15 giây miễn trạng thái + hóa giải sát thương + tốc chạy +30, giãn cách 60 giây | Khi đánh: 15 giây miễn khống chế + buff giảm sát thương nhận + tốc chạy, giãn cách 60 giây | Gần giống |
| Phản Lưỡng Nghi Đao Pháp | - | Phong trận trúng địch: địch −20% sát thương 3 giây, bản thân tăng phát huy 3 giây | Không có hiệu quả | Khác (phụ thuộc phong trận, chưa làm) |
| Cửu Thiên Canh Phong | E (autocast) | Đao khí 1000 (rộng 200), tối đa 7, 40% choáng 1 giây; rồi Vô Tận Cương Phong thêm 3 đòn | 4 đợt đạn bay 1000 cách 0,17 giây, tối đa 7; choáng 40% 1 giây | Gần giống |
| Vô Nhân Vô Ngã | - | Bỏ qua né tránh, tốc đánh, kháng thời gian choáng; E tăng tấn công | Bị động: tốc đánh + kháng thời gian trạng thái; E 30% thêm 25% sát thương | Gần giống |
| Sương Ngạo Côn Lôn | - | Sát thương lên hệ Thủy, vật công ngoại, tấn công khi chí mạng | Bị động: sát thương % | Gần giống |

Trước khi sửa: Q/W là quét nón, E là nổ quanh thân, Nhất Khí Tam Thanh bị làm thành chiêu lướt (KVCT là buff 300 giây); thiếu Thanh Phong Phù.

### Thiếu Lâm Bổng (TLB) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TLB"`; Q `eHN`/`eHt`, W `JEQ`/`JEH`, E `J9P`/`J9w` + `J97`/`J9v`, R `JsO`/`JsB`, D `ed8`, F `eZY`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 10; thêm **Dịch Cân Kinh, A La Hán Thần Công, Như Lai Thiên Diệp** dùng chung với Thiếu Lâm Quyền / Đao). Trước đây Q là quét nón 2 đòn, W nổ 3 đợt, R nổ 4 đợt, E nổ 2 đợt, Bất Động Minh Vương / Như Ý là buff chung chung 300 giây.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; Bất Động Minh Vương và Như Ý Thúc Cốt Công trong KVCT là chiêu bật / tắt, map làm thành buff 300 / 180 giây.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Phổ Độ Côn Pháp | Q (autocast) | Sau 0,1 giây đánh 1 lần quanh chỗ mục tiêu đứng (bán kính 180, tối đa 7); 30% thọ thương 1 giây | Đánh lan 180 tại mục tiêu, tối đa 7, 30% thọ thương 1 giây (đòn đánh liền, không trễ 0,1 giây) | Giống |
| Thiếu Lâm Côn Pháp | - | Bị động: chính xác, vật công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống (không có chính xác / vật công %) |
| Dịch Cân Kinh | - | Bị động: sinh lực tối đa % | Bị động: sinh lực tối đa | Giống |
| A La Hán Thần Công | - | Hào quang phản đòn cận chiến / tầm xa | Bị động: phản đòn | Gần giống (không tách cận chiến / tầm xa) |
| Bất Động Minh Vương | D | Bật / tắt 300 giây: né tránh, chịu sát thương chí mạng −%, sát thương nhận vào −% | Buff 300 giây: giảm sát thương nhận | Gần giống (không bật / tắt, không có né tránh) |
| Như Lai Thiên Diệp | - | Bị động: phát huy lực tấn công, tỉ lệ thọ thương, kháng định thân | Bị động: sát thương % | Gần giống |
| Thất Tinh La Sát Côn | W (autocast) | Sau 1/6 giây quét 1 lần quanh thân (bán kính 300, tối đa 7); 35% thọ thương 1 giây | Nổ quanh thân 300, tối đa 7, 35% thọ thương 1 giây | Giống |
| Túy Tiên Bát Côn | R | 8 giây, mỗi 0,5 giây: hút tối đa 4 kẻ địch trong 800 về sát bản thân và tự tung Thất Tinh La Sát Côn (35% thọ thương); khi tung chiêu gắn thêm một trạng thái riêng (chưa rõ tác dụng) | 16 nhịp cách 0,5 giây quanh thân: hút tối đa 4 địch trong 800 và đánh | Gần giống (đánh các kẻ vừa hút thay vì quét 300 tối đa 7; chưa có trạng thái riêng khi tung) |
| Kim Cang Bất Hoại | - | Bị đánh khi sinh lực dưới 95%: 3 giây miễn sát thương, định thân, chậm, choáng, đẩy / kéo; giãn cách theo cấp, tối thiểu 10 giây | Cùng điều kiện 95%: 3 giây miễn sát thương và khống chế; giãn cách 15 giây | Gần giống (giãn cách cố định) |
| Như Ý Thúc Cốt Công | F | Bật / tắt 180 giây: sinh khí +, hóa giải % sát thương (tối đa 36% sinh lực) | Buff 180 giây: sinh khí, hóa giải sát thương, kháng trạng thái | Gần giống (không bật / tắt, không trần 36%) |
| Vi Đà Hiến Chử | E (autocast) | 2 lượt quét quanh thân cách 0,2 giây (bán kính 300, tối đa 7); 40% thọ thương 1 giây | 2 đợt nổ quanh thân cách 0,2 giây, tối đa 7, 40% thọ thương 1 giây | Giống |
| Ma Kha Vô Lượng | - | Bỏ qua né tránh; E 50% (+10%/cấp) thêm 1 nhát đâm 7 mục tiêu trên đường thẳng (7 bước × 0,2 giây, bán kính 120), 5% sát thương thành sinh lực | E có 30% thêm 25% sát thương (engine chung `fx 65536`) | Khác (không có nhát đâm đường thẳng 7 mục tiêu, không hút 5% sinh lực, không bỏ qua né tránh; cần mã mới để làm đúng) |
| Tẩy Tủy Kinh | - | Bị động: sát thương hệ Mộc, sinh khí, sức mạnh, phản đòn sát thương kỹ năng, chí mạng | Bị động: chí mạng + phản đòn | Gần giống (không có sát thương Mộc / sinh khí / sức mạnh) |

### Đoàn Thị Khí (DTK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DTK"`; Q `eSW`/`eSy`/`eST`, W `eNp`/`eNG`/`eNm`/`eNc`/`eNh`, R `erk`/`erD`/`era`, E `Jko`/`Jk4`/`JkJ`/`JkD`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q là quét nón 2 đòn, W 6 đạn thẳng không giãn cách, R quét nón 18 đòn, E 2 đạn.

Thêm vào engine (`kskill.j`, chỉ cộng thêm): khóa 183 "chiêu này tung kèm Q / W / E của tướng" (tung cùng lúc, khi trúng đòn có xác suất, hoặc khi sinh lực thấp; hàm `zzKS_Slot`, `zzKS_Near`). Dùng cho Khí Thôn Vạn Lý (kèm Lục Mạch Thần Kiếm), Lục Kiếm Tề Phát, Ám Hương Sơ Ảnh.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; đạn kiếm khí bay thẳng theo hướng lúc tung.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Kim Ngọc Mãn Đường | Q (autocast) | 3 kiếm khí song song bay 900 (rộng 120, 4 đạn từ cấp 4, 5 đạn từ cấp 7), mỗi đạn tối đa 7; 30% chậm 2 giây | Quạt 3 đạn bay 900 (góc 7°), tối đa 7 mỗi đạn, thêm đạn ở cấp 3 và 5; 30% chậm 2 giây | Gần giống (đạn tỏa quạt, không song song; mốc thêm đạn sớm hơn) |
| Đoàn Thị Tâm Pháp | - | Bị động: băng công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Bắc Minh Thần Công | - | Hào quang: hóa giải % sát thương (tối đa 36% sinh lực), kháng tỉ lệ tê liệt / hỗn loạn / đẩy kéo / thọ thương / định thân / bỏng | Bị động bản thân: hóa giải sát thương + kháng trạng thái | Gần giống (không phải hào quang, không tách từng kháng) |
| Lục Kiếm Tề Phát | - | Bị đánh khi sinh lực dưới 50%: 6 kiếm khí truy kích kẻ đang đánh, sát thương thành sinh lực; giãn cách 30 giây | Sinh lực dưới 50%: tung Lục Mạch Thần Kiếm vào kẻ địch gần nhất, giãn cách 30 giây | Gần giống (kẻ gần nhất thay vì kẻ đánh mình; không hút sinh lực) |
| Khô Vinh Thiền Công | - | Tốc đánh, băng công %; dưới 35% sinh lực bị đánh: 5 giây, mỗi 0,5 giây hồi % sinh lực; giãn cách 60 giây | Tốc đánh, sát thương %; dưới 35%: hồi 20% sinh lực một lần, giãn cách 60 giây | Gần giống (hồi một lần, tỉ lệ ước lượng) |
| Đoàn Gia Khí Kiếm | - | Bị động: phát huy lực tấn công (cơ bản + kỹ năng), tỉ lệ làm chậm, kháng bỏng | Bị động: sát thương % | Gần giống (không có tỉ lệ chậm / kháng bỏng) |
| Lục Mạch Thần Kiếm | W (autocast) | 6 kiếm khí, mỗi 0,21 giây một đạn, tự dẫn vào mục tiêu; tối đa 7 mỗi đạn; 35% chậm 2 giây; mỗi kiếm một hiệu quả: +40% công cơ bản, +40% ngũ hành, 11% bỏng 3 giây, 11% choáng 1 giây, 11% thọ thương 2 giây | 6 đạn cách 0,21 giây bay thẳng 800, tối đa 7, 35% chậm 2 giây | Gần giống (không tự dẫn, không có 5 hiệu quả riêng của từng kiếm) |
| Kinh Thiên Nhất Kiếm | R | 18 kiếm khí cách 0,1 giây (lệch ngẫu nhiên ±20°), bay 1200 (rộng 150), tối đa 5 mỗi đạn; đẩy lùi 120 và chậm 2 giây (code: 100%, mô tả ghi 80% / 50%) | 18 đạn cách 0,1 giây bay thẳng 1200, tối đa 5, chậm 100% 2 giây, đẩy lùi | Gần giống (không lệch ngẫu nhiên; mức đẩy lùi theo engine chung) |
| Bách Hồng Thực Nhật | - | Bị động: tốc đánh, tốc chạy, sinh lực tối đa %, chí mạng | Bị động: tốc đánh, tốc chạy, sinh lực, chí mạng | Giống |
| Luyện Khí Hoàn Thần | - | Mỗi 10 giây tạo khí cầu, chạm vào nhận chí mạng + sát thương chí mạng, cộng dồn 4 tầng, 60 giây | Bị động: chí mạng cố định | Khác (không có khí cầu / cộng dồn; cần mã mới) |
| Khí Thôn Vạn Lý | E (autocast) | 2 lưỡi kiếm cách 1/6 giây bay 1000 (rộng 100), tối đa 7 mỗi lưỡi, 40% chậm 2 giây; đồng thời tung Lục Mạch Thần Kiếm | 2 đạn cách 0,17 giây bay 1000, tối đa 7, 40% chậm 2 giây; tung kèm Lục Mạch Thần Kiếm (khóa 183) | Giống |
| Thiên Long Thần Công | - | Né tránh, kháng thời gian trạng thái ngũ hành; E thêm 1 thức đánh ngẫu nhiên 2 mục tiêu quanh thân (sát thương theo %) | Bị động: kháng trạng thái | Khác (không có né tránh, không có thức đánh ngẫu nhiên kèm E) |
| Ám Hương Sơ Ảnh | - | Mỗi giây +1 tầng (tối đa 21), mỗi 6 tầng khi tấn công tung 1 lần Lục Mạch Thần Kiếm; sát thương hệ Hỏa % | Khi đánh, mỗi 6 giây tung Lục Mạch Thần Kiếm (khóa 183) | Gần giống (không tích lũy nhiều lần, không có sát thương Hỏa %) |

### Thiên Vương Chùy (TVC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TVC"`; Q `eA8`, W `J3D`/`J3a`, E `JeC`/`Jex` + `Jek`, R `eOv`/`eO2`, D `eLJ`/`eL3`, F `eSh`, bị động `JdY`, `JKW`..`JKR`, `elz`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 12; thêm **Đoạn Hồn Thích (R)** dùng chung với Thiên Vương Đao). Trước đây Q là đánh đơn 3 đòn, W đánh đơn 3 đòn, E quét nón, D lướt 4 đòn, F buff 30 giây.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Hành Vân Quyết | Q (autocast) | 1 đòn quanh chỗ mục tiêu đứng (bán kính 150, tối đa 7); 35% thọ thương 1 giây | Đánh lan 150 tại mục tiêu, tối đa 7, 35% thọ thương 1 giây | Giống |
| Thiên Vương Chùy Pháp | - | Bị động: chính xác, vật công %, chí mạng | Bị động: sát thương %, chí mạng | Giống |
| Đoạn Hồn Thích | R | Lướt ≤700, không gây sát thương; quanh điểm đến (200, tối đa 7): định thân (30+6/cấp)% 3 giây, thọ thương (30+5/cấp)% 2 giây; 2 giây miễn trạng thái | Như Thiên Vương Đao | Giống |
| Thiên Vương Bản Sinh | - | Sinh lực tối đa %; bị đánh khi sinh lực ≤40% (xác suất 25+5/cấp %): 10 giây miễn sát thương và trạng thái, giãn cách 45 giây (Bất Khuất giảm giãn cách) | Sinh lực tối đa; sinh lực dưới 40%: 10 giây miễn sát thương và khống chế, giãn cách 45 giây, xác suất 35% cố định | Gần giống (không phải điều kiện "bị đánh", không có Bất Khuất, xác suất cố định) |
| Kim Chung Tráo | F | Mọi tướng phe ta trong 1000 (đồng đội 60%): kháng 4 hệ +(45+15/cấp), giảm thời gian thọ thương; 300 giây | Buff phe ta 300 giây: kháng + kháng trạng thái | Giống |
| Bất Diệt Sát Ý | - | Bị động: phát huy lực tấn công, hồi phục sinh lực, kháng định thân | Bị động: sát thương %, kháng trạng thái | Gần giống (không có hồi phục sinh lực) |
| Thừa Long Quyết | W (autocast) | 2 đòn cách 0,24 giây tại điểm cách thân 100 phía trước (bán kính 220, tối đa 7); 40% thọ thương 1 giây | 2 đợt nổ quanh thân 220 cách 0,24 giây, tối đa 7, 40% thọ thương 1 giây | Giống (tâm lệch 100 về phía trước, map lấy tại thân) |
| Trảm Long Quyết | D | Lướt ≤800; chạm đất bán kính 300: 100% thọ thương 2 giây, kéo 150 về tâm; rồi 4 đợt cách 0,5 giây (300, tối đa 7, thọ thương 1 giây) | Lướt ≤800, quanh điểm đến: 100% thọ thương 2 giây, kéo | Khác một phần (thiếu 4 đợt duy trì 0,5 giây; cần mã mới cho vùng sau lướt) |
| Càn Khôn Chùy | - | Mỗi lần bị đánh +1 tầng (tối đa cấp+5, 6 giây): +6% phát huy cơ bản / kỹ năng, −4% thời gian trạng thái | Cộng dồn tầng khi mình trúng đòn (+sát thương, chí mạng; tối đa 5 tầng, 6 giây) | Khác (map cộng dồn khi đánh, KVCT khi bị đánh) |
| Hóa Kinh Quyết | - | Vòng sáng: giảm sát thương nhận %; Tạ Kinh Quyết: kẻ địch gần (200) giảm 30% sát thương gây ra (không thấy code, có thể do aura object data) | Bị động: giảm sát thương nhận | Gần giống (không có giảm sát thương của kẻ địch gần) |
| Tung Hoành Tứ Hải | E (autocast) | 3 đợt cách 1/6 giây tại điểm cách thân 120 phía trước (bán kính 220, không giới hạn mục tiêu); 45% thọ thương 1 giây | 3 đợt nổ quanh thân 220 cách 0,17 giây, không giới hạn, 45% thọ thương 1 giây | Giống (tâm lệch 120 về phía trước, map lấy tại thân) |
| Đảo Hư Thiên | - | Sinh lực tối đa %; E 75% (một lần): giậm chân gây sát thương quanh thân 250 ở cả 3 đợt của E | Sinh lực tối đa; E 75% thêm 3 đợt nổ quanh thân | Gần giống (đợt thêm dùng bán kính 220 của E, không phải 250) |
| Thiên Mã Hành Không | - | Bị động: sinh khí, chí mạng tối thiểu / tối đa, sát thương hệ Mộc | Bị động: chí mạng | Gần giống (không có sinh khí / hệ Mộc) |

### Đường Môn Phi Đao (DMPD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DMPD"`; Q `Jsy`/`JsT`, W `JxA`/`JxM`, E `JFp`/`JFm`/`JFc`, R `e1W`/`e1z`, F `e1U`/`e1O`, D `eLG`, bị động `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Mê Ảnh Tung, Tôi Độc Thuật, Đường Môn Ám Khí dùng chung với Đường Môn Tụ Tiễn (đã đối chiếu ở đó). Trước đây Q là 2 đạn thẳng, W 3 đạn thẳng, E là chiêu lướt.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; trạng thái của mọi chiêu đánh là định thân 1 giây, kèm độc sát 2 nhịp (map dùng độc theo engine chung).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tiểu Lý Phi Đao | Q (autocast) | Phi đao bay 900 (rộng 100) xuyên tối đa 7 mục tiêu; 30% định thân 1 giây; độc 2 nhịp | Đạn bay 900, tối đa 7; định thân 30% 1 giây; độc | Giống |
| Đường Môn Ám Khí | - | Bị động: chính xác, độc công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống (không có chính xác / độc công %) |
| Mê Ảnh Tung | F | Lướt 300 + 40/cấp, giãn cách 10 giây; kèm Xuất Kỳ Bất Ý 5 giây (+12% + 3%/cấp phát huy lực tấn công, không làm mới khi còn) | Lướt 300 + 40/cấp; buff 5 giây | Giống |
| Tôi Độc Thuật | - | Hào quang: vật công, độc công %, sát thương chí mạng | Bị động bản thân: sát thương % + chí mạng | Gần giống (không phải hào quang) |
| Mãn Thiên Hoa Vũ | R | Tại điểm (tối đa 740 từ thân): 3 đợt cách 1 giây, bán kính 300, tối đa 7; 50% định thân 1 giây; độc 2 nhịp; đánh dấu Câu Hồn 10 giây nếu có Thực Cốt Huyết Nhẫn | Trận tại điểm ≤740: 3 nhịp cách 1 giây, 300, tối đa 7, 50% định thân 1 giây, độc | Giống (thiếu đánh dấu Câu Hồn) |
| Tâm Nhãn | - | Bị động: phát huy lực tấn công, tỉ lệ định thân, kháng choáng | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Nhiếp Hồn Nguyệt Ảnh | W (autocast) | Đánh tại chỗ mục tiêu đứng: 3 đợt cách 0,32 giây, bán kính 280, tối đa 7; 35% định thân 1 giây; độc chỉ ở đợt cuối (mô tả ghi "phóng đao tầm xa", code là vùng) | 3 đợt tại mục tiêu cách 0,32 giây, 280, tối đa 7, 35% định thân, độc ở mọi đợt | Giống (độc ở mọi đợt thay vì chỉ đợt cuối) |
| Hàm Sa Xạ Ảnh | - | Bị động: tốc đánh, chí mạng, độc sát % | Bị động: tốc đánh + chí mạng | Gần giống (không có độc sát %) |
| Thực Cốt Huyết Nhẫn | - | Mãn Thiên Hoa Vũ trúng: Câu Hồn 10 giây, Q / W / E gây thêm (13% + 2%/cấp) sát thương lên kẻ đó | Không có hiệu quả | Khác (chưa có đánh dấu Câu Hồn; cần mã mới) |
| Ảnh Tung Trận | D | 16 giây: miễn định thân, chậm, đẩy / kéo (và hai loại khác) ngay từ lúc bấm; né tránh nội / ngoại +(27+3/cấp)% khi đứng trong 500 quanh tâm; Mê Ảnh Tung còn giãn cách 0,2 giây; Xuất Kỳ Bất Ý giữ suốt trận | Miễn khống chế 16 giây + giảm sát thương nhận | Gần giống (né tránh thay bằng giảm sát thương; không có tâm trận, không có giãn cách 0,2 giây) |
| Vô Ảnh Xuyên | E (autocast) | Phi đao bay 1000, nổ ở địch đầu tiên (180, tối đa 7), rồi 3 lần nổ nữa cách 0,1 giây (tổng 4); 40% định thân 1 giây; độc chỉ ở lần đầu | 4 lần nổ cách 0,1 giây tại mục tiêu (180, tối đa 7), 40% định thân 1 giây, độc | Gần giống (nổ tại mục tiêu, không có phi đao bay; độc ở mọi lần) |
| Tâm Phách | - | Né tránh nội / ngoại công; E: 75% (một lần) đổi độc thành 6 nhịp (Độc Thích Cốt) | Bị động: né tránh | Gần giống (không có Độc Thích Cốt) |
| Bách Phát Bách Trúng | - | Bị động: sát thương hệ Thổ, sinh khí, thân pháp, tốc đánh | Bị động: tốc đánh + né / thân pháp | Gần giống (không có hệ Thổ / sinh khí) |

### Cái Bang Bổng (CBB) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CBB"`; Q `Ja8`/`JaR`/`JaW`, W `J0Y`/`J0W`/`J0y`, E `JaU`/`JaO`/`Jal`, R `J4w`..`J42`, D `e1i`, Đả Cẩu Trận `Jad`/`JaL`, Tung Hạc Công `Jef`/`Je0`/`Jfi`, Hoại Thương `J0z`, bị động `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Túy Điệp Cuồng Vũ dùng chung với Cái Bang Chưởng. Trước đây Q 2 đạn, W 3 đạn thẳng, E nổ 6 đợt quanh thân, R nổ quanh thân 12 đợt, D là buff sát thương.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trạng thái: bỏng (ena) và thọ thương (en9) suy từ thời gian khớp mô tả.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Bổng Đả Ác Cẩu | Q (autocast) | Gậy bay 800, nổ ở địch đầu tiên: bán kính 100, không giới hạn mục tiêu; 30% bỏng 1,5 giây và 30% thọ thương 1 giây. Số gậy theo cấp (1 / 2 / 3), nhưng trong code khóa số gậy có vẻ không bao giờ được ghi nên thực tế 1 gậy | Nổ tại mục tiêu 100, không giới hạn, 30% bỏng 1,5 giây + 30% thọ thương 1 giây (1 gậy) | Giống (không có đường bay 800) |
| Cái Bang Bổng Pháp | - | Bị động: chính xác, hỏa công, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Gần giống (không có chính xác) |
| Tiêu Dao Công | - | Bị động: né tránh, kháng phản đòn, tốc chạy, bỏ qua né tránh | Bị động: tốc chạy | Khác một phần (chưa có né tránh / bỏ qua né tránh) |
| Ác Cẩu Lan Lộ | R | 12 gậy tỏa đều mỗi 30°, bay 600 (rộng 100) xuyên mọi địch (mỗi địch 1 lần mỗi gậy); 50% bỏng 3 giây và 50% thọ thương 1 giây | 12 đạn tỏa đều, bay 600, xuyên; 50% bỏng 3 giây + 50% thọ thương 1 giây | Giống |
| Túy Điệp Cuồng Vũ | - | Hào quang: kháng tất cả, kháng thời gian thọ thương | Bị động bản thân: giảm sát thương + kháng trạng thái | Gần giống (không phải hào quang) |
| Bôn Lưu Đáo Hải | - | Bị động: phát huy lực tấn công, tăng tỉ lệ bỏng, kháng tỉ lệ thọ thương | Bị động: sát thương %, kháng trạng thái | Gần giống (không có tăng tỉ lệ bỏng) |
| Thiên Hạ Vô Cẩu | W (autocast) | 3 gậy bay song song, đuổi mục tiêu, tầm ~1000 (rộng 100), tối đa 7 mỗi gậy; gậy giữa 35% bỏng 1,5 giây, hai gậy bên 35% thọ thương 1 giây, sát thương đến trễ 0,4 / 0,6 giây | Quạt 3 đạn bay 1000, tối đa 7, 35% bỏng 1,5 giây + 35% thọ thương 1 giây trên mọi gậy | Gần giống (không tự đuổi, không tách trạng thái từng gậy, không trễ sát thương) |
| Đả Cẩu Bổng Pháp | - | Vật công, thời gian thọ thương; Hoại Thương: 35% nhân sát thương (1,12 + 0,08/cấp) mọi đòn của phái | Sát thương %; 30% thêm 25% sát thương (khóa chung) | Gần giống (xác suất và mức nhân theo engine chung) |
| Minh Sát Thu Hào | D | 300 giây: né tránh nội / ngoại công +(10 + 2/cấp)%; dùng lại chỉ làm mới | Buff 300 giây: giảm sát thương nhận (10 + 2/cấp)% | Khác một phần (engine không có chỉ số né tránh; dùng giảm sát thương thay) |
| Tung Hạc Công | - | Bị đánh khi sinh lực ≤95%: đẩy địch trong 400 ra 300; 15 giây miễn trạng thái, +né tránh; giãn cách 45 giây; hóa giải % sát thương | Sinh lực dưới 95%: 15 giây miễn khống chế, giãn cách 45 giây; giảm sát thương nhận | Gần giống (không đẩy lùi, không phải điều kiện "bị đánh", né tránh thay bằng giảm sát thương) |
| Bổng Quỷnh Lược Địa | E (autocast) | 3 gậy cách 1/6 giây, đuổi mục tiêu, tầm 1200 (rộng 110), tối đa 7; mỗi địch bị trúng tối đa 2 lần mỗi gậy; mỗi lần 40% bỏng 2 giây hoặc thọ thương 1 giây (một trong hai); gậy đầu có 75% tạo Đả Cẩu Trận | 3 đạn cách 0,17 giây bay 1200, tối đa 7; 40% bỏng 2 giây ở đợt 1, 40% thọ thương 1 giây ở đợt sau | Gần giống (không đuổi, mỗi địch 1 lần mỗi đạn, không có Đả Cẩu Trận) |
| Đả Cẩu Trận Pháp | - | Giảm sát thương nhận, chính xác; Đả Cẩu Trận: tại chỗ địch bị trúng, 3 giây mỗi 0,2 giây đánh 1 lần (bán kính 300, tối đa 7) | Bị động: giảm sát thương nhận | Khác (chưa có vùng Đả Cẩu Trận; cần mã mới) |
| Hỗn Thiên Khí Công | - | Bị động: sát thương hệ Kim, kháng tất cả, bỏ qua phòng thủ | Bị động: giảm sát thương nhận | Gần giống (không có hệ Kim / bỏ qua phòng thủ) |

### Nga My Kiếm (NMK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="NMK"`; Q `J30`/`JKi`/`JKQ`, W `eqw`/`eqv`/`eqV`, E `ed9`/`ede`/`edf`, R `Jfq`/`Jf6`, D `J0r`/`J0S`, Phật Tâm Từ Hựu `Jet`/`Jer`/`Jeq`, bị động `Jd8`, mật tịch `JlJ`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q 2 đạn, W 3 đạn, E 5 đạn đều có số đợt đúng nhưng không có tầm / giãn cách / số mục tiêu / chậm; R và D là buff 20 giây; các bị động đều là chỉ số đoán theo mô tả.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; trạng thái của Q / W / E là làm chậm.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thôi Song Vọng Nguyệt | Q (autocast) | 2 đạn cách 0,2 giây bay 600 (rộng 100) xuyên, tối đa 7 mỗi đạn; 30% chậm 2 giây | 2 đạn cách 0,2 giây bay 600, xuyên, tối đa 7; 30% chậm 2 giây | Giống |
| Từ Hàng Phổ Độ | R | Vùng cố định tại chỗ bán kính 500: mỗi đồng minh (tướng) nhận 4 lần hồi, mỗi giây một lần, (6 + 1/cấp)% sinh lực tối đa của người tung; 4 giây, giãn cách 8 giây | Buff phe ta: hồi một lần (10 + 2/cấp)% sinh lực tối đa của người nhận | Gần giống (hồi một lần thay vì 4 lần; bán kính 1000 của engine; hồi theo sinh lực người nhận) |
| Thiên Phật Thiên Diệp | D | Mọi tướng phe ta trong 1000 (đồng đội 60%), 1200 giây: hiệu quả của Mộng Điệp, Phật Tâm, Ba La, Thanh Âm, Thanh Tâm (mỗi cái không vượt cấp D) | Buff phe ta 1200 giây: giảm sát thương nhận + sinh lực tối đa | Gần giống (gộp thành 2 chỉ số, không tách từng hiệu quả) |
| Mộng Điệp | - | Qua D: hồi phục sinh lực / nội lực %; bản thân: băng công % | Bị động: sát thương % | Gần giống (không có hồi phục) |
| Phật Tâm Từ Hựu | - | Qua D: sinh lực / nội lực tối đa %; bị đánh thường khi sinh lực ≤40%: hồi 100% sinh lực, miễn trạng thái 3,8 + 0,2/cấp giây, giãn cách 45 giây | Sinh lực tối đa; sinh lực dưới 40%: hồi 100%, 4 giây miễn khống chế, giãn cách 45 giây | Gần giống (không phải điều kiện "bị đánh thường"; chưa có miễn sát thương nếu code có) |
| Ba La Tâm Kinh | - | Qua D: kháng tất cả; bản thân: phát huy lực tấn công, tỉ lệ chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Kiếm Ảnh Phật Quang | W (autocast) | 3 đạn cách 0,15 giây bay 900 (rộng 165) xuyên, tối đa 7 mỗi đạn; 35% chậm 2 giây | 3 đạn cách 0,15 giây bay 900, xuyên, tối đa 7; 35% chậm 2 giây | Giống |
| Thanh Âm Phạn Xướng | - | Qua D: kháng thời gian trạng thái | Bị động: kháng trạng thái | Gần giống |
| Thanh Tâm Tịnh Khí | - | Qua D: chịu sát thương chí mạng −%; bản thân: kháng chí mạng | Bị động: giảm sát thương nhận | Gần giống |
| Liên Hoa Tâm Kinh | - | Bị động: tốc đánh, băng công %, phát huy lực tấn công | Bị động: tốc đánh + sát thương % | Giống |
| Băng Sương Điện Phóng | E (autocast) | 5 kiếm tỏa hình sao (0, ±72, ±144°), kiếm đổi hướng một lần về phía mục tiêu rồi bay thẳng, tổng ~1080 (rộng 150), tối đa 7 mỗi kiếm; 40% chậm 2 giây | Quạt 5 đạn (góc 10°) bay 1080, xuyên, tối đa 7; 40% chậm 2 giây | Gần giống (không tỏa hình sao rồi quay lại, đạn xếp quạt hẹp) |
| Độ Nguyên Công | - | Nội công, sinh khí; E: +(10 + 2/cấp)% sát thương và hút 5% sinh lực | Sinh lực tối đa; E hút 5% sinh lực | Gần giống (chưa có +% sát thương của E) |
| Bế Nguyệt Phất Trần | - | Bị động: sát thương hệ Hỏa, vật công nội, tốc đánh, chí mạng | Bị động: tốc đánh + chí mạng | Gần giống (không có hệ Hỏa / vật công nội) |

Mật tịch của KVCT chưa làm: khi chịu sát thương chí tử hủy sát thương và hồi 50% sinh lực (giãn cách 300 giây), mỗi 5 giây hồi 8% sinh lực + nội lực.

### Minh Giáo Chùy (MGC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="MGC"`; Q `e6L`/`e6n`, W `etU`/`etO`, E `eqc`/`eqh`, R `e6Q`/`e6H`/`e6Z`, T `eS6`, D `eZM`/`eZ5`, F `egj`/`egU`, bị động `Jd8`, `Jp0`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu; trong code không có chiêu nào dùng chung hàm với Minh Giáo Kiếm hay Thiên Vương Chùy. Trước đây Q 1 đòn, W đánh đơn 3 đòn, R lướt chung, T buff 30 giây, D 3 đòn, F nổ quanh thân.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; độc sát 2 nhịp dùng độc của engine chung.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Khai Thiên Thức | Q (autocast) | Nổ bán kính 150 tại chỗ mục tiêu, không giới hạn mục tiêu; 30% thọ thương 1 giây; độc 2 nhịp | Nổ 150 tại mục tiêu, 30% thọ thương 1 giây, độc | Giống |
| Minh Giáo Chùy Pháp | - | Bị động: chính xác, độc công %, chí mạng | Bị động: sát thương %, chí mạng | Gần giống |
| Khốn Hổ Vân Tiếu | R | Lướt ≤700 (đánh 150 dọc đường, không khống chế); điểm cuối bán kính 200, tối đa 7: 50% định thân 2 giây + độc 4 nhịp, không sát thương trực tiếp | Lướt ≤700, đánh quanh điểm cuối: 50% định thân 2 giây + độc | Gần giống (không có đòn dọc đường; có sát thương ở điểm cuối) |
| Kim Qua Thiết Mã | T | Mọi tướng phe ta trong 1000 (đồng đội 60%): chí mạng +(16+8/cấp), sát thương chí mạng; 300 giây | Buff phe ta 300 giây: chí mạng | Gần giống (không có sát thương chí mạng riêng) |
| Phách Địa Thế | D | Đạn bay 960 (rộng 150) xuyên tối đa 7; 80% định thân 2 giây; mỗi mục tiêu sau +25% sát thương; độc 4 nhịp; tiêu hết tầng Địa Liệt thành các đợt sát thương phụ | Đạn bay 960, xuyên, tối đa 7; 80% định thân 2 giây; độc | Gần giống (không +25% theo thứ tự, không đợt phụ Địa Liệt) |
| Ngự Mã Thuật | - | Bị động: phát huy lực tấn công, kháng tất cả (code cộng vĩnh viễn, không kiểm điều kiện cưỡi ngựa) | Bị động: sát thương %, giảm sát thương | Giống |
| Long Thôn Thức | W (autocast) | Sau 0,3 giây nổ tại điểm cách thân 100 phía trước, bán kính 240, không giới hạn; 35% thọ thương 1 giây; độc 2 nhịp | Nổ quanh thân 240, không giới hạn, 35% thọ thương 1 giây, độc (không trễ 0,3 giây) | Giống (tâm lệch 100 về phía trước, map lấy tại thân) |
| Hồn Phách Phi Dương | F | 5 đạn song song bay 1000, không sát thương, gắn suy yếu 10 giây (kẻ địch gây −30% sát thương); bản thân +(12+3/cấp)% phát huy lực tấn công 6 giây | Chỉ buff bản thân 6 giây | Khác một phần (thiếu suy yếu −30% lên kẻ địch; cần mã mới) |
| Cửu Hi Hỗn Dương | - | Bị đánh thường khi sinh lực ≤50%: miễn trạng thái, hồi (15+5/cấp)% mỗi giây trong (2+cấp) giây; giãn cách 30 giây | Sinh lực dưới 50%: hồi 40% một lần, 3 giây miễn khống chế, giãn cách 30 giây | Gần giống (hồi một lần, không phải điều kiện "bị đánh thường") |
| Liệt Diệm Thao Thiên | - | Sinh lực tối đa %; né tránh hoàn toàn (8+cấp+cự li/22)% mọi sát thương trừ độc; mỗi 2 giây +1 tầng Địa Liệt (tối đa 7) | Sinh lực tối đa | Khác (chưa có né tránh theo cự li, chưa có tầng Địa Liệt) |
| Khu Hổ Thức | E (autocast) | 2 lượt quét cách 0,25 giây tại điểm cách thân 150 (280, tối đa 7); 40% thọ thương 1 giây; độc chỉ ở lượt 2 | 2 đợt nổ quanh thân 280 cách 0,25 giây, tối đa 7, 40% thọ thương 1 giây, độc | Giống (tâm lệch 150 về phía trước) |
| Trấn Ngục Phá Thiên Kinh | - | Giảm sát thương ngũ hành; E 40% tung thêm 3 đạn tỏa ±15° (tầm ~850, xuyên) và hồi 20% sinh lực | Bị động: giảm sát thương nhận | Khác (chưa có 3 đạn kèm E và hồi sinh lực) |
| Không Tuyệt Tâm Pháp | - | Bị động: sát thương hệ Thổ, vật công ngoại, bỏ qua né tránh, hóa giải trạng thái | Bị động: sát thương %, kháng trạng thái | Gần giống |

### Minh Giáo Kiếm (MGK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="MGK"`; Q `JEv`/`JEV`/`JE2`, W `JFk`/`JFD`/`JFa`/`JF4`/`JFJ`, E `JCv`/`JCp`/`JCG`, R `Jkz`/`Jkw`/`Jk7`, D `ely`, F `JEh`/`JEF`, Hoang Hỏa `JEG`, bị động `Jd8`, `JlJ`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu; không chiêu nào dùng chung với Minh Giáo Chùy. Trước đây Q là đạn thẳng, W / E là nổ quanh thân, R là nổ 8 đợt, F là nổ 2 đợt (sai chiêu), Hoang Hỏa Ngọc Phần là nổ 4 đợt.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; độc sát dùng độc của engine chung (KVCT: số nhịp độc tăng theo chiêu bị động, Thánh Hỏa Thần Công +1 nhịp).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thánh Hỏa Phần Tâm | Q (autocast) | Vùng lửa đứng yên tại chỗ mục tiêu: 4 nhịp cách 1 giây, bán kính 150, tối đa 7, mỗi địch chỉ trúng 1 lần; 30% định thân 0,5 giây; độc 3 nhịp (mô tả "thiêu đốt mục tiêu đi qua") | Vùng tại mục tiêu: 4 nhịp cách 1 giây, 150, tối đa 7, 30% định thân 0,5 giây, độc | Giống (map đánh lại cùng địch mỗi nhịp, KVCT chỉ một lần) |
| Minh Giáo Kiếm Pháp | - | Bị động: độc công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống (không có độc công %) |
| Di Khí Phiêu Tung | - | Bị động: tốc chạy, tỉ lệ né tránh nội công | Bị động: tốc chạy | Khác một phần (chưa có né tránh nội công) |
| Vạn Vật Câu Phần | W | Tại điểm (tối đa 740): 2 đợt cách 0,2 giây (200, tối đa 7, chỉ sát thương), rồi 6 ngọn lửa bay 600 (rộng 200, tối đa 7, mỗi địch 1 lần): 50% định thân 2 giây + độc 4 nhịp; giãn cách 5 − 0,1/cấp Nhân Huân Tử Khí | Vùng tại điểm ≤740: 2 đợt cách 0,2 giây, 200, tối đa 7, 50% định thân 2 giây + độc | Gần giống (không có 6 ngọn lửa bay ra; trạng thái ở cả 2 đợt) |
| Càn Khôn Đại Na Di | D | 15 giây: chuyển (8+2/cấp)% sát thương gây ra thành sinh lực, miễn choáng / định thân; mật tịch hồi 25% sinh lực + nội lực mỗi giây | 15 giây: hút sinh lực (8+2/cấp)% + miễn khống chế | Giống (chưa có mật tịch hồi 25%) |
| Ly Hỏa Đại Pháp | - | Bị động: phát huy lực tấn công cơ bản / kỹ năng, tỉ lệ định thân, kháng choáng | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Thánh Hỏa Liêu Nguyên | E (autocast) | Tại điểm (tối đa 740): lửa rơi 10 tick × 0,1 giây, đánh ở tick 6-10 bán kính 400, tối đa 10, mỗi địch 1 lần; 35% định thân 1 giây; độc 5 nhịp | Vùng tại điểm ≤740: 1 nhịp sau 0,6 giây, 400, tối đa 10, 35% định thân 1 giây, độc | Giống |
| Thánh Hỏa Lệnh Pháp | F | (7 + 0,5/cấp) giây: giãn cách Vạn Vật Câu Phần / Thánh Hỏa Liêu Nguyên / Kiếm Đãng Bát Hoang còn 0,3 giây; hết hạn trả lại | Chỉ hiệu ứng buff, không có tác dụng | Khác (chưa hạ giãn cách W / E / R; cần mã mới) |
| Nhân Huân Tử Khí | - | Độc công; giãn cách Vạn Vật Câu Phần −0,1 giây/cấp, Thánh Hỏa Liêu Nguyên −0,16 giây/cấp | Bị động: sát thương % | Khác một phần (chưa giảm giãn cách) |
| Hoang Hỏa Ngọc Phần | - | Mỗi nhịp độc có (8+cấp)% nhân sát thương nhịp đó ×(1,27+0,03/cấp) | 30% thêm 25% sát thương cho mọi chiêu (khóa chung) | Gần giống (không riêng nhịp độc, xác suất và mức nhân theo engine chung) |
| Kiếm Đãng Bát Hoang | R | Tại điểm (tối đa 740): 3 đợt cách 0,2 giây, bán kính 500, tối đa 10, không loại trùng; 40% định thân 1 giây; độc ở đòn cuối; giãn cách 10 − 0,3/cấp | Vùng tại điểm ≤740: 3 nhịp cách 0,2 giây, 500, tối đa 10, 40% định thân, độc | Giống |
| Thánh Hỏa Thần Công | - | Độc sát gây ra %; giãn cách R −0,3 giây/cấp; +1 nhịp độc của W / E / R | Bị động: sát thương % | Khác một phần (chưa giảm giãn cách R, chưa +1 nhịp độc) |
| Mục Dã Ưng Dương | - | Bị động: sát thương hệ Thổ, nội công, thời gian độc sát +% | Bị động: sát thương % | Gần giống |

### Đoàn Thị Chỉ (DTC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DTC"`; Q `JCC`/`JCx`, W `JaN`/`Jat`, E `JCN`/`JCt`, R `enA`/`enM`/`enX`, F `erl`/`erd`, D `egb`/`egN`/`egt`/`egS`, bị động `Jd8`, `JKH`/`JK1`, `JCq`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q là đánh đơn 2 đòn, R 2 đạn, F lướt, D 9 đạn thẳng, W / E đánh đơn 3 đòn.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trạng thái: thọ thương (en9), làm chậm (en4), định thân (enJ).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thần Chỉ Điểm Huyệt | Q (autocast) | 2 đợt cách 0,2 giây tại chỗ mục tiêu (100, tối đa 7); mỗi đợt 30% thọ thương 0,5 giây và 30% chậm 1 giây | 2 đợt tại mục tiêu cách 0,2 giây, 100, tối đa 7; đợt 1 thọ thương 30%, đợt 2 chậm 30% | Giống (map chia hai trạng thái theo đợt, KVCT áp cả hai mỗi đợt) |
| Đoàn Thị Chỉ Pháp | - | Bị động: chính xác, băng công %, chí mạng | Bị động: sát thương %, chí mạng | Gần giống |
| Nhất Dương Chỉ | R | 1 đạn bay 900 (rộng 150) xuyên, tổng tối đa 7; 80% định thân 3 giây; luôn bỏ qua né tránh | Đạn bay 900, tối đa 7, 80% định thân 3 giây | Giống (chưa có bỏ qua né tránh) |
| Lăng Ba Vi Bộ | F | 15 giây: tốc chạy +(45+5/cấp), né tránh nội / ngoại +(50+5/cấp)%, miễn thọ thương / chậm | Buff 15 giây: tốc chạy + kháng trạng thái | Gần giống (không có né tránh) |
| Từ Bi Quyết | - | Bị đánh khi sinh lực ≤50%: tự tung Lăng Ba Vi Bộ (theo cấp Từ Bi) 15 giây, giãn cách 60 giây | Không có hiệu quả | Khác (chưa tự tung F; cần mã mới vì khóa 183 chỉ gọi Q / W / E) |
| Kim Ngọc Chỉ Pháp | - | Bị động: phát huy lực tấn công, tỉ lệ chậm, kháng bỏng | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Cản Dương Thần Chỉ | W (autocast) | 3 đợt cách 1/6 giây quanh chỗ người dùng (250, tối đa 7); mỗi đợt 35% thọ thương 0,5 giây và 35% chậm 1 giây | 3 đợt quanh thân 250 cách 0,17 giây, tối đa 7; thọ thương ở đợt 1, chậm ở đợt sau | Giống |
| Huyền Băng Cửu Kiếp | D | Chọn điểm ≤800, 9 kim băng cách 0,25 giây đuổi mục tiêu, mỗi kim nổ 180 (không giới hạn), 80% chậm 3 giây; mật tịch nảy thêm kim | 9 đợt nổ 180 tại mục tiêu cách 0,25 giây, 80% chậm 3 giây | Gần giống (không có kim bay đuổi / nảy thêm; cần mục tiêu đơn vị) |
| Diệu Đề Chỉ | - | Khi tung R: 30 giây chính xác, chí mạng, phát huy lực tấn công cơ bản / kỹ năng | Bị động: chí mạng | Khác (chưa có buff khi tung R) |
| Thí Nguyên Quyết | - | Khi tự tung Q / W / E: 30 giây miễn định thân / tê liệt / hỗn loạn / đẩy kéo, hóa giải trạng thái; giãn cách 30 giây | Khi đánh: 30 giây miễn khống chế, giãn cách 30 giây; sát thương %, giảm sát thương | Gần giống (kích khi đánh thay vì khi tung chiêu; không hóa giải sẵn) |
| Thiên Long Thần Chỉ | E (autocast) | 3 đợt cách 1/6 giây tại chỗ mục tiêu (150, tối đa 7); mỗi đợt 40% thọ thương 0,5 giây và 40% chậm 1 giây | 3 đợt tại mục tiêu cách 0,17 giây, 150, tối đa 7; thọ thương đợt 1, chậm đợt sau | Giống |
| Càn Thiên Chỉ Pháp | - | E 30% (+20% mật tịch): 10 giây hóa giải + bỏ qua né tránh; E ×(1,18+0,02/cấp) | Giảm sát thương; E 30% thêm 25% sát thương | Gần giống |
| Bách Bộ Xuyên Dương | - | R đổi định thân thành điểm huyệt 100% 3 giây; E ×(1,32+0,04/cấp) lên kẻ bị điểm huyệt; sát thương hệ Hỏa | Bị động: sát thương % | Khác (chưa có điểm huyệt) |

### Cổ Mộ Châm (CMC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CMC"`; Q `Jav`/`Ja2`/`Jap`, W `Jxa`/`JxJ`, E `Jay`/`Jaz`, R `JkB`/`Jkl`/`Jku`, D `Jxu`/`JxY`/`JxR`, F `Joc`/`Joh`, T `JJo`, Súc Thế `eiV`/`eip`/`eim`, Hành Vân `eic`, Lưu Quang `eQe`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu; Q / W / E / R / D / F / T riêng của Cổ Mộ Châm, trong khi A0ML / A0MM / A0MN... thuộc Cổ Mộ Kiếm. Trước đây Q / W / E là chiêu mặc định theo mô tả, R lướt, D quạt nón, F nổ 20 đợt không giãn cách, T buff 20 giây.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trong KVCT "choáng" là `enD`; mỗi lượt châm chỉ có châm giữa gây sát thương (châm bên chỉ là hiệu ứng).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Biệt Tự | Q (autocast) | 2 châm cách 0,2 giây bay ~250 (rộng ~90), tối đa 7 mỗi châm; 30% choáng 1 giây | 2 đạn cách 0,2 giây bay 250, tối đa 7; 30% choáng 1 giây | Giống |
| Mộ Châm Pháp | - | Bị động: lôi công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Kinh Hồng Chiếu Ảnh | R | Lướt ≤720; lúc xuất phát quanh chỗ đứng (350, tối đa 10): 80% định thân 2 giây; buff Phi Hồng Đạp Tuyết 10 giây (né, miễn chậm); cuối đường 6 lượt mưa châm (không choáng) | Lướt ≤720, quanh điểm đến: 80% định thân 2 giây | Gần giống (định thân ở điểm đến thay vì điểm đầu; thiếu buff 10 giây và 6 lượt mưa châm) |
| Súc Thế Đãi Phát | - | Mỗi 5 giây buff 5 giây: sát thương 3 chiêu kế +(17+3/cấp)%, giảm sát thương nhận | Mỗi 5 giây khi đánh: buff 5 giây sát thương % + giảm sát thương | Gần giống (không giới hạn 3 chiêu, không kiểm "khi không tấn công") |
| Ngọc Phong Châm | D | Cần ≥2 tầng Thôn Tư (+2 mỗi 6 giây, tối đa 6); 7 châm cách 0,08 giây hình quạt ±24° bay 600 (rộng 120), tối đa 7 mỗi châm; 40% choáng 1 giây | Quạt 7 đạn bay 600, tối đa 7; 40% choáng 1 giây | Gần giống (không có tầng Thôn Tư; quạt đều thay vì lệch ngẫu nhiên) |
| Lưu Vân Pháp | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Ly Hận | W (autocast) | 3 đợt cách 0,2 giây, mỗi đợt bay 384 (rộng 100), tối đa 7; 35% choáng 1 giây | 3 đợt cách 0,2 giây bay 384, tối đa 7; 35% choáng 1 giây | Giống |
| Hoàng Tuyền Lảo Đảo | F | 5 giây, mỗi 0,25 giây đánh quanh chỗ bấm (360, tối đa 7), 20 lần; 30% choáng 1 giây | 20 đợt cách 0,25 giây quanh thân 360, tối đa 7; 30% choáng 1 giây | Giống (mật tịch tự tung khi ≤30% sinh lực chưa làm) |
| Hành Vân Đới Vũ | - | Lôi công %; khi dùng hết tầng Thôn Tư: 8 giây né tránh + miễn khống chế, giãn cách 30 giây | Bị động: sát thương % | Khác một phần (không có tầng Thôn Tư nên chưa có buff né tránh) |
| Vụ Tập Vân Hợp | T | Bật / tắt: Q / W / E / D chỉ trúng 1 mục tiêu; chí mạng +(175+25/cấp), sát thương chí mạng | Buff 300 giây: chí mạng | Gần giống (không giới hạn 1 mục tiêu, không bật / tắt) |
| Bi Sầu | E (autocast) | 3 đợt cách 0,2 giây bay 400 (rộng 100), tối đa 7; 40% choáng 1 giây; kèm Lưu Quang Tứ Xạ nếu có Phong Lưu Vân Tán | 3 đợt cách 0,2 giây bay 400, tối đa 7; 40% choáng 1 giây | Giống (thiếu Lưu Quang Tứ Xạ) |
| Phong Lưu Vân Tán | - | Lôi công %, chí mạng tối đa; E tung Lưu Quang Tứ Xạ lên 5 mục tiêu ngẫu nhiên (giãn cách 2 giây) | Bị động: sát thương %, chí mạng | Khác (chưa có Lưu Quang Tứ Xạ; cần mã mới) |
| Mê Thần Dẫn | - | Bị động: sát thương hệ Thủy, tốc đánh, né tránh; kẻ địch quanh thân giảm 20% lực tấn công | Bị động: tốc đánh + né / thân pháp | Gần giống (không có giảm lực tấn công địch quanh thân) |

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
