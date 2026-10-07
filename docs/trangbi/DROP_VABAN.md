# DROP — bản vá cho hệ rơi đồ hiện có (điều phối áp dụng)

File mới: `tools/jass/gameplay_12_drop.j` (nối SAU `gameplay_09_equip.j`, phụ thuộc `zzEQ_CanUse`, `zzEQ_SetTier`, `zzVL_RollAffix`).
Hàm công khai: `zzDR_Drop(unit dead, unit killer)` và `zzDR_DropKind(integer kind, real x, real y, unit hero)`; kind 0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss.
Điều kiện: nhóm DATA phải đăng ký hashtable của loại vật phẩm `ITV*`, `ITS*` (khóa 0 = mã loại, chia 10 >= 1) để `zzVL_RollAffix` lăn chỉ số.

## Bản vá — `tools/jass/gameplay_06_events.j`

Thứ tự ghép đề xuất trong `tools/gameplay.py`: 01, 02, 03, 04, 05, **09, 12**, 06, 07, 08, 10, 11 (12 phải đứng sau 02 và 09, trước 06).
Nếu thứ tự thực tế khác, đảm bảo 12 đứng trước 06 và sau 02, 09.

(a) `zzVL_CampDeath` (gameplay_02_farm.j): chỉ BỎ vòng rơi đồ cũ, đoạn cuối hàm `if vl_elite > 0 then loop ... zzVL_DropGear ... endloop endif` (còn lại giữ: nguyên liệu `zzVL_mat`, thưởng vàng/kinh nghiệm).
Lý do 02 không gọi trực tiếp: 12 ghép sau 02 nên JASS không cho gọi; và hashtable của quái bị Flush trong `zzVL_CampDeath`. Vì vậy rơi đồ gọi từ `zzVL_OnDeath` (06), đọc mức TRƯỚC khi gọi `zzVL_CampDeath`:

(b) `zzVL_OnDeath` (gameplay_06_events.j), ĐOẠN CŨ:
```
    if vl_d!=null then
        call zzVL_CampDeath(vl_d)
    endif
```
ĐOẠN MỚI (thêm local `local integer vl_kind` ở đầu hàm, cùng khối local):
```
    if vl_d!=null then
        set vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_d),10)
        if LoadInteger(zzVL_ht,GetHandleId(vl_d),9)>0 then
            call zzDR_DropKind(vl_kind,GetUnitX(vl_d),GetUnitY(vl_d),zzDR_KillerHero(vl_k))
        endif
        call zzVL_CampDeath(vl_d)
    endif
```
(khóa 9 > 0 nghĩa là quái bãi farm do `zzVL_CampSpawn` tạo; chỉ quái này rơi trang bị. `vl_k` = `GetKillingUnit()` đã có trong hàm.)

(c) `zzVL_BossKilled` (gameplay_06_events.j), ĐOẠN CŨ:
```
    call zzVL_DropGear(5, 5, GetUnitX(zzVL_boss), GetUnitY(zzVL_boss))
```
ĐOẠN MỚI (vl_pk đã là tham số):
```
    call zzDR_DropKind(3,GetUnitX(zzVL_boss),GetUnitY(zzVL_boss),Jx[vl_pk+1])
```
Giữ hai dòng `CreateItem('I00W', ...)` (nguyên liệu). Boss Tần Thủy Hoàng (ITHB) do nhóm BOSS xử lý riêng.

(d) Có thể xóa biến cục bộ không còn dùng (`vl_tier`, `vl_n`, `vl_k_loop`, `vl_i`, `vl_g`) — để lại cũng không lỗi.
Hàm `zzVL_DropGear` và bảng `zzVL_gear` / `zzVL_gearN` có thể giữ (không còn gọi) hoặc xóa khi nhóm DATA dọn bảng item cũ.

## Ghi chú
- `ELITE_DROP_MAX_TIER` / `BOSS_DROP_MAX_TIER` trong `tools/config.py` chỉ dùng cho bảng bậc trang bị VLTK cũ; hệ mới dùng hằng JASS ở đầu `gameplay_12_drop.j` (bậc cường hóa khởi đầu).
- Vũ khí Tần Lăng (ITW*) và ITHB không bao giờ rơi từ hàm này.
