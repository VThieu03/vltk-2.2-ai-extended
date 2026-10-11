# CMC (H025): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CMC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/VLTK_data/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CMC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Biệt Tự [Q]  (id X338, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_lyhan.mdx` | `Textures\star4.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\Lanaya_D2.BLP`, `VLTK_data\KVCT3_Data\Lanaya_D.BLP` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Orc\Devour\DevourEffectArt.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 2. Mộ Châm Pháp [bị động]  (id X339, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_bisau.mdx` | `VLTK_data\KVCT3_Data\AZ_Smoke9.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\RibbonBlur1.blp`, `VLTK_data\KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon_007.blp`, `VLTK_data\KVCT3_Data\AZ_Flare10.blp`, `VLTK_data\KVCT3_Data\RibbonNE1_White.blp` | riêng phái |

## 3. Kinh Hồng Chiếu Ảnh [R]  (id X340, kind 3)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 80% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_kinhhong.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\GenericGlow64.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `ReplaceableTextures\Selection\SelectionCircleLarge.blp` | riêng phái |
| lúc tung (trên tướng) | `CMC_kinhhong.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\GenericGlow64.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `ReplaceableTextures\Selection\SelectionCircleLarge.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Orc\Devour\DevourEffectArt.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 4. Súc Thế Đãi Phát [bị động]  (id X341, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_sucthedaiphat.mdx` | `Textures\RibbonNE1_White.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb17.blp`, `VLTK_data\KVCT3_Data\AZ_Splast22.blp`, `VLTK_data\KVCT3_Data\Morgana_Base_E_Shield_Glow.blp`, `VLTK_data\KVCT3_Data\Morgana_Base_Q_Mis_Core.blp` | riêng phái |

## 5. Ngọc Phong Châm [D]  (id X342, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_ngocphongcham.mdx` | `VLTK_data\KVCT3_Data\diezhen.blp`, `textures\Purple_Glow.blp` | riêng phái |
| trên địch bị trúng | `CMC_ngocphongtarget.mdx` | `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `VLTK_data\KVCT3_Data\AZ_star1.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |
| buff (trên tướng) | `CMC_ngocphongbuff.mdx` | `Textures\GenericGlow2c.blp` | riêng phái |

## 6. Lưu Vân Pháp [bị động]  (id X343, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_hoangtuyentarget.mdx` | `VLTK_data\KVCT3_Data\txx110_5_b.blp`, `VLTK_data\KVCT3_Data\txx110_1.blp`, `VLTK_data\KVCT3_Data\txx110_b.blp`, `VLTK_data\KVCT3_Data\txx110_4_b.blp`, `VLTK_data\KVCT3_Data\txx110_2_b.blp`, `VLTK_data\KVCT3_Data\txx110_3_b.blp` | riêng phái |

## 7. Ly Hận [W]  (id X344, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_lyhan.mdx` | `Textures\star4.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\Lanaya_D2.BLP`, `VLTK_data\KVCT3_Data\Lanaya_D.BLP` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Orc\Devour\DevourEffectArt.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 8. Hoàng Tuyền Lảo Đảo [F]  (id X345, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_hoangtuyencham.mdx` | `Textures\RibbonNE1_White.blp`, `Textures\Flare.blp`, `Textures\CloudSingle.blp`, `Textures\snowflake2.blp`, `Textures\Frost2.blp`, `Textures\star2.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMC_hoangtuyentarget.mdx` | `VLTK_data\KVCT3_Data\txx110_5_b.blp`, `VLTK_data\KVCT3_Data\txx110_1.blp`, `VLTK_data\KVCT3_Data\txx110_b.blp`, `VLTK_data\KVCT3_Data\txx110_4_b.blp`, `VLTK_data\KVCT3_Data\txx110_2_b.blp`, `VLTK_data\KVCT3_Data\txx110_3_b.blp` | riêng phái |

## 9. Hành Vân Đới Vũ [bị động]  (id X346, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_minhchauamdau.mdx` | `VLTK_data\KVCT3_Data\huanrao_dun_01.blp`, `VLTK_data\KVCT3_Data\huanrao_dun_02.blp`, `VLTK_data\KVCT3_Data\huanrao_dun_03.blp` | riêng phái |

## 10. Vụ Tập Vân Hợp [T]  (id X347, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_vutapvanhop.mdx` | `VLTK_data\KVCT3_Data\Wind_flaresimple_w.blp`, `VLTK_data\KVCT3_Data\Wind_flare2_w.blp`, `VLTK_data\KVCT3_Data\Wind_heroglow_w.blp`, `VLTK_data\KVCT3_Data\Wind_flareline_w.blp`, `VLTK_data\KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp` | riêng phái |

## 11. Bi Sầu [E]  (id X348, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_bisau.mdx` | `VLTK_data\KVCT3_Data\AZ_Smoke9.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\RibbonBlur1.blp`, `VLTK_data\KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon_007.blp`, `VLTK_data\KVCT3_Data\AZ_Flare10.blp`, `VLTK_data\KVCT3_Data\RibbonNE1_White.blp` | riêng phái |
| lúc tung (trên tướng) | `CMC_cham5_5.mdx` | `VLTK_data\KVCT3_Data\AZ_Smoke9.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\RibbonBlur1.blp`, `VLTK_data\KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon_007.blp`, `VLTK_data\KVCT3_Data\AZ_Flare10.blp`, `VLTK_data\KVCT3_Data\RibbonNE1_White.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMC_chamtarget.mdx` | `VLTK_data\KVCT3_Data\AZ_Smoke9.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\RibbonBlur1.blp`, `VLTK_data\KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon_007.blp`, `VLTK_data\KVCT3_Data\AZ_Flare10.blp`, `VLTK_data\KVCT3_Data\RibbonNE1_White.blp` | riêng phái |
| lúc tung 2 (trên tướng) | `CMC_bisau.mdx` | `VLTK_data\KVCT3_Data\AZ_Smoke9.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\RibbonBlur1.blp`, `VLTK_data\KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon_007.blp`, `VLTK_data\KVCT3_Data\AZ_Flare10.blp`, `VLTK_data\KVCT3_Data\RibbonNE1_White.blp` | riêng phái |

## 12. Phong Lưu Vân Tán [bị động]  (id X349, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_ngocphongbuff.mdx` | `Textures\GenericGlow2c.blp` | riêng phái |
| trên địch bị trúng | `CMC_ngocphongtarget.mdx` | `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `VLTK_data\KVCT3_Data\AZ_star1.blp`, `VLTK_data\KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CMC_ngocphongcham.mdx` | `VLTK_data\KVCT3_Data\diezhen.blp`, `textures\Purple_Glow.blp` | riêng phái |

## 13. Mê Thần Dẫn [bị động]  (id X350, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMC_sucthedaiphat.mdx` | `Textures\RibbonNE1_White.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb17.blp`, `VLTK_data\KVCT3_Data\AZ_Splast22.blp`, `VLTK_data\KVCT3_Data\Morgana_Base_E_Shield_Glow.blp`, `VLTK_data\KVCT3_Data\Morgana_Base_Q_Mis_Core.blp` | riêng phái |
