# TVC (H00V): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TVC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TVC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Hành Vân Quyết [Q]  (id X247, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_Hanhvan.mdx` | `Textures\GenericGlow2c.blp`, `Textures\GenericGlow64.blp`, `Textures\star5tga.blp`, `Textures\pixies1.blp`, `Textures\Ghost2.blp`, `Textures\Shockwave4white.blp`, `Textures\Shockwave1.blp` | riêng phái |
| trên địch bị trúng | `TVC_thualongquyettarget.mdx` | `Textures\Catapult.blp`, `Textures\Shockwave1b.blp`, `Textures\Dust5A.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\rock64.blp`, `Textures\Shockwave1.blp` | riêng phái |

## 2. Thiên Vương Chùy Pháp [bị động]  (id X248, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_hoakinhquyet.mdx` | `Abilities\Spells\Other\HowlOfTerror\Skull1.blp`, `KVCT3_Data\D00871.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 3. Đoạn Hồn Thích [R]  (id X249, kind 3)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **định thân** 30% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_doanhonthich.mdx` | `KVCT3_Data\HB02_weapon02.blp`, `KVCT3_Data\HB02_ATTACK.blp`, `Textures\RibbonNE1_White.blp` | dùng chung (cùng dùng: TVD, TVT) |

## 4. Thiên Vương Bản Sinh [bị động]  (id X250, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_thualongquyet.mdx` | `Textures\Flare.blp` | riêng phái |

## 5. Kim Chung Tráo [F]  (id X251, kind 7)
Nguồn model: **bảng KVCT tự sinh**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_kimchungtrao.mdx` | `KVCT3_Data\effect_jinzhongzhao.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\CrystalSheild.blp` | riêng phái |
| lúc tung (trên tướng) | `TVC_kimchungcast.mdx` | `Textures\star6.blp`, `Textures\Dust5A.blp`, `Textures\star5tga.blp`, `Textures\firering4.blp`, `Textures\Yellow_Glow.blp` | riêng phái |

## 6. Bất Diệt Sát Ý [bị động]  (id X252, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_tramlongeffect1.mdx` | `KVCT3_Data\effect_bomb_16_1.blp`, `KVCT3_Data\effect_bomb_16_2.blp`, `KVCT3_Data\effect_bomb_16_3.blp`, `KVCT3_Data\effect_bomb_16_4.blp`, `KVCT3_Data\effect_bomb_16_5.blp`, `KVCT3_Data\effect_bomb_16_6.blp`, `KVCT3_Data\effect_bomb_16_7.blp` | riêng phái |

## 7. Thừa Long Quyết [W]  (id X253, kind 4)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_thualongquyet.mdx` | `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TVC_thualongcast.mdx` | `Textures\AxeBladeBlueSteel.blp`, `KVCT3_Data\AZ_Particle_DragonSlash_01.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Shockwave29.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave11.blp`, `Textures\Shockwave10.blp` | riêng phái |
| trên địch bị trúng | `TVC_thualongquyettarget.mdx` | `Textures\Catapult.blp`, `Textures\Shockwave1b.blp`, `Textures\Dust5A.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\rock64.blp`, `Textures\Shockwave1.blp` | riêng phái |

## 8. Trảm Long Quyết [D]  (id X254, kind 3)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 100% trong 2.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_tramlongeffect2.mdx` | `Textures\Clouds8x8Fade.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Dust3x.blp`, `Textures\Shockwave1White.blp`, `Textures\Shockwave10.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\White_64_Foam1.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Doodads\Cinematic\EyeOfSargeras\Demon_Rune_Cracks.blp`, `Textures\RingOFire.blp` | riêng phái |
| trên địch bị trúng | `TVC_thualongquyettarget.mdx` | `Textures\Catapult.blp`, `Textures\Shockwave1b.blp`, `Textures\Dust5A.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\rock64.blp`, `Textures\Shockwave1.blp` | riêng phái |

## 9. Càn Khôn Chùy [bị động]  (id X255, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_cankhonchuybuff.mdx` | `war3mapImported\t3_effect_selectioncirclesmall1.blp` | riêng phái |

## 10. Hóa Kinh Quyết [bị động]  (id X256, kind 0)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_hoakinhquyet.mdx` | `Abilities\Spells\Other\HowlOfTerror\Skull1.blp`, `KVCT3_Data\D00871.blp`, `Textures\Shockwave10.blp` | riêng phái |
| trên địch bị trúng | `TVC_thualongquyettarget.mdx` | `Textures\Catapult.blp`, `Textures\Shockwave1b.blp`, `Textures\Dust5A.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\rock64.blp`, `Textures\Shockwave1.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `TVC_hoakinhquyet.mdx` | `Abilities\Spells\Other\HowlOfTerror\Skull1.blp`, `KVCT3_Data\D00871.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 11. Tung Hoành Tứ Hải [E]  (id X257, kind 4)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 45% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_tranphaieffect1.mdx` | `KVCT3_Data\BlastFlash.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Smoke1E.blp`, `KVCT3_Data\AZ_Flash6.blp`, `KVCT3_Data\Flare2.blp`, `KVCT3_Data\AZ_Stone1x2.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Rune10.blp`, `KVCT3_Data\AZ_Smoke_yello2x2.blp`, `KVCT3_Data\AZ_Flashb2p.blp`, `KVCT3_Data\AZ_Crack33.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TVC_tranphaieffect2.mdx` | `KVCT3_Data\AZ_Shockwave1x.blp`, `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Stone6_1x2.blp`, `Textures\Shockwave1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TVC_tranphaichuy.mdx` | `KVCT3_Data\shuangchui11.blp` | riêng phái |

## 12. Đảo Hư Thiên [bị động]  (id X258, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVC_hoakinhquyet.mdx` | `Abilities\Spells\Other\HowlOfTerror\Skull1.blp`, `KVCT3_Data\D00871.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 13. Thiên Mã Hành Không [bị động]  (id X259, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThienMaHanhKhong.mdx` | `Textures\GenericGlow64.blp`, `HoaHiemViDi.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: TVD, TVT) |
