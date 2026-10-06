# HSK (Hoa Sơn Kiếm Tông) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. Khối khởi tạo phái: dòng 82114-82190 (marker A0L5 = $41304C35, sG=32, K8h[32] dòng 130633).
Bảng chiêu (slot -> id): 1 A0L6, 2 A0LH, 3 A0KZ, 4 A0LO, 5 A0LP, 6 A0LI, 7 A0L7, 8 A0LJ, 9 A0LK, 10 A0LN, 11 A0LL, 12 A0LM, 14 A0XS.
Tooltip/chỉ số bị động: nhánh `elseif sG[oY]==32` dòng 127263-127343. JdV(@, kf, xT, oY, bool, $, #, !) – tức tham số 1 = "@", 6 = "$", 7 = "#", 8 = "!".
Cộng thêm theo k3 (mật tịch?): dòng 129524-129538.
AI tự cast: dòng 105579-105595 (slot 9 "taunt", slot 5 "howlofterror", slot 4 "thunderclap").

Autocast Q/W: khối trúng đòn dòng 127969-127977 (marker A0L5):
- buff B05W ($42303557) trên mục tiêu -> J46 (Q, Bạch Hồng Quán Nhật, đọc slot 1).
- buff B05X ($42303558) -> Js2 (W, Thương Tùng Nghênh Khách, đọc slot 7).
- KHÔNG có buff thứ 3: E (A0LO) là chiêu bấm (GetSpellAbilityId()==fWp).

Quy ước: rF95 = 0.03125 s; eYQ(a,lv,b)=a+b*(lv-1); ezX(lv,b,a)=a+b*(lv-1). ftG(oy,X,Y): X=% vật công ngoại, Y=phát huy lực tấn công cơ bản;
ft2(Z)=nguyên tố phẳng (tooltip gọi "Lôi công"). enD(target, %xs, src, giây) = choáng. Tối đa 7 mục tiêu mỗi đợt/mỗi đạn ở mọi chiêu.
sm slot N > 0 -> thường x1.2 sát thương hoặc hiệu ứng thêm (nghĩa chính xác của sm không chắc; có thể là bí kíp/cường hóa).

---
## 1. A0L6 – Bạch Hồng Quán Nhật – Q (autocast, buff B05W)
Hàm J46 (~83535), tick J4g. Âm thanh "snd_TVC_skill1.mp3" (dùng lại của TVC).
- Lấy vị trí MỤC TIÊU lúc kích hoạt (điểm cố định). 2 đợt, chu kỳ 0.24 s (fS5 .24; đợt đầu sau 0.24 s nếu fS5 không chạy ngay – không chắc).
- Mỗi đợt: AoE bán kính 150 quanh điểm, tối đa 7 địch; choáng 0.5 s xác suất 30% (ECv=30).
- Sát thương: vật ngoại 50%+10%/lv, phát huy cơ bản 100%+20%/lv, lôi 150+30/lv. Khớp tooltip (xT==1: @=50+10, #=150+30, !=100+20).
- sm slot1 >0: set hX=true trước ftC (có lẽ chí mạng chắc chắn – không chắc).
- Mỗi lần Q phát động (o6==0) còn gọi: Cửu Kiếm Hợp Nhất e_F nếu slot11>0 và hết giãn cách; Phá Kiếm Thức eH0 nếu slot10>0 và hết giãn cách.

## 2. A0LH – Kiếm Tông Tổng Quyết (bị động, slot 2)
Chỉ chỉ số (127269-127280): gốc JGd .15, JGR 15, JGK 5, JG4 .8; mỗi cấp +JGd .05, JGR 5, JG4 .1, JGK 1. Tooltip: !=5+5(lv-1)? (ezX(kf,5,20)=20+5(lv-1)) chính xác%,
@=ezX(10,90) lôi%, #=ezX(5,20) chí mạng, $=ezX(1,6) tốc đánh. Ánh xạ hàm JGx -> chỉ số không kiểm (không chắc). Khối k3 129528: e80(300*k3, sp).

## 3. A0KZ – Long Nhiễu Thân (bị động, slot 3)
Chỉ chỉ số: JG5 5 (+1/lv) [tốc chạy?], ko .18 (+.02/lv) [kháng thời gian chậm?], JG3(x9,45 +15/lv) [kháng băng]. Tooltip !=ezX(15,60), @=ezX(2,20)?, #=ezX(1,6)... (ánh xạ không chắc). k3: JGm(.5*k3).

## 4. A0LO – Thiên Thân Đảo Huyền – E (bấm, fWp)
JKF (chọn điểm) + JKC (sát thương) ~73800; JKx -> tick JKk chu kỳ 0.3 s. Âm thanh snd_TDK_4.mp3.
- Điểm rơi = vị trí con trỏ (CP/Cz) hoặc điểm AI lưu (fkm/fkG); giới hạn tầm 600 từ caster; caster quay mặt về hướng đó.
- 10 đợt (sm4>0: 15 đợt), mỗi 0.3 s (tổng ~3 s), AoE bán kính 300 quanh điểm cố định, tối đa 7 địch/đợt.
- Choáng 0.5 s xác suất 40%. Sát thương: vật 60%+12%/lv, phát huy 150%+30%/lv, lôi 270+54/lv (sm4: x1.2). Khớp tooltip.
- Giãn cách 5 s theo tooltip (lấy từ dữ liệu ability, không thấy trong code).

## 5. A0LP – Kim Nhạn Hoành Không – R (bấm bật buff, f2L)
eSU (~ek6) -> tick eSO mỗi 1 s, 20 lần (20 s).
- Bản thân: +tốc đánh (ftz) 8+lv; +né tránh (ftt) 170+30*lv; e8f(kv)+e8f(b6) (miễn nhiễm hỗn loạn, làm chậm – suy theo tooltip); thêm buff A0L8/A0L?.
- sm5>0: thêm e8f(Sj), e8f(FW) (không rõ loại miễn nhiễm).
- Mỗi giây: với MỖI địch trong bán kính 800 quanh caster (nếu tổng tầng <16) -> eSl cộng 1 tầng [Kiếm Vũ] CHO CHÍNH CASTER:
  mỗi tầng 4 s: +lv% (0.01*lv) phát huy lực cơ bản (ftH) và kỹ năng (ftQ), +5 tốc đánh. Tối đa 16 tầng (f26).
- KHÁC MÔ TẢ: tooltip nói Kiếm Vũ "làm giảm 15% tốc độ di chuyển và tấn công của mục tiêu" – code KHÔNG làm chậm địch; tầng là buff cho caster. # trong tooltip = ezX(1,1)=lv.
- Hết 20 s gỡ toàn bộ (tầng Kiếm Vũ tự hết sau 4 s). Giãn cách 30 s: dữ liệu ability.

## 6. A0LI – Hi Di Kiếm Pháp (bị động, slot 6)
Chỉ chỉ số: JGO .08 (+.02/lv), JGU .08 (+.02/lv) [phát huy cơ bản/kỹ năng], e80 Nl .18 (+.02), ks .18 (+.02) [tỉ lệ choáng / kháng tỉ lệ chậm]. k3: JG3(x9,100*k3), ko .3*k3.

## 7. A0L7 – Thương Tùng Nghênh Khách – W (autocast, buff B05X)
Js2 (~92170), đạn JsG -> tick Jsp(0.1667 s)/Jsm(rF95). Âm thanh snd_hsk2.wav.
- Hướng kK = caster -> mục tiêu lúc kích hoạt; xuất phát từ vị trí caster lúc kích hoạt.
- 3 đạo: đạo 1 ngay lập tức (lệch 40 về phía trước), sau 0.1667 s đạo 2 (lệch 40 sang trái -90°), sau 0.333 s đạo 3 (lệch 40 sang phải +90°). Cả 3 bay SONG SONG theo kK.
- Đạn: tốc 25/tick (800/s), tầm 600 (24 tick), bán kính chạm 110, xuyên, mỗi đạn trúng mỗi địch 1 lần, tối đa 7 địch/đạn.
- Choáng 0.5 s xác suất 35%. Sát thương: vật 50%+10%/lv, phát huy 120%+24%/lv, lôi 160+32/lv; x(1+0.03*lv Q) (đúng mô tả Q "tăng 3%/cấp"); sm7: x1.2. Gọi fUX (không rõ).
- Cũng kích hoạt Cửu Kiếm (e_F) / Phá Kiếm Thức (eH0) như Q.

## 8. A0LJ – Thái Nhạc Tam Thanh (bị động, slot 8)
Chỉ chỉ số: e80 FJ 8 (+2/lv) [né sát thương nội công %], k2 5 (+2/lv) [hóa giải trạng thái %], xs .1 (+.02/lv) [giảm sát thương ngũ hành]. k3: JGB(.25*k3).
Không tìm thấy logic riêng khác.

## 9. A0LK – Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm – D (bật/tắt, fhK)
eOy: nếu chưa có buff fh3 (A0LE) -> eOT bật; nếu có -> gỡ buff B061 (tắt). Tick eOz mỗi rF95.
- Mỗi 6 s (lần đầu SAU 6 s bật, không phát ngay) gọi eOP: +sát thương gây ra (ftb) 0.13+0.02*lv (=15%+2%/lv-1, khớp tooltip !=ezX(2,15)) trong 3 s.
- sm9>0: +1000 sp (e80 sp; có lẽ sinh lực tối đa – không chắc) suốt thời gian bật.
- Tắt khi chết hoặc mất buff. AI không cast lại khi đang có A0LE.

## 10. A0LN – Phá Kiếm Thức (bị động, slot 10) – phát từ Q/W
eH0 (~83550) -> tick eHE mỗi 0.5 s, 10 tick (5 s = giãn cách, cờ ECe).
- Tâm = vị trí caster lúc phát (cố định). 3 đòn: tick ECk=10,9,8 (t≈0.5/1.0/1.5 s), AoE bán kính 350, tối đa 7 địch, hút máu 5% (ju1gh=.05).
- Sát thương: vật 100%+20%/lv, phát huy 200%+40%/lv, lôi 300+60/lv. Không có trạng thái.
- [Phá Khí Thức]: +100 FJ và +100 FU (né nội/ngoại 100%) từ lúc phát đến tick 9 (~1 s). sm10: thêm ene (giải trạng thái?) + 100 k2 cùng thời gian.
- Điều kiện: chỉ phát khi Q hoặc W autocast kích hoạt (không phải "mỗi khoảng thời gian" độc lập).

## 11. A0LL – Cửu Kiếm Hợp Nhất (bị động, slot 11) – phát từ Q/W
e_F (~83400): 9 kiếm e_s ở góc kK, ±40, ±80, ±120, ±160 (kK = caster->mục tiêu), từ vị trí caster. Tick e_C mỗi rF95.
- Pha 1: bay thẳng 400 (20/tick=640/s, 20 tick). Pha 2: truy đuổi mục tiêu (đổi hướng mỗi tick về mục tiêu), số tick = khoảng cách lúc đó/20 (mục tiêu chết thì bay thêm 400 thẳng).
- Bán kính chạm 100, mỗi kiếm trúng mỗi địch 1 lần, tối đa 7 địch/kiếm. Choáng 1 s xác suất 50%.
- Sát thương: vật 80%+16%/lv, phát huy 200%+40%/lv, lôi 235+47/lv; sm11 x1.2.
- Giãn cách: e_k 4 s (Exu), trừ sm12 giây. LỖI: EC3 tính từ ECf[ou] TRƯỚC khi gán ECf -> đọc sai người chơi (thực tế thường 4 s).
- LỖI: "+3%/lv theo W" dùng LoadInteger(o8,eRS(oY,QS),7) – QS là khóa Real (chiều cao tooltip), không có SaveInteger -> nhiều khả năng luôn 0, buff 3%/cấp W không có tác dụng.

## 12. A0LM – Nhất Kiếm Phá Vạn Pháp (bị động, slot 12)
Chỉ số: JGR 40 (+10/lv) [chí mạng], JGY .1 (+.02/lv) [sát thương chí mạng]. Hiệu quả riêng trong e_F/e_C:
- Sát thương Cửu Kiếm x(1.16+0.04*lv) (= +20%+4%/lv-1, khớp #=ezX(4,20)); hút máu 5% mỗi đòn Cửu Kiếm (ju1gh=.05).

## 14. A0XS – Độc Cô Cửu Kiếm (bị động, slot 14)
Chỉ số: Evj .01*k3 [sát thương lên hệ Thủy], JGK 7*k3 [tốc đánh]. Hiệu quả riêng trong e_F:
- Mỗi lần Cửu Kiếm phát: 50% (GetRandomReal(0,100)<=50) – CHỈ kiếm đầu tiên (góc kK) mang hiệu ứng; khi kiếm đó kết thúc gọi e_x:
  AoE bán kính 150 tại điểm kết thúc, tối đa 7 địch, fth(2+0.1*lv) = sát thương % sinh lực hiện tại (2.1%..3.0%). Khớp tooltip "#.$%" (bc=20+kf).
