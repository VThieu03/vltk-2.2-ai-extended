# DMPD (E006): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/DMPD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `DMPD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Tiểu Lý Phi Đao [Q]  (id X260, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_phidao1.mdx` | `Buildings\Other\DragonBuildingBlue\DragonRoostBlue.blp`, `Textures\GenericGlow64.blp`, `Textures\Clouds8x8Fade.blp` | riêng phái |

## 2. Đường Môn Ám Khí [bị động]  (id X261, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_manthienhoavu1.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp` | riêng phái |

## 3. Mê Ảnh Tung [F]  (id X262, kind 3)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_anhtungtran.mdx` | `Buildings\Human\AltarOfKings\AltarOfKings.blp`, `Buildings\Human\HumanLumberMill\HumanLumberMill.blp`, `KVCT3_Data\OrderFlag3.blp`, `Textures\GenericGlow2_64.blp`, `Textures\star5tga.blp`, `KVCT3_Data\wavering_bw.blp`, `Textures\Flare.blp`, `KVCT3_Data\smoke_bw.blp`, `KVCT3_Data\flarering_bw.blp`, `KVCT3_Data\flaresimple01_bw.blp`, `KVCT3_Data\flareshot01_bw.blp`, `KVCT3_Data\flaresimple02_bw.blp`, `UI\MiniMap\ping4.blp` | riêng phái, phái khác cũng dùng: DMPT |
| lúc tung (trên tướng) | `DMPD_anhtungtrancast.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow2c.blp`, `Textures\White_64_Foam1.blp` | riêng phái |
| buff (trên tướng) | `DMPD_anhtungtranaura.mdx` | `KVCT3_Data\mofazhendizuo2.blp` | riêng phái, phái khác cũng dùng: DMPT |

## 4. Tôi Độc Thuật [bị động]  (id X263, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_manthienhoavu3.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `DMTT_toidocaura.mdx` | `KVCT3_Data\VenArt.BLP` | dùng chung (cùng dùng: DMPT, DMTT) |

## 5. Mãn Thiên Hoa Vũ [R]  (id X264, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 50% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_manthienhoavu1.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMPD_manthienhoavu2.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DMPD_manthienhoavu3.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp` | riêng phái |

## 6. Tâm Nhãn [bị động]  (id X265, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\TamNhan.mdx` | `Textures\Energy1Color.blp`, `Textures\Red_Glow3.blp`, `Textures\star5tga.blp`, `Textures\GenericGlow64.blp`, `Textures\Zap1_Red.blp`, `Textures\Yellow_Star.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: DMPT, DMTT) |

## 7. Nhiếp Hồn Nguyệt Ảnh [W]  (id X266, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 35% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_nhiephonwave1_1.mdx` | `KVCT3_Data\nhiepanh.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `DMPD_nhiephontarget.mdx` | `UI\MiniMap\ping4.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp`, `Textures\Shockwave1White.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMPD_nhiephonwave2_1.mdx` | `KVCT3_Data\nhiepanh.blp` | riêng phái |

## 8. Hàm Sa Xạ Ảnh [bị động]  (id X267, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_phidao1.mdx` | `Buildings\Other\DragonBuildingBlue\DragonRoostBlue.blp`, `Textures\GenericGlow64.blp`, `Textures\Clouds8x8Fade.blp` | riêng phái |

## 9. Thực Cốt Huyết Nhẫn [bị động]  (id X268, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_voanhxuyen.mdx` | `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_object_Darts.blp`, `KVCT3_Data\star2x2.blp`, `Textures\RibbonNE1_blue.blp`, `KVCT3_Data\AZ_GlowBlue.blp`, `KVCT3_Data\AZ_Shockwave1U.blp`, `KVCT3_Data\AZ_Shockwave2.blp`, `KVCT3_Data\AZ_RibbonNK2.blp`, `KVCT3_Data\Nortrom_Aghanim.blp`, `KVCT3_Data\HeroNortrom6.blp` | riêng phái |

## 10. Ảnh Tung Trận [D]  (id X269, kind 8)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_anhtungtranaura.mdx` | `KVCT3_Data\mofazhendizuo2.blp` | riêng phái, phái khác cũng dùng: DMPT |
| lúc tung (trên tướng) | `DMPD_anhtungtrancast.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow2c.blp`, `Textures\White_64_Foam1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMPD_anhtungtran.mdx` | `Buildings\Human\AltarOfKings\AltarOfKings.blp`, `Buildings\Human\HumanLumberMill\HumanLumberMill.blp`, `KVCT3_Data\OrderFlag3.blp`, `Textures\GenericGlow2_64.blp`, `Textures\star5tga.blp`, `KVCT3_Data\wavering_bw.blp`, `Textures\Flare.blp`, `KVCT3_Data\smoke_bw.blp`, `KVCT3_Data\flarering_bw.blp`, `KVCT3_Data\flaresimple01_bw.blp`, `KVCT3_Data\flareshot01_bw.blp`, `KVCT3_Data\flaresimple02_bw.blp`, `UI\MiniMap\ping4.blp` | riêng phái, phái khác cũng dùng: DMPT |

