# Báo cáo lag khi tung skill KVCT (tools\kskill.j)

Chỉ đọc, không sửa file nào. Số dòng là dòng trong `tools/kskill.j`, trừ khi ghi file khác.

## 1. Nguồn tải đã xác minh

### A. Đạn (zzKS_Missile / zzKS_Fly, dòng 274-336)
- Mỗi viên đạn có 1 timer riêng chạy mỗi 0.03 s (dòng 333) và 1 group `vl_hit` riêng (dòng 325).
- Mỗi tick, `zzKS_Fly` gọi `CreateGroup()` và `DestroyGroup()` (dòng 285, 304), `GroupEnumUnitsInRange` bán kính 120, 3 lần SaveReal và khoảng 6 lần Load (dòng 287-289), cùng 2 lần BlzSetSpecialEffectX/Y.
- Với mỗi đơn vị trong vòng quét, code gọi `LoadInteger(...,259)` hai lần và `CountUnitsInGroup(vl_hit)` (dòng 297). Hàm này duyệt ForGroup với độ phức tạp O(n) trên mỗi ứng viên.
- Đạn bay 40 đơn vị/tick, tầm mặc định 900, tức khoảng 23 tick. Ví dụ chiêu X241 (Lục Mạch Thần Kiếm 2) có 18 đợt, gap 0.10 s, tầm 1200, nên mỗi viên sống 30 tick. Kết quả là khoảng 9 timer 0.03 s chạy cùng lúc và khoảng 330 lần Create/DestroyGroup mỗi giây cho một người chơi.
- Chiêu quạt: X276 có 12 viên. Các chiêu X342, X296, X234, X160, X049 có 5-7 viên. Mỗi viên lại có timer, group và model riêng. Kind 21 (X087) bắn quạt 5 viên mỗi 5 s, suốt thời gian bật toggle.
- Không có giới hạn cứng số đạn sống cùng lúc. Riêng trường hợp key 259 = 0 thì số mục tiêu mỗi đạn cũng không giới hạn.

### B. Nhiều đợt (zzKS_Run / zzKS_Again, dòng 423-496)
- Mỗi lần cast tạo thêm 1 timer cho các đợt sau, mặc định 0.22 s mỗi đợt.
- Mỗi đợt gọi `zzKS_Do`. Với kind 4 nova, `zzKS_Area` (dòng 240-265) làm như sau:
  - tạo 1 group bằng CreateGroup, quét bằng Enum, rồi DestroyGroup;
  - tạo 1 hiệu ứng nền, là **model chiêu** (dòng 400);
  - với **mỗi** địch, `zzKS_Strike` (dòng 234) tạo thêm `AddSpecialEffectTarget(model chiêu)`, rồi gọi TpHit (một sự kiện sát thương), Status và Fx.
- Chiêu nặng nhất trong bảng `build/kskill_table.j`:
  - **X397** (TDC_sinhtuphu11): kind 4, **45 đợt**, không có 257/258/259. Bán kính 380, gap 0.22 s, kéo dài khoảng 10 s, **không giới hạn mục tiêu**. Với 30 lính, ước tính khoảng 1400 model hiệu ứng chiêu và 1350 sự kiện sát thương trong 10 s.
  - X423: 26 đợt, kind 4, không giới hạn mục tiêu.
  - X410: 25 đợt, kind 4, model 61 KB, không giới hạn mục tiêu.
  - X345: 20 đợt, gap 0.25 s.
  - X419: kind 5, 16 đợt, không giới hạn mục tiêu, model 56 KB.
  - X033: kind 17, 40 đợt, gap 0.30 s.
- Các field (FieldTick, dòng 539-591): X038 (18, 20 xung), X081 (13, 18 xung, 0.5 s), X228 (18, 16 xung). Mỗi xung tạo 1 group và 1 hiệu ứng nền, cộng 1 hiệu ứng trên mỗi địch (tối đa 7).

