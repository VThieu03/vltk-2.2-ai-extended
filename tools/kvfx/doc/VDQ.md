# VDQ (H01S): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/VDQ.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `VDQ_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Bác Cập Nhị Phục [Q]  (id X195, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_baccapnhiphuc.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |
| lúc tung (trên tướng) | `VDQ_caster2.mdx` | `Textures\GenericGlow2b.blp`, `Textures\star6.blp`, `Textures\CartoonCloud.blp`, `Textures\Purple_Glow.blp`, `Textures\Shockwave1White.blp`, `Textures\GenericGlowFaded.blp`, `Textures\firering1A.blp` | riêng phái |

## 2. Võ Đang Khí Công [bị động]  (id X196, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_batquaidulong.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Green_Glow2.blp`, `ReplaceableTextures\Splats\DarkSummonSpecial.blp`, `KVCT3_Data\BatQuai.blp`, `KVCT3_Data\ThaiCuc.blp` | riêng phái |

## 3. Tọa Vọng Vô Ngã [D]  (id X197, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ToaVongVoNga.mdx` | `Textures\GenericGlow64.blp`, `YinYang_a.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: VDK) |
| lớp thêm tại điểm 1 | `VDQ_vongakiem.mdx` | `Textures\RibbonBlur1.blp`, `KVCT3_Data\Dust3.blp`, `Textures\rock64.blp`, `Textures\RockParticle.blp`, `Textures\Dust5A.blp`, `KVCT3_Data\Layers1.blp`, `Textures\star5tga.blp`, `Textures\Flare.blp`, `Textures\Blue_Star.blp`, `Textures\Blue_Glow2.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave1White.blp` | riêng phái |

## 4. Chân Vũ Thất Tiệt [bị động]  (id X198, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_chanvutt.mdx` | `Textures\GenericGlow2b.blp`, `KVCT3_Data\AZ_FlareLightning.blp`, `KVCT3_Data\AZ_Lightning2x2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_FlareLightning_white.blp` | riêng phái |

## 5. Thuần Dương Vô Cực [F]  (id X199, kind 9)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_thuanduongvocuc.mdx` | `Textures\Star8.blp`, `KVCT3_Data\Rune1d.blp`, `Textures\Shockwave10.blp`, `Units\Human\Phoenix\Demon_Rune_RibbonB.blp` | riêng phái |

## 6. Thái Cực Vô Ý [bị động]  (id X200, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_thaicuc.mdx` | `Textures\pixies1.blp`, `Textures\GenericGlow2c.blp`, `Textures\Yellow_Star.blp`, `doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp`, `Textures\AuraRune7Green.blp`, `KVCT3_Data\Bakua_b.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 7. Thiên Địa Vô Cực [W]  (id X201, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_thaicuc.mdx` | `Textures\pixies1.blp`, `Textures\GenericGlow2c.blp`, `Textures\Yellow_Star.blp`, `doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp`, `Textures\AuraRune7Green.blp`, `KVCT3_Data\Bakua_b.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `VDQ_thiendiacaster.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |
| trên địch bị trúng | `VDQ_thiendiatarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |
| lớp thêm tại điểm 1 | `VDQ_thiendia.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 8. Vạn Kiếm Quy Tông [R]  (id X202, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 80% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_vongakiem.mdx` | `Textures\RibbonBlur1.blp`, `KVCT3_Data\Dust3.blp`, `Textures\rock64.blp`, `Textures\RockParticle.blp`, `Textures\Dust5A.blp`, `KVCT3_Data\Layers1.blp`, `Textures\star5tga.blp`, `Textures\Flare.blp`, `Textures\Blue_Star.blp`, `Textures\Blue_Glow2.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave1White.blp` | riêng phái |
| lúc tung (trên tướng) | `VDQ_caster2.mdx` | `Textures\GenericGlow2b.blp`, `Textures\star6.blp`, `Textures\CartoonCloud.blp`, `Textures\Purple_Glow.blp`, `Textures\Shockwave1White.blp`, `Textures\GenericGlowFaded.blp`, `Textures\firering1A.blp` | riêng phái |
| trên địch bị trúng | `VDQ_thiendiatarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 9. Võ Đang Cửu Dương [bị động]  (id X203, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_thuanduongvocuc.mdx` | `Textures\Star8.blp`, `KVCT3_Data\Rune1d.blp`, `Textures\Shockwave10.blp`, `Units\Human\Phoenix\Demon_Rune_RibbonB.blp` | riêng phái |

## 10. Bát Quái Du Long [bị động]  (id X204, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\BatQuaiDuLong.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Green_Glow2.blp`, `ReplaceableTextures\Splats\DarkSummonSpecial.blp`, `BatQuai.blp`, `ThaiCuc.blp` | dùng chung (model Thiên Kiếm) |

## 11. Cửu Cung Bát Quái [E]  (id X205, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_cuucung1.mdx` | `Textures\Clouds8x8Mod.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\GenericGlow64.blp`, `UI\MiniMap\ping4.blp`, `Textures\Flare.blp`, `KVCT3_Data\BatQuai.blp`, `KVCT3_Data\ThaiCuc.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `VDQ_thiendiacaster.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |
| lớp thêm tại điểm 1 | `VDQ_cuucung2.mdx` | `KVCT3_Data\gumujianzhen.blp` | riêng phái |
| lớp thêm tại điểm 2 | `VDQ_thaicuc.mdx` | `Textures\pixies1.blp`, `Textures\GenericGlow2c.blp`, `Textures\Yellow_Star.blp`, `doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp`, `Textures\AuraRune7Green.blp`, `KVCT3_Data\Bakua_b.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 12. Thái Cực Thần Công [bị động]  (id X206, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThaiCucThanCong.mdx` | `Textures\pixies1.blp`, `Textures\GenericGlow2c.blp`, `Textures\Yellow_Star.blp`, `doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp`, `Textures\AuraRune7Green.blp`, `Bakua_b.blp`, `YinYang_a.blp` | dùng chung (model Thiên Kiếm) |

## 13. Lưỡng Nghi Tâm Pháp [bị động]  (id X207, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDQ_batquaidulong.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Green_Glow2.blp`, `ReplaceableTextures\Splats\DarkSummonSpecial.blp`, `KVCT3_Data\BatQuai.blp`, `KVCT3_Data\ThaiCuc.blp` | riêng phái |
