# CBB (H020): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/CBB.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `CBB_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Bổng Đả Ác Cẩu [Q]  (id X273, kind 16)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 30% trong 1.5 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bong.mdx` | `Textures\Blue_Glow2.blp`, `KVCT3_Data\BongDaAcCau.blp` | riêng phái |
| trên địch bị trúng | `CBB_bongtarget.mdx` | `Textures\star32.blp`, `Textures\lensflare1A.blp`, `Textures\Red_Glow3.blp`, `Textures\GenericGlow1.blp`, `Textures\Zap1_Red.blp`, `Textures\Clouds8x8.blp`, `Textures\HeroAvatarFlame.blp` | riêng phái |

## 2. Cái Bang Bổng Pháp [bị động]  (id X274, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bongquynheffect.mdx` | `KVCT3_Data\AutumnGlow.blp`, `Textures\GenericGlow2_64.blp`, `Textures\white.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\dust3.blp`, `KVCT3_Data\AutumnStar.blp`, `KVCT3_Data\SacredTail11Max.blp`, `KVCT3_Data\largesmoke1.blp`, `UI\Glues\SinglePlayer\HumanCampaign3D\HumanCampaignSwordBlade.blp`, `Textures\Ballista.blp`, `UI\MiniMap\ping4.blp`, `Textures\Shockwave1White.blp`, `Textures\star6.blp`, `Textures\rock64.blp`, `Units\Creeps\Kobold\Kobold.blp` | riêng phái |

## 3. Tiêu Dao Công [bị động]  (id X275, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bongtarget.mdx` | `Textures\star32.blp`, `Textures\lensflare1A.blp`, `Textures\Red_Glow3.blp`, `Textures\GenericGlow1.blp`, `Textures\Zap1_Red.blp`, `Textures\Clouds8x8.blp`, `Textures\HeroAvatarFlame.blp` | riêng phái |

## 4. Ác Cẩu Lan Lộ [R]  (id X276, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 50% trong 3.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bong.mdx` | `Textures\Blue_Glow2.blp`, `KVCT3_Data\BongDaAcCau.blp` | riêng phái |
| trên địch bị trúng | `CBB_bongtarget.mdx` | `Textures\star32.blp`, `Textures\lensflare1A.blp`, `Textures\Red_Glow3.blp`, `Textures\GenericGlow1.blp`, `Textures\Zap1_Red.blp`, `Textures\Clouds8x8.blp`, `Textures\HeroAvatarFlame.blp` | riêng phái |

## 5. Túy Điệp Cuồng Vũ [bị động]  (id X277, kind 0)
Nguồn model: **bảng tay**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_firetarget.mdx` | `Textures\GenericGlowX.blp`, `abilities\Spells\NightElf\Blink\Star11d.blp`, `Textures\Shockwave10.blp`, `Textures\Red_Glow2.blp`, `Textures\star32.blp`, `Abilities\Weapons\FlamingArrow\fire10022.blp` | riêng phái |
| aura bị động (gắn tướng suốt) | `CBC_hoatbatluuthu.mdx` | `KVCT3_Data\GenericGlowFadedA.blp`, `KVCT3_Data\AZ_MagicMatrix17_White.blp` | dùng chung (cùng dùng: CBC) |

## 6. Bôn Lưu Đáo Hải [bị động]  (id X278, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_minhsatthuhao.mdx` | `Abilities\Spells\Items\AIda\Rune8.blp`, `Abilities\Spells\Human\InnerFire\Rune7.blp`, `Textures\Rune1d.blp` | riêng phái |

## 7. Thiên Hạ Vô Cẩu [W]  (id X279, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 35% trong 1.5 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bong.mdx` | `Textures\Blue_Glow2.blp`, `KVCT3_Data\BongDaAcCau.blp` | riêng phái |
| lúc tung (trên tướng) | `CBB_thienhavocaucaster.mdx` | `KVCT3_Data\AZ_Knife_light1b.blp`, `KVCT3_Data\AZ_glow1.blp`, `KVCT3_Data\AZ_Splast1Q.blp` | riêng phái |
| trên địch bị trúng | `CBB_firetarget.mdx` | `Textures\GenericGlowX.blp`, `abilities\Spells\NightElf\Blink\Star11d.blp`, `Textures\Shockwave10.blp`, `Textures\Red_Glow2.blp`, `Textures\star32.blp`, `Abilities\Weapons\FlamingArrow\fire10022.blp` | riêng phái |

## 8. Đả Cẩu Bổng Pháp [bị động]  (id X280, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_dacautran.mdx` | `Textures\rune4b.blp`, `Textures\aurarune8.blp` | riêng phái |

