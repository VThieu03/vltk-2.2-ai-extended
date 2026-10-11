# CLK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Cuồng Lôi Chấn Địa": {   # [Q]
        "main": "CLK_cuongloi.mdx",
        "area": ["CLK_thienloichannhac.mdx"],
    },
    "Côn Lôn Kiếm Pháp": {   # [bị động]
        "main": "CLK_daocottienphong.mdx",
    },
    "Thanh Phong Phù": {   # [F]
        "main": "CLK_nguphongbuff.mdx",
        "cast": "CLK_nguphongcaster.mdx",
        "area": ["CLK_thanhphongphu.mdx", "CLK_daocottienphong.mdx"],
    },
    "Thiên Tế Tấn Lôi": {   # [W]
        "main": "CLK_thientetanloi.mdx",
        "target": "CLK_targetlight2.mdx",
    },
    "Đạo Cốt Tiên Phong": {   # [T]
        "main": "CLK_daocottienphong.mdx",
    },
    "Ngũ Lôi Chánh Pháp": {   # [bị động]
        "main": "CLK_thienloichannhac.mdx",
        "area": ["CLK_thanhphongphu.mdx"],
    },
    "Lôi Động Cửu Thiên": {   # [E]
        "main": "CLK_loidongcuuthien.mdx",
    },
    "Lôi Đình Quyết": {   # [bị động]
        "main": "CLK_loidinhquyet.mdx",
        "aura": "CLK_loidinhquyet.mdx",
    },
    "Huyền Thiên Vô Cực": {   # [bị động]
        "main": "CLK_loidongcuuthien.mdx",
        "area": ["CLK_thienloichannhac.mdx", "CLK_thientetanloi.mdx"],
    },
    "Ngự Phong Thuật": {   # [D]
        "main": "CLK_nguphongthuat.mdx",
    },
    "Thiên Lôi Chấn Nhạc": {   # [R]
        "main": "CLK_thienloichannhac.mdx",
        "target": "CLK_set5.mdx",
    },
    "Hỗn Nguyên Càn Khôn": {   # [bị động]
        "main": "CLK_cuongloi.mdx",
    },
    "Hóa Tủy Vô Ý": {   # [bị động]
        "main": "CLK_daocottienphong.mdx",
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
# 1. Cuồng Lôi Chấn Địa [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_cuongloi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-5.blp
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-1.blp
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-3.blp
#    lúc tung (trên tướng): CLK_cast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4.blp
#         texture: Textures\firering6.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4x4.blp
#    lớp thêm tại điểm 1: CLK_thienloichannhac.mdx   [riêng phái]
#         texture: Textures\Zap1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning_A1_4x4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\LightningBall.blp
#
# 2. Côn Lôn Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_daocottienphong.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HeTho.blp
#
# 3. Thanh Phong Phù [F]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_nguphongbuff.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\Blue_Star2.blp
#    lúc tung (trên tướng): CLK_nguphongcaster.mdx   [riêng phái]
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
#    lớp thêm tại điểm 1: CLK_thanhphongphu.mdx   [riêng phái]
#         texture: Textures\MagicGlow.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\GraveYardGhost.blp
#         texture: Textures\Rune4b.blp
#    lớp thêm tại điểm 2: CLK_daocottienphong.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HeTho.blp
#
# 4. Thiên Tế Tấn Lôi [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_thientetanloi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JD-2021leidianlong_shandain02.tga
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: ReplaceableTextures\Splats\Splat01Mature.blp
#    lúc tung (trên tướng): CLK_cast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4.blp
#         texture: Textures\firering6.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4x4.blp
#    trên địch bị trúng: CLK_targetlight2.mdx   [riêng phái]
#         texture: Textures\Yellow_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\ZapYellow.blp
#
# 5. Đạo Cốt Tiên Phong [T]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_daocottienphong.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HeTho.blp
#    lúc tung (trên tướng): CLK_nguphongcaster.mdx   [riêng phái]
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
#
# 6. Ngũ Lôi Chánh Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_thienloichannhac.mdx   [riêng phái]
#         texture: Textures\Zap1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning_A1_4x4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\LightningBall.blp
#    lớp thêm tại điểm 1: CLK_thanhphongphu.mdx   [riêng phái]
#         texture: Textures\MagicGlow.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\GraveYardGhost.blp
#         texture: Textures\Rune4b.blp
#
# 7. Lôi Động Cửu Thiên [E]   (kind 17, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_loidongcuuthien.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_2_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_14_8x1.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_1_4x2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Fragment_2_8x8.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Frame_Glow_3.blp
#    lúc tung (trên tướng): CLK_cast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4.blp
#         texture: Textures\firering6.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4x4.blp
#
# 8. Lôi Đình Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_loidinhquyet.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\TX_Star2012.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N1_ef_13.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N1_ef_14.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow5.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_star1.blp
#    aura bị động (gắn tướng suốt): CLK_loidinhquyet.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\TX_Star2012.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N1_ef_13.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N1_ef_14.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_glow5.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_FarSeer_N2S_star1.blp
#
# 9. Huyền Thiên Vô Cực [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_loidongcuuthien.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_2_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_14_8x1.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Lightning_1_4x2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_D2_Sequence_Fragment_2_8x8.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Frame_Glow_3.blp
#    lớp thêm tại điểm 1: CLK_thienloichannhac.mdx   [riêng phái]
#         texture: Textures\Zap1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning_A1_4x4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\LightningBall.blp
#    lớp thêm tại điểm 2: CLK_thientetanloi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JD-2021leidianlong_shandain02.tga
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: ReplaceableTextures\Splats\Splat01Mature.blp
#
# 10. Ngự Phong Thuật [D]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_nguphongthuat.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx926_1.blp
#         texture: Textures\Dust3.blp
#         texture: VLTK_data\KVCT3_Data\tx926_2.blp
#         texture: VLTK_data\KVCT3_Data\tx926_3.blp
#         texture: VLTK_data\KVCT3_Data\tx926_4.blp
#         texture: VLTK_data\KVCT3_Data\tx926_5.blp
#         texture: VLTK_data\KVCT3_Data\tx926_6.blp
#         texture: VLTK_data\KVCT3_Data\tx926_7.blp
#    lúc tung (trên tướng): CLK_nguphongcaster.mdx   [riêng phái]
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
#    buff (trên tướng): CLK_nguphongbuff.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\Blue_Star2.blp
#
# 11. Thiên Lôi Chấn Nhạc [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_thienloichannhac.mdx   [riêng phái]
#         texture: Textures\Zap1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning_A1_4x4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\LightningBall.blp
#    lúc tung (trên tướng): CLK_cast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare1B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4.blp
#         texture: Textures\firering6.blp
#         texture: VLTK_data\KVCT3_Data\AZ_lightning4x4.blp
#    trên địch bị trúng: CLK_set5.mdx   [riêng phái]
#         texture: Textures\Zap1.blp
#         texture: Textures\star32.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#
# 12. Hỗn Nguyên Càn Khôn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_cuongloi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-5.blp
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-1.blp
#         texture: VLTK_data\KVCT3_Data\@Sasuke_light-3.blp
#
# 13. Hóa Tủy Vô Ý [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CLK_daocottienphong.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HeTho.blp
# ===== HẾT DANH MỤC =====
