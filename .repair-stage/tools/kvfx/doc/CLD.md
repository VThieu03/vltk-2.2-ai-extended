# CLD (H01U): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CLD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CLD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Cuồng Phong Sậu Điện [Q]  (id X208, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_cuongphong.mdx` | `abilities\Spells\Other\Tornado\ShadowWalk1.blp`, `abilities\Spells\Other\Tornado\wind.blp`, `Textures\Clouds8x8.blp`, `Textures\GenericGlow2c.blp` | riêng phái |
| lúc tung (trên tướng) | `CLD_buffcast.MDX` | `Textures\GenericGlow2b.blp`, `Textures\AuraRune8.blp`, `Textures\DemonRune4.blp`, `Textures\star2.blp` | riêng phái |
| trên địch bị trúng | `CLD_effecttarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `KVCT3_Data\Bakua_b.blp`, `Textures\star5tga.blp`, `Textures\lensflare1Ax.blp`, `Textures\lensflare1A.blp` | riêng phái |

## 2. Côn Lôn Đao Pháp [bị động]  (id X209, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_canhphong2.mdx` | `KVCT3_Data\AZ_Shockwave17.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_leaf_2x2.blp`, `KVCT3_Data\SmokeA2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `Textures\rock64.blp` | riêng phái |

## 3. Thanh Phong Phù [F]  (id X210, kind 7)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_tamthanhbuff.mdx` | `Textures\GenericGlow2b.blp`, `Textures\star2.blp`, `Textures\Green_Glow3.blp`, `Textures\Leaf4x4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_LeafGreen.blp` | riêng phái |
| trên địch bị trúng | `CLD_hoiphongtarget2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light1o.blp`, `KVCT3_Data\AZ_GlowBlue2.blp`, `Textures\Smoke.blp`, `KVCT3_Data\AZ_Knife_light2j.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLD_canhphong.mdx` | `Abilities\Spells\Other\Tornado\ShadowWalk1.blp`, `KVCT3_Data\Knife_light1M.blp`, `Textures\Dust3x.blp`, `KVCT3_Data\lightning1.blp`, `KVCT3_Data\ShadowWalk3p.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Dust6.blp`, `Textures\CloudSingle.blp`, `Textures\White_64_Foam1.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\rock64.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CLD_canhphong2.mdx` | `KVCT3_Data\AZ_Shockwave17.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_leaf_2x2.blp`, `KVCT3_Data\SmokeA2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `Textures\rock64.blp` | riêng phái |

## 4. Tụ Nguyên Thuật [R]  (id X211, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_tunguyenthuatbuff.mdx` | `Textures\GenericGlow64.blp`, `Textures\star5tga.blp`, `KVCT3_Data\Blind.blp` | riêng phái |

## 5. Nhất Khí Tam Thanh [D]  (id X212, kind 6)
Nguồn model: **bảng KVCT tự sinh**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_phongsuongtoaianh.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp`, `Textures\Flare.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\GenericGlow2b.blp`, `Textures\star2_32.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\RibbonBlur1.blp`, `Textures\clouds_anim1_bw.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `Textures\RibbonNE1_White.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\GenericGlow1.blp`, `Textures\clouds_anim1.blp`, `Textures\CloudSingle.blp` | dùng chung (cùng dùng: HSK, NMC) |

## 6. Thiên Thanh Địa Trọc [bị động]  (id X213, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_tamthanhbuff.mdx` | `Textures\GenericGlow2b.blp`, `Textures\star2.blp`, `Textures\Green_Glow3.blp`, `Textures\Leaf4x4.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_LeafGreen.blp` | riêng phái |

## 7. Ngạo Tuyết Tiếu Phong [W]  (id X214, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_ngaotuyet.mdx` | `KVCT3_Data\tx926_1.blp`, `Textures\Dust3.blp`, `KVCT3_Data\tx926_2.blp`, `KVCT3_Data\tx926_3.blp`, `KVCT3_Data\tx926_4.blp`, `KVCT3_Data\tx926_5.blp`, `KVCT3_Data\tx926_6.blp`, `KVCT3_Data\tx926_7.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `CLD_ngaotuyetcast.mdx` | `KVCT3_Data\z-DaoG jhxcom_2001.blp`, `KVCT3_Data\z-DaoG jhxcom_2021.blp`, `KVCT3_Data\z-DaoG jhxcom_2000.blp`, `KVCT3_Data\z-DaoG jhxcom_2010.blp` | riêng phái |
| trên địch bị trúng | `CLD_ngaotuyettarget.mdx` | `Textures\Flare.blp`, `Textures\Ghost1.blp`, `Textures\star4_32.blp`, `Textures\star6.blp`, `KVCT3_Data\AZ_Star3.blp`, `KVCT3_Data\AZ_Flare1Q.blp`, `KVCT3_Data\AZ_Smoke1E.blp`, `KVCT3_Data\star2x2.blp`, `KVCT3_Data\AZ_Smoke8x8a.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLD_hoiphongphatlieu.mdx` | `KVCT3_Data\AZ_Knife_light3.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light4.blp`, `KVCT3_Data\AZ_Smoke1ED.blp` | riêng phái |

