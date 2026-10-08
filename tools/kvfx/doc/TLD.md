# TLD (H01E): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TLD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TLD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Phục Ma Đao Pháp [Q]  (id X117, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_phucmadp.mdx` | `Textures\firering1A.blp`, `Textures\Yellow_Glow.blp`, `Textures\Clouds8x8Grey.blp`, `Textures\star2_32.blp` | riêng phái |

## 2. Thiếu Lâm Đao Pháp [bị động]  (id X118, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_lahantran.mdx` | `Textures\LavaLump.blp`, `KVCT3_Data\tx208-1.blp`, `KVCT3_Data\tx208-2.blp` | riêng phái, phái khác cũng dùng: TLB |

## 3. Dịch Cân Kinh [bị động]  (id X119, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_phucmadp.mdx` | `Textures\firering1A.blp`, `Textures\Yellow_Glow.blp`, `Textures\Clouds8x8Grey.blp`, `Textures\star2_32.blp` | riêng phái |

## 4. A La Hán Thần Công [bị động]  (id X120, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_lahantran.mdx` | `Textures\LavaLump.blp`, `KVCT3_Data\tx208-1.blp`, `KVCT3_Data\tx208-2.blp` | riêng phái, phái khác cũng dùng: TLB |
| aura bị động (gắn tướng suốt) | `TLD_lahantran.mdx` | `Textures\LavaLump.blp`, `KVCT3_Data\tx208-1.blp`, `KVCT3_Data\tx208-2.blp` | riêng phái, phái khác cũng dùng: TLB |

## 5. Bồ Đề Tâm Pháp [D]  (id X121, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_bodetamphapcast.mdx` | `Textures\Yellow_Glow_Dim2.blp`, `Textures\Yellow_Star_Dim.blp`, `Textures\firering4.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\star5tga.blp`, `Textures\star4.blp`, `Textures\star32.blp`, `KVCT3_Data\GodCorss.blp` | riêng phái |

## 6. Như Lai Thiên Diệp [bị động]  (id X122, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_thientrucdao.mdx` | `KVCT3_Data\Hero_Slayer_N5_Flare.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow6.blp`, `KVCT3_Data\Hero_Slayer_N10S_light.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow4.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow.blp`, `KVCT3_Data\Hero_Slayer_N10S_star.blp`, `KVCT3_Data\Hero_Slayer_N10S_star1.blp`, `KVCT3_Data\Hero_Slayer_N10S_smoke.blp`, `KVCT3_Data\Hero_Slayer_N10S_star2.blp` | riêng phái |
| trên địch bị trúng | `TLD_thientructarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |

## 7. Thiên Trúc Tuyệt Đao [W]  (id X123, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_votuongtram.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| trên địch bị trúng | `TLD_thientructarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLD_thientrucdao.mdx` | `KVCT3_Data\Hero_Slayer_N5_Flare.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow6.blp`, `KVCT3_Data\Hero_Slayer_N10S_light.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow4.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow.blp`, `KVCT3_Data\Hero_Slayer_N10S_star.blp`, `KVCT3_Data\Hero_Slayer_N10S_star1.blp`, `KVCT3_Data\Hero_Slayer_N10S_smoke.blp`, `KVCT3_Data\Hero_Slayer_N10S_star2.blp` | riêng phái |

## 8. Hàng Long Bất Vũ [F]  (id X124, kind 8)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_hanglongbuff.mdx` | `KVCT3_Data\BOSS_Heilong02.blp`, `KVCT3_Data\Seal81.blp`, `UI\MiniMap\ping4.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `TLD_hanglongcast.mdx` | `Textures\star3.blp`, `Textures\Dust5A.blp`, `Textures\star4.blp`, `Textures\Green_firering2b.blp`, `Textures\Rune1d.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 9. Đạt Ma Bế Tức [bị động]  (id X125, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_datmabetucbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\Buddha.BLP` | riêng phái |

## 10. Đại Thừa Như Lai Chú [R]  (id X126, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_daithua.mdx` | `Textures\Flare.blp`, `UI\MiniMap\ping4.blp`, `UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp`, `Textures\star6.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp`, `Textures\GenericGlow2_64.blp` | riêng phái |
| buff (trên tướng) | `TLD_daithuabuff.mdx` | `UI\MiniMap\ping4.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLD_votuongtram.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |

## 11. Quy Thiền Đao Pháp [E]  (id X127, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_tamgioihoasen.mdx` | `Textures\Flare.blp`, `Textures\GenericGlow64.blp`, `KVCT3_Data\AZ_texturesPetal2.blp`, `KVCT3_Data\AZ_Petal1.blp` | riêng phái |
| trên địch bị trúng | `TLD_thientructarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLD_votuongtram.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TLD_tamgioidao.mdx` | `KVCT3_Data\Hero_Jingke_N2s_light2.blp`, `KVCT3_Data\Hero_Jingke_N2s_light3.blp`, `KVCT3_Data\Hero_Jingke_N2s_star.blp`, `KVCT3_Data\Hero_EncHantress_N2S_star3.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp` | riêng phái |

## 12. Thiền Nguyên Công [bị động]  (id X128, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_thientrucdao.mdx` | `KVCT3_Data\Hero_Slayer_N5_Flare.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow6.blp`, `KVCT3_Data\Hero_Slayer_N10S_light.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow4.blp`, `KVCT3_Data\Hero_Slayer_N10S_glow.blp`, `KVCT3_Data\Hero_Slayer_N10S_star.blp`, `KVCT3_Data\Hero_Slayer_N10S_star1.blp`, `KVCT3_Data\Hero_Slayer_N10S_smoke.blp`, `KVCT3_Data\Hero_Slayer_N10S_star2.blp` | riêng phái |
| trên địch bị trúng | `TLD_thientructarget.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp` | riêng phái |

## 13. Trảm Ma Đao Pháp [bị động]  (id X129, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLD_tamgioihoasen.mdx` | `Textures\Flare.blp`, `Textures\GenericGlow64.blp`, `KVCT3_Data\AZ_texturesPetal2.blp`, `KVCT3_Data\AZ_Petal1.blp` | riêng phái |
