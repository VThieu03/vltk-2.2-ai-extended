# TVD (H002): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TVD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TVD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Kinh Lôi Trảm [Q]  (id X013, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_targeteffect1.mdx` | `KVCT3_Data\Hero_Jingke_Star7.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_glow2.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N1s_star3.blp`, `KVCT3_Data\Hero_Jingke_N1s_star4.blp`, `KVCT3_Data\Hero_Jingke_N1s_light.blp`, `KVCT3_Data\TX_Star4.blp` | riêng phái |
| trên địch bị trúng | `TVD_targeteffect1.mdx` | `KVCT3_Data\Hero_Jingke_Star7.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_glow2.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N1s_star3.blp`, `KVCT3_Data\Hero_Jingke_N1s_star4.blp`, `KVCT3_Data\Hero_Jingke_N1s_light.blp`, `KVCT3_Data\TX_Star4.blp` | riêng phái |

## 2. Thiên Vương Đao Pháp [bị động]  (id X014, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phathientram.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |

## 3. Đoạn Hồn Thích [R]  (id X015, kind 3)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **định thân** 30% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVT_doanhonthich.mdx` | `KVCT3_Data\HB02_weapon02.blp`, `KVCT3_Data\HB02_ATTACK.blp`, `Textures\RibbonNE1_White.blp` | dùng chung (cùng dùng: TVC, TVT) |
| trên địch bị trúng | `TVD_targeteffect1.mdx` | `KVCT3_Data\Hero_Jingke_Star7.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_glow2.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N1s_star3.blp`, `KVCT3_Data\Hero_Jingke_N1s_star4.blp`, `KVCT3_Data\Hero_Jingke_N1s_light.blp`, `KVCT3_Data\TX_Star4.blp` | riêng phái |

## 4. Kinh Lôi Phá Thiên [bị động]  (id X016, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phathientram.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |

## 5. Thiên Vương Chiến Ý [D]  (id X017, kind 7)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phathientram.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |

## 6. Thiên Canh Chiến Khí [bị động]  (id X018, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phathientram.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |

## 7. Phá Thiên Trảm [W]  (id X019, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phathientram.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |
| trên địch bị trúng | `TVD_targeteffect2.mdx` | `KVCT3_Data\[NFTS]2019826103036_0060[1].blp`, `Textures\Shockwave1White.blp`, `KVCT3_Data\[NFTS]2019826103036_0060[2].blp`, `KVCT3_Data\[NFTS]2019826103036_0060[3].blp` | riêng phái |

## 8. Tĩnh Tâm Quyết [bị động]  (id X020, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phitinhtramthichbuff.mdx` | `KVCT3_Data\[AKE]000011.blp` | riêng phái |

## 9. Phi Tinh Trảm Thích [bị động]  (id X021, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_phitinhtramthichbuff.mdx` | `KVCT3_Data\[AKE]000011.blp` | riêng phái |

## 10. Tung Hoành Bát Hoang [F]  (id X022, kind 8)
Nguồn model: **bảng KVCT tự sinh**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_tunghoanhbathoangbuff.mdx` | `KVCT3_Data\Hero_SkeletonKing_N6S_light.blp`, `KVCT3_Data\Hero_SkeletonKing_N6S_light3.blp`, `KVCT3_Data\Hero_SkeletonKing_N6S_glow1.blp` | riêng phái |

## 11. Hào Hùng Trảm [E]  (id X023, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_tranphainewz2.mdx` | `KVCT3_Data\ur05_0.blp`, `KVCT3_Data\ur05_1.blp`, `KVCT3_Data\ur05_2.blp`, `KVCT3_Data\ur05_3.blp`, `KVCT3_Data\ur05_4.blp`, `KVCT3_Data\ur05_5.blp` | riêng phái |
| lúc tung (trên tướng) | `TVD_tranphaicast.mdx` | `KVCT3_Data\ZK-Knife light1.blp`, `KVCT3_Data\ZK-Knife light2.BLP`, `KVCT3_Data\ZK-Knife light5.blp`, `KVCT3_Data\ZK-Knife light3.blp`, `KVCT3_Data\ZK-Knife light6.blp`, `KVCT3_Data\ZK-Knife light7.blp`, `KVCT3_Data\ZK-Knife light4.blp`, `KVCT3_Data\ZK-Knife light8.blp` | riêng phái |
| trên địch bị trúng | `TVD_targeteffect1.mdx` | `KVCT3_Data\Hero_Jingke_Star7.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_glow2.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N1s_star3.blp`, `KVCT3_Data\Hero_Jingke_N1s_star4.blp`, `KVCT3_Data\Hero_Jingke_N1s_light.blp`, `KVCT3_Data\TX_Star4.blp` | riêng phái |

## 12. Bát Phong Trảm [bị động]  (id X024, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TVD_targeteffect1.mdx` | `KVCT3_Data\Hero_Jingke_Star7.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Jingke_glow2.blp`, `KVCT3_Data\Hero_Jingke_N1s_star1.blp`, `KVCT3_Data\Hero_Jingke_N1s_star3.blp`, `KVCT3_Data\Hero_Jingke_N1s_star4.blp`, `KVCT3_Data\Hero_Jingke_N1s_light.blp`, `KVCT3_Data\TX_Star4.blp` | riêng phái |

## 13. Thiên Mã Hành Không [bị động]  (id X025, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\ThienMaHanhKhong.mdx` | `Textures\GenericGlow64.blp`, `HoaHiemViDi.blp` | dùng chung (model Thiên Kiếm) (cùng dùng: TVC, TVT) |
