# DMPD (Đường Môn Phi Đao) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. DMPD = lớp sG==12 (`set Kuz[oY]="DMPD"` dòng 80602; bảng chiêu Ff dòng ~80646-80666). Marker autocast của lớp: `K8h[12]=A08F` (dòng 130613).
Ghi chú: hàm JDP (snd_DMPD1, dùng slot 7/1) là của lớp 35 = DMPT (marker A0XX/B07D, dòng 128007) — KHÔNG phải DMPD.

## Quy ước chung (đã kiểm)
- Tick `rF95` = 0.03125 s (1/32 s). `fS5(ou,true,f,T)` = hẹn giờ lặp chu kỳ T.
- `enJ(ke,target,k9,src)` = **định thân** (dummy A01C cast order "ensnare", dòng 300/302). Xác suất ke % (nhân (1+Rc nguồn)/(1+Rm+kF đích)), thời gian = k9 giây (k9*10 làm level dummy, chia kháng sV/kk; kẹp 0.1-5 s). Bị chặn nếu đích có k2/kV (% kháng) hoặc Rp>=1 (miễn định thân). Mọi chiêu đánh của DMPD gọi enJ(...,1.,...) → định thân 1 s.
- ftC(phys, h6, type, target, poisonHit, src) = sát thương trúng đòn; ftC(0,h6,xC,target,X,src) mỗi 1 s = **độc sát** (tick). Số tick độc = e84(k9) = k9*(1+Wt của đích) (+3%/cấp slot14 nếu nguồn có A08U – không áp cho DMPD).
- e12 (dòng ~65533): nếu có slot 9 (Thực Cốt Huyết Nhẫn) và đích có buff Câu Hồn (Bv=A08O) → sát thương ×(1.13+0.02*cấp slot 9).
- "sm" (cờ mật tịch nâng cấp, JlJ 128959): sm của chiêu đánh → sát thương ×1.2.

## 1. A08H Tiểu Lý Phi Đao – Q (slot 1, autocast)
- Kích hoạt: hero có A08F, khi đánh trúng mục tiêu có buff B02E → gỡ buff, gọi `Jsy(0,oR,oy,0)` (Jdd ~127705).
- Jsy (readable `function Jsy`): 1 phi đao từ vị trí người dùng (lùi ra 50) bay theo hướng tới mục tiêu, tốc 30/tick = 960/s, sống qol7k/mBut = 900/30 = 30 tick → tầm 900. Tick JsT: bán kính quét 100 (`$64`), **xuyên**, mỗi địch chỉ trúng 1 lần (group Bc), tối đa 7 mục tiêu tổng.
- Mỗi mục tiêu: định thân 30% 1 s (B2=30); sát thương Bm (ftG 1.0+0.2/cấp ... 2.0+0.4/cấp) + BG (ft2 200+40/cấp); độc Jsz(Bp=ftV 150+30/cấp, 2 tick ×1 s). Có e12 (Câu Hồn). sm1 → ×1.2 và hX=true.
- Khác mô tả: mô tả không nói xuyên/7 mục tiêu. Chú thích "tăng Nhiếp Hồn 3%/cấp" đúng: JxA nhân (1+0.03*cấp slot1).

## 2. A07S Đường Môn Ám Khí – bị động (slot 2)
- Jd8 (124943+), xT==2: lần đầu JGd .15 (EvX), JGR 15 (Fe), JGK 5 (tốc đánh), JG4 .8 (kE/oN); mỗi cấp +.05/+5/+1/+.1. Thứ tự map chỉ số ↔ "chính xác/độc công/chí mạng/tốc đánh" chỉ suy từ tên trường: JGK = tốc đánh (chắc), các trường khác không chắc.
- sm2: +300 sp (JlJ 129133). Không có hiệu quả riêng khác.

## 3. A07T Mê Ảnh Tung – F (slot 3, dùng chung với DMTT)
- e15/e1U (~65905): tầm tối đa f7l = 300 + 40*cấp; điểm chọn xa hơn → cắt về tầm. Không dùng được khi đang lướt (EWB) hoặc sJ.
- e1O/e1B: lướt 48/tick = 1536/s, số tick = khoảng cách/48; ẩn nút chiêu trong lúc lướt; dừng nếu gặp chỗ không đi được (ePc).
- Kết thúc lướt: nếu CHƯA có buff f7q (A07U) → e1l: Xuất Kỳ Bất Ý 5 s, ftH và ftQ +(0.12+0.03*cấp) (suy đoán: phát huy tấn công cơ bản/kỹ năng, theo mô tả). Đang có buff thì KHÔNG làm mới. sm3: thêm ftZ +0.2 (chỉ số không rõ); miễn kv/Wp chỉ khi sG==11 (DMTT), DMPD không có.
- Giãn cách 10 s (eLm/eLG đặt lại). Không gây sát thương.
- Khác mô tả: buff không refresh nếu còn; mô tả không nói tầm 300+40/cấp (dấu `!`).

