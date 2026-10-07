# MGC (Minh Giáo Chùy) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. MGC = lớp sG==14 (khối `if GetUnitAbilityLevel(oy,$41303944)>0` dòng 80746, `Kuz="MGC"` dòng 80754; bảng chiêu Ff dòng ~80800-80820). Marker autocast `K8h[14]=A09D` (dòng 130615). Khối học chiêu/bị động: Jd8 `elseif sG[oY]==14` dòng 125140-125247.
Không có âm thanh snd_MGC. Các chiêu đều dùng hằng/biến riêng của MGC (không thấy dùng chung hàm với lớp khác trong các chiêu dưới).

## Quy ước (bổ sung cho notes_DMPD.md)
- `en9(src, giây, %xs, target)` = thọ thương (cấu trúc giống enJ: xác suất nhân hệ số h8 nguồn / FB+kF đích; chặn bởi k2/kV % kháng, hn>=1 miễn; giây*10 kẹp 1..50). Cờ `hn` = miễn thọ thương.
- `e80(x,u,FY)`: FY>=1 → mọi sát thương lên u = 0 (Jp0 dòng ~98000: `LoadReal(..FY)>=1.` → fEr=0).
- Bảng sm (mật tịch nâng cấp) có tác dụng: sm1/7/11 ×1.2 sát thương; sm3, sm4, sm5, sm8, sm9, sm12 xem từng chiêu.
- Độc sát: hàm e6u/etd/eqC/e6b/eZO đều = tick 1 s `ftC(0,h6,xC,...)`, số tick e84(k9) (k9*(1+Wt đích)).
- Autocast (Jdd dòng 127725): hero có A09D đánh trúng đích có buff → gỡ buff rồi gọi:
  B02M → `e6L(oy,0,oR,0)` (Q), B02N → `etU(oR,oy,0,0)` (W), B02O → `eqc(oR,oy,0,0)` (E). (oy = hero, oR = mục tiêu.)

## 1. A09M Khai Thiên Thức – Q (slot 1, autocast)
- e6L (dòng ~60000-60100): lưu vị trí MỤC TIÊU lúc đánh; sau 1 tick (0.03125 s) e6n nổ AoE tâm = vị trí mục tiêu, bán kính 150 ($96), KHÔNG giới hạn số mục tiêu.
- Mỗi địch: en9 thọ thương 30% 1 s; ftC(Un=ftG(1.0+.2/cấp, 2.0+.4/cấp), UL=ft2(200+40/cấp)); độc e6u(Ud=ftV(140+28/cấp), 2 tick).
- sm1 → ×1.2. Không nhận buff từ chiêu khác. "Tấn công của Long Thôn Thức +3%/cấp" đúng: etU nhân (1+.03*cấp slot1).
- Khác mô tả: mô tả "phạm vi nhỏ" → thực tế AoE 150 quanh mục tiêu, không giới hạn số lượng.

## 2. A09N Minh Giáo Chùy Pháp – bị động (slot 2)
- Jd8 xT==2: lần đầu JGd .15, JGR 15, JG4 .8 (oN); +.05/+5/+.1 mỗi cấp. (Giống mẫu DMPD slot 2; ánh xạ chỉ số ↔ chính xác/độc công/chí mạng chỉ suy đoán.) Không có hiệu quả riêng khác.
- Tốc đánh: đặt BlzSetUnitAttackCooldown(.5) trong khối khởi tạo lớp (dòng ~80766, chỉ khi Kuu>0 và Kun==0).

## 3. A09O Khốn Hổ Vân Tiếu – R (slot 3, biến EWl)
- e6Q (dòng ~60124): điểm đích = điểm chuột CP/Cz (hoặc fkm/fkG điểm autocast); xa hơn 700 ($2BC) → cắt về 700. Không dùng khi đang lướt (EWB) hoặc sJ. Quay mặt về hướng lướt.
- Sát thương: mi=ftG(5+1/cấp, 10+2/cấp), GE=ft2(1500+300/cấp), PB=ftV(600+120/cấp) (độc).
- e6H/e6Z: hero LƯỚT 48/tick (=1536/s), số tick = khoảng cách/48; dừng nếu gặp ô không đi được (ePc). Trong khi lướt, ẩn nút chiêu; mỗi tick quét bán kính 150 quanh hero: mỗi địch trúng 1 lần ftC(mi, GE) – KHÔNG khống chế, KHÔNG độc, không giới hạn số mục tiêu.
- Kết thúc: AoE bán kính 200 ($C8) tại điểm cuối, tối đa 7 mục tiêu: enJ định thân 50% **2 s** + độc e6b(PB, 4 tick). Không có sát thương trực tiếp ở điểm cuối.
- sm3: trong lúc lướt +100 k2 (kháng 100% khống chế) và FY+1 (miễn sát thương).
- Khác mô tả: mô tả "định thân 1 giây" → code 2 s; mô tả không nói sát thương dọc đường lướt.

