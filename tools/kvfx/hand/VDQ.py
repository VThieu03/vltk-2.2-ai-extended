# VDQ: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
# Bằng chứng đọc từ code gốc KVCT (D:/kvct-dev/work/readable.j):
#   VDQ_baccapnhiphuc  <- J4l (dòng 83281, Q: nổ tại vị trí mục tiêu)
#   VDQ_thiendia       <- JCO (91326, W: nổ tại điểm theo nhịp)
#   VDQ_thiendiatarget <- JCO (91335, W: trên địch trúng), J9D (77342, R: gắn "origin" địch trúng)
#   VDQ_thaicuc        <- JCU (91364, W: vùng tại điểm, scale 1.5), JDG (85886, E: vùng tại điểm)
#   VDQ_thiendiacaster <- JCU (91365, W: vùng tại điểm, scale 1.5), JDm (85822, E: trên địch trúng)
#   VDQ_vongakiem      <- J9D (77341, R: trên địch trúng), JDm (85812, E: tại điểm theo nhịp)
#   VDQ_cuucung1 / VDQ_cuucung2 <- JDG (85875-85883, E: vùng tại điểm)
#   (SpiritOfVengeanceMissile gắn "weapon" tướng ở Q/W/E là model gốc WC3, không có trong kho KVCT nên không ghi;
#    VDQ_caster2 KHÔNG được readable.j dùng ở đâu nên đã bỏ khỏi Q và R)
VFX = {
    "Bác Cập Nhị Phục": {   # [Q] — KVCT: đã đối chiếu
        "main": "VDQ_baccapnhiphuc.mdx",
    },
    "Võ Đang Khí Công": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDQ_batquaidulong.mdx",
    },
    "Tọa Vọng Vô Ngã": {   # [D] KVCT không có hiệu ứng trong script
        "main": "MDX\\ToaVongVoNga.mdx",
        "cast": "VDK_vongacast.mdx",
        "area": ["VDQ_vongakiem.mdx"],
    },
    "Chân Vũ Thất Tiệt": {   # [bị động] KVCT không có hiệu ứng trong script
        "aura": "VDQ_chanvutt.mdx",
    },
    "Thuần Dương Vô Cực": {   # [F] KVCT không có hiệu ứng trong script
        "main": "VDQ_thuanduongvocuc.mdx",
        "cast": "VDQ_caster2.mdx",
    },
    "Thái Cực Vô Ý": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDQ_thaicuc.mdx",
    },
    "Thiên Địa Vô Cực": {   # [W] — KVCT: đã đối chiếu
        "main": {"file": "VDQ_thaicuc.mdx", "scale": 1.5},
        "target": {"file": "VDQ_thiendiatarget.mdx", "ground": True},
        "area": ["VDQ_thiendia.mdx", "VDQ_thiendiacaster.mdx"],
    },
    "Vạn Kiếm Quy Tông": {   # [R] — KVCT: đã đối chiếu
        "main": "VDQ_vongakiem.mdx",
        "target": "VDQ_thiendiatarget.mdx",
    },
    "Võ Đang Cửu Dương": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDQ_thuanduongvocuc.mdx",
    },
    "Bát Quái Du Long": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "MDX\\BatQuaiDuLong.mdx",
    },
    "Cửu Cung Bát Quái": {   # [E] — KVCT: đã đối chiếu (VDQ_vongakiem nổ tại điểm theo nhịp: area đã đủ 2 lớp nên không ghi)
        "main": "VDQ_cuucung1.mdx",
        "target": {"file": "VDQ_thiendiacaster.mdx", "ground": True},
        "area": ["VDQ_cuucung2.mdx", "VDQ_thaicuc.mdx"],
    },
    "Thái Cực Thần Công": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "MDX\\ThaiCucThanCong.mdx",
    },
    "Lưỡng Nghi Tâm Pháp": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDQ_batquaidulong.mdx",
    },
}