## 4. A07W Tôi Độc Thuật – vòng sáng (slot 4)
- Jd8 xT==4: lần đầu JGe 70, JGY .1 (F8), JG4 .5, thêm ability A07W, aura model DMTT_toidocaura (JcZ, tham số $457=1111 – không chắc là bán kính); mỗi cấp +30/+.02/+.15. sm4: +10 Fh. Hiệu ứng lên đồng đội do ability WC3 – không kiểm.

## 5. A08J Mãn Thiên Hoa Vũ – R (slot 5, bấm)
- e1W (SPELL_CAST): điểm đích tối đa 740 ($2E4) từ người dùng. e1T (EFFECT) → e1z(oy,PB,50,...): 3 đợt (EX3=3), chu kỳ 1.0 s (đợt đầu sau 1 s – theo fS5, không chắc fS5 có chạy ngay không), tại điểm cố định, bán kính 300 ($12C), tối đa 7 mục tiêu/đợt.
- Mỗi đợt/mục tiêu: định thân 50% 1 s; sát thương mi (ftG .5+.1/cấp ... 2.0+.4/cấp) + GE (ft2 450+90/cấp); độc e1w(PB=ftV 600+120/cấp, 2 tick ×1 s). KHÔNG nhân e12.
- Câu Hồn: nếu có slot 9 và đích chưa có Bv → e1v: buff Bv 10 s; sm9 → ftr(-0.2) lên đích (chỉ số không rõ). Câu Hồn tăng sát thương Q, W, E (e12), không tăng R.
- Giãn cách 6 s theo mô tả (BlzSet… không thấy trong code; Jdc(120,40) – không chắc nghĩa).
- Auto: AI dòng 105233 dùng "thunderclap" khi bật autocast slot 5.

## 6. A081 Tâm Nhãn – bị động (slot 6)
- xT==6: JGO .08 (Fm), JGU .08 (k0) (phát huy cơ bản/kỹ năng), Rc +.18, Fc +.18; mỗi cấp +.02 tất cả. Rc là hệ số nhân xác suất định thân trong enJ (tương đối, không cộng %). Fc suy là kháng choáng (không chắc).
- sm6: JG3(xk,+100), FF +.3.

## 7. A08K Nhiếp Hồn Nguyệt Ảnh – W (slot 7, autocast)
- Kích hoạt: A08F + đích có buff B02F → `JxA(oR,0,oy,0)` (Jdd ~127712).
- JxA (90252): tâm = vị trí mục tiêu lúc kích hoạt (cố định). 6 tick ×0.16 s; sát thương ở tick 2,4,6 → 3 đợt cách 0.32 s, bán kính 280 ($118), tối đa 7/đợt.
- Mỗi đợt: định thân 35% 1 s; Bj (ftG .4+.08/cấp ... 1.0+.2/cấp) + BX (ft2 100+20/cấp), nhân (1+0.03*cấp slot1) và e12; chỉ đợt 3 thêm độc JxO(BM=ftV 250+50/cấp, 2 tick).
- Hiệu ứng: 3 lưỡi đao xoay (Jx5) + ám khí rơi (JxX) – chỉ hình ảnh.
- Khác mô tả: mô tả "phóng ra nhiều đao tầm xa" nhưng code là AOE tại vị trí mục tiêu; độc chỉ ở đợt cuối.

## 8. A08L Hàm Sa Xạ Ảnh – bị động (slot 8)
- xT==8: lần đầu JGR 45, JGJ .12 (F4); mỗi cấp JGR +15, JGK +1 (tốc đánh), JGJ +.03; JpP. sm8: k2 +15 (kháng khống chế % – k2 dùng trong enJ/en4/en9 → chặn trạng thái).
- Khác: mô tả "tốc đánh +!" nhưng tốc đánh chỉ cộng theo cấp (không có giá trị nền).

