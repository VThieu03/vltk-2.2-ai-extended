# MGK (Minh Giáo Kiếm) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. MGK = lớp sG==13, marker hero A08U ($41303855), `set Kuz[oY]="MGK"` dòng 80678; bảng chiêu Ff dòng 80721-80742. K8h[13]=A08U (130614).
Slot 1..12,14: A08W, A08X, A08Y, A08Z, A090, A093, A094, A095, A098, A099, A09A, A09B, A0WU. (Không thấy chiêu nào dùng chung với MGC sG==14 – MGC có bảng/hàm riêng.)
eYQ(base,cấp,step) = base + step*(cấp-1). ftp(...)=phát huy cơ bản (hệ số), ft2 = sát thương chiêu, ftV = độc sát/tick. "sm" = cờ mật tịch nâng cấp → ×1.2.

## Chung
- Độc sát của MGK: tick 1 s, số tick qua e84 (41716): ×(1+Wt đích + 0.03*cấp slot14) (A0WU, chỉ hero có A08U).
- Hoang Hỏa (slot 10, JEG 41? – hàm `JEG`): MỖI tick độc của Q/W (JEp, JFf; E/R qua JCF/Jkp – chưa mở, giả định tương tự, KHÔNG chắc) roll (8+cấp)% → sát thương tick ×(1.27+0.03*cấp).
- Autocast AI (105241): slot5 thunderclap (nếu chưa có A091), slot11 battleroar, slot7 howlofterror, ... theo cờ KNz.

## 1. A08W Thánh Hỏa Phần Tâm – Q (slot 1, autocast)
- Kích hoạt (127719): hero có A08U, trúng mục tiêu có buff B02J → gỡ buff, `JEv(oR,0,0,oy)` (71836).
- JEv: KHÔNG phải đạn bay: tạo vùng lửa cố định tại vị trí mục tiêu (model MGK_thanhhoapt), tick JEV mỗi 1 s, 4 tick (tick đầu sau 1 s).
- JEV: bán kính 150 ($96), mỗi địch chỉ trúng 1 lần cả đời vùng (group Ux), tối đa 7 mục tiêu/tick. Mỗi mục tiêu: định thân 30% 0.5 s; sát thương ftp(1.0+0.2/cấp) + ft2(200+40/cấp); độc JE2: 3 tick (+1 nếu sm slot **3** – lạ, không phải sm1) × ftV(200+40/cấp). sm1 → ×1.2.
- Khác mô tả: "đi qua" thực tế là vùng đứng yên 4 s; mô tả không nói 7 mục tiêu. "Tấn công Thánh Hỏa Liêu Nguyên +3%/cấp" đúng (JCp nhân 1+0.03*cấp slot1).

## 2. A08X Minh Giáo Kiếm Pháp – bị động (slot 2)
- 125052: lần đầu JGR 15, JGK 5 (tốc đánh), JG4(.8,oN); mỗi cấp +5/+1/+.1. sm2: JGR +50 (129163). Không hiệu ứng riêng. Map JGR/JG4 ↔ chí mạng/độc công: suy, không chắc.

## 3. A08Y Di Khí Phiêu Tung – bị động (slot 3)
- Lần đầu JG5 5 (tốc chạy), FJ +8 (né nội công); mỗi cấp +1/+2. Không hiệu ứng riêng. sm3 → +1 tick độc cho Q (xem trên).

## 4. A08Z Vạn Vật Câu Phần – W (slot 4)
- JFk (93447): chọn điểm, tầm tối đa 740 ($2E4), quay mặt. JFD (93416): mi ftp(2.8+0.56/cấp), GE ft2(560+112/cấp), PB ftV(700+140/cấp); sm4 ×1.2.
- JFa → JF4 mỗi 0.2 s, 2 đợt tại điểm: bán kính 200 ($C8), tối đa 7, chỉ sát thương (KHÔNG định thân, KHÔNG độc). = "Số chiêu thức 2".
- Sau đợt 2: 6 ngọn lửa JFJ bay ra theo góc facing+30/90/150/210/270/330, tốc 30/tick (960/s), tầm 600 ($258), bán kính 200, tối đa 7 mỗi ngọn; mỗi địch trúng 1 lần cho cả 6 ngọn (khoá chung pF). Trúng: định thân 50% 2 s, sát thương mi/GE, độc JFe 4 tick (+1 nếu học slot12) × PB.
- Giãn cách: 5 - 0.1*cấp slot9 (giây, không phải %). Mô tả "vòng lửa từ trung tâm" khớp.

