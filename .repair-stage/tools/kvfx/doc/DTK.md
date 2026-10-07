# DTK (H00U): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/DTK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `DTK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Kim Ngọc Mãn Đường [Q]  (id X234, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **làm chậm** 30% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_kimngocmanduong.mdx` | `KVCT3_Data\Dawn_slash_Shoot.blp`, `KVCT3_Data\Dawn_lightning1.blp`, `KVCT3_Data\Dawn_lightning2.blp` | riêng phái, phái khác cũng dùng: DTC |

## 2. Đoàn Thị Tâm Pháp [bị động]  (id X235, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_khithontarget.mdx` | `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\Tornado2b.blp`, `Textures\RibbonNE1_blue.blp` | riêng phái |

## 3. Bắc Minh Thần Công [bị động]  (id X236, kind 0)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\BacMinhThanCong.mdx` | `ReplaceableTextures\Selection\SpellAreaOfEffect.blp`, `Textures\Ghost2.blp`, `Textures\CrystalSheild.blp`, `Textures\star4.blp` | dùng chung (model Thiên Kiếm) |
| aura bị động (gắn tướng suốt) | `DTK_bacminhaura.mdx` | `Textures\CrystalSheild.blp`, `Textures\Blue_Star2.blp` | riêng phái |

## 4. Lục Kiếm Tề Phát [bị động]  (id X237, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_luckiemtarget.mdx` | `KVCT3_Data\tx019-1.blp`, `KVCT3_Data\tx019-2.blp`, `KVCT3_Data\tx019-3.blp` | riêng phái |

## 5. Khô Vinh Thiền Công [bị động]  (id X238, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_luckiemtarget.mdx` | `KVCT3_Data\tx019-1.blp`, `KVCT3_Data\tx019-2.blp`, `KVCT3_Data\tx019-3.blp` | riêng phái |

## 6. Đoàn Gia Khí Kiếm [bị động]  (id X239, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_lucmachtarget42.mdx` | `Textures\Frost3.blp`, `Textures\Star7b.blp`, `KVCT3_Data\tx061.blp` | riêng phái |

## 7. Lục Mạch Thần Kiếm [W]  (id X240, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **làm chậm** 35% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_lucmachcaster.mdx` | `KVCT3_Data\AZ_BallisticQ1.blp`, `KVCT3_Data\AZ_Tornado11b.blp`, `Textures\Flare.blp`, `Textures\sun.blp`, `KVCT3_Data\AZ_Shockwave14.blp`, `Textures\Tornado2b.blp` | riêng phái |
| lúc tung (trên tướng) | `DTK_lucmachcaster.mdx` | `KVCT3_Data\AZ_BallisticQ1.blp`, `KVCT3_Data\AZ_Tornado11b.blp`, `Textures\Flare.blp`, `Textures\sun.blp`, `KVCT3_Data\AZ_Shockwave14.blp`, `Textures\Tornado2b.blp` | riêng phái |
| trên địch bị trúng | `DTK_lucmachtarget42.mdx` | `Textures\Frost3.blp`, `Textures\Star7b.blp`, `KVCT3_Data\tx061.blp` | riêng phái |

## 8. Kinh Thiên Nhất Kiếm [R]  (id X241, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **làm chậm** 100% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_kimngocmanduong.mdx` | `KVCT3_Data\Dawn_slash_Shoot.blp`, `KVCT3_Data\Dawn_lightning1.blp`, `KVCT3_Data\Dawn_lightning2.blp` | riêng phái, phái khác cũng dùng: DTC |

## 9. Bách Hồng Thực Nhật [bị động]  (id X242, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_lucmachthankiem3.mdx` | `KVCT3_Data\tx09_3.blp` | riêng phái |

## 10. Luyện Khí Hoàn Thần [bị động]  (id X243, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_luyenkhibuff.mdx` | `ReplaceableTextures\Selection\SpellAreaOfEffect.blp`, `Textures\Ghost2.blp`, `Textures\CrystalSheild.blp`, `Textures\star4.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DTK_luyenkhihh.mdx` | `KVCT3_Data\AZ_Flare6.blp`, `Textures\Flare.blp`, `Textures\Tornado2b.blp`, `KVCT3_Data\AZ_Shockwave12.blp`, `Textures\lensflare1Ax.blp`, `KVCT3_Data\Disruptor_Aghanim1_purple.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DTK_luyenkhi.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\Yellow_Glow2.blp`, `Textures\Flare.blp`, `Textures\snowflake.blp`, `Textures\Clouds8x8.blp`, `Textures\Ghost2.blp`, `Textures\rainTail.blp`, `Textures\snowflake2.blp`, `Textures\Blue_Star2.blp` | riêng phái |

## 11. Khí Thôn Vạn Lý [E]  (id X244, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **làm chậm** 40% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_lucmachcaster.mdx` | `KVCT3_Data\AZ_BallisticQ1.blp`, `KVCT3_Data\AZ_Tornado11b.blp`, `Textures\Flare.blp`, `Textures\sun.blp`, `KVCT3_Data\AZ_Shockwave14.blp`, `Textures\Tornado2b.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `DTK_khithonvanly.mdx` | `KVCT3_Data\flareshot01_bw.blp`, `KVCT3_Data\dust3.blp`, `KVCT3_Data\RoyalGlow.blp`, `Textures\Purple_Star.blp`, `KVCT3_Data\flaresimple01_bw.blp`, `KVCT3_Data\flaresimple02_bw.blp`, `Textures\Dust5ABlack.blp`, `KVCT3_Data\smoke_bw.blp`, `Textures\GenericGlow2_64.blp`, `KVCT3_Data\flash01_bw.blp` | riêng phái |

## 12. Thiên Long Thần Công [bị động]  (id X245, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_lucmachthankiem6.mdx` | `KVCT3_Data\tx09_6.blp` | riêng phái |

## 13. Ám Hương Sơ Ảnh [bị động]  (id X246, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_luyenkhi.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\Yellow_Glow2.blp`, `Textures\Flare.blp`, `Textures\snowflake.blp`, `Textures\Clouds8x8.blp`, `Textures\Ghost2.blp`, `Textures\rainTail.blp`, `Textures\snowflake2.blp`, `Textures\Blue_Star2.blp` | riêng phái |
