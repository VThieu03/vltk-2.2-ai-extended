# NMC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Tứ Tượng Đồng Quy": {   # [Q]
        "main": "NMC_tutuongdq.mdx",
        "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
        "buff": "NMC_vantuongbuff.mdx",
        "area": ["NMC_tutuongtarget.mdx"],
    },
    "Nga My Chưởng Pháp": {   # [bị động]
        "main": "NMC_batdiet2.mdx",
    },
    "Phật Tâm Từ Hựu": {   # [bị động]
        "main": "NMC_diepdetanghoa.mdx",
    },
    "Bất Diệt Bất Tuyệt": {   # [bị động]
        "main": "MDX\\BatDietBatTuyet.mdx",
        "area": ["NMC_batdiet2.mdx"],
    },
    "Phật Quang Chiến Khí": {   # [R]
        "main": "TLHD_khaphuyet.mdx",
    },
    "Phật Pháp Vô Biên": {   # [bị động]
        "main": "NMC_phongsuongtoaianh.mdx",
    },
    "Phong Sương Toái Ảnh": {   # [W]
        "main": "NMC_diepdetanghoa.mdx",
        "target": {"file": "NMC_phongsuongtarget.mdx", "ground": True},
        "area": ["NMC_phongsuongtoaianh.mdx"],
    },
    "Diệp Để Tàng Hoa": {   # [bị động]
        "main": "war3mapImported\\Effect_dongbang.mdx",
    },
    "Kim Đỉnh Miên Chưởng": {   # [bị động]
        "main": "Abilities\\Weapons\\ProcMissile\\ProcMissile.mdl",
        "target": "war3mapImported\\Effect_fire2.mdx",
    },
    "Vạn Tướng Thần Công": {   # [D]
        "main": "NMC_vantuongbuff.mdx",
        "target": "NMC_tutuongtarget.mdx",
    },
    "Nguyệt Hoa Khuynh Tả": {   # [E]
        "main": "NMC_nguyethoaeffect.mdx",
        "cast": {"file": "NMC_nguyethoacast.mdx", "ground": True},
        "area": ["NMC_diepdetanghoa.mdx"],
    },
    "Vạn Phật Quy Tông": {   # [bị động]
        "main": "NMC_phatquangbuff.mdx",
        "cast": "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl",
    },
    "Kim Đỉnh Phật Quang": {   # [bị động]
        "main": "NMC_phatquangbuff.mdx",
        "buff": "NMC_kimdinhbuff.mdx",
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
# 1. Tứ Tượng Đồng Quy [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_tutuongdq.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\TX_Smoke2003.blp
#         texture: VLTK_data\KVCT3_Data\TX_Xulie2019.blp
#         texture: VLTK_data\KVCT3_Data\TX_Xulie2020.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star5.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2004.blp
#         texture: VLTK_data\KVCT3_Data\Hero_WinterWyvern_N1S_R_Source_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_WinterWyvern_N1S_R_Source_01.blp
#    trên địch bị trúng: Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#    buff (trên tướng): NMC_vantuongbuff.mdx   [riêng phái]
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\KVCT3_Data\AZ_MagicMatrix19.blp
#    lớp thêm tại điểm 1: NMC_tutuongtarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#
# 2. Nga My Chưởng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_batdiet2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#
# 3. Phật Tâm Từ Hựu [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_diepdetanghoa.mdx   [riêng phái]
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
# 4. Bất Diệt Bất Tuyệt [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\BatDietBatTuyet.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\firering4.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\Loose\PhatQuangChienKhi.blp
#         texture: VLTK_data\Loose\Ping.blp
#    lớp thêm tại điểm 1: NMC_batdiet2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#
# 5. Phật Quang Chiến Khí [R]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLHD_khaphuyet.mdx   [dùng chung]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\OrcBloodTailParticle0.blp
#
# 6. Phật Pháp Vô Biên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_phongsuongtoaianh.mdx   [riêng phái, phái khác cũng dùng: CLD, HSK]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Abilities\Spells\Undead\VampiricAura\AuraRune6.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\clouds_anim1.blp
#         texture: Textures\CloudSingle.blp
#
# 7. Phong Sương Toái Ảnh [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_diepdetanghoa.mdx   [riêng phái]
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
#    trên địch bị trúng: NMC_phongsuongtarget.mdx   [riêng phái]
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
#    lớp thêm tại điểm 1: NMC_phongsuongtoaianh.mdx   [riêng phái, phái khác cũng dùng: CLD, HSK]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Abilities\Spells\Undead\VampiricAura\AuraRune6.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\clouds_anim1.blp
#         texture: Textures\CloudSingle.blp
#
# 8. Diệp Để Tàng Hoa [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Effect_dongbang.mdx   [dùng chung]
#         texture: VLTK_data\war3mapImported\AZ_Crack28.blp
#         texture: Textures\Ice3b.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\star5tga.blp
#
# 9. Kim Đỉnh Miên Chưởng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Weapons\ProcMissile\ProcMissile.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: Effect_fire2.mdx   [dùng chung (cùng dùng: TLB)]
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Lords0000.blp
#         texture: Textures\Lords0001.blp
#         texture: Textures\Lords0002.blp
#         texture: Textures\Lords0003.blp
#         texture: Textures\Lords0004.blp
#         texture: Textures\Lords0005.blp
#         texture: Textures\Lords0006.blp
#         texture: Textures\Lords0007.blp
#         texture: Textures\Water_Particles.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\LavaLump2.blp
#
# 10. Vạn Tướng Thần Công [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_vantuongbuff.mdx   [riêng phái]
#         texture: Textures\AuraRune7Green.blp
#         texture: VLTK_data\KVCT3_Data\AZ_MagicMatrix19.blp
#    trên địch bị trúng: NMC_tutuongtarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#
# 11. Nguyệt Hoa Khuynh Tả [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_nguyethoaeffect.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: VLTK_data\KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb17.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon42.blp
#    lúc tung (trên tướng): NMC_nguyethoacast.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\star4x4.blp
#         texture: Textures\GenericGlow1.blp
#         texture: VLTK_data\KVCT3_Data\moonknight_moon.blp
#         texture: Textures\RibbonBlur1.blp
#    lớp thêm tại điểm 1: NMC_diepdetanghoa.mdx   [riêng phái]
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
# 12. Vạn Phật Quy Tông [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_phatquangbuff.mdx   [riêng phái]
#         texture: abilities\Spells\Human\InnerFire\Crown1.blp
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: abilities\Spells\Human\InnerFire\Rune7.blp
#         texture: Textures\Rune1d.blp
#         texture: VLTK_data\KVCT3_Data\PhatQuangChienKhi.blp
#         texture: VLTK_data\KVCT3_Data\LienHoa.blp
#    lúc tung (trên tướng): Objects\Spawnmodels\NightElf\NECancelDeath\NECancelDeath.mdl   [model gốc Warcraft III]
#
# 13. Kim Đỉnh Phật Quang [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMC_phatquangbuff.mdx   [riêng phái]
#         texture: abilities\Spells\Human\InnerFire\Crown1.blp
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: abilities\Spells\Human\InnerFire\Rune7.blp
#         texture: Textures\Rune1d.blp
#         texture: VLTK_data\KVCT3_Data\PhatQuangChienKhi.blp
#         texture: VLTK_data\KVCT3_Data\LienHoa.blp
#    buff (trên tướng): NMC_kimdinhbuff.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Zap1_Red.blp
# ===== HẾT DANH MỤC =====
