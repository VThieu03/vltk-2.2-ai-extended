# TYK (H02B): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TYK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TYK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Phong Quyển Tàn Tuyết [Q]  (id X416, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 30% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_phongquyen.mdx` | `Textures\snowflake.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\rainTail.blp` | riêng phái |
| lúc tung (trên tướng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái, phái khác cũng dùng: TYD |

## 2. Thúy Yên Kiếm Pháp [bị động]  (id X417, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_bangtamtientu2.mdx` | `KVCT3_Data\AZ_Flashb2P_2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_smokeT1.blp`, `KVCT3_Data\AZ_Snowflake2.blp` | riêng phái |

## 3. Tuyết Ảnh [bị động]  (id X418, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |
| aura bị động (gắn tướng suốt) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |

## 4. Vũ Đả Lê Hoa [R]  (id X419, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 80% trong 4.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_huyenbang.mdx` | `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp` | riêng phái, phái khác cũng dùng: TYD |
| lúc tung (trên tướng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái, phái khác cũng dùng: TYD |

## 5. Hộ Thể Hàn Băng [bị động]  (id X420, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_hothehanbang.mdx` | `KVCT3_Data\GameBABY_ss422a01.blp`, `KVCT3_Data\GameBABY_ss422a02.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYK_huyenbang.mdx` | `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp` | riêng phái, phái khác cũng dùng: TYD |

## 6. Băng Cốt Tuyết Tâm [bị động]  (id X421, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |

## 7. Băng Tâm Tiên Tử [W]  (id X422, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 35% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_bangtamtientu2.mdx` | `KVCT3_Data\AZ_Flashb2P_2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_smokeT1.blp`, `KVCT3_Data\AZ_Snowflake2.blp` | riêng phái |
| lúc tung (trên tướng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái, phái khác cũng dùng: TYD |
| buff (trên tướng) | `TYK_Buffbangtam.mdx` | `Textures\Ghost2.blp`, `KVCT3_Data\chongjibo_frost.blp`, `KVCT3_Data\chongjibo2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYK_bangtamtientu1.mdx` | `KVCT3_Data\jianxiashaon1.blp` | riêng phái |

## 8. Phi Tự Phiêu Hoa [D]  (id X423, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 50% trong 3.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_phituphieuhoaeffect.mdx` | `Textures\Clouds8x8.blp`, `Textures\Frost3.blp`, `Textures\snowflake.blp`, `Textures\Dust3x.blp`, `Abilities\Spells\Human\Blizzard\Frost3test.blp` | riêng phái |
| lúc tung (trên tướng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái, phái khác cũng dùng: TYD |
| trên địch bị trúng | `TYK_phituphieuhoaeffect.mdx` | `Textures\Clouds8x8.blp`, `Textures\Frost3.blp`, `Textures\snowflake.blp`, `Textures\Dust3x.blp`, `Abilities\Spells\Human\Blizzard\Frost3test.blp` | riêng phái |

## 9. Phù Vân Tán Tuyết [bị động]  (id X424, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |

## 10. Băng Tâm Ngọc Lăng [F]  (id X425, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_Buffbangtam.mdx` | `Textures\Ghost2.blp`, `KVCT3_Data\chongjibo_frost.blp`, `KVCT3_Data\chongjibo2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYK_bangtamtientu1.mdx` | `KVCT3_Data\jianxiashaon1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TYK_bangtamtientu2.mdx` | `KVCT3_Data\AZ_Flashb2P_2.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_smokeT1.blp`, `KVCT3_Data\AZ_Snowflake2.blp` | riêng phái |

## 11. Thủy Ánh Mạn Tú [E]  (id X426, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **làm chậm** 40% trong 2.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_thuyanh1.mdx` | `KVCT3_Data\AZ_RibbonNE2S.blp`, `KVCT3_Data\AZ_Smoke2x2A1.blp`, `KVCT3_Data\AZ_water6.blp` | riêng phái |
| lúc tung (trên tướng) | `TYK_effectcast.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star5tga.blp`, `KVCT3_Data\tx163-1.blp`, `KVCT3_Data\tx163-2.blp`, `KVCT3_Data\tx163-3.blp` | riêng phái, phái khác cũng dùng: TYD |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TYK_phituphieuhoaeffect.mdx` | `Textures\Clouds8x8.blp`, `Textures\Frost3.blp`, `Textures\snowflake.blp`, `Textures\Dust3x.blp`, `Abilities\Spells\Human\Blizzard\Frost3test.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TYK_thuyanhmantu.mdx` | `KVCT3_Data\icespirit.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TYK_thuyanheffect2.mdx` | `Textures\Flare.blp`, `Textures\Dust3.blp` | riêng phái |

## 12. Thập Diện Mai Phục [bị động]  (id X427, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |

## 13. Tuyết Ánh Hồng Trần [bị động]  (id X428, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TYK_tuyetanh.mdx` | `Textures\star5tga.blp`, `Textures\star5tga.blp`, `Textures\snowflake2.blp` | riêng phái, phái khác cũng dùng: TYD |
