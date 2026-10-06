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
