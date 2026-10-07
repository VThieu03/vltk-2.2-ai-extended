# Bản vá nhóm GEMDROP (07/10/2026) — điều phối áp dụng

## A. Bỏ rơi nguyên liệu ghép đồ (zzVL_mat / MATS)
Đã áp dụng trong `tools/gameplay.py`: vật phẩm cũ có metadata 53/44 bị xóa khỏi bảng rơi thay vì đổi thành nguyên liệu. `tools/jass/gameplay_02_farm.j` hiện không còn đoạn tạo nguyên liệu khi quái bãi chết. Các định nghĩa `MATS` và mảng cũ còn sót có thể được dọn sau; không còn là đường rơi.

### A1. tools\jass\gameplay_02_farm.j, zzVL_CampDeath — đã xóa đoạn:
```
    if zzVL_matN>0 and GetRandomInt(1,100)<=(18 * vl_drops) then
        call CreateItem(zzVL_mat[GetRandomInt(0,zzVL_matN-1)],GetUnitX(vl_d)+GetRandomReal(-40,40),GetUnitY(vl_d)+GetRandomReal(-40,40))
    endif
```
(Nếu `vl_drops` chỉ còn được gán mà không dùng thì giữ nguyên cũng không lỗi pjass.)

### A2. tools\gameplay.py, DROP_FN (hàm zzVL_Drop): bí phổ (khóa 53) / đồ khảm cũ (khóa 44) trong bảng rơi được xóa khỏi bảng rơi.
Cũ:
```
    "if vl_it!=null and zzVL_ht!=null and zzVL_matN>0 and (LoadInteger(zzVL_ht,GetItemTypeId(vl_it),53)>0 or LoadInteger(zzVL_ht,GetItemTypeId(vl_it),44)>0) then",
    "call RemoveItem(vl_it)",
    "return CreateItem(zzVL_mat[GetRandomInt(0,zzVL_matN-1)],vl_x,vl_y)",
    "endif",
```
Mới:
```
    "if vl_it!=null and zzVL_ht!=null and (LoadInteger(zzVL_ht,GetItemTypeId(vl_it),53)>0 or LoadInteger(zzVL_ht,GetItemTypeId(vl_it),44)>0) then",
    "call RemoveItem(vl_it)",
    "return null",
    "endif",
```

### A3. tools\gameplay.py dòng ~347-349 (bảng ghi mảng nguyên liệu) — XÓA 3 dòng (hoặc chỉ cần để matN=0):
```
    for i, m in enumerate(MATS):
        rows.append("set zzVL_mat[%d]='%s'" % (i, m))
    rows.append("set zzVL_matN=%d" % len(MATS))
```
Có thể giữ khai báo `integer array zzVL_mat` / `zzVL_matN` (dòng 219-220) để không sinh lỗi tham chiếu; sau A1, A2 không còn nơi nào đọc chúng. Hằng `MATS` (dòng 455) có thể xóa. Lưu ý: 5 người ở gameplay_08_ui.j (khoảng dòng 339-370, ghép I06K+I06N+I06M...) và zzVL_KhamInit (I06J..I06M) còn dùng các mã nguyên liệu — thuộc nhóm DATA / ghép đồ cũ, không phải chỗ rơi.

## B. Móc nối rơi bảo thạch
### B1. Thứ tự ghép module (tools\gameplay.py): đã thêm thứ tự `gameplay_14_gem.j`, `gameplay_15_gemshop.j`, `gameplay_16_gemdrop.j` trước `gameplay_12_drop.j`; cần tạo module 14 để pipeline chạy.

### B2. tools\jass\gameplay_12_drop.j, zzDR_DropKind: đã thêm sau `zzDR_Crystal`:
```
    call zzGD_Drop(vl_kind,vl_x,vl_y,vl_hero)
```

### B3. tools\kvequip.py, hàm rows(): đã thêm sau khối huyền tinh:
```
    # Ruoi bao thach theo lich phut (gameplay_16_gemdrop.j; config muc 13)
    r.append("call SaveInteger(zzVL_ht,0,360,%d)" % config.GD_CATCHUP_KILLS)
    r.append("call SaveInteger(zzVL_ht,0,361,%d)" % config.GD_MAX_PER_KILL)
    r.append("call SaveInteger(zzVL_ht,0,362,%d)" % config.GD_MAX_PER_KILL_BOSS)
    r.append("call SaveInteger(zzVL_ht,0,363,%d)" % config.GD_ENABLED)
    for t_ in range(1, 10):
        u_ = config.GD_TIER_UNLOCK[t_ - 1]
        n40_ = config.GD_TIER_N40[t_ - 1]
        s_ = config.GD_TIER_START[t_ - 1]
        rate_ = config.GD_T9_PER_MIN if n40_ is None else (n40_ - s_) / float(40 - u_)
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (370 + t_, u_))
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (380 + t_, round(rate_ * 1000)))
        r.append("call SaveInteger(zzVL_ht,0,%d,%d)" % (390 + t_, s_))
```
(Khóa parent 0 dùng: 360-363, 371-379, 381-389, 391-399. Hashtable người chơi 6300+người, khóa 1..9 — không trùng 6100 / 6200.)
