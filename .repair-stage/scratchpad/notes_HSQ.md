# HSQ (Hoa Sơn Khí Tông) – ghi chú cơ chế theo code KVCT

Nguồn: D:\kvct-dev\work\readable.j. HSQ = lớp sG==31 (marker A0KI=$41304B49, dòng 82038). `Kuz="HSQ"` dòng 82046; bảng chiêu Ff dòng 82092-82112.
Slot: 1 A0KJ(Q) 2 A0KM 3 A0KZ 4 A0L0(R) 5 A0L1 6 A0KN 7 A0KK(W) 8 A0L4 9 A0L3(D) 10 A0L2 11 A0KL(E) 12 A0KX 14 A0XP.
Marker autocast K8h[31]=A0KI (130632). Khối trúng đòn 127955-127968:
- buff B05Q ($42303551) → `JEM` (Q), B05R → `e1L` (W), B05S → `eZN` (E).
- Chỉ số bị động/tooltip: nhánh sG==31 dòng 127178-127260. Mật tịch (k3): 129498-129523.
- AI tự cast (105567): slot9 D ("taunt") nếu chưa có A0KV; slot4 R ("thunderclap") nếu chưa có A0KR.

Quy ước: enD=choáng; `ftp(x)` = % tấn công cơ bản; `ft2` = lôi công phẳng; ftC = gây sát thương; `ftb` = khuếch đại sát thương gây ra; `ftB/ftd` = hồi nội lực; `ftR(..,oi)` = % lôi công.
Hệ số chung Q/W/E (đòn gốc o6==0): × `eq3` (Khí Quán Trường Hồng, slot8) và ×1.2 nếu mật tịch (sm) của chiêu đó. W, E gọi `fUX` (proc bang hội, chung). Mỗi đợt tối đa 7 mục tiêu.

## 1. A0KJ Thanh Vân Tống Sảng – Q (autocast) — `JEM` → tick `JEX` mỗi 0.2 s
- Vùng tại VỊ TRÍ mục tiêu lúc trúng (cố định), bán kính 150, 2 đợt (0.2 s, 0.4 s), tối đa 7/đợt.
- Sát thương ftp(1.0+0.2*(lv-1)) + lôi 200+40*(lv-1). Mỗi trúng: choáng 30% / 1 s. Khớp mô tả.
- "Tấn công Ma Vân Kiếm Khí +3%/cấp" thực hiện trong e1L (W) — đúng.

## 2. A0KM Hoa Sơn Khí Công – bị động: chỉ chỉ số (JGR 15+5/cấp, JGK 5+1, JG4 .8+.1). Mật tịch: JGR +50.
## 3. A0KZ Long Nhiễu Thân – bị động: JG5 5+1, kháng chậm e80 ko .18+.02, JG3 x9 45+15. Mật tịch: JGm +.5.

## 4. A0L0 Chân Khí Hộ Thể – R — `elj` (cast), tick `el5` mỗi rF95, kết thúc `elU`
- Buff B05T, 5 s (R2I(5/rF95)=160 tick). Giảm sát thương EJV +(0.35+0.05*lv) (lv1 40%); kháng trạng thái k2 +(25+5*lv)% (lv1 30%).
- KHÔNG thấy giới hạn "36% sinh lực tối đa" trong code chiêu này (có thể nằm ở chỗ xử lý EJV chung — không kiểm).
- Hết 5 s (hoặc chết) → `elU`: choáng 100% / 3 s mọi địch bán kính 500 quanh người dùng (không giới hạn số mục tiêu).
  Nếu mật tịch slot4: hồi 50% sinh lực + 50% nội lực tối đa. Nếu học slot14 → `elO` (Tử Khí Đông Lai).
- Giãn cách 20 s theo dữ liệu ability (không trong code).

## 5. A0L1 Hải Nạp Bách Xuyên – bị động — `eAw` (bắt đầu khi học lần đầu) tick `eA7` mỗi 3 s
- Nếu nội lực ≥70%: GỠ buff B005/B007/B008/B009 (thọ thương/chậm/bỏng/choáng?) rồi `eAv`: 95 tick rF95 ≈ 3 s, cộng (0.25+0.05*lv) vào 8 chỉ số kháng (Fn, ko, FR, FF, FB, ks, NT, Fc = kháng tỉ lệ+thời gian).
- Mô tả không nói việc gỡ trạng thái đang dính – code có.
- Lôi công bị động: JG4 1.0+0.1/cấp.

