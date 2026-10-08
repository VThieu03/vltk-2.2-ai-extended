### Hoa Sơn Kiếm (HSK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="HSK"`; Q `J46`/`J4g`, W `Js2`/`JsG`/`Jsp`, E `JKF`/`JKC`/`JKk`, R `eSU`/`eSO`, D `eOy`/`eOP`, Phá Kiếm Thức `eH0`/`eHE`, Cửu Kiếm `e_F`/`e_C`/`e_x`, bị động `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu; Long Nhiễu Thân dùng chung với Hoa Sơn Khí. Trong KVCT chỉ Q và W là autocast (E là chiêu bấm), map vẫn để Q / W / E đều autocast theo yêu cầu. Trước đây Q quét nón, E nổ quanh thân 10 đợt, R / D là buff, W quét nón, Phá Kiếm Thức / Cửu Kiếm chỉ là chỉ số.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. Phá Kiếm Thức và Cửu Kiếm trong KVCT phát khi Q / W tung (giãn cách 5 và 4 giây); map làm thành tự phát 10% mỗi đòn đánh.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Bạch Hồng Quán Nhật | Q (autocast) | 2 đợt cách 0,24 giây tại chỗ mục tiêu (150, tối đa 7); 30% choáng 0,5 giây | 2 đợt tại mục tiêu cách 0,24 giây, 150, tối đa 7; 30% choáng 0,5 giây | Giống |
| Kiếm Tông Tổng Quyết | - | Bị động: chính xác, lôi công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Long Nhiễu Thân | - | Như Hoa Sơn Khí | Như Hoa Sơn Khí | Gần giống |
| Thiên Thân Đảo Huyền | E (chiêu bấm trong KVCT) | Rơi tại điểm chuột (≤600): 10 đợt cách 0,3 giây (15 nếu mật tịch), bán kính 300, tối đa 7; 40% choáng 0,5 giây | Vùng tại điểm ≤600: 10 nhịp cách 0,3 giây, 300, tối đa 7, 40% choáng 0,5 giây | Giống (autocast thay vì bấm theo yêu cầu) |
| Kim Nhạn Hoành Không | R | 20 giây: tốc đánh +(8+cấp), né tránh +(170+30/cấp), miễn hỗn loạn / chậm; mỗi giây mỗi địch quanh 800 cho thân 1 tầng Kiếm Vũ (+cấp% phát huy lực tấn công, +5 tốc đánh, tối đa 16 tầng; code không làm chậm địch dù mô tả ghi 15%) | Buff 20 giây: tốc đánh + kháng trạng thái | Gần giống (không có né tránh, không có tầng Kiếm Vũ) |
| Hi Di Kiếm Pháp | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Thương Tùng Nghênh Khách | W (autocast) | 3 kiếm khí song song cách 1/6 giây bay 600 (rộng 110) xuyên, tối đa 7 mỗi kiếm; 35% choáng 0,5 giây | 3 đạn cách 0,17 giây bay 600, xuyên, tối đa 7; 35% choáng 0,5 giây | Giống |
| Thái Nhạc Tam Thanh | - | Bị động: né tránh nội công, hóa giải trạng thái, giảm sát thương ngũ hành | Bị động: giảm sát thương + kháng trạng thái | Gần giống (không có né tránh) |
| Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm | D | Bật / tắt: mỗi 6 giây (lần đầu sau 6 giây) +(13+2/cấp)% sát thương 3 giây | Buff 300 giây: sát thương % thấp hơn, liên tục | Gần giống (không theo nhịp 6 giây, không bật / tắt) |
| Phá Kiếm Thức | - | Khi Q / W tung (giãn cách 5 giây): 3 đòn cách 0,5 giây quanh thân (350, tối đa 7), hút 5% sinh lực, 1 giây né tránh | Tự phát 10% mỗi đòn đánh: 3 đòn quanh thân 350, tối đa 7, hút 5% sinh lực | Gần giống (kích theo xác suất, không có né tránh 1 giây) |
| Cửu Kiếm Hợp Nhất | - | Khi Q / W tung (giãn cách 4 giây): 9 kiếm mỗi 40° bay 400 rồi đuổi mục tiêu (rộng 100, tối đa 7); 50% choáng 1 giây | Tự phát 10% mỗi đòn đánh: 9 đạn tỏa quạt 40°, bay 800, tối đa 7; 50% choáng 1 giây | Gần giống (không đuổi mục tiêu; kích theo xác suất) |
| Nhất Kiếm Phá Vạn Pháp | - | Chí mạng, sát thương chí mạng; Cửu Kiếm ×(1,16+0,04/cấp) và hút 5% | Bị động: chí mạng | Khác một phần (chưa tăng sát thương / hút máu của Cửu Kiếm) |
| Độc Cô Cửu Kiếm | - | Sát thương hệ Thủy, tốc đánh; 50%: thanh kiếm đầu tiên của Cửu Kiếm khi kết thúc nổ 150 gây (2+0,1/cấp)% sinh lực hiện tại | Bị động: tốc đánh | Khác (chưa có đòn chí tử %) |
