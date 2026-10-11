# TLD: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Phục Ma Đao Pháp": {   # [Q]
        "main": "TLD_phucmadp.mdx",
    },
    "Thiếu Lâm Đao Pháp": {   # [bị động]
        "main": "TLD_lahantran.mdx",
    },
    "Dịch Cân Kinh": {   # [bị động]
        "main": "TLD_phucmadp.mdx",
    },
    "A La Hán Thần Công": {   # [bị động]
        "main": "TLD_lahantran.mdx",
        "aura": "TLD_lahantran.mdx",
    },
    "Bồ Đề Tâm Pháp": {   # [D]
        "cast": "TLD_bodetamphapcast.mdx",
    },
    "Như Lai Thiên Diệp": {   # [bị động]
        "main": "TLD_thientrucdao.mdx",
        "target": "TLD_thientructarget.mdx",
    },
    "Thiên Trúc Tuyệt Đao": {   # [W]
        "main": "TLD_thientrucdao.mdx",
        "target": ["TLD_votuongtram.mdx", "TLD_thientructarget.mdx"],
    },
    "Hàng Long Bất Vũ": {   # [F]
        "main": "TLD_hanglongbuff.mdx",
        "cast": "TLD_hanglongcast.mdx",
    },
    "Đạt Ma Bế Tức": {   # [bị động]
        "main": "TLD_datmabetucbuff.mdx",
    },
    "Đại Thừa Như Lai Chú": {   # [R]
        "main": "TLD_daithua.mdx",
        "buff": "TLD_daithuabuff.mdx",
        "area": ["TLD_votuongtram.mdx"],
    },
    "Quy Thiền Đao Pháp": {   # [E]
        "main": "TLD_tamgioidao.mdx",
        "cast": {"file": "TLD_tamgioihoasen.mdx", "ground": True},
        "target": ["TLD_votuongtram.mdx", "TLD_thientructarget.mdx"],
    },
    "Thiền Nguyên Công": {   # [bị động]
        "main": "TLD_thientrucdao.mdx",
        "target": "TLD_thientructarget.mdx",
    },
    "Trảm Ma Đao Pháp": {   # [bị động]
        "main": "TLD_tamgioihoasen.mdx",
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
# 1. Phục Ma Đao Pháp [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_phucmadp.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\star2_32.blp
#
# 2. Thiếu Lâm Đao Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: VLTK_data\KVCT3_Data\tx208-1.blp
#         texture: VLTK_data\KVCT3_Data\tx208-2.blp
#
# 3. Dịch Cân Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_phucmadp.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\star2_32.blp
#
# 4. A La Hán Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: VLTK_data\KVCT3_Data\tx208-1.blp
#         texture: VLTK_data\KVCT3_Data\tx208-2.blp
#    aura bị động (gắn tướng suốt): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: VLTK_data\KVCT3_Data\tx208-1.blp
#         texture: VLTK_data\KVCT3_Data\tx208-2.blp
#
# 5. Bồ Đề Tâm Pháp [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_bodetamphapcast.mdx   [riêng phái, phái khác cũng dùng: TLQ]
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\firering4.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\GodCorss.blp
#    lúc tung (trên tướng): TLD_bodetamphapcast.mdx   [riêng phái, phái khác cũng dùng: TLQ]
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\firering4.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\GodCorss.blp
#
# 6. Như Lai Thiên Diệp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_thientrucdao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star2.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 7. Thiên Trúc Tuyệt Đao [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_thientrucdao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star2.blp
#    trên địch bị trúng: TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    trên địch bị trúng 2: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 8. Hàng Long Bất Vũ [F]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_hanglongbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BOSS_Heilong02.blp
#         texture: VLTK_data\KVCT3_Data\Seal81.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TLD_hanglongcast.mdx   [riêng phái]
#         texture: Textures\star3.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Green_firering2b.blp
#         texture: Textures\Rune1d.blp
#         texture: Textures\Red_Glow3.blp
#
# 9. Đạt Ma Bế Tức [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_datmabetucbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\KVCT3_Data\Buddha.BLP
#
# 10. Đại Thừa Như Lai Chú [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_daithua.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\star6.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp
#         texture: Textures\GenericGlow2_64.blp
#    buff (trên tướng): TLD_daithuabuff.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    lớp thêm tại điểm 1: TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#
# 11. Quy Thiền Đao Pháp [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_tamgioidao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N2s_light2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N2s_light3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N2s_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EncHantress_N2S_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N2s_star1.blp
#    lúc tung (trên tướng): TLD_tamgioihoasen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\KVCT3_Data\AZ_texturesPetal2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Petal1.blp
#    trên địch bị trúng: TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    trên địch bị trúng 2: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 12. Thiền Nguyên Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_thientrucdao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Slayer_N10S_star2.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 13. Trảm Ma Đao Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLD_tamgioihoasen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\KVCT3_Data\AZ_texturesPetal2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Petal1.blp
# ===== HẾT DANH MỤC =====
