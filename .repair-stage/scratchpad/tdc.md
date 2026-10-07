### Tiêu Dao Chưởng (TDC) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TDC"`; Q `JD6`/`JDg`, W `J4S`/`J4q`, E `J4Q`/`J41`/`J4N`, R `eAU`/`eAl`/`eAd`, D `eiK`/`eQi`/`eQQ`/`eQZ`, F `J0Q`/`J0Z`, T `Jfb`/`Jf1`, bị động `eid`, `eBA`, `egu`, `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q quét nón 2 đòn, R 4 đòn một mục tiêu, W / E đánh đơn, D nổ 12 đợt quanh thân, F nổ 6 đợt, T lướt chung.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trạng thái của cả phái là bỏng (ena) 2 giây, riêng R là định thân.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Dương Ca Thiên Quân | Q (autocast) | 2 đợt cách 0,2 giây tại chỗ mục tiêu (150, tối đa 7); 30% bỏng 2 giây | 2 đợt tại mục tiêu cách 0,2 giây, 150, tối đa 7; 30% bỏng 2 giây | Giống |
| Tiêu Dao Chưởng Pháp | - | Bị động: hỏa công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Hàn Tụ Huyệt | R | Chọn ngẫu nhiên 1 địch trong 1200, đạn đuổi tới; chạm: vùng 300 (tối đa 7) 90% định thân 3 giây, 1 đòn rồi 3 đòn cách 1 giây (4 đòn) | 4 đòn cách 1 giây lên 1 địch ngẫu nhiên trong 1200, 90% định thân 3 giây | Gần giống (không có đạn đuổi, không có vùng 300; mỗi đòn chọn lại địch ngẫu nhiên) |
| Sưu Hồn Đại Pháp | - | Né tránh; bị đánh khi sinh lực ≤50%: vùng 400 hỗn loạn (50+4/cấp)%, 1 + 6 đòn cách 0,5 giây, hút 100% sát thương; giãn cách 30 giây | Bị động: tốc chạy / né | Khác (chưa có đòn khi sinh lực thấp) |
| Diệm Nguyên Luân Hồi | - | Kháng phản đòn, hỏa công %; mỗi 10 giây buff 8 giây: giảm sát thương (35+5/cấp)%, miễn 3 loại trạng thái; mất sau 3 lần bị nhắm đánh (mô tả ghi 2) | Mỗi 10 giây khi đánh: buff 8 giây giảm sát thương (35+5/cấp)% | Gần giống (không mất sau số lần bị đánh, không miễn trạng thái) |
| Phục Nhật Xuất Vân | - | Bị động: phát huy lực tấn công, tỉ lệ bỏng, kháng thọ thương | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Bạch Nhật Sâm Thần | W (autocast) | 3 đợt (mô tả ghi 2) cách 0,2 giây tại chỗ mục tiêu (250, tối đa 7); 35% bỏng 2 giây | 3 đợt tại mục tiêu cách 0,2 giây, 250, tối đa 7; 35% bỏng 2 giây | Giống |
| Sinh Tử Phù | D | Tại điểm ≤800: 15 đợt cách 0,2 giây, mỗi đợt 3 bùa bay ra 800 (rộng 100) lệch 120°, tối đa 7 mỗi bùa; 50% bỏng 2 giây; mỗi trúng +1 tầng (+3%+1%/cấp phát huy, 6 giây, tối đa 15) | Vùng tại điểm ≤800: 15 nhịp cách 0,2 giây, bán kính 450, tối đa 7, 50% bỏng 2 giây | Gần giống (vùng tròn thay vì bùa bay ra; chưa có cộng dồn tầng) |
| Hỗn Nhật Khí Quyết | - | Giảm sát thương ngũ hành, kháng trạng thái; mỗi lần Q / W / E +1 tầng Bát Hoang Lục Hợp (10 giây, tối đa 10): hồi phục, kháng thời gian trạng thái | Bị động: giảm sát thương + kháng trạng thái | Khác một phần (chưa có tầng Bát Hoang Lục Hợp) |
| Thiên Tàm Cửu Biến | F | 15 giây: tốc chạy +30; mỗi 0,5 giây 3 địch đầu tiên trong 1500 mỗi con 1 đạn đuổi, nổ 150 (tối đa 4), hút 15% sinh lực | 15 giây, mỗi 0,5 giây đánh tối đa 3 địch trong 800 quanh thân, hút 15% sinh lực | Gần giống (không có đạn đuổi, không có tốc chạy +30) |
| Bài Sơn Đảo Hải | E (autocast) | 3 chưởng đuổi mục tiêu bay ~1000 (rộng 160), tối đa 7 mỗi chưởng; 40% bỏng 2 giây | Quạt 3 đạn bay 1000, tối đa 7; 40% bỏng 2 giây | Gần giống (đạn không tự đuổi) |
| Thái Hư Thần Công | - | Hỏa công %; E: 75% Bài Vân Chưởng quanh mục tiêu (200, tối đa 7) khi chưởng đầu tới nơi | Bị động: sát thương %; E 75% thêm một đợt nổ | Gần giống (đợt nổ thêm quanh người dùng, không phải quanh mục tiêu) |
| Tung Bộ Quan Hỏa | T | Nhảy ≤700 (miễn sát thương / trạng thái khi nhảy); đáp: 4 giây chí mạng +(265+35/cấp), sát thương chí mạng +20%, chí mạng tối đa +25 | Lướt ≤700 không sát thương; đáp: 4 giây chí mạng | Gần giống (không miễn trạng thái khi nhảy, không có sát thương chí mạng riêng) |
