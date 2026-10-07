# TDK (Tiêu Dao Kiếm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Bảng chiêu: dòng 81584-81657 (marker phái A0GD = $41304744, sG=25, K8h[25] dòng 130626).
Autocast Q/W/E: khối marker A0GD dòng 127879-127892:
- buff B03I ($42303449) -> JsY (Q, Trảm Vân Kiếm, slot 1); B03J -> JCk (W, Tê Chiếu Phồn Thương, slot 7); B03K -> J4A (E, Bách Điểu Triều Phượng, slot 11).
Chỉ số bị động/tooltip: nhánh sG==25 dòng 126378-126483 (JdV tham số tooltip; ezX(lv,b,a)=a+b*(lv-1)). Cộng thêm k3 (mật tịch?): 129407-129418.
AI tự bấm chiêu: 105436 (slot 5 "fanofknives" nếu chưa có buff Sơ Hoa; slot 8 "howlofterror"; slot 3).

Quy ước chung (giống CBB): rF95=0.03125 s; ftG(oy,X,Y) X=% vật công ngoại?, Y=phát huy cơ bản? (nhãn suy, xem CBB); ft2 = hỏa công phẳng.
ena=bỏng, en9=thọ thương, enJ=định thân. Xác suất trạng thái = k3 (số %).
- ftC(...) = gây sát thương. sv=1.2 nếu mục tiêu có buff E3X (do R + sm slot3 gây ra, xem R).
- eiJ(oY,oy): gọi khi Q/W/E phát (mỗi lần thi triển, KHÔNG phải mỗi đòn trúng) -> cộng 1 tầng Hoa Khai Mạch nếu đang có buff Sơ Hoa Dẫn.
- sm slot N > 0 -> x1.2 sát thương hoặc hiệu ứng thêm (không rõ sm là gì, có lẽ cường hóa/bí kíp).
- fUX(oY,oy) gọi ở W/E: không rõ tác dụng.
- Lưu ý nhãn tooltip: các ký hiệu !/@/#/$ của JdV không trùng thứ tự với nhãn trong mô tả; ghi theo số trong code.

---
## 1. A0GE – Trảm Vân Kiếm – Q (autocast B03I)
Hàm JsY (dòng ~83400), đạn JsR, tick JsW (rF95).
- Sát thương: ftG(0.4+0.08/lv, 0.8+0.16/lv), hỏa 100+20/lv. k3=30 (bỏng 2 s 30%, thọ thương 0.5 s 30%) – khớp mô tả.
- Hướng caster->mục tiêu; gốc cách caster 50. Đạn: 600 tầm (hge6=$258, 20/tick => 30 tick, ~640/s), bán kính chạm 110 ($6E), xuyên thấu, mỗi đích trúng 1 lần, KHÔNG giới hạn số mục tiêu.
- Số đạn theo LoadInteger(eRS(oY,QS),1): >=6 -> 3 đạn (giữa offset 10 + hai bên offset 70 vuông góc); >=3 -> 2 đạn (hai bên offset 60, không có đạn giữa); còn lại 1. Đạn bay SONG SONG.
  Tooltip $ (số chiêu) tính theo cấp kf (1/2/3 ở cấp 1-2/3-5/6+). Code đọc khóa QS (không chắc QS = cấp chiêu; giống nghi vấn ở CBB).
- sm slot1>0 -> hX=true (có lẽ ép chí mạng; không chắc).
- Bị động: Q có cấp nào cũng làm W x(1+3%*lvQ) (khớp mô tả "Tê Chiếu tăng 3%/cấp").

## 2. A0GS – Tiêu Dao Kiếm Pháp – bị động chỉ số (126389)
Gốc: JGd .15, JGR 15, JGK 5, JG4 .8 (oH); mỗi k3: JGd +.05, JGR +5, JG4 +.1, JGK +1. Tooltip: chính xác ezX(kf,10,90)?, ... (nhãn JGx không xác minh: JGd=chính xác%?, JG4=hỏa công%?, JGR=chí mạng, JGK=tốc đánh – suy theo mô tả).

