# CMK (Cổ Mộ Kiếm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. CMK = lớp sG==34 (hero có marker A0MJ=$41304D4A, dòng 82266). `Kuz="CMK"` dòng 82274; bảng chiêu Ff dòng 82318-82341.
Slot: 1 A0ML(Q) 2 A0MO 3 A0MZ(R) 4 A0N7 5 A0N8 6 A0MP 7 A0MM(W) 8 A0N2(D) 9 A0N3 10 A0N6(F) 11 A0MN(E) 12 A0MY 14 A0XW.
Marker autocast: K8h[34]=A0MJ (130635). Khối trúng đòn dòng 127993-128006:
- buff B06A → `JhM` (Q), B06B → `JFb` (W), B06C → `Jhe` (E).
- Chỉ số bị động/tooltip: nhánh sG==34 dòng 127452-127545 (JdV = tham số tooltip). Mật tịch/cộng thêm k3: 129555-129572.
- AI tự cast (105624): F (slot10, "fanofknives") khi hết CD; D (slot8, "thunderclap") chỉ khi Tuyệt fGf>=2; R (slot3, "taunt") vào điểm.

Quy ước: rF95=1/32 s. `enD(target,chance,src,giây)` = **choáng** (suy từ khớp xác suất 30/35/40/50 và 1 s với mô tả; cũng dùng cho R 1.5 s). Xác suất ×(1+Nl nguồn)/(1+Fc+kF đích), thời gian ×(1+Nd)/(1+FF+kk), kẹp 0.1–5 s; bị chặn bởi k2/kV (%) hoặc Wp.
`ftG(oy,a,b)` sát thương (a,b theo cấp, giống các phái khác); `ft2(x)` = lôi công phẳng. `hX=true` trước ftC: có lẽ ép chí mạng; `rc=true`: có lẽ ép chính xác (không chắc, khớp mô tả D "chí mạng 100%, chính xác 100%").
`JDx(oY,..)` = cộng 1 tầng [Cấm] (slot9) – gọi ở Q/W/E khi là đòn gốc (o6==0).

## 1. A0ML Thu Nhạn Bàng Hoàng – Q (autocast) — `JhM` (95509), tick `JhX`, lượt về `Jhj`/`Jh5`
- 1 "kiếm khí" bay thẳng từ người dùng về hướng mục tiêu (xuất phát lùi trước 50), tốc 32/tick (1024/s), 26 tick (840/32) → tầm ~832; quét bán kính 100, xuyên, không giới hạn mục tiêu, mỗi địch 1 lần/lượt.
- Hết tầm thì quay ngược 180° bay thêm ~832 (Jhj/Jh5, cùng bán kính) → "2 lần" = đi + về; cùng một địch có thể trúng 2 lần.
- Sát thương ftG(0.5+0.1/cấp, 1.0+0.2/cấp) + lôi 150+30/cấp. Mỗi trúng: choáng 30%/1 s. sm slot1>0 → hX=true mỗi trúng (không có ×1.2 như W/E).
- Không có hệ số theo cấp chiêu khác. Câu "Tấn công của Cô Nguyệt Bồi Hồi +3%/cấp" thực hiện trong W (đúng).

## 2. A0MO Kiếm Mộ Pháp – bị động (slot 2) – chỉ chỉ số
127464: lần đầu JGd .15, JGR 15, JGK 5, JG4(.8); mỗi cấp +.05/+5/+.1/+1. Mật tịch (129557): sp +300*k3. Không hiệu ứng riêng.

## 3. A0MZ Hồng Tụ Triền – R (biến fGE) — egy (chọn điểm), `egz` (58526) → `egP` (58504), tick `egw` mỗi 2 s
- Điểm đặt = điểm chỉ định, kẹp tối đa 800 từ người dùng.
- Vùng cố định bán kính 250; tick lúc 2,4,6,8 s (4 tick, không tick lúc cast): mỗi tick tối đa 7 địch, choáng xác suất 36+4*cấp % (cấp1=40) trong 1.5 s. Tổng 8 s khớp mô tả.
- Cast nhận 3 tầng [Tuyệt] (`eg7`, tối đa 7): mỗi tầng fti +5 (tốc chạy) và ftg +1%*cấp R (kháng tỉ lệ ngũ hành – suy theo mô tả).
- sm3: hồi ngay 30% HP max. Giãn cách 4 s chỉ theo mô tả. Biến `ni` tính nhưng không dùng.

## 4. A0N7 Tịnh Ảnh Trầm Bích – bị động (slot 4) — `J3X` (~75140) → `J3j` mỗi 60 s → `J35`
- Lần đầu kích hoạt 60 s SAU khi học (không ngay). Mỗi lần: cộng (0.44+0.04*cấp)×nội lực tối đa vào ftU (suy = sinh lực tối đa), hồi 100% HP (ftl 1.0), kéo 59.94 s rồi gỡ (J3U). Khớp mô tả. Mật tịch: JG8 +100*k3.

## 5. A0N8 Mộ Vân Ngưng Bích – bị động (slot 5) — trigger EVENT_PLAYER_UNIT_ATTACKED `eb4`/`ebJ` (66215) → `eb9` → `ebf`
- Học: JGe +70 (+30/cấp) (vật công ngoại) và thêm ability A0N9 (cờ).
- Khi bị **tấn công thường** (sự kiện ATTACKED = lúc địch ra đòn, không phải mọi sát thương/kỹ năng) và ftY(oy)<=50 (suy là %HP): hộ thuẫn (0.6+0.2*cấp)×nội lực tối đa (lưu fKH), 5 s; giãn cách 10 s (A0NA cờ, đếm 10×1 s). sm5: kV +100 (miễn trạng thái) trong lúc có thuẫn.

