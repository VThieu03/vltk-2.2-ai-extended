# TVC (Thiên Vương Chùy) – ghi chú cơ chế theo code KVCT (readable.j)

Lớp: `set sG[oY]=2`, marker hero `A02B` ($41303242), bảng chiêu dòng ~79838 (hàm J4k).
Quy ước đã kiểm:
- `eYQ(base,lv,step)` = base + step*(lv-1); `ezX` tương tự (int).
- `rF95` = 0.03125 s (1/32). `fS5(ou,true,f,T)` = tick lặp chu kỳ T.
- `en9(caster,dur,chance,target)` = **thọ thương** (suy ra: Q tip "35% thọ thương 1s" khớp `en9(..,1.,35,..)`; duration chia cho kháng `Fn` của mục tiêu, Kim Chung tăng `Fn` = "thời gian bị thọ thương -%").
- `enJ(chance,target,dur,caster)` = **định thân** (suy ra từ Đoạn Hồn: tip "định thân 3 giây" ↔ `enJ(...,3.,...)`; Bất Diệt Sát Ý tăng `Rm` = kháng tỉ lệ của enJ ↔ tip "kháng tỉ lệ định thân").
- en4/ena/enD: TVC không dùng.
- `eno(angle,unit,dist,time,chance)` = đẩy/kéo unit theo góc angle quãng dist trong time giây (qua ePR); bỏ qua TAUREN (boss).
- `ftC(pctAtk,...,flat,...)` = gây sát thương; `ftG(oy,a,b)` hệ số % lực tấn công cơ bản (khoảng a..b – không chắc min/max hay ngoại/nội), `ft2(x)` = vật công cộng thêm.
- `sm` slot N = cờ "mật tịch/nâng cấp" của chiêu N (không chắc tên chính xác) -> thường x1.2 sát thương.
- Đòn Q/W/E kích hoạt trong handler trúng đòn, dòng 127565-127578: nếu attacker có A02B và mục tiêu mang buff
  B00L -> `eA8` (Q), B00O -> `J3D` (W), B00R -> `JeC` (E); buff bị gỡ ngay. Buff do ability autocast (object data) gắn – code không cho thấy xác suất/giãn cách đặt buff (không chắc).

---
## 1. A02C Hành Vân Quyết (Q)  – eA8 (dòng ~ tìm `function eA8`), tick eAY
- 1 đợt duy nhất (mm=1), tick sau 1/32 s.
- Vùng tròn bán kính **150** ($96) quanh **vị trí mục tiêu lúc trúng**; tối đa **7** mục tiêu.
- Sát thương: ftG(1.0+0.2(lv-1), 2.0+0.4(lv-1)) + ft2(200+40(lv-1)). Nếu sm1: set hX=true (hiệu ứng thêm, không rõ).
- Thọ thương: 35%, 1 s (`en9(mC,1.,35,xO)`).
- Khớp mô tả. "Tăng 3%/cấp Thừa Long" hiện ở W (W nhân 1+0.03*lv(Q)).

## 2. A02E Thiên Vương Chùy Pháp (bị động) – JdY xT==2 (sG==2, dòng ~123997)
- Học lần đầu: JGd +0.15 (EvX, chính xác?), JGR +15 (Fe, chí mạng?), JG4 +0.8 vào kE (vật công %). Mỗi cấp: +0.05 / +5 / (+0.1 kE – không chắc dòng này nằm trong khối sG==2).
- Không có hiệu ứng riêng ngoài chỉ số.

## 3. A01M Đoạn Hồn Thích (R) – eOv/eOV (48865), eO2 (48849), eOp (48807), eOG (48794)
- Lướt tới điểm chỉ định, tối đa **700** ($2BC); tốc 48 đv/tick 1/32s (=1536 đv/s). Dừng nếu gặp địa hình không đi được.
- Khi tới nơi: vùng tròn bán kính **200** ($C8), tối đa **7** mục tiêu:
  - định thân `enJ(30+6(lv-1)%, 3 s)`; thọ thương `en9(2 s, 30+5(lv-1)%)`.
  - **Không gây sát thương** (không có ftC).
