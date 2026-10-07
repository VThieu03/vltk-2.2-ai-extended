# CBB: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Bổng Đả Ác Cẩu': {'main': 'CBB_bong.mdx', 'target': 'CBB_bongtarget.mdx'},   # [Q]
    'Cái Bang Bổng Pháp': {'main': 'CBB_bongquynheffect.mdx'},   # [bị động]
    'Tiêu Dao Công': {'main': 'CBB_bongtarget.mdx'},   # [bị động]
    'Ác Cẩu Lan Lộ': {'main': 'CBB_bong.mdx', 'target': 'CBB_bongtarget.mdx'},   # [R]
    'Túy Điệp Cuồng Vũ': {'main': 'CBB_firetarget.mdx', 'aura': 'CBC_hoatbatluuthu.mdx'},   # [bị động]
    'Bôn Lưu Đáo Hải': {'main': 'CBB_minhsatthuhao.mdx'},   # [bị động]
    'Thiên Hạ Vô Cẩu': {'main': 'CBB_bong.mdx', 'cast': 'CBB_thienhavocaucaster.mdx', 'target': 'CBB_firetarget.mdx'},   # [W]
    'Đả Cẩu Bổng Pháp': {'main': 'CBB_dacautran.mdx'},   # [bị động]
    'Minh Sát Thu Hào': {'main': 'CBB_minhsatthuhao.mdx', 'cast': 'CBB_minhsatcast.mdx', 'cast_ground': True},   # [D]
    'Tung Hạc Công': {'main': 'CBB_tunghacbuff.mdx', 'cast': 'CBB_tunghaccast.mdx'},   # [bị động]
    'Bổng Quỷnh Lược Địa': {'main': 'CBB_bong.mdx', 'cast': 'CBB_thienhavocaucaster.mdx', 'area': ['CBB_bongquynheffect.mdx', 'CBB_tranphai2.mdx']},   # [E]
    'Đả Cẩu Trận Pháp': {'main': 'CBB_dacautran.mdx', 'area': ['CBB_tranphai2.mdx']},   # [bị động]
    'Hỗn Thiên Khí Công': {'main': 'CBB_thienhavocaucaster.mdx'},   # [bị động]
}

# Đổi texture của model (xem danh mục bên dưới).
TEXTURES = {
}

# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) =====
# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:
#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}
#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\Flame4.blp"}
#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)
# Sửa xong chạy lại pipeline (scratchpad/run_pipeline.py) để áp dụng.
#
# 1. Bổng Đả Ác Cẩu [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bong.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\BongDaAcCau.blp
#    trên địch bị trúng: CBB_bongtarget.mdx   [riêng phái]
#         texture: Textures\star32.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\HeroAvatarFlame.blp
#
# 2. Cái Bang Bổng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bongquynheffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AutumnGlow.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\white.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\dust3.blp
#         texture: KVCT3_Data\AutumnStar.blp
#         texture: KVCT3_Data\SacredTail11Max.blp
#         texture: KVCT3_Data\largesmoke1.blp
#         texture: UI\Glues\SinglePlayer\HumanCampaign3D\HumanCampaignSwordBlade.blp
#         texture: Textures\Ballista.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\star6.blp
#         texture: Textures\rock64.blp
#         texture: Units\Creeps\Kobold\Kobold.blp
#
# 3. Tiêu Dao Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bongtarget.mdx   [riêng phái]
#         texture: Textures\star32.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\HeroAvatarFlame.blp
#
# 4. Ác Cẩu Lan Lộ [R]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bong.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\BongDaAcCau.blp
#    trên địch bị trúng: CBB_bongtarget.mdx   [riêng phái]
#         texture: Textures\star32.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\HeroAvatarFlame.blp
#
# 5. Túy Điệp Cuồng Vũ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_firetarget.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: abilities\Spells\NightElf\Blink\Star11d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\star32.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#    aura bị động (gắn tướng suốt): CBC_hoatbatluuthu.mdx   [dùng chung (cùng dùng: CBC)]
#         texture: KVCT3_Data\GenericGlowFadedA.blp
#         texture: KVCT3_Data\AZ_MagicMatrix17_White.blp
#
# 6. Bôn Lưu Đáo Hải [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_minhsatthuhao.mdx   [riêng phái]
#         texture: Abilities\Spells\Items\AIda\Rune8.blp
#         texture: Abilities\Spells\Human\InnerFire\Rune7.blp
#         texture: Textures\Rune1d.blp
#
# 7. Thiên Hạ Vô Cẩu [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bong.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\BongDaAcCau.blp
#    lúc tung (trên tướng): CBB_thienhavocaucaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light1b.blp
#         texture: KVCT3_Data\AZ_glow1.blp
#         texture: KVCT3_Data\AZ_Splast1Q.blp
#    trên địch bị trúng: CBB_firetarget.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: abilities\Spells\NightElf\Blink\Star11d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\star32.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#
# 8. Đả Cẩu Bổng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_dacautran.mdx   [riêng phái]
#         texture: Textures\rune4b.blp
#         texture: Textures\aurarune8.blp
#
# 9. Minh Sát Thu Hào [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_minhsatthuhao.mdx   [riêng phái]
#         texture: Abilities\Spells\Items\AIda\Rune8.blp
#         texture: Abilities\Spells\Human\InnerFire\Rune7.blp
#         texture: Textures\Rune1d.blp
#    lúc tung (trên tướng): CBB_minhsatcast.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Smoke2000.blp
#         texture: KVCT3_Data\TX_Star2018.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_smoke.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_star2.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N6_ef_01.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N6_ef_04.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7_ef_02.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_star4_he.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_star1.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_star3.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_glow1.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_glow2.blp
#         texture: KVCT3_Data\Hero_EarthShaker_N7S_star.blp
#
# 10. Tung Hạc Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_tunghacbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N2S_F_Grain9.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Crack.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Shockwave1.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Shockwave.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_star2.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Ribbon4.blp
#    lúc tung (trên tướng): CBB_tunghaccast.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glow2.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glow3.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glow4.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_long1.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glow.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_chibang.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_chibang1.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glowshui.blp
#         texture: KVCT3_Data\Hero_SlithereenGuard_N4S_glowshui1.blp
#
# 11. Bổng Quỷnh Lược Địa [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_bong.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\BongDaAcCau.blp
#    lúc tung (trên tướng): CBB_thienhavocaucaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light1b.blp
#         texture: KVCT3_Data\AZ_glow1.blp
#         texture: KVCT3_Data\AZ_Splast1Q.blp
#    lớp thêm tại điểm 1: CBB_bongquynheffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AutumnGlow.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\white.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\dust3.blp
#         texture: KVCT3_Data\AutumnStar.blp
#         texture: KVCT3_Data\SacredTail11Max.blp
#         texture: KVCT3_Data\largesmoke1.blp
#         texture: UI\Glues\SinglePlayer\HumanCampaign3D\HumanCampaignSwordBlade.blp
#         texture: Textures\Ballista.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\star6.blp
#         texture: Textures\rock64.blp
#         texture: Units\Creeps\Kobold\Kobold.blp
#    lớp thêm tại điểm 2: CBB_tranphai2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star4.blp
#         texture: TerrainArt\Ashenvale\Ashen_DirtGrass.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#
# 12. Đả Cẩu Trận Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_dacautran.mdx   [riêng phái]
#         texture: Textures\rune4b.blp
#         texture: Textures\aurarune8.blp
#    lớp thêm tại điểm 1: CBB_tranphai2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star4.blp
#         texture: TerrainArt\Ashenvale\Ashen_DirtGrass.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#
# 13. Hỗn Thiên Khí Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBB_thienhavocaucaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light1b.blp
#         texture: KVCT3_Data\AZ_glow1.blp
#         texture: KVCT3_Data\AZ_Splast1Q.blp
# ===== HẾT DANH MỤC =====