## 4. A09P Kim Qua Thiết Mã – T (slot 4, biến f2Z)
- eS6 (dòng ~61960): mọi HERO đồng minh (kể cả bản thân) trong 1000 ($3E8). Chí mạng ft6 +(16+8*cấp) (làm tròn nguyên), sát thương chí mạng ftq +(.08+.02*cấp); đồng đội ×0.6. sm4: thêm ft1 +0.5 (×0.6 cho đồng đội; chỉ số ft1 chưa xác định).
- Duy trì 300 s ($12C/rF95), buff f2H=A09F (B02P). Nếu đã có buff: gỡ, sau 10 tick (0.3125 s) áp lại (làm mới). Giãn cách 15 s theo object data.

## 5. A09Q Phách Địa Thế – D (slot 5, biến fPy)
- eZM (spell cast): hướng = eub(hero) hoặc hướng tới fkm/fkG; quay mặt. eZj/eZ5 (spell effect, dòng ~67740): 1 đạn từ hero, tốc 30/tick (960/s), tầm 960 ($3C0) = 32 tick, bán kính 150, **xuyên**, mỗi địch 1 lần, tối đa 7 mục tiêu.
- Sát thương mi=ftG(6+1.2/cấp, 15+3/cấp), GE=ft2(1500+300/cấp), PB=ftV(750+150/cấp). Hệ số K9s bắt đầu 1.0, +0.25 sau mỗi mục tiêu (mục tiêu thứ n ×(1+0.25(n-1))) — đúng mô tả.
- Mỗi địch: enJ định thân 80% 2 s; độc eZO(PB, 4 tick).
- sm5: hX=true, uGd2u=.3, eIqet=999 (chưa rõ nghĩa — có thể bỏ qua phòng thủ 30%; KHÔNG chắc). (Lưu ý không có ×1.2 cho sm5.)
- Địa Liệt (slot 10): nếu EPk>0 khi phóng → lấy hết tầng (reset 0); mỗi địch trúng nhận eZL: K9F đợt (=số tầng) cách 0.1 s, mỗi đợt ftC(ftG(0, 4+.8/cấp10), ft2(400+80/cấp10)) với ju1gh=.05 (hút máu 5%, suy từ mô tả).

## 6. A09R Ngự Mã Thuật – bị động (slot 6)
- Jd8 xT==6: JGO .08, JGU .08 (+.02/cấp) = phát huy cơ bản/kỹ năng; Fc .18(+.02); FF, Fn, sV, ko .27(+.03); JG3(0, 90+20/cấp) (có lẽ kháng tất cả). Ánh xạ từng chỉ số sang dòng mô tả không chắc (Fn,sV = kháng thời gian định thân/thọ thương theo en9/enJ).
- Khác mô tả: KHÔNG thấy điều kiện "khi cưỡi ngựa" trong code — cộng vĩnh viễn khi học.

## 7. A09S Long Thôn Thức – W (slot 7, autocast)
- etU (dòng ~63700): tâm = hero + 100 về hướng mục tiêu (lúc đánh), sau 0.3 s etO nổ AoE bán kính 240 ($F0), không giới hạn số mục tiêu.
- Mỗi địch: en9 thọ thương 35% 1 s; ftC(ftG(1.5+.3/cấp, 3+.6/cấp), ft2(300+60/cấp)); độc etd(ftV(160+32/cấp), 2 tick).
- ×(1+.03*cấp Q). sm7 ×1.2. etB = chỉ hiệu ứng (4 vệt).

