# CMC (Cổ Mộ Châm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Khối khởi tạo phái: dòng 82190-82262 (marker A0LQ = $41304C51, sG=33, K8h[33] dòng 130634).
Bảng chiêu (Ff): 1 A0LS, 2 A0LV, 3 A0M8, 4 A0ME, 5 A0MA, 6 A0LW, 7 A0LT, 8 A0MC, 9 A0MF, 10 A0MD, 11 A0LU, 12 A0M7, 14 A0XT.
Không có "snd_CMC"; âm thanh là `Sound\\snd_cmc1..6.mp3` (chữ thường).
Thanh Q/W/E autocast: marker A0LQ trong khối trúng đòn (dòng 127979-127992):
- buff B062 -> Jav (Q, Biệt Tự, đọc slot 1); B063 -> Jxa (W, Ly Hận, slot 7); B064 -> Jay (E, Bi Sầu, slot 11).
Học chiêu / chỉ số bị động: nhánh sG==33 dòng 127356-127451; mật tịch (sm) nhánh sG==33 dòng 129539-129554.

Quy ước chung (giống notes_CBB/NMK):
- rF95 = 0.03125 s; eYQ(a,lv,b)=a+b*(lv-1). ftp(x)= % "phát huy lực tấn công cơ bản"; ft2(x)= lôi công phẳng (sát thương chiêu). ftC(mi,..,GE) gây sát thương.
- **enD(target, chance, src, 1.) = CHOÁNG** (dummy cast, thời lượng k9 nhân hệ số kháng; bị chặn bởi k2/kV/Wp). Mọi "choáng 1 giây" của phái dùng enD.
- enJ = định thân. enF(kd,u) = PauseUnit + TimeScale 0 (đóng băng cứng), gọi qua enh(u,giây,%).
- **eim(oY,oy) = Súc Thế Đãi Phát (slot 4)**: nếu có buff Eso -> trừ 1 lần dùng (Esk), trả ×(1.17+0.03*lv4); hết 3 lần thì gỡ buff. Được gọi bởi Q, W, E, R (đợt châm), D (khi đủ tầng), F (bấm).
- A0M5 ($41304D35) = buff của Vụ Tập Vân Hợp (T). Đạn của Q, W, E, D kiểm tra: có A0M5 -> trúng 1 mục tiêu là dừng (max mục tiêu = 1). R, F, Lưu Quang KHÔNG bị giới hạn.
- sm slot N > 0 -> ×1.2 sát thương (cờ mật tịch).
- fUX(oY,oy) (W, E) – không rõ tác dụng (giống CBB).

---
## 1. A0LS – Biệt Tự – Q (autocast, buff B062)
Hàm: Jav (~84600), đạn Ja2, bay Jap, lặp JaV (0.2 s). Tooltip: sG33 xT==1 (127357).
- Sát thương: ftp 100%+20%/lv, ft2 200+40/lv; choáng xác suất 30, 1 s (enD). sm1 ×1.2; eim.
- Hướng: từ caster tới mục tiêu; đạn sinh cách caster 50.
- Số châm: 1 ngay + 1 sau 0.2 s (EsJ=1) = **2 châm** (khớp "Số chiêu thức 2"). Mỗi châm 1 đường thẳng (không quạt).
- Đạn: tốc 25/tick (800/s), sống R2I(250/25)=10 tick -> tầm ~250. Bán kính dò 90, mỗi địch trúng 1 lần/châm, tối đa 7 mục tiêu/châm (1 nếu A0M5).
- Mô tả "W tăng 3%/cấp": đúng – Jxa nhân (1+0.03*lv1).

## 7. A0LT – Ly Hận – W (autocast, buff B063)
Hàm: Jxa, đạn JxJ, bay Jx9, lặp Jx4 (0.2 s).
- Sát thương: ftp 110%+22%/lv, ft2 220+44/lv, × (1+0.03*lv Q); eim; sm7 ×1.2; choáng 35%, 1 s.
- 3 đợt (0, 0.2, 0.4 s). Mỗi đợt 3 châm song song: giữa (cách caster 60 theo hướng mục tiêu) + 2 châm lệch ±90° cách 40.
  **Chỉ châm giữa (x8=true) gây sát thương**; 2 châm bên chỉ hiệu ứng. Đợt 2,3 lệch hướng ngẫu nhiên ±8° (cả 3 châm cùng góc).
  => thực tế 3 lần trúng (khớp "Số chiêu thức 3").
- Đạn: tốc 32/tick (1024/s), sống R2I(384/32)=12 tick -> tầm 384. Bán kính 100, tối đa 7 mục tiêu/châm (1 nếu A0M5).

