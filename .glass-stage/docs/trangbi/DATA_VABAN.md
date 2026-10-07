# Bản vá nhóm DATA cần điều phối áp dụng

## 1. Thứ tự ghép module (BẮT BUỘC) - tools/gameplay.py, hàm script()
gameplay_09_equip.j chỉ phụ thuộc biến toàn cục + gameplay_01 (zzVL_Msg, zzVL_Text), nhưng gameplay_02 / 08 / 10 / 12 gọi zzEQ_*.
Thứ tự ghép phải là: 01, 09, 02, 03, 04, 05, 12, 06, 07, 08, 10, 11 (12 sau 02 và 09, trước 06). Hiện `files = sorted(...)` đặt 09 sau 08.
Chỗ sửa: sau dòng `files = sorted([...])` thêm
    order = ["gameplay_01_core.j", "gameplay_09_equip.j", "gameplay_02_farm.j", "gameplay_03_tranphai.j", "gameplay_04_combat.j",
             "gameplay_05_quests.j", "gameplay_12_drop.j", "gameplay_06_events.j", "gameplay_07_ai.j", "gameplay_08_ui.j",
             "gameplay_10_shop.j", "gameplay_11_tanlang.j"]
    files = [f for f in order if f in files] + [f for f in files if f not in order]

## 2. Bước pipeline mới (scratchpad/run_pipeline.py)
Chèn "kvequip.py" SAU "describe.py" và TRƯỚC "icons.py" (cần war3map.j đã có zzVL_Items; ghi thẳng hàm zzEQ_Items vào war3map.j).

## 3. Vũ khí khởi đầu đúng phái (tools/jass/gameplay_03_tranphai.j, zzVL_TpTick) - khuyến nghị
Vũ khí cũ vẫn mặc được mọi phái (không bị hạn chế), nên không bắt buộc. Muốn mọi tướng khởi đầu bằng vũ khí KVCT đúng loại, trong vòng
`loop exitwhen vl_i>4 ... UnitAddItem(vl_hero,CreateItem(zzVL_start[vl_i],...))` thay bằng: nếu vl_i==3 và zzEQ_StartWeapon(vl_hero)!=0
thì tạo CreateItem(zzEQ_StartWeapon(vl_hero),...) thay cho zzVL_start[3].

## 4. Nhóm SHOP: khi trừ vũ khí +10 đang MẶC
Cường hóa của món KVCT nằm trên món đồ (khóa 90), không còn theo ô. Khi tiêu thụ vũ khí +10 đang mặc (zzVL_equipItem[pid*10+5]) phải đặt
zzVL_equipItem[pid*10+5]=null rồi gọi zzVL_AffixSum(pid) (như tháo đồ). Mua xong, SetTier(item,11) đã đúng.

## 5. Nhóm DROP
Mọi món ITV*/ITS* có khóa 0 (loại*10+3), nên zzVL_RollAffix lăn chỉ số bình thường. zzEQ_SetTier(item,t) dùng cho bậc khởi đầu (t 0..10).
Dòng chỉ số ngẫu nhiên nay phụ thuộc ô: bảng zzEQ_AffixSlots trong gameplay_09_equip.j (xem báo cáo).
