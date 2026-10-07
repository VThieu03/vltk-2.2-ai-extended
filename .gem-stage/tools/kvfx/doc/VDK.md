# VDK (E001): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/VDK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `VDK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Tam Hoàn Sáo Nguyệt [Q]  (id X026, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 30% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_tamhoanthaonguyet.mdx` | `Textures\lensflare1A.blp`, `Textures\GenericGlow1.blp`, `Textures\Shockwave10.blp`, `Textures\Zap1.blp`, `Textures\Blue_Glow2.blp`, `Textures\BlueSqGlow.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 2. Võ Đang Kiếm Pháp [bị động]  (id X027, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_vothuongkiem.mdx` | `KVCT3_Data\ZapBlue1.blp`, `KVCT3_Data\CircleBlue.blp`, `KVCT3_Data\StarBlue.blp`, `KVCT3_Data\ZapLightning1X4.blp`, `KVCT3_Data\GlowBlue.blp`, `KVCT3_Data\222.blp` | riêng phái |

## 3. Tọa Vọng Vô Ngã [D]  (id X028, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ToaVongVoNga.mdx` | `Textures\GenericGlow64.blp`, `YinYang_a.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: VDQ) |
| lúc tung (trên tướng) | `VDK_vongacast.mdx` | `KVCT3_Data\ThaiCuc.blp`, `Textures\Yellow_Glow3.blp` | riêng phái |

## 4. Lưu Tinh Cản Nguyệt [R]  (id X029, kind 3)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_nhankiemcast.mdx` | `Textures\RibbonBlur1.blp` | riêng phái |

## 5. Thất Tinh Quyết [bị động]  (id X030, kind 0)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_thattinhaura.mdx` | `KVCT3_Data\ThatTinhQuyet.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `VDK_thattinhaura.mdx` | `KVCT3_Data\ThatTinhQuyet.blp` | riêng phái |

## 6. Kiếm Khí Tung Hoành [bị động]  (id X031, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_tutieuhoanhvan.mdx` | `Textures\Flare.blp`, `KVCT3_Data\Effect_AZ_GenericGlow.blp`, `KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp`, `KVCT3_Data\Effect_AZ_Shockwave2B.blp` | riêng phái |

## 7. Nhân Kiếm Hợp Nhất [W]  (id X032, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 35% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_nhankiemsword.mdx` | `Textures\Blue_Glow2.blp`, `KVCT3_Data\ColdSword2.BLP` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `VDK_nhankiemcast.mdx` | `Textures\RibbonBlur1.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `VDK_nhankiemtarget.mdx` | `Textures\lensflare1A.blp`, `Textures\GenericGlow1.blp`, `Textures\Shockwave10.blp`, `Textures\Zap1.blp`, `Textures\Blue_Glow2.blp`, `Textures\BlueSqGlow.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 8. Lưỡng Nghi Kiếm Pháp [F]  (id X033, kind 17)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 50% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_luongnghikiem.mdx` | `KVCT3_Data\thorarrow.blp`, `KVCT3_Data\Blue_Glow3.blp` | riêng phái |

## 9. Thái Nhất Chân Khí [bị động]  (id X034, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_thainhat.mdx` | `Textures\GenericGlow2b.blp`, `KVCT3_Data\YinYang_a.blp` | riêng phái |

## 10. Mê Tung Huyễn Ảnh [bị động]  (id X035, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\MeTungHuyenAnh.mdx` | `Textures\Blue_Glow2.blp`, `Textures\Zap1.blp`, `Bakua_b.blp` | dùng chung (model Thiên Kiếm) |

## 11. Vô Thượng Kiếm Đạo [E]  (id X036, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 40% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_vothuongkiem.mdx` | `KVCT3_Data\ZapBlue1.blp`, `KVCT3_Data\CircleBlue.blp`, `KVCT3_Data\StarBlue.blp`, `KVCT3_Data\ZapLightning1X4.blp`, `KVCT3_Data\GlowBlue.blp`, `KVCT3_Data\222.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `VDK_vothuongcastereffect.mdx` | `KVCT3_Data\Dawn_Slash_Lightning_01.blp`, `KVCT3_Data\Dawn_Slash_Lightning_02.blp`, `KVCT3_Data\Dawn_Slash_Lightning_03.blp`, `KVCT3_Data\Dawn_Slash_Lightning_04.blp`, `KVCT3_Data\Dawn_Slash_Lightning_05.blp`, `KVCT3_Data\Dawn_Slash_Lightning_06.blp`, `KVCT3_Data\Dawn_Slash_Lightning_07.blp`, `KVCT3_Data\Dawn_Slash_Lightning_08.blp`, `KVCT3_Data\Dawn_Slash_Lightning_09.blp`, `KVCT3_Data\Dawn_Slash_Lightning_10.blp`, `KVCT3_Data\Dawn_Slash_Lightning_11.blp`, `KVCT3_Data\Dawn_Slash_Lightning_12.blp`, `KVCT3_Data\Dawn_Slash_Lightning_13.blp`, `KVCT3_Data\Dawn_Slash_Lightning_14.blp`, `KVCT3_Data\Dawn_Slash_Lightning_15.blp`, `KVCT3_Data\Dawn_Slash_Lightning_16.blp`, `KVCT3_Data\Dawn_lightning1.blp`, `KVCT3_Data\Dawn_lightning2.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `VDK_vothuongtarget.mdx` | `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N2s_star2.blp`, `KVCT3_Data\Hero_Jingke_N3s_glow2.blp`, `KVCT3_Data\Hero_Jingke_N4s_star.blp`, `KVCT3_Data\Hero_Jingke_N4s_glow1.blp`, `KVCT3_Data\Hero_Jingke_N4s_glow2.blp`, `KVCT3_Data\Hero_Jingke_N4s_glow.blp`, `KVCT3_Data\Hero_Jingke_N4s_star1.blp`, `KVCT3_Data\Hero_Jingke_N4s_star2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `VDK_vocuckiemy.mdx` | `KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp` | riêng phái |

## 12. Thái Cực Kiếm Pháp [bị động]  (id X037, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_vocuckiemy.mdx` | `KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp`, `KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp` | riêng phái |

## 13. Tử Tiêu Hoành Vân [T]  (id X038, kind 18)
Nguồn model: **chọn theo tên / tk_mapping**
Trạng thái gây ra: **làm chậm** 100% trong 24.0 giây → model trạng thái `Effect_dongbang.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `VDK_tutieuhoanhvan.mdx` | `Textures\Flare.blp`, `KVCT3_Data\Effect_AZ_GenericGlow.blp`, `KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp`, `KVCT3_Data\Effect_AZ_Shockwave2B.blp` | riêng phái |
| buff (trên tướng) | `VDK_tutieubuff.mdx` | `KVCT3_Data\GameBABY_a1101.blp`, `KVCT3_Data\GameBABY_a1102.blp` | riêng phái |