### C. Lướt (Dash, dòng 742-862) và bóng ảo, nguồn tải ĐỒ HỌA lớn nhất
- `zzKS_DashTick` chạy mỗi 1/32 s. Mỗi tick gọi `zzKS_Ghost` (dòng 825), hàm này gọi `AddSpecialEffect(<model tướng>)` (dòng 757).
- Model tướng là **Hero_*.mdx nặng 0.7-1.6 MB** (src/map/war3mapImported), có xương và animation walk (`BlzPlaySpecialEffect`, dòng 761). Thêm 1 timer cho mỗi bóng, sống 0.2 s.
- Kết quả: khoảng 7 bản model tướng đầy đủ animate cùng lúc, và 32 lần tạo model nặng mỗi giây cho mỗi người đang lướt.
- Chain (kind 11, `zzKS_ChainTick`, dòng 865-907) có 8 lần lướt, mỗi lần 10 bước, nên tạo 80 bóng tướng.
- `zzKS_DashHit` (dòng 780-809) với key 214 (chiêu X029) gọi `zzKS_QWE` trên **mỗi** địch trúng (tối đa 7), tức `zzKS_Run` × 3 chiêu Q/W/E, nên một lần lướt có thể kích hoạt **21 chiêu**. Mỗi chiêu lại có các đợt và đạn riêng. Đây là đỉnh tải tức thời (spike) dễ thấy nhất.

### D. Hiệu ứng trúng = model chiêu
- Mọi lần trúng đều dùng `LoadStr(...,250)`, tức chính model chiêu (cast/projectile), cho hiệu ứng trên mỗi mục tiêu. Các chỗ này nằm ở dòng 234, 574, 734 và 799/801.
- KVCT gốc (`D:\kvct-dev\work\readable.j`, hàm eST) dùng model nhẹ riêng cho hiệu ứng trúng, ví dụ `tX="Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl"`. Model đạn chỉ có 1 bản cho mỗi viên.

### E. Sự kiện sát thương
- Mỗi lần gọi `zzVL_TpHit` (gameplay_03_tranphai.j:40) đều đi qua `zzVL_OnDamage` → `zzVL_OnDamageBody` (gameplay_04_combat.j:220-400). Hàm này chạy hàng chục câu if và có thể `zzVL_Text` tạo texttag (dòng ~349, ~389).
- Tải này tỉ lệ thuận với số "đợt × mục tiêu" nêu ở mục B.

### F. AI và tự thi triển
- `zzVL_AutoTick` chạy mỗi 0.35 s cho người chơi, `zzVL_AiFight` chạy mỗi 0.5 s cho máy (gameplay_08_ui.j:1946-1947).
- Cả hai tung mọi chiêu ngay khi hết hồi (cooldown ≤ 15 s). Vì vậy 10 tướng đều xả chiêu liên tục.
- Hiệu ứng của tướng máy ở xa màn hình vẫn được tạo đầy đủ.

### G. Timer chu kỳ khác
- `zzKS_Tick`: 1 s. Với 10 người chơi, mỗi người duyệt khoảng 14 + 4 + N kỹ năng, mỗi kỹ năng khoảng 10 lần LoadInteger. Tải nhẹ, khoảng 1000 lần Load mỗi giây.
- `zzKS_BarTick`: 0.1 s, chỉ cho người chơi local. Tick này gọi `BlzFrameSetTexture` (icon) cho 8 nút **mỗi tick**, kể cả khi icon không đổi, cùng BlzFrameSetText/Visible. Tải UI vừa phải và có thể cache.
- `zzVL_TagTick`: 0.04 s, nhẹ.
- ToggleTick và Aura: 1 s.

### H. Rò rỉ và hashtable
- Timer, group và effect đều được Destroy hoặc Flush đầy đủ. Không thấy leak handle lớn.
- Ngoại lệ 1: `zzKS_Tick` dòng 1255 `AddSpecialEffectTarget(...,"weapon")` không bao giờ bị hủy. Cố ý, mỗi tướng 1 lần.
- Ngoại lệ 2: các khóa trên HandleId của địch (75, 76, 81, 68/69, -ab) không bao giờ được Flush khi lính chết. Hashtable phình dần, nhưng không gây giật.
- Hashtable trong vòng nóng: Fly gọi 3 lần Save và khoảng 8 lần Load mỗi tick mỗi đạn. `zzKS_Fx` và `zzKS_Status` gọi khoảng 10-15 lần Load cho mỗi mục tiêu bị trúng.
- `ExecuteFunc` chỉ dùng cho FieldX và SlotX, mỗi lần cast một lần. Không đáng kể.

