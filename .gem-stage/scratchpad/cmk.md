### Cổ Mộ Kiếm (CMK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="CMK"`; Q `JhM`/`JhX`/`Jhj`, W `JFb`/`JF1`/`JFN`, E `Jhe`/`Jhf`/`Jh3`/`JhK`, R `egy`/`egz`/`egw`, D `JD4`/`JDJ`/`JD9`, F `eH8`/`eHY`, bị động `JDx`, `J3X`, `ebf`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q là đạn thẳng 2 đòn, W quét nón 2 đòn, E đạn 3 đòn, R nổ quanh thân choáng 3 đợt, D quét nón, F lướt.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map. "Choáng" là `enD`. "2 lần" của Q / W / E là kiếm khí bay đi rồi quay lại (cùng một địch có thể trúng cả hai lượt).

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thu Nhạn Bàng Hoàng | Q (autocast) | Kiếm khí bay ~832 (rộng 100) xuyên mọi địch rồi quay lại; 30% choáng 1 giây | 2 lượt cách 0,81 giây bay 832, xuyên, không giới hạn; 30% choáng 1 giây | Giống (lượt về bay từ chỗ người dùng thay vì quay lại) |
| Kiếm Mộ Pháp | - | Bị động: chính xác, lôi công %, chí mạng, tốc đánh | Bị động: sát thương %, chí mạng, tốc đánh | Giống |
| Hồng Tụ Triền | R | Vùng bán kính 250 tại điểm ≤800, tick giây 2 / 4 / 6 / 8 (tối đa 7): (36+4/cấp)% choáng 1,5 giây; cast cho 3 tầng Tuyệt | Vùng tại điểm ≤800: 4 nhịp cách 2 giây, 250, tối đa 7, (36+4/cấp)% choáng 1,5 giây | Giống (thiếu tầng Tuyệt) |
| Tịnh Ảnh Trầm Bích | - | Mỗi 60 giây: đổi nội lực thành sinh lực tối đa (0,44+0,04/cấp) và hồi đầy sinh lực | Bị động: sinh lực tối đa | Khác một phần (chưa có chu kỳ 60 giây / hồi đầy) |
| Mộ Vân Ngưng Bích | - | Bị đánh thường khi sinh lực ≤50%: hộ thuẫn (0,6+0,2/cấp)× nội lực tối đa 5 giây, giãn cách 10 giây | Sinh lực dưới 50%: hồi 30% một lần, giãn cách 10 giây | Gần giống (hồi máu thay hộ thuẫn) |
| Ngọc Nữ Kiếm Pháp | - | Bị động: phát huy lực tấn công, tỉ lệ choáng, kháng chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Cô Nguyệt Bồi Hồi | W (autocast) | Như Q: bay ~832 (rộng 180) đi và về; 35% choáng 1 giây | 2 lượt bay 832; 35% choáng 1 giây | Giống |
| Chung Nam Vãn Chiếu | D | Tốn 2 tầng Tuyệt; kiếm khí bay ~952 (rộng 120), tối đa 7, mỗi địch 3 đòn, 50% choáng 1 giây, ép chí mạng / chính xác | 3 đợt cách 0,17 giây bay 952, tối đa 7; 50% choáng 1 giây | Gần giống (không tốn tầng Tuyệt, không ép chí mạng) |
| Hàn Sơn Độc Lập | - | Mỗi Q / W / E +1 tầng Cấm (chí mạng, khuếch đại sát thương); đủ 5 tầng tự tung D | Cộng dồn tầng khi đánh trúng (tối đa 5) | Khác (không tự tung D, tầng tính theo đòn trúng) |
| Phi Thiên Vũ | F | 12 giây: hóa giải (25+5/cấp)% sát thương (≤36% sinh lực mỗi đòn), miễn 5 trạng thái, giữ tầng Tuyệt / Cấm | Buff 12 giây: miễn khống chế + giảm sát thương | Gần giống (không giữ tầng, không trần 36%) |
| Cô Thân Chi Ảnh | E (autocast) | Kiếm khí bay 900 (rộng 200) đi và về; 40% choáng 1 giây; mỗi địch trúng lượt đi làm lượt về mạnh thêm | 2 lượt bay 900; 40% choáng 1 giây | Gần giống (lượt về không mạnh thêm) |
| Ngọc Nữ Tâm Kinh | - | Chí mạng, kháng chí mạng; E 65%: Phá Mộng Hành, mọi địch quanh địch đầu tiên (300) nhận 3 đòn cách 0,2 giây | Chí mạng, giảm sát thương; E 65% thêm 3 đợt | Gần giống (3 đợt thêm chạy theo chính E, không quanh địch đầu tiên) |
| Bạch Vân Hồi Vọng | - | Sát thương hệ Thủy, sát thương khi chí mạng, miễn chậm; E: lượt về mạnh thêm (0,16+0,02/cấp) mỗi địch trúng, tối đa ×2,2 | Bị động: chí mạng + kháng trạng thái | Khác một phần (chưa có lượt về mạnh thêm) |
