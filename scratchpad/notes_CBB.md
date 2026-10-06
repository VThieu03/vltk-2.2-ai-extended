# CBB (Cái Bang Bổng) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Bảng chiêu: dòng 81356-81411 (marker phái A0EI = $41304549, sG=22).
Thanh Q/W/E autocast: marker A0EI trong Jdd (dòng 127837-127850):
- buff B03Z -> Ja8 (Q, Bổng Đả Ác Cẩu); B040 -> J0Y (W, Thiên Hạ Vô Cẩu); B041 -> JaU (E, Bổng Quỷnh Lược Địa).
  (Gán Q/W/E suy từ slot oB mà mỗi hàm đọc: Ja8 đọc slot 1, J0Y slot 7, JaU slot 11.)

Quy ước chung:
- Tick hẹn giờ rF95 = 0.03125 s (32 tick/giây).
- eYQ(a,lv,b) = a + b*(lv-1); ezX(lv,b,a) = a + b*(lv-1).
- ftG(oy, X, Y): X = % vật công ngoại, Y = "phát huy lực tấn công cơ bản" (suy từ đối chiếu với tham số tooltip JdV); ft2(Z) = hỏa công phẳng.
- Trạng thái: **ena(target, t, chance, src) = bỏng**, **en9(src, t, chance, target) = thọ thương**. Suy ra bằng cách khớp thời gian với tooltip
  (Q: ena 1.5 s / en9 1 s đúng "bỏng 1.5 s / thọ thương 1 s"; R: ena 3 s / en9 1 s đúng "bỏng 3 s / thọ thương 1 s"), và chỉ số kháng
  Fn/FB (trong en9) đúng là "kháng thời gian/tỉ lệ thọ thương" ở bị động 5/6. Thời lượng thực = t*(1+bonus)/(1+kháng), xác suất cũng chia kháng.
- J0z(oY) = Hoại Thương (bị động slot 8): áp vào gần như mọi đòn của phái (xem slot 8).
- sm slot N > 0 -> sát thương x1.2 (không chắc sm là gì; có thể là cường hóa/bí kíp chiêu).
- Sát thương W và E còn gọi fUX(oY,oy) (TriggerEvaluate(xS)) – không rõ tác dụng (không chắc).

---
## 1. A0EK – Bổng Đả Ác Cẩu – Q (autocast, buff B03Z)
Hàm: Ja8 (84825), đạn JaY (~84800), tick JaR (84773), nổ JaW (84754). Chỉ số tooltip: nhánh sG==22 xT==1 (~126062).
- Sát thương: vật ngoại 40%+8%/lv, phát huy cơ bản 100%+20%/lv(=1.0+0.2*(lv-1)), hỏa công 100+20/lv. Xác suất trạng thái k3=30.
- Hướng: kK = góc caster->mục tiêu; đạn sinh cách caster 50 theo hướng đó.
- Số đạn phụ thuộc LoadInteger(o8,eRS(oY,QS),1): >=6 -> 3 đạn (giữa offset 10, hai bên lệch ±90° offset 70); >=3 -> 2 đạn (hai bên offset 60); còn lại 1 đạn.
  Tất cả đạn bay SONG SONG theo kK (các đạn chỉ lệch vị trí xuất phát, không tỏa quạt).
  **Không chắc / nghi lỗi**: khóa QS chỉ thấy SaveReal (chiều cao tooltip, 123647) – không tìm thấy SaveInteger nào vào QS, nên LoadInteger có thể luôn = 0 -> thực tế luôn 1 đạn.
  Ý định rõ ràng là theo cấp: tooltip đặt "Số chiêu thức" bc = 1 (lv<3) / 2 (lv>=3) / 3 (lv>=6) (dòng ~126066).
- Đạn: tốc 20/tick (640/s), sống 800/20 = 40 tick -> tầm 800. Dò mục tiêu bán kính 90; gặp kẻ địch đầu tiên thì nổ 1 lần (iD) và đạn tồn tại thêm 5 tick rồi biến mất.
- Nổ (JaW): AoE bán kính 100 tại điểm đạn, KHÔNG giới hạn số mục tiêu; mỗi mục tiêu: bỏng 1.5 s (30%), thọ thương 1 s (30%), sát thương * J0z.
  Nếu sm slot1>0 đặt hX=true (không chắc – có thể ép chí mạng).
- Khác mô tả: "nhiều chiêu" – xem nghi lỗi QS ở trên; tooltip không nói về nổ AoE 100.

