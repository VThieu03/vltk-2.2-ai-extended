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
