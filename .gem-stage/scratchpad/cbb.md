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
