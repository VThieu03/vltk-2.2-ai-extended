# TDC (H029): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TDC.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TDC_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Dương Ca Thiên Quân [Q]  (id X390, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 30% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_duongca.mdx` | `Textures\firering1A.blp`, `Textures\White_64_Foam1.blp` | riêng phái |
| lúc tung (trên tướng) | `TDC_caster.mdx` | `KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TDC_wave1.mdx` | `Textures\Blue_Star2.blp`, `Textures\Flare.blp` | riêng phái |

## 2. Tiêu Dao Chưởng Pháp [bị động]  (id X391, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_baivanchuong.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP` | riêng phái |

## 3. Hàn Tụ Huyệt [R]  (id X392, kind 17)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **định thân** 90% trong 3.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_tuhuyet.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `KVCT3_Data\RibbonNE2.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Flashb17.blp`, `KVCT3_Data\AZ_Ribbon42.blp` | riêng phái |
| lúc tung (trên tướng) | `TDC_caster2.mdx` | `Textures\Ghost1.blp`, `KVCT3_Data\BattlecastGlow.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |

## 4. Sưu Hồn Đại Pháp [bị động]  (id X393, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_baivanchuong.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP` | riêng phái |

## 5. Diệm Nguyên Luân Hồi [bị động]  (id X394, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_diemnguyenbuff.mdx` | `KVCT3_Data\AZ_Shockwave1J.blp`, `KVCT3_Data\AZ_glow4.blp`, `KVCT3_Data\AZ_Smoke2x2A2_ice.blp` | riêng phái |

## 6. Phục Nhật Xuất Vân [bị động]  (id X395, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_sinhtuphu11.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `KVCT3_Data\RibbonNE2.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Flashb17.blp`, `KVCT3_Data\AZ_Ribbon42.blp` | riêng phái |

## 7. Bạch Nhật Sâm Thần [W]  (id X396, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 35% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_bachnhat1.mdx` | `Textures\Dust3x.blp`, `Textures\LightningBall.blp`, `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `Textures\star8.blp`, `Textures\Tornado2b.blp`, `Textures\Flare.blp`, `KVCT3_Data\AZ_Shockwave1White4.blp`, `KVCT3_Data\AZ_Shockwave17.blp`, `Textures\star4.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `TDC_caster.mdx` | `KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TDC_bachnhat2.mdx` | `KVCT3_Data\TX_Star19.blp`, `KVCT3_Data\Hero_Sven_N4_EF_07.blp`, `KVCT3_Data\Hero_Sven_N3S_W_Target2_10.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\Hero_Sven_N4_EF_05.blp`, `KVCT3_Data\Hero_Sven_N4_EF_06.blp`, `KVCT3_Data\TX_Star1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TDC_wave1.mdx` | `Textures\Blue_Star2.blp`, `Textures\Flare.blp` | riêng phái |

## 8. Sinh Tử Phù [D]  (id X397, kind 13)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 50% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_sinhtuphueffect.mdx` | `KVCT3_Data\AZ_Flare6.blp`, `Textures\Flare.blp`, `Textures\Tornado2b.blp`, `KVCT3_Data\AZ_Shockwave12.blp`, `Textures\lensflare1Ax.blp`, `KVCT3_Data\Disruptor_Aghanim1_purple.blp` | riêng phái |
| lúc tung (trên tướng) | `TDC_sinhtuphucaster.MDX` | `KVCT3_Data\SetItems_N4S_Red_FlareLightning.blp`, `KVCT3_Data\SetItems_N4S_Red_lightning4.blp`, `KVCT3_Data\SetItems_N4S_Red_Flare2.blp`, `KVCT3_Data\SetItems_N4S_Red_Flare.blp`, `KVCT3_Data\SetItems_N5_TP_ef_16.blp`, `KVCT3_Data\TX_Star1.blp`, `KVCT3_Data\TX_Star20.blp`, `KVCT3_Data\TX_Star2004.blp`, `KVCT3_Data\SetItems_N5_TP_ef_05.blp`, `KVCT3_Data\SetItems_N5_TP_ef_06.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |
| buff (trên tướng) | `TDC_sinhtubuff.mdx` | `KVCT3_Data\GameBABY_ss422a01.blp`, `KVCT3_Data\GameBABY_ss422a02.blp` | riêng phái |

## 9. Hỗn Nhật Khí Quyết [bị động]  (id X398, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_honnhatbuff.mdx` | `Textures\Flare.blp`, `Textures\Dust3.blp`, `Textures\star4_32.blp` | riêng phái |

## 10. Thiên Tàm Cửu Biến [F]  (id X399, kind 18)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_thientamcb.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp` | riêng phái |

## 11. Bài Sơn Đảo Hải [E]  (id X400, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 40% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_wave1.mdx` | `Textures\Blue_Star2.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `TDC_caster2.mdx` | `Textures\Ghost1.blp`, `KVCT3_Data\BattlecastGlow.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TDC_baisondh.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `Textures\Purple_Glow.blp`, `Textures\Purple_Glow_Dim.blp`, `Textures\Purple_Star.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01_yellow.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang02_yellow.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang03.blp` | riêng phái |

## 12. Thái Hư Thần Công [bị động]  (id X401, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_thientamcb.mdx` | `Textures\lensflare1A.blp`, `Textures\star4.blp`, `Textures\Dust6.blp`, `Textures\Energy1.blp` | riêng phái |

## 13. Tung Bộ Quan Hỏa [T]  (id X402, kind 3)
Nguồn model: **chọn theo tên / tk_mapping**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TDC_tuhuyet.mdx` | `Textures\Flare.blp`, `Textures\Clouds8x8Mod.blp`, `KVCT3_Data\RibbonNE2.blp`, `Textures\Dust3.blp`, `KVCT3_Data\AZ_Flashb17.blp`, `KVCT3_Data\AZ_Ribbon42.blp` | riêng phái |
| lúc tung (trên tướng) | `TDC_caster.mdx` | `KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp`, `KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp` | riêng phái |
| trên địch bị trúng | `TDC_target.mdx` | `Textures\GenericGlowFaded.blp`, `Textures\LavaLump.blp`, `Textures\Flame4.blp`, `Textures\LavaLump2.blp`, `Textures\RingOFire.blp`, `Textures\Shockwave9.blp` | riêng phái |
