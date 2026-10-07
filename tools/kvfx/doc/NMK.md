# NMK (H021): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/NMK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `NMK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thôi Song Vọng Nguyệt [Q]  (id X286, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 30% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_thoisongeffect.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NMK_thoisongvongnguyet.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Flare.blp`, `Textures\lensflare1Ax.blp`, `Textures\Tornado2b.blp` | riêng phái |

## 2. Từ Hàng Phổ Độ [R]  (id X287, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_tuhang.mdx` | `Textures\Blue_Glow2.blp`, `Textures\Yellow_Glow.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Purple_Glow.blp`, `Textures\Zap1_Red.blp`, `KVCT3_Data\SenEmei01.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NMK_tuhang2.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\star5tga.blp`, `Textures\Shockwave11.blp`, `Textures\Shockwave_blue.blp`, `Textures\rainTail.blp` | riêng phái |
| lớp thêm tại điểm 2 | `NMK_effect8.mdx` | `Textures\Clouds8x8.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 3. Thiên Phật Thiên Diệp [D]  (id X288, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_thienphatbuff.mdx` | `KVCT3_Data\heianhuanxiang1.BLP`, `KVCT3_Data\heianhuanxiang2.blp` | riêng phái |

## 4. Mộng Điệp [bị động]  (id X289, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_effect8.mdx` | `Textures\Clouds8x8.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 5. Phật Tâm Từ Hựu [bị động]  (id X290, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_kiemanhphatquang.mdx` | `KVCT3_Data\leshandafo01.blp`, `KVCT3_Data\leshandafo02.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave11.blp`, `Textures\GenericGlow2c.blp`, `Textures\GenericGlow2b.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX.blp` | riêng phái |

## 6. Ba La Tâm Kinh [bị động]  (id X291, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_kiemanhphatquangtarget.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |

## 7. Kiếm Ảnh Phật Quang [W]  (id X292, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 35% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_kiemanhphatquang.mdx` | `KVCT3_Data\leshandafo01.blp`, `KVCT3_Data\leshandafo02.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave11.blp`, `Textures\GenericGlow2c.blp`, `Textures\GenericGlow2b.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `NMK_kiemanhphatquangtarget.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |

## 8. Thanh Âm Phạn Xướng [bị động]  (id X293, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_thoisongvongnguyet.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Flare.blp`, `Textures\lensflare1Ax.blp`, `Textures\Tornado2b.blp` | riêng phái |

## 9. Thanh Tâm Tịnh Khí [bị động]  (id X294, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_tuhang.mdx` | `Textures\Blue_Glow2.blp`, `Textures\Yellow_Glow.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Purple_Glow.blp`, `Textures\Zap1_Red.blp`, `KVCT3_Data\SenEmei01.blp` | riêng phái |

## 10. Liên Hoa Tâm Kinh [bị động]  (id X295, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_tuhang2.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\star5tga.blp`, `Textures\Shockwave11.blp`, `Textures\Shockwave_blue.blp`, `Textures\rainTail.blp` | riêng phái |

## 11. Băng Sương Điện Phóng [E]  (id X296, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 40% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_bangsuongkiem.mdx` | `Buildings\Human\ArcaneSanctum\ArcaneSanctum.blp`, `Textures\WaterBlobs1.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave10.blp`, `Textures\star5tga.blp`, `Textures\Dust5ABlack.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Blue_Glow2.blp`, `KVCT3_Data\222.blp` | riêng phái |
| trên địch bị trúng | `NMK_bangsuongtarget.mdx` | `KVCT3_Data\tx019-1.blp`, `KVCT3_Data\tx019-2.blp`, `KVCT3_Data\tx019-3.blp` | riêng phái |
| buff (trên tướng) | `NMK_thienphatbuff.mdx` | `KVCT3_Data\heianhuanxiang1.BLP`, `KVCT3_Data\heianhuanxiang2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NMK_bangsuongeffect.mdx` | `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_Smoke1E.blp`, `KVCT3_Data\AZ_SnowGlobe0.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\AZ_GlowBlue.blp`, `Textures\Ice3b.blp`, `KVCT3_Data\az_crack48.tga` | riêng phái |

## 12. Độ Nguyên Công [bị động]  (id X297, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_thoisongvongnguyet.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Flare.blp`, `Textures\lensflare1Ax.blp`, `Textures\Tornado2b.blp` | riêng phái |

## 13. Bế Nguyệt Phất Trần [bị động]  (id X298, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMK_thoisongvongnguyet.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Flare.blp`, `Textures\lensflare1Ax.blp`, `Textures\Tornado2b.blp` | riêng phái |
