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
