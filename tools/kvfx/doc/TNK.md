# TNK (H01P): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TNK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TNK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Tàn Dương Như Huyết [Q]  (id X182, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_tanduongnhuhuyet.mdx` | `KVCT3_Data\AZ_Splast1W.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\AZ_Knife_light2S.blp`, `KVCT3_Data\AZ_RibbonFire.blp`, `KVCT3_Data\BloodSmoke.blp`, `KVCT3_Data\AZ_RibbonGhost.blp`, `KVCT3_Data\AZ_GlowYellow.blp`, `KVCT3_Data\AZ_Smoke1E.blp` | riêng phái |

## 2. Thiên Nhẫn Mâu Pháp [bị động]  (id X183, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_gianghai2.mdx` | `Textures\Dust5.blp`, `Textures\Dust3.blp`, `Textures\RibbonBlur1.blp`, `Textures\white.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Flare.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Fade.blp` | riêng phái |

## 3. Liệt Hỏa Tinh Thiên [R]  (id X184, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 50% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\LietHoaTinhThien.mdx` | `Textures\lensflare1A.blp`, `Textures\Green_Glow3.blp`, `Textures\Shockwave4.blp`, `Textures\Star7b.blp` | dùng chung (model Thiên Kiếm) |

## 4. Ma Âm Phệ Phách [D]  (id X185, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 45% trong 4.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_maamtarget.mdx` | `KVCT3_Data\kuwei_suolian.blp` | riêng phái |

## 5. Bi Tô Thanh Phong [bị động]  (id X186, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_tanduongnhuhuyet.mdx` | `KVCT3_Data\AZ_Splast1W.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\AZ_Knife_light2S.blp`, `KVCT3_Data\AZ_RibbonFire.blp`, `KVCT3_Data\BloodSmoke.blp`, `KVCT3_Data\AZ_RibbonGhost.blp`, `KVCT3_Data\AZ_GlowYellow.blp`, `KVCT3_Data\AZ_Smoke1E.blp` | riêng phái |

## 6. Thiên Ma Giải Thể [bị động]  (id X187, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_vanlong3.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Flare.blp`, `KVCT3_Data\gn1.blp`, `Textures\GenericGlow5.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\RibbonNE1_Pink.blp`, `Textures\Red_Glow1.blp` | riêng phái |

## 7. Vân Long Kích [W]  (id X188, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_vanlongkich.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP`, `KVCT3_Data\ZK-file2.blp`, `KVCT3_Data\RibbonNE1_White.blp`, `KVCT3_Data\ZK-file1.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TNK_vanlongcast.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\Dust3.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\Magic11.blp`, `Textures\Flare.blp`, `KVCT3_Data\Magic4.blp` | riêng phái |
| trên địch bị trúng | `TNK_vanlongtarget.mdx` | `KVCT3_Data\AZ_Splast1W.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\AZ_Knife_light2S.blp`, `KVCT3_Data\kulouwang01_effect01.blp`, `KVCT3_Data\Flare2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_RibbonFired.blp`, `KVCT3_Data\AZ_Smoke1Ed.blp` | riêng phái |

## 8. Phi Hồng Vô Tích [F]  (id X189, kind 3)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 100% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_phihongcast.mdx` | `Textures\Dust5ABlack.blp`, `Textures\LavaLump2.blp`, `Textures\Dust6Color.blp`, `Units\Human\Phoenix\RibbonNE1_Red.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Flame4.blp` | riêng phái |

## 9. Cửu Khúc Hợp Thương [bị động]  (id X190, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_cuukhucbuff.MDX` | `KVCT3_Data\eff2.blp` | riêng phái |

## 10. Vân Long Tam Hiện [bị động]  (id X191, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\VanLong.mdx` | `Textures\Red_Glow3.blp`, `Textures\Red_star3.blp`, `Textures\lensflare1A.blp`, `Textures\Zap1_Red.blp` | dùng chung (model Thiên Kiếm) |
| lúc tung (trên tướng) | `TNK_vanlongcast.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\Dust3.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\Magic11.blp`, `Textures\Flare.blp`, `KVCT3_Data\Magic4.blp` | riêng phái |
| trên địch bị trúng | `TNK_vanlongtarget.mdx` | `KVCT3_Data\AZ_Splast1W.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\AZ_Knife_light2S.blp`, `KVCT3_Data\kulouwang01_effect01.blp`, `KVCT3_Data\Flare2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_RibbonFired.blp`, `KVCT3_Data\AZ_Smoke1Ed.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TNK_vanlongkich.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP`, `KVCT3_Data\ZK-file2.blp`, `KVCT3_Data\RibbonNE1_White.blp`, `KVCT3_Data\ZK-file1.blp` | riêng phái |

## 11. Giang Hải Nộ Lan [E]  (id X192, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_gianghai1.mdx` | `Textures\Dust5.blp`, `Textures\Dust3.blp`, `Textures\RibbonBlur1.blp`, `Textures\white.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Flare.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Fade.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TNK_vanlongcast.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\Dust3.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\Magic11.blp`, `Textures\Flare.blp`, `KVCT3_Data\Magic4.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TNK_gianghaitarget.mdx` | `KVCT3_Data\txx110_5.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110.blp`, `KVCT3_Data\txx110_4.blp`, `KVCT3_Data\txx110_2.blp`, `KVCT3_Data\txx110_3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TNK_gianghai2.mdx` | `Textures\Dust5.blp`, `Textures\Dust3.blp`, `Textures\RibbonBlur1.blp`, `Textures\white.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Flare.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\Clouds8x8Fade.blp` | riêng phái |

## 12. Ma Viêm Tại Thiên [bị động]  (id X193, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_maamtarget.mdx` | `KVCT3_Data\kuwei_suolian.blp` | riêng phái |

## 13. Bích Nguyệt Phi Tinh [bị động]  (id X194, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TNK_tanduongnhuhuyet.mdx` | `KVCT3_Data\AZ_Splast1W.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\AZ_Knife_light2S.blp`, `KVCT3_Data\AZ_RibbonFire.blp`, `KVCT3_Data\BloodSmoke.blp`, `KVCT3_Data\AZ_RibbonGhost.blp`, `KVCT3_Data\AZ_GlowYellow.blp`, `KVCT3_Data\AZ_Smoke1E.blp` | riêng phái |
