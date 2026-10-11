# HSQ: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Thanh Vân Tống Sảng": {   # [Q]
        "main": "HSQ_thanhvan.mdx",
        "cast": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl",
        "target": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl",
    },
    "Hoa Sơn Khí Công": {   # [bị động]
        "main": "HSQ_hainapbachxuyen.mdx",
    },
    "Long Nhiễu Thân": {   # [bị động]
        "main": "HSQ_mavankk2.mdx",
    },
    "Chân Khí Hộ Thể": {   # [R]
        "main": "HSQ_chankhihothecast.mdx",
        "cast": "HSQ_chankhihothecast.mdx",
    },
    "Hải Nạp Bách Xuyên": {   # [bị động]
        "main": "HSQ_hainapbachxuyen.mdx",
    },
    "Khí Chấn Sơn Hà": {   # [bị động]
        "main": "HSQ_phangoc.mdx",
    },
    "Ma Vân Kiếm Khí": {   # [W]
        "main": "HSQ_mavansword.mdx",
        "cast": {"file": "HSQ_caster.mdx", "ground": True},
        "target": "HSQ_mavankk2.mdx",
    },
    "Khí Quán Trường Hồng": {   # [bị động]
        "main": "HSQ_thanhvan.mdx",
    },
    "Tử Hà Chân Khí": {   # [D]
        "main": "HSQ_tuhachankhi.mdx",
        "cast": "HSQ_chankhihothecast.mdx",
        "area": ["HSQ_chankhihothe.mdx"],
    },
    "Huyền Nhãn Yên Vân": {   # [bị động]
        "main": "HSQ_tukhidl.mdx",
    },
    "Phách Thạch Phá Ngọc": {   # [E]
        "main": "HSQ_phachthach.mdx",
        "cast": {"file": "HSQ_caster.mdx", "ground": True},
        "area": ["HSQ_mavankk2.mdx", "HSQ_phangoc2.mdx"],
        "target": "Abilities\\Weapons\\VoidWalkerMissile\\VoidWalkerMissile.mdl","scale":0.3
    },
    "Thần Quang Toàn Nhiễu": {   # [bị động]
        "main": "HSQ_hainapbachxuyen.mdx",
    },
    "Tử Khí Đông Lai": {   # [bị động]
        "main": "HSQ_tukhidl.mdx",
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
# 1. Thanh Vân Tống Sảng [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_thanhvan.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#    lúc tung (trên tướng): Abilities\Weapons\SpiritOfVengeanceMissile\SpiritOfVengeanceMissile.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: Abilities\Weapons\SpiritOfVengeanceMissile\SpiritOfVengeanceMissile.mdl   [model gốc Warcraft III]
#
# 2. Hoa Sơn Khí Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1_White.blp
#
# 3. Long Nhiễu Thân [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: VLTK_data\KVCT3_Data\AZ_star2.blp
#
# 4. Chân Khí Hộ Thể [R]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\HellscreamW2.blp
#    lúc tung (trên tướng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\HellscreamW2.blp
#
# 5. Hải Nạp Bách Xuyên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1_White.blp
#
# 6. Khí Chấn Sơn Hà [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_phangoc.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 7. Ma Vân Kiếm Khí [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_mavansword.mdx   [riêng phái]
#         texture: Textures\Star7b.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Dust5A.blp
#         texture: VLTK_data\KVCT3_Data\wx_jian4.blp
#    lúc tung (trên tướng): HSQ_caster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Glow.blp
#         texture: VLTK_data\KVCT3_Data\GlowBlack2.blp
#         texture: VLTK_data\KVCT3_Data\Zap2.blp
#         texture: VLTK_data\KVCT3_Data\Ribbon3.blp
#    lớp thêm tại điểm 1: HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: VLTK_data\KVCT3_Data\AZ_star2.blp
#
# 8. Khí Quán Trường Hồng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_thanhvan.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 9. Tử Hà Chân Khí [D]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tuhachankhi.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N6_VFX_03.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N5_ef_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N5_ef_11.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N6_VFX_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N6_VFX_01.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2020.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Butcher_N6_VFX_04.blp
#    lúc tung (trên tướng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\HellscreamW2.blp
#    lớp thêm tại điểm 1: HSQ_chankhihothe.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_glow2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon1X.blp
#         texture: VLTK_data\KVCT3_Data\AZ_WhiteFire6x6.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave31.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1t.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 10. Huyền Nhãn Yên Vân [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tukhidl.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a01.blp
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a02.blp
#
# 11. Phách Thạch Phá Ngọc [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_phachthach.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\effect_anranxiaohunzhang.blp
#         texture: VLTK_data\KVCT3_Data\effect_anranxiaohunzhang02.blp
#         texture: VLTK_data\KVCT3_Data\effect_anranxiaohunzhang03.blp
#         texture: Textures\GenericGlow2c.blp
#    lúc tung (trên tướng): HSQ_caster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Glow.blp
#         texture: VLTK_data\KVCT3_Data\GlowBlack2.blp
#         texture: VLTK_data\KVCT3_Data\Zap2.blp
#         texture: VLTK_data\KVCT3_Data\Ribbon3.blp
#    trên địch bị trúng: Abilities\Weapons\VoidWalkerMissile\VoidWalkerMissile.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: VLTK_data\KVCT3_Data\AZ_star2.blp
#    lớp thêm tại điểm 2: HSQ_phangoc2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 12. Thần Quang Toàn Nhiễu [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1_White.blp
#
# 13. Tử Khí Đông Lai [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tukhidl.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a01.blp
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a02.blp
# ===== HẾT DANH MỤC =====
