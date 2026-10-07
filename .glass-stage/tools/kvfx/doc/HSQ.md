# HSQ (H027): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/HSQ.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `HSQ_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Thanh Vân Tống Sảng [Q]  (id X364, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_thanhvan.mdx` | `KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp`, `KVCT3_Data\Hero_Undying_N2S_D_hand.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow1.blp`, `KVCT3_Data\Hero_Undying_N2S_star.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow2.blp`, `KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp` | riêng phái |
| lúc tung (trên tướng) | `HSQ_caster.mdx` | `KVCT3_Data\Glow.blp`, `KVCT3_Data\GlowBlack2.blp`, `KVCT3_Data\Zap2.blp`, `KVCT3_Data\Ribbon3.blp` | riêng phái |

## 2. Hoa Sơn Khí Công [bị động]  (id X365, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_hainapbachxuyen.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star32.blp`, `UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_Shockwave1_White.blp` | riêng phái |

## 3. Long Nhiễu Thân [bị động]  (id X366, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_mavankk2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_RiBbon_White02.blp`, `KVCT3_Data\AZ_Smoke12.blp`, `Textures\GenericGlow2_64_blue.blp`, `KVCT3_Data\AZ_Glow04.blp`, `Textures\Dust3.blp`, `Textures\Frost3.blp`, `Textures\GenericGlow1.blp`, `Textures\Clouds8x8Grey.blp`, `KVCT3_Data\AZ_star2.blp` | riêng phái |

## 4. Chân Khí Hộ Thể [R]  (id X367, kind 8)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_chankhihothecast.mdx` | `KVCT3_Data\HellscreamW.blp`, `Textures\Flare.blp`, `KVCT3_Data\HellscreamW2.blp` | riêng phái |
| lúc tung (trên tướng) | `HSQ_chankhihothecast.mdx` | `KVCT3_Data\HellscreamW.blp`, `Textures\Flare.blp`, `KVCT3_Data\HellscreamW2.blp` | riêng phái |

## 5. Hải Nạp Bách Xuyên [bị động]  (id X368, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_hainapbachxuyen.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star32.blp`, `UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_Shockwave1_White.blp` | riêng phái |

## 6. Khí Chấn Sơn Hà [bị động]  (id X369, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_phangoc.mdx` | `KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp`, `KVCT3_Data\Hero_Undying_N2S_D_hand.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow1.blp`, `KVCT3_Data\Hero_Undying_N2S_star.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow2.blp`, `KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp` | riêng phái |

## 7. Ma Vân Kiếm Khí [W]  (id X370, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_mavansword.mdx` | `Textures\Star7b.blp`, `Textures\Shockwave1.blp`, `Textures\Dust5A.blp`, `KVCT3_Data\wx_jian4.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `HSQ_caster.mdx` | `KVCT3_Data\Glow.blp`, `KVCT3_Data\GlowBlack2.blp`, `KVCT3_Data\Zap2.blp`, `KVCT3_Data\Ribbon3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HSQ_mavankk2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_RiBbon_White02.blp`, `KVCT3_Data\AZ_Smoke12.blp`, `Textures\GenericGlow2_64_blue.blp`, `KVCT3_Data\AZ_Glow04.blp`, `Textures\Dust3.blp`, `Textures\Frost3.blp`, `Textures\GenericGlow1.blp`, `Textures\Clouds8x8Grey.blp`, `KVCT3_Data\AZ_star2.blp` | riêng phái |

## 8. Khí Quán Trường Hồng [bị động]  (id X371, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_thanhvan.mdx` | `KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp`, `KVCT3_Data\Hero_Undying_N2S_D_hand.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow1.blp`, `KVCT3_Data\Hero_Undying_N2S_star.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow2.blp`, `KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp` | riêng phái |

## 9. Tử Hà Chân Khí [D]  (id X372, kind 8)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_tuhachankhi.mdx` | `KVCT3_Data\Hero_Butcher_N6_VFX_03.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_05.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_11.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_02.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_01.blp`, `KVCT3_Data\TX_Star2020.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_04.blp` | riêng phái |
| lúc tung (trên tướng) | `HSQ_chankhihothecast.mdx` | `KVCT3_Data\HellscreamW.blp`, `Textures\Flare.blp`, `KVCT3_Data\HellscreamW2.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HSQ_chankhihothe.mdx` | `KVCT3_Data\AZ_glow2.blp`, `KVCT3_Data\AZ_Ribbon1X.blp`, `KVCT3_Data\AZ_WhiteFire6x6.blp`, `KVCT3_Data\AZ_Shockwave31.blp`, `KVCT3_Data\AZ_Shockwave1t.blp`, `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 10. Huyền Nhãn Yên Vân [bị động]  (id X373, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_tukhidl.mdx` | `KVCT3_Data\GameBABY_ss422a01.blp`, `KVCT3_Data\GameBABY_ss422a02.blp` | riêng phái |

## 11. Phách Thạch Phá Ngọc [E]  (id X374, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_phachthach.mdx` | `KVCT3_Data\effect_anranxiaohunzhang.blp`, `KVCT3_Data\effect_anranxiaohunzhang02.blp`, `KVCT3_Data\effect_anranxiaohunzhang03.blp`, `Textures\GenericGlow2c.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `HSQ_caster.mdx` | `KVCT3_Data\Glow.blp`, `KVCT3_Data\GlowBlack2.blp`, `KVCT3_Data\Zap2.blp`, `KVCT3_Data\Ribbon3.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HSQ_mavankk2.mdx` | `Textures\Flare.blp`, `KVCT3_Data\AZ_RiBbon_White02.blp`, `KVCT3_Data\AZ_Smoke12.blp`, `Textures\GenericGlow2_64_blue.blp`, `KVCT3_Data\AZ_Glow04.blp`, `Textures\Dust3.blp`, `Textures\Frost3.blp`, `Textures\GenericGlow1.blp`, `Textures\Clouds8x8Grey.blp`, `KVCT3_Data\AZ_star2.blp` | riêng phái |
| lớp thêm tại điểm 2 | `HSQ_phangoc2.mdx` | `KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp`, `KVCT3_Data\Hero_Undying_N2S_D_hand.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow1.blp`, `KVCT3_Data\Hero_Undying_N2S_star.blp`, `KVCT3_Data\Hero_Undying_N2S_D_glow2.blp`, `KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp` | riêng phái |

## 12. Thần Quang Toàn Nhiễu [bị động]  (id X375, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_hainapbachxuyen.mdx` | `Textures\Flare.blp`, `Textures\star4_32.blp`, `Textures\star32.blp`, `UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_Shockwave1_White.blp` | riêng phái |

## 13. Tử Khí Đông Lai [bị động]  (id X376, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSQ_tukhidl.mdx` | `KVCT3_Data\GameBABY_ss422a01.blp`, `KVCT3_Data\GameBABY_ss422a02.blp` | riêng phái |
