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