## 2. A0ER – Cái Bang Bổng Pháp (bị động, slot 2) – chỉ chỉ số
Code (126076-126084): lần đầu JGd .15, JGR 15, JGK 5, JG4(.8,oH); mỗi cấp +JGd .05, JGR 5, JG4 .1, JGK 1.
Tooltip: chính xác ! = 90+10*(lv-1)%, hỏa công @ = 20+5*(lv-1)%, chí mạng # = 20+5*(lv-1), tốc đánh $ = 6+1*(lv-1).
Ánh xạ hàm->chỉ số (không chắc): JGd=chính xác%, JGR=?, JGK=?, JG4(oH)=tốc độ đánh. Số liệu code và tooltip không khớp 1-1 (ví dụ JGd .15+.05 vs 90%) – không chắc đơn vị.

## 3. A0ET – Tiêu Dao Công (bị động, slot 3) – chỉ số
Code (126085-126095): lần đầu JGn 170, FL +.17, JG5 2, sp +80; mỗi cấp JGn +30, FL +.03, JG5 +1, sp +20.
Tooltip: né tránh 200+30/lv(lv1=200), kháng phản đòn 20+3%/lv, tốc chạy 3+1/lv, bỏ qua né tránh 200+20/lv... (ezX(kf,20,100)/(1,3)/(30,200)).
Suy: JGn=né tránh, FL=kháng phản đòn, JG5=tốc độ di chuyển, sp=bỏ qua né tránh (khớp số học). Không có hiệu ứng riêng.
Lưu ý khối 129345: sG==22 xT==3 thêm Fn +.5*k3 (kháng thời gian thọ thương) – khối này dùng k3 (có thể là cấp cộng thêm từ trang bị; không chắc).

## 4. A0F0 – Ác Cẩu Lan Lộ – R (chủ động, biến fuM)
Hàm: J4w (83000) -> J47 (82987) -> J4v (82969) -> J4V (82949) -> tick J42.
- Sát thương: vật ngoại 85%+17%/lv, phát huy cơ bản 175%+35%/lv, hỏa công 250+50/lv. Xác suất trạng thái 50.
- 12 đạn tỏa tròn 360°: góc = hướng mặt caster + 0,30,...,330. Xuất phát cách caster 40.
- Đạn: tốc 25/tick (800/s), sống 600/25 = 24 tick -> tầm 600, bán kính 100, xuyên, không giới hạn mục tiêu, mỗi mục tiêu trúng 1 lần/đạn.
- Mỗi trúng: bỏng 3 s (50%), thọ thương 1 s (50%), sát thương * J0z.
- Giãn cách 2 s: không có trong code (do object data). Khớp mô tả.

## 5. A0E9 – Túy Điệp Cuồng Vũ (vòng sáng, slot 5)
Code (126105-126113): lần đầu JG3(0,80) + Fn +.13 + thêm ability A0E9 + hiệu ứng "CBC_hoatbatluuthu.mdl"; mỗi cấp JG3(0,+20), Fn +.02.
Tooltip: kháng tất cả 80+20/lv... thực tế ! = ezX(20,100)=100 lv1, @ = ezX(2,15)=15% lv1 (code 0.15 lv1 ✓).
Suy: JG3(0,x)=kháng tất cả; Fn=kháng thời gian thọ thương (Fn ở mẫu số thời gian của en9). Code chỉ cộng cho bản thân; phần "vòng sáng" cho đồng đội nếu có thì ở object data A0E9 (không chắc).

