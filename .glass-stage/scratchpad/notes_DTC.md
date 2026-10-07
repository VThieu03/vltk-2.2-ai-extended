# DTC (Đoàn Thị Chỉ) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. DTC = lớp sG==20 (hero có A0D9, dòng 81203-81211, `Kuz="DTC"` 81211). Bảng chiêu Ff dòng 81256-81273 (slot 13 trống).
Marker autocast K8h[20]=A0D9 (130621). Khối trúng đòn 127809-127822: B03N → `JCC` (Q), B03O → `JaN` (W), B03P → `JCN` (E). (Ai gắn buff B03N/O/P: hệ autocast chung, không lần theo.)
Chỉ số bị động: Jd8 nhánh sG==20 dòng 125872-125945. Mật tịch (sm) chỉ số: 129303-129318. AI tự cast (105356): F (slot4) nếu không có A0DI, R (slot3) "howlofterror", D (slot8) "fanofknives".
Quy ước: en9=thọ thương, en4=làm chậm, enJ=định thân, hX=true trước ftC = bỏ qua né tránh (suy từ mô tả R; chưa đọc ftC để xác nhận). Tick hẹn giờ: lần đánh đầu chạy SAU 1 chu kỳ.
Tất cả đòn nhiều lần: mỗi đợt quét lại vùng, tối đa 7 mục tiêu/đợt (cùng mục tiêu bị trúng mỗi đợt).
JKH (gọi khi tự thi triển Q/W/E, không gọi ở R/D): nếu có Thí Nguyên Quyết (slot10) và không có A0DW → kích hoạt JK1 (xem slot 10).

## 1. A0DB Thần Chỉ Điểm Huyệt – Q (slot1, autocast) — `JCC` (90927) / tick `JCx`
- Vùng cố định tại VỊ TRÍ mục tiêu lúc phát, bán kính 100; 2 đợt, chu kỳ 0.2 s (đợt 1 sau 0.2 s).
- Mỗi đợt/địch: thọ thương 30% 0.5 s (en9), làm chậm 30% 1 s (en4). Sát thương ftG(0.5+0.1/cấp, 1.0+0.2/cấp) + ft2(150+30/cấp).
- sm1: bật hX (bỏ qua né). Mô tả "Q tăng W 3%/cấp": đúng, nằm trong JaN (W ×(1+0.03×cấp Q)).

## 2. A0DE Đoàn Thị Chỉ Pháp – bị động (slot2)
- Jd8: JGd .15+.05/cấp, JGR 15+5/cấp, JG4(.8+.1/cấp, ob). Theo mô tả là chính xác%/băng công%/chí mạng – ánh xạ hàm→chỉ số CHƯA kiểm. sm2: sp +300 (sp = bỏ qua né tránh, suy từ JCq).

## 3. A0DO Nhất Dương Chỉ – R (slot3) — enq/en6 (hướng) + `enA` → đạn `enM` (43585) / tick `enX`
- 1 đạn thẳng theo hướng chỉ định (hoặc hướng mặt), 45/tick (1440/s), 900/45 = 20 tick → tầm 900; bán kính quét 150; xuyên, mỗi địch 1 lần, TỔNG tối đa 7 mục tiêu.
- Trúng: định thân 80% 3 s (enJ); luôn hX=true (bỏ qua né). Sát thương ftG(3.0+0.6, 5.0+1.0)/cấp + ft2(800+160/cấp). sm3: ×1.5.
- Nếu có Bách Bộ Xuyên Dương (slot14): THAY định thân bằng `enm(3)` = điểm huyệt 100% 3 s (Pause + timescale 0, buff A0X3/B074), không kiểm kháng/thủ lĩnh.
- Nếu có Diệu Đề Chỉ (slot9) và chưa có buff fka → `enj` (xem slot 9). Giãn cách 10 s chỉ ở object data.

## 4. A0DQ Lăng Ba Vi Bộ – F (slot4) — `erl`→`erd`(oY,cấp,15 s) (62650-62700) / tick `erL`
- 15 s: tốc chạy +(45+5×cấp) (fti, chỉ hero), FU và FJ +(50+5×cấp) (né nội/ngoại %), hn +1, kv +1 (miễn thọ thương/chậm – theo mô tả). sm4: thêm NW +1 (chưa rõ).
- Đang có buff KxP mà bấm lại → "stop" (không chồng). Giãn cách 45 s: object data. Mô tả "+!" và "@%" khớp công thức.

## 5. A0DR Từ Bi Quyết – bị động (slot5) — `erj`/`er5`/`erU` (62707-62740)
- Sự kiện EVENT_PLAYER_UNIT_ATTACKED, đơn vị bị đánh có A0DS (thêm khi học slot5). Điều kiện: HP ≤50% (ftY), không có A0DT (cờ hồi chiêu) và không đang Lăng Ba.
- Gọi erd với CẤP slot5 (không phải cấp F), 15 s; giãn cách 60 s (A0DT, đếm 1 s). Xác suất 100%. sm5: JGv +0.4 (chưa rõ).

