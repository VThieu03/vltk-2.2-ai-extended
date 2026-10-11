# MGK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Thánh Hỏa Phần Tâm": {   # [Q] KVCT: chỉ MGK_thanhhoapt (hàm JEv), không có lớp cast / buff / area
        "main": "MGK_thanhhoapt.mdx",
        "cast": "MGK_thanhhoacast.mdx",
        "target": "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl",
    },
    "Minh Giáo Kiếm Pháp": {   # [bị động]
        "main": "",
    },
    "Di Khí Phiêu Tung": {   # [bị động]
        "main": "",
    },
    "Vạn Vật Câu Phần": {   # [W]
        "main": "MGK_effect1.mdx",
        "target": "MGK_effect1.mdx",
        "cast": "MGK_effect1.mdx",
        "area": ["MGK_effect1.mdx"],
    },
    "Càn Khôn Đại Na Di": {   # [D]
        "main": "MGK_cankhonbuff.mdx",
        "cast": "MGK_cankhoncaster.mdx",
    },
    "Ly Hỏa Đại Pháp": {   # [bị động]
        "main": "",
    },
    "Thánh Hỏa Liêu Nguyên": {   # [E] KVCT: thanhhoaln rơi xuống, nổ effect1 lúc chạm đất, thanhhoaeffect trên tướng lúc tung (hàm JCc / JCh / JCp)
        "main": "MGK_thanhhoaln.mdx",
        "cast": "MGK_thanhhoaeffect.mdx",
        "area": ["MGK_effect1.mdx"],
        "target": "MGK_effect1.mdx",
    },
    "Thánh Hỏa Lệnh Pháp": {   # [F] KVCT: CasterArt thanhhoacast (A095), buff thanhhoalenhbuff (A096)
        "main": "MGK_thanhhoalenhbuff.mdx",
        "cast": "MGK_thanhhoacast.mdx",
    },
    "Nhân Huân Tử Khí": {   # [bị động]
        "main": "",
    },
    "Hoang Hỏa Ngọc Phần": {   # [bị động]
        "main": "",
    },
    "Kiếm Đãng Bát Hoang": {   # [R]
        "main": "MGK_kiemdangbathoang.mdx",
    },
    "Thánh Hỏa Thần Công": {   # [bị động]
        "main": "",
    },
    "Mục Dã Ưng Dương": {   # [bị động]
        "main": "",
    },
}

# Giữ texture gốc của model KVCT; không đổi hiệu ứng hệ độc thành lửa.
TEXTURES = {}

# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) =====
# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:
#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}
#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\Flame4.blp"}
#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)
# Sửa xong chạy lại pipeline (tools/pipeline.py) để áp dụng.
#
# 1. Thánh Hỏa Phần Tâm [Q]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoapt.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Abilities\Spells\Demon\DarkPortal\DemonRune1backup.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\Flame4.blp
#    trên địch bị trúng: Abilities\Weapons\SkeletalMageMissile\SkeletalMageMissile.mdl   [model gốc Warcraft III]
#    buff (trên tướng): MGK_thanhhoalenhbuff.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlow64.blp
#
# 2. Minh Giáo Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_heroglow_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp
#         texture: VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp
#
# 3. Di Khí Phiêu Tung [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#
# 4. Vạn Vật Câu Phần [W]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): Abilities\Spells\NightElf\Immolation\ImmolationTarget.mdl   [model gốc Warcraft III]
#    lúc tung (trên tướng): Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: Abilities\Spells\Other\AcidBomb\BottleImpact.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl   [model gốc Warcraft III]
#
# 5. Càn Khôn Đại Na Di [D]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_cankhonbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\SacredTail11.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple_bw.blp
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
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#
# 7. Thánh Hỏa Liêu Nguyên [E]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#    lúc tung (trên tướng): MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
#    trên địch bị trúng: Abilities\Spells\Other\AcidBomb\BottleImpact.mdl   [model gốc Warcraft III]
#    buff (trên tướng): MGK_thanhhoalenhbuff.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlow64.blp
#    lớp thêm tại điểm 1: MGK_effect1.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#
# 8. Thánh Hỏa Lệnh Pháp [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoalenhbuff.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\FlamingArrow\fire10022.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlow64.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\Flame4.blp
#
# 9. Nhân Huân Tử Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaln.mdx   [riêng phái]
#         texture: Textures\Clouds8x8ModFire.blp
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\LavaLump2.blp
#
# 10. Hoang Hỏa Ngọc Phần [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_heroglow_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp
#         texture: VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp
#
# 11. Kiếm Đãng Bát Hoang [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_kiemdangbathoang.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_ribbon1_green.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Energy_Wave.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9_blur_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_groundglow2_darkgreen.blp
#         texture: VLTK_data\KVCT3_Data\Wind_RevenantSword_diff.blp
#         texture: VLTK_data\KVCT3_Data\Wind_Groundcrackh_alpha_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave_line1a_splat_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_starlight1_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon2_tail_a_cyan.blp
#         texture: VLTK_data\KVCT3_Data\Wind_ribbon3b_tail_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_heroglow_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave7a_blur_w.blp
#         texture: VLTK_data\KVCT3_Data\Wind_shockwave9b_line_bw.blp
#         texture: VLTK_data\KVCT3_Data\Wind_glowgreen2a.blp
#         texture: VLTK_data\KVCT3_Data\Wind_zaplight_1_tail_w.blp
#    trên địch bị trúng: Abilities\Spells\Other\AcidBomb\BottleImpact.mdl   [model gốc Warcraft III]
#
# 12. Thánh Hỏa Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanhHoa.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\CloudSingle.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Clouds8x8ModFire.blp
#    lúc tung (trên tướng): MGK_thanhhoacast.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\Flame4.blp
#
# 13. Mục Dã Ưng Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGK_thanhhoaeffect.mdx   [riêng phái]
#         texture: Textures\Flame4.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Shockwave1.blp
# ===== HẾT DANH MỤC =====
