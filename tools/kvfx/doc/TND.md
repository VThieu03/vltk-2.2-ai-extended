# TND (H014): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TND.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TND_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Đạn Chỉ Liệt Diệm [Q]  (id X078, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 30% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_danchifire.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Fade.blp`, `Abilities\Spells\Demon\DarkPortal\DemonRune1backup.blp` | riêng phái |

## 2. Thiên Nhẫn Đao Pháp [bị động]  (id X079, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_thienngoaifire.mdx` | `KVCT3_Data\AZ_Crack12.blp`, `KVCT3_Data\Xin_T2_O.blp`, `KVCT3_Data\AZ_Crack11.blp` | riêng phái |
| lúc tung (trên tướng) | `TND_thienngoailuutinhcaster.mdx` | `Textures\star4_32.blp`, `Textures\Flare.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow1.blp`, `Textures\RibbonBlur1.blp`, `KVCT3_Data\AZ_Star3.blp`, `Textures\RibbonNE1_blue.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TND_thienngoaistone.mdx` | `units\Demon\Infernal\Infernal.blp`, `Textures\LavaLump.blp`, `Textures\star32.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Clouds8x8Grey.blp`, `Textures\clouds_anim1_bw.blp`, `Textures\Dust3.blp`, `Textures\Dust5A.blp`, `Textures\rock64.blp`, `Textures\Shockwave10.blp`, `Textures\grad2b.blp` | riêng phái |

## 3. Hỏa Liên Phần Hoa [D]  (id X080, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 100% trong 3.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_hoalienhole.mdx` | `KVCT3_Data\xuanwo1.blp`, `Textures\Clouds8x8Mod.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TND_hoalieneffect.mdx` | `Textures\Star7b.blp` | riêng phái |

## 4. Thôi Sơn Điền Hải [R]  (id X081, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 35% trong 1.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_thoisonfire.mdx` | `KVCT3_Data\FireAnima4x4.blp`, `Textures\Flare.blp` | riêng phái |

## 5. Nhiếp Hồn Loạn Tâm [F]  (id X082, kind 15)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 36% trong 4.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_nhiephoneffect.mdx` | `Textures\star6.blp`, `Textures\firering4.blp`, `Textures\LavaLump.blp`, `Textures\Clouds8x8Black.blp`, `Textures\Ghost1.blp`, `KVCT3_Data\AZ_Flashb9.blp`, `KVCT3_Data\AZ_ICEWOLF-Fire1.blp`, `Textures\LavaLump2.blp`, `KVCT3_Data\AZ_AuraRune5.blp`, `KVCT3_Data\AZ_Crack10.blp` | riêng phái |
| trên địch bị trúng | `TND_nhiephontarget.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp`, `Textures\GenericGlowFaded.blp` | riêng phái |

## 6. Xí Không Ma Diệm [bị động]  (id X083, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_madao.mdx` | `KVCT3_Data\Mr.War3_Mingjiaowq.blp`, `Textures\Flare.blp`, `KVCT3_Data\Mr.War3_Mingjiaowq2.BLP`, `Textures\LavaLump2.blp` | riêng phái |

## 7. Thiên Ngoại Lưu Tinh [W]  (id X084, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 35% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) (kích cỡ 10%) | `TND_thienngoaistone.mdx` | `units\Demon\Infernal\Infernal.blp`, `Textures\LavaLump.blp`, `Textures\star32.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Clouds8x8Grey.blp`, `Textures\clouds_anim1_bw.blp`, `Textures\Dust3.blp`, `Textures\Dust5A.blp`, `Textures\rock64.blp`, `Textures\Shockwave10.blp`, `Textures\grad2b.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TND_thienngoailuutinhcaster.mdx` | `Textures\star4_32.blp`, `Textures\Flare.blp`, `UI\MiniMap\ping4.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow1.blp`, `Textures\RibbonBlur1.blp`, `KVCT3_Data\AZ_Star3.blp`, `Textures\RibbonNE1_blue.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TND_thienngoaifire.mdx` | `KVCT3_Data\AZ_Crack12.blp`, `KVCT3_Data\Xin_T2_O.blp`, `KVCT3_Data\AZ_Crack11.blp` | riêng phái |