## 6. A0ES – Bôn Lưu Đáo Hải (bị động, slot 6)
Code (126114-126124): lần đầu JGO .08, JGU .08, Nz .18, FB .18; mỗi cấp +.02 cả bốn -> lv1 = 10% mỗi thứ.
Suy: JGO/JGU = phát huy cơ bản/kỹ năng; Nz = cộng tỉ lệ gây bỏng (tử số xác suất ena); FB = kháng tỉ lệ thọ thương (mẫu số xác suất en9). Khớp tooltip (! = @ = # = 10+2/lv).
Khối 129345: xT==6 thêm JG3(kN,80*k3) và Fn +.3*k3 (không chắc nguồn k3).

## 7. A0EL – Thiên Hạ Vô Cẩu – W (autocast, buff B040)
Hàm: J0Y (72982), đạn J0R (~72960), tick J0W (72906), sát thương trễ J0y/J0T (72882-72904).
- Sát thương: vật ngoại 80%+16%/lv, phát huy cơ bản 150%+30%/lv, hỏa công 150+30/lv; nhân (1+3%*cấp Q) (đúng "Q: tấn công Thiên Hạ Vô Cẩu +3%/cấp"); sm7 -> x1.2. Xác suất trạng thái 35.
- 3 đạn bay theo hướng caster->mục tiêu: giữa (offset 10), hai bên lệch ±90° offset 70; xuất phát cách caster 50.
- Đạn: tốc 20/tick (640/s), sống 50 tick (1.5625 s) -> tầm ~1000; ĐUỔI MỤC TIÊU: cứ 10 tick (0.3125 s) quay lại hướng mục tiêu ban đầu (nếu còn sống).
- Bán kính 100, tối đa 7 mục tiêu/đạn, mỗi mục tiêu 1 lần/đạn.
- Đạn giữa (x6=1): bỏng 1.5 s (35%) + sát thương ngay * J0z.
- Đạn bên (x6=2,3): thọ thương 1 s (35%) + sát thương TRỄ qua J0y: tick 0.2 s, iX = 2 hoặc 3 -> trễ 0.4 s (đạn 2) / 0.6 s (đạn 3); hủy nếu mục tiêu chết.
- Khác mô tả: mô tả nói mỗi chiêu đều có bỏng+thọ thương 35%; code tách: đạn giữa chỉ bỏng, đạn bên chỉ thọ thương; sát thương trễ không được nêu.

## 8. A0EU – Đả Cẩu Bổng Pháp (bị động, slot 8) + Hoại Thương
Chỉ số (126130-126137): lần đầu JGe 170, hY +.18; mỗi cấp JGe +30, hY +.02. Suy JGe = vật công ngoại (200+30/lv), hY = tăng thời gian thọ thương (tử số thời gian en9) 20%+2%/lv.
Hoại Thương: J0z (72876): nếu đã học slot 8, mỗi lần gây sát thương tung xác suất 35% -> nhân sát thương 1.12+0.08*lv (lv1 = x1.20; tooltip # = ezX(30,200)=200?? – tooltip "sát thương cơ bản +#%" ghi 200% lv1, code chỉ +20%: KHÁC MÔ TẢ, không chắc tooltip hiểu thế nào).
J0z được gọi ở: Q (JaR), W (J0W/J0T), E (Jal), R (J42), Đả Cẩu Trận (JaL).
Khối 129345: xT==8 thêm JGO/JGU +.3*k3.

## 9. A0EX – Minh Sát Thu Hào – D (chủ động, biến fwF; buff/ability đánh dấu fwh = A0EN)
Hàm: e1i (66135) -> e1Q -> e1b (bật) / e1H (làm mới) ; tick e11, e1Z.
- Nếu chưa có A0EN: thêm A0EN, cộng FU và FJ +(10+2*lv) (+10 nếu sm9) (lv1 = 12%), kéo dài 300/rF95 tick = 300 s. FU/FJ suy là tỉ lệ né sát thương ngoại/nội (khớp tooltip ! = 12+2/lv).
- Nếu đang có: gỡ A0EN (e11 sẽ hoàn chỉ số), sau 10 tick (~0.31 s) bật lại -> thực chất là làm mới 300 s, không phải tắt.
- Hết thời gian / gỡ ability: trừ lại FU/FJ, gỡ buff B032.
- AI tự dùng khi chưa có A0EN (105386, lệnh "taunt"). Giãn cách 15 s: object data.

## 10. A0EV – Tung Hạc Công (bị động, slot 10)
Chỉ số (126143-126149): lần đầu EJV +.10 + thêm ability A0EY; mỗi cấp EJV +.01 -> lv1 11% (khớp ! = 11+1/lv). Suy EJV = hóa giải % sát thương nhận (giới hạn 36% sinh lực không thấy ở đây – không chắc nằm đâu).
Kích hoạt: Jef/Je3 (76407): sự kiện EVENT_PLAYER_UNIT_ATTACKED (khi BỊ ĐÁNH, kể cả trước khi trúng), có A0EY, không có A0EZ (giãn cách), sinh lực ftY(oy) <= 95% (JeK).
Hiệu ứng Je0: đẩy lùi mọi kẻ địch trong bán kính 400 ra xa 300 trong 0.5 s (ePR); thêm A0EZ 45 s (JeE tick 1 s) = giãn cách 45 s.
Jfi: 15 s (15/rF95 tick): k2 +100, Fh +50, ftt +500*lv (né tránh, khớp @ = 500/lv); buff B043 với ability đánh dấu fY1.
Suy: k2 +100 -> trong ena/en9 kiểm "random < k2" -> miễn nhiễm 100% bỏng/thọ thương (có lẽ mọi trạng thái); Fh +50 = né tránh tối đa +50% (không chắc).
Khác mô tả: không thấy code "hóa giải" (xóa) trạng thái đang có – chỉ miễn nhiễm mới (không chắc).

## 11. A0EM – Bổng Quỷnh Lược Địa – E (autocast, buff B041)
Hàm: JaU (85063), tick phóng JaO (.1667 s), đạn JaB, tick Jal (84948).
- Sát thương: vật ngoại 65%+13%/lv, phát huy cơ bản 100%+20%/lv, hỏa công 120+24/lv; nhân (1+3%*cấp W) (khớp "W: tấn công Bổng Quỳnh +3%/cấp"); sm11 -> x1.2. Xác suất 40.
- Phóng 3 đạn lần lượt cách 0.1667 s (ib=3,2,1). Gốc = vị trí caster lúc tung; đạn 3: cách 100 theo hướng mục tiêu; đạn 2: cách 100 ở góc +90°; đạn 1: góc -90°. Tất cả bay theo hướng iN (caster->mục tiêu).
- Đạn: tốc 25/tick (800/s), 48 tick = 1.5 s -> tầm 1200; ĐUỔI: quay hướng về mục tiêu ở tick còn lại 32 và 16 (sau 0.5 s, 1.0 s).
- Bán kính 110, tối đa 7 lượt trúng/đạn; ở tick 24 (0.75 s) xóa nhóm đã trúng -> mỗi mục tiêu bị trúng tối đa 2 lần/đạn (giải thích "tấn công 2 lần", 3x2 = "6 chiêu thức").
- Mỗi trúng: 50/50 chọn thọ thương 1 s HOẶC bỏng 2 s (xác suất 40%), sát thương * J0z.
- Lần chạm kẻ địch ĐẦU TIÊN của mỗi đạn: nếu học slot 12, 75%, không có A0F1 -> Đả Cẩu Trận (Jad) tại vị trí kẻ địch đó.
- Khác mô tả: mô tả nói bỏng 40% VÀ thọ thương 40%; code chỉ 1 trong 2 mỗi lần trúng.

## 12. A0EW – Đả Cẩu Trận Pháp (bị động, slot 12) + Đả Cẩu Trận
Chỉ số (126155-126160): lần đầu JGB .1; mỗi cấp JGB +.02, JGd +.1. Suy JGB = thu nhỏ sát thương nhận (# = 12+2/lv %), JGd = chính xác % ($ = 10/lv).
Đả Cẩu Trận: Jad (84914), tick JaL (84886), âm "snd_CBB_dacautran.mp3".
- Kích hoạt: từ đạn E (xem trên), 75%, khi không có A0F1. Thêm A0F1 lúc bắt đầu, gỡ lúc kết thúc -> "giãn cách 3 s" thực chất = thời gian trận đang tồn tại (3 s), nên có thể bật lại ngay khi trận cũ hết.
- Cố định tại vị trí kẻ địch bị trúng; 15 tick x 0.2 s = 3 s (= "15 chiêu thức").
- Mỗi tick: AoE bán kính 300, tối đa 7 mục tiêu, sát thương: vật ngoại 0% (k3=0), phát huy cơ bản 150%+30%/lv, hỏa công 100+20/lv; sm12 -> x1.2; * J0z. Không gây trạng thái.
- Caster được k2 +30 trong 3 s (khả năng kháng/miễn trạng thái 30% – không chắc) – mô tả không nêu.
- Hiệu ứng: 4 cột cách 100 (góc 90..360) và 6 cột cách 200 (góc 60..360), mỗi cái 3 s (Jan) – chỉ hình ảnh.

## 14. A0X8 – Hỗn Thiên Khí Công (bị động, slot 14)
Code (126161-126170): lần đầu xD +.08, kb +.08, JG3(0,80); mỗi cấp Evj +.01, xD +.01, kb +.01, JG3(0,+20).
Suy: Evj = sát thương lên hệ Kim (! = 1/lv %), JG3(0,..) = kháng tất cả (@ = 100+20/lv), xD/kb = bỏ qua vật phòng / hỏa phòng (# = 9+1/lv %). Khớp tooltip. Không có hiệu ứng riêng.