## 5. A090 Càn Khôn Đại Na Di – D (slot 5)
- ely (46142): 15 s (15 tick ×1 s, elT). EvA +(0.08+0.02*cấp) (hút máu = chuyển hóa sát thương → sinh lực), Wp +1, Rp +1 (miễn choáng/định thân). Buff fCH, gỡ B02K khi hết. sm5: mỗi giây hồi 25% máu và 25% nội lực (ftl/ftB .25). Giãn cách 60 s theo mô tả (code không đặt).

## 6. A093 Ly Hỏa Đại Pháp – bị động (slot 6)
- Lần đầu JGO .08, JGU .08 (phát huy cơ bản/kỹ năng), Rc .18 (hệ số tỉ lệ định thân), Fc .18 (kháng choáng – suy), JGJ .12 (độc sát gây ra – suy); mỗi cấp +.02/.02/.02/.02/.03. sm6: JG3(xk,+100), FF +.3, JGJ +.15.

## 7. A094 Thánh Hỏa Liêu Nguyên – E (slot 7)
- JCv: điểm, tầm tối đa 740. JCp (91082): mi ftp(6+1.2/cấp), GE ft2(1200+240/cấp), PB ftV(700+140/cấp), cả 3 ×(1+0.03*cấp slot1); sm7 ×1.2.
- JCG/JCm: 10 tick ×0.1 s; mỗi tick 3 hiệu ứng rơi ngẫu nhiên ±200. Tick 6-10 quét bán kính 400 ($190), tối đa 10/tick, mỗi địch chỉ 1 lần → thực tế 1 đòn/địch. Định thân 35% 1 s, độc JCF 5 tick (+1 nếu học slot12) × PB.
- Giãn cách 8 - 0.16*cấp slot9 s.

## 8. A095 Thánh Hỏa Lệnh Pháp – F (slot 8)
- JEh (71762): thời lượng (14+cấp) tick ×0.5 s = 7+0.5*cấp s (khớp "!.@"). CD W/E/R đặt 0.3 s và reset ngay. Hết hạn (JEF) trả CD: W 5-0.1*cấp9, E 8-0.16*cấp9, R 10-0.3*cấp12. sm8: ftz +100 trong thời gian (chỉ số chưa rõ).
- Code bị động xT==8 thêm Jdc(400,160) (mana?) – không rõ.

## 9. A098 Nhân Huân Tử Khí – bị động (slot 9)
- JG4(.35*k3, oN) (độc công); CD W = 5-0.1*cấp (giây), E = 8-0.16*cấp (giây) → mô tả ghi % nhưng code trừ giây cố định (=2% của 5 s/8 s mỗi cấp, tức tương đương %). sm9: Fc +.6.

## 10. A099 Hoang Hỏa Ngọc Phần – bị động (slot 10)
- Hiệu ứng riêng ở JEG: mỗi tick độc roll (8+cấp)% → ×(1.27+0.03*cấp). sm10: JGO/JGU +.25.

## 11. A09A Kiếm Đãng Bát Hoang – R (slot 11)
- Jkz: điểm, tầm tối đa 740. Jkw (88619): mi ftp(2.4+0.48/cấp), GE ft2(480+96/cấp), PB ftV(700+140/cấp), ×(1+0.03*cấp slot **7**) (mô tả không nói); sm11 ×1.2.
- Jk7/Jkv: 4 tick ×0.2 s (tick 1 chỉ hiệu ứng 6 kiếm vòng 160). Tick 2,3,4: bán kính 500 ($1F4), tối đa 10/tick, KHÔNG loại trùng → mỗi địch trúng 3 lần; mỗi lần định thân 40% 1 s; đòn cuối thêm độc Jkp 6 tick (+1 nếu học slot12) × PB. Khớp "3 lần, kết thúc gây độc".
- Giãn cách 10 - 0.3*cấp slot12 s.

## 12. A09B Thánh Hỏa Thần Công – bị động (slot 12)
- JGJ .08 +.02/cấp (độc sát gây ra); CD R 10-0.3*cấp; có học → +1 tick độc cho W/E/R (không phụ thuộc cấp). sm12: FJ +10.

## 14. A0WU Mục Dã Ưng Dương – bị động (slot 14)
- JmQ 90 lần đầu +30/cấp (nội công), Evj +.01/cấp (sát thương lên Thổ); e84: số tick độc ×(1+0.03*cấp) (chỉ hero A08U).

## Hàm then chốt
JEv/JEV/JE2/JEp 71836 (Q); JFD/JFk 93416-93450, JFa, JF4, JFJ, JF9, JFe/JFf (W); ely/elT 46142 (D); JCp/JCv 91082-91114, JCG, JCm, JCF (E); JEh/JEF 71762 (F); Jkw/Jkz 88619-88650, Jk7, Jkv, Jkp (R); JEG (Hoang Hỏa); e84 41716; chỉ số bị động 125043-125137; sm 129161; kích hoạt Q 127719; AI 105241.
