# DTC (H024): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/DTC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `DTC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thần Chỉ Điểm Huyệt [Q]  (id X325, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThanChi.mdx` | `Textures\WaterWake3.blp`, `Textures\WaterBlobs1.blp`, `Textures\Bubble.blp`, `Textures\White_64_Foam1.blp` | dùng chung (model Thiên Kiếm) |

## 2. Đoàn Thị Chỉ Pháp [bị động]  (id X326, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_canduongchi.mdx` | `KVCT3_Data\AZ_GlowYellowb.blp`, `KVCT3_Data\AZ_Flare1R1b.blp`, `KVCT3_Data\MG_Lightning1_fxb.blp`, `KVCT3_Data\lightning4x4.blp` | riêng phái |

## 3. Nhất Dương Chỉ [R]  (id X327, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 80% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTK_kimngocmanduong.mdx` | `KVCT3_Data\Dawn_slash_Shoot.blp`, `KVCT3_Data\Dawn_lightning1.blp`, `KVCT3_Data\Dawn_lightning2.blp` | dùng chung (cùng dùng: DTK) |

## 4. Lăng Ba Vi Bộ [F]  (id X328, kind 6)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_langbacast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái |

## 5. Từ Bi Quyết [bị động]  (id X329, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_thienlongchi1.mdx` | `KVCT3_Data\AFB_lltsfx.blp`, `KVCT3_Data\AFB_TT1.blp` | riêng phái |

## 6. Kim Ngọc Chỉ Pháp [bị động]  (id X330, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_thienlongchi2.mdx` | `KVCT3_Data\bd100.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 7. Cản Dương Thần Chỉ [W]  (id X331, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_canduongeffect1.mdx` | `Textures\Flare.blp`, `KVCT3_Data\TX_daji.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DTC_Img.mdx` | `KVCT3_Data\Mr.War3_PJWH.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DTC_canduongchi.mdx` | `KVCT3_Data\AZ_GlowYellowb.blp`, `KVCT3_Data\AZ_Flare1R1b.blp`, `KVCT3_Data\MG_Lightning1_fxb.blp`, `KVCT3_Data\lightning4x4.blp` | riêng phái |

## 8. Huyền Băng Cửu Kiếp [D]  (id X332, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 80% trong 3.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_Img.mdx` | `KVCT3_Data\Mr.War3_PJWH.blp` | riêng phái |

## 9. Diệu Đề Chỉ [bị động]  (id X333, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_dieudebuff.mdx` | `Textures\GenericGlow64.blp`, `Textures\star5tga.blp`, `KVCT3_Data\Precision.blp` | riêng phái |

## 10. Thí Nguyên Quyết [bị động]  (id X334, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_thinguyenbuff.mdx` | `Textures\Flare.blp` | riêng phái |

## 11. Thiên Long Thần Chỉ [E]  (id X335, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_thienlongchi1.mdx` | `KVCT3_Data\AFB_lltsfx.blp`, `KVCT3_Data\AFB_TT1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DTC_canduongeffect1.mdx` | `Textures\Flare.blp`, `KVCT3_Data\TX_daji.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DTC_Img.mdx` | `KVCT3_Data\Mr.War3_PJWH.blp` | riêng phái |

## 12. Càn Thiên Chỉ Pháp [bị động]  (id X336, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_thienlongchi1.mdx` | `KVCT3_Data\AFB_lltsfx.blp`, `KVCT3_Data\AFB_TT1.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DTC_thienlongchi2.mdx` | `KVCT3_Data\bd100.blp`, `Textures\Shockwave10.blp` | riêng phái |

## 13. Bách Bộ Xuyên Dương [bị động]  (id X337, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `DTC_bachbobuff.mdx` | `Textures\lensflare1A.blp`, `Textures\DemonRune2.blp`, `Textures\DemonRune3.blp`, `KVCT3_Data\massteleportcircle.blp`, `Textures\ribbonne1_blue.blp` | riêng phái |
| lớp thêm tại điểm 1 | `DTC_canduongchi.mdx` | `KVCT3_Data\AZ_GlowYellowb.blp`, `KVCT3_Data\AZ_Flare1R1b.blp`, `KVCT3_Data\MG_Lightning1_fxb.blp`, `KVCT3_Data\lightning4x4.blp` | riêng phái |
| lớp thêm tại điểm 2 | `DTC_canduongeffect1.mdx` | `Textures\Flare.blp`, `KVCT3_Data\TX_daji.blp` | riêng phái |
