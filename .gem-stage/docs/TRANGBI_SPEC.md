# Đặc tả hệ trang bị KVCT (chốt 07/10/2026) — dùng chung cho các nhóm việc

Yêu cầu của người dùng (nguyên văn tóm tắt):
- Copy toàn bộ trang bị KVCT sang map: **10 ô** (nón, áo, lưng, tay, giày, vũ khí, liên, nhẫn, bội, hộ phù) và **11 loại vũ khí**
  (kiếm, đao, thương, chùy, triền thủ, côn, tụ tiễn, phi đao, trường đao, đại đao, phi tiêu). Khảo sát: `docs/KVCT_TRANGBI.md`.
- **Không làm trùng sinh, làm CƯỜNG HÓA**: +1 dùng icon (và chỉ số) tương ứng trùng sinh 1, +2 ↔ ts 2 … +10 ↔ ts 10.
  **Cường hóa phải đổi cả icon lẫn chỉ số.** Giữ hệ 22 dòng chỉ số ngẫu nhiên kiểu Diablo hiện có.
- **Vũ khí trùng sinh 11 = "Vũ khí Tần Lăng"**: boss **Tần Thủy Hoàng** rơi **Tần Lăng Hòa Thị Bích**. Mua item vũ khí Tần Lăng tốn
  **vàng + một vũ khí +10 đang có + một Hòa Thị Bích**. Item vũ khí Tần Lăng **bán trong tiệm tạp hóa, thay cho những trang bị bán hiện nay**.
- **Quy định hệ nào mặc vũ khí nào**: kiếm thì dùng kiếm, không được dùng thương hay bổng. Bảng ở mục 3.
- Giữ nguyên ghi công tác giả (vnakira; icon KVCT Silva.Fox). Không ghi đè mô tả trang bị hiện có ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]").

## 1. Mã vật phẩm mới (đã dành sẵn, KHÔNG dùng mã khác, không đụng I0xx / IJxx cũ)
| Mã | Ý nghĩa |
|---|---|
| `ITV0` … `ITVA` | vũ khí gốc theo loại, thứ tự 0..10 = kiếm, đao, thương, chùy, triền thủ, côn, tụ tiễn, phi đao, trường đao, đại đao, phi tiêu |
| `ITS1` `ITS2` `ITS3` `ITS4` `ITS5` | nón, áo, lưng, tay, giày |
| `ITS7` `ITS8` `ITS9` `ITSA` | liên, nhẫn, bội, hộ phù (ô 6 là vũ khí nên bỏ qua) |
| `ITW0` … `ITWA` | **Vũ khí Tần Lăng** theo loại (cùng thứ tự với `ITV0..ITVA`), là trùng sinh 11 |
| `ITHB` | **Tần Lăng Hòa Thị Bích** (nguyên liệu, rơi từ Tần Thủy Hoàng) |

## 2. Cường hóa (bậc) của một món trang bị
- Bậc lưu trên **vật phẩm đang cầm** (handle): `LoadInteger(zzVL_ht, GetHandleId(item), 90)` = 0 … 10 (vũ khí Tần Lăng luôn là 11).
- Giao diện lập trình (đặt trong `tools/jass/gameplay_09_equip.j`, do nhóm DATA viết, các nhóm khác chỉ GỌI):
  - `function zzEQ_Tier takes item vl_it returns integer`
  - `function zzEQ_SetTier takes item vl_it,integer vl_t returns nothing` (đổi icon `BlzSetItemIconPath`, tên, mô tả, hệ số chỉ số)
  - `function zzEQ_Slot takes integer vl_itemType returns integer` (1..10, 0 nếu không phải trang bị KVCT)
  - `function zzEQ_WeaponType takes integer vl_itemType returns integer` (0..10, -1 nếu không phải vũ khí)
  - `function zzEQ_CanUse takes unit vl_hero,item vl_it returns boolean` (đúng loại vũ khí của phái, mục 3)
  - `function zzEQ_IsPlus10Weapon takes item vl_it returns boolean` (vũ khí +10, không phải Tần Lăng)
- Icon bậc t của vũ khí loại L: `war3mapImported\Icon_VK_<loại>t.blp` (kèm bản `Largeicon_...`); xem `docs/KVCT_TRANGBI.md` mục 3.
  Bậc 0 (chưa cường hóa) dùng icon bậc 1 hoặc icon gốc của vật phẩm (nhóm DATA chọn). Tần Lăng (11) dùng icon bậc 11.

## 3. Phái nào dùng loại vũ khí nào (đọc từ code KVCT)
| Loại (chỉ số) | Phái |
|---|---|
| kiếm (0) | MGK, NMK, TYK, DTK, TDK, CLK, VDQ, VDK, HSQ, HSK, CMK |
| đao (1) | TVD, TLD, TYD, TND, CLD, NDD |
| thương (2) | TVT, TNK |
| chùy (3) | TVC, MGC |
| triền thủ (4) | TLQ, NDC, NMC, DTC, CBC, TDC |
| côn (5) | TLB, CBB |
| tụ tiễn (6) | DMTT, CMC, DMPT |
| phi đao (7) | DMPD |
Loại 8 trường đao, 9 đại đao, 10 phi tiêu: chưa phái nào dùng (không bán trong tiệm, có thể rơi). Mỗi phái chỉ mặc **đúng một** loại ở trên.
Mã phái ↔ mã tướng: `tools/kskill_data.py` (`CLASS`).

## 4. Phân việc và ranh giới file (tránh giẫm chân nhau)
Không nhóm nào chạy pipeline (nó ghi vào `src/map` và sao map; chạy song song sẽ hỏng). Chỉ kiểm tra bằng `python -c "import ast..."`
cho Python và đọc kỹ JASS. Người điều phối (agent chính) sẽ chạy pipeline, bắt lỗi pjass, rồi nối các phần lại.
Nếu cần sửa **file không thuộc nhóm mình**, KHÔNG sửa: ghi bản vá chính xác vào `docs/trangbi/<NHÓM>_VABAN.md` (file, vị trí, đoạn thay) để điều phối áp dụng.

| Nhóm | File được sở hữu / tạo mới |
|---|---|
| **DATA** | `tools/kvequip.py` (bước pipeline mới), `tools/kvequip_data.py`, `tools/jass/gameplay_09_equip.j`, `tools/gameplay_items.py`, `tools/describe.py`, các hàm cường hóa / chỉ số trong `tools/jass/gameplay_02_farm.j` và `gameplay_08_ui.j` |
| **SHOP** | `tools/jass/gameplay_10_shop.j`, phần "Tần Lăng" mới trong `tools/config.py` (mục 8), phần bảng bán hàng (`table()` về cửa hàng) trong `tools/gameplay.py` |
| **BOSS** | `tools/tanlang.py` (bước pipeline mới), `tools/jass/gameplay_11_tanlang.j` |
| **DROP** | `tools/jass/gameplay_12_drop.j`; bản vá cho hệ rơi đồ hiện có (`gameplay_02_farm.j` phần rơi đồ) ghi vào `docs/trangbi/DROP_VABAN.md` |

Mỗi nhóm kết thúc bằng một báo cáo ngắn: file đã tạo / sửa, hàm công khai, các dòng móc nối cần thêm (ví dụ gọi trong `zzVL_Init`),
điều chưa chắc chắn. Ghi tiến độ vào mục "ĐANG LÀM" của `WORKLOG.md` (thêm một dòng, đừng xóa dòng người khác).