## 8. A09T Hồn Phách Phi Dương – F (slot 8, biến fG9)
- egj (spell cast): hướng = eub hoặc fkm/fkG. egU (dòng ~58730):
  - Bản thân: egL buff fGx=A09I (B02R) ftH + ftQ +(.12+.03*cấp) (phát huy cơ bản + kỹ năng), duy trì 6 s (+5 s nếu sm8 → 11 s).
  - 5 đạn song song cùng hướng, lệch ngang 0, ±100, ±200; tốc 15/tick (480/s), tầm 1000 ($3E8) ~67 tick (~2.1 s), bán kính 100, mỗi đạn tối đa 7 mục tiêu, mỗi địch 1 lần/đạn.
  - Trúng: nếu chưa có → debuff Kz7=A09H (B02Q) 10 s; không làm mới nếu đang có. Không gây sát thương.
  - B02Q: sát thương mục tiêu gây ra ×0.7 (Jp0 dòng 98674) — đúng mô tả -30%.

## 9. A09U Cửu Hi Hỗn Dương – bị động (slot 9)
- Học: thêm A09V. Trigger e_9/e_e (EVENT_PLAYER_UNIT_ATTACKED – khi BỊ RA ĐÒN đánh, không phải khi nhận sát thương phép), nếu không có A09W (cờ hồi chiêu) và HP<=50% → e_f.
- e_f: thêm A09W 30 s (giãn cách 30). e_K: buff fsg (B02S), miễn: hn (thọ thương), Rp (định thân), kv, Wp, FW (chậm/choáng/đẩy kéo – suy đoán); hồi (15+5*cấp)% HP tối đa mỗi 1 s, (2+cấp) lần (duy trì 2+cấp giây). sm9: ftZ +0.3 trong thời gian buff (chỉ số chưa rõ).
- Khác mô tả: chỉ kích hoạt khi bị đánh thường (event attacked).

## 10. A09X Liệt Diệm Thao Thiên – bị động (slot 10)
- Học: thêm A09Y, JGv .12 +.03/cấp (sinh lực tối đa %), FJ/FU +8 +1/cấp, eZl: mỗi 2 s +1 tầng Địa Liệt (EPk, tối đa 7, hiện trên multiboard).
- Né (Jp0 dòng ~98000): khi đích có A09Y, f0m += khoảng cách/22; né hoàn toàn nếu rand<FU+f0m (đòn hero-attack-type) hoặc FJ+f0m (loại khác); áp cho mọi sát thương TRỪ độc (xC). Thêm E7e nếu khoảng cách>=400 (chung).
- Khác mô tả: không chỉ "tầm xa" — áp mọi khoảng cách (cự li gần cho tỉ lệ thấp).
- Địa Liệt kích nổ: xem mục 5.

## 11. A09Z Khu Hổ Thức – E (slot 11, autocast)
- eqc (dòng ~60420): tâm cố định = hero + 150 về hướng mục tiêu; eqh mỗi 0.25 s, 2 đợt (0.25 s và 0.5 s), AoE bán kính 280 ($118), tối đa 7 mục tiêu/đợt.
- Mỗi đợt/địch: en9 thọ thương 40% 1 s; ftC(ftG(1+.2/cấp, 3+.6/cấp), ft2(300+60/cấp)). Độc eqC(ftV(200+40/cấp), 2 tick) CHỈ ở đợt 2.
- ×(1+.03*cấp W); sm11 ×1.2.
- Trấn Ngục (slot 12): nếu học, xác suất (40+10*sm12)% khi thi triển → 3 đạn eqk (hướng 0, ±15°) từ hero+100, tốc 30/tick (960/s), 25 tick (~750 → tới 850), bán kính 120, xuyên, mỗi đạn tối đa 7 mục tiêu; sát thương ftG(.4+.08/cấp12, .75+.15/cấp12)+ft2(100+20/cấp12), không độc/khống chế; hero hồi 20% HP tối đa (ftl .2) ngay.
- Khác mô tả: "Lưu Tinh … Số chiêu thức 3" = 3 đạn tỏa ±15°, không phải 3 lần đánh.

## 12. A0A0 Trấn Ngục Phá Thiên Kinh – bị động (slot 12)
- Jd8: xs +.06 +.02/cấp (giảm sát thương ngũ hành phải chịu). Hiệu ứng E: xem mục 11.

## 14. A0WV Không Tuyệt Tâm Pháp – bị động (slot 14)
- Jd8: JGe 380+120/cấp (có lẽ vật công ngoại), sp 300+100/cấp (bỏ qua né tránh?), k2 22+2/cấp (% kháng khống chế → "hóa giải trạng thái"), Evj +.01/cấp (hệ số khắc ngũ hành, dòng 98502). Ánh xạ tên chỉ số chưa chắc.
