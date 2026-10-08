### Đường Môn Phi Đao (DMPD) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="DMPD"`; Q `Jsy`/`JsT`, W `JxA`/`JxM`, E `JFp`/`JFm`/`JFc`, R `e1W`/`e1z`, F `e1U`/`e1O`, D `eLG`, bị động `Jd8`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Mê Ảnh Tung, Tôi Độc Thuật, Đường Môn Ám Khí dùng chung với Đường Môn Tụ Tiễn (đã đối chiếu ở đó). Trước đây Q là 2 đạn thẳng, W 3 đạn thẳng, E là chiêu lướt.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; trạng thái của mọi chiêu đánh là định thân 1 giây, kèm độc sát 2 nhịp (map dùng độc theo engine chung).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Tiểu Lý Phi Đao | Q (autocast) | Phi đao bay 900 (rộng 100) xuyên tối đa 7 mục tiêu; 30% định thân 1 giây; độc 2 nhịp | Đạn bay 900, tối đa 7; định thân 30% 1 giây; độc | Giống |
| Đường Môn Ám Khí | - | Bị động: chính xác, độc công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống (không có chính xác / độc công %) |
| Mê Ảnh Tung | F | Lướt 300 + 40/cấp, giãn cách 10 giây; kèm Xuất Kỳ Bất Ý 5 giây (+12% + 3%/cấp phát huy lực tấn công, không làm mới khi còn) | Lướt 300 + 40/cấp; buff 5 giây | Giống |
| Tôi Độc Thuật | - | Hào quang: vật công, độc công %, sát thương chí mạng | Bị động bản thân: sát thương % + chí mạng | Gần giống (không phải hào quang) |
| Mãn Thiên Hoa Vũ | R | Tại điểm (tối đa 740 từ thân): 3 đợt cách 1 giây, bán kính 300, tối đa 7; 50% định thân 1 giây; độc 2 nhịp; đánh dấu Câu Hồn 10 giây nếu có Thực Cốt Huyết Nhẫn | Trận tại điểm ≤740: 3 nhịp cách 1 giây, 300, tối đa 7, 50% định thân 1 giây, độc | Giống (thiếu đánh dấu Câu Hồn) |
| Tâm Nhãn | - | Bị động: phát huy lực tấn công, tỉ lệ định thân, kháng choáng | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Nhiếp Hồn Nguyệt Ảnh | W (autocast) | Đánh tại chỗ mục tiêu đứng: 3 đợt cách 0,32 giây, bán kính 280, tối đa 7; 35% định thân 1 giây; độc chỉ ở đợt cuối (mô tả ghi "phóng đao tầm xa", code là vùng) | 3 đợt tại mục tiêu cách 0,32 giây, 280, tối đa 7, 35% định thân, độc ở mọi đợt | Giống (độc ở mọi đợt thay vì chỉ đợt cuối) |
| Hàm Sa Xạ Ảnh | - | Bị động: tốc đánh, chí mạng, độc sát % | Bị động: tốc đánh + chí mạng | Gần giống (không có độc sát %) |
| Thực Cốt Huyết Nhẫn | - | Mãn Thiên Hoa Vũ trúng: Câu Hồn 10 giây, Q / W / E gây thêm (13% + 2%/cấp) sát thương lên kẻ đó | Không có hiệu quả | Khác (chưa có đánh dấu Câu Hồn; cần mã mới) |
| Ảnh Tung Trận | D | 16 giây: miễn định thân, chậm, đẩy / kéo (và hai loại khác) ngay từ lúc bấm; né tránh nội / ngoại +(27+3/cấp)% khi đứng trong 500 quanh tâm; Mê Ảnh Tung còn giãn cách 0,2 giây; Xuất Kỳ Bất Ý giữ suốt trận | Miễn khống chế 16 giây + giảm sát thương nhận | Gần giống (né tránh thay bằng giảm sát thương; không có tâm trận, không có giãn cách 0,2 giây) |
| Vô Ảnh Xuyên | E (autocast) | Phi đao bay 1000, nổ ở địch đầu tiên (180, tối đa 7), rồi 3 lần nổ nữa cách 0,1 giây (tổng 4); 40% định thân 1 giây; độc chỉ ở lần đầu | 4 lần nổ cách 0,1 giây tại mục tiêu (180, tối đa 7), 40% định thân 1 giây, độc | Gần giống (nổ tại mục tiêu, không có phi đao bay; độc ở mọi lần) |
| Tâm Phách | - | Né tránh nội / ngoại công; E: 75% (một lần) đổi độc thành 6 nhịp (Độc Thích Cốt) | Bị động: né tránh | Gần giống (không có Độc Thích Cốt) |
| Bách Phát Bách Trúng | - | Bị động: sát thương hệ Thổ, sinh khí, thân pháp, tốc đánh | Bị động: tốc đánh + né / thân pháp | Gần giống (không có hệ Thổ / sinh khí) |
