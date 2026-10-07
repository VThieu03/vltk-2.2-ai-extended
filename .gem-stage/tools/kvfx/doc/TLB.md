# TLB (H00L): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TLB.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TLB_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Phổ Độ Côn Pháp [Q]  (id X221, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_targeteffect.mdx` | `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Shockwave9.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\Flare.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Shockwave9.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\Flare.blp` | riêng phái |

## 2. Thiếu Lâm Côn Pháp [bị động]  (id X222, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon2.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 3. Dịch Cân Kinh [bị động]  (id X223, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_nhuythuccotcong.mdx` | `Textures\sun.blp`, `Textures\Flare.blp`, `Textures\Red_Glow2.blp`, `KVCT3_Data\AZ_Flash4.blp`, `KVCT3_Data\AZ_Flashb2p.blp`, `KVCT3_Data\AZ_Flashb5.blp`, `KVCT3_Data\jswuqi1.blp`, `KVCT3_Data\AZ_Rune6.blp`, `KVCT3_Data\Xin_E_Effect.blp`, `KVCT3_Data\AZ_Rune3.blp`, `KVCT3_Data\AZ_Rune2.blp`, `Textures\Yellow_Glow3.blp`, `KVCT3_Data\AZ_Shockwave31.blp`, `KVCT3_Data\AZ_Ribbon03.blp` | riêng phái |

## 4. A La Hán Thần Công [bị động]  (id X224, kind 0)
Nguồn model: **bảng KVCT tự sinh**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_targeteffect.mdx` | `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Shockwave9.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\Flare.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `TLD_lahantran.mdx` | `Textures\LavaLump.blp`, `KVCT3_Data\tx208-1.blp`, `KVCT3_Data\tx208-2.blp` | dùng chung (cùng dùng: TLD) |

## 5. Bất Động Minh Vương [D]  (id X225, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_batdongbuff.mdx` | `Textures\Ghost2.blp`, `KVCT3_Data\chongjibo_frost.blp`, `KVCT3_Data\chongjibo2.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_batdongcast.mdx` | `KVCT3_Data\AZ_Shockwave1White.blp`, `KVCT3_Data\EarthSpirit_F3.blp`, `KVCT3_Data\AZ_Shockwave1x.blp`, `KVCT3_Data\Flare2.blp` | riêng phái |

## 6. Như Lai Thiên Diệp [bị động]  (id X226, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `KVCT3_Data\AZ_FlareWhite1.blp`, `KVCT3_Data\AZ_Flashb5.blp`, `KVCT3_Data\AZ_Shockwave17.blp`, `KVCT3_Data\star2x2.blp`, `KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |

## 7. Thất Tinh La Sát Côn [W]  (id X227, kind 4)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon11.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Shockwave9.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\Flare.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLB_lasatcon2.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 8. Túy Tiên Bát Côn [R]  (id X228, kind 18)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon11.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `KVCT3_Data\AZ_Ribbon13.blp`, `KVCT3_Data\AZ_Shockwave9.blp`, `KVCT3_Data\AZ_Shockwave25.blp`, `KVCT3_Data\BlastFlash.blp`, `KVCT3_Data\Flare.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLB_lasatcon2.mdx` | `KVCT3_Data\carck_tp_dust.blp`, `KVCT3_Data\crack_tp.blp`, `KVCT3_Data\chongjibo2.blp`, `KVCT3_Data\flarer1white.blp`, `KVCT3_Data\Knife_light1M.blp`, `KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `KVCT3_Data\flare4x4.blp`, `KVCT3_Data\chongjibo3.blp`, `KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 9. Kim Cang Bất Hoại [bị động]  (id X229, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_kimcangbuff.mdx` | `Textures\Green_Glow3.blp`, `Textures\star4_32.blp`, `Abilities\Spells\Undead\RegenerationAura\DarkSummon.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\Flare.blp`, `Textures\Eyes.blp`, `Textures\clouds_anim1_bw.blp`, `Textures\ToonSmokeX.blp`, `Textures\star5tga.blp` | riêng phái |

## 10. Như Ý Thúc Cốt Công [F]  (id X230, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_nhuythuccotcong.mdx` | `Textures\sun.blp`, `Textures\Flare.blp`, `Textures\Red_Glow2.blp`, `KVCT3_Data\AZ_Flash4.blp`, `KVCT3_Data\AZ_Flashb2p.blp`, `KVCT3_Data\AZ_Flashb5.blp`, `KVCT3_Data\jswuqi1.blp`, `KVCT3_Data\AZ_Rune6.blp`, `KVCT3_Data\Xin_E_Effect.blp`, `KVCT3_Data\AZ_Rune3.blp`, `KVCT3_Data\AZ_Rune2.blp`, `Textures\Yellow_Glow3.blp`, `KVCT3_Data\AZ_Shockwave31.blp`, `KVCT3_Data\AZ_Ribbon03.blp` | riêng phái |

## 11. Vi Đà Hiến Chử [E]  (id X231, kind 4)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `KVCT3_Data\AZ_FlareWhite1.blp`, `KVCT3_Data\AZ_Flashb5.blp`, `KVCT3_Data\AZ_Shockwave17.blp`, `KVCT3_Data\star2x2.blp`, `KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_vidacast.mdx` | `KVCT3_Data\animeslash.blp`, `KVCT3_Data\animeslashp.blp`, `Textures\GenericGlow1.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TLB_vidatarget.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp`, `KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP`, `KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP` | riêng phái |

## 12. Ma Kha Vô Lượng [bị động]  (id X232, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_tuytienbatcon.mdx` | `Textures\Shockwave10.blp`, `KVCT3_Data\AZ_Knife_light1M.blp`, `Textures\RibbonNE1_blue.blp`, `KVCT3_Data\AZ_Shockwave1U.blp`, `KVCT3_Data\AZ_Splast2x2.blp`, `Textures\Flare.blp` | riêng phái |

## 13. Tẩy Tủy Kinh [bị động]  (id X233, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `KVCT3_Data\AZ_Shockwave21.blp`, `KVCT3_Data\AZ_FlareWhite1.blp`, `KVCT3_Data\AZ_Flashb5.blp`, `KVCT3_Data\AZ_Shockwave17.blp`, `KVCT3_Data\star2x2.blp`, `KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |
