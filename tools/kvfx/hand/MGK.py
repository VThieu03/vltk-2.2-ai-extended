# MGK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/MGK.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Thánh Hỏa Phần Tâm': {'main': 'MDX\\ThanhHoaPhanTam.mdx', 'cast': 'MGK_thanhhoacast.mdx', 'buff': 'MGK_thanhhoalenhbuff.mdx', 'area': ['MGK_thanhhoaeffect.mdx', 'MGK_thanhhoaln.mdx']},   # [Q]
    'Minh Giáo Kiếm Pháp': {'main': 'MGK_kiemdangbathoang.mdx'},   # [bị động]
    'Di Khí Phiêu Tung': {'main': 'MGK_thanhhoaeffect.mdx'},   # [bị động]
    'Vạn Vật Câu Phần': {'main': 'MDX\\VanVat.mdx'},   # [W]
    'Càn Khôn Đại Na Di': {'main': 'MGK_cankhonbuff.mdx', 'cast': 'MGK_cankhoncaster.mdx'},   # [D]
    'Ly Hỏa Đại Pháp': {'main': 'MGK_effect1.mdx'},   # [bị động]
    'Thánh Hỏa Liêu Nguyên': {'main': 'MGK_thanhhoaln.mdx', 'cast': 'MGK_thanhhoacast.mdx', 'buff': 'MGK_thanhhoalenhbuff.mdx', 'area': ['MGK_thanhhoaeffect.mdx']},   # [E]
    'Thánh Hỏa Lệnh Pháp': {'main': 'MDX\\ThanhHoa.mdx', 'cast': 'MGK_thanhhoacast.mdx', 'area': ['MGK_thanhhoaln.mdx', 'MGK_thanhhoaeffect.mdx']},   # [F]
    'Nhân Huân Tử Khí': {'main': 'MGK_thanhhoaln.mdx'},   # [bị động]
    'Hoang Hỏa Ngọc Phần': {'main': 'MGK_kiemdangbathoang.mdx'},   # [bị động]
    'Kiếm Đãng Bát Hoang': {'main': 'MGK_kiemdangbathoang.mdx'},   # [R]
    'Thánh Hỏa Thần Công': {'main': 'MDX\\ThanhHoa.mdx', 'cast': 'MGK_thanhhoacast.mdx', 'area': ['MGK_thanhhoaeffect.mdx', 'MGK_thanhhoaln.mdx']},   # [bị động]
    'Mục Dã Ưng Dương': {'main': 'MGK_thanhhoaeffect.mdx'},   # [bị động]
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
# 1. Thánh Hỏa Phần Tâm [Q]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanhHoaPhanTam.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Abilities\Spells\Demon\DarkPortal\DemonRune1backup.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\star2.blp
#    buff (trên tướng): MGK_thanhhoalenhbuff.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlow64.blp
#    lớp thêm tại điểm 1: MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#    lớp thêm tại điểm 2: MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#
# 2. Minh Giáo Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_starlight1_bw.blp
#         texture: KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: KVCT3_Data\Wind_glowgreen2a.blp
#         texture: KVCT3_Data\Wind_zaplight_1_tail_w.blp
#
# 3. Di Khí Phiêu Tung [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#
# 4. Vạn Vật Câu Phần [W]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\VanVat.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\CloudSingle.blp
#
# 5. Càn Khôn Đại Na Di [D]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_cankhonbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\SacredTail11.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\flaresimple_bw.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave10.blp
#    lúc tung (trên tướng): MGK_cankhoncaster.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Buildings\Other\FountainOfLifeBlood\FlareBlood.blp
#
# 6. Ly Hỏa Đại Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_effect1.mdx   [riêng phái]
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
# 7. Thánh Hỏa Liêu Nguyên [E]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\star2.blp
#    buff (trên tướng): MGK_thanhhoalenhbuff.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlow64.blp
#    lớp thêm tại điểm 1: MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#
# 8. Thánh Hỏa Lệnh Pháp [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanhHoa.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Clouds8x8ModFire.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\star2.blp
#    lớp thêm tại điểm 1: MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#    lớp thêm tại điểm 2: MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#
# 9. Nhân Huân Tử Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#
# 10. Hoang Hỏa Ngọc Phần [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_starlight1_bw.blp
#         texture: KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: KVCT3_Data\Wind_glowgreen2a.blp
#         texture: KVCT3_Data\Wind_zaplight_1_tail_w.blp
#
# 11. Kiếm Đãng Bát Hoang [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: KVCT3_Data\Wind_Energy_Wave.blp
#         texture: KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: KVCT3_Data\Wind_starlight1_bw.blp
#         texture: KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: KVCT3_Data\Wind_glowgreen2a.blp
#         texture: KVCT3_Data\Wind_zaplight_1_tail_w.blp
#
# 12. Thánh Hỏa Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanhHoa.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Clouds8x8ModFire.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\star2.blp
#    lớp thêm tại điểm 1: MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#    lớp thêm tại điểm 2: MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#
# 13. Mục Dã Ưng Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
# ===== HẾT DANH MỤC =====
