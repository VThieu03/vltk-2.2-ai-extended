# NMC (E005): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/NMC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `NMC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Tứ Tượng Đồng Quy [Q]  (id X169, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 30% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_tutuongdq.mdx` | `KVCT3_Data\TX_Smoke2003.blp`, `KVCT3_Data\TX_Xulie2019.blp`, `KVCT3_Data\TX_Xulie2020.blp`, `KVCT3_Data\TX_Star5.blp`, `KVCT3_Data\TX_Star2004.blp`, `KVCT3_Data\Hero_WinterWyvern_N1S_R_Source_02.blp`, `KVCT3_Data\Hero_WinterWyvern_N1S_R_Source_01.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `NMC_tutuongtarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp` | riêng phái |
| buff (trên tướng) | `NMC_vantuongbuff.mdx` | `Textures\AuraRune7Green.blp`, `KVCT3_Data\AZ_MagicMatrix19.blp` | riêng phái |

## 2. Nga My Chưởng Pháp [bị động]  (id X170, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_batdiet2.mdx` | `Textures\Clouds8x8.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 3. Phật Tâm Từ Hựu [bị động]  (id X171, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_diepdetanghoa.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |

## 4. Bất Diệt Bất Tuyệt [bị động]  (id X172, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\BatDietBatTuyet.mdx` | `Textures\firering4.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\star5tga.blp`, `PhatQuangChienKhi.blp`, `Ping.blp` | dùng chung (model Thiên Kiếm) |
| lớp thêm tại điểm 1 | `NMC_batdiet2.mdx` | `Textures\Clouds8x8.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Demolisher.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 5. Phật Quang Chiến Khí [R]  (id X173, kind 7)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLHD_khaphuyet.mdx` | `Textures\Clouds8x8Fire.blp`, `Textures\White_64_Foam1.blp`, `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\OrcBloodTailParticle0.blp` | dùng chung |

## 6. Phật Pháp Vô Biên [bị động]  (id X174, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_phongsuongtoaianh.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp`, `Textures\Flare.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\GenericGlow2b.blp`, `Textures\star2_32.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\RibbonBlur1.blp`, `Textures\clouds_anim1_bw.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `Textures\RibbonNE1_White.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\GenericGlow1.blp`, `Textures\clouds_anim1.blp`, `Textures\CloudSingle.blp` | riêng phái, phái khác cũng dùng: CLD, HSK |

## 7. Phong Sương Toái Ảnh [W]  (id X175, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 35% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_diepdetanghoa.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `NMC_phongsuongtarget.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NMC_phongsuongtoaianh.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp`, `Textures\Flare.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\GenericGlow2b.blp`, `Textures\star2_32.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\RibbonBlur1.blp`, `Textures\clouds_anim1_bw.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `Textures\RibbonNE1_White.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\GenericGlow1.blp`, `Textures\clouds_anim1.blp`, `Textures\CloudSingle.blp` | riêng phái, phái khác cũng dùng: CLD, HSK |

## 8. Diệp Để Tàng Hoa [bị động]  (id X176, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_diepdetanghoa.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |

## 9. Kim Đỉnh Miên Chưởng [bị động]  (id X177, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_kimdinhbuff.mdx` | `Textures\Blue_Glow2.blp`, `Textures\Yellow_Glow.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Purple_Glow.blp`, `Textures\Zap1_Red.blp` | riêng phái |

## 10. Vạn Tướng Thần Công [D]  (id X178, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_vantuongbuff.mdx` | `Textures\AuraRune7Green.blp`, `KVCT3_Data\AZ_MagicMatrix19.blp` | riêng phái |
| trên địch bị trúng | `NMC_tutuongtarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp` | riêng phái |

## 11. Nguyệt Hoa Khuynh Tả [E]  (id X179, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 40% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_nguyethoaeffect.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `KVCT3_Data\RibbonNE2.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Flashb17.blp`, `KVCT3_Data\AZ_Ribbon42.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `NMC_nguyethoacast.mdx` | `Textures\Flare.blp`, `KVCT3_Data\star4x4.blp`, `Textures\GenericGlow1.blp`, `KVCT3_Data\moonknight_moon.blp`, `Textures\RibbonBlur1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `NMC_diepdetanghoa.mdx` | `Textures\firering6.blp`, `Textures\grad2d.blp`, `KVCT3_Data\20huaxianzi_effect_Tornado1E.blp`, `KVCT3_Data\20huaxianzi_effect_snowflake01.blp`, `Textures\star4_32.blp`, `Textures\star4.blp`, `Textures\Flare.blp`, `Textures\star5tga.blp`, `KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp`, `KVCT3_Data\20huaxinazi_effect_lightning4.blp`, `KVCT3_Data\20huaxianzi_effect_hua.blp` | riêng phái |

## 12. Vạn Phật Quy Tông [bị động]  (id X180, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_phatquangbuff.mdx` | `abilities\Spells\Human\InnerFire\Crown1.blp`, `Textures\Yellow_Glow_Dim2.blp`, `abilities\Spells\Human\InnerFire\Rune7.blp`, `Textures\Rune1d.blp`, `KVCT3_Data\PhatQuangChienKhi.blp`, `KVCT3_Data\LienHoa.blp` | riêng phái |

## 13. Kim Đỉnh Phật Quang [bị động]  (id X181, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_phatquangbuff.mdx` | `abilities\Spells\Human\InnerFire\Crown1.blp`, `Textures\Yellow_Glow_Dim2.blp`, `abilities\Spells\Human\InnerFire\Rune7.blp`, `Textures\Rune1d.blp`, `KVCT3_Data\PhatQuangChienKhi.blp`, `KVCT3_Data\LienHoa.blp` | riêng phái |
| buff (trên tướng) | `NMC_kimdinhbuff.mdx` | `Textures\Blue_Glow2.blp`, `Textures\Yellow_Glow.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Purple_Glow.blp`, `Textures\Zap1_Red.blp` | riêng phái |
