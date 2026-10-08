### Hoa Sơn Khí (HSQ) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="HSQ"`; Q `JEM`/`JEX`, W `e1L`/`e1n`/`e1u`, E `eZN`/`eZt`/`eZr`, R `elj`/`el5`/`elU`, D `JfU`/`JfO`, Hải Nạp `eAw`/`eA7`/`eAv`, Khí Quán `eq3`, Thần Quang `eZq`/`eZ6`, Tử Khí `elO`/`elB`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q là đánh đơn 2 đòn, R là hộ thuẫn 20 giây, D buff sát thương, W / E mặc định theo mô tả.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Nội lực là yếu tố chính của phái (Khí Quán, Hải Nạp, Tử Hà) nhưng map không có cơ chế sức mạnh theo % nội lực.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thanh Vân Tống Sảng | Q (autocast) | 2 đợt cách 0,2 giây tại chỗ mục tiêu (150, tối đa 7); 30% choáng 1 giây | 2 đợt tại mục tiêu cách 0,2 giây, 150, tối đa 7; 30% choáng 1 giây | Giống |
| Hoa Sơn Khí Công | - | Bị động: lôi công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Long Nhiễu Thân | - | Bị động: tốc chạy, kháng thời gian chậm, kháng băng công | Bị động: tốc chạy + kháng trạng thái | Gần giống |
| Chân Khí Hộ Thể | R | 5 giây: giảm sát thương (35+5/cấp)%, kháng trạng thái (25+5/cấp)%; hết hạn: 100% choáng 3 giây mọi địch quanh thân 500 | Buff 5 giây: giảm sát thương (35+5/cấp)% | Gần giống (thiếu choáng khi hết hạn, thiếu kháng trạng thái, không trần 36% sinh lực) |
| Hải Nạp Bách Xuyên | - | Mỗi 3 giây nếu nội lực >70%: gỡ trạng thái xấu, +kháng 8 chỉ số 3 giây; lôi công % | Bị động: sát thương %, kháng trạng thái | Khác một phần (không có điều kiện nội lực, không gỡ trạng thái) |
| Khí Chấn Sơn Hà | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Ma Vân Kiếm Khí | W (autocast) | Tại chỗ mục tiêu: đợt chính sau ~0,64 giây (300, tối đa 7, 35% choáng 1 giây), rồi 3 đợt Ma Vân Khí Công cách 0,5 giây (300, tối đa 7, không choáng) | 4 đợt tại mục tiêu cách 0,5 giây, 300, tối đa 7; choáng 35% ở đợt đầu | Giống (đợt đầu đánh ngay, không trễ 0,64 giây) |
| Khí Quán Trường Hồng | - | Sát thương kỹ năng +10% mỗi 10% nội lực (tối đa +15%+2%/cấp), tốn 10% nội lực hiện tại mỗi lần | Bị động: sát thương % cố định | Khác (không tính theo nội lực) |
| Tử Hà Chân Khí | D | 20 giây: lôi công +(80+20/cấp)%, mỗi giây hồi (18+2/cấp)% nội lực tối đa, miễn 4 trạng thái | 20 giây: sát thương % + hồi nội lực một lần + miễn khống chế | Gần giống (hồi nội lực một lần; mức tăng sát thương theo thang map) |
| Huyền Nhãn Yên Vân | - | Hải Nạp nhận thêm: hóa giải (8+2/cấp)% sát thương khi nội lực đầy (≤36% sinh lực) | Bị động: giảm sát thương nhận | Gần giống (không phụ thuộc nội lực) |
| Phách Thạch Phá Ngọc | E (autocast) | Một đợt tại chỗ mục tiêu sau 0,2 giây (240, tối đa 7, 40% choáng 1 giây); mỗi địch trúng thêm 3 đòn đơn mục tiêu cách 0,2 giây (Tử Khí Đông Lai) | 4 đợt tại mục tiêu cách 0,2 giây, 240, tối đa 7; 40% choáng 1 giây | Gần giống (3 đòn thêm là vùng chứ không đơn mục tiêu) |
| Thần Quang Toàn Nhiễu | - | Kháng thời gian trạng thái; E tung Long Huyền Kiếm Khí: 6 đợt cách 0,5 giây tại chỗ mục tiêu (300, tối đa 7) | Bị động: kháng trạng thái | Khác (chưa có Long Huyền Kiếm Khí; cần mã mới) |
| Tử Khí Đông Lai | - | Khi Chân Khí Hộ Thể kết thúc: 6,5 giây hồi 100% nội lực mỗi 0,5 giây, khuếch đại sát thương (33+3/cấp)%; lôi công % | Bị động: sát thương %, hồi nội lực định kỳ | Khác một phần (không gắn với kết thúc R) |
