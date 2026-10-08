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