## 8. Hồi Phong Phất Liễu [bị động]  (id X215, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_hoiphongphatlieu.mdx` | `KVCT3_Data\AZ_Knife_light3.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light4.blp`, `KVCT3_Data\AZ_Smoke1ED.blp` | riêng phái |
| trên địch bị trúng | `CLD_hoiphongtarget2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light1o.blp`, `KVCT3_Data\AZ_GlowBlue2.blp`, `Textures\Smoke.blp`, `KVCT3_Data\AZ_Knife_light2j.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLD_canhphong.mdx` | `Abilities\Spells\Other\Tornado\ShadowWalk1.blp`, `KVCT3_Data\Knife_light1M.blp`, `Textures\Dust3x.blp`, `KVCT3_Data\lightning1.blp`, `KVCT3_Data\ShadowWalk3p.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Dust6.blp`, `Textures\CloudSingle.blp`, `Textures\White_64_Foam1.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\rock64.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CLD_canhphong2.mdx` | `KVCT3_Data\AZ_Shockwave17.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_leaf_2x2.blp`, `KVCT3_Data\SmokeA2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `Textures\rock64.blp` | riêng phái |

## 9. Lưỡng Nghi Chân Khí [bị động]  (id X216, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_buffphanluongnghi.mdx` | `KVCT3_Data\TX_Star2012.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_13.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_14.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow3.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow5.blp`, `KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_star1.blp` | riêng phái |
| buff (trên tướng) | `CLD_luongnghibuff.mdx` | `KVCT3_Data\AZ_Sputtering.blp`, `Textures\Flare.blp`, `Textures\Dust3.blp`, `Textures\star4_32.blp`, `KVCT3_Data\AZ_Fire2_4x8.blp` | riêng phái |

## 10. Phản Lưỡng Nghi Đao Pháp [bị động]  (id X217, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_buffphanluongnghi.mdx` | `KVCT3_Data\TX_Star2012.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_13.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_14.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow3.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow5.blp`, `KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_star1.blp` | riêng phái |
| buff (trên tướng) | `CLD_luongnghibuff.mdx` | `KVCT3_Data\AZ_Sputtering.blp`, `Textures\Flare.blp`, `Textures\Dust3.blp`, `Textures\star4_32.blp`, `KVCT3_Data\AZ_Fire2_4x8.blp` | riêng phái |

## 11. Cửu Thiên Canh Phong [E]  (id X218, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_canhphong2.mdx` | `KVCT3_Data\AZ_Shockwave17.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_leaf_2x2.blp`, `KVCT3_Data\SmokeA2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `Textures\rock64.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `CLD_ngaotuyetcast.mdx` | `KVCT3_Data\z-DaoG jhxcom_2001.blp`, `KVCT3_Data\z-DaoG jhxcom_2021.blp`, `KVCT3_Data\z-DaoG jhxcom_2000.blp`, `KVCT3_Data\z-DaoG jhxcom_2010.blp` | riêng phái |
| trên địch bị trúng | `CLD_hoiphongtarget2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light1o.blp`, `KVCT3_Data\AZ_GlowBlue2.blp`, `Textures\Smoke.blp`, `KVCT3_Data\AZ_Knife_light2j.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CLD_canhphong.mdx` | `Abilities\Spells\Other\Tornado\ShadowWalk1.blp`, `KVCT3_Data\Knife_light1M.blp`, `Textures\Dust3x.blp`, `KVCT3_Data\lightning1.blp`, `KVCT3_Data\ShadowWalk3p.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Dust6.blp`, `Textures\CloudSingle.blp`, `Textures\White_64_Foam1.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\rock64.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CLD_hoiphongphatlieu.mdx` | `KVCT3_Data\AZ_Knife_light3.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Knife_light4.blp`, `KVCT3_Data\AZ_Smoke1ED.blp` | riêng phái |

## 12. Vô Nhân Vô Ngã [bị động]  (id X219, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\VoNhanVoNga.mdx` | `Textures\GenericGlow64.blp`, `Bakua_b.blp` | dùng chung (model Thiên Kiếm) |

## 13. Sương Ngạo Côn Lôn [bị động]  (id X220, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CLD_buffphanluongnghi.mdx` | `KVCT3_Data\TX_Star2012.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_13.blp`, `KVCT3_Data\Hero_FarSeer_N1_ef_14.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow3.blp`, `KVCT3_Data\Hero_FarSeer_N2S_glow5.blp`, `KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp`, `KVCT3_Data\Hero_FarSeer_N2S_star1.blp` | riêng phái |
| buff (trên tướng) | `CLD_luongnghibuff.mdx` | `KVCT3_Data\AZ_Sputtering.blp`, `Textures\Flare.blp`, `Textures\Dust3.blp`, `Textures\star4_32.blp`, `KVCT3_Data\AZ_Fire2_4x8.blp` | riêng phái |
