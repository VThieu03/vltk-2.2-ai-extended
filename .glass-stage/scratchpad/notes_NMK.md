# NMK (Nga My Kiếm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. NMK = lớp sG==15 (dòng 80823: hero có A0A1). `Kuz="NMK"` dòng 80831; bảng chiêu Ff dòng ~80805-80819.
Marker autocast: K8h[15]=A0A1 (dòng 130616). Khối trúng đòn dòng 127739-127751:
- buff B02T → `J30` (Q), B02U → `eqw` (W), B02V → `ed9` (E). (Ai/xác suất gắn buff B02T/U/V: không lần theo, nằm ở hệ autocast chung.)
- Chỉ số bị động: Jd8 nhánh sG==15 dòng 125355-125440. Mật tịch (sm, JlJ) nhánh sG==15 dòng 129196-129234.
- AI tự cast (dòng 105297): D (slot3) nếu chưa có buff fyy=A0A8; R (slot2) khi JGa(oy)<50 (có lẽ %HP <50).

Quy ước: rF95=1/32 s. `en4(target,src,ke,k9)` = **làm chậm** (dummy A01B, order "slow", dòng 291/293): xác suất ke% ×(1+kC nguồn)/(1+ks+kF đích); thời gian k9 s (chia kháng). Bị chặn bởi k2/kV (% miễn) hoặc kv.
`ju1gh` = tỉ lệ hút máu của đòn ftC kế tiếp (lưu fEH, JGQ dòng 98821: hồi k3×sát thương, tối đa 30% HP max).

## 1. A0A5 Thôi Song Vọng Nguyệt – Q (slot 1, autocast) — `J30` (74483), đạn `JKi`/tick `JKQ`
- 2 đạn: 1 ngay + 1 sau 0.2 s (XF=1, fS5 J3E .2). Hướng = từ người dùng tới mục tiêu, xuất phát lùi trước 50.
- Đạn bay thẳng 24/tick (=768/s), sống eEody/ebftz = 600/24 = 25 tick → tầm 600. Quét bán kính 100, xuyên, mỗi địch 1 lần/đạn, tối đa 7 mục tiêu/đạn.
- Mỗi trúng: làm chậm 30% 2 s (en4 Xm=30); sát thương ftp(2.0+0.4/cấp) cơ bản + ft2(200+40/cấp). sm1 → ×1.2.
- Khớp mô tả (2 lần, 30%/2 s). Mô tả không nói xuyên/7 mục tiêu/tầm 600.

## 2. A0A6 Từ Hàng Phổ Độ – R (slot 2) — Jfq→`Jf6` (76212), `Jfg`/`JfA`/`JfM`/`JfX`
- Lượng hồi = (6%+1%/cấp) × HP max **của người thi triển**, mỗi 1 s, 4 lần (fYc=4).
- Vùng cố định tại chỗ cast, bán kính 500; quét lúc cast + mỗi 1 s trong 4 s (fYa=4): đồng minh **anh hùng** vào vùng lần đầu nhận 1 chuỗi hồi 4 tick (mỗi người chỉ 1 chuỗi). Tick đầu của chuỗi chạy sau 1 s.
- sm2: người nhận được k2 +100 (miễn trạng thái) cho tới tick đầu (~1 s) rồi gỡ.
- Giãn cách 8 s chỉ theo mô tả (không thấy trong code).

## 3. A0A7 Thiên Phật Thiên Diệp – D (slot 3) — J0r→`J0S` (73423), `J0g`, `J0A`, `J0q`
- Áp lên mọi đồng minh **anh hùng** trong 1000 quanh người cast (kể cả bản thân). Buff fyy=A0A8 (biểu tượng B02W), thời gian 1200 s (20 phút). Đồng đội nhận 60% (k3=.6).
- Mỗi hiệu quả theo cấp chiêu tương ứng nhưng **bị kẹp ≤ cấp D** (Evc):
  - slot4 Mộng Điệp: ftO(+0.1×cấp) (hiệu suất hồi phục; chỉ 1 hàm, không rõ HP/MP riêng)
  - slot5 Phật Tâm: ftj+ftM (+14%+2%/cấp HP max & MP max)
  - slot6 Ba La: ftT(0, 80+20/cấp) kháng tất cả (làm tròn số nguyên)
  - slot8 Thanh Âm: ftA(+16%+4%/cấp) (kháng thời gian trạng thái)
  - slot9 Thanh Tâm: ftr(+16%+4%/cấp) (giảm sát thương chí mạng nhận)
