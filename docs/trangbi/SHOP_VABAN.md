# Bản vá nhóm SHOP (vũ khí Tần Lăng) cần điều phối áp dụng

## 1. Móc khởi tạo (bắt buộc) - tools/jass/gameplay_08_ui.j, hàm zzVL_Init
Sau dòng `call zzVL_KhamInit()` (khoảng dòng 2023) thêm đúng một dòng (dùng ExecuteFunc vì gameplay_10 nằm SAU gameplay_08 trong file ghép):

    call ExecuteFunc("zzSH_Init")

(`zzVL_ht` và bảng dữ liệu đã nạp trước đó, nên đúng thứ tự.)

## 2. Yêu cầu với nhóm DATA
- Hàm dùng: zzEQ_CanUse(hero,item), zzEQ_WeaponType(itemType), zzEQ_IsPlus10Weapon(item), zzEQ_SetTier(item,11). zzEQ_WeaponType PHẢI trả đúng cho cả mã ITV? và ITW?, và cho vũ khí +10 (mã gốc ITV? hoặc mã vũ khí cũ) đã cường hóa.
- Vật phẩm ITW0..ITWA: lớp `ches`/Permanent, igol sẽ do gameplay.py shops() đặt = config.TANLANG_WEAPON_GOLD nếu ITW? đã có trong war3map.w3t lúc chạy bước gameplay. Nếu bước kvequip (tạo ITW?) chạy SAU bước gameplay thì kvequip phải tự đặt `igol = config.TANLANG_WEAPON_GOLD` (isto 10, istr 30, isst 0), nếu không giá hiện trên tiệm sai (JASS vẫn kiểm vàng bằng giá engine và hoàn đúng config.TANLANG_WEAPON_GOLD).
- Tên hiển thị món Tần Lăng do DATA đặt (tên không nằm trong config SHOP).

## 3. Cần biết khi nối
- zzSH_OnBuy là trigger SELL_ITEM riêng; zzVL_OnCraftBuy bỏ qua ITW? (key 60 = 0), không xung đột.
- ITHB phải nằm trong hành trang/đang mặc (dùng zzVL_FindMat). Nhóm BOSS/DROP đảm bảo ITHB nhặt vào zzVL_bag như vật phẩm thường.
- Mặc định tiệm bán vũ khí Tần Lăng là n00K (Cửa hàng vũ khí). Đổi bằng config.TANLANG_SHOP_UNIT.