## 6. A0DF Kim Ngọc Chỉ Pháp – bị động (slot6)
- JGO/JGU .08+.02/cấp (lực cơ bản/kỹ năng), kC .18+.02/cấp (tỉ lệ làm chậm, kC dùng trong en4), NT .18+.02/cấp (khả năng kháng bỏng). sm6: JG3(xa,+100), FR +0.3.

## 7. A0DC Càn Dương Thần Chỉ – W (slot7, autocast) — `JaN` (85289) / tick `Jat`
- Vùng cố định quanh VỊ TRÍ NGƯỜI DÙNG lúc phát, bán kính 250; 3 đợt chu kỳ 0.1667 s.
- Mỗi đợt: thọ thương 35% 0.5 s, làm chậm 35% 1 s. Sát thương ftG(0.5+0.1, 1.0+0.2)/cấp + ft2(150+30/cấp), ×(1+0.03×cấp Q). sm7 ×1.2. Mô tả "tăng E 3%/cấp": đúng (trong JCN).

## 8. A0DU Huyền Băng Cửu Kiếp – D (slot8) — `egb` (chọn mục tiêu) / `egN`→`egt` (58933) / `egr` / đạn `egS`→`egq`
- Chọn điểm ≤800 (quá → báo "Vượt quá cự li"); mục tiêu = địch trong 150 quanh điểm (ưu tiên TAUREN); không có → hủy.
- 9 đạn, mỗi 0.25 s (đạn 1 sau 0.25 s), xuất phát từ vị trí người dùng lúc đó, ĐUỔI mục tiêu 25/tick (800/s), tối đa 100 tick; nổ khi ≤90 hoặc hết giờ, hoặc mục tiêu chết (nổ tại chỗ). Mục tiêu chết → ngưng phóng đạn còn lại.
- Nổ: AoE bán kính 180, không giới hạn số mục tiêu, làm chậm 80% 3 s. Sát thương ftG(1.0+0.2, 2.0+0.4)/cấp + ft2(300+60/cấp). sm8 ×1.3.
- sm9 (lưu ý: kiểm sm slot 9, không phải 8): mỗi nổ phóng thêm 1 đạn hướng ngẫu nhiên (eg6) tầm 600, bán kính 100, tối đa 4 mục tiêu, chậm 80% 3 s, cùng sát thương.

## 9. A0DP Diệu Đề Chỉ – bị động (slot9) — `enj` (từ enA)
- Khi thi triển R, nếu chưa có buff fka: 30 s (mô tả 28 s – KHÁC): ft1 0.3+0.1/cấp (chính xác), ft6 32+8/cấp (chí mạng), ftH và ftQ 0.13+0.02/cấp (lực cơ bản/kỹ năng). Không làm mới khi đang có. Jd8 slot9 không cộng chỉ số thường.

## 10. A0DV Thí Nguyên Quyết – bị động (slot10) — `JKH`→`JKZ`/`JK1` (74376)
- Chỉ số thường: JGO/JGU .1+.02/cấp, JGB .08+.02/cấp (giảm sát thương nhận). sm10: JG4 +2.0, sp +300.
- Kích hoạt: tự thi triển Q/W/E (kể cả autocast), không có A0DW → buff bg 30 s: b6, Rp, FW, Sj +1 (miễn định thân/tê liệt/hỗn loạn/đẩy kéo – theo mô tả), gỡ B006, B00B, B00C (hóa giải). Giãn cách 30 s (A0DW). Xác suất 100%.

## 11. A0DD Thiên Long Thần Chỉ – E (slot11, autocast) — `JCN` (91661) / tick `JCt`
- Vùng cố định tại vị trí mục tiêu, bán kính 150; 3 đợt chu kỳ 0.1667 s. Thọ thương 40% 0.5 s, chậm 40% 1 s.
- Sát thương ftG(0.85+0.17, 1.65+0.33)/cấp + ft2(240+48/cấp), ×(1+0.03×cấp W); sm11 ×1.2; có slot12 ×(1.18+0.02×cấp12).
- Địch có B074 (điểm huyệt) và có slot14: ×(1.32+0.04×cấp14).

## 12. A0DX Càn Thiên Chỉ Pháp – bị động (slot12)
- Chỉ số: JGW .13+.02/cấp, ZW +4+1/cấp (ZW = hóa giải sát thương %, suy từ JCq).
- Khi phát E (o6==0): xác suất 30%+20%×sm12, nếu chưa có buff Z7 → `JCq`: 10 s ZW +20, sp +1500 (bỏ qua né). Mô tả nói "Duy trì 10 giây" – khớp.

## 14. A0X4 Bách Bộ Xuyên Dương – bị động (slot14)
- Chỉ số: Evj +0.01/cấp (sát thương lên hệ Hỏa). R → điểm huyệt 3 s (xem 3). E ×(1.32+0.04/cấp) với mục tiêu đang bị điểm huyệt.
