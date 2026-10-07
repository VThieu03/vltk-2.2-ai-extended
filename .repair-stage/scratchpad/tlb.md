### Thiếu Lâm Bổng (TLB) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="TLB"`; Q `eHN`/`eHt`, W `JEQ`/`JEH`, E `J9P`/`J9w` + `J97`/`J9v`, R `JsO`/`JsB`, D `ed8`, F `eZY`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu (trước 10; thêm **Dịch Cân Kinh, A La Hán Thần Công, Như Lai Thiên Diệp** dùng chung với Thiếu Lâm Quyền / Đao). Trước đây Q là quét nón 2 đòn, W nổ 3 đợt, R nổ 4 đợt, E nổ 2 đợt, Bất Động Minh Vương / Như Ý là buff chung chung 300 giây.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; Bất Động Minh Vương và Như Ý Thúc Cốt Công trong KVCT là chiêu bật / tắt, map làm thành buff 300 / 180 giây.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Phổ Độ Côn Pháp | Q (autocast) | Sau 0,1 giây đánh 1 lần quanh chỗ mục tiêu đứng (bán kính 180, tối đa 7); 30% thọ thương 1 giây | Đánh lan 180 tại mục tiêu, tối đa 7, 30% thọ thương 1 giây (đòn đánh liền, không trễ 0,1 giây) | Giống |
| Thiếu Lâm Côn Pháp | - | Bị động: chính xác, vật công %, chí mạng, tốc đánh | Bị động: chí mạng + tốc đánh | Gần giống (không có chính xác / vật công %) |
| Dịch Cân Kinh | - | Bị động: sinh lực tối đa % | Bị động: sinh lực tối đa | Giống |
| A La Hán Thần Công | - | Hào quang phản đòn cận chiến / tầm xa | Bị động: phản đòn | Gần giống (không tách cận chiến / tầm xa) |
| Bất Động Minh Vương | D | Bật / tắt 300 giây: né tránh, chịu sát thương chí mạng −%, sát thương nhận vào −% | Buff 300 giây: giảm sát thương nhận | Gần giống (không bật / tắt, không có né tránh) |
| Như Lai Thiên Diệp | - | Bị động: phát huy lực tấn công, tỉ lệ thọ thương, kháng định thân | Bị động: sát thương % | Gần giống |
| Thất Tinh La Sát Côn | W (autocast) | Sau 1/6 giây quét 1 lần quanh thân (bán kính 300, tối đa 7); 35% thọ thương 1 giây | Nổ quanh thân 300, tối đa 7, 35% thọ thương 1 giây | Giống |
| Túy Tiên Bát Côn | R | 8 giây, mỗi 0,5 giây: hút tối đa 4 kẻ địch trong 800 về sát bản thân và tự tung Thất Tinh La Sát Côn (35% thọ thương); khi tung chiêu gắn thêm một trạng thái riêng (chưa rõ tác dụng) | 16 nhịp cách 0,5 giây quanh thân: hút tối đa 4 địch trong 800 và đánh | Gần giống (đánh các kẻ vừa hút thay vì quét 300 tối đa 7; chưa có trạng thái riêng khi tung) |
| Kim Cang Bất Hoại | - | Bị đánh khi sinh lực dưới 95%: 3 giây miễn sát thương, định thân, chậm, choáng, đẩy / kéo; giãn cách theo cấp, tối thiểu 10 giây | Cùng điều kiện 95%: 3 giây miễn sát thương và khống chế; giãn cách 15 giây | Gần giống (giãn cách cố định) |
| Như Ý Thúc Cốt Công | F | Bật / tắt 180 giây: sinh khí +, hóa giải % sát thương (tối đa 36% sinh lực) | Buff 180 giây: sinh khí, hóa giải sát thương, kháng trạng thái | Gần giống (không bật / tắt, không trần 36%) |
| Vi Đà Hiến Chử | E (autocast) | 2 lượt quét quanh thân cách 0,2 giây (bán kính 300, tối đa 7); 40% thọ thương 1 giây | 2 đợt nổ quanh thân cách 0,2 giây, tối đa 7, 40% thọ thương 1 giây | Giống |
| Ma Kha Vô Lượng | - | Bỏ qua né tránh; E 50% (+10%/cấp) thêm 1 nhát đâm 7 mục tiêu trên đường thẳng (7 bước × 0,2 giây, bán kính 120), 5% sát thương thành sinh lực | E có 30% thêm 25% sát thương (engine chung `fx 65536`) | Khác (không có nhát đâm đường thẳng 7 mục tiêu, không hút 5% sinh lực, không bỏ qua né tránh; cần mã mới để làm đúng) |
| Tẩy Tủy Kinh | - | Bị động: sát thương hệ Mộc, sinh khí, sức mạnh, phản đòn sát thương kỹ năng, chí mạng | Bị động: chí mạng + phản đòn | Gần giống (không có sát thương Mộc / sinh khí / sức mạnh) |
