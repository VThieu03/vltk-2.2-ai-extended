# MGC (H022): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/MGC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `MGC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Khai Thiên Thức [Q]  (id X299, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khaithienthuc.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp` | riêng phái |
| lúc tung (trên tướng) | `MGC_buffcast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow2_32.blp`, `Textures\Energy1.blp` | riêng phái |

## 2. Minh Giáo Chùy Pháp [bị động]  (id X300, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_dongdat.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 3. Khốn Hổ Vân Tiếu [R]  (id X301, kind 3)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 50% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khonhovantieueffect.mdx` | `KVCT3_Data\zd107.blp` | riêng phái |
| lúc tung (trên tướng) | `MGC_buffcast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow2_32.blp`, `Textures\Energy1.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `MGC_phachdiatarget.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\LavaLump.blp`, `Textures\LavaLump2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Fire.blp`, `Textures\star6.blp`, `Textures\star4_32.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave4white.blp`, `KVCT3_Data\AZ_lightningBlack_2x2.blp`, `KVCT3_Data\AZ_glow1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `MGC_khaithienthuc.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp` | riêng phái |

## 4. Kim Qua Thiết Mã [T]  (id X302, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_kimquathietma.mdx` | `abilities\Spells\NightElf\TrueshotAura\quartercircle2.blp`, `textures\ghost2.blp` | riêng phái |

## 5. Phách Địa Thế [D]  (id X303, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 80% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_phachdia.mdx` | `Units\Human\Uther\Uther.blp`, `Textures\Yellow_Star.blp`, `Textures\Clouds8x8Fire.blp`, `Abilities\Weapons\PhoenixMissile\RibbonMagic1.blp`, `Textures\Yellow_Star_Dim.blp`, `Textures\Yellow_Glow.blp`, `Textures\Yellow_Glow_Dim2.blp`, `Textures\Sparkle_Anim.blp`, `Textures\Shockwave1White.blp` | riêng phái |
| lúc tung (trên tướng) | `MGC_buffcast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow2_32.blp`, `Textures\Energy1.blp` | riêng phái |
| trên địch bị trúng | `MGC_phachdiatarget.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\LavaLump.blp`, `Textures\LavaLump2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Fire.blp`, `Textures\star6.blp`, `Textures\star4_32.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Shockwave4white.blp`, `KVCT3_Data\AZ_lightningBlack_2x2.blp`, `KVCT3_Data\AZ_glow1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `MGC_dongdat.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 6. Ngự Mã Thuật [bị động]  (id X304, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khuhothuc.mdx` | `KVCT3_Data\shuangchui11.blp` | riêng phái |

## 7. Long Thôn Thức [W]  (id X305, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_longthontarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |
| lúc tung (trên tướng) | `MGC_buffcast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow2_32.blp`, `Textures\Energy1.blp` | riêng phái |
| trên địch bị trúng | `MGC_longthontarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |

## 8. Hồn Phách Phi Dương [F]  (id X306, kind 6)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_honphach.mdx` | `KVCT3_Data\Ghost.blp`, `KVCT3_Data\Mystic_Glow.blp` | riêng phái |
| trên địch bị trúng | `MGC_xichtarget.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp`, `Textures\GenericGlowFaded.blp` | riêng phái |

## 9. Cửu Hi Hỗn Dương [bị động]  (id X307, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_cuuhihonduong.mdx` | `KVCT3_Data\circlegreen3.blp`, `KVCT3_Data\energyringgreen.blp`, `KVCT3_Data\flare.blp`, `KVCT3_Data\glow5.blp`, `KVCT3_Data\leaves2x2.blp` | riêng phái |

## 10. Liệt Diệm Thao Thiên [bị động]  (id X308, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khaithienthuc.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp` | riêng phái |

## 11. Khu Hổ Thức [E]  (id X309, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khuhothuc.mdx` | `KVCT3_Data\shuangchui11.blp` | riêng phái |
| lúc tung (trên tướng) | `MGC_buffcast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow2_32.blp`, `Textures\Energy1.blp` | riêng phái |
| trên địch bị trúng | `MGC_khuhothuctarget.mdx` | `Textures\Flare.blp`, `Textures\Leaf4x4.blp`, `KVCT3_Data\AZ_Shockwave15.blp`, `KVCT3_Data\EarthSpirit_wave5.blp` | riêng phái |

## 12. Trấn Ngục Phá Thiên Kinh [bị động]  (id X310, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_khaithienthuc.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp`, `Textures\Shockwave1.blp`, `Textures\star.blp`, `Textures\star1.blp`, `Textures\star2.blp`, `Textures\star2_32.blp`, `Textures\star3.blp`, `Textures\star32.blp`, `Textures\star4.blp`, `Textures\star5tga.blp`, `Textures\star6.blp`, `Textures\Star8.blp`, `Textures\Star8b.blp`, `Textures\Star8c.blp`, `Textures\Star9.blp` | riêng phái |
| lớp thêm tại điểm 1 | `MGC_kimquathietma.mdx` | `abilities\Spells\NightElf\TrueshotAura\quartercircle2.blp`, `textures\ghost2.blp` | riêng phái |

## 13. Không Tuyệt Tâm Pháp [bị động]  (id X311, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MGC_cuuhihonduong.mdx` | `KVCT3_Data\circlegreen3.blp`, `KVCT3_Data\energyringgreen.blp`, `KVCT3_Data\flare.blp`, `KVCT3_Data\glow5.blp`, `KVCT3_Data\leaves2x2.blp` | riêng phái |
