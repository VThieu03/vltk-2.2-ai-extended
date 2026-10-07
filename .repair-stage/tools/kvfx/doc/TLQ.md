# TLQ (H00Z): model và texture của từng chiêu

Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/TLQ.py`
(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.
Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa
texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `TLQ_`; **dùng chung** = model của phái khác,
hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.

## 1. Long Trảo Hổ Trảo [Q]  (id X065, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 30% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_longtraohotrao.mdx` | `Textures\GenericGlow2c.blp`, `Textures\GenericGlowX_Mod2.blp`, `Textures\Flare.blp`, `KVCT3_Data\Palm.BLP`, `Textures\Flame4.blp`, `Textures\lensflare1A.blp`, `Textures\lensflare1Ax.blp`, `Textures\LavaLump2.blp` | riêng phái |
| trên địch bị trúng | `TLQ_targeteffect.mdx` | `Textures\GenericGlowX.blp`, `abilities\Spells\NightElf\Blink\Star11d.blp`, `Textures\Blue_Glow2.blp`, `Textures\star32.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |

## 2. Thiếu Lâm Quyền Pháp [bị động]  (id X066, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_kimcangchuongeffect2.mdx` | `UI\MiniMap\ping4.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |

## 3. Dịch Cân Kinh [bị động]  (id X067, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_kimcuongchuongefffect3.mdx` | `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `UI\MiniMap\ping4.blp`, `Textures\AuraRune7Green.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowFaded.blp`, `Textures\star4.blp`, `Textures\White_64_Foam1.blp`, `KVCT3_Data\AZ_Rune3-1.blp`, `KVCT3_Data\AZ_Smoke_yello2x2.blp`, `KVCT3_Data\AZ_Lightning27.blp`, `Textures\Flare.blp` | riêng phái |

## 4. Sư Tử Hống [R]  (id X068, kind 4)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 36% trong 3.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_sutuhong.mdx` | `KVCT3_Data\Hero_EarthShaker_N3S_A_source_01.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_02.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_05.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_04.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_07.blp`, `KVCT3_Data\TX_Star2000.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_08.blp`, `KVCT3_Data\Hero_EarthShaker_N3S_A_source_09.blp` | riêng phái |
| trên địch bị trúng | `TLQ_targeteffect.mdx` | `Textures\GenericGlowX.blp`, `abilities\Spells\NightElf\Blink\Star11d.blp`, `Textures\Blue_Glow2.blp`, `Textures\star32.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| buff (trên tướng) | `TLQ_sutuhongbuff.mdx` | `Textures\pixies1.blp`, `Textures\GenericGlowX.blp`, `Textures\Clouds8x8Mod.blp`, `Doodads\Cinematic\IcecrownObelisk\Glow_Runes.blp` | riêng phái |
| lớp thêm tại điểm 1 | `HydraliskImpact.mdx` | `Textures\Dust3.blp`, `Textures\BloodSplutWhite.blp` | dùng chung (cùng dùng: DMTT, TVT) |

## 5. Bồ Đề Tâm Pháp [D]  (id X069, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_kimcuongeff2.mdx` | `KVCT3_Data\Hero_STormSpirit_N2S_Flare.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White3.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_LightningBall.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Crack.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White11.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_lightning24x4.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_2lightning.blp` | riêng phái |

## 6. Như Lai Thiên Diệp [bị động]  (id X070, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_nhulai.mdx` | `Textures\star5tga.blp`, `KVCT3_Data\YuNie1.blp`, `KVCT3_Data\YuNie2.blp` | riêng phái |

## 7. Kim Cương Phục Ma [W]  (id X071, kind 16)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 35% trong 0.5 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_kimcuongphucma.mdx` | `Textures\lensflare1A.blp`, `Textures\Zap1.blp`, `Textures\Blue_Star2.blp`, `KVCT3_Data\Buddha.blp`, `KVCT3_Data\PhatQuangChienKhi.blp`, `Textures\GenericGlow64.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TLQ_kimcuongtarget.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\WaterBlobs1.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\Shockwave10.blp`, `Textures\star2_32.blp`, `Textures\snowflake.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLQ_kimcuongeff2.mdx` | `KVCT3_Data\Hero_STormSpirit_N2S_Flare.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White3.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_LightningBall.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Crack.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White11.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_lightning24x4.blp`, `KVCT3_Data\Hero_STormSpirit_N2S_2lightning.blp` | riêng phái |

