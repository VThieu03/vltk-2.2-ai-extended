# CMC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Biệt Tự': {'main': 'CMC_lyhan.mdx'},   # [Q]
    'Mộ Châm Pháp': {'main': 'CMC_bisau.mdx'},   # [bị động]
    'Kinh Hồng Chiếu Ảnh': {'main': 'CMC_kinhhong.mdx'},   # [R]
    'Súc Thế Đãi Phát': {'main': 'CMC_sucthedaiphat.mdx'},   # [bị động]
    'Ngọc Phong Châm': {'main': 'CMC_ngocphongcham.mdx', 'target': 'CMC_ngocphongtarget.mdx', 'buff': 'CMC_ngocphongbuff.mdx'},   # [D]
    'Lưu Vân Pháp': {'main': 'CMC_hoangtuyentarget.mdx'},   # [bị động]
    'Ly Hận': {'main': 'CMC_lyhan.mdx'},   # [W]
    'Hoàng Tuyền Lảo Đảo': {'main': 'CMC_hoangtuyencham.mdx', 'target': 'CMC_hoangtuyentarget.mdx', 'target_ground': True},   # [F]
    'Hành Vân Đới Vũ': {'main': 'CMC_minhchauamdau.mdx'},   # [bị động]
    'Vụ Tập Vân Hợp': {'main': 'CMC_vutapvanhop.mdx'},   # [T]
    'Bi Sầu': {'main': 'CMC_cham5_5.mdx', 'target': 'CMC_chamtarget.mdx', 'area': ['CMC_bisau.mdx', 'CMC_lyhan.mdx'], 'target_ground': True},   # [E]
    'Phong Lưu Vân Tán': {'main': 'CMC_ngocphongbuff.mdx', 'target': 'CMC_ngocphongtarget.mdx', 'area': ['CMC_ngocphongcham.mdx']},   # [bị động]
    'Mê Thần Dẫn': {'main': 'CMC_sucthedaiphat.mdx'},   # [bị động]
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
# 1. Biệt Tự [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_lyhan.mdx   [riêng phái]
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Lanaya_D2.BLP
#         texture: KVCT3_Data\Lanaya_D.BLP
#
# 2. Mộ Châm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_bisau.mdx   [riêng phái]
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
# 3. Kinh Hồng Chiếu Ảnh [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_kinhhong.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\GenericGlow64.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp
#         texture: Abilities\Spells\Undead\VampiricAura\AuraRune6.blp
#         texture: ReplaceableTextures\Selection\SelectionCircleLarge.blp
#
# 4. Súc Thế Đãi Phát [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_sucthedaiphat.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_White.blp
#         texture: KVCT3_Data\AZ_Flashb17.blp
#         texture: KVCT3_Data\AZ_Splast22.blp
#         texture: KVCT3_Data\Morgana_Base_E_Shield_Glow.blp
#         texture: KVCT3_Data\Morgana_Base_Q_Mis_Core.blp
#
# 5. Ngọc Phong Châm [D]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_ngocphongcham.mdx   [riêng phái]
#         texture: KVCT3_Data\diezhen.blp
#         texture: textures\Purple_Glow.blp
#    trên địch bị trúng: CMC_ngocphongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#    buff (trên tướng): CMC_ngocphongbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow2c.blp
#
# 6. Lưu Vân Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_hoangtuyentarget.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_b.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_b.blp
#         texture: KVCT3_Data\txx110_4_b.blp
#         texture: KVCT3_Data\txx110_2_b.blp
#         texture: KVCT3_Data\txx110_3_b.blp
#
# 7. Ly Hận [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_lyhan.mdx   [riêng phái]
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Lanaya_D2.BLP
#         texture: KVCT3_Data\Lanaya_D.BLP
#
# 8. Hoàng Tuyền Lảo Đảo [F]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_hoangtuyencham.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Flare.blp
#         texture: Textures\CloudSingle.blp
#         texture: Textures\snowflake2.blp
#         texture: Textures\Frost2.blp
#         texture: Textures\star2.blp
#    trên địch bị trúng: CMC_hoangtuyentarget.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_b.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_b.blp
#         texture: KVCT3_Data\txx110_4_b.blp
#         texture: KVCT3_Data\txx110_2_b.blp
#         texture: KVCT3_Data\txx110_3_b.blp
#
# 9. Hành Vân Đới Vũ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_minhchauamdau.mdx   [riêng phái]
#         texture: KVCT3_Data\huanrao_dun_01.blp
#         texture: KVCT3_Data\huanrao_dun_02.blp
#         texture: KVCT3_Data\huanrao_dun_03.blp
#
# 10. Vụ Tập Vân Hợp [T]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_vutapvanhop.mdx   [riêng phái]
#         texture: KVCT3_Data\Wind_flaresimple_w.blp
#         texture: KVCT3_Data\Wind_flare2_w.blp
#         texture: KVCT3_Data\Wind_heroglow_w.blp
#         texture: KVCT3_Data\Wind_flareline_w.blp
#         texture: KVCT3_Data\Wind_RibbonflareLine1b_yellowgreen.blp
#
# 11. Bi Sầu [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_cham5_5.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Ribbon14.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\RibbonBlur1.blp
#         texture: KVCT3_Data\AZ_Stone3_6x6.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Ribbon_007.blp
#         texture: KVCT3_Data\AZ_Flare10.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#    trên địch bị trúng: CMC_chamtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Ribbon14.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\RibbonBlur1.blp
#         texture: KVCT3_Data\AZ_Stone3_6x6.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Ribbon_007.blp
#         texture: KVCT3_Data\AZ_Flare10.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#    lớp thêm tại điểm 1: CMC_bisau.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Ribbon14.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\RibbonBlur1.blp
#         texture: KVCT3_Data\AZ_Stone3_6x6.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Ribbon_007.blp
#         texture: KVCT3_Data\AZ_Flare10.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#    lớp thêm tại điểm 2: CMC_lyhan.mdx   [riêng phái]
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Lanaya_D2.BLP
#         texture: KVCT3_Data\Lanaya_D.BLP
#
# 12. Phong Lưu Vân Tán [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_ngocphongbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow2c.blp
#    trên địch bị trúng: CMC_ngocphongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#    lớp thêm tại điểm 1: CMC_ngocphongcham.mdx   [riêng phái]
#         texture: KVCT3_Data\diezhen.blp
#         texture: textures\Purple_Glow.blp
#
# 13. Mê Thần Dẫn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMC_sucthedaiphat.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_White.blp
#         texture: KVCT3_Data\AZ_Flashb17.blp
#         texture: KVCT3_Data\AZ_Splast22.blp
#         texture: KVCT3_Data\Morgana_Base_E_Shield_Glow.blp
#         texture: KVCT3_Data\Morgana_Base_Q_Mis_Core.blp
# ===== HẾT DANH MỤC =====
