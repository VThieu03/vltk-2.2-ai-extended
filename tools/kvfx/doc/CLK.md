# CLK (H009): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CLK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CLK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Cuồng Lôi Chấn Địa [Q]  (id X104, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\CuongLoi.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `Flare.blp`, `Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp` | dùng chung (model Thiên Kiếm) |
| lúc tung (trên tướng) | `CLK_cast.mdx` | `KVCT3_Data\AZ_Flare1B.blp`, `KVCT3_Data\AZ_FlareLightning.blp`, `KVCT3_Data\AZ_lightning4.blp`, `Textures\firering6.blp`, `KVCT3_Data\AZ_lightning4x4.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLK_thienloichannhac.mdx` | `Textures\Zap1.blp`, `KVCT3_Data\AZ_lightning_A1_4x4.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\GenericGlow64.blp`, `Textures\LightningBall.blp` | riêng phái |

## 2. Côn Lôn Kiếm Pháp [bị động]  (id X105, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_daocottienphong.mdx` | `KVCT3_Data\HeTho.blp` | riêng phái |

## 3. Thanh Phong Phù [F]  (id X106, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_nguphongbuff.mdx` | `Textures\Blue_Glow2.blp`, `Textures\GenericGlowFaded.blp`, `Textures\Blue_Star2.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_nguphongcaster.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLK_thanhphongphu.mdx` | `Textures\MagicGlow.blp`, `Textures\Ghost2.blp`, `Textures\GraveYardGhost.blp`, `Textures\Rune4b.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CLK_daocottienphong.mdx` | `KVCT3_Data\HeTho.blp` | riêng phái |

## 4. Thiên Tế Tấn Lôi [W]  (id X107, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_thientetanloi.mdx` | `KVCT3_Data\JD-2021leidianlong_shandain02.tga`, `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `ReplaceableTextures\Splats\Splat01Mature.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_cast.mdx` | `KVCT3_Data\AZ_Flare1B.blp`, `KVCT3_Data\AZ_FlareLightning.blp`, `KVCT3_Data\AZ_lightning4.blp`, `Textures\firering6.blp`, `KVCT3_Data\AZ_lightning4x4.blp` | riêng phái |
| trên địch bị trúng | `CLK_targetlight2.mdx` | `Textures\Yellow_Glow3.blp`, `KVCT3_Data\ZapYellow.blp` | riêng phái |

## 5. Đạo Cốt Tiên Phong [T]  (id X108, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_daocottienphong.mdx` | `KVCT3_Data\HeTho.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_nguphongcaster.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp` | riêng phái |

## 6. Ngũ Lôi Chánh Pháp [bị động]  (id X109, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_thienloichannhac.mdx` | `Textures\Zap1.blp`, `KVCT3_Data\AZ_lightning_A1_4x4.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\GenericGlow64.blp`, `Textures\LightningBall.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLK_thanhphongphu.mdx` | `Textures\MagicGlow.blp`, `Textures\Ghost2.blp`, `Textures\GraveYardGhost.blp`, `Textures\Rune4b.blp` | riêng phái |

## 7. Lôi Động Cửu Thiên [E]  (id X110, kind 17)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 80% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_loidongcuuthien.mdx` | `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_2_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_14_8x1.blp`, `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_1_4x2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Fragment_2_8x8.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Frame_Glow_3.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_cast.mdx` | `KVCT3_Data\AZ_Flare1B.blp`, `KVCT3_Data\AZ_FlareLightning.blp`, `KVCT3_Data\AZ_lightning4.blp`, `Textures\firering6.blp`, `KVCT3_Data\AZ_lightning4x4.blp` | riêng phái |

## 8. Lôi Đình Quyết [bị động]  (id X111, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_loidinhquyet.mdx` | `KVCT3_Data\TX_Star2012.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_13.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_14.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow3.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow5.blp`, `KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_star1.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `CLK_loidinhquyet.mdx` | `KVCT3_Data\TX_Star2012.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_13.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_14.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow3.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow5.blp`, `KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_star1.blp` | riêng phái |

## 9. Huyền Thiên Vô Cực [bị động]  (id X112, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_loidongcuuthien.mdx` | `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_2_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_14_8x1.blp`, `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_1_4x2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_D2_Sequence_Fragment_2_8x8.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Frame_Glow_3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLK_thienloichannhac.mdx` | `Textures\Zap1.blp`, `KVCT3_Data\AZ_lightning_A1_4x4.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\GenericGlow64.blp`, `Textures\LightningBall.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CLK_thientetanloi.mdx` | `KVCT3_Data\JD-2021leidianlong_shandain02.tga`, `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `ReplaceableTextures\Splats\Splat01Mature.blp` | riêng phái |

## 10. Ngự Phong Thuật [D]  (id X113, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 90% trong 3.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_nguphongthuat.mdx` | `KVCT3_Data\tx926_1.blp`, `Textures\Dust3.blp`, `KVCT3_Data\tx926_2.blp`, `KVCT3_Data\tx926_3.blp`, `KVCT3_Data\tx926_4.blp`, `KVCT3_Data\tx926_5.blp`, `KVCT3_Data\tx926_6.blp`, `KVCT3_Data\tx926_7.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_nguphongcaster.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp` | riêng phái |
| buff (trên tướng) | `CLK_nguphongbuff.mdx` | `Textures\Blue_Glow2.blp`, `Textures\GenericGlowFaded.blp`, `Textures\Blue_Star2.blp` | riêng phái |

## 11. Thiên Lôi Chấn Nhạc [R]  (id X114, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_thienloichannhac.mdx` | `Textures\Zap1.blp`, `KVCT3_Data\AZ_lightning_A1_4x4.blp`, `Textures\Flare.blp`, `Textures\Shockwave10.blp`, `Textures\GenericGlow64.blp`, `Textures\LightningBall.blp` | riêng phái |
| lúc tung (trên tướng) | `CLK_cast.mdx` | `KVCT3_Data\AZ_Flare1B.blp`, `KVCT3_Data\AZ_FlareLightning.blp`, `KVCT3_Data\AZ_lightning4.blp`, `Textures\firering6.blp`, `KVCT3_Data\AZ_lightning4x4.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLK_set5.mdx` | `Textures\Zap1.blp`, `Textures\star32.blp`, `Textures\lensflare1A.blp`, `Textures\Blue_Glow2.blp`, `Textures\GenericGlow1.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 12. Hỗn Nguyên Càn Khôn [bị động]  (id X115, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_cuongloi.mdx` | `KVCT3_Data\@Sasuke_light-5.blp`, `KVCT3_Data\@Sasuke_light-1.blp`, `KVCT3_Data\@Sasuke_light-3.blp` | riêng phái |

## 13. Hóa Tủy Vô Ý [bị động]  (id X116, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLK_daocottienphong.mdx` | `KVCT3_Data\HeTho.blp` | riêng phái |
