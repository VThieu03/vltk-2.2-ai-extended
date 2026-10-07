# DMTT: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/DMTT.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Thiên La Địa Võng': {'main': 'DMTT_doancannhan.mdx', 'area': ['DMTT_tanghondinh.mdx', 'HydraliskImpact.mdx']},   # [Q]
    'Đường Môn Ám Khí': {'main': 'DMTT_baovucham.mdx'},   # [bị động]
    'Mê Ảnh Tung': {'main': 'DMTT_doancannhan.mdx'},   # [F]
    'Tôi Độc Thuật': {'main': 'DMTT_toidocaura.mdx', 'aura': 'DMTT_toidocaura.mdx'},   # [bị động]
    'Đoạn Cân Nhẫn': {'main': 'DMTT_doancannhan.mdx', 'area': ['DMTT_tanghondinh.mdx', 'HydraliskImpact.mdx']},   # [R]
    'Tâm Nhãn': {'main': 'MDX\\TamNhan.mdx'},   # [bị động]
    'Bạo Vũ Lê Hoa': {'main': 'DMTT_baovu.mdx', 'area': ['DMTT_baovucham.mdx', 'HydraliskImpact.mdx']},   # [W]
    'Xuyên Vân Tiễn': {'main': 'DMTT_xuyenvantientarget.mdx'},   # [D]
    'Thất Tuyệt Sát Quang': {'main': 'MDX\\ThatTuyetSatQuang.mdx', 'buff': 'DMTT_phuquangluocanhbuff.mdx'},   # [bị động]
    'Tang Hồn Đinh': {'main': 'DMTT_tanghondinh.mdx'},   # [bị động]
    'Khổng Tước Vũ': {'main': 'DMTT_khongtuocvu1.mdx', 'area': ['DMTT_khongtuocvu3.mdx', 'DMTT_khongtuocvu2.mdx']},   # [E]
    'Tâm Ma': {'main': 'DMTT_doancannhan.mdx'},   # [bị động]
    'Phù Quang Lược Ảnh': {'main': 'DMTT_phuquangluocanhbuff.mdx'},   # [bị động]
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
# 1. Thiên La Địa Võng [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_doancannhan.mdx   [riêng phái]
#         texture: KVCT3_Data\HapTinhTran.BLP
#    lớp thêm tại điểm 1: DMTT_tanghondinh.mdx   [riêng phái]
#         texture: KVCT3_Data\HELLFIRE_RUNE.BLP
#         texture: KVCT3_Data\AURARUNE3_MIP1.BLP
#         texture: KVCT3_Data\GRADIENT64FLIPA.BLP
#         texture: textures\FLARE.BLP
#         texture: textures\STAR8B.BLP
#    lớp thêm tại điểm 2: HydraliskImpact.mdx   [dùng chung (cùng dùng: TLQ, TVT)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#
# 2. Đường Môn Ám Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_baovucham.mdx   [riêng phái]
#         texture: Textures\star6.blp
#         texture: Textures\Shockwave1white.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Abilities\Spells\Other\TinkerRocket\TinkerRocketRibbon.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\star2.blp
#         texture: Textures\ShockwaveWater1Black.blp
#
# 3. Mê Ảnh Tung [F]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_doancannhan.mdx   [riêng phái]
#         texture: KVCT3_Data\HapTinhTran.BLP
#
# 4. Tôi Độc Thuật [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_toidocaura.mdx   [riêng phái, phái khác cũng dùng: DMPD, DMPT]
#         texture: KVCT3_Data\VenArt.BLP
#    aura bị động (gắn tướng suốt): DMTT_toidocaura.mdx   [riêng phái, phái khác cũng dùng: DMPD, DMPT]
#         texture: KVCT3_Data\VenArt.BLP
#
# 5. Đoạn Cân Nhẫn [R]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_doancannhan.mdx   [riêng phái]
#         texture: KVCT3_Data\HapTinhTran.BLP
#    lớp thêm tại điểm 1: DMTT_tanghondinh.mdx   [riêng phái]
#         texture: KVCT3_Data\HELLFIRE_RUNE.BLP
#         texture: KVCT3_Data\AURARUNE3_MIP1.BLP
#         texture: KVCT3_Data\GRADIENT64FLIPA.BLP
#         texture: textures\FLARE.BLP
#         texture: textures\STAR8B.BLP
#    lớp thêm tại điểm 2: HydraliskImpact.mdx   [dùng chung (cùng dùng: TLQ, TVT)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#
# 6. Tâm Nhãn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\TamNhan.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: DMPD, DMPT)]
#         texture: Textures\Energy1Color.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Yellow_Star.blp
#
# 7. Bạo Vũ Lê Hoa [W]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_baovu.mdx   [riêng phái]
#         texture: Textures\GlaiveThrower.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\star2.blp
#    lớp thêm tại điểm 1: DMTT_baovucham.mdx   [riêng phái]
#         texture: Textures\star6.blp
#         texture: Textures\Shockwave1white.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Abilities\Spells\Other\TinkerRocket\TinkerRocketRibbon.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\star2.blp
#         texture: Textures\ShockwaveWater1Black.blp
#    lớp thêm tại điểm 2: HydraliskImpact.mdx   [dùng chung (cùng dùng: TLQ, TVT)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#
# 8. Xuyên Vân Tiễn [D]   (kind 1, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_xuyenvantientarget.mdx   [riêng phái]
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\Flare.blp
#
# 9. Thất Tuyệt Sát Quang [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThatTuyetSatQuang.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Ghost2.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\Flame4.blp
#    buff (trên tướng): DMTT_phuquangluocanhbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_flaresimple_w.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_flareline_w.blp
#         texture: KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp
#
# 10. Tang Hồn Đinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_tanghondinh.mdx   [riêng phái]
#         texture: KVCT3_Data\HELLFIRE_RUNE.BLP
#         texture: KVCT3_Data\AURARUNE3_MIP1.BLP
#         texture: KVCT3_Data\GRADIENT64FLIPA.BLP
#         texture: textures\FLARE.BLP
#         texture: textures\STAR8B.BLP
#
# 11. Khổng Tước Vũ [E]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_khongtuocvu1.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave1U.blp
#         texture: KVCT3_Data\AZ_Shockwave2.blp
#         texture: KVCT3_Data\chenmoshushi.blp
#         texture: KVCT3_Data\AZ_Star2_1x4.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flare10.blp
#         texture: Textures\Dust3.blp
#    lớp thêm tại điểm 1: DMTT_khongtuocvu3.mdx   [riêng phái]
#         texture: KVCT3_Data\Shockwave_AA1.blp
#         texture: Textures\sun.blp
#         texture: KVCT3_Data\EarthSpirit_wave5.blp
#         texture: KVCT3_Data\Shockwave_A1.blp
#         texture: KVCT3_Data\AZ_Flare1W.blp
#         texture: KVCT3_Data\AZ_RibbonNE2W.blp
#    lớp thêm tại điểm 2: DMTT_khongtuocvu2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Ribbon14.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\RibbonBlur1.blp
#         texture: KVCT3_Data\AZ_Stone3_6x6.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Ribbon_007.blp
#         texture: KVCT3_Data\AZ_Flare10.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#
# 12. Tâm Ma [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_doancannhan.mdx   [riêng phái]
#         texture: KVCT3_Data\HapTinhTran.BLP
#
# 13. Phù Quang Lược Ảnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMTT_phuquangluocanhbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_flaresimple_w.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_flareline_w.blp
#         texture: KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp
# ===== HẾT DANH MỤC =====
