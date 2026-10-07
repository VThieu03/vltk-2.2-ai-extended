# Khảo sát trang bị KVCT (07/10/2026)

Nguồn: `D:\kvct-dev\work\readable.j` (bảng tạo trang bị quanh dòng 40225-40300), `listfile.txt` của map KVCT.

## 1. Trang bị KVCT không nằm trong dữ liệu vật phẩm
`ItemData.slk` / `ItemStrings.txt` của KVCT chỉ có khoảng 28 vật phẩm tùy chỉnh (`I000`-`I01B`: nguyên liệu, sách trùng sinh,
rương thần binh, đan dược…). **Trang bị thật được tạo bằng script** từ các bảng tên và icon theo ô + loại vũ khí + bậc.
Vì vậy muốn "copy trang bị KVCT" phải sao chép **bảng tạo trang bị và bảng icon**, không có sẵn danh sách vật phẩm để chép.

## 2. Mười ô trang bị (bảng `KU2`, icon bảng `KjF`)
| Ô | Tên | Icon (tiền tố) |
|---|---|---|
| 1 | nón | `Icon_PC_non` (cũng có `Icon_TBAH_non#_#`) |
| 2 | áo | `Icon_PC_ao` (`Icon_TBAH_ao#_#`) |
| 3 | lưng (yêu đái) | `Icon_PC_lung` |
| 4 | tay (hộ uyển) | `Icon_PC_tay` |
| 5 | giày | `Icon_PC_giay` |
| 6 | vũ khí | `Icon_VK_<loại>#` |
| 7 | liên (hạng liên) | `Icon_TS_lien` |
| 8 | nhẫn (giới chỉ) | `Icon_TS_nhan` |
| 9 | bội (ngọc bội) | `Icon_TS_boi` |
| 10 | hộ phù (hộ thân phù) | `Icon_TS_phu#_#` |

Mỗi loại icon có kèm bản lớn `LargeIcon_...` (hiển thị lớn trong hành trang / bảng nhân vật).

## 3. Mười một loại vũ khí (bảng `K5N`, icon bảng `Kjx`)
1 kiếm · 2 đao · 3 thương · 4 chùy · 5 triền thủ · 6 côn · 7 tụ tiễn · 8 phi đao · 9 trường đao · 10 đại đao · 11 phi tiêu.
Icon: `icon_vk_<loại>#` với `#` từ 1 đến 20 (kiếm `Icon_VK_kiem#`, đao `icon_vk_dao#`, thương `icon_vk_thuong#`, chùy `icon_vk_chuy#`,
triền thủ `icon_vk_trienthu#`, côn `icon_vk_con#`, tụ tiễn `icon_vk_tutien#`, phi đao `icon_vk_phidao#`, trường đao `icon_vk_truongdao#`,
đại đao `icon_vk_daidao#`, phi tiêu `icon_vk_phitieu#`), mỗi loại có thêm bản `Largeicon_vk_...`. Số `#` là bậc: dùng cho
ts 1…11 (và còn dư tới 20).

## 4. Phái dùng loại vũ khí nào (đọc từ icon `Icon_Attack_*` của bảng phái)
| Loại | Phái |
|---|---|
| kiếm | MGK, NMK, TYK, DTK, TDK, CLK, VDQ, VDK, HSQ, HSK, CMK |
| đao | TVD, TLD, TYD, TND, CLD, NDD, (TLBD, TDBD, HDTL, HDLS) |
| thương | TVT, TNK |
| chùy | TVC, MGC |
| triền thủ (quyền / chưởng) | TLQ, NDC, NMC, DTC, CBC, TDC |
| côn (bổng) | TLB, CBB |
| tụ tiễn | DMTT, CMC, DMPT |
| phi đao | DMPD |

(Trường đao, đại đao, phi tiêu có icon nhưng không phái nào ở trên chọn làm loại mặc định; có thể là vũ khí rơi / thần binh.)

## 5. Khác
- 5 hệ ngũ hành (Kim, Mộc, Thủy, Hỏa, Thổ) cho trang bị (`K5o`), 4 linh thú (`KXs`: Thanh Long, Bạch Hổ, Huyền Vũ, Chu Tước), 5 loại sát thương (`Klj`).
- Chuỗi dấu `*` (`EPB`, `Kjk`) là cách hiển thị cấp / số ô khảm.
- Boss **Tần Thủy Hoàng** có trong KVCT (model `Boss_tanthuyhoang.mdx`, hóa thân `BienThan_tanthuyhoang.mdx`), xuất hiện ở **Tần Lăng** cùng
  Bạch Khởi và Thái Sử Khang, kèm lối vào Tần Lăng mở / đóng theo giờ (`readable.j` dòng 53190-53284).

## 6. Hệ trang bị hiện tại của map (để đối chiếu)
- `war3map.w3t` có 327 vật phẩm (VLTK gốc, 4 loại: mũ, áo, vũ khí, giày; bậc +1…+3, đồ vàng / thần khí), phân loại ở `tools/gameplay_items.py`.
- Phiên khác đang làm 10 ô trang bị (`vl_eq_1..10`, hộ uyển, yêu đái…).