## 3. A0GV – Đan Phượng Dẫn – R (bấm, fF3)
e_Q (cast, dòng 47615): điểm đích = điểm chuột, kẹp tối đa 640 ($280) từ caster. e_Z (47601) -> e_b (47587), tick e_1 (47546) mỗi 1.0 s x10 lần = 10 s.
- Sát thương mỗi tick: ftG(0.8+0.16/lv, 1.6+0.32/lv), hỏa 210+42/lv. Bán kính 350 ($15E), tối đa 7 mục tiêu/tick.
- Mỗi tick: định thân 1.5 s (enJ) 50%, bỏng 2.5 s 50% – khớp mô tả.
- sm slot3>0: đích chưa có E3X nhận buff E3X 4 s (e_N) => mọi đòn TDK lên nó x1.2.
- Giãn cách 15 s: lấy từ object data (không thấy trong code).
- Nếu có bị động 9 (Bính Nhược Quan Hỏa): e_r – hồi (0.08+0.02*lv9)*sinh lực tối đa mỗi 1 s x4 lần (4 s), buff $4230344F.

## 4. A0GW – Chân Hỏa Hộ Thể – bị động (126410; trigger ell/elL dòng 46200-46228)
- Chỉ số: JGv .08 (+.02*k3) sinh lực%, JGn 170 (+30*k3) né tránh, e80 FL .13 (+.02*k3) kháng phản đòn; thêm ability $41304758.
- Kích hoạt: EVENT_PLAYER_UNIT_ATTACKED (khi bản thân BỊ đánh thường – không phải bị chiêu), ftY(oy)<=50 (sinh lực <=50%), không có cờ hồi $41304759.
- eln: kẻ địch trong 400 ($190) quanh bản thân: en2(3,100) – hỗn loạn 3 s 100% (en2 suy = hỗn loạn theo mô tả, không kiểm).
  Bản thân: el8 buff 5 s: e80 k2 +100 (k2 suy = miễn nhiễm/kháng trạng thái); sm slot4>0 thêm ftZ +0.8 (không rõ).
- Giãn cách = 31 - lv giây (khớp tooltip $=30-(lv-1)).

## 5. A0GZ – Sơ Hoa Dẫn – F (bấm, fzg; eik dòng 70760)
- Đồng minh là HERO trong 1000 ($3E8) quanh caster (gồm bản thân): buff E3C 30 s: FL (kháng phản đòn) +(0.13+0.02*lv) và ftA +(0.18+0.02*lv) (ftA suy = kháng thời gian trạng thái).
  So tooltip: !=20+2(lv-1), #=15+2(lv-1): code 15%/20% ở cấp 1 – khớp số nhưng không rõ ghép nhãn nào với số nào.
- Nếu đã có buff: gỡ, chờ 10 tick (~0.31 s) rồi áp lại (eio).
- Riêng bản thân: sm slot5>0 -> ftZ +0.3; bị động 10 có -> ftz +15 (tốc đánh) và F5 +10 (tỉ lệ chí mạng tối đa) – khớp mô tả Ngang Nhật Đồ.
- Hoa Khai Mạch (ei9, 70655): mỗi lần Q/W/E/D phát (eiJ) khi có E3C và học slot5, tối đa 16 tầng, mỗi tầng độc lập 10 s:
  chí mạng ft6 +(12+4*lv), phát huy cơ bản ftH và kỹ năng ftQ +(0.02+0.01*lv); bị động 9: thêm ftq (sát thương chí mạng) +0.01*lv9 mỗi tầng.
  Tooltip: #=16+4(lv-1) chí mạng, $=3+(lv-1)% – khớp. (eiJ gọi trong JsY/JCk/J4A; D không gọi.)
- Giãn cách 60 s: object data.

## 6. A0GT – Đoản Ca Hành – bị động chỉ số (126429): JGO .08, JGU .08 (phát huy cơ bản/kỹ năng), Nz .18 (tỉ lệ bỏng), FB .18 (kháng tỉ lệ thọ thương); mỗi k3 +.02. Không có hiệu ứng riêng.

## 7. A0GF – Tê Chiếu Phồn Thương – W (autocast B03J)
JCk (~83440), đạn JCD, tick JCa (rF95), lặp JCo mỗi 0.2 s.
- Sát thương: ftG(0.6+0.12/lv, 1.2+0.24/lv), hỏa 160+32/lv; x(1+0.03*lvQ); sm7 x1.2. k3=35: thọ thương 0.5 s, bỏng 2 s (khớp).
- 3 đạn: 1 ngay + 2 cách 0.2 s; gốc cách caster 80. Đạn 1 theo hướng mục tiêu; đạn 2,3 lệch ngẫu nhiên GetRandomInt(-2,2)*6 = -12..+12 độ (mô tả "hình quạt" – thực ra quạt hẹp ngẫu nhiên, đạn 1 không lệch).
- Đạn: tầm 600, 25/tick (800/s), bán kính 120, tối đa 7 mục tiêu/đạn, mỗi đích 1 lần/đạn. sm10>0: 30% hX=true.

