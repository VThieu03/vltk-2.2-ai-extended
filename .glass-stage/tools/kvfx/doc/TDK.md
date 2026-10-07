# TDK (H02A): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TDK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TDK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Trảm Vân Kiếm [Q]  (id X403, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 30% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_tramvankiem2.mdx` | `Textures\star32.blp`, `Textures\WaterBlobs1.blp`, `Textures\Shockwave10.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Purple_Glow.blp`, `Textures\Flare.blp`, `Textures\Blue_Glow2.blp`, `Textures\Dust5ABlack.blp` | riêng phái |
| trên địch bị trúng | `TDK_target.mdx` | `Textures\GenericGlow2_32.blp`, `Textures\Flare.blp`, `Textures\Shockwave1.blp`, `Textures\star4.blp`, `TerrainArt\Ashenvale\Ashen_DirtGrass.blp` | riêng phái |

## 2. Tiêu Dao Kiếm Pháp [bị động]  (id X404, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_danphuongcd.mdx` | `KVCT3_Data\JD-2021-GUANGHTX-b.blp`, `KVCT3_Data\JD-2021-GUANGHTX-d.blp`, `KVCT3_Data\JD-2021-GUANGHTX -1.blp` | riêng phái |

## 3. Đan Phượng Dẫn [R]  (id X405, kind 13)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **định thân** 50% trong 1.5 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_danphuongdan5.mdx` | `KVCT3_Data\fh1122.blp`, `KVCT3_Data\fh3344.blp`, `KVCT3_Data\JD2_02.blp` | riêng phái |
| trên địch bị trúng | `TDK_targeteffect2.mdx` | `KVCT3_Data\txx110_5_r.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_r.blp`, `KVCT3_Data\txx110_4_r.blp`, `KVCT3_Data\txx110_2_r.blp`, `KVCT3_Data\txx110_3_r.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TDK_danphuongdan.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `Textures\Frost2.blp`, `Textures\Frost3.blp`, `Textures\Shockwave_Ice1.blp`, `Textures\snowflake2.blp`, `KVCT3_Data\AZ_Petal1.blp`, `KVCT3_Data\effect_lingyuquan.blp` | riêng phái |

## 4. Chân Hỏa Hộ Thể [bị động]  (id X406, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_chanhoabuff.mdx` | `KVCT3_Data\JN_tianmodun1.blp`, `KVCT3_Data\JN_tianmodun2.blp` | riêng phái |
| buff (trên tướng) | `TDK_chanhoabuff2.mdx` | `Textures\GenericGlow1.blp`, `Textures\LavaLump2.blp`, `units\Demon\Felgaurd\FelGuard.blp`, `Textures\Knife_spinningBlade.blp`, `UI\Glues\SinglePlayer\Orc_Exp\Stars3.blp`, `Textures\Clouds8x8.blp`, `Textures\Energy1.blp`, `Textures\Flame4.blp`, `Textures\GenericGlow2b.blp` | riêng phái |

## 5. Sơ Hoa Dẫn [F]  (id X407, kind 7)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_buffsohoa.mdx` | `KVCT3_Data\huaban_3.blp` | riêng phái |

## 6. Đoản Ca Hành [bị động]  (id X408, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_kiemchungdan4.mdx` | `KVCT3_Data\JL2-1.blp`, `KVCT3_Data\JL2-2.blp`, `Textures\Smoke.blp` | riêng phái |

## 7. Tê Chiếu Phồn Thương [W]  (id X409, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_techieukiem.mdx` | `Textures\Clouds8x8Fire.blp`, `Textures\star2.blp`, `KVCT3_Data\zhuxian.blp`, `Textures\Flare.blp` | riêng phái |
| trên địch bị trúng | `TDK_targeteffect2.mdx` | `KVCT3_Data\txx110_5_r.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_r.blp`, `KVCT3_Data\txx110_4_r.blp`, `KVCT3_Data\txx110_2_r.blp`, `KVCT3_Data\txx110_3_r.blp` | riêng phái |

## 8. Kiếm Chủng Dẫn [D]  (id X410, kind 13)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 50% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_kiemchungdan4.mdx` | `KVCT3_Data\JL2-1.blp`, `KVCT3_Data\JL2-2.blp`, `Textures\Smoke.blp` | riêng phái |
| trên địch bị trúng | `TDK_targeteffect2.mdx` | `KVCT3_Data\txx110_5_r.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_r.blp`, `KVCT3_Data\txx110_4_r.blp`, `KVCT3_Data\txx110_2_r.blp`, `KVCT3_Data\txx110_3_r.blp` | riêng phái |

## 9. Bính Nhược Quan Hỏa [bị động]  (id X411, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_chanhoabuff.mdx` | `KVCT3_Data\JN_tianmodun1.blp`, `KVCT3_Data\JN_tianmodun2.blp` | riêng phái |
| buff (trên tướng) | `TDK_chanhoabuff2.mdx` | `Textures\GenericGlow1.blp`, `Textures\LavaLump2.blp`, `units\Demon\Felgaurd\FelGuard.blp`, `Textures\Knife_spinningBlade.blp`, `UI\Glues\SinglePlayer\Orc_Exp\Stars3.blp`, `Textures\Clouds8x8.blp`, `Textures\Energy1.blp`, `Textures\Flame4.blp`, `Textures\GenericGlow2b.blp` | riêng phái |

## 10. Ngang Nhật Đồ [bị động]  (id X412, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_techieukiem.mdx` | `Textures\Clouds8x8Fire.blp`, `Textures\star2.blp`, `KVCT3_Data\zhuxian.blp`, `Textures\Flare.blp` | riêng phái |

## 11. Bách Điểu Triều Phượng [E]  (id X413, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 40% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_kiemchungdan4.mdx` | `KVCT3_Data\JL2-1.blp`, `KVCT3_Data\JL2-2.blp`, `Textures\Smoke.blp` | riêng phái |
| trên địch bị trúng | `TDK_targeteffect2.mdx` | `KVCT3_Data\txx110_5_r.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_r.blp`, `KVCT3_Data\txx110_4_r.blp`, `KVCT3_Data\txx110_2_r.blp`, `KVCT3_Data\txx110_3_r.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TDK_bachdieukiem.mdx` | `KVCT3_Data\WQ06.blp`, `Textures\Flare.blp`, `Textures\Red_Glow3.blp`, `Textures\star32.blp`, `Textures\Purple_Glow.blp`, `Textures\Shockwave_Ice1.blp` | riêng phái |

## 12. Phần Phách Tru Tâm [bị động]  (id X414, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_tramvankiem2.mdx` | `Textures\star32.blp`, `Textures\WaterBlobs1.blp`, `Textures\Shockwave10.blp`, `Textures\RibbonNE1_White.blp`, `Textures\Purple_Glow.blp`, `Textures\Flare.blp`, `Textures\Blue_Glow2.blp`, `Textures\Dust5ABlack.blp` | riêng phái |

## 13. Hỏa Hải Vô Nhai [bị động]  (id X415, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDK_hoahai.mdx` | `KVCT3_Data\GodBoy_saboguanghuan01.blp`, `KVCT3_Data\Moon_texiao_fugaihongzha_01_xulie_baozhahuohua.blp`, `KVCT3_Data\GodBoy_saboguanghuan02.blp` | riêng phái |