## 9. A08M Thực Cốt Huyết Nhẫn – bị động (slot 9)
- Không có chỉ số. Hiệu quả: R trúng → Câu Hồn 10 s (e1v), e12 ×(1.13+0.02*cấp) cho Q (JsT), W (JxM), E (JFm, JFh). Mô tả chỉ nói W, E – Q cũng được tăng.

## 10. A08P Ảnh Tung Trận – D (slot 10, bấm)
- eLG (~44225): 16 s (fkz=512 tick). Ngay khi bấm cộng +1 vào Rp (miễn định thân), kv (miễn en4 "slow" = chậm), Wp (miễn ena "drunkenhaze"), FW (miễn eno – đẩy/kéo), hn (miễn en9 "silence" – có lẽ choáng/thọ thương, không chắc) suốt 16 s (không phụ thuộc vị trí).
- Giãn cách F (A07T) đặt 0.2 s trong trận, hết trận về 10 s.
- fkR=480 tick (15 s): giữ buff Xuất Kỳ Bất Ý không hết (e1d) – chỉ nếu đã có buff (phải lướt F một lần).
- Mỗi 2 s (64 tick): nếu người dùng trong 500 ($1F4) quanh điểm bấm và chưa có fkO (A08R) → eLc: buff fkO ~2 s (63 tick), né tránh ngoại (FU) và nội (FJ) +(27+3*cấp)%. sm10: mỗi 2 s hồi 30% máu và 30% nội lực tối đa (ftl/ftB .3).
- 5 hiệu ứng ở bán kính 450 quanh tâm (eLF/eLs, 15 s) – có vẻ chỉ hình ảnh.
- Khác mô tả: miễn nhiễm có suốt 16 s ngay từ đầu, không theo nhịp 2 s; né tránh chỉ khi đứng trong 500 quanh tâm trận. Giãn cách 60 s chỉ theo mô tả.

## 11. A08S Vô Ảnh Xuyên – E (slot 11, autocast)
- Kích hoạt: A08F + buff B02G → `JFp(0,oR,0,oy)` (~127716). (Còn gọi JFp(50,...) cho dummy n0AP/n0B5 dòng 122197 – bản sao/triệu hồi.)
- JFp (93599): 1 phi đao từ người dùng hướng tới mục tiêu, tốc 50/tick=1600/s, 20 tick → tầm 1000, bán kính 100, nổ ở địch đầu tiên chạm.
- JFm: nổ bán kính 180 ($B4), tối đa 7: định thân 40% 1 s, O8 (ftG .5+.1 ... 1.3+.26) + Ou (ft2 130+26/cấp), nhân (1+0.03*cấp slot7), e12. Độc JFF: bình thường 2 tick ×On (ftV 400+80/cấp).
- Tâm Phách (slot 12): nếu có và roll 75% (MỘT lần cho cả lần nổ) → JFF(PB,PO,6): 6 tick, 2 tick đầu = On, 4 tick sau = PO (ftV 250+50/cấp slot12, sm12 ×1.2) – "Độc Thích Cốt".
- Sau đó JFc: 3 đợt nữa cách 0.1 s tại cùng điểm, bán kính 180, tối đa 7, định thân 40%, sát thương mi/GE, KHÔNG độc. Tổng 4 lần đánh = "Số chiêu thức 4".

## 12. A08T Tâm Phách – bị động (slot 12)
- xT==12: FJ +1/cấp, FU +1/cấp (né nội/ngoại, dòng 111116). Hiệu quả E như trên.

## 14. A0WT Bách Phát Bách Trúng – bị động (slot 14; mã $41305754)
- xT==14: lần đầu JmH 80, JmZ 80 (sinh khí/thân pháp), mỗi cấp +20/+20, JGK +8 (tốc đánh) và Evj +0.01 (sát thương lên Thổ +1%/cấp – suy theo mô tả).

## Đoạn code then chốt
Jsy/JsT/Jsz (Q); JxA 90252, JxM, JxO (W); e1T/e1W/e1z/e1P/e1v 65560-65690 (R); e1U/e1O/e1B/e1l/e1d ~65820-65910 (F); eLG/eLm/eLc/eLh ~44180-44240 (D); JFp 93599, JFG, JFm, JFF/JFs, JFc/JFh (E); enJ ~42880; e12/e84; Jd8 124943-125040 (chỉ số bị động); JlJ 129131 (sm); Jdd 127705-127717 (kích hoạt Q/W/E).