# Đổi texture của model (xem danh mục bên dưới).
TEXTURES = {
}

# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) =====
# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:
#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}
#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\Flame4.blp"}
#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)
# Sửa xong chạy lại pipeline (tools/pipeline.py) để áp dụng.
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
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
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
#         texture: VLTK_data\KVCT3_Data\BatQuai.blp
#         texture: VLTK_data\KVCT3_Data\ThaiCuc.blp
#
# 3. Tọa Vọng Vô Ngã [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ToaVongVoNga.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: VDK)]
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\Loose\YinYang_a.blp
#    lúc tung (trên tướng): VDK_vongacast.mdx   [dùng chung (cùng dùng: VDK)]
#         texture: VLTK_data\KVCT3_Data\ThaiCuc.blp
#         texture: Textures\Yellow_Glow3.blp
#    lớp thêm tại điểm 1: VDQ_vongakiem.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\RockParticle.blp
#         texture: Textures\Dust5A.blp
#         texture: VLTK_data\KVCT3_Data\Layers1.blp
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
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning2x2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning_white.blp
#    aura bị động (gắn tướng suốt): VDQ_chanvutt.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning2x2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning_white.blp
#
# 5. Thuần Dương Vô Cực [F]   (kind 9, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thuanduongvocuc.mdx   [riêng phái]
#         texture: Textures\Star8.blp
#         texture: VLTK_data\KVCT3_Data\Rune1d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Units\Human\Phoenix\Demon_Rune_RibbonB.blp
#    lúc tung (trên tướng): VDQ_caster2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star6.blp
#         texture: Textures\CartoonCloud.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\firering1A.blp
#
# 6. Thái Cực Vô Ý [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 7. Thiên Địa Vô Cực [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#    lúc tung (trên tướng): VDQ_thiendiacaster.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#    trên địch bị trúng: VDQ_thiendiatarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#    lớp thêm tại điểm 1: VDQ_thiendia.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#    lớp thêm tại điểm 2: VDQ_thiendiacaster.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 8. Vạn Kiếm Quy Tông [R]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_vongakiem.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\RockParticle.blp
#         texture: Textures\Dust5A.blp
#         texture: VLTK_data\KVCT3_Data\Layers1.blp
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
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 9. Võ Đang Cửu Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_thuanduongvocuc.mdx   [riêng phái]
#         texture: Textures\Star8.blp
#         texture: VLTK_data\KVCT3_Data\Rune1d.blp
#         texture: Textures\Shockwave10.blp
#         texture: Units\Human\Phoenix\Demon_Rune_RibbonB.blp
#
# 10. Bát Quái Du Long [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\BatQuaiDuLong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#         texture: VLTK_data\Loose\BatQuai.blp
#         texture: VLTK_data\Loose\ThaiCuc.blp
#
# 11. Cửu Cung Bát Quái [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_cuucung1.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\GenericGlow64.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\BatQuai.blp
#         texture: VLTK_data\KVCT3_Data\ThaiCuc.blp
#    lúc tung (trên tướng): VDQ_caster2.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star6.blp
#         texture: Textures\CartoonCloud.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\firering1A.blp
#    trên địch bị trúng: VDQ_thiendiacaster.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#    lớp thêm tại điểm 1: VDQ_cuucung2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\gumujianzhen.blp
#    lớp thêm tại điểm 2: VDQ_thaicuc.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\KVCT3_Data\Bakua_b.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 12. Thái Cực Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThaiCucThanCong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\Yellow_Star.blp
#         texture: doodads\Cinematic\EyeOfSargeras\Demon_Rune2.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\Loose\Bakua_b.blp
#         texture: VLTK_data\Loose\YinYang_a.blp
#
# 13. Lưỡng Nghi Tâm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDQ_batquaidulong.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#         texture: VLTK_data\KVCT3_Data\BatQuai.blp
#         texture: VLTK_data\KVCT3_Data\ThaiCuc.blp
# ===== HẾT DANH MỤC =====