- Đồng thời eOG "Thừa Phong Phá Lãng": buff 2 s (R2I(2/rF95) tick); +100 vào `k2` (k2 = xác suất miễn mọi trạng thái trong en9/enJ/...) => miễn nhiễm trạng thái; sm3: +1 `FY` (không rõ). Code KHÔNG gọi hàm giải trạng thái (ene) ở đây -> "hóa giải" chỉ qua miễn nhiễm/buff object data (không chắc).
- Ability bị ẩn trong lúc lướt (EWB=true). Giãn cách 6 s: object data.
- Khác mô tả: tip ghi "!% thọ thương 2s, @% định thân 3s" -> !=30+5/lv, @=30+6/lv (suy luận theo thứ tự tham số).

## 4. A02F Thiên Vương Bản Sinh (bị động) – JKW/JKy/JKz/JKP (≈74020-74110), gọi ở 98745
- Kích hoạt trong handler nhận sát thương (f09 = TVC bị đánh): cần A02B + A02G ($41303247, marker học chiêu) + không có A02J ($4130324A = đang giãn cách) + sát thương >0 + **HP% <= 40** -> xác suất **25+5*lv %**.
- Hiệu lực (JKz): 10 s (+2 s nếu sm4); +100 `k2` (miễn trạng thái), +1 `FY` (suy ra = miễn sát thương, không chắc), tô màu vàng; sm4: gọi `ene` (giải các buff xấu B005-B00C).
- Giãn cách (JKy): 45 - fKV giây (đếm 1s/tick), rồi fKV=0.
- Bất Khuất (JKR, sự kiện EVENT_PLAYER_UNIT_ATTACKED – khi bị đánh thường, không phải khi nhận sát thương kỹ năng): 12% mỗi lần, fKV+1, tối đa 15. Cộng dồn cả khi đang giãn cách (áp vào lần kế tiếp).
- Sinh lực tối đa +8% học lần đầu, +2%/cấp (JGv, JdY xT==4).

## 5. A02K Kim Chung Tráo (F) – eSh/eSF (61404), eSx, eSs, eSk
- Tức thì; tất cả **anh hùng đồng minh** trong bán kính **1000** (gồm bản thân).
- Kháng (ftT(0,...) – kháng tất cả? 4 hệ theo tip): 45+15*lv (code dùng lv thô, không phải eYQ); đồng đội 60% (làm tròn xuống).
- Fn += 0.25+0.05*lv (đồng đội x0.6). Fn là mẫu số thời gian thọ thương: thời gian thực = t/(1+Fn) -> giảm thực ≈ Fn/(1+Fn), không phải trừ thẳng %.
- Duy trì **300 s**. Nếu mục tiêu đang có buff: gỡ rồi áp lại sau 10 tick (0.3125 s) (eSs/eSC).
- sm5 (chỉ bản thân): ftr +0.15, ftS +80 (không rõ chỉ số).
- Giãn cách 15 s: object data.

## 6. A02N Bất Diệt Sát Ý (bị động) – JdY xT==6
- Lần đầu: JGO +0.08 (Fm), JGU +0.08 (k0) – phát huy tấn công cơ bản/kỹ năng; e80 sn +0.18 (hồi phục?), Rm +0.18 (kháng định thân, xác nhận Rm trong enJ). Mỗi cấp +0.02 tất cả. Không hiệu ứng riêng.

## 7. A02O Thừa Long Quyết (W) – J3D, tick J3a (chu kỳ 0.12 s)
- Hướng: từ TVC tới mục tiêu (lưu lúc kích hoạt). Tâm vùng = 100 ($64) phía trước vị trí TVC lúc kích hoạt; bán kính **220** ($DC).
- mL=4 tick x 0.12 s; gây đòn khi mL==3 và mL==1 => **2 đợt**, tại ~0.24 s và ~0.48 s. Mỗi đợt tối đa **7** mục tiêu (cùng mục tiêu có thể trúng cả 2).
- Sát thương: ftG(0.75+0.15, 1.5+0.3 /lv) + ft2(225+45(lv-1)), nhân (1+0.03*lv Q); sm7 x1.2.
- Thọ thương 40%, 1 s. Khớp mô tả.