- Nếu mục tiêu đã có buff: gỡ buff (J0A hoàn chỉ số), sau 10 tick (0.3125 s) áp lại (làm mới).
- Bị động slot3 (Jd8): tốc đánh JGK 5 + 1/cấp.

## Bị động (Jd8 125355+ ; tên chỉ số suy từ hàm, không chắc 100%)
- 4 A0AA Mộng Điệp: JG4(0.8 + 0.1/cấp, ob) – băng công %.
- 5 A0AB Phật Tâm Từ Hựu: thêm A0AC → trigger `Jet`/`JeN` (77103): khi **bị đánh thường** (EVENT_PLAYER_UNIT_ATTACKED), không có A0AD (giãn cách), ftY(oy)<=40 (%HP) → `Jer`: giãn cách 45 s; `Jeq`: hồi 100% HP, k2 +100 (miễn trạng thái), FY +1 (miễn sát thương?), thời gian 3.8+0.2/cấp s. Khớp mô tả (40%, 45 s). Lưu ý: chỉ kích bằng đòn đánh thường, không bởi chiêu.
- 6 A0AG Ba La Tâm Kinh: JGO/JGU 0.08+0.02/cấp (phát huy cơ bản/kỹ năng), kC 0.18+0.02/cấp (tỉ lệ làm chậm – kC nhân xác suất trong en4).
- 8 A0AH: JGW 0.18+0.02/cấp. 9 A0AI: JG8 40+20/cấp (kháng chí mạng).
- 10 A0AL: JGO/JGU .1+.02, JG4 .8+.2 (băng %), JGK 10+1 (tốc đánh).
- 12 A0AM Độ Nguyên Công: JmQ/JmH 30/cấp (nội công/sinh khí); hiệu quả lên E xem dưới.
- 14 A0WW: JG9 265+35, JGR 60+20, JGK 8/cấp (không có giá trị khởi điểm), Evj +0.01/cấp. Ánh xạ JG9/JGR/Evj ↔ "vật công nội/chí mạng/sát thương lên Hỏa" KHÔNG chắc.
- Mật tịch (JlJ 129196): sm3 FV+.6; sm4 thêm A0A3 → `ebK` mỗi 5 s hồi 8% HP + 8% MP (ftl/ftB, dòng 66140); sm5 FW+1; sm6 kháng xa+100, FR+.3; sm8 k2+25 (miễn trạng thái 25%); sm9 A0AJ → khi chịu sát thương chí tử (dòng 98754): huỷ sát thương, `Jeg` hồi 50% HP, giãn cách 300 s; sm10 JG9+400; sm12 FY+.15.

## 7. A0AN Kiếm Ảnh Phật Quang – W (slot 7, autocast) — `eqw` (60598), `eqv`/tick `eqV`
- 3 đạn: 1 ngay + 2 cách 0.15 s (X6=2). Hướng tới mục tiêu, lùi trước 50.
- Bay 20/tick (640/s), sống mgspu/ije93=900/20=45 tick → tầm 900. Bán kính quét 165 ($A5), xuyên, tối đa 7/đạn.
- Làm chậm 35% 2 s; sát thương ftp(1.25+0.25/cấp) + ft2(250+50/cấp), ×(1+0.03×cấp Q). sm7 ×1.2. Gọi fUX (chưa rõ).
- Khớp mô tả (3 lần, 35%, "thẳng").

## 11. A0AO Băng Sương Điện Phóng – E (slot 11, autocast) — `ed9` (45034), `ede`/tick `edf`
- 5 kiếm khí hình sao: góc hướng mục tiêu +0, ±72, ±144. Bay 30/tick (960/s), tổng 900/30+6 = 36 tick (~1080).
- 6 tick đầu bay theo góc riêng (~180), tick thứ 6 **đổi hướng một lần** về vị trí hiện tại của mục tiêu (nếu mục tiêu chết → hướng ban đầu), rồi bay thẳng. Không bám liên tục.
- Bán kính 150, xuyên, tối đa 7/đạn. Làm chậm 40% 2 s. Sát thương ftp(1.0+0.2/cấp) + ft2(200+40/cấp), ×(1+0.03×cấp W); sm11 ×1.2.
- Có slot12 (Độ Nguyên Công): ×(1.1+0.02×cấp12) và hút máu 5% (ju1gh=.05). Mô tả "Sát thương chiêu +@%" khớp kiểu 10%+2%/cấp (suy).
