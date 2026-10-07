# HSK (H028): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/HSK.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `HSK_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Bạch Hồng Quán Nhật [Q]  (id X377, kind 16)
Nguồn model: **chọn theo tên / tk_mapping**
Trạng thái gây ra: **choáng** 30% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_bachhong.mdx` | `KVCT3_Data\txx110_5_b.blp`, `KVCT3_Data\txx110_1.blp`, `KVCT3_Data\txx110_b.blp`, `KVCT3_Data\txx110_4_b.blp`, `KVCT3_Data\txx110_2_b.blp`, `KVCT3_Data\txx110_3_b.blp` | riêng phái |

## 2. Kiếm Tông Tổng Quyết [bị động]  (id X378, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_phakiemthuc.mdx` | `KVCT3_Data\BF_DaoGuang_1.blp`, `KVCT3_Data\BF_Lizi.blp` | riêng phái |

## 3. Long Nhiễu Thân [bị động]  (id X379, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_kiemvu.mdx` | `ReplaceableTextures\TeamColor\TeamColor09.blp`, `KVCT3_Data\qingtongjian.blp`, `KVCT3_Data\qingtongjianGH.blp`, `Textures\GenericGlow2c.blp` | riêng phái |

## 4. Thiên Thân Đảo Huyền [E]  (id X380, kind 13)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **choáng** 40% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_thienthandaohuyen.mdx` | `ReplaceableTextures\TeamColor\TeamColor09.blp`, `KVCT3_Data\qingtongjianGH.blp`, `Textures\Clouds8x8Fire.blp` | riêng phái |
| trên địch bị trúng | `HSK_thienthantarget.mdx` | `KVCT3_Data\Hero_Jingke_N2s_light6.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp`, `KVCT3_Data\Hero_Jingke_N2s_star2.blp` | riêng phái |
| buff (trên tướng) | `HSK_thienthanaura.mdx` | `KVCT3_Data\Hero_Butcher_N6_VFX_03.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_05.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_11.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_02.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_01.blp`, `KVCT3_Data\TX_Star2020.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_04.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HSK_thienthanaura2.mdx` | `KVCT3_Data\Hero_Butcher_N6_VFX_03.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_05.blp`, `KVCT3_Data\Hero_Butcher_N5_ef_11.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_02.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_01.blp`, `KVCT3_Data\TX_Star2020.blp`, `KVCT3_Data\Hero_Butcher_N6_VFX_04.blp` | riêng phái |

## 5. Kim Nhạn Hoành Không [R]  (id X381, kind 6)
Nguồn model: **bảng KVCT tự sinh**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NMC_phongsuongtoaianh.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp`, `Textures\Flare.blp`, `Textures\GenericGlow2_64_blue.blp`, `Textures\GenericGlow2b.blp`, `Textures\star2_32.blp`, `Textures\star5tga.blp`, `Textures\star4_32.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\RibbonBlur1.blp`, `Textures\clouds_anim1_bw.blp`, `Abilities\Spells\Undead\VampiricAura\AuraRune6.blp`, `Textures\RibbonNE1_White.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\GenericGlow1.blp`, `Textures\clouds_anim1.blp`, `Textures\CloudSingle.blp` | dùng chung (cùng dùng: CLD, NMC) |
| lúc tung (trên tướng) | `HSK_kimnhancast.mdx` | `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp`, `Textures\ShockwaveWater1.blp`, `UI\MiniMap\ping4.blp` | riêng phái |

## 6. Hi Di Kiếm Pháp [bị động]  (id X382, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_thienthantarget.mdx` | `KVCT3_Data\Hero_Jingke_N2s_light6.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp`, `KVCT3_Data\Hero_Jingke_N2s_star2.blp` | riêng phái |

## 7. Thương Tùng Nghênh Khách [W]  (id X383, kind 5)
Nguồn model: **chọn theo tên / tk_mapping**
Trạng thái gây ra: **choáng** 35% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_thuongtungkiem.mdx` | `KVCT3_Data\jxqy3M_B_07.blp`, `Textures\Flare.blp` | riêng phái |
| trên địch bị trúng | `HSK_thuongtungtarget.mdx` | `KVCT3_Data\Hero_Jingke_N2s_light6.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp`, `KVCT3_Data\Hero_Jingke_N2s_star2.blp` | riêng phái |

## 8. Thái Nhạc Tam Thanh [bị động]  (id X384, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_thuongtungtarget.mdx` | `KVCT3_Data\Hero_Jingke_N2s_light6.blp`, `KVCT3_Data\Hero_Jingke_N2s_star1.blp`, `KVCT3_Data\Hero_Jingke_N2s_star2.blp` | riêng phái |

## 9. Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm [D]  (id X385, kind 6)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_doatmenhbuff.mdx` | `KVCT3_Data\ArcaneRune.blp` | riêng phái |
| lúc tung (trên tướng) | `HSK_doatmenhcast.mdx` | `Textures\grad2b.blp`, `Textures\GenericGlow64.blp`, `Textures\Star8c.blp`, `Textures\GenericGlowFaded.blp`, `KVCT3_Data\Hero_ShadowFiend_N4_ef_11.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_12.blp`, `KVCT3_Data\TX_Star2004.blp` | riêng phái |

## 10. Phá Kiếm Thức [bị động]  (id X386, kind 4)
Nguồn model: **chọn theo tên / tk_mapping**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_phakiemthuc.mdx` | `KVCT3_Data\BF_DaoGuang_1.blp`, `KVCT3_Data\BF_Lizi.blp` | riêng phái |

## 11. Cửu Kiếm Hợp Nhất [bị động]  (id X387, kind 5)
Nguồn model: **chọn theo tên / tk_mapping**
Trạng thái gây ra: **choáng** 50% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_cuukiem.mdx` | `KVCT3_Data\Hero_TemplarAssassin_N1_star4.blp`, `KVCT3_Data\TX_Star2004.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp`, `KVCT3_Data\TX_Star5.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_15.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_02.blp` | riêng phái |

## 12. Nhất Kiếm Phá Vạn Pháp [bị động]  (id X388, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_phakiemthuc.mdx` | `KVCT3_Data\BF_DaoGuang_1.blp`, `KVCT3_Data\BF_Lizi.blp` | riêng phái |

## 13. Độc Cô Cửu Kiếm [bị động]  (id X389, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `HSK_cuukiem.mdx` | `KVCT3_Data\Hero_TemplarAssassin_N1_star4.blp`, `KVCT3_Data\TX_Star2004.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp`, `KVCT3_Data\TX_Star5.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_15.blp`, `KVCT3_Data\Hero_TemplarAssassin_N3S_ef_02.blp` | riêng phái |
