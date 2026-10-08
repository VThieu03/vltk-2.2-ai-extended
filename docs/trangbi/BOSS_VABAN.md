# Nhóm BOSS - bản vá cần điều phối áp dụng (Tần Thủy Hoàng)

File của nhóm: `tools/tanlang.py`, `tools/jass/gameplay_11_tanlang.j`. Mã đơn vị boss: **`n0TL`** (đã kiểm: không có trong `src/map/war3map.w3u` và `war3map.j`). Vật phẩm rơi: `'ITHB'`.

Cấu hình: KHÔNG sửa `config.py` (mục 8 thuộc nhóm SHOP). Số mặc định nằm ở đầu `gameplay_11_tanlang.j`, trong 5 hàm nhỏ
(JASS không cho khai báo hằng ngoài khối globals, nên dùng hàm trả số): `zzTL_FirstMinute` (30), `zzTL_Interval` (30),
`zzTL_Hp` (1.500.000 + 40.000 x phút), `zzTL_Damage` (2500 + 100 x phút), `zzTL_Armor` (150 + 4 x phút). Sửa số rồi chạy lại pipeline.

## 1. Móc nối JASS (bắt buộc)
File: `tools/jass/gameplay_08_ui.j`, hàm `zzVL_Init` (dòng ~2198, ngay sau/trước `call TimerStart(CreateTimer(),1.,true,function zzVL_EventTick)`).
Thêm một dòng:
```
    call ExecuteFunc("zzTL_Init")
```
Dùng `ExecuteFunc` (gọi theo tên chuỗi) vì `gameplay.py` ghép các module `jass\*.j` theo thứ tự tên và chèn `kskill.j`, `vlui.j`
TRƯỚC `zzVL_Init`; module 09-12 nằm SAU `zzVL_Init`, nên gọi trực tiếp `zzTL_Init()` sẽ lỗi "chưa khai báo" ở pjass.
Hệ quả: các nhóm khác cũng vậy (DATA / SHOP / DROP gọi hàm module 09-12 từ zzVL_Init phải dùng ExecuteFunc), hoặc điều phối
sửa `gameplay.py` (hàm `script`, chỗ `mod.index("function zzVL_Init ...")`) để chèn module 09+ trước `zzVL_Init`.
Module 11 chỉ dùng hàm / biến của module 01-08 (đứng trước), không cần bản vá nào khác.

## 2. Pipeline
File: `scratchpad/run_pipeline.py`, danh sách `pipeline`: thêm `"tanlang.py",` ngay sau `"import_boss.py",` (trước `"lvl200.py"`).
Lý do: nó ghi `war3map.w3u` (phải sau `convert_text.py`), chép 2 model và texture KVCT vào `src/map/war3mapImported` và `src/map/KVCT3_Data`.
Cũng cập nhật dòng pipeline trong `AGENTS.md` / `WORKLOG.md` / `docs/KIEN_TRUC_CODE.md` nếu muốn.

## 3. Lưu ý với nhóm khác
- Vật phẩm `ITHB` do nhóm DATA tạo. Nếu chưa có, `CreateItem` trả `null`, không lỗi nhưng không rơi gì.
- Hàm dọn đồ rác / tự bán đồ trong `gameplay_08_ui.j`: nếu có dọn vật phẩm nằm dưới đất thì phải bỏ qua `ITHB` (đề nghị DROP / DATA kiểm).
- Boss dùng hàm có sẵn: `zzVL_IsCreep`, `zzVL_All`, `zzVL_Log`, `zzVL_Name`, `zzVL_AddCT`, `zzVL_BannerMsg`, biến `zzVL_clock`, `zzVL_ht`, `zzVL_logMsg`. Đừng đổi tên chúng.
- Khóa `zzVL_ht` cha `'n0TL'` (khóa con 1, 2, 3) là của module này.