## 11. A0LU – Bi Sầu – E (autocast, buff B064)
Hàm: Jay, đạn Jaz, bay JaP, lặp JaT (0.2 s).
- Sát thương: ftp 180%+36%/lv, ft2 370+74/lv, × (1+0.03*lv W); eim; sm11 ×1.2; choáng 40%, 1 s.
- 3 đợt (0, 0.2, 0.4 s), mỗi đợt 5 châm: giữa (cách 60), 2 châm ±90° cách 30, 2 châm ±135° cách 90; tất cả bay cùng hướng (song song, tham số $64/$78/80 chỉ là độ cao hiệu ứng).
  **Chỉ châm giữa gây sát thương** -> 3 lần trúng trên đường thẳng (khớp "3").
- Đạn: tốc 40/tick (1280/s), sống R2I(420/40)=10 tick -> tầm 400. Bán kính 100, tối đa 7/châm (1 nếu A0M5).
- Nếu học slot 12 (Phong Lưu Vân Tán) và EFF[oY]=false -> gọi eQe (Lưu Quang Tứ Xạ), xem slot 12.

## 3. A0M8 – Kinh Hồng Chiếu Ảnh – R (bấm, điểm)
Hàm: JkB (88876) -> Jkl (lướt), Jkd (tick lướt), JkL/Jkn (buff), Jku/Jk8 (mưa châm), JkY/JkR/JkW (châm).
- Mục tiêu điểm; tầm lướt tối đa 720 ($2D0); không cho dùng khi EvR/EWB/sJ (đang bị khóa/đang lướt).
- Khi bắt đầu lướt: AoE bán kính 350 ($15E) **quanh vị trí xuất phát**, tối đa 10 địch: định thân enJ 80%, 2 s (khớp "80% định thân 2 s" nhưng là tại điểm đầu, không phải điểm đến).
- Lướt: 32/tick (1024/s); dừng sớm nếu ePc (ô không đi được). Ẩn nút chiêu trong lúc lướt. Sau lướt +6 tick rồi gọi Jku tại điểm đến.
- Buff [Phi Hồng Đạp Tuyết] (fnG, B065) chỉ áp nếu chưa có: né FJ & FU +(10+2*lv3)% (lv1 = 12%), e8f(kv,+1) (suy là miễn làm chậm – không kiểm), 10 s. sm3: thêm Etd và b6 (+1) – Etd = miễn enh/đóng băng (thấy trong enh); b6 không rõ.
- Mưa châm Jku: sát thương ftp 250%+50%/lv, ft2 400+80/lv, × eim (không có sm ×1.2). 6 đợt cách 0.05 s; mỗi đợt từ điểm cách điểm đến 400 theo góc base+{0,120,240,60,180,300}, bay hướng (góc+188°) tức gần về phía điểm đến (lệch 8°).
  Mỗi đợt 3 châm (giữa + ±90° cách 30), **chỉ châm giữa gây sát thương**. Châm: tốc 32/tick, sống R2I(960/32)=30 tick -> bay 960 (xuyên qua điểm đến), bán kính 150, tối đa 7/châm.
  => 6 lần trúng (khớp "Số chiêu thức 6"). **KHÔNG có choáng** trong JkW (mô tả ghi 50% choáng 1 s – lệch).

## 5. A0MA – Ngọc Phong Châm – D (bấm)
Hàm: Jxu (cast: chọn hướng), JxY (effect), JxR/JxW (lặp 0.08 s), Jxy/JxT (châm). Thôn Tư: Jxw/Jx7 (dòng ~89920), khởi động khi học (127389).
- Thôn Tư (E7L): mỗi 6 s +2 tầng, tối đa 6. Bắt đầu đếm khi học chiêu.
- Cần >=2 tầng; nếu <2 thì không có gì xảy ra (code không hoàn cooldown). Trừ 2 tầng.
- Sát thương: ftp 225%+45%/lv, ft2 ngẫu nhiên trong [340+68/lv, 380+76/lv]; eim; sm5 ×1.2. Choáng 40%, 1 s.
- Hướng = facing (eub) hoặc điểm chỉ định. Thêm ability A0MB và ẩn nút trong lúc phóng.
- **7 châm, mỗi 0.08 s 1 châm** (khớp 7), góc = hướng + randint(-8,8)*3 -> quạt ngẫu nhiên ±24°. Xuất phát tại vị trí caster lúc bấm.
- Châm: tốc 30/tick, sống 600/30=20 tick -> tầm 600, bán kính 120, tối đa 7/châm (1 nếu A0M5).
- sm5: địch trúng nhận ability A0M1 (fLb) 5 s (hiệu ứng trong object data, không rõ).
- Nếu có slot 12 VÀ sm12 và EFF=false -> cũng kích Lưu Quang Tứ Xạ (eQe) khi phóng D.
- Khi tầng về 0 và học slot 9 và không có A0MG -> eic (Hành Vân Đới Vũ).

