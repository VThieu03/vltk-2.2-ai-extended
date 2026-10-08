# DMPD: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Tiểu Lý Phi Đao': {'main': 'DMPD_phidao1.mdx'},   # [Q]
    'Đường Môn Ám Khí': {'main': 'DMPD_manthienhoavu1.mdx'},   # [bị động]
    'Mê Ảnh Tung': {'main': 'DMPD_anhtungtran.mdx', 'cast': 'DMPD_anhtungtrancast.mdx', 'buff': 'DMPD_anhtungtranaura.mdx'},   # [F]
    'Tôi Độc Thuật': {'main': 'DMPD_manthienhoavu3.mdx', 'aura': 'DMTT_toidocaura.mdx'},   # [bị động]
    'Mãn Thiên Hoa Vũ': {'main': 'DMPD_manthienhoavu1.mdx', 'area': ['DMPD_manthienhoavu2.mdx', 'DMPD_manthienhoavu3.mdx']},   # [R]
    'Tâm Nhãn': {'main': 'MDX\\TamNhan.mdx'},   # [bị động]
    'Nhiếp Hồn Nguyệt Ảnh': {'main': 'DMPD_nhiephonwave1_1.mdx', 'target': 'DMPD_nhiephontarget.mdx', 'area': ['DMPD_nhiephonwave2_1.mdx'], 'target_ground': True},   # [W]
    'Hàm Sa Xạ Ảnh': {'main': 'DMPD_phidao1.mdx'},   # [bị động]
    'Thực Cốt Huyết Nhẫn': {'main': 'DMPD_voanhxuyen.mdx'},   # [bị động]
    'Ảnh Tung Trận': {'main': 'DMPD_anhtungtranaura.mdx', 'cast': 'DMPD_anhtungtrancast.mdx', 'area': ['DMPD_anhtungtran.mdx']},   # [D]
    'Vô Ảnh Xuyên': {'main': 'DMPD_voanhxuyen.mdx', 'area': ['DMPD_voanhxuyen_11.mdx', 'DMPD_voanhxuyen_2.mdx']},   # [E]
    'Tâm Phách': {'main': 'DMPD_voanhxuyen_111.mdx'},   # [bị động]
    'Bách Phát Bách Trúng': {'main': 'DMPD_voanhxuyen_1111.mdx'},   # [bị động]
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
# 1. Tiểu Lý Phi Đao [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_phidao1.mdx   [riêng phái]
#         texture: Buildings\Other\DragonBuildingBlue\DragonRoostBlue.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Clouds8x8Fade.blp
#
# 2. Đường Môn Ám Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_manthienhoavu1.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp
#
# 3. Mê Ảnh Tung [F]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_anhtungtran.mdx   [riêng phái, phái khác cũng dùng: DMPT]
#         texture: Buildings\Human\AltarOfKings\AltarOfKings.blp
#         texture: Buildings\Human\HumanLumberMill\HumanLumberMill.blp
#         texture: KVCT3_Data\OrderFlag3.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\wavering_bw.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\smoke_bw.blp
#         texture: KVCT3_Data\flarering_bw.blp
#         texture: KVCT3_Data\flaresimple01_bw.blp
#         texture: KVCT3_Data\flareshot01_bw.blp
#         texture: KVCT3_Data\flaresimple02_bw.blp
#         texture: UI\MiniMap\ping4.blp
#    lúc tung (trên tướng): DMPD_anhtungtrancast.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\White_64_Foam1.blp
#    buff (trên tướng): DMPD_anhtungtranaura.mdx   [riêng phái, phái khác cũng dùng: DMPT]
#         texture: KVCT3_Data\mofazhendizuo2.blp
#
# 4. Tôi Độc Thuật [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_manthienhoavu3.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp
#    aura bị động (gắn tướng suốt): DMTT_toidocaura.mdx   [dùng chung (cùng dùng: DMPT, DMTT)]
#         texture: KVCT3_Data\VenArt.BLP
#
# 5. Mãn Thiên Hoa Vũ [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_manthienhoavu1.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp
#    lớp thêm tại điểm 1: DMPD_manthienhoavu2.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp
#    lớp thêm tại điểm 2: DMPD_manthienhoavu3.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\feather.blp
#
# 6. Tâm Nhãn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\TamNhan.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: DMPT, DMTT)]
#         texture: Textures\Energy1Color.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Yellow_Star.blp
#
# 7. Nhiếp Hồn Nguyệt Ảnh [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_nhiephonwave1_1.mdx   [riêng phái]
#         texture: KVCT3_Data\nhiepanh.blp
#    trên địch bị trúng: DMPD_nhiephontarget.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp
#         texture: Textures\Shockwave1White.blp
#    lớp thêm tại điểm 1: DMPD_nhiephonwave2_1.mdx   [riêng phái]
#         texture: KVCT3_Data\nhiepanh.blp
#
# 8. Hàm Sa Xạ Ảnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_phidao1.mdx   [riêng phái]
#         texture: Buildings\Other\DragonBuildingBlue\DragonRoostBlue.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Clouds8x8Fade.blp
#
# 9. Thực Cốt Huyết Nhẫn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_voanhxuyen.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_object_Darts.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: KVCT3_Data\AZ_GlowBlue.blp
#         texture: KVCT3_Data\AZ_Shockwave1U.blp
#         texture: KVCT3_Data\AZ_Shockwave2.blp
#         texture: KVCT3_Data\AZ_RibbonNK2.blp
#         texture: KVCT3_Data\Nortrom_Aghanim.blp
#         texture: KVCT3_Data\HeroNortrom6.blp
#
# 10. Ảnh Tung Trận [D]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_anhtungtranaura.mdx   [riêng phái, phái khác cũng dùng: DMPT]
#         texture: KVCT3_Data\mofazhendizuo2.blp
#    lúc tung (trên tướng): DMPD_anhtungtrancast.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\White_64_Foam1.blp
#    lớp thêm tại điểm 1: DMPD_anhtungtran.mdx   [riêng phái, phái khác cũng dùng: DMPT]
#         texture: Buildings\Human\AltarOfKings\AltarOfKings.blp
#         texture: Buildings\Human\HumanLumberMill\HumanLumberMill.blp
#         texture: KVCT3_Data\OrderFlag3.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\wavering_bw.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\smoke_bw.blp
#         texture: KVCT3_Data\flarering_bw.blp
#         texture: KVCT3_Data\flaresimple01_bw.blp
#         texture: KVCT3_Data\flareshot01_bw.blp
#         texture: KVCT3_Data\flaresimple02_bw.blp
#         texture: UI\MiniMap\ping4.blp
#
# 11. Vô Ảnh Xuyên [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_voanhxuyen.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_object_Darts.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: KVCT3_Data\AZ_GlowBlue.blp
#         texture: KVCT3_Data\AZ_Shockwave1U.blp
#         texture: KVCT3_Data\AZ_Shockwave2.blp
#         texture: KVCT3_Data\AZ_RibbonNK2.blp
#         texture: KVCT3_Data\Nortrom_Aghanim.blp
#         texture: KVCT3_Data\HeroNortrom6.blp
#    lớp thêm tại điểm 1: DMPD_voanhxuyen_11.mdx   [riêng phái]
#         texture: KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp
#         texture: KVCT3_Data\garen_skin11_r_swordcolor.blp
#         texture: KVCT3_Data\garen_skin11_r_swordblur.blp
#         texture: KVCT3_Data\Wind_ribbon_beam_color.blp
#         texture: KVCT3_Data\Wind_Cloud_2x2_cartoon.blp
#         texture: KVCT3_Data\Wind_Cracks_glow_v2.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_shockwave4_Ring_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_glow_v2_blur_green.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_Ember4_2x4_w.blp
#         texture: KVCT3_Data\Ember_1bFx_4x4.blp
#    lớp thêm tại điểm 2: DMPD_voanhxuyen_2.mdx   [riêng phái]
#         texture: KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp
#         texture: KVCT3_Data\garen_skin11_r_swordcolor.blp
#         texture: KVCT3_Data\garen_skin11_r_swordblur.blp
#         texture: KVCT3_Data\Wind_ribbon_beam_color.blp
#         texture: KVCT3_Data\Wind_Cloud_2x2_cartoon.blp
#         texture: KVCT3_Data\Wind_Cracks_glow_v2.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_shockwave4_Ring_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_glow_v2_blur_green.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_Ember4_2x4_w.blp
#         texture: KVCT3_Data\Ember_1bFx_4x4.blp
#
# 12. Tâm Phách [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_voanhxuyen_111.mdx   [riêng phái]
#         texture: KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp
#         texture: KVCT3_Data\garen_skin11_r_swordcolor.blp
#         texture: KVCT3_Data\garen_skin11_r_swordblur.blp
#         texture: KVCT3_Data\Wind_ribbon_beam_color.blp
#         texture: KVCT3_Data\Wind_Cloud_2x2_cartoon.blp
#         texture: KVCT3_Data\Wind_Cracks_glow_v2.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_shockwave4_Ring_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_glow_v2_blur_green.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_Ember4_2x4_w.blp
#         texture: KVCT3_Data\Ember_1bFx_4x4.blp
#
# 13. Bách Phát Bách Trúng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_voanhxuyen_1111.mdx   [riêng phái]
#         texture: KVCT3_Data\garen_skin11_r_swordcoloralphablend.blp
#         texture: KVCT3_Data\garen_skin11_r_swordcolor.blp
#         texture: KVCT3_Data\garen_skin11_r_swordblur.blp
#         texture: KVCT3_Data\Wind_ribbon_beam_color.blp
#         texture: KVCT3_Data\Wind_Cloud_2x2_cartoon.blp
#         texture: KVCT3_Data\Wind_Cracks_glow_v2.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_shockwave4_Ring_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_glow_v2_blur_green.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_Ember4_2x4_w.blp
#         texture: KVCT3_Data\Ember_1bFx_4x4.blp
# ===== HẾT DANH MỤC =====