### I. Nhật ký game
- `log.txt` chỉ ghi "tick <vàng>" và tên chiêu mỗi giây, không có dấu hiệu treo. Ví dụ từ 2:52 đến 2:58 vẫn đều đặn.
- Không thể đo FPS từ log này.

## 2. Vì sao hoạt ảnh "không giống" (so với KVCT eST/era)

| Thuộc tính | KVCT (eST, era) | kskill.j (zzKS_Missile/Fly) |
|---|---|---|
| Tốc độ đạn | 20/tick (eST, 640/s) hoặc 40/tick (era) mỗi 1/32 s | luôn 40 mỗi 0.03 s (≈1333/s): nhanh hơn ~2× cho chiêu kiểu eST |
| Kích thước | `BlzSetSpecialEffectScale(.4)` | không gọi Scale → 1.0, to gấp 2.5× |
| Độ cao | `BlzSetSpecialEffectZ(GetLocationZ+80)` (tuyệt đối, theo địa hình), 70 cho era | `BlzSetSpecialEffectHeight(60)`, không cập nhật khi đi qua dốc |
| Hướng | Yaw = góc +10° (eST) | Yaw = góc |
| Cập nhật | `BlzSetSpecialEffectPosition(x,y,z)` | chỉ SetX/SetY, Z không theo địa hình |
| Model đạn | model riêng của chiêu (vd `DTK_kimngocmanduong.mdl`) | model "một model mỗi chiêu" do kskill.py chọn theo tên gần đúng (dòng 941-958), nhiều chiêu dùng model *cast*/*caster* hoặc model chung theo phái (`pool[i % len(pool)]`) |
| Hiệu ứng trúng | model nhẹ (FrostArmorDamage …) | lại chính model chiêu → nhìn lặp, rối |
| Tối đa mục tiêu mỗi đạn | 7, dừng quét khi đủ (GroupClear) | key 259; nhiều chiêu = 0 (vô hạn) |
| Group quét | global `hW`, tái dùng | CreateGroup/DestroyGroup mỗi tick |

- KVCT cũng dùng một timer cho mỗi đạn (fS5). Vậy về số timer thì hai bên tương đương. Khác biệt chính nằm ở group, scale, Z và hiệu ứng trúng.
- Chu kỳ timer: KVCT dùng 0.03125, map dùng 0.03. Gần nhau.

## 3. Giải pháp, xếp theo (hiệu quả giảm lag) / (rủi ro)

1. **Giới hạn bóng ảo khi lướt.** Vị trí: `zzKS_DashTick`, dòng 824-827.
   - Thay đổi: chỉ tạo bóng mỗi 3 tick (lưu bộ đếm ở key 12 của timer).
   - Code đề xuất: `if ModuloInteger(vl_n,3)==0 then call zzKS_Ghost(vl_h,vl_a) endif`
   - Giảm tải: model tướng tạo ra giảm từ 32/s xuống khoảng 11/s, tức 3 lần. Đây là phần đồ họa nặng nhất.
   - Rủi ro: rất thấp, chỉ khác về hình ảnh.
   - Tùy chọn thêm: bỏ hẳn bóng nếu tướng không phải của người chơi local và không thấy được. **KHÔNG** tạo effect bên trong `GetLocalPlayer()` (gây desync). Nếu cần, chỉ đặt alpha 0 trong khối local.
2. **Giới hạn mục tiêu mặc định.** Vị trí: `zzKS_Area` dòng 244, `zzKS_Fly` dòng 297, `FieldTick` dòng 548.
   - Thay đổi: khi key 259 = 0 thì dùng 7, đúng như KVCT. Code: `if vl_max==0 then set vl_max=7 endif`.
   - Cách khác: sửa trong kskill.py, cho mọi chiêu thiếu `max` ghi 259 = 7.
   - Giảm tải: X397, X423, X410 và X419 giảm số hit × effect từ khoảng 30 xuống 7 mỗi đợt, tức 4×.
   - Rủi ro: thấp. Sát thương diện rộng lên đám đông giảm, nhưng đây đúng là hành vi KVCT.
3. **Hiệu ứng trúng dùng model nhẹ và giới hạn số lượng.** Vị trí: `zzKS_Strike` dòng 234, FieldTick dòng 574, DashHit dòng 799.
   - Thay đổi: thêm bộ đếm toàn cục `zzKS_fxN` (reset mỗi 0.1 s trong BarTick, hoặc dùng `TimerGetElapsed`). Khi đã có hơn 3 hiệu ứng trúng trong cùng một đợt thì bỏ qua AddSpecialEffectTarget.
   - Thêm một khóa mới (ví dụ 182) cho model trúng nhẹ, do kskill.py chọn theo kiểu KVCT, mặc định `Abilities\\Weapons\\...Impact`.
   - Giảm tải: 2-5× số effect khi đánh đám đông.
   - Rủi ro: thấp.
4. **Group toàn cục thay cho CreateGroup/DestroyGroup.**
   - Phạm vi: các hàm Fly, Area, Random, Near, FieldTick, Auto, ToggleTick, Curse, DashHit, ChainTick, Freeze.
   - Thay đổi: khai báo `group zzKS_g=CreateGroup()` trong globals (thêm vào phần globals mà build chèn), rồi dùng `GroupEnumUnitsInRange(zzKS_g,...)` + vòng FirstOfGroup/GroupRemoveUnit như hiện tại. Ở những chỗ `exitwhen` thoát sớm (Area dòng 249, FieldTick 563, Curse 730, ToggleTick 688, DashHit 788) phải thêm `call GroupClear(zzKS_g)` sau vòng.
   - Lưu ý tái nhập: TpHit → OnDamage → OnHit → zzKS_Run → Area có thể lồng vào nhau trong khi vòng ngoài còn duyệt. Cần **2 group** (một cho Fly, một cho các hàm khác), hoặc dùng mẫu "enum vào group cục bộ đệm toàn cục theo độ sâu": `zzKS_gs[zzKS_depth]`, mảng 8 group tạo sẵn, `set zzKS_depth=zzKS_depth+1` trước khi dùng.
   - Giảm tải: bỏ khoảng 300-1000 lần tạo và hủy handle mỗi giây khi giao tranh.
   - Rủi ro: trung bình nếu bỏ qua tái nhập. Dùng mảng theo độ sâu thì an toàn. pjass OK.
5. **Fly: bỏ CountUnitsInGroup và cache.** Vị trí: dòng 297.
   - Thay đổi: lưu số trúng vào key 3 của timer (`LoadInteger(ht,id,3)+1`) thay cho CountUnitsInGroup, và lưu `max` vào key 11 khi tạo đạn.
   - Thêm: khi đã đủ max thì kết thúc quét. Code: `if vl_max>0 and LoadInteger(zzVL_ht,vl_id,3)>=vl_max then` → `call GroupClear`. Có thể cho đạn chỉ bay tiếp mà không quét nữa.
   - Giảm tải: nhỏ đến vừa với nhiều đạn trong đám đông.
   - Rủi ro: rất thấp.
6. **Một timer chung 0.03125 s cho mọi đạn và mọi lần lướt (danh sách mảng).**
   - Thay đổi: thay `zzKS_Missile` và `zzKS_Fly` bằng mảng song song `zzKS_mE[]`, `zzKS_mH[]`, `zzKS_mX[]`… cùng `zzKS_mN`. Xóa phần tử theo kiểu swap-with-last. Timer toàn cục chỉ chạy khi `zzKS_mN>0`.
   - Tiện thể bỏ hẳn hashtable trong vòng nóng.
   - Group trúng của mỗi đạn vẫn cần, hoặc dùng mảng nhỏ nếu max ≤ 7.
   - Giảm tải: bỏ chi phí timer và hashtable mỗi đạn. Khoảng 2-3× cho phần logic đạn.
   - Rủi ro: trung bình. Phải viết lại khoảng 80 dòng và test kỹ chiêu quạt, kind 21 và 215. Mảng JASS giới hạn 8191 phần tử, nên đặt trần 300 đạn: khi đầy thì không tạo đạn mới.
7. **Chặn đệ quy QWE của lướt (X029, key 214).** Vị trí: `zzKS_DashHit`, dòng 795.
   - Thay đổi: chỉ gọi `zzKS_QWE` cho **mục tiêu đầu tiên**. Code: `if LoadInteger(zzVL_ht,vl_ab,214)>0 and vl_n==1 then`. Cách khác là giới hạn bằng cờ thời gian 0.5 s cho mỗi người chơi.
   - Giảm tải: mỗi lần lướt kích hoạt 3 chiêu thay vì 21 chiêu.
   - Rủi ro: thấp-trung bình. Cần xem KVCT gốc làm cho 1 hay tất cả mục tiêu. Mô tả "dash end casts the hero's Q W E" gợi ý chỉ 1 lần.
8. **Giảm đợt quá dày.**
   - Thay đổi: với kind 4/5 có hits > 12 và không có 258, đặt gap 0.3 và giảm hits theo tỉ lệ, giữ tổng sát thương. Lưu ý `zzKS_Hit` chia cho n nên phải chỉnh hệ số.
   - Làm trong kskill.py OVR cho X397, X423, X410, X419, X345 và X241.
   - Rủi ro: thay đổi nhịp chiêu. Nên làm sau cùng.
9. **Hình ảnh đạn giống KVCT.** Vị trí: `zzKS_Missile` dòng 320-322 và `zzKS_Fly` dòng 290-291.
   - Thêm `call BlzSetSpecialEffectScale(vl_e,.4)`. Nên đặt scale theo chiêu bằng một khóa mới do kskill.py ghi từ hàm KVCT tương ứng.
   - Dùng `BlzSetSpecialEffectZ` với Z địa hình +80 (MoveLocation + GetLocationZ, location toàn cục) và cập nhật bằng `BlzSetSpecialEffectPosition`.
   - Tốc độ theo chiêu (khóa mới, mặc định 20 hoặc 40 mỗi 1/32 s), chu kỳ timer 0.03125.
   - Không giảm lag, nhưng scale nhỏ hơn cũng giảm fill-rate. Rủi ro thấp.
10. **BarTick: chỉ đặt texture khi ability đổi.** Vị trí: dòng 1397.
    - Thay đổi: lưu `zzKS_bAb[vl_k]` và chỉ gọi `BlzFrameSetTexture` khi khác. Chỉ chạy trong ngữ cảnh local, không ảnh hưởng sync.
    - Giảm tải: nhỏ. Rủi ro gần như 0.
11. **AI xa người chơi.**
    - Thay đổi: trong `zzVL_AiFight` (gameplay_07_ai.j:137), bỏ qua tung chiêu (chỉ đánh thường) khi không có tướng người thật trong 2000 đơn vị. Đây là logic đồng bộ cho mọi máy nên an toàn.
    - Giảm tải: theo số máy AI giao tranh ngoài màn hình.
    - Rủi ro: AI yếu hơn khi đánh nhau ngoài tầm nhìn.
12. **Dọn hashtable của lính chết.**
    - Thay đổi: thêm `FlushChildHashtable(zzVL_ht,GetHandleId(u))` khi lính chết, nếu chưa có trigger nào làm.
    - Tác dụng: chống phình bộ nhớ dài hạn, không chống giật.

**Nên làm trước (nhanh, an toàn):** 1, 2, 7, 5 và 10. Sau đó làm 3 và 4 (group theo độ sâu). Cuối cùng là 6 (timer chung) và 9 (hình ảnh), vì cần test lại toàn bộ chiêu đạn.
Sau mỗi thay đổi JASS: build và chạy pjass.
