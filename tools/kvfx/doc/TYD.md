# TYD (E002): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TYD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TYD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Mục Dã Lưu Tinh [Q]  (id X039, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 30% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_mucda.mdx` | `Textures\Ghost2.blp`, `Textures\star4.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Frost2.blp` | riêng phái |

## 2. Thúy Yên Đao Pháp [bị động]  (id X040, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtunghoasen.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flash6-b.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Petal4-b.blp` | riêng phái |

## 3. Tuyết Ảnh [bị động]  (id X041, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_daptuyetbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\DapTuyetVoNgan.blp`, `Textures\star5tga.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | dùng chung (cùng dùng: TYK) |

## 4. Ngự Tuyết Ẩn [R]  (id X042, kind 19)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | dùng chung (cùng dùng: TYK) |
| buff (trên tướng) | `TYD_daptuyetbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\DapTuyetVoNgan.blp`, `Textures\star5tga.blp` | riêng phái |

## 5. Hộ Thể Hàn Băng [bị động]  (id X043, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtuocdao2.mdx` | `KVCT3_Data\ws_005_sw_1.blp` | riêng phái |

## 6. Băng Cơ Ngọc Cốt [bị động]  (id X044, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtuochoasen.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flash6-b.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Petal4-b.blp` | riêng phái |

## 7. Băng Tung Vô Ảnh [W]  (id X045, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 35% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtunghoasen.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flash6-b.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Petal4-b.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYD_bangtungvoanh.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Ice3b.blp`, `Textures\GenericGlow64.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave1White.blp`, `Textures\snowflake.blp`, `Textures\RibbonNE1_White.blp`, `Textures\RibbonBlur1.blp` | riêng phái |

## 8. Đạp Tuyết Vô Ngấn [bị động]  (id X046, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_daptuyetbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\DapTuyetVoNgan.blp`, `Textures\star5tga.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYD_luuphonghoituyet.mdx` | `Textures\Frost3.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect.blp`, `Textures\star5tga.blp`, `Textures\Star8c.blp` | riêng phái |

## 9. Hàn Nguyệt Yên Tỏa [bị động]  (id X047, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_banglongpha.mdx` | `Textures\Flare.blp`, `KVCT3_Data\11renyugongzhu_effectA.blp`, `KVCT3_Data\11renyugongzhu_effectB.blp` | riêng phái |

## 10. Tương Tư [D]  (id X048, kind 20)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bufftuongtu.mdx` | `Textures\Clouds8x8.blp`, `abilities\Spells\Human\Banish\GenericGlow2bA.blp`, `Textures\ShockwaveWater1.blp`, `Textures\snowflake.blp`, `Textures\star32.blp`, `Textures\Blue_Glow2.blp`, `Textures\Ghost2.blp` | riêng phái |

## 11. Băng Tước Việt Chi [E]  (id X049, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 40% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtuocdao1.mdx` | `KVCT3_Data\ws_005_sw_1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYD_bangtuocdao2.mdx` | `KVCT3_Data\ws_005_sw_1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TYD_bangtuochoasen.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flash6-b.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Petal4-b.blp` | riêng phái |

## 12. Băng Tâm Thiến Ảnh [bị động]  (id X050, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYD_bangtunghoasen.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flash6-b.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Petal4-b.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYD_bangtungvoanh.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Ice3b.blp`, `Textures\GenericGlow64.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave1White.blp`, `Textures\snowflake.blp`, `Textures\RibbonNE1_White.blp`, `Textures\RibbonBlur1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TYD_bangtuocdao1.mdx` | `KVCT3_Data\ws_005_sw_1.blp` | riêng phái |

## 13. Dạ Lai Tây Phong [F]  (id X051, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 100% trong 2.4 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_huyenbang.mdx` | `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp` | dùng chung (cùng dùng: TYK) |
