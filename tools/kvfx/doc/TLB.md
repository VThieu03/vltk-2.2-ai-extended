# TLB (H00L): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TLB.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/VLTK_data/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TLB_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Phổ Độ Côn Pháp [Q]  (id X221, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_targeteffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Ribbon13.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave9.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave25.blp`, `VLTK_data\KVCT3_Data\BlastFlash.blp`, `VLTK_data\KVCT3_Data\Flare.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Ribbon13.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave9.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave25.blp`, `VLTK_data\KVCT3_Data\BlastFlash.blp`, `VLTK_data\KVCT3_Data\Flare.blp` | riêng phái |

## 2. Thiếu Lâm Côn Pháp [bị động]  (id X222, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon2.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 3. Dịch Cân Kinh [bị động]  (id X223, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_nhuythuccotcong.mdx` | `Textures\sun.blp`, `Textures\Flare.blp`, `Textures\Red_Glow2.blp`, `VLTK_data\KVCT3_Data\AZ_Flash4.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb2p.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\jswuqi1.blp`, `VLTK_data\KVCT3_Data\AZ_Rune6.blp`, `VLTK_data\KVCT3_Data\Xin_E_Effect.blp`, `VLTK_data\KVCT3_Data\AZ_Rune3.blp`, `VLTK_data\KVCT3_Data\AZ_Rune2.blp`, `Textures\Yellow_Glow3.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave31.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon03.blp` | riêng phái |

## 4. A La Hán Thần Công [bị động]  (id X224, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_targeteffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Ribbon13.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave9.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave25.blp`, `VLTK_data\KVCT3_Data\BlastFlash.blp`, `VLTK_data\KVCT3_Data\Flare.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `TLD_lahantran.mdx` | `Textures\LavaLump.blp`, `VLTK_data\KVCT3_Data\tx208-1.blp`, `VLTK_data\KVCT3_Data\tx208-2.blp` | dùng chung (cùng dùng: TLD) |

## 5. Bất Động Minh Vương [D]  (id X225, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_batdongbuff.mdx` | `Textures\Ghost2.blp`, `VLTK_data\KVCT3_Data\chongjibo_frost.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_batdongcast.mdx` | `VLTK_data\KVCT3_Data\AZ_Shockwave1White.blp`, `VLTK_data\KVCT3_Data\EarthSpirit_F3.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave1x.blp`, `VLTK_data\KVCT3_Data\Flare2.blp` | riêng phái |
| trên địch bị trúng | `Abilities\Spells\Human\DivineShield\DivineShieldTarget.mdl` | model gốc Warcraft III | model gốc Warcraft III |
| buff (trên tướng) | `Effect_fire2.mdx` | `Textures\WaterBlobs1.blp`, `Textures\White_64_Foam1.blp`, `Textures\Lords0000.blp`, `Textures\Lords0001.blp`, `Textures\Lords0002.blp`, `Textures\Lords0003.blp`, `Textures\Lords0004.blp`, `Textures\Lords0005.blp`, `Textures\Lords0006.blp`, `Textures\Lords0007.blp`, `Textures\Water_Particles.blp`, `Textures\ShockwaveWater1.blp`, `Textures\LavaLump2.blp` | dùng chung (cùng dùng: NMC) |

## 6. Như Lai Thiên Diệp [bị động]  (id X226, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave21.blp`, `VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave17.blp`, `VLTK_data\KVCT3_Data\star2x2.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |

