# DMPT (E003): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/DMPT.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `DMPT_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Tán Hoa Tiêu [Q]  (id X052, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_tanhoatieu.mdx` | `KVCT3_Data\lingyongwq.blp` | riêng phái |

## 2. Đường Môn Ám Khí [bị động]  (id X053, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cankhonnhattrich.mdx` | `Textures\GenericGlowFaded.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp`, `Textures\Yellow_Star.blp` | riêng phái |

## 3. Mê Ảnh Tung [F]  (id X054, kind 3)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cankhonnhattrich2.mdx` | `Textures\GenericGlowFaded.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp`, `Textures\Yellow_Star.blp` | riêng phái |

## 4. Tôi Độc Thuật [bị động]  (id X055, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cankhonnhattrich3.mdx` | `Textures\GenericGlowFaded.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp`, `Textures\Yellow_Star.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `DMTT_toidocaura.mdx` | `KVCT3_Data\VenArt.BLP` | dùng chung (cùng dùng: DMPD, DMTT) |

## 5. Mãn Thiên Hoa Vũ [R]  (id X056, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 50% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cankhontarget.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |

## 6. Tâm Nhãn [bị động]  (id X057, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\TamNhan.mdx` | `Textures\Energy1Color.blp`, `Textures\Red_Glow3.blp`, `Textures\star5tga.blp`, `Textures\GenericGlow64.blp`, `Textures\Zap1_Red.blp`, `Textures\Yellow_Star.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: DMPD, DMTT) |

## 7. Cửu Cung Phi Tinh [W]  (id X058, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 35% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cuucung4.mdx` | `KVCT3_Data\ui_chilun_00.blp` | riêng phái |

## 8. Hàm Sa Xạ Ảnh [bị động]  (id X059, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cuucung5.mdx` | `KVCT3_Data\ui_chilun_00.blp` | riêng phái |

## 9. Mê Hồn Trận [bị động]  (id X060, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_mehontrap.mdx` | `UI\MiniMap\ping4.blp`, `Textures\Purple_Glow.blp`, `KVCT3_Data\LuuThuyQuyet.blp`, `Textures\Yellow_Glow.blp` | riêng phái |

## 10. Ảnh Tung Trận [D]  (id X061, kind 8)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPD_anhtungtranaura.mdx` | `KVCT3_Data\mofazhendizuo2.blp` | dùng chung (cùng dùng: DMPD) |
| lớp thêm tại điểm 1 | `DMPD_anhtungtran.mdx` | `Buildings\Human\AltarOfKings\AltarOfKings.blp`, `Buildings\Human\HumanLumberMill\HumanLumberMill.blp`, `KVCT3_Data\OrderFlag3.blp`, `Textures\GenericGlow2_64.blp`, `Textures\star5tga.blp`, `KVCT3_Data\wavering_bw.blp`, `Textures\Flare.blp`, `KVCT3_Data\smoke_bw.blp`, `KVCT3_Data\flarering_bw.blp`, `KVCT3_Data\flaresimple01_bw.blp`, `KVCT3_Data\flareshot01_bw.blp`, `KVCT3_Data\flaresimple02_bw.blp`, `UI\MiniMap\ping4.blp` | dùng chung (cùng dùng: DMPD) |

## 11. Càn Khôn Nhất Trịch [E]  (id X062, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 40% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_cankhonnhattrich3.mdx` | `Textures\GenericGlowFaded.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp`, `Textures\Yellow_Star.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `DMPT_cankhontarget.mdx` | `KVCT3_Data\zd070.blp`, `KVCT3_Data\zd071.blp`, `KVCT3_Data\zd072.blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\zd073.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DMPT_kimnguyenbao.mdx` | `KVCT3_Data\JD-faguangyuanbao2.blp`, `KVCT3_Data\JD-faguangyuanbao1.blp`, `ReplaceableTextures\TeamColor\TeamColor04.blp`, `KVCT3_Data\JD-faguangyuanbao3.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DMPT_cankhonnhattrich2.mdx` | `Textures\GenericGlowFaded.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp`, `KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp`, `Textures\Yellow_Star.blp` | riêng phái |

## 12. Truy Hồn Đoạt Mệnh [bị động]  (id X063, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_thiettoahg.mdx` | `KVCT3_Data\JN_dituci_lv1.blp`, `KVCT3_Data\JN_dituci_lv2.blp`, `Textures\Flare.blp`, `Textures\Zap1_Red.blp`, `Textures\Shockwave1.blp`, `KVCT3_Data\JN_dituci_lv3.blp`, `KVCT3_Data\JN_dituci_lv4.blp`, `KVCT3_Data\JN_dituci_lv5.blp` | riêng phái |

## 13. Thiết Tỏa Hoành Giang [T]  (id X064, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 100% trong 9.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DMPT_thiettoahg.mdx` | `KVCT3_Data\JN_dituci_lv1.blp`, `KVCT3_Data\JN_dituci_lv2.blp`, `Textures\Flare.blp`, `Textures\Zap1_Red.blp`, `Textures\Shockwave1.blp`, `KVCT3_Data\JN_dituci_lv3.blp`, `KVCT3_Data\JN_dituci_lv4.blp`, `KVCT3_Data\JN_dituci_lv5.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `DMPT_thiettoataget.mdx` | `UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp`, `Textures\GenericGlowFaded.blp` | riêng phái |
| buff (trên tướng) | `DMPT_thiettoabuff.mdx` | `Textures\star4.blp` | riêng phái |
