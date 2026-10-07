# TDC (Tiêu Dao Chưởng) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Bảng chiêu: dòng 81660-81737 (marker phái A0H3 = $41304833, sG=26, K8h[26] dòng 130627).
Tooltip số liệu: nhánh sG==26 dòng 126484-126580 (JdV: tham số cuối = "!", các tham số giữa = @/$/#; đã khớp với code ở mọi chiêu).
Thanh Q/W/E autocast: khối trúng đòn dòng 127893-127906 (khi oy có marker A0H3, xét buff trên mục tiêu oR):
- B04Q ($42303451) -> JD6 (Q, Dương Ca Thiên Quân); B04R ($42303452) -> J4S (W, Bạch Nhật Sâm Thần); B04S ($42303453) -> J4Q (E, Bài Sơn Đảo Hải).
  (Xác suất ra buff do object data, không có trong JASS.)
AI tự cast (105457): slot10 "fanofknives" (trừ khi có A0HG? $41304847), slot3 "taunt", slot8 "howlofterror" (điểm).

Quy ước: rF95=0.03125 s; eYQ(a,lv,b)=a+b*(lv-1); ftp(x)= phát huy lực tấn công cơ bản x; ft2(x)= hỏa công x; ftC(mi,..,GE)= gây sát thương.
ena(t,2.,chance,src)= bỏng 2 s; enJ(chance,t,dur,src)= định thân; en2(dur,chance,t)= hỗn loạn (SUY từ tooltip, chưa kiểm hàm).
ju1gh= tỉ lệ hút máu cho lần ftC kế tiếp (SUY: 1.=100% Sưu Hồn, .15=15% Thiên Tàm, khớp tooltip).
sm slot N>0 -> x1.2 sát thương (bí kíp?). egu(oY,oy) = cộng 1 tầng Bát Hoang Lục Hợp (slot 9), chỉ gọi khi Q/W/E ra đòn thật (o6==0).
"Tối đa 7 mục tiêu" = mỗi lượt quét GroupEnum dừng ở 7 kẻ địch.

---
## 1. A0H5 – Dương Ca Thiên Quân – Q (autocast, buff B04Q)
JD6 (~86560), tick JDg (.2 s). Âm snd_TDC_1.
- Tâm = vị trí MỤC TIÊU lúc phát động (cố định). 2 đợt, cách 0.2 s (đợt đầu sau 0.2 s), bán kính 150, tối đa 7/đợt.
- Bỏng 2 s xác suất 30. Phát huy 100%+20%/lv, hỏa công 200+40/lv. Khớp tooltip.
- Cấp Q tăng W 3%/cấp (đọc trong J4S). Gọi egu (tầng slot 9).

## 7. A0H6 – Bạch Nhật Sâm Thần – W (autocast, buff B04R)
J4S (~83590), tick J4q (.2 s). Âm snd_TDC_2.
- Tâm = vị trí mục tiêu lúc phát động. **3 đợt** (EeN=3) cách 0.2 s, bán kính 250, tối đa 7/đợt. Mô tả nói "tấn công 2 lần", số chiêu thức 3 → code = 3.
- Bỏng 2 s xác suất 35. Phát huy 120%+24%/lv, hỏa 230+46/lv, rồi x(1+0.03*lvQ). Gọi egu, fUX.

## 11. A0H7 – Bài Sơn Đảo Hải – E (autocast, buff B04S)
J4Q (~83790) -> J4H (trễ) -> J4Z -> J4b -> tick J41 (rF95). Âm snd_TDC_3.
- 3 đạn truy kích mục tiêu: đạn1 xuất phát 50 trước mặt (trễ .02 s), đạn2/3 lệch ±90° cách caster 120 (trễ .08/.14 s).
- Tốc độ 20/tick (=640/s), sống tối đa 50 tick (~1.56 s) hoặc tới khi cách mục tiêu <=50. Vùng trúng: tròn bán kính 160 tâm 80 trước đạn;
  mỗi kẻ địch trúng 1 lần/đạn, tối đa 7/đạn. Bỏng 2 s xác suất 40.
- Phát huy 175%+35%/lv, hỏa 350+70/lv, x(1+0.03*lvW). Gọi egu, fUX.
- Chỉ ĐẠN 1 khi tới mục tiêu (<=50) mới thử Thái Hư (slot 12) 75%.

## 3. A0HK – Hàn Tụ Huyệt – R (fm9, bấm, sự kiện 274 = spell effect)
eAU (57785) -> eAl -> tick eAd -> eAL -> eAn/eAu.
- Chọn NGẪU NHIÊN 1 kẻ địch trong 1200 quanh caster (eP3). Đạn từ 60 trước mặt, truy kích tốc độ 20/tick, sống tối đa 150 tick (~4.7 s).
- Chạm (<=40): AoE bán kính 300 quanh mục tiêu, tối đa 7: định thân 3 s xác suất 90; 1 đòn ngay + 3 đòn mỗi 1 s (=4 đòn, khớp "số chiêu thức 4").
  DoT bám từng mục tiêu, dừng nếu mục tiêu/caster chết.
- Phát huy 300%+60%/lv, hỏa 600+120/lv. Không gọi egu.
- sm>0: eAO buff caster 3 s (e80(+100,k2) + ene(...)) – không rõ k2/ene (không chắc).

## 8. A0HQ – Sinh Tử Phù – D (fzX, chọn điểm)
eiK (cast, 70590): điểm đích, tối đa 800 ($320). eiE (effect) -> eQi -> tick eQQ (.2 s) -> eQH -> tick eQZ (rF95), tầng eQb.
- 15 đợt x 0.2 s (3 s); mỗi đợt 3 đạn từ TÂM điểm bay ra ngoài, lệch nhau 120°, góc gốc ngẫu nhiên 0-180. Tổng 45 đạn (khớp).
- Mỗi đạn: tốc 20/tick, 40 tick (đi 800), bán kính trúng 100, 1 lần/mục tiêu/đạn, tối đa 7/đạn. Bỏng 2 s xác suất 50.
- Phát huy 60%+12%/lv; hỏa ngẫu nhiên [105+21/lv, 135+27/lv].
- Mỗi lần trúng (khi số tầng <15) +1 tầng Chân Khí Nghịch Lưu: +3%+1%/lv (.02+.01*lv) phát huy cơ bản & kỹ năng (ftH/ftQ), mỗi tầng tồn tại 6 s độc lập, tối đa 15.

## 10. A0HS – Thiên Tàm Cửu Biến – F (fyS, tự thân)
J0Q (73540) -> J0H -> tick J0Z (.5 s) -> J0b -> tick J01 -> J0N.
- 30 tick x 0.5 s = 15 s; buff fWE, tốc chạy +30 (fti); hết sớm nếu mất buff/chết.
- Mỗi 0.5 s: 3 kẻ địch ĐẦU TIÊN trong 1500 (FirstOfGroup, KHÔNG thật sự ngẫu nhiên), mỗi con 1 đạn truy kích (tốc 20/tick, tối đa 150 tick).
- Chạm: AoE 150, tối đa 4, hút máu 15%. Không trạng thái. Phát huy 100%+20%/lv, hỏa [180+36,250+50]/lv.
- (fys=A0ZG / J0p, J0G là chiêu phái khác, không phải TDC.)

## 14. A0XG – Tung Bộ Quan Hỏa – T (fYp, chọn điểm)
Jfb -> Jf1 -> tick JfN (rF95) -> Jft (buff).
- Tối đa 700 ($2BC); nhảy 54/tick theo parabol cao tối đa 320; trong lúc nhảy e80(+100,k2), e80(+1,FY) (SUY: bất tử/miễn trạng thái).
  Không cho dùng khi cờ EvR/EWB/sJ; ẩn nút chiêu trong lúc nhảy. Dừng nếu gặp ô không đi được (ePc).
- Đáp: buff 4 s: chí mạng +265+35/lv(lv1=265), sát thương chí mạng +17%+3%*lv (lv1=20%), chí mạng tối đa +25 (F5). Không cộng lại nếu đang có buff.

## Bị động
- 2 A0HI Tiêu Dao Chưởng Pháp: tốc đánh(JGR) 20+5/lv, chí mạng 6+1/lv, hỏa công 90%+10%/lv. Chỉ chỉ số.
- 4 A0HL Sưu Hồn Đại Pháp (eid/eil 71090-71135): né +200+30/lv (JGn), thêm ability A0HM.
  Phát: sự kiện EVENT_PLAYER_UNIT_ATTACKED (bản thân BỊ nhắm đánh, lúc ra đòn chứ không phải lúc trúng), sinh lực <=50%, không có A0HN (giãn cách).
  AoE 400 quanh bản thân, KHÔNG giới hạn mục tiêu: hỗn loạn 3 s xác suất 50+4/lv; 1 đòn ngay + 6 đòn mỗi 0.5 s (3 s), hút máu 100%.
  Phát huy 250%+50%/lv, hỏa 500+100/lv. Giãn cách 30 s (−10 s mỗi cấp sm).
- 5 A0HO Diệm Nguyên Luân Hồi (eBA/eBM/eBX/eBj/eBg, 48270-48360): kháng phản đòn 20%+2%, hỏa công 110%+10%.
  Mỗi 10 s: buff 256 tick = 8 s: giảm sát thương nhận 35%+5%/lv (ftZ .3+.05*lv), miễn 3 cờ hn/Rp/FW (mô tả liệt kê 4 loại – không chắc map).
  Sau 3 s (tick 160) gắn A0HP; sau đó bị nhắm đánh **3 lần** (EwJ=3, sự kiện ATTACKED) thì mất buff. Mô tả nói 2 lần → khác.
  sm>0: thêm +30% kháng phản đòn trong buff.
- 6 A0HJ Phục Nhật Xuất Vân: phát huy cơ bản & kỹ năng +10%+2%/lv, tỉ lệ bỏng (Nz) +20%+2%, kháng tỉ lệ thọ thương (FB) +20%+2%. Chỉ số.
- 9 A0HR Hỗn Nhật Khí Quyết: giảm sát thương ngũ hành (xs) 10%+2%/lv. Tầng Bát Hoang Lục Hợp (egu/eg8 58600-58630):
  chỉ cộng khi Q/W/E ra đòn (mỗi lần phát động, không theo số mục tiêu; R/D/F/đánh thường KHÔNG cộng). Mỗi tầng 10 s độc lập, tối đa 10:
  hồi phục (sn) +4%+1%/lv, kháng thời gian/tỉ lệ trạng thái (ftA/ftg) +1%/lv. sm>0: +20 (ft6) và ftz(+2) mỗi tầng.
- 12 A0HT Thái Hư Thần Công: hỏa công +65%+15%/lv. Bài Vân Chưởng (J4N): 75% khi đạn 1 của E tới mục tiêu; AoE 200 quanh mục tiêu, tối đa 7,
  phát huy 200%+40%/lv, hỏa ngẫu nhiên [400+80, 600+120]/lv, không trạng thái.
- Khối JlJ (129420) sG==26: xT2 JGR(50*k3), xT6 JG3(kN,80*k3)+Fn .3*k3 – không rõ mục đích (có thể điểm cường hóa).
