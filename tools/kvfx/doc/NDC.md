# NDC (H01L): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/NDC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `NDC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Độc Sa Chưởng [Q]  (id X143, kind 16)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_effect1.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp` | riêng phái |

## 2. Ngũ Độc Chưởng Pháp [bị động]  (id X144, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_hoacotmienchuong2.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp`, `KVCT3_Data\Skullmx.blp`, `Textures\GenericGlow64.blp` | riêng phái |

## 3. Thiên Canh Địa Sát [R]  (id X145, kind 13)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_thiencanhds.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp` | riêng phái |

## 4. Xuyên Tâm Độc Thích [bị động]  (id X146, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_truyphongdocthich.mdx` | `Textures\white.blp`, `KVCT3_Data\jn_fu_015_h.blp`, `KVCT3_Data\Seal08.blp`, `UI\MiniMap\ping4.blp`, `UI\Glues\SinglePlayer\NightElfCampaign3D\NightElfFemaleEyeGlow1.blp` | riêng phái |

## 5. Bi Ma Huyết Quang [bị động]  (id X147, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_huyetdinhbuff.mdx` | `Textures\Green_Glow3.blp`, `UI\MiniMap\ping4.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NDC_bimahuyetquang.mdx` | `Textures\grad3.blp`, `KVCT3_Data\dust3.blp`, `Textures\Black32.blp`, `KVCT3_Data\flaresimple01_bw.blp`, `KVCT3_Data\flaresimple02_bw.blp`, `KVCT3_Data\flaresimple_green.blp`, `Textures\Shockwave1White.blp` | riêng phái |

## 6. Bách Cổ Độc Kinh [bị động]  (id X148, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_hoacotmienchuong2.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp`, `KVCT3_Data\Skullmx.blp`, `Textures\GenericGlow64.blp` | riêng phái |

## 7. Âm Phong Thực Cốt [W]  (id X149, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 35% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_amphong1.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\star5tga.blp`, `Textures\Shockwave11.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp` | riêng phái |
| lúc tung (trên tướng) | `NDC_amphongcast.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\LavaLump.blp`, `Textures\LavaLump2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Fire.blp`, `Textures\star6.blp`, `Textures\star4_32.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave4white.blp`, `KVCT3_Data\AZ_lightningBlack_2x2.blp`, `KVCT3_Data\AZ_glow1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NDC_amphong3.mdx` | `ReplaceableTextures\CommandButtons\BTNDarkRitual.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\GenericGlowX_Mod2.blp` | riêng phái |
| lớp thêm tại điểm 2 | `NDC_amphong2.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Green_Glow2.blp`, `ReplaceableTextures\Splats\DarkSummonSpecial.blp` | riêng phái |

## 8. Hóa Cốt Miên Chưởng [D]  (id X150, kind 13)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_hoacotmienchuong2.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp`, `KVCT3_Data\Skullmx.blp`, `Textures\GenericGlow64.blp` | riêng phái |
| buff (trên tướng) | `NDC_hoacotbuff.mdx` | `KVCT3_Data\SKULL.BLP`, `Textures\Blue_Glow2.blp`, `KVCT3_Data\TOONSMOKE16.BLP`, `Textures\GenericGlow64.blp`, `Textures\Ghost1.blp`, `Textures\Ghost2.blp`, `KVCT3_Data\nassus_ghost.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NDC_hoacotbuff.mdx` | `KVCT3_Data\SKULL.BLP`, `Textures\Blue_Glow2.blp`, `KVCT3_Data\TOONSMOKE16.BLP`, `Textures\GenericGlow64.blp`, `Textures\Ghost1.blp`, `Textures\Ghost2.blp`, `KVCT3_Data\nassus_ghost.blp` | riêng phái |

