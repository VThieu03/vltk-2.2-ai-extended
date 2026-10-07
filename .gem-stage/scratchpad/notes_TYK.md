# TYK (Thúy Yên Kiếm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Bảng chiêu: dòng 80975-81048 (marker phái A0BC = $41304243, sG=17, K8h[17] dòng 130618).
Thanh Q/W/E autocast: marker A0BC trong khối trúng đòn (dòng 127767-127780):
- buff B034 -> eQJ (Q, slot 1); B035 -> edc (W, slot 7); B036 -> Jsw (E, slot 11).
Tooltip chỉ số: nhánh `elseif sG[oY]==17` dòng 125534-125620 (khớp với code ở mọi chiêu đã kiểm).
AI tự dùng chiêu (105321): slot 10 "howlofterror" (khi chưa bật A0BL), slot 4 "taunt", slot 8 "thunderclap" (bấm vào điểm).

Quy ước: rF95=0.03125 s; eYQ(a,lv,b)=a+b*(lv-1); ftp = phát huy lực tấn công cơ bản; ft2 = băng công phẳng;
en4 = làm chậm (target, src, xác suất, giây); enJ = định thân. sm slot N >0 -> x1.2 (giống ghi chú khác, không rõ sm).
- **f5n(.24+.02*slot9, 0)** = nhân 1+random(0, 0.24+0.02*lv Phù Vân Tán Tuyết) vào phần băng công MỌI đòn của phái.
  Lưu ý: kể cả slot9 = 0 vẫn có random 0-24% (vì .24>0). Tooltip slot 9 "$" = 24+2*lv khớp.
- fUO (gọi ở 5 chỗ: eQ9, edF, Js7, edg, edM = Q, W, E, R hai đợt) -> JdN: hiệu ứng Tuyết Ánh Hồng Trần (slot 14).
- Không có dùng chung với TYD ngoài A0BO (slot3) và A0BQ (slot5) – xem tools/kskill.py OVR.

---
## 1. A0BM – Phong Quyển Tàn Tuyết – Q (autocast buff B034)
Hàm eQJ (đạn), tick eQ9.
- 1 đạn thẳng theo hướng caster->mục tiêu, sinh cách caster 40. Tốc độ xEkcq=15/tick (480/s), tồn tại ku9b/15=750/15=50 tick -> tầm 750.
- Bán kính trúng 100, tối đa 7 mục tiêu, mỗi mục tiêu 1 lần.
- Sát thương: phát huy cơ bản 100%+20%/lv, băng công 250+50/lv (khớp tooltip). Làm chậm 30% 2 s (đúng tooltip).
- Q cấp n làm W mạnh thêm 3%/cấp (ở edc) – đúng mô tả.

## 2. A0BN – Thúy Yên Kiếm Pháp – bị động (slot 2): chỉ cộng chỉ số (JGR 15+5/lv, JGK 5+1/lv, JG4 ob(băng công %) .8+.1/lv). Không hiệu ứng riêng.
## 3. A0BO – Tuyết Ảnh – bị động (slot 3) – dùng chung TYD. Chỉ chỉ số (+ hiệu ứng TYK_tuyetanh.mdl).

## 4. A0BP – Vũ Đả Lê Hoa – R (bấm, fCe; edt -> edr -> edS)
- Sát thương: phát huy cơ bản 90%+18%/lv, băng công 185+37/lv (khớp).
- Đợt 1 (ed6/edg): 8 đạn từ vị trí caster bay RA ngoài theo 8 hướng CỐ ĐỊNH theo bản đồ (EUP[ou] không bao giờ được gán => 0°; ±45, ±90, ±135, 180), không theo hướng mặt.
  Tốc độ dHv3=25/tick, 20 tick -> 500. Bán kính 110, tối đa 4 mục tiêu/đạn.
  **Lỗi code**: edg dùng EU7[ou] làm xác suất chậm nhưng EU7 không bao giờ được gán -> đợt 1 xác suất làm chậm 0%.
- Đợt 2 sau 0.6 s (edq -> edA/edM): 8 đạn sinh ở vòng bán kính 640 quanh VỊ TRÍ LÚC BẤM, bay VÀO trong (kK+180) 500. Bán kính 110, tối đa 4/đạn, làm chậm 80% 4 s.
  => 16 đạn = "16 chiêu thức". Một mục tiêu có thể ăn nhiều đạn (mỗi đạn có group riêng).
- Sau 1.2 s (tick thứ 2) edX: Xuân Nê Hộ Hoa: ene (hóa giải) + e80(100, k2) 4 s (suy: miễn nhiễm trạng thái, không chắc k2) – tooltip nói "kết thúc thi triển"; đúng 4 s.
- sm4>0: mỗi mục tiêu trúng (chưa có A0BF) bị ed5: -300 chỉ số x9 trong 10 s (không rõ x9).
- Giãn cách 8 s: dữ liệu object, không thấy trong code.

## 5. A0BQ – Hộ Thể Hàn Băng – bị động (slot 5) – dùng chung TYD (đã có OVR). Code tooltip: JGv .08+.02/lv (sinh lực %), thêm A0BR.
## 6. A0BT – Băng Cốt Tuyết Tâm – bị động (slot 6): JGO/JGU .08+.02/lv, e80 kC/NT .18+.02/lv. Chỉ chỉ số.