## 9. Minh Sát Thu Hào [D]  (id X281, kind 6)
Nguồn model: **bảng tay**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_minhsatthuhao.mdx` | `Abilities\Spells\Items\AIda\Rune8.blp`, `Abilities\Spells\Human\InnerFire\Rune7.blp`, `Textures\Rune1d.blp` | riêng phái |
| lúc tung (trên tướng) (đặt dưới đất (model sàn)) | `CBB_minhsatcast.mdx` | `KVCT3_Data\TX_Smoke2000.blp`, `KVCT3_Data\TX_Star2018.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_smoke.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_star2.blp`, `KVCT3_Data\Hero_EarthShaker_N6_ef_01.blp`, `KVCT3_Data\Hero_EarthShaker_N6_ef_04.blp`, `KVCT3_Data\Hero_EarthShaker_N7_ef_02.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_star4_he.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_star1.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_star3.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_glow1.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_glow2.blp`, `KVCT3_Data\Hero_EarthShaker_N7S_star.blp` | riêng phái |

## 10. Tung Hạc Công [bị động]  (id X282, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_tunghacbuff.mdx` | `KVCT3_Data\Hero_Undying_N2S_F_Grain9.blp`, `KVCT3_Data\Hero_Undying_N2S_Crack.blp`, `KVCT3_Data\Hero_Undying_N2S_Shockwave1.blp`, `KVCT3_Data\Hero_Undying_N2S_Shockwave.blp`, `KVCT3_Data\Hero_Undying_N2S_star2.blp`, `KVCT3_Data\Hero_Undying_N2S_Ribbon4.blp` | riêng phái |
| lúc tung (trên tướng) | `CBB_tunghaccast.mdx` | `KVCT3_Data\Hero_SlithereenGuard_N4S_glow2.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_glow3.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_glow4.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_long1.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_glow.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_chibang.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_chibang1.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_glowshui.blp`, `KVCT3_Data\Hero_SlithereenGuard_N4S_glowshui1.blp` | riêng phái |

## 11. Bổng Quỷnh Lược Địa [E]  (id X283, kind 5)
Nguồn model: **bảng tay**
Trạng thái gây ra: **bỏng (nhận thêm 50% sát thương)** 40% trong 2.0 giây → model trạng thái `Effect_fire2.mdx` (xem TRANG_THAI.md)

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_bong.mdx` | `Textures\Blue_Glow2.blp`, `KVCT3_Data\BongDaAcCau.blp` | riêng phái |
| lúc tung (trên tướng) | `CBB_thienhavocaucaster.mdx` | `KVCT3_Data\AZ_Knife_light1b.blp`, `KVCT3_Data\AZ_glow1.blp`, `KVCT3_Data\AZ_Splast1Q.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CBB_bongquynheffect.mdx` | `KVCT3_Data\AutumnGlow.blp`, `Textures\GenericGlow2_64.blp`, `Textures\white.blp`, `Textures\Shockwave10.blp`, `KVCT3_Data\dust3.blp`, `KVCT3_Data\AutumnStar.blp`, `KVCT3_Data\SacredTail11Max.blp`, `KVCT3_Data\largesmoke1.blp`, `UI\Glues\SinglePlayer\HumanCampaign3D\HumanCampaignSwordBlade.blp`, `Textures\Ballista.blp`, `UI\MiniMap\ping4.blp`, `Textures\Shockwave1White.blp`, `Textures\star6.blp`, `Textures\rock64.blp`, `Units\Creeps\Kobold\Kobold.blp` | riêng phái |
| lớp thêm tại điểm 2 | `CBB_tranphai2.mdx` | `Textures\GenericGlow2_32.blp`, `Textures\Flare.blp`, `Textures\star4.blp`, `TerrainArt\Ashenvale\Ashen_DirtGrass.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp` | riêng phái |

## 12. Đả Cẩu Trận Pháp [bị động]  (id X284, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_dacautran.mdx` | `Textures\rune4b.blp`, `Textures\aurarune8.blp` | riêng phái |
| lớp thêm tại điểm 1 | `CBB_tranphai2.mdx` | `Textures\GenericGlow2_32.blp`, `Textures\Flare.blp`, `Textures\star4.blp`, `TerrainArt\Ashenvale\Ashen_DirtGrass.blp`, `Textures\Shockwave1.blp`, `Textures\Shockwave10.blp`, `Textures\Clouds8x8Fire.blp` | riêng phái |

## 13. Hỗn Thiên Khí Công [bị động]  (id X285, kind 0)
Nguồn model: **bảng tay**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `CBB_thienhavocaucaster.mdx` | `KVCT3_Data\AZ_Knife_light1b.blp`, `KVCT3_Data\AZ_glow1.blp`, `KVCT3_Data\AZ_Splast1Q.blp` | riêng phái |