## 8. Thúc Phọc Chú [bị động]  (id X085, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_thucphocchubuff.mdx` | `Textures\GenericGlowX.blp`, `Textures\Shockwave11.blp`, `Textures\Clouds8x8Mod.blp`, `KVCT3_Data\GenericGlow33b_A.blp`, `Textures\LavaLump2.blp` | riêng phái |

## 9. Nghịch Chuyển Tâm Kinh [bị động]  (id X086, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_nghichchuyenbuff.mdx` | `Textures\Red_Glow2.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\Shockwave1.blp`, `Textures\GenericGlow2_64.blp`, `Textures\clouds_anim1.blp` | riêng phái |

## 10. Ma Đao Thôn Thần [T]  (id X087, kind 21)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_madao.mdx` | `KVCT3_Data\Mr.War3_Mingjiaowq.blp`, `Textures\Flare.blp`, `KVCT3_Data\Mr.War3_Mingjiaowq2.BLP`, `Textures\LavaLump2.blp` | riêng phái |

## 11. Tật Hỏa Liêu Nguyên [E]  (id X088, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 40% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_tathoafire.mdx` | `Textures\Clouds8x8Fade.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_01.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_1X6.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_02.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_03.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_04.blp`, `Textures\ShockwaveWater1.blp`, `Textures\GenericGlow64.blp`, `KVCT3_Data\MirrorZI_effect_baxianjian01_00.blp`, `Textures\Shockwave1.blp`, `Textures\Star8b.blp`, `Textures\Star8.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TND_tathoacast.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_GlowYellow.blp`, `KVCT3_Data\AZ_Shockwave30.blp`, `KVCT3_Data\AZ_Ribbon441.blp` | riêng phái |
| trên địch bị trúng | `TND_tathoatarget.mdx` | `KVCT3_Data\Flame8x8.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TND_bladerain.mdx` | `KVCT3_Data\BF_FlameFx_black_8x8.blp`, `KVCT3_Data\FlareLine1b_Fx.blp`, `Textures\snowflake2.blp`, `KVCT3_Data\BF_lineFx_white.blp`, `KVCT3_Data\PikeMagnaBlue.blp`, `KVCT3_Data\BF_FlareamberFx_4x2.blp`, `KVCT3_Data\smoke8x8.blp`, `Textures\LavaLump2.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TND_tathoafire2.mdx` | `KVCT3_Data\AZ_RibbonFire.blp`, `KVCT3_Data\AZ_Smoke3_2x2.blp`, `KVCT3_Data\AZ_Smokewhite2x2.blp`, `KVCT3_Data\AZ_Shockwave2B.blp`, `KVCT3_Data\AZ_smoke4x4.blp`, `Textures\LavaLump2.blp`, `Textures\LavaLump.blp`, `KVCT3_Data\Fire2x2.BLP`, `KVCT3_Data\AZ_Crack4.blp`, `KVCT3_Data\AZ_Splast1x.blp` | riêng phái |

## 12. Ma Diệm Thất Sát [bị động]  (id X089, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_thienngoaifire.mdx` | `KVCT3_Data\AZ_Crack12.blp`, `KVCT3_Data\Xin_T2_O.blp`, `KVCT3_Data\AZ_Crack11.blp` | riêng phái |

## 13. Huyền Minh Hấp Tinh [bị động]  (id X090, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TND_nghichchuyenbuff.mdx` | `Textures\Red_Glow2.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\Shockwave1.blp`, `Textures\GenericGlow2_64.blp`, `Textures\clouds_anim1.blp` | riêng phái |
