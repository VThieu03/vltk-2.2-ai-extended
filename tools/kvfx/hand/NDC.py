# NDC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Độc Sa Chưởng": {   # [Q]
        "main": "Abilities\\Spells\\NightElf\\CorrosiveBreath\\CorrosiveBreathMissile.mdl",
        "cast": "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl",
        "target": "Abilities\\Weapons\\GreenDragonMissile\\GreenDragonMissile.mdl",
        "area": ["NDC_effect1.mdx"],
    },
    "Ngũ Độc Chưởng Pháp": {   # [bị động]
        "main": "NDC_hoacotmienchuong2.mdx",
    },
    "Thiên Canh Địa Sát": {   # [R]
        "main": "NDC_thiencanhds.mdx",
        "cast": "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl",
        "area": ["Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl"],
    },
    "Xuyên Tâm Độc Thích": {   # [bị động]
        "main": "NDC_truyphongdocthich.mdx",
    },
    "Bi Ma Huyết Quang": {   # [bị động]
        "main": "NDC_huyetdinhbuff.mdx",
        "area": ["NDC_bimahuyetquang.mdx"],
    },
    "Bách Cổ Độc Kinh": {   # [bị động]
        "main": "NDC_hoacotmienchuong2.mdx",
    },
    "Âm Phong Thực Cốt": {   # [W]
        "main": "NDC_amphong1.mdx",
        "cast": "NDC_amphongcast.mdx",
        "target": "Abilities\\Weapons\\KeeperGroveMissile\\KeeperGroveMissile.mdl",
        "area": ["NDC_amphong3.mdx", "NDC_amphong2.mdx"],
    },
    "Hóa Cốt Miên Chưởng": {   # [D]
        "main": "NDC_hoacotmienchuong2.mdx",
        "buff": "NDC_hoacotbuff.mdx",
        "area": ["NDC_hoacotbuff.mdx"],
    },
    "Truy Phong Độc Thích": {   # [bị động]
        "main": "NDC_truyphongdocthich.mdx",
        "cast": "NDC_amphongcast.mdx",
        "area": ["NDC_amphong1.mdx", "NDC_amphong2.mdx"],
    },
    "Luyện Ngục Hủ Cổ": {   # [bị động]
        "main": "NDC_thiencanhds.mdx",
    },
    "U Minh Quỷ Trảo": {   # [E]
        "main": "NDC_quytrao3.mdx",
        "cast": "NDC_amphongcast.mdx",
        "target": "NDC_uminhkholautarget.mdx",
        "area": ["NDC_uminheffect.mdx"],
    },
    "Đoạn Cân Hủ Cốt": {   # [bị động]
        "main": "NDC_thiencanhds.mdx",
    },
    "U Minh Khô Lâu": {   # [T]
        "main": "NDC_uminhkholautarget.mdx",
        "target": "NDC_uminhkholautarget.mdx",
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
# 1. Độc Sa Chưởng [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Spells\NightElf\CorrosiveBreath\CorrosiveBreathMissile.mdl   [model gốc Warcraft III]
#    lúc tung (trên tướng): Abilities\Weapons\SkeletalMageMissile\SkeletalMageMissile.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: Abilities\Weapons\GreenDragonMissile\GreenDragonMissile.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: NDC_effect1.mdx   [riêng phái]
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
#
# 2. Ngũ Độc Chưởng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_hoacotmienchuong2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#         texture: VLTK_data\KVCT3_Data\Skullmx.blp
#         texture: Textures\GenericGlow64.blp
#
# 3. Thiên Canh Địa Sát [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_thiencanhds.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#    lúc tung (trên tướng): Abilities\Weapons\SkeletalMageMissile\SkeletalMageMissile.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: Abilities\Spells\Other\Cleave\CleaveDamageTarget.mdl   [model gốc Warcraft III]
#
# 4. Xuyên Tâm Độc Thích [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_truyphongdocthich.mdx   [riêng phái]
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\jn_fu_015_h.blp
#         texture: VLTK_data\KVCT3_Data\Seal08.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\NightElfFemaleEyeGlow1.blp
#
# 5. Bi Ma Huyết Quang [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_huyetdinhbuff.mdx   [riêng phái]
#         texture: Textures\Green_Glow3.blp
#         texture: UI\MiniMap\ping4.blp
#    lớp thêm tại điểm 1: NDC_bimahuyetquang.mdx   [riêng phái]
#         texture: Textures\grad3.blp
#         texture: VLTK_data\KVCT3_Data\dust3.blp
#         texture: Textures\Black32.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple01_bw.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple02_bw.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple_green.blp
#         texture: Textures\Shockwave1White.blp
#
# 6. Bách Cổ Độc Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_hoacotmienchuong2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#         texture: VLTK_data\KVCT3_Data\Skullmx.blp
#         texture: Textures\GenericGlow64.blp
#
# 7. Âm Phong Thực Cốt [W]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_amphong1.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#    lúc tung (trên tướng): NDC_amphongcast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire.blp
#         texture: Textures\star6.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave4white.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightningBlack_2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_glow1.blp
#    trên địch bị trúng: Abilities\Weapons\KeeperGroveMissile\KeeperGroveMissile.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: NDC_amphong3.mdx   [riêng phái]
#         texture: ReplaceableTextures\CommandButtons\BTNDarkRitual.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#    lớp thêm tại điểm 2: NDC_amphong2.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#
# 8. Hóa Cốt Miên Chưởng [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_hoacotmienchuong2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#         texture: VLTK_data\KVCT3_Data\Skullmx.blp
#         texture: Textures\GenericGlow64.blp
#    buff (trên tướng): NDC_hoacotbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\SKULL.BLP
#         texture: Textures\Blue_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\TOONSMOKE16.BLP
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Ghost1.blp
#         texture: Textures\Ghost2.blp
#         texture: VLTK_data\KVCT3_Data\nassus_ghost.blp
#    lớp thêm tại điểm 1: NDC_hoacotbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\SKULL.BLP
#         texture: Textures\Blue_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\TOONSMOKE16.BLP
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Ghost1.blp
#         texture: Textures\Ghost2.blp
#         texture: VLTK_data\KVCT3_Data\nassus_ghost.blp
#
# 9. Truy Phong Độc Thích [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_truyphongdocthich.mdx   [riêng phái]
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\jn_fu_015_h.blp
#         texture: VLTK_data\KVCT3_Data\Seal08.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\NightElfFemaleEyeGlow1.blp
#    lúc tung (trên tướng): NDC_amphongcast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire.blp
#         texture: Textures\star6.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave4white.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightningBlack_2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_glow1.blp
#    lớp thêm tại điểm 1: NDC_amphong1.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#    lớp thêm tại điểm 2: NDC_amphong2.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Green_Glow2.blp
#         texture: ReplaceableTextures\Splats\DarkSummonSpecial.blp
#
# 10. Luyện Ngục Hủ Cổ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_thiencanhds.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#
# 11. U Minh Quỷ Trảo [E]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_quytrao3.mdx   [riêng phái]
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): NDC_amphongcast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire.blp
#         texture: Textures\star6.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave4white.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightningBlack_2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_glow1.blp
#    trên địch bị trúng: NDC_uminhkholautarget.mdx   [riêng phái, phái khác cũng dùng: NDD]
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\Red_Glow1.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Red_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_2x8.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_4x4.blp
#         texture: VLTK_data\KVCT3_Data\7fx_lightraysup_full2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb9.blp
#         texture: VLTK_data\KVCT3_Data\kulou001.blp
#    lớp thêm tại điểm 1: NDC_uminheffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\zd090.blp
#         texture: VLTK_data\KVCT3_Data\zd091.blp
#         texture: Textures\CrystalBall.blp
#
# 12. Đoạn Cân Hủ Cốt [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_thiencanhds.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\Shockwave1b.blp
#
# 13. U Minh Khô Lâu [T]   (kind 15, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDC_uminhkholautarget.mdx   [riêng phái, phái khác cũng dùng: NDD]
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\Red_Glow1.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Red_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_2x8.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_4x4.blp
#         texture: VLTK_data\KVCT3_Data\7fx_lightraysup_full2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb9.blp
#         texture: VLTK_data\KVCT3_Data\kulou001.blp
#    trên địch bị trúng: NDC_uminhkholautarget.mdx   [riêng phái, phái khác cũng dùng: NDD]
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\Red_Glow1.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Red_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_2x8.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_4x4.blp
#         texture: VLTK_data\KVCT3_Data\7fx_lightraysup_full2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb9.blp
#         texture: VLTK_data\KVCT3_Data\kulou001.blp
# ===== HẾT DANH MỤC =====