## 8. A0MC – Hoàng Tuyền Lảo Đảo – F (bấm, không mục tiêu)
Hàm: Joc (87198) -> Joh/JoF (tick 0.05 s), Jos (hiệu ứng rơi).
- Sát thương: ftp 105%+21%/lv, ft2 ngẫu nhiên [155+31/lv, 215+43/lv]; eim; sm8 ×1.2. Choáng 30%, 1 s.
- Tâm = vị trí caster lúc bấm (cố định). Kéo dài 100 tick × 0.05 = 5 s; cứ 5 tick (0.25 s) đánh AoE bán kính 360 ($168), tối đa 7 địch -> **20 lần** (khớp 20). Hiệu ứng châm rơi ngẫu nhiên ±250.
- Giãn cách 8 s: không thấy trong code (object data).
- Mật tịch slot 9 (sm9, dòng 129547) cho A0MH: khi bị tấn công (EVENT_PLAYER_UNIT_ATTACKED) và HP<=30% -> tự thi triển Hoàng Tuyền (Jop) với thêm enh 3 s 100% (đóng băng/pause), giãn cách 60 s (A0MI).

## 10. A0MD – Vụ Tập Vân Hợp – T (bật/tắt)
Hàm: JJo/JJD/JJa (78380-78420). Bấm lần 2 gỡ buff A0M5 (B069).
- Khi bật: chí mạng ft6 +175+25*lv, sát thương chí mạng ftq +0.2+0.03*lv. sm10: ftH và ftQ +0.3 (không rõ chỉ số).
- A0M5 giới hạn châm Q/W/E/D còn 1 mục tiêu (khớp mô tả). Không tốn mana/thời hạn trong code.

## 4. A0ME – Súc Thế Đãi Phát (bị động)
Hàm: eiV/ei2 (mỗi 5 s), eip/eiG (buff Eso, B066), eim (tiêu hao).
- **Mỗi 5 s cố định** áp buff (KHÔNG kiểm tra "khi không tấn công" – lệch mô tả): ftZ +0.18+0.02*lv (suy = giảm sát thương nhận), 5 s; đặt 3 lần dùng.
- Sát thương chiêu ×(1.17+0.03*lv4) mỗi lần qua eim; hết 3 lần gỡ buff. sm4: +1 hn, NW, Wp (Wp chặn choáng enD -> suy miễn khống chế).

## 9. A0MF – Hành Vân Đới Vũ (bị động)
Hàm: eic (70825), eiF/eis (buff fL2), eih (giãn cách).
- Kích khi D làm Thôn Tư về 0 (xem slot 5). Buff 8 s: né FJ/FU +25+5*lv9, k2 +100 (k2 = tỉ lệ kháng choáng/đóng băng trong enD/enh -> miễn khống chế). Giãn cách 30 s (A0MG).
- Chỉ số học: JG4 1.0 +0.1*k3 (lôi công %?). sm9: A0MH (xem F).

## 12. A0M7 – Phong Lưu Vân Tán (bị động)
- Chỉ số: JG4 .5+.15*k3, e80(F5,+1*k3) (suy = trần chí mạng). sm (129539) không có nhánh xT==12.
- Lưu Quang Tứ Xạ: eQe/eQf/eQ3/eQK/eQ0 (~69100-69190). Kích từ E (cần học slot12) hoặc D (cần học + sm12). EFF làm cờ giãn cách.
  Tick 0.1 s, EFV=20: 5 tick đầu mỗi tick chọn **1 địch ngẫu nhiên** trong 1200 quanh caster và bắn 1 chùm 5 châm (giữa ±6° ngẫu nhiên; chỉ châm giữa gây sát thương) -> tối đa 5 lượt (có thể trùng mục tiêu). Giãn cách = 20 tick = 2 s (khớp).
  Sát thương ftp 160%+32%/lv12, ft2 335+67/lv12, sm12 ×1.2, không eim, không choáng. Châm: tốc 32/tick, tầm 1200, bán kính 120, tối đa 7.

## 2/6/14 – bị động chỉ số
- 2 Mộ Châm Pháp: JGR/JGK/JG4(oi) (lôi công %, chí mạng, tốc đánh – suy theo tooltip). sm2: JGR +50.
- 6 Lưu Vân Pháp: JGO/JGU +.08+.02/lv, Nl và ks +.18+.02/lv (Nl = tỉ lệ choáng trong enD). sm6: JG3, ko +0.3.
- 14 Mê Thần Dẫn: JGn, JcO(A0XV – hào quang, suy giảm lực tấn công địch 20%), Evj +1%/lv, JGK.
