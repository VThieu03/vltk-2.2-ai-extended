### Thúy Yên Kiếm (TYK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TYK"`; Q `eQJ`/`eQ9`, W `edc`/`edh`/`edF`/`eds`, E `Jsw`/`Js7`/`Jsv`, R `edt`/`edr`/`edS`/`edq`, D `eHS`/`eHA`/`eHj`, F `edD`/`eda`/`edk`, bị động `Jd8`, `f5n`, `JdN`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu; Tuyết Ảnh và Hộ Thể Hàn Băng dùng chung với Thúy Yên Đao. Trước đây các số "hits" và loại chiêu chỉ là ước lượng (Q 2 đạn, W quét nón, E 3 đạn, R 8 đạn, D nổ 10 đợt, F buff 20 giây).

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Trong KVCT mọi đòn của phái nhân thêm 1 + ngẫu nhiên (0 … 0,24 + 0,02/cấp Phù Vân Tán Tuyết) vào băng công (map không có).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Phong Quyển Tàn Tuyết | Q (autocast) | 1 kiếm khí bay 750 (rộng 100) xuyên tối đa 7; 30% chậm 2 giây | Đạn bay 750, xuyên, tối đa 7; 30% chậm 2 giây | Giống |
| Thúy Yên Kiếm Pháp | - | Bị động: băng công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Tuyết Ảnh | - | Như Thúy Yên Đao | Như Thúy Yên Đao | Giống |
| Vũ Đả Lê Hoa | R | Đợt 1: 8 mảnh bay ra 500 (tối đa 4 mỗi mảnh; code hướng cố định theo bản đồ, xác suất chậm đợt 1 = 0% do lỗi); đợt 2 sau 0,6 giây: 8 mảnh bay vào từ vòng 640, 80% chậm 4 giây; 4 giây hóa giải / miễn trạng thái | 2 đợt cách 0,6 giây, mỗi đợt quạt 8 đạn bay 500, tối đa 4; 80% chậm 4 giây (cả hai đợt); 4 giây miễn khống chế | Gần giống (đợt 2 bay ra thay vì bay vào; đợt 1 cũng chậm; hướng theo người dùng) |
| Hộ Thể Hàn Băng | - | Như Thúy Yên Đao: sinh lực tối đa, dưới 40% đóng băng địch | Như Thúy Yên Đao | Giống |
| Băng Cốt Tuyết Tâm | - | Bị động: phát huy lực tấn công, tỉ lệ chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Băng Tâm Tiên Tử | W (autocast) | 1 kiếm khí bay ~912 (rộng 100) xuyên tối đa 7; mỗi địch trúng nhận đòn thứ 2 sau 0,3 giây; 35% chậm 2 giây | 2 đợt cách 0,3 giây bay 912, xuyên, tối đa 7; 35% chậm 2 giây | Giống |
| Phi Tự Phiêu Hoa | D | Tại điểm ≤740: 26 nhịp cách 0,3 giây, bán kính 300, tối đa 7; băng công ngẫu nhiên; 50% chậm 3 giây + 50% định thân 1 giây | Vùng tại điểm ≤740: 26 nhịp cách 0,3 giây, 300, tối đa 7; nhịp đầu 50% chậm 3 giây, nhịp sau 50% định thân 1 giây | Giống (hai trạng thái chia theo nhịp thay vì cùng lúc) |
| Phù Vân Tán Tuyết | - | Vật công nội, né tránh, phát huy lực tấn công; nhân ngẫu nhiên 0 – 24% băng công mọi đòn | Bị động: sát thương %, tốc chạy / né | Khác một phần (không có hệ số ngẫu nhiên) |
| Băng Tâm Ngọc Lăng | F | Bật / tắt không giới hạn: băng công +(160+20/cấp)%, hồi phục sinh lực; mỗi kẻ địch bắt đầu đánh bị phản (1000+200/cấp) băng công, không giãn cách | Buff 300 giây: sát thương % | Khác (chưa có phản đòn; không bật / tắt) |
| Thủy Ánh Mạn Tú | E (autocast) | 1 kiếm khí bay ~1100 (rộng 220), tối đa 7; 40% chậm 2 giây; mỗi địch trúng nhận thêm 3 đòn cách 0,25 giây (Phong Tuyết Băng Thiên) | 4 đợt cách 0,25 giây bay 1100, tối đa 7; 40% chậm 2 giây | Gần giống (3 đòn thêm là đạn chứ không đánh lên chính địch trúng) |
| Thập Diện Mai Phục | - | Kháng tỉ lệ trạng thái; E (50%, giãn cách 9 giây): tạo vùng Phi Tự Phiêu Hoa tại mục tiêu | Bị động: kháng trạng thái | Khác (chưa có vùng Phi Tự Phiêu Hoa kèm E) |
| Tuyết Ánh Hồng Trần | - | Sát thương hệ Hỏa, hồi phục; Q / W / E / R trúng: 40% chậm 100% 3 giây + 3 đòn băng sát mỗi giây | Bị động: sát thương %, sinh lực | Khác (chưa có băng sát) |
