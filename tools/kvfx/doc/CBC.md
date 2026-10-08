# CBC (H00A): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CBC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CBC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Hàng Long Hữu Hối [Q]  (id X091, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 30% trong 1.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) (kích cỡ 150%) | `CBC_hanglong.mdx` | `KVCT3_Data\KhangLongHuuHoi.blp`, `Textures\Red_Glow2.blp` | riêng phái |

## 2. Cái Bang Chưởng Pháp [bị động]  (id X092, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_effect.mdx` | `Textures\WaterBlobs1.blp`, `Textures\White_64_Foam1.blp`, `Textures\Lords0000.blp`, `Textures\Lords0001.blp`, `Textures\Lords0002.blp`, `Textures\Lords0003.blp`, `Textures\Lords0004.blp`, `Textures\Lords0005.blp`, `Textures\Lords0006.blp`, `Textures\Lords0007.blp`, `Textures\Water_Particles.blp`, `Textures\ShockwaveWater1.blp`, `Textures\LavaLump2.blp` | riêng phái |

## 3. Hóa Hiểm Vi Di [bị động]  (id X093, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\HoaHiemViDi.mdx` | `Textures\Yellow_Glow3.blp`, `HoaHiemViDi.blp` | dùng chung (model Thiên Kiếm) |

## 4. Thời Thừa Lục Long [R]  (id X094, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_luclongbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\FlyingDragon.blp` | riêng phái |
| lúc tung (trên tướng) | `CBC_luclongcast.mdx` | `Textures\Flame4.blp` | riêng phái |

## 5. Túy Điệp Cuồng Vũ [bị động]  (id X095, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_hoatbatluuthu.mdx` | `KVCT3_Data\GenericGlowFadedA.blp`, `KVCT3_Data\AZ_MagicMatrix17_White.blp` | riêng phái, phái khác cũng dùng: CBB |
| aura bị động (gắn tướng suốt) | `CBC_hoatbatluuthu.mdx` | `KVCT3_Data\GenericGlowFadedA.blp`, `KVCT3_Data\AZ_MagicMatrix17_White.blp` | riêng phái, phái khác cũng dùng: CBB |

## 6. Tiềm Long Tại Uyên [bị động]  (id X096, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\TiemLong.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Purple_Glow.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `SoPhuong.blp` | dùng chung (model Thiên Kiếm) |

## 7. Phi Long Tại Thiên [W]  (id X097, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 35% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_hanglong.mdx` | `KVCT3_Data\KhangLongHuuHoi.blp`, `Textures\Red_Glow2.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `CBC_luclongbuff.mdx` | `Textures\GenericGlow64.blp`, `KVCT3_Data\FlyingDragon.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CBC_casting.mdx` | `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_3.blp`, `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_4.blp`, `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_5.blp` | riêng phái |
| lớp thêm tại điểm 1 | `VolcanoMissile.mdx` | `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\LavaLump2.blp`, `Textures\ShockwaveWater1.blp`, `Textures\EQ_Rock2.blp`, `Textures\Red_Glow3.blp` | dùng chung |

## 8. Trảo Long Công [bị động]  (id X098, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\TraoLongCong.mdx` | `Textures\GenericGlow64.blp`, `Textures\star5tga.blp` | dùng chung (model Thiên Kiếm) |

## 9. Thần Long Bài Vĩ [bị động]  (id X099, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_flame.mdx` | `Textures\LavaLump2.blp`, `Textures\Red_star2.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\Dust5ABlack.blp`, `Textures\RingOFire.blp`, `Textures\Tornado2b.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 10. Bá Vương Tá Giáp [bị động]  (id X100, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_bavuongbuff.mdx` | `KVCT3_Data\long1.blp`, `KVCT3_Data\long2.blp`, `KVCT3_Data\long3.blp` | riêng phái |

## 11. Long Du Thiên Địa [E]  (id X101, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 40% trong 3.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_dulong.mdx` | `Textures\RedDragon.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\Shockwave1White.blp`, `Textures\Red_Glow3.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\LavaLump.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `CBC_casting.mdx` | `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_3.blp`, `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_4.blp`, `KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_5.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `CBC_flame.mdx` | `Textures\LavaLump2.blp`, `Textures\Red_star2.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\Dust5ABlack.blp`, `Textures\RingOFire.blp`, `Textures\Tornado2b.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\Red_Glow3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CBC_flame.mdx` | `Textures\LavaLump2.blp`, `Textures\Red_star2.blp`, `ReplaceableTextures\Splats\ThunderClapUbersplat.blp`, `Textures\Dust5ABlack.blp`, `Textures\RingOFire.blp`, `Textures\Tornado2b.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\Red_Glow3.blp` | riêng phái |

## 12. Giáng Long Chưởng [bị động]  (id X102, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\GiangLong.mdx` | `Textures\WaterBlobs1.blp`, `Textures\White_64_Foam1.blp`, `Textures\Lords0000.blp`, `Textures\Lords0001.blp`, `Textures\Lords0002.blp`, `Textures\Lords0003.blp`, `Textures\Lords0004.blp`, `Textures\Lords0005.blp`, `Textures\Lords0006.blp`, `Textures\Lords0007.blp`, `Textures\Water_Particles.blp`, `Textures\ShockwaveWater1.blp`, `Textures\LavaLump2.blp` | dùng chung (model Thiên Kiếm) |

## 13. Triệt Y Thập Bát Điệt [D]  (id X103, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBC_trietytbd.mdx` | `Textures\Flame4.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield2.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield3.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield1.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield5.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield6.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield7.blp`, `KVCT3_Data\Hero_EmberSpirit_N4S_C_Target6.blp` | riêng phái |
