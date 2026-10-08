# DMTT (H01M): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/DMTT.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `DMTT_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thiên La Địa Võng [Q]  (id X156, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_doancannhan.mdx` | `KVCT3_Data\HapTinhTran.BLP` | riêng phái |
| lớp thêm tại điểm 1 | `DMTT_tanghondinh.mdx` | `KVCT3_Data\HELLFIRE_RUNE.BLP`, `KVCT3_Data\AURARUNE3_MIP1.BLP`, `KVCT3_Data\GRADIENT64FLIPA.BLP`, `textures\FLARE.BLP`, `textures\STAR8B.BLP` | riêng phái |
| lớp thêm tại điểm 2 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: TLQ, TVT) |

## 2. Đường Môn Ám Khí [bị động]  (id X157, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_baovucham.mdx` | `Textures\star6.blp`, `Textures\Shockwave1white.blp`, `Textures\GenericGlow2_32.blp`, `Abilities\Spells\Other\TinkerRocket\TinkerRocketRibbon.blp`, `Textures\Dust5ABlack.blp`, `Textures\star2.blp`, `Textures\ShockwaveWater1Black.blp` | riêng phái |

## 3. Mê Ảnh Tung [F]  (id X158, kind 3)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_doancannhan.mdx` | `KVCT3_Data\HapTinhTran.BLP` | riêng phái |

## 4. Tôi Độc Thuật [bị động]  (id X159, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_toidocaura.mdx` | `KVCT3_Data\VenArt.BLP` | riêng phái, phái khác cũng dùng: DMPD, DMPT |
| aura bị động (gắn tướng suốt) | `DMTT_toidocaura.mdx` | `KVCT3_Data\VenArt.BLP` | riêng phái, phái khác cũng dùng: DMPD, DMPT |

## 5. Đoạn Cân Nhẫn [R]  (id X160, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 25% trong 2.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_doancannhan.mdx` | `KVCT3_Data\HapTinhTran.BLP` | riêng phái |
| lớp thêm tại điểm 1 | `DMTT_tanghondinh.mdx` | `KVCT3_Data\HELLFIRE_RUNE.BLP`, `KVCT3_Data\AURARUNE3_MIP1.BLP`, `KVCT3_Data\GRADIENT64FLIPA.BLP`, `textures\FLARE.BLP`, `textures\STAR8B.BLP` | riêng phái |
| lớp thêm tại điểm 2 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: TLQ, TVT) |

## 6. Tâm Nhãn [bị động]  (id X161, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\TamNhan.mdx` | `Textures\Energy1Color.blp`, `Textures\Red_Glow3.blp`, `Textures\star5tga.blp`, `Textures\GenericGlow64.blp`, `Textures\Zap1_Red.blp`, `Textures\Yellow_Star.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: DMPD, DMPT) |

## 7. Bạo Vũ Lê Hoa [W]  (id X162, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 35% trong 1.5 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_baovu.mdx` | `Textures\GlaiveThrower.blp`, `Textures\Tornado2b.blp`, `Textures\RibbonNE1_blue.blp`, `Textures\Dust5A.blp`, `Textures\Clouds8x8.blp`, `Textures\star2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMTT_baovucham.mdx` | `Textures\star6.blp`, `Textures\Shockwave1white.blp`, `Textures\GenericGlow2_32.blp`, `Abilities\Spells\Other\TinkerRocket\TinkerRocketRibbon.blp`, `Textures\Dust5ABlack.blp`, `Textures\star2.blp`, `Textures\ShockwaveWater1Black.blp` | riêng phái |
| lớp thêm tại điểm 2 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: TLQ, TVT) |

## 8. Xuyên Vân Tiễn [D]  (id X163, kind 1)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_xuyenvantientarget.mdx` | `Textures\GenericGlow2c.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\Flare.blp` | riêng phái |

## 9. Thất Tuyệt Sát Quang [bị động]  (id X164, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThatTuyetSatQuang.mdx` | `Textures\Ghost2.blp`, `Textures\Blue_Glow2.blp`, `Textures\GenericGlowX.blp`, `Textures\Flame4.blp` | dùng chung (model Thiên Kiếm) |
| buff (trên tướng) | `DMTT_phuquangluocanhbuff.mdx` | `KVCT3_Data\Wind_flaresimple_w.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_heroglow_w.blp`, `KVCT3_Data\Wind_flareline_w.blp`, `KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp` | riêng phái |

## 10. Tang Hồn Đinh [bị động]  (id X165, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_tanghondinh.mdx` | `KVCT3_Data\HELLFIRE_RUNE.BLP`, `KVCT3_Data\AURARUNE3_MIP1.BLP`, `KVCT3_Data\GRADIENT64FLIPA.BLP`, `textures\FLARE.BLP`, `textures\STAR8B.BLP` | riêng phái |

## 11. Khổng Tước Vũ [E]  (id X166, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 1.5 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_khongtuocvu1.mdx` | `KVCT3_Data\AZ_Shockwave1U.blp`, `KVCT3_Data\AZ_Shockwave2.blp`, `KVCT3_Data\chenmoshushi.blp`, `KVCT3_Data\AZ_Star2_1x4.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Flare10.blp`, `Textures\Dust3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMTT_khongtuocvu3.mdx` | `KVCT3_Data\Shockwave_AA1.blp`, `Textures\sun.blp`, `KVCT3_Data\EarthSpirit_wave5.blp`, `KVCT3_Data\Shockwave_A1.blp`, `KVCT3_Data\AZ_Flare1W.blp`, `KVCT3_Data\AZ_RibbonNE2W.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DMTT_khongtuocvu2.mdx` | `KVCT3_Data\AZ_Smoke9.blp`, `KVCT3_Data\AZ_Ribbon14.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\RibbonBlur1.blp`, `KVCT3_Data\AZ_Stone3_6x6.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Ribbon_007.blp`, `KVCT3_Data\AZ_Flare10.blp`, `KVCT3_Data\RibbonNE1_White.blp` | riêng phái |

## 12. Tâm Ma [bị động]  (id X167, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_doancannhan.mdx` | `KVCT3_Data\HapTinhTran.BLP` | riêng phái |

## 13. Phù Quang Lược Ảnh [bị động]  (id X168, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMTT_phuquangluocanhbuff.mdx` | `KVCT3_Data\Wind_flaresimple_w.blp`, `KVCT3_Data\Wind_flare2_w.blp`, `KVCT3_Data\Wind_heroglow_w.blp`, `KVCT3_Data\Wind_flareline_w.blp`, `KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp` | riêng phái |