## 9. Truy Phong Độc Thích [bị động]  (id X151, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_truyphongdocthich.mdx` | `Textures\white.blp`, `KVCT3_Data\jn_fu_015_h.blp`, `KVCT3_Data\Seal08.blp`, `UI\MiniMap\ping4.blp`, `UI\Glues\SinglePlayer\NightElfCampaign3D\NightElfFemaleEyeGlow1.blp` | riêng phái |
| lúc tung (trên tướng) | `NDC_amphongcast.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\LavaLump.blp`, `Textures\LavaLump2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Fire.blp`, `Textures\star6.blp`, `Textures\star4_32.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave4white.blp`, `KVCT3_Data\AZ_lightningBlack_2x2.blp`, `KVCT3_Data\AZ_glow1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NDC_amphong1.mdx` | `Textures\Yellow_Star_Dim.blp`, `Textures\star5tga.blp`, `Textures\Shockwave11.blp`, `Textures\Yellow_Glow.blp`, `Textures\Shockwave1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `NDC_amphong2.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Green_Glow2.blp`, `ReplaceableTextures\Splats\DarkSummonSpecial.blp` | riêng phái |

## 10. Luyện Ngục Hủ Cổ [bị động]  (id X152, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_thiencanhds.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp` | riêng phái |

## 11. U Minh Quỷ Trảo [E]  (id X153, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_quytrao.mdx` | `Textures\Green_Glow3.blp`, `Textures\Flare.blp`, `Textures\Dust5ABlack.blp` | riêng phái |
| lúc tung (trên tướng) | `NDC_amphongcast.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\LavaLump.blp`, `Textures\LavaLump2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Fire.blp`, `Textures\star6.blp`, `Textures\star4_32.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave4white.blp`, `KVCT3_Data\AZ_lightningBlack_2x2.blp`, `KVCT3_Data\AZ_glow1.blp` | riêng phái |
| trên địch bị trúng | `NDC_uminhkholautarget.mdx` | `KVCT3_Data\Flare.blp`, `KVCT3_Data\Dust3.blp`, `Textures\Red_Glow1.blp`, `Textures\Red_Glow2.blp`, `Textures\Red_Glow3.blp`, `KVCT3_Data\AZ_Fire04_2x8.blp`, `KVCT3_Data\AZ_Fire04_4x4.blp`, `KVCT3_Data\7fx_lightraysup_full2.blp`, `KVCT3_Data\AZ_Flashb9.blp`, `KVCT3_Data\kulou001.blp` | riêng phái, phái khác cũng dùng: NDD |
| lớp thêm tại điểm 1 | `NDC_quytrao3.mdx` | `Textures\Green_Glow3.blp`, `Textures\Green_Glow2.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\Flare.blp` | riêng phái |
| lớp thêm tại điểm 2 | `NDC_uminheffect.mdx` | `KVCT3_Data\zd090.blp`, `KVCT3_Data\zd091.blp`, `Textures\CrystalBall.blp` | riêng phái |

## 12. Đoạn Cân Hủ Cốt [bị động]  (id X154, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_thiencanhds.mdx` | `Textures\Clouds8x8.blp`, `Textures\Leaf4x4.blp`, `Textures\Green_Star.blp`, `Textures\Shockwave1b.blp` | riêng phái |

## 13. U Minh Khô Lâu [T]  (id X155, kind 15)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDC_uminhkholautarget.mdx` | `KVCT3_Data\Flare.blp`, `KVCT3_Data\Dust3.blp`, `Textures\Red_Glow1.blp`, `Textures\Red_Glow2.blp`, `Textures\Red_Glow3.blp`, `KVCT3_Data\AZ_Fire04_2x8.blp`, `KVCT3_Data\AZ_Fire04_4x4.blp`, `KVCT3_Data\7fx_lightraysup_full2.blp`, `KVCT3_Data\AZ_Flashb9.blp`, `KVCT3_Data\kulou001.blp` | riêng phái, phái khác cũng dùng: NDD |
| trên địch bị trúng | `NDC_uminhkholautarget.mdx` | `KVCT3_Data\Flare.blp`, `KVCT3_Data\Dust3.blp`, `Textures\Red_Glow1.blp`, `Textures\Red_Glow2.blp`, `Textures\Red_Glow3.blp`, `KVCT3_Data\AZ_Fire04_2x8.blp`, `KVCT3_Data\AZ_Fire04_4x4.blp`, `KVCT3_Data\7fx_lightraysup_full2.blp`, `KVCT3_Data\AZ_Flashb9.blp`, `KVCT3_Data\kulou001.blp` | riêng phái, phái khác cũng dùng: NDD |
