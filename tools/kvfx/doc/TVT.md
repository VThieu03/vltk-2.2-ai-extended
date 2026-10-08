# TVT (H01F): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TVT.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TVT_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Hồi Phong Lạc Nhạn [Q]  (id X130, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_hoiphonglacnhan.mdx` | `Textures\RibbonNE1_Red2.blp`, `Textures\Shockwave_Ice1.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: DMTT, TLQ) |

## 2. Thiên Vương Thương Pháp [bị động]  (id X131, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_buffkinhloiphathien.mdx` | `Textures\Dust3x.blp`, `Textures\CloudSingleBlend.blp`, `KVCT3_Data\tx_zj_01.blp`, `KVCT3_Data\tx_zj_02.blp`, `KVCT3_Data\tx_zj_03.blp` | riêng phái |
| trên địch bị trúng | `TVT_bavuongtramkim_target.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TVT_bonloithuong.mdx` | `Textures\GenericGlow2b.blp`, `Textures\Wirlwinds.blp`, `Textures\Dust3x.blp`, `Textures\WaterWake3.blp`, `Textures\White_64_Foam1.blp`, `Textures\Clouds8x8.blp`, `Textures\RibbonNE1_blue.blp`, `Textures\Shockwave4white.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TVT_bavuongeffect1.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP` | riêng phái |

## 3. Đoạn Hồn Thích [R]  (id X132, kind 3)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_doanhonthich.mdx` | `KVCT3_Data\HB02_weapon02.blp`, `KVCT3_Data\HB02_ATTACK.blp`, `Textures\RibbonNE1_White.blp` | riêng phái, phái khác cũng dùng: TVC, TVD |
| buff (trên tướng) | `TVT_buffdoanhonthich.mdx` | `KVCT3_Data\AZ_glow2.blp`, `KVCT3_Data\AZ_Ribbon1X.blp`, `KVCT3_Data\AZ_WhiteFire6x6.blp`, `KVCT3_Data\AZ_Shockwave31.blp`, `KVCT3_Data\AZ_Shockwave1t.blp`, `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 4. Kinh Lôi Phá Thiên [bị động]  (id X133, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_buffkinhloiphathien.mdx` | `Textures\Dust3x.blp`, `Textures\CloudSingleBlend.blp`, `KVCT3_Data\tx_zj_01.blp`, `KVCT3_Data\tx_zj_02.blp`, `KVCT3_Data\tx_zj_03.blp` | riêng phái |

## 5. Thiên Vương Chiến Ý [D]  (id X134, kind 7)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_buffkinhloiphathien.mdx` | `Textures\Dust3x.blp`, `Textures\CloudSingleBlend.blp`, `KVCT3_Data\tx_zj_01.blp`, `KVCT3_Data\tx_zj_02.blp`, `KVCT3_Data\tx_zj_03.blp` | riêng phái |
| lúc tung (trên tướng) | `TVT_chienycast.mdx` | `Textures\Yellow_Glow_Dim2.blp`, `Textures\Yellow_Star_Dim.blp`, `Textures\firering4.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\star5tga.blp`, `Textures\star4.blp`, `Textures\star32.blp`, `war3mapImported\CrossSword.blp` | riêng phái |
| trên địch bị trúng | `TVT_bavuongtramkim_target.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TVT_bavuongeffect1.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP` | riêng phái |
| lớp thêm tại điểm 2 | `TVT_bavuongeffect2.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP` | riêng phái |

## 6. Thiên Canh Chiến Khí [bị động]  (id X135, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_buffkinhloiphathien.mdx` | `Textures\Dust3x.blp`, `Textures\CloudSingleBlend.blp`, `KVCT3_Data\tx_zj_01.blp`, `KVCT3_Data\tx_zj_02.blp`, `KVCT3_Data\tx_zj_03.blp` | riêng phái |
| lúc tung (trên tướng) | `TVT_chienycast.mdx` | `Textures\Yellow_Glow_Dim2.blp`, `Textures\Yellow_Star_Dim.blp`, `Textures\firering4.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\star5tga.blp`, `Textures\star4.blp`, `Textures\star32.blp`, `war3mapImported\CrossSword.blp` | riêng phái |