## 6. A0MP Ngọc Nữ Kiếm Pháp – bị động (slot 6) – chỉ số
Lần đầu JGO .08, JGU .08, Nl .18, ks .18; +.02/cấp → cấp1 10% mỗi thứ. Nl = tỉ lệ gây choáng (tử số enD) ✓; ks suy = kháng tỉ lệ làm chậm. Mật tịch: JG3(x9,100*k3), ko +.3*k3.

## 7. A0MM Cô Nguyệt Bồi Hồi – W (autocast) — `JFb` (94268), tick `JF1`, lượt về `JFN`/`JFt`
- Như Q: đi ~832 (26 tick × 32) rồi về ~832, bán kính **180**, xuyên, không giới hạn, mỗi địch 1 lần/lượt.
- ftG(1.0+0.2, 2.0+0.4) + lôi 225+45; ×(1+3%×cấp Q). sm7 ×1.2; gọi fUX. Choáng 35%/1 s mỗi trúng.

## 8. A0N2 Chung Nam Vãn Chiếu – D (biến fuA) — `JD4` (85624) cast, `JDo` hướng, `JDJ` (85595), tick `JD9`, `JD0`/`JDE`
- Bấm: CHỈ chạy nếu Tuyệt >=2, trừ 2 tầng; nếu <2 thì không gì cả (CD vẫn mất – không chắc). ftG(**1.6**+0.32, 3.0+0.6) + lôi 500+100.
- Tự phát từ Hàn Sơn (JDa 85xxx): ftG(**2.0**+0.4, 3.0+0.6) + lôi 500+100, không tốn Tuyệt. Tooltip (200/300/500) khớp bản tự phát, bản bấm thấp hơn (1.6).
- Kiếm khí bay thẳng (hướng mặt/điểm), tốc 34/tick, 28 tick → tầm ~952, bán kính 120, **tối đa 7 mục tiêu**; mỗi mục tiêu: choáng 50%/1 s, 3 đòn (1 ngay + 2 đòn cách 0.1667 s), mọi đòn hX+rc (chí mạng/chính xác 100%). Chỉ 1 lượt (không quay về). 4 hiệu ứng JD3 phía sau chỉ là hình.
- Lạc Nhật Dư Huy (`JDe`): mỗi lần D thêm 1 tầng nếu <4: ftq +0.18 (mô tả nói +20% sát thương chí mạng; ftq suy = ST chí mạng), 4 s mỗi tầng riêng. sm8: +10 F5/tầng.

## 9. A0N3 Hàn Sơn Độc Lập – bị động (slot 9) — `JDx` (85662)
- Mỗi lần Q/W/E (đòn gốc, kể cả khi trượt mục tiêu? – gọi ngay lúc phát, không cần trúng) +1 Cấm. Mỗi tầng: ft6 +(18+6*cấp) (chí mạng) và ftb +0.09 (khuếch đại ST).
- Khi đếm tới 5: reset về 0 và (nếu đã học D) tự phát D (JDa) → thực tế buff tối đa 4 tầng, tầng thứ 5 không tồn tại. Phi Thiên Vũ (A0MW) giữ tối thiểu 1. Mật tịch: JGK +15*k3.

## 10. A0N6 Phi Thiên Vũ – F (biến fzC) — `eH8` (68680), tick `eHY`
- 12 s: EJV += 0.25+0.05*cấp (hóa giải % ST nhận; trừ tối đa 36% HP max **mỗi đòn**, dòng 98654). Cờ miễn hn,kv,Wp,Sj,Etd (5 trạng thái theo mô tả; ánh xạ từng cờ không chắc; kv=chậm, Wp=choáng theo enD).
- Buff A0MW: Tuyệt/Cấm khi về 0 bị đặt lại 1 (eg7, JDx). Giãn cách 30 s chỉ theo mô tả. Mật tịch: JGO/JGU +.3*k3.

## 11. A0MN Cô Thân Chi Ảnh – E (autocast) — `Jhe` (94507) → `Jhf` (94470), tick `Jh3`, lượt về `JhK`/`Jh0`
- Đi: tốc 30/tick, 30 tick (900/30) → tầm 900, bán kính **200**, xuyên, không giới hạn; về: ngược 180° thêm 900.
- ftG(1.5+0.3, 3.0+0.6) + lôi 400+80; ×(1+3%×cấp W). sm11 ×1.2; fUX. Choáng 40%/1 s.

## 12. A0MY Ngọc Nữ Tâm Kinh – bị động (slot 12) + Phá Mộng Hành (trong `Jhf`)
- Chỉ số: JGR 40, JG8 40, +10/cấp.
- Mỗi lần E: 65% bật; khi lượt đi trúng địch ĐẦU TIÊN → `JhE`: mọi địch bán kính 300 quanh nó nhận `JFi`: 3 đòn mỗi 0.2 s (đòn đầu sau 0.2 s), ftG(0, 1.25+0.25) + lôi 100+20. sm12: ftq +0.25 trong 2 s (JFH).

## 14. A0XW Bạch Vân Hồi Vọng – bị động (slot 14)
- Chỉ số: Ev5 +.14 (+.02/cấp) (ST khi chí mạng), Evj +.01/cấp (ST lên hệ Thủy), cờ kv +1 (miễn chậm).
- E: mỗi địch trúng ở lượt đi cộng hệ số lượt về +(0.16+0.02*cấp), tối đa ×2.2 (=+120%) – chỉ nhân sát thương lượt về (Jh3→JhK). Khớp mô tả.