## 8. A0GU – Kiếm Chủng Dẫn – D (bấm, fpZ; eqW dòng 60720)
- Điểm chuột kẹp 640. eqy: tick eqT mỗi 0.3 s x25 = 7.5 s (khớp). Bán kính 480 ($1E0), tối đa 7 mục tiêu/tick.
- Sát thương: ftG(0.45+0.09/lv, 0.75+0.15/lv), hỏa 110+22/lv; sm8 x1.2. Thọ thương 1 s 50% (khớp).
- Bị động 10 -> eqz: Kiếm Tiếu lên bản thân 7.5 s: sát thương chí mạng ftq +(0.08+0.02*lv10).

## 9. A0H0 – Bính Nhược Quan Hỏa – bị động: hiệu quả qua R (e_r: hồi 8%+2%*lv sinh lực/giây, 4 s) và Hoa Khai Mạch (+1%*lv sát thương chí mạng/tầng). Tooltip !=ezX(kf,1,1)=lv? và #=10+2(lv-1) – KHÔNG khớp hoàn toàn với 8%+2%*lv (lv1=10%: khớp #); không chắc ký hiệu nào hiển thị.

## 10. A0H1 – Ngang Nhật Đồ – bị động: JG4 .5 (+.15*k3) hỏa công, JG5 5 (+1*k3) tốc chạy, JGn 170 (+30*k3) né. Hiệu quả riêng: F +15 tốc đánh +10 chí mạng tối đa (bản thân); D -> Kiếm Tiếu (xem 8).

## 11. A0GG – Bách Điểu Triều Phượng – E (autocast B03K)
J4A (83465), đạn J4X, tick J4j (rF95), lặp J4M mỗi 0.15 s.
- Sát thương: ftG(0.75+0.15/lv, 1.6+0.32/lv), hỏa 200+40/lv; x(1+0.03*lvW); sm11 x1.2. k3=40: thọ thương 0.5 s, bỏng 2 s (khớp).
- 4 đạn SONG SONG cùng hướng mục tiêu, gốc cách caster 80, lệch ngang +75 (ngay), +25, -25, -75 (mỗi 0.15 s). Tầm 800 ($320), 25/tick, bán kính 120, tối đa 7/đạn.
- Bị động 12 (Phần Phách Tru Tâm): khi E phát (không phải khi trúng!) 75% và số Kiếm Ngâm đang có <3 -> J45 tại vị trí MỤC TIÊU.
- Bị động 14 + buff fm6: mỗi đích trúng nhận thêm hỏa sát ft2(800+240*(lv14-1)) sau 1 s (J4O/J4B).

## 12. A0H2 – Phần Phách Tru Tâm – bị động: JGR 44 (+6*k3) chí mạng.
Kiếm Ngâm J45 (83515): tại điểm mục tiêu, tick J4U mỗi 0.4 s x10 = 4 s, bán kính 250 ($FA), tối đa 7/tick, KHÔNG gây trạng thái.
Sát thương ftG(0.25+0.05/lv, 0.3+0.06/lv), hỏa 50+10/lv. Trong lúc tồn tại caster được e80 k2 +25 (mỗi Kiếm Ngâm). Tối đa 3 cái (EfR).

## 14. A0XB – Hỏa Hải Vô Nhai – bị động (126477; trigger eAQ/eAZ dòng 58060-58088)
- e80 Evj +0.01*k3 (sát thương lên hệ Kim; tooltip !=ezX(kf,1,1)). Thêm ability $41305844.
- Kích hoạt: EVENT_PLAYER_UNIT_ATTACKED với GetAttacker() = bản thân (khi bản thân ĐÁNH THƯỜNG), 100%, không cờ $41305843.
  Buff fm6 ($41305846) 30 s; giãn cách 60 s (cờ $41305843). Trong buff: mỗi đạn E trúng gây thêm hỏa 800+240(lv-1) 1 lần (trễ 1 s). Khớp mô tả.