## 7. Truy Tinh Trục Nguyệt [W]  (id X136, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_truytinheffect.mdx` | `KVCT3_Data\ZK-barb protrusion.blp`, `KVCT3_Data\ZY-LZ3.BLP` | riêng phái |
| trên địch bị trúng | `TVT_truytinhtarget.mdx` | `KVCT3_Data\Hero_Juggernaut_N7S_light6.blp`, `KVCT3_Data\Hero_Juggernaut_N7S_star.blp`, `KVCT3_Data\Hero_Juggernaut_N7S_star2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: DMTT, TLQ) |

## 8. Bôn Lôi Toàn Long Thương [F]  (id X137, kind 11)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 100% trong 2.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_bonloithuong.mdx` | `Textures\GenericGlow2b.blp`, `Textures\Wirlwinds.blp`, `Textures\Dust3x.blp`, `Textures\WaterWake3.blp`, `Textures\White_64_Foam1.blp`, `Textures\Clouds8x8.blp`, `Textures\RibbonNE1_blue.blp`, `Textures\Shockwave4white.blp` | riêng phái |
| trên địch bị trúng | `TVT_bonloitarget.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |

## 9. Liên Hoàn Đoạt Mệnh Thương [bị động]  (id X138, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_doatmenhbuff.mdx` | `KVCT3_Data\GlowYellow.blp`, `KVCT3_Data\Circle.blp`, `KVCT3_Data\flame2x2.blp`, `KVCT3_Data\Spark.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TVT_bonloithuong.mdx` | `Textures\GenericGlow2b.blp`, `Textures\Wirlwinds.blp`, `Textures\Dust3x.blp`, `Textures\WaterWake3.blp`, `Textures\White_64_Foam1.blp`, `Textures\Clouds8x8.blp`, `Textures\RibbonNE1_blue.blp`, `Textures\Shockwave4white.blp` | riêng phái |

## 10. Hoành Hành Vô Kỵ [T]  (id X139, kind 8)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_hoanhhanhbuff.mdx` | `Textures\Flare.blp`, `KVCT3_Data\Effect_AZ_GenericGlow.blp`, `KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp`, `KVCT3_Data\Effect_AZ_Shockwave2B.blp` | riêng phái |

## 11. Bá Vương Trạm Kim [E]  (id X140, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_bavuongtramkim_target.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |
| trên địch bị trúng | `TVT_bavuongtramkim_target.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |

## 12. Huyết Chiến Bát Phương [bị động]  (id X141, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_bonloithuong.mdx` | `Textures\GenericGlow2b.blp`, `Textures\Wirlwinds.blp`, `Textures\Dust3x.blp`, `Textures\WaterWake3.blp`, `Textures\White_64_Foam1.blp`, `Textures\Clouds8x8.blp`, `Textures\RibbonNE1_blue.blp`, `Textures\Shockwave4white.blp` | riêng phái |
| lúc tung (trên tướng) | `TVT_chienycast.mdx` | `Textures\Yellow_Glow_Dim2.blp`, `Textures\Yellow_Star_Dim.blp`, `Textures\firering4.blp`, `ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\GenericGlow64.blp`, `Textures\GenericGlow2c.blp`, `Textures\star5tga.blp`, `Textures\star4.blp`, `Textures\star32.blp`, `war3mapImported\CrossSword.blp` | riêng phái |

## 13. Thiên Mã Hành Không [bị động]  (id X142, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThienMaHanhKhong.mdx` | `Textures\GenericGlow64.blp`, `HoaHiemViDi.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: TVC, TVD) |
