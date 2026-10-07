# CMK (H026): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CMK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CMK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thu Nhạn Bàng Hoàng [Q]  (id X351, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_thunhan.mdx` | `KVCT3_Data\ICE_daoguang.blp`, `KVCT3_Data\ICE_daoguang2.blp`, `KVCT3_Data\Ice3.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMK_target1.mdx` | `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `KVCT3_Data\AZ_star1.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CMK_chungnam.mdx` | `KVCT3_Data\t_daoguang2.blp` | riêng phái |

## 2. Kiếm Mộ Pháp [bị động]  (id X352, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_conguyet.mdx` | `KVCT3_Data\Dawn_Slash.blp`, `Textures\Flare.blp` | riêng phái |

## 3. Hồng Tụ Triền [R]  (id X353, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 36% trong 1.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_hongtutrien.mdx` | `Textures\GenericGlow64.blp`, `Textures\GenericGlow2_64.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Flare.blp`, `Textures\RibbonBlur1.blp`, `Textures\AuraRune8.blp`, `ReplaceableTextures\Splats\TeleportTarget.blp`, `KVCT3_Data\AZ_MagicMatrix24.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Shockwave42.blp`, `Textures\Ghost2.blp` | riêng phái |
| trên địch bị trúng | `CMK_target.mdx` | `KVCT3_Data\Hero_Jingke_daolight5.blp`, `KVCT3_Data\Hero_Jingke_daolight6.blp`, `KVCT3_Data\Hero_Jingke_N2s_light15.blp`, `KVCT3_Data\Hero_Jingke_N2s_light13.blp`, `KVCT3_Data\Hero_Jingke_N2s_light14.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp` | riêng phái |

## 4. Tịnh Ảnh Trầm Bích [bị động]  (id X354, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_tinhanhtrambich.mdx` | `Abilities\Spells\NightElf\Starfall\Moon_Cresent.blp`, `Textures\Flare.blp`, `Textures\GenericGlow1.blp`, `Units\Creeps\Medivh\GenericGlow2_mip1.blp`, `UI\MiniMap\ping4.blp` | riêng phái |

## 5. Mộ Vân Ngưng Bích [bị động]  (id X355, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_movanbuff.mdx` | `Textures\Flare.blp`, `KVCT3_Data\FHGH01.blp`, `KVCT3_Data\FHGH02.blp`, `KVCT3_Data\FHGH03.blp`, `KVCT3_Data\FHGH04.blp`, `KVCT3_Data\FHGH05.blp`, `KVCT3_Data\FHGH06.blp` | riêng phái |

## 6. Ngọc Nữ Kiếm Pháp [bị động]  (id X356, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_hongtutrien.mdx` | `Textures\GenericGlow64.blp`, `Textures\GenericGlow2_64.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Flare.blp`, `Textures\RibbonBlur1.blp`, `Textures\AuraRune8.blp`, `ReplaceableTextures\Splats\TeleportTarget.blp`, `KVCT3_Data\AZ_MagicMatrix24.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Shockwave42.blp`, `Textures\Ghost2.blp` | riêng phái |

## 7. Cô Nguyệt Bồi Hồi [W]  (id X357, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_conguyet.mdx` | `KVCT3_Data\Dawn_Slash.blp`, `Textures\Flare.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMK_target1.mdx` | `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `KVCT3_Data\AZ_star1.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CMK_conguyet2.mdx` | `KVCT3_Data\Dawn_Slash.blp`, `Textures\Flare.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CMK_chungnam.mdx` | `KVCT3_Data\t_daoguang2.blp` | riêng phái |

## 8. Chung Nam Vãn Chiếu [D]  (id X358, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 50% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_chungnam.mdx` | `KVCT3_Data\t_daoguang2.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMK_target1.mdx` | `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `KVCT3_Data\AZ_star1.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |

## 9. Hàn Sơn Độc Lập [bị động]  (id X359, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_phithienvu2.mdx` | `KVCT3_Data\Hero_TormentedSoul_N2S_firering6.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Genericstar2_32.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_star.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_star1.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Knife_light2F.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Crack12.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow4.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow1.blp`, `KVCT3_Data\TX_Star22.blp` | riêng phái |

## 10. Phi Thiên Vũ [F]  (id X360, kind 8)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_phithienvu.mdx` | `KVCT3_Data\Hero_Undying_N1S_F_Grain9.blp`, `KVCT3_Data\Hero_Undying_N1S_R_Star2.blp` | riêng phái |
| trên địch bị trúng | `CMK_phithienvu2.mdx` | `KVCT3_Data\Hero_TormentedSoul_N2S_firering6.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Genericstar2_32.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_star.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_star1.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Knife_light2F.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_Crack12.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow4.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow.blp`, `KVCT3_Data\Hero_TormentedSoul_N2S_glow1.blp`, `KVCT3_Data\TX_Star22.blp` | riêng phái |

## 11. Cô Thân Chi Ảnh [E]  (id X361, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_chungnam.mdx` | `KVCT3_Data\t_daoguang2.blp` | riêng phái |
| lúc tung (trên tướng) | `CMK_castercothan.mdx` | `KVCT3_Data\JN_huadiewu1.blp`, `KVCT3_Data\JN_huadiewu2.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CMK_target1.mdx` | `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp`, `KVCT3_Data\AZ_star1.blp`, `KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CMK_phamonghanh3.mdx` | `KVCT3_Data\20huaxianzi_effect_Flare1B_p.blp`, `KVCT3_Data\20huaxianzi_effect_FlareLightning_p.blp`, `Textures\firering6.blp`, `KVCT3_Data\20huaxianzi_effect_lightning4x4_p.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect02.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CMK_cothanca.mdx` | `KVCT3_Data\JN_huixuanbiao_A_01.blp`, `KVCT3_Data\JN_huixuanbiao_A_02.blp`, `KVCT3_Data\JN_huixuanbiao_A_03.blp`, `KVCT3_Data\JN_huixuanbiao_A_04.blp`, `KVCT3_Data\JN_huixuanbiao_A_05.blp`, `KVCT3_Data\JN_huixuanbiao_A_06.blp`, `KVCT3_Data\JN_huixuanbiao_A_07.blp` | riêng phái |

## 12. Ngọc Nữ Tâm Kinh [bị động]  (id X362, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_target2.mdx` | `KVCT3_Data\txx110_5_b.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_b.blp`, `KVCT3_Data\txx110_4_b.blp`, `KVCT3_Data\txx110_2_b.blp`, `KVCT3_Data\txx110_3_b.blp` | riêng phái |

## 13. Bạch Vân Hồi Vọng [bị động]  (id X363, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CMK_target3.mdx` | `Textures\star4_32.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `Textures\Dust3.blp`, `Textures\RibbonNE1_White.blp`, `Textures\white.blp`, `Textures\RibbonBlur1.blp`, `Textures\Shockwave10.blp`, `Textures\LavaLump.blp`, `Textures\GenericGlow64.blp`, `Textures\Clouds8x8Fade.blp`, `ReplaceableTextures\TeamColor\TeamColor15.blp`, `KVCT3_Data\AZGlow_4x4.blp`, `Textures\Ghost1.blp`, `Textures\Ghost2.blp`, `KVCT3_Data\AZ_Shockwave5_B.blp`, `KVCT3_Data\AZ_Shockwave23_B.blp`, `KVCT3_Data\AZ_Splast1WT.blp`, `KVCT3_Data\AZ_Flashb17_BB.blp` | riêng phái |
