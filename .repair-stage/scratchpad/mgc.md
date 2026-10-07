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