## 8. La Hán Kim Thân [F]  (id X072, kind 6)
Nguồn model: **chọn theo tên / tk_mapping**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_lahanbuff.mdx` | `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `UI\MiniMap\ping4.blp`, `Textures\AuraRune7Green.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowFaded.blp`, `Textures\star4.blp`, `Textures\White_64_Foam1.blp`, `KVCT3_Data\AZ_Rune3-1.blp`, `KVCT3_Data\AZ_Smoke_yello2x2.blp`, `KVCT3_Data\AZ_Lightning27.blp`, `Textures\Flare.blp` | riêng phái |
| lúc tung (trên tướng) | `TLQ_lahankimthancast.mdx` | `Textures\Star8.blp`, `Textures\Star7b.blp`, `Textures\firering1A.blp`, `Textures\Yellow_Glow.blp`, `Textures\DemonRune5.blp`, `KVCT3_Data\Buddha.blp` | riêng phái |
| buff (trên tướng) | `TLQ_lahanbuff2.mdx` | `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `UI\MiniMap\ping4.blp`, `Textures\AuraRune7Green.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowFaded.blp`, `Textures\star4.blp`, `Textures\White_64_Foam1.blp`, `KVCT3_Data\AZ_Rune3-1.blp`, `KVCT3_Data\AZ_Smoke_yello2x2.blp`, `KVCT3_Data\AZ_Lightning27.blp`, `Textures\Flare.blp` | riêng phái |

## 9. Đạt Ma Võ Kinh [bị động]  (id X073, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_nhulai.mdx` | `Textures\star5tga.blp`, `KVCT3_Data\YuNie1.blp`, `KVCT3_Data\YuNie2.blp` | riêng phái |

## 10. Hỗn Nguyên Nhất Khí [bị động]  (id X074, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `MDX\HonNguyenNhatKhi.mdx` | `Textures\Shockwave1.blp`, `Textures\GenericGlow5.blp`, `Ping.blp` | dùng chung (model Thiên Kiếm) |

## 11. Đại Lực Kim Cang Chưởng [E]  (id X075, kind 5)
Nguồn model: **bảng KVCT tự sinh**
Trạng thái gây ra: **thọ thương (câm lặng)** 40% trong 1.0 giây

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_votuongeffect.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\star2_32.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `UI\MiniMap\ping4.blp`, `KVCT3_Data\PalmShaoLin.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| trên địch bị trúng (đặt dưới đất (model sàn)) | `TLQ_targeteffect.mdx` | `Textures\GenericGlowX.blp`, `abilities\Spells\NightElf\Blink\Star11d.blp`, `Textures\Blue_Glow2.blp`, `Textures\star32.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |
| lớp thêm tại điểm 1 | `TLQ_kimcangchuongeffect1.mdx` | `KVCT3_Data\rlz.blp` | riêng phái |
| lớp thêm tại điểm 2 | `TLQ_kimcuongchuongefffect3.mdx` | `Textures\ShockwaveWater1.blp`, `Textures\Shockwave10.blp`, `UI\MiniMap\ping4.blp`, `Textures\AuraRune7Green.blp`, `Textures\GenericGlow5.blp`, `Textures\GenericGlowFaded.blp`, `Textures\star4.blp`, `Textures\White_64_Foam1.blp`, `KVCT3_Data\AZ_Rune3-1.blp`, `KVCT3_Data\AZ_Smoke_yello2x2.blp`, `KVCT3_Data\AZ_Lightning27.blp`, `Textures\Flare.blp` | riêng phái |

## 12. Vô Tướng Thần Công [bị động]  (id X076, kind 0)
Nguồn model: **chọn theo tên / tk_mapping**

*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_votuongeffect.mdx` | `Textures\HeroGoblinAlchemistBLUE.blp`, `Textures\Dust3x.blp`, `Textures\BloodWhiteSmall.blp`, `Textures\star2_32.blp`, `UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp`, `UI\MiniMap\ping4.blp`, `KVCT3_Data\PalmShaoLin.blp`, `KVCT3_Data\BuddhistRoar.blp` | riêng phái |

## 13. Thiên Thủ Như Lai Ấn [T]  (id X077, kind 8)
Nguồn model: **bảng KVCT tự sinh**
Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.

| Vai trò | Model | Texture | Loại |
|---|---|---|---|
| chính (đạn bay / vùng / hiệu ứng) | `TLQ_nhulai.mdx` | `Textures\star5tga.blp`, `KVCT3_Data\YuNie1.blp`, `KVCT3_Data\YuNie2.blp` | riêng phái |