## 7. Thất Tinh La Sát Côn [W]  (id X227, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon11.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_lasatcon11.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Ribbon13.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave9.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave25.blp`, `VLTK_data\KVCT3_Data\BlastFlash.blp`, `VLTK_data\KVCT3_Data\Flare.blp` | riêng phái |
| lúc tung 2 (trên tướng) | `TLB_lasatcon2.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLB_lasatcon2.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |

## 8. Túy Tiên Bát Côn [R]  (id X228, kind 18)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_lasatcon11.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_lasatcon11.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| trên địch bị trúng | `TLB_targeteffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Ribbon13.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave9.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave25.blp`, `VLTK_data\KVCT3_Data\BlastFlash.blp`, `VLTK_data\KVCT3_Data\Flare.blp` | riêng phái |
| lúc tung 2 (trên tướng) | `TLB_lasatcon2.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLB_lasatcon2.mdx` | `VLTK_data\KVCT3_Data\carck_tp_dust.blp`, `VLTK_data\KVCT3_Data\crack_tp.blp`, `VLTK_data\KVCT3_Data\chongjibo2.blp`, `VLTK_data\KVCT3_Data\flarer1white.blp`, `VLTK_data\KVCT3_Data\Knife_light1M.blp`, `VLTK_data\KVCT3_Data\Knife_light2F.blp`, `Textures\Flare.blp`, `VLTK_data\KVCT3_Data\flare4x4.blp`, `VLTK_data\KVCT3_Data\chongjibo3.blp`, `VLTK_data\KVCT3_Data\crack3.blp`, `Textures\rock64.blp`, `Textures\Rock01_04.blp`, `Textures\white.blp`, `VLTK_data\KVCT3_Data\rock.blp`, `Textures\RibbonNE1_White.blp` | riêng phái |
| lớp thêm tại điểm 2 | `Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 9. Kim Cang Bất Hoại [bị động]  (id X229, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_kimcangbuff.mdx` | `Textures\Green_Glow3.blp`, `Textures\star4_32.blp`, `Abilities\Spells\Undead\RegenerationAura\DarkSummon.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `VLTK_data\KVCT3_Data\Flare.blp`, `Textures\Eyes.blp`, `Textures\clouds_anim1_bw.blp`, `Textures\ToonSmokeX.blp`, `Textures\star5tga.blp` | riêng phái |

## 10. Như Ý Thúc Cốt Công [F]  (id X230, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_nhuythuccotcong.mdx` | `Textures\sun.blp`, `Textures\Flare.blp`, `Textures\Red_Glow2.blp`, `VLTK_data\KVCT3_Data\AZ_Flash4.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb2p.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\jswuqi1.blp`, `VLTK_data\KVCT3_Data\AZ_Rune6.blp`, `VLTK_data\KVCT3_Data\Xin_E_Effect.blp`, `VLTK_data\KVCT3_Data\AZ_Rune3.blp`, `VLTK_data\KVCT3_Data\AZ_Rune2.blp`, `Textures\Yellow_Glow3.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave31.blp`, `VLTK_data\KVCT3_Data\AZ_Ribbon03.blp` | riêng phái |

## 11. Vi Đà Hiến Chử [E]  (id X231, kind 4)
Nguồn model: **bảng tay**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave21.blp`, `VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave17.blp`, `VLTK_data\KVCT3_Data\star2x2.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `TLB_vidacast.mdx` | `VLTK_data\KVCT3_Data\animeslash.blp`, `VLTK_data\KVCT3_Data\animeslashp.blp`, `Textures\GenericGlow1.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TLB_vidatarget.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP` | riêng phái |
| lớp thêm tại điểm 1 | `TLB_vidatarget.mdx` | `Textures\LightningBall.blp`, `Textures\Zap1_Red.blp`, `Textures\grad2d.blp`, `Textures\Clouds8x8Fade.blp`, `Textures\rock64.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP`, `VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP` | riêng phái |
| lớp thêm tại điểm 2 | `TLB_vidaeffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave21.blp`, `VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave17.blp`, `VLTK_data\KVCT3_Data\star2x2.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |

## 12. Ma Kha Vô Lượng [bị động]  (id X232, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_tuytienbatcon.mdx` | `Textures\Shockwave10.blp`, `VLTK_data\KVCT3_Data\AZ_Knife_light1M.blp`, `Textures\RibbonNE1_blue.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave1U.blp`, `VLTK_data\KVCT3_Data\AZ_Splast2x2.blp`, `Textures\Flare.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `Abilities\Spells\NightElf\FaerieDragonInvis\FaerieDragon_Invis.mdl` | model gốc Warcraft III | model gốc Warcraft III |

## 13. Tẩy Tủy Kinh [bị động]  (id X233, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLB_vidaeffect.mdx` | `VLTK_data\KVCT3_Data\AZ_Firering1A.blp`, `Textures\star5tga.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave21.blp`, `VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb5.blp`, `VLTK_data\KVCT3_Data\AZ_Shockwave17.blp`, `VLTK_data\KVCT3_Data\star2x2.blp`, `VLTK_data\KVCT3_Data\AZ_Flashb3.blp`, `Textures\Flare.blp` | riêng phái |