## 7. A0BU – Băng Tâm Tiên Tử – W (autocast buff B035)
Hàm edc -> edh (đạn), tick edF, đòn 2 eds -> edC.
- 1 đạn thẳng, sinh cách caster 60, tốc độ eIm75=24/tick (768/s), 912/24=38 tick -> tầm ~912. Bán kính 100, tối đa 7.
- Sát thương: phát huy cơ bản 150%+30%/lv, băng công 400+80/lv, x(1+3%*cấp Q). Chậm 35% 2 s.
- Mỗi mục tiêu trúng: đòn 1 ngay + đòn 2 y hệt sau 0.3 s (eds) -> "2 lần sát thương" (khớp). Có gọi fUX (không rõ).
- Mô tả "Tấn công của [Thủy Ánh Mạn Tú] tăng 3%/cấp": đúng (Jsw nhân 1+.03*slot7).

## 8. A0BV – Phi Tự Phiêu Hoa – D (bấm vào điểm, fzO; eHS chọn điểm, eHA -> eHM -> eHX, tick eHj)
- Điểm đặt: điểm chọn, nếu xa hơn 740 thì kéo về 740 theo hướng. Caster quay mặt về hướng đó.
- Vùng tại điểm: 26 tick, mỗi 0.3 s (7.8 s ~ "8 giây", "26 chiêu" khớp), bán kính 300, tối đa 7 mục tiêu/tick.
- Mỗi tick: băng công ngẫu nhiên [195+39/lv, 275+55/lv] (tính 1 lần lúc thi triển), KHÔNG có phần lực tấn công cơ bản.
  Làm chậm 50% 3 s, định thân 50% 1 s (khớp). Không gọi fUO (không kích Tuyết Ánh Hồng Trần).
- Giãn cách 12 s: object data.

## 9. A0BW – Phù Vân Tán Tuyết – bị động (slot 9): JGO/JGU .1+.02/lv, JG9 180+20/lv, JGn 160+40/lv; và f5n (xem trên).

## 10. A0BX – Băng Tâm Ngọc Lăng – F (bật/tắt, fxz; edD -> eda; buff ed4/edJ; phản đòn edk -> edo)
- Bật: thêm A0BL (fxT), ftR ob (băng công %) +(1.4+0.2*lv) (=160%+20%/lv... tooltip ! = 160+20(lv-1)), e80 sn (hồi phục sinh lực) +0.15*lv (tooltip # = 15/lv). Lần bấm 2 gỡ A0BL -> tắt, gỡ chỉ số. Không giới hạn thời gian.
- Phản kích: sự kiện EVENT_PLAYER_UNIT_ATTACKED (khi kẻ địch BẮT ĐẦU đánh, cả đánh xa), nếu có A0BL: băng công (1000+200/lv)*(1+0.4*sm10)*f5n vào kẻ tấn công. Không giãn cách, không xác suất.
- Lưu ý OVR hiện tại (kind 6, dur 20, chỉ số kháng) KHÔNG khớp code: code là bật/tắt vô hạn + phản đòn.

## 11. A0BY – Thủy Ánh Mạn Tú – E (autocast buff B036)
Hàm Jsw, tick Js7, thức 2 Jsv/JsV.
- 1 đạn thẳng từ caster về hướng mục tiêu, tốc độ vKzd=30/tick (960/s), mv3h=1100/30=36 tick -> tầm ~1100. Bán kính 220, tối đa 7. Chậm 40% 2 s.
- Đòn chính: phát huy cơ bản 200%+40%/lv, băng công 400+80/lv. Thức 2 "Phong Tuyết Băng Thiên": KHÔNG phải đạn mới; trên mỗi mục tiêu trúng 3 đòn mỗi 0.25 s:
  phát huy cơ bản 100%+20%/lv, băng công 300+60/lv. Tất cả x(1+3%*cấp W), x(1.17+0.03*cấp slot12) nếu có Thập Diện.
- Khi có slot12 VÀ đã học slot8 (D): 50% (+50*sm12) nếu không có A0C0 -> eH6: vùng Phi Tự Phiêu Hoa tại vị trí MỤC TIÊU (oR ban đầu), sát thương theo cấp slot12; khóa A0C0 9 s (eHg, tick 1 s).

## 12. A0BZ – Thập Diện Mai Phục – bị động (slot 12): JGy .13+.02/lv (kháng tỉ lệ trạng thái) + hiệu ứng E ở trên. Khớp mô tả.

## 14. A0WY – Tuyết Ánh Hồng Trần – bị động (slot 14) – JdN/Jdt/Jdr (128264)
- Chỉ số: e80 Evj .01/lv, sn .12/lv, sL .12/lv.
- Mỗi lần Q/W/E/R trúng 1 mục tiêu (qua fUO): 40% -> làm chậm 100% 3 s + băng sát 3 đòn mỗi 1 s, mỗi đòn Jmr(1000+300/lv)*f5n.
  Jmr = 0.5*o6*(chỉ số nguyên tố chính) + 0.5*o6*(tổng 5 chỉ số nguyên tố), *(1+k0) -> không phải băng công phẳng (không chắc tên chỉ số).
  Không giãn cách; D và F không kích.
