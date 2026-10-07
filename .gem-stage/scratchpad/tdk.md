### Tiêu Dao Kiếm (TDK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TDK"`; Q `JsY`/`JsR`/`JsW`, W `JCk`/`JCD`/`JCa`, E `J4A`/`J4X`/`J4j`, R `e_Q`/`e_Z`/`e_1`, D `eqW`/`eqy`/`eqT`, F `eik`/`ei9`, bị động `ell`/`elL`, `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q 2 đạn, R nổ quanh thân 4 đợt, W quét nón 3 đòn, D nổ quanh thân 12 đợt, E 4 đạn, F buff 25 giây.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trạng thái của Q / W / E: bỏng (ena) và thọ thương (en9).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Trảm Vân Kiếm | Q (autocast) | 1 kiếm khí (2 song song ở cấp 3, 3 ở cấp 6; code đọc khóa số đạn có vẻ không được ghi nên thực tế 1) bay 600 (rộng 110) xuyên mọi địch; 30% bỏng 2 giây + 30% thọ thương 0,5 giây | Quạt 2 đạn (thêm đạn ở cấp 3 / 5) bay 600, xuyên; 30% bỏng 2 giây + 30% thọ thương 0,5 giây | Giống (nhiều đạn hơn code thực tế) |
| Tiêu Dao Kiếm Pháp | - | Bị động: chính xác, hỏa công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Đan Phượng Dẫn | R | Vùng tại điểm ≤640, mỗi giây trong 10 giây: bán kính 350, tối đa 7, 50% định thân 1,5 giây + 50% bỏng 2,5 giây; mật tịch gắn buff ×1,2 sát thương lên địch | Vùng tại điểm ≤640: 10 nhịp cách 1 giây, 350, tối đa 7; nhịp đầu 50% định thân 1,5 giây, các nhịp sau 50% bỏng 2,5 giây | Gần giống (hai trạng thái chia theo nhịp thay vì cùng lúc; thiếu hồi sinh lực nếu có Bính Nhược Quan Hỏa) |
| Chân Hỏa Hộ Thể | - | Sinh lực tối đa, né tránh, kháng phản đòn; bị đánh thường khi sinh lực ≤50%: địch quanh 400 hỗn loạn 3 giây, 5 giây miễn trạng thái; giãn cách 31 − cấp giây | Sinh lực tối đa, tốc chạy; sinh lực dưới 50%: 5 giây miễn khống chế, giãn cách 30 giây | Gần giống (không hỗn loạn địch quanh) |
| Sơ Hoa Dẫn | F | Mọi tướng phe ta trong 1000, 30 giây: kháng phản đòn +(15+2/cấp)%, kháng thời gian trạng thái +(20+2/cấp)%; mỗi Q / W / E cộng tầng Hoa Khai Mạch (chí mạng, phát huy, tối đa 16 tầng 10 giây) | Buff phe ta 30 giây: kháng trạng thái + giảm sát thương | Gần giống (không có tầng Hoa Khai Mạch) |
| Đoản Ca Hành | - | Bị động: phát huy lực tấn công, tỉ lệ bỏng, kháng thọ thương | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Tê Chiếu Phồn Thương | W (autocast) | 3 đạn cách 0,2 giây (đạn 2 / 3 lệch ngẫu nhiên ±12°) bay 600 (rộng 120), tối đa 7 mỗi đạn; 35% thọ thương 0,5 giây + 35% bỏng 2 giây | 3 đạn cách 0,2 giây bay 600, tối đa 7; đạn 1 thọ thương 35%, đạn sau bỏng 35% | Giống (không lệch ngẫu nhiên; trạng thái chia theo đạn) |
| Kiếm Chủng Dẫn | D | Vùng tại điểm ≤640: mỗi 0,3 giây trong 7,5 giây (25 nhịp), bán kính 480, tối đa 7; 50% thọ thương 1 giây; Ngang Nhật Đồ cho Kiếm Tiếu | Vùng tại điểm ≤640: 25 nhịp cách 0,3 giây, 480, tối đa 7, 50% thọ thương 1 giây | Giống (thiếu Kiếm Tiếu) |
| Bính Nhược Quan Hỏa | - | Đan Phượng Dẫn kèm hồi (8+2/cấp)% sinh lực mỗi giây 4 giây; Hoa Khai Mạch +sát thương chí mạng | Bị động: sinh lực tối đa | Khác (không có hồi sinh lực khi dùng R) |
| Ngang Nhật Đồ | - | Bị động: hỏa công %, tốc chạy, né tránh; Sơ Hoa Dẫn thêm tốc đánh + chí mạng tối đa; D cho Kiếm Tiếu | Bị động: sát thương %, tốc chạy / né | Gần giống (không có hiệu quả riêng lên F / D) |
| Bách Điểu Triều Phượng | E (autocast) | 4 đạn song song lệch ngang cách 0,15 giây bay 800 (rộng 120), tối đa 7 mỗi đạn; 40% thọ thương 0,5 giây + 40% bỏng 2 giây | 4 đạn cách 0,15 giây bay 800, tối đa 7; đạn 1 bỏng 40%, đạn sau thọ thương 40% | Giống (không lệch ngang) |
| Phần Phách Tru Tâm | - | Chí mạng; E đánh trúng: tới 3 Kiếm Ngâm (75%, mỗi cái 4 giây, đánh mỗi 0,4 giây bán kính 250) | Chí mạng; E 75% thêm 3 đợt | Gần giống (đợt thêm của E thay vì kiếm đứng yên 4 giây) |
| Hỏa Hải Vô Nhai | - | Sát thương hệ Kim; khi đánh (giãn cách 60 giây): 30 giây, mỗi mục tiêu E trúng nhận thêm hỏa sát trễ 1 giây | Bị động: sát thương % | Khác (chưa có hỏa sát kèm E) |
