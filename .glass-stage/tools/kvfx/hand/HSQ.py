# HSQ: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/HSQ.py). Sửa file này rồi chạy lại pipeline.
VFX = {
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
# 1. Thanh Vân Tống Sảng [Q]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_thanhvan.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#    lúc tung (trên tướng): HSQ_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Glow.blp
#         texture: KVCT3_Data\GlowBlack2.blp
#         texture: KVCT3_Data\Zap2.blp
#         texture: KVCT3_Data\Ribbon3.blp
#
# 2. Hoa Sơn Khí Công [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_Shockwave1_White.blp
#
# 3. Long Nhiễu Thân [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: KVCT3_Data\AZ_star2.blp
#
# 4. Chân Khí Hộ Thể [R]   (kind 8, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\HellscreamW2.blp
#    lúc tung (trên tướng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\HellscreamW2.blp
#
# 5. Hải Nạp Bách Xuyên [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_Shockwave1_White.blp
#
# 6. Khí Chấn Sơn Hà [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_phangoc.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 7. Ma Vân Kiếm Khí [W]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_mavansword.mdx   [riêng phái]
#         texture: Textures\Star7b.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Dust5A.blp
#         texture: KVCT3_Data\wx_jian4.blp
#    lúc tung (trên tướng): HSQ_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Glow.blp
#         texture: KVCT3_Data\GlowBlack2.blp
#         texture: KVCT3_Data\Zap2.blp
#         texture: KVCT3_Data\Ribbon3.blp
#    lớp thêm tại điểm 1: HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: KVCT3_Data\AZ_star2.blp
#
# 8. Khí Quán Trường Hồng [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_thanhvan.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 9. Tử Hà Chân Khí [D]   (kind 8, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tuhachankhi.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_03.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_05.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_11.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_02.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_01.blp
#         texture: KVCT3_Data\TX_Star2020.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_04.blp
#    lúc tung (trên tướng): HSQ_chankhihothecast.mdx   [riêng phái]
#         texture: KVCT3_Data\HellscreamW.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\HellscreamW2.blp
#    lớp thêm tại điểm 1: HSQ_chankhihothe.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_glow2.blp
#         texture: KVCT3_Data\AZ_Ribbon1X.blp
#         texture: KVCT3_Data\AZ_WhiteFire6x6.blp
#         texture: KVCT3_Data\AZ_Shockwave31.blp
#         texture: KVCT3_Data\AZ_Shockwave1t.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 10. Huyền Nhãn Yên Vân [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tukhidl.mdx   [riêng phái]
#         texture: KVCT3_Data\GameBABY_ss422a01.blp
#         texture: KVCT3_Data\GameBABY_ss422a02.blp
#
# 11. Phách Thạch Phá Ngọc [E]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_phachthach.mdx   [riêng phái]
#         texture: KVCT3_Data\effect_anranxiaohunzhang.blp
#         texture: KVCT3_Data\effect_anranxiaohunzhang02.blp
#         texture: KVCT3_Data\effect_anranxiaohunzhang03.blp
#         texture: Textures\GenericGlow2c.blp
#    lúc tung (trên tướng): HSQ_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Glow.blp
#         texture: KVCT3_Data\GlowBlack2.blp
#         texture: KVCT3_Data\Zap2.blp
#         texture: KVCT3_Data\Ribbon3.blp
#    lớp thêm tại điểm 1: HSQ_mavankk2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_RiBbon_White02.blp
#         texture: KVCT3_Data\AZ_Smoke12.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: KVCT3_Data\AZ_Glow04.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: KVCT3_Data\AZ_star2.blp
#    lớp thêm tại điểm 2: HSQ_phangoc2.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N2S_D_Smoke1E.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_hand.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow1.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_star.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_D_glow2.blp
#         texture: KVCT3_Data\Hero_Undying_N2S_Smoke2_8x8.blp
#
# 12. Thần Quang Toàn Nhiễu [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_hainapbachxuyen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star32.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_Shockwave1_White.blp
#
# 13. Tử Khí Đông Lai [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSQ_tukhidl.mdx   [riêng phái]
#         texture: KVCT3_Data\GameBABY_ss422a01.blp
#         texture: KVCT3_Data\GameBABY_ss422a02.blp
# ===== HẾT DANH MỤC =====
