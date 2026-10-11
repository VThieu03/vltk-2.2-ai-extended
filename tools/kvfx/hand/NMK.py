# NMK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Thôi Song Vọng Nguyệt": {   # [Q]
        "main": "NMK_thoisongvongnguyet.mdx",
        "target": "NMK_thoisongeffect.mdx",
        "cast": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
    },
    "Từ Hàng Phổ Độ": {   # [R]
        "main": "NMK_tuhang.mdx",
        "cast": "NMK_tuhang.mdx",
        "area": ["NMK_tuhang2.mdx", "NMK_effect8.mdx"],
        "scale": 0.5,
    },
    "Thiên Phật Thiên Diệp": {   # [D]
        "main": "NMK_thienphatbuff.mdx","scale": 0.5,
    },
    "Mộng Điệp": {   # [bị động]
        "main": r"Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl",
    },
    "Phật Tâm Từ Hựu": {   # [bị động]
        "main": "NMK_kiemanhphatquang.mdx",
    },
    "Ba La Tâm Kinh": {   # [bị động]
        "main": "NMK_kiemanhphatquangtarget.mdx",
    },
    "Kiếm Ảnh Phật Quang": {   # [W]
        "main": "NMK_kiemanhphatquang.mdx",
        "target": "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
        "cast": "NMK_kiemanhphatquangtarget.mdx","scale": 0.3
    },
    "Thanh Âm Phạn Xướng": {   # [bị động]
        "main": "war3mapImported\\TND_tathoafire.mdx",
    },
    "Thanh Tâm Tịnh Khí": {   # [bị động]
        "main": "war3mapImported\\Effect_slam2.mdx",
    },
    "Liên Hoa Tâm Kinh": {   # [bị động]
        "main": "NMK_tuhang2.mdx",
        "aura": "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl",
    },
    "Băng Sương Điện Phóng": {   # [E]
        "main": "NMK_bangsuongkiem.mdx",
        "target": "NMK_bangsuongtarget.mdx",
        "buff": "NMK_thienphatbuff.mdx",
        "area": ["NMK_bangsuongeffect.mdx"],
    },
    "Độ Nguyên Công": {   # [bị động]
        "main": "NMK_thoisongvongnguyet.mdx",
    },
    "Bế Nguyệt Phất Trần": {   # [bị động]
        "main": "NMK_thoisongvongnguyet.mdx",
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
# 1. Thôi Song Vọng Nguyệt [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
#    lúc tung (trên tướng): Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: NMK_thoisongeffect.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star.blp
#         texture: Textures\star1.blp
#         texture: Textures\star2.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star3.blp
#         texture: Textures\star32.blp
#         texture: Textures\star4.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star6.blp
#         texture: Textures\Star8.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\Star9.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#
# 2. Từ Hàng Phổ Độ [R]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_tuhang.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Zap1_Red.blp
#         texture: VLTK_data\KVCT3_Data\SenEmei01.blp
#    lúc tung (trên tướng): NMK_tuhang.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Zap1_Red.blp
#         texture: VLTK_data\KVCT3_Data\SenEmei01.blp
#    lớp thêm tại điểm 1: NMK_tuhang2.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Shockwave_blue.blp
#         texture: Textures\rainTail.blp
#    lớp thêm tại điểm 2: NMK_effect8.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#
# 3. Thiên Phật Thiên Diệp [D]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thienphatbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\heianhuanxiang1.BLP
#         texture: VLTK_data\KVCT3_Data\heianhuanxiang2.blp
#
# 4. Mộng Điệp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl   [model gốc Warcraft III]
#
# 5. Phật Tâm Từ Hựu [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquang.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\leshandafo01.blp
#         texture: VLTK_data\KVCT3_Data\leshandafo02.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX.blp
#
# 6. Ba La Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquangtarget.mdx   [riêng phái]
#         texture: Textures\firering6.blp
#         texture: Textures\grad2d.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_Tornado1E.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_snowflake01.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp
#         texture: VLTK_data\KVCT3_Data\20huaxinazi_effect_lightning4.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_hua.blp
#
# 7. Kiếm Ảnh Phật Quang [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquang.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\leshandafo01.blp
#         texture: VLTK_data\KVCT3_Data\leshandafo02.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX.blp
#    lúc tung (trên tướng): NMK_kiemanhphatquangtarget.mdx   [riêng phái]
#         texture: Textures\firering6.blp
#         texture: Textures\grad2d.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_Tornado1E.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_snowflake01.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp
#         texture: VLTK_data\KVCT3_Data\20huaxinazi_effect_lightning4.blp
#         texture: VLTK_data\KVCT3_Data\20huaxianzi_effect_hua.blp
#    trên địch bị trúng: Abilities\Weapons\AvengerMissile\AvengerMissile.mdl   [model gốc Warcraft III]
#
# 8. Thanh Âm Phạn Xướng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_tathoafire.mdx   [dùng chung (cùng dùng: TND)]
#         texture: Textures\Clouds8x8Fade.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_01.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_1X6.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_02.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_03.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_04.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_00.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8.blp
#
# 9. Thanh Tâm Tịnh Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Effect_slam2.mdx   [dùng chung]
#         texture: VLTK_data\KVCT3_Data\TX_zhendi1.blp
#         texture: VLTK_data\KVCT3_Data\TX_zhendi2.blp
#         texture: VLTK_data\KVCT3_Data\TX_zhendi3.blp
#         texture: VLTK_data\KVCT3_Data\TX_zhendi4.blp
#         texture: VLTK_data\KVCT3_Data\TX_zhendi5.blp
#
# 10. Liên Hoa Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_tuhang2.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Shockwave_blue.blp
#         texture: Textures\rainTail.blp
#    aura bị động (gắn tướng suốt): Abilities\Spells\Human\Slow\SlowCaster.mdl   [model gốc Warcraft III]
#
# 11. Băng Sương Điện Phóng [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_bangsuongkiem.mdx   [riêng phái]
#         texture: Buildings\Human\ArcaneSanctum\ArcaneSanctum.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\222.blp
#    trên địch bị trúng: NMK_bangsuongtarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx019-1.blp
#         texture: VLTK_data\KVCT3_Data\tx019-2.blp
#         texture: VLTK_data\KVCT3_Data\tx019-3.blp
#    buff (trên tướng): NMK_thienphatbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\heianhuanxiang1.BLP
#         texture: VLTK_data\KVCT3_Data\heianhuanxiang2.blp
#    lớp thêm tại điểm 1: NMK_bangsuongeffect.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke1E.blp
#         texture: VLTK_data\KVCT3_Data\AZ_SnowGlobe0.blp
#         texture: Textures\Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\AZ_GlowBlue.blp
#         texture: Textures\Ice3b.blp
#         texture: VLTK_data\KVCT3_Data\az_crack48.tga
#
# 12. Độ Nguyên Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
#
# 13. Bế Nguyệt Phất Trần [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
# ===== HẾT DANH MỤC =====
