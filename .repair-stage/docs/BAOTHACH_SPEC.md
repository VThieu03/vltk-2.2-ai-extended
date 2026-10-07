# Đặc tả hệ bảo thạch KVCT (chốt 07/10/2026) — dùng chung cho các nhóm việc

Yêu cầu của người dùng:
- **Không còn drop nguyên liệu để ghép đồ nữa** (nguyên liệu `zzVL_mat` / MATS rơi từ quái, boss…): bỏ rơi nguyên liệu ghép đồ.
- **Bảo thạch trong game lấy thuộc tính của KVCT** (icon KVCT `baothach<loại>_<bậc>.blp`, loại 1..6, bậc 1..9; chỉ số theo KVCT rồi **sửa lại cho phù hợp game**:
  cân với hệ 22 dòng chỉ số, cường hóa +10 gấp 4 lần, HP / sát thương của map). **Lấy icon bảo thạch KVCT về map.**
- **Tiệm tạp hóa nâng bậc bảo thạch**. Công thức nâng (người dùng chọn): nâng bậc t lên t+1 tốn **(GEM_UP_BASE + GEM_UP_STEP*(t-1)) viên bảo thạch cùng LOẠI cùng BẬC t** — cấp số cộng
  (mặc định base 2, step 1: bậc 1→2 cần 2 viên, 2→3 cần 3, … 8→9 cần 9) **cộng vàng cố định** (GEM_UP_GOLD, mặc định 500). Số liệu đặt ở `tools/config.py` (mục 12 mới, do nhóm SHOP viết).
- **Đảm bảo bảo thạch rơi đủ nhiều để đến phút 40 có bảo thạch bậc 8, 9 dùng được**. Vì công thức nâng nhân dần (bậc cao cần rất nhiều viên bậc thấp) nên **bậc rơi phải tăng theo phút**:
  quái rơi trực tiếp bảo thạch bậc cao dần (bậc tối đa đang rơi tăng theo thời gian), nâng bậc ở tiệm là đường phụ để gộp. Mốc đề xuất (sửa được trong config): bậc 1 từ phút 0, 2 từ 4, 3 từ 8, 4 từ 12,
  5 từ 16, 6 từ 22, 7 từ 28, 8 từ 33, 9 từ 40; trước phút 40 phải đủ bảo thạch bậc 8 để khảm đầy các ô của bộ đồ chính, bậc 9 xuất hiện từ phút 40.
- Giữ nguyên ghi công tác giả (vnakira; icon KVCT: Silva.Fox) và các mô tả trang bị ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]").

## 1. Mã vật phẩm mới (đã dành sẵn)
| Mã | Ý nghĩa |
|---|---|
| `IG11` … `IG19`, `IG21` … `IG29`, … `IG61` … `IG69` | bảo thạch loại 1..6, bậc 1..9. Mã = `I`,`G`,<loại 1-6>,<bậc 1-9>, ví dụ `IG35` = loại 3 bậc 5 |
Các bảo thạch cũ của map (12 loại `I101`..`I10C` và các loại khảm cũ) **được thay bằng hệ mới**: không còn rơi, không còn bán; xử lý đồ cũ người chơi đang có (giữ khảm đã gắn hoặc chuyển) do nhóm DATA quyết định và ghi rõ.

## 2. Giao diện lập trình (đặt trong `tools/jass/gameplay_14_gem.j`, do nhóm DATA viết; các nhóm khác chỉ GỌI)
- `function zzGM_Type takes integer vl_itemType returns integer` (1..6, 0 nếu không phải bảo thạch mới)
- `function zzGM_Tier takes integer vl_itemType returns integer` (1..9, 0 nếu không)
- `function zzGM_Code takes integer vl_type,integer vl_tier returns integer` (mã vật phẩm, 0 nếu ngoài khoảng)
- `function zzGM_Stat takes integer vl_type,integer vl_tier returns integer` (giá trị chỉ số đã cân cho game của một viên)
Hashtable `zzVL_ht` (loại vật phẩm bảo thạch): khóa 110 = loại, 111 = bậc.

## 3. Phân việc và ranh giới file
Không nhóm nào chạy pipeline (`scratchpad/run_pipeline.py`): nó ghi vào `src/map` và sao map, chạy song song sẽ hỏng. Chỉ kiểm tra cú pháp Python bằng `ast`; JASS phải đúng pjass
(local ở đầu hàm, không trùng tên biến toàn cục, chuỗi có `\\` kép, thụt lề 4 dấu cách). Cần sửa file ngoài quyền: ghi bản vá chính xác (file, vị trí, đoạn thay) vào
`docs/baothach/<NHÓM>_VABAN.md`, điều phối viên áp dụng. Không commit git. Ghi một dòng tiến độ vào `WORKLOG.md` (đừng xóa dòng người khác).

| Nhóm | File được sở hữu / tạo mới |
|---|---|
| **GEMDATA** | `tools/kvgem.py` (bước pipeline mới), `tools/kvgem_data.py`, `tools/jass/gameplay_14_gem.j`; phần khảm / chỉ số bảo thạch trong `tools/jass/gameplay_02_farm.j`, `gameplay_08_ui.j` (`zzVL_Kham*`, `zzVL_AffixSum` phần khảm), `tools/gameplay_items.py`, `tools/describe.py` |
| **GEMSHOP** | `tools/jass/gameplay_15_gemshop.j`, mục 12 mới "BẢO THẠCH" trong `tools/config.py` (GEM_UP_BASE, GEM_UP_STEP, GEM_UP_GOLD), phần bảng bán hàng của tiệm trong `tools/gameplay.py` (`table()` / `shops()`) |
| **GEMDROP** | `tools/jass/gameplay_16_gemdrop.j`; bản vá bỏ rơi nguyên liệu ghép đồ trong `gameplay_02_farm.j` (`zzVL_CampDeath` phần `zzVL_mat`), `gameplay_06_events.j`, `gameplay_05_quests.j`… ghi vào `docs/baothach/GEMDROP_VABAN.md`; mục rơi bảo thạch trong `tools/config.py` mục 13 mới |

Ghi chú: tiệm nâng bảo thạch dùng đơn vị **n00M** (Tàng Bảo Các, trước bán nguyên liệu; nay không còn nguyên liệu), đổi tên "Tiệm tạp hóa - Nâng bảo thạch". Tiệm vũ khí Tần Lăng (n00K) giữ nguyên.
Mỗi nhóm kết thúc bằng báo cáo ngắn: file tạo / sửa, hàm công khai (chữ ký), khóa hashtable / config mới, dòng móc nối cần thêm (vd gọi trong `zzVL_Init`), điều chưa chắc chắn.
