# NDD (E000): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/NDD.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/VLTK_data/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `NDD_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Huyết Đao Độc Sát [Q]  (id X000, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 30% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_huyetdao.mdx` | `Textures\HeroDemonHunter.blp`, `Textures\Energy1.blp`, `Textures\Green_Glow2.blp`, `Textures\Green_Glow3.blp`, `Textures\Dust3.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Weapons\GargoyleMissile\GargoyleMissile.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 2. Ngũ Độc Đao Pháp [bị động]  (id X001, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_chucapcoc.mdx` | `VLTK_data\KVCT3_Data\GW_hama.blp` | riêng phái |

## 3. Vô Hình Cổ [F]  (id X002, kind 14)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_sauvohinh.mdx` | `UI\MiniMap\ping4.blp`, `VLTK_data\KVCT3_Data\SauVoHinh.BLP`, `Textures\Green_Glow3.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\NightElf\Immolation\ImmolationDamage.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 4. Bách Độc Xuyên Tâm [R]  (id X003, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **định thân** 25% trong 1.0 giây → model trạng thái `Effect_dinhthan.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_bachdocxuyentam.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Blue_Star.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Weapons\GreenDragonMissile\GreenDragonMissile.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 5. Vạn Cổ Thực Tâm [bị động]  (id X004, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_vancobuff.mdx` | `Textures\Ghost2.blp`, `Textures\Flare.blp` | riêng phái |

## 6. Ngũ Độc Kỳ Kinh [bị động]  (id X005, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_huyetdao.mdx` | `Textures\HeroDemonHunter.blp`, `Textures\Energy1.blp`, `Textures\Green_Glow2.blp`, `Textures\Green_Glow3.blp`, `Textures\Dust3.blp` | riêng phái |

## 7. Huyền Âm Trảm [W]  (id X006, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_huyenamdao.mdx` | `Textures\HeroLich.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\Green_Glow2.blp`, `Textures\GenericGlowX_Mod2.blp` | riêng phái |
| lúc tung (trên tướng) | `Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| trên địch bị trúng | `NDD_huyenamtarget.mdx` | `Textures\Dust3.blp`, `Textures\Green_Glow3.blp`, `Textures\Dust5ABlack.blp`, `ReplaceableTextures\Weather\Clouds8x8.blp`, `Textures\Green_Star.blp`, `Textures\RibbonNE1.blp`, `Textures\ShockwaveWater1Black.blp`, `Textures\DrainIn.blp` | riêng phái |

## 8. Chu Cáp Thanh Minh [D]  (id X007, kind 13)
Nguồn model: **bảng tay**
Trạng thái gây ra: **choáng** 80% trong 2.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_chucapcoc.mdx` | `VLTK_data\KVCT3_Data\GW_hama.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| lớp thêm tại điểm 1 | `NDD_chucapeffect.mdx` | `Textures\White_64_Foam1.blp`, `Textures\Clouds8x8Mod.blp`, `Textures\Shockwave1White.blp`, `Textures\ShockwaveWater1.blp` | riêng phái |
| lớp thêm tại điểm 2 | `Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 9. Hóa Huyết Tiệt Mạch [bị động]  (id X008, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_huyetdao.mdx` | `Textures\HeroDemonHunter.blp`, `Textures\Energy1.blp`, `Textures\Green_Glow2.blp`, `Textures\Green_Glow3.blp`, `Textures\Dust3.blp` | riêng phái |

## 10. Huyết Đỉnh Công [bị động]  (id X009, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_huyetdao.mdx` | `Textures\HeroDemonHunter.blp`, `Textures\Energy1.blp`, `Textures\Green_Glow2.blp`, `Textures\Green_Glow3.blp`, `Textures\Dust3.blp` | riêng phái |

## 11. U Hồn Phệ Ảnh [E]  (id X010, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_uhonpheanh.mdx` | `Textures\Green_Glow3.blp`, `Textures\Green_Glow2.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `NDD_uhonpheanh2.mdx` | `Textures\Flare.blp`, `Textures\Leaf4x4.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave15.blp`, `VLTK_data\KVCT3_Data\EarthSpirit_wave5.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `NDD_uhonpheanhtarget.mdx` | `VLTK_data\KVCT3_Data\flare1_tail.blp`, `VLTK_data\KVCT3_Data\FallingStar02_line.blp`, `VLTK_data\KVCT3_Data\BF_shockwaveFx2c.blp`, `VLTK_data\KVCT3_Data\Shockwave6_Green.blp`, `VLTK_data\KVCT3_Data\Flare2_w.blp`, `Textures\leaf4x4.blp`, `VLTK_data\KVCT3_Data\FlameFx_white_8x8.blp`, `VLTK_data\KVCT3_Data\flame4x4_blur.blp` | riêng phái |
| lúc tung 2 (trên tướng) | `Abilities\Spells\Undead\DeathCoil\DeathCoilSpecialArt.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| lớp thêm tại điểm 1 | `NDD_uhonpheanh3.mdx` | `Textures\HeroLich.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\Green_Glow2.blp`, `Textures\GenericGlowX_Mod2.blp` | riêng phái |
| lớp thêm tại điểm 2 | `NDD_uhoncast.mdx` | `VLTK_data\KVCT3_Data\AZ_BloodDripRed.blp`, `VLTK_data\KVCT3_Data\AZ_BloodRed2X2.blp`, `VLTK_data\KVCT3_Data\AZ_smoke_red_2x2.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave2B.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb16.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon36.blp`, `VLTK_data\KVCT3_Data\AZ_Smoke5.blp` | riêng phái |

## 12. Thiên Thù Vạn Độc [bị động]  (id X011, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_bachdocxuyentam.mdx` | `Textures\RibbonNE1_blue.blp`, `Textures\Blue_Star.blp` | riêng phái |

## 13. U Minh Khô Lâu [T]  (id X012, kind 15)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `NDD_chucapcoc.mdx` | `VLTK_data\KVCT3_Data\GW_hama.blp` | riêng phái |
| trên địch bị trúng | `NDC_uminhkholautarget.mdx` | `VLTK_data\KVCT3_Data\Flare.blp`, `VLTK_data\KVCT3_Data\Dust3.blp`, `Textures\Red_Glow1.blp`, `Textures\Red_Glow2.blp`, `Textures\Red_Glow3.blp`, `VLTK_data\KVCT3_Data\AZ_Fire04_2x8.blp`, `VLTK_data\KVCT3_Data\AZ_Fire04_4x4.blp`, `VLTK_data\KVCT3_Data\7fx_lightraysup_full2.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb9.blp`, `VLTK_data\KVCT3_Data\kulou001.blp` | dùng chung (cùng dùng: NDC) |
