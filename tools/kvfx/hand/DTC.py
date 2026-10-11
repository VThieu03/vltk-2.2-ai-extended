# DTC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Thần Chỉ Điểm Huyệt": {   # [Q]
        "main": "MDX\\ThanChi.mdx",
        "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
        "cast": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
    },
    "Đoàn Thị Chỉ Pháp": {   # [bị động]
        "main": "DTC_canduongchi.mdx",
    },
    "Nhất Dương Chỉ": {   # [R]
        "main": "DTK_kimngocmanduong.mdx",
        "target": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl",
    },
    "Lăng Ba Vi Bộ": {   # [F]
        "main": "Abilities\\Spells\\Other\\Drain\\ManaDrainCaster.mdl",
    },
    "Từ Bi Quyết": {   # [bị động]
        "main": "DTC_thienlongchi1.mdx",
    },
    "Kim Ngọc Chỉ Pháp": {   # [bị động]
        "main": "DTC_thienlongchi2.mdx",
    },
    "Cản Dương Thần Chỉ": {   # [W]
        "main": "DTC_Img.mdx",
        "cast": "DTC_canduongeffect1.mdx",
        "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
        "area": ["DTC_canduongchi.mdx"],
    },
    "Huyền Băng Cửu Kiếp": {   # [D]
        "main": "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl",
    },
    "Diệu Đề Chỉ": {   # [bị động]
        "main": "DTC_dieudebuff.mdx",
    },
    "Thí Nguyên Quyết": {   # [bị động]
        "main": "DTC_thinguyenbuff.mdx",
    },
    "Thiên Long Thần Chỉ": {   # [E]
        "main": "DTC_thienlongchi1.mdx",
        "cast": "DTC_canduongeffect1.mdx",
        "area": ["DTC_Img.mdx", "DTC_tranphai22.mdx"],
    },
    "Càn Thiên Chỉ Pháp": {   # [bị động]
        "main": "DTC_thienlongchi1.mdx",
        "area": ["DTC_thienlongchi2.mdx"],
    },
    "Bách Bộ Xuyên Dương": {   # [bị động]
        "main": "DTC_bachbobuff.mdx",
        "area": ["DTC_canduongchi.mdx", "DTC_canduongeffect1.mdx"],
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
# 1. Thần Chỉ Điểm Huyệt [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanChi.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\WaterWake3.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\Bubble.blp
#         texture: Textures\White_64_Foam1.blp
#    lúc tung (trên tướng): Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#
# 2. Đoàn Thị Chỉ Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_canduongchi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_GlowYellowb.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1R1b.blp
#         texture: VLTK_data\KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: VLTK_data\KVCT3_Data\lightning4x4.blp
#
# 3. Nhất Dương Chỉ [R]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [dùng chung (cùng dùng: DTK)]
#         texture: VLTK_data\KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning1.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning2.blp
#    trên địch bị trúng: Abilities\Weapons\SpiritOfVengeanceMissile\SpiritOfVengeanceMissile.mdl   [model gốc Warcraft III]
#
# 4. Lăng Ba Vi Bộ [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Spells\Other\Drain\ManaDrainCaster.mdl   [model gốc Warcraft III]
#
# 5. Từ Bi Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AFB_lltsfx.blp
#         texture: VLTK_data\KVCT3_Data\AFB_TT1.blp
#
# 6. Kim Ngọc Chỉ Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\bd100.blp
#         texture: Textures\Shockwave10.blp
#
# 7. Cản Dương Thần Chỉ [W]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_Img.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Mr.War3_PJWH.blp
#    lúc tung (trên tướng): DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\TX_daji.blp
#    trên địch bị trúng: Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: DTC_canduongchi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_GlowYellowb.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1R1b.blp
#         texture: VLTK_data\KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: VLTK_data\KVCT3_Data\lightning4x4.blp
#
# 8. Huyền Băng Cửu Kiếp [D]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Spells\Undead\FreezingBreath\FreezingBreathMissile.mdl   [model gốc Warcraft III]
#
# 9. Diệu Đề Chỉ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_dieudebuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\Precision.blp
#
# 10. Thí Nguyên Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thinguyenbuff.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#
# 11. Thiên Long Thần Chỉ [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AFB_lltsfx.blp
#         texture: VLTK_data\KVCT3_Data\AFB_TT1.blp
#    lúc tung (trên tướng): DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\TX_daji.blp
#    lớp thêm tại điểm 1: DTC_Img.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Mr.War3_PJWH.blp
#    lớp thêm tại điểm 2: DTC_tranphai22.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\bd100.blp
#         texture: Textures\Shockwave10.blp
#
# 12. Càn Thiên Chỉ Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AFB_lltsfx.blp
#         texture: VLTK_data\KVCT3_Data\AFB_TT1.blp
#    lớp thêm tại điểm 1: DTC_thienlongchi2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\bd100.blp
#         texture: Textures\Shockwave10.blp
#
# 13. Bách Bộ Xuyên Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTC_bachbobuff.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\DemonRune2.blp
#         texture: Textures\DemonRune3.blp
#         texture: VLTK_data\KVCT3_Data\massteleportcircle.blp
#         texture: Textures\ribbonne1_blue.blp
#    lớp thêm tại điểm 1: DTC_canduongchi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_GlowYellowb.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1R1b.blp
#         texture: VLTK_data\KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: VLTK_data\KVCT3_Data\lightning4x4.blp
#    lớp thêm tại điểm 2: DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\TX_daji.blp
# ===== HẾT DANH MỤC =====
