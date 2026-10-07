# VDQ: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/VDQ.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Bác Cập Nhị Phục': {'main': 'VDQ_baccapnhiphuc.mdx', 'cast': 'VDQ_caster2.mdx'},   # [Q]
    'Võ Đang Khí Công': {'main': 'VDQ_batquaidulong.mdx'},   # [bị động]
    'Tọa Vọng Vô Ngã': {'main': 'MDX\\ToaVongVoNga.mdx', 'area': ['VDQ_vongakiem.mdx']},   # [D]
    'Chân Vũ Thất Tiệt': {'main': 'VDQ_chanvutt.mdx'},   # [bị động]
    'Thuần Dương Vô Cực': {'main': 'VDQ_thuanduongvocuc.mdx'},   # [F]
    'Thái Cực Vô Ý': {'main': 'VDQ_thaicuc.mdx'},   # [bị động]
    'Thiên Địa Vô Cực': {'main': 'VDQ_thaicuc.mdx', 'cast': 'VDQ_thiendiacaster.mdx', 'target': 'VDQ_thiendiatarget.mdx', 'area': ['VDQ_thiendia.mdx'], 'cast_ground': True},   # [W]
    'Vạn Kiếm Quy Tông': {'main': 'VDQ_vongakiem.mdx', 'cast': 'VDQ_caster2.mdx', 'target': 'VDQ_thiendiatarget.mdx'},   # [R]
    'Võ Đang Cửu Dương': {'main': 'VDQ_thuanduongvocuc.mdx'},   # [bị động]
    'Bát Quái Du Long': {'main': 'MDX\\BatQuaiDuLong.mdx'},   # [bị động]
    'Cửu Cung Bát Quái': {'main': 'VDQ_cuucung1.mdx', 'cast': 'VDQ_thiendiacaster.mdx', 'area': ['VDQ_cuucung2.mdx', 'VDQ_thaicuc.mdx'], 'cast_ground': True},   # [E]
    'Thái Cực Thần Công': {'main': 'MDX\\ThaiCucThanCong.mdx'},   # [bị động]
    'Lưỡng Nghi Tâm Pháp': {'main': 'VDQ_batquaidulong.mdx'},   # [bị động]
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
# 1. Bác Cập Nhị Phục [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_baccapnhiphuc.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\Flare.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: KVCT3_Data\YinYang_a.blp
#    lúc tung (trên tướng): VDQ_caster2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star6.blp
#         texture: Textures\CartoonCloud.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\firering1A.blp
#
# 2. Võ Đang Khí Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_batquaidulong.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#         texture: KVCT3_Data\BatQuai.blp
#         texture: KVCT3_Data\ThaiCuc.blp
#
# 3. Tọa Vọng Vô Ngã [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ToaVongVoNga.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: VDK)]
#         texture: Textures\GenericGlow64.blp
#         texture: YinYang_a.blp
#    lớp thêm tại điểm 1: VDQ_vongakiem.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#         texture: KVCT3_Data\Dust3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\RockParticle.blp
#         texture: Textures\Dust5A.blp
#         texture: KVCT3_Data\Layers1.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Blue_Star.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave1White.blp
#
# 4. Chân Vũ Thất Tiệt [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_chanvutt.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: KVCT3_Data\AZ_FlareLightning.blp
#         texture: KVCT3_Data\AZ_Lightning2x2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_FlareLightning_white.blp
#
# 5. Thuần Dương Vô Cực [F]   (kind 9, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thuanduongvocuc.mdx   [riêng phái]
#         texture: Textures\Star8.blp
#         texture: KVCT3_Data\Rune1d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Units\Human\Phoenix\Demon_Rune_RibbonB.blp
#
# 6. Thái Cực Vô Ý [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 7. Thiên Địa Vô Cực [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: KVCT3_Data\YinYang_a.blp
#    lúc tung (trên tướng): VDQ_thiendiacaster.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#         texture: KVCT3_Data\YinYang_a.blp
#    trên địch bị trúng: VDQ_thiendiatarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: KVCT3_Data\YinYang_a.blp
#    lớp thêm tại điểm 1: VDQ_thiendia.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 8. Vạn Kiếm Quy Tông [R]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_vongakiem.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#         texture: KVCT3_Data\Dust3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\RockParticle.blp
#         texture: Textures\Dust5A.blp
#         texture: KVCT3_Data\Layers1.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Blue_Star.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave1White.blp
#    lúc tung (trên tướng): VDQ_caster2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star6.blp
#         texture: Textures\CartoonCloud.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\firering1A.blp
#    trên địch bị trúng: VDQ_thiendiatarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 9. Võ Đang Cửu Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thuanduongvocuc.mdx   [riêng phái]
#         texture: Textures\Star8.blp
#         texture: KVCT3_Data\Rune1d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Units\Human\Phoenix\Demon_Rune_RibbonB.blp
#
# 10. Bát Quái Du Long [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\BatQuaiDuLong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#         texture: BatQuai.blp
#         texture: ThaiCuc.blp
#
# 11. Cửu Cung Bát Quái [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_cuucung1.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\GenericGlow64.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\BatQuai.blp
#         texture: KVCT3_Data\ThaiCuc.blp
#    lúc tung (trên tướng): VDQ_thiendiacaster.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#         texture: KVCT3_Data\YinYang_a.blp
#    lớp thêm tại điểm 1: VDQ_cuucung2.mdx   [riêng phái]
#         texture: KVCT3_Data\gumujianzhen.blp
#    lớp thêm tại điểm 2: VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 12. Thái Cực Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThaiCucThanCong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: Bakua_b.blp
#         texture: YinYang_a.blp
#
# 13. Lưỡng Nghi Tâm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_batquaidulong.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#         texture: KVCT3_Data\BatQuai.blp
#         texture: KVCT3_Data\ThaiCuc.blp
# ===== HẾT DANH MỤC =====
