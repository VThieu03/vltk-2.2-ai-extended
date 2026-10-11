# MGK (H023): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/MGK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/VLTK_data/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `MGK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thánh Hỏa Phần Tâm [Q]  (id X312, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 0.5 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoapt.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Fade.blp`, `Abilities\Spells\Demon\DarkPortal\DemonRune1backup.blp` | riêng phái |
| lúc tung (trên tướng) | `MGK_thanhhoacast.mdx` | `Textures\GenericGlow2b.blp`, `Textures\DemonRune4.blp`, `Textures\Flame4.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Weapons\SkeletalMageMissile\SkeletalMageMissile.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| buff (trên tướng) | `MGK_thanhhoalenhbuff.mdx` | `Textures\Clouds8x8Fire.blp`, `Abilities\Weapons\FlamingArrow\fire10022.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlow64.blp` | riêng phái |

## 2. Minh Giáo Kiếm Pháp [bị động]  (id X313, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_kiemdangbathoang.mdx` | `VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp`, `VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp`, `VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp`, `VLTK_data\KVCT3_Data\Wind_heroglow_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp`, `VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp`, `VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp` | riêng phái |

## 3. Di Khí Phiêu Tung [bị động]  (id X314, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoaeffect.mdx` | `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Shockwave11.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp` | riêng phái |

## 4. Vạn Vật Câu Phần [W]  (id X315, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 50% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `Abilities\Spells\NightElf\Immolation\ImmolationTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| lúc tung (trên tướng) | `Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| trên địch bị trúng | `Abilities\Spells\Other\AcidBomb\BottleImpact.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| lớp thêm tại điểm 1 | `Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 5. Càn Khôn Đại Na Di [D]  (id X316, kind 8)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_cankhonbuff.mdx` | `VLTK_data\KVCT3_Data\SacredTail11.blp`, `Textures\GenericGlow2_64.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flaresimple_bw.blp`, `Textures\star5tga.blp`, `Textures\Shockwave10.blp` | riêng phái |
| lúc tung (trên tướng) | `MGK_cankhoncaster.mdx` | `Textures\Blue_Star2.blp`, `Buildings\Other\FountainOfLifeBlood\FlareBlood.blp` | riêng phái |

## 6. Ly Hỏa Đại Pháp [bị động]  (id X317, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_effect1.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp` | riêng phái |

## 7. Thánh Hỏa Liêu Nguyên [E]  (id X318, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 35% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoaln.mdx` | `Textures\Clouds8x8ModFire.blp`, `Textures\CloudSingle.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Flame4.blp`, `Textures\GenericGlowX.blp`, `Textures\LavaLump2.blp` | riêng phái |
| lúc tung (trên tướng) | `MGK_thanhhoaeffect.mdx` | `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Shockwave11.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Other\AcidBomb\BottleImpact.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| buff (trên tướng) | `MGK_thanhhoalenhbuff.mdx` | `Textures\Clouds8x8Fire.blp`, `Abilities\Weapons\FlamingArrow\fire10022.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlow64.blp` | riêng phái |
| lớp thêm tại điểm 1 | `MGK_effect1.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Flame4.blp` | riêng phái |

## 8. Thánh Hỏa Lệnh Pháp [F]  (id X319, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoalenhbuff.mdx` | `Textures\Clouds8x8Fire.blp`, `Abilities\Weapons\FlamingArrow\fire10022.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlow64.blp` | riêng phái |
| lúc tung (trên tướng) | `MGK_thanhhoacast.mdx` | `Textures\GenericGlow2b.blp`, `Textures\DemonRune4.blp`, `Textures\Flame4.blp` | riêng phái |

## 9. Nhân Huân Tử Khí [bị động]  (id X320, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoaln.mdx` | `Textures\Clouds8x8ModFire.blp`, `Textures\CloudSingle.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Flame4.blp`, `Textures\GenericGlowX.blp`, `Textures\LavaLump2.blp` | riêng phái |

## 10. Hoang Hỏa Ngọc Phần [bị động]  (id X321, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_kiemdangbathoang.mdx` | `VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp`, `VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp`, `VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp`, `VLTK_data\KVCT3_Data\Wind_heroglow_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp`, `VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp`, `VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp` | riêng phái |

## 11. Kiếm Đãng Bát Hoang [R]  (id X322, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_kiemdangbathoang.mdx` | `VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp`, `VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp`, `VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp`, `VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp`, `VLTK_data\KVCT3_Data\Wind_heroglow_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp`, `VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp`, `VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp`, `VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Other\AcidBomb\BottleImpact.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 12. Thánh Hỏa Thần Công [bị động]  (id X323, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThanhHoa.mdx` | `Textures\CloudSingle.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Clouds8x8ModFire.blp` | dùng chung (model Thiên Kiếm) |
| lúc tung (trên tướng) | `MGK_thanhhoacast.mdx` | `Textures\GenericGlow2b.blp`, `Textures\DemonRune4.blp`, `Textures\Flame4.blp` | riêng phái |

## 13. Mục Dã Ưng Dương [bị động]  (id X324, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGK_thanhhoaeffect.mdx` | `Textures\Flame4.blp`, `Textures\Flame4.blp`, `Textures\Shockwave11.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp` | riêng phái |