## 8. A02P Trảm Long Quyết (D) – eLJ/eL9 (44021), eLe, eLf (lướt), eL3/eLK (vùng duy trì)
- Lướt tới điểm, tối đa **800** ($320), 50 đv/tick 1/32s (1600 đv/s).
- Đòn chạm đất: bán kính **300**, tối đa 7; thọ thương **100% 2 s**; **kéo** về tâm: eno(góc mục tiêu->tâm, 150 đv, 0.3 s, 100%), bỏ qua boss. sm8: ju1gh=0.1 (không rõ).
- Sau đó eL3: 4 đợt mỗi **0.5 s**, bán kính 300, tối đa 7/đợt, thọ thương 100% **1 s**, không kéo. Dừng nếu TVC chết.
- Tổng 5 đợt sát thương (khớp "5 lần"), nhưng chỉ đợt đầu kéo và thọ thương 2 s; 4 đợt sau thọ thương 1 s (khác mô tả).
- Sát thương mỗi đợt: ftG(2.4+0.48, 4.5+0.9 /lv) + ft2(700+140(lv-1)).

## 9. A02Q Càn Khôn Chùy (bị động) – elz/elP (gọi ở 98886 khi TVC nhận đòn)
- Mỗi lần bị đánh (trước kiểm tra sát thương >0): tầng 1 tạo bằng elP; các lần sau làm mới thời gian (6 + sm9 s) và +1 tầng nếu tầng < lv+5 => **tối đa lv+5 tầng**.
- Mỗi tầng: ftH +0.06, ftQ +0.06 (phát huy cơ bản/kỹ năng), ftA +0.04 (giảm thời gian trạng thái). Tick 1 s (elw).

## 10. A02U Hóa Kinh Quyết (vòng sáng) – JdY xT==10
- JGB (Fb, giảm sát thương nhận) +0.08 lần đầu, +0.02/cấp. Thêm ability ẩn A02V ($41303256) + hiệu ứng TVC_hoakinhquyet.mdl.
- "Tạ Kinh Quyết" (-30% sát thương kẻ địch gần, phạm vi 200): không tìm thấy code JASS; có lẽ do A02V (aura object data). Không chắc.

## 11. A02X Tung Hoành Tứ Hải (E) – JeC, tick Jex (0.1667 s)
- Tâm = 120 ($78) phía trước TVC theo hướng tới mục tiêu; bán kính **220**; mr=3 => **3 đợt** cách 0.1667 s (đợt đầu ở 0.1667 s).
- **Không giới hạn số mục tiêu** (không có đếm xR). Thọ thương 45% 1 s.
- Sát thương: ftG(0.8+0.16, 1.65+0.33 /lv) + ft2(250+50(lv-1)), nhân (1+0.03*lv W); sm11 x1.2.
- Jeo: chỉ hiệu ứng hình (6 tia ±12/36/60°).

## 12. A02Y Đảo Hư Thiên (bị động, kèm E) – JdY xT==12, Jek
- Sinh lực tối đa +8% lần đầu, +2%/cấp.
- Khi E kích hoạt: tung 75% một lần (nếu đã học slot 12). Nếu trúng -> **Jek gọi ở MỖI đợt của E (3 lần)**: bán kính **250** quanh vị trí TVC lúc kích hoạt, không giới hạn mục tiêu, không trạng thái; sát thương ftG(1.0+0.2, 2.0+0.4 /lv) + ft2(300+60(lv-1)), sm12 x1.2.
- Khác mô tả: tip ngầm 1 cú giậm; code gây 3 lần.

## 14. A0WA Thiên Mã Hành Không (bị động) – JdY xT==14
- Sinh khí JmH +80 lần đầu, +20/cấp; EPC/F5 +3 lần đầu, +0.5/cấp (chí mạng min/max); Evj +0.01/cấp (sát thương lên Mộc?). Slot 14 không có hiệu ứng riêng cho TVC (dòng 128265 thuộc lớp khác, không kiểm được lớp nào – không chắc).

(Không có slot 13.)