## 11. Vô Ảnh Xuyên [E]  (id X270, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_voanhxuyen.mdx` | `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_object_Darts.blp`, `KVCT3_Data\star2x2.blp`, `Textures\RibbonNE1_blue.blp`, `KVCT3_Data\AZ_GlowBlue.blp`, `KVCT3_Data\AZ_Shockwave1U.blp`, `KVCT3_Data\AZ_Shockwave2.blp`, `KVCT3_Data\AZ_RibbonNK2.blp`, `KVCT3_Data\Nortrom_Aghanim.blp`, `KVCT3_Data\HeroNortrom6.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMPD_voanhxuyen_11.mdx` | `KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp`, `KVCT3_Data\garen_skin11_r_swordcolor.blp`, `KVCT3_Data\garen_skin11_r_swordblur.blp`, `KVCT3_Data\Wind_ribbon_beam_color.blp`, `KVCT3_Data\Wind_Cloud_2x2_cartoon.blp`, `KVCT3_Data\Wind_Cracks_glow_v2.blp`, `KVCT3_Data\Wind_Energy_Wave.blp`, `KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `KVCT3_Data\Wind_shockwave4_Ring_w.blp`, `KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `KVCT3_Data\Wind_glow_v2_blur_green.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_Ember4_2x4_w.blp`, `KVCT3_Data\Ember_1bFx_4x4.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DMPD_voanhxuyen_2.mdx` | `KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp`, `KVCT3_Data\garen_skin11_r_swordcolor.blp`, `KVCT3_Data\garen_skin11_r_swordblur.blp`, `KVCT3_Data\Wind_ribbon_beam_color.blp`, `KVCT3_Data\Wind_Cloud_2x2_cartoon.blp`, `KVCT3_Data\Wind_Cracks_glow_v2.blp`, `KVCT3_Data\Wind_Energy_Wave.blp`, `KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `KVCT3_Data\Wind_shockwave4_Ring_w.blp`, `KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `KVCT3_Data\Wind_glow_v2_blur_green.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_Ember4_2x4_w.blp`, `KVCT3_Data\Ember_1bFx_4x4.blp` | riêng phái |

## 12. Tâm Phách [bị động]  (id X271, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_voanhxuyen_111.mdx` | `KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp`, `KVCT3_Data\garen_skin11_r_swordcolor.blp`, `KVCT3_Data\garen_skin11_r_swordblur.blp`, `KVCT3_Data\Wind_ribbon_beam_color.blp`, `KVCT3_Data\Wind_Cloud_2x2_cartoon.blp`, `KVCT3_Data\Wind_Cracks_glow_v2.blp`, `KVCT3_Data\Wind_Energy_Wave.blp`, `KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `KVCT3_Data\Wind_shockwave4_Ring_w.blp`, `KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `KVCT3_Data\Wind_glow_v2_blur_green.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_Ember4_2x4_w.blp`, `KVCT3_Data\Ember_1bFx_4x4.blp` | riêng phái |

## 13. Bách Phát Bách Trúng [bị động]  (id X272, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_voanhxuyen_1111.mdx` | `KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp`, `KVCT3_Data\garen_skin11_r_swordcolor.blp`, `KVCT3_Data\garen_skin11_r_swordblur.blp`, `KVCT3_Data\Wind_ribbon_beam_color.blp`, `KVCT3_Data\Wind_Cloud_2x2_cartoon.blp`, `KVCT3_Data\Wind_Cracks_glow_v2.blp`, `KVCT3_Data\Wind_Energy_Wave.blp`, `KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp`, `KVCT3_Data\Wind_shockwave4_Ring_w.blp`, `KVCT3_Data\Wind_shockwave_line1a_splat_w.blp`, `KVCT3_Data\Wind_shockwave9_blur_bw.blp`, `KVCT3_Data\Wind_glow_v2_blur_green.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_Ember4_2x4_w.blp`, `KVCT3_Data\Ember_1bFx_4x4.blp` | riêng phái |