## 6. A0KN Khí Chấn Sơn Hà – bị động: JGO/JGU .08+.02 (phát huy cơ bản/kỹ năng), Nl .18+.02 (tỉ lệ gây choáng), ks .18+.02 (kháng tỉ lệ chậm). Mật tịch: JGO/JGU +.3.

## 7. A0KK Ma Vân Kiếm Khí – W (autocast) — `e1L` → tick `e1n` mỗi 0.32 s → `e1u`/`e18`
- Vị trí mục tiêu cố định. Đợt chính chỉ ở tick thứ 2 (≈0.64 s): bán kính 300, tối đa 7, ftp(1.0+0.2*(lv-1)) + lôi 200+40*(lv-1), choáng 35%/1 s.
- Tick 3 (≈0.96 s) → [Ma Vân Khí Công] `e1u`: 3 đợt mỗi 0.5 s, bán kính 300, tối đa 7, ftp(0.8+0.16*(lv-1)) + lôi 155+31*(lv-1), KHÔNG choáng.
- Tất cả ×(1+0.03*cấp Q).

## 8. A0L4 Khí Quán Trường Hồng – bị động — `eq3` (gọi ở Q/W/E)
- Hệ số = 1 + floor(nội lực%/10)*0.1, trần 1.15+0.02*lv (lv1 = +17%, khác "mỗi 10% +10%" nếu tưởng tối đa 100%).
- Chỉ khi hệ số >1 và nội lực >20%: trừ 10% nội lực hiện tại (mỗi lần Q/W/E gốc).
- Mật tịch: thêm A0KP + `eqK`: mỗi 5 s hồi 15% nội lực tối đa.

## 9. A0L3 Tử Hà Chân Khí – D — `JfU`, tick `JfO` mỗi 1 s
- 20 s: lôi công ftR +(0.8+0.2*lv) (lv1 +100%), mỗi giây hồi (0.18+0.02*lv) nội lực tối đa (lv1 20%), miễn nhiễm 4 cờ e8f (kv, Etd, b6, FW = chậm/đóng băng/hỗn loạn/đẩy-kéo?).
- Mật tịch: khuếch đại sát thương +15% trong thời gian buff. Giãn cách 60 s theo dữ liệu.

## 10. A0L2 Huyền Nhãn Yên Vân – bị động: trong `eAv` (buff Hải Nạp): EJV +(0.08+0.02*lv) giảm sát thương trong ~3 s. Không thấy trần 36%. Mật tịch: JGO/JGU +.3 (129519; đoạn này thuộc xT==10).

## 11. A0KL Phách Thạch Phá Ngọc – E (autocast) — `eZN` → `eZt` (1 đợt sau 0.2 s)
- Hiệu ứng đạn bay (e8r) chỉ là hình; sát thương tại vị trí mục tiêu, bán kính 240, tối đa 7: ftp(2.0+0.4*(lv-1)) + lôi 500+100*(lv-1), choáng 40%/1 s.
- Mỗi mục tiêu trúng thêm [Tử Khí Đông Lai] `eZr`→`eZS`: 3 lần mỗi 0.2 s đơn mục tiêu, ftp(1.1+0.22*(lv-1)) + lôi 300+60*(lv-1).
- Tất cả ×(1+0.03*cấp W). Sau đợt, nếu học slot12 và cờ Exx tắt → `eZq`.

## 12. A0KX Thần Quang Toàn Nhiễu – bị động — `eZq` → `eZ6` mỗi 0.5 s
- Long Huyền Kiếm Khí tại vị trí mục tiêu E: 6 đợt / 0.5 s, bán kính 300, tối đa 7, ftp(3.0+0.6*(lv-1)) + lôi 800+160*(lv-1) (×1.2 mật tịch; mật tịch còn đặt pB7dn=.03 – ý nghĩa chưa rõ).
- "Giãn cách": cờ Exx bật lúc tạo, tắt ở đợt thứ 5 (~2.5 s) → không chồng 2 lượt; xấp xỉ 2 s mô tả.
- Chỉ số: JGy .13+.02/cấp (kháng thời gian ngũ hành).

## 14. A0XP Tử Khí Đông Lai – bị động — `elO`/`elB` (khi R kết thúc)
- 13 tick × 0.5 s = 6.5 s: mỗi tick hồi 100% nội lực tối đa; khuếch đại sát thương ftb +(0.33+0.03*lv) (lv1 36%).
- Chỉ số: e80 Evj +.01/cấp, JG4 +.5/cấp (tooltip ezX 3..36 / 50).
