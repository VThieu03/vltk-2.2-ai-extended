# CMK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Thu Nhạn Bàng Hoàng': {'main': 'CMK_thunhan.mdx', 'target': 'CMK_target1.mdx', 'area': ['CMK_chungnam.mdx'], 'target_ground': True},   # [Q]
    'Kiếm Mộ Pháp': {'main': 'CMK_conguyet.mdx'},   # [bị động]
    'Hồng Tụ Triền': {'main': 'CMK_hongtutrien.mdx', 'target': 'CMK_target.mdx'},   # [R]
    'Tịnh Ảnh Trầm Bích': {'main': 'CMK_tinhanhtrambich.mdx'},   # [bị động]
    'Mộ Vân Ngưng Bích': {'main': 'CMK_movanbuff.mdx'},   # [bị động]
    'Ngọc Nữ Kiếm Pháp': {'main': 'CMK_hongtutrien.mdx'},   # [bị động]
    'Cô Nguyệt Bồi Hồi': {'main': 'CMK_conguyet.mdx', 'target': 'CMK_target1.mdx', 'area': ['CMK_conguyet2.mdx', 'CMK_chungnam.mdx'], 'target_ground': True},   # [W]
    'Chung Nam Vãn Chiếu': {'main': 'CMK_chungnam.mdx', 'target': 'CMK_target1.mdx', 'target_ground': True},   # [D]
    'Hàn Sơn Độc Lập': {'main': 'CMK_phithienvu2.mdx'},   # [bị động]
    'Phi Thiên Vũ': {'main': 'CMK_phithienvu.mdx', 'target': 'CMK_phithienvu2.mdx'},   # [F]
    'Cô Thân Chi Ảnh': {'main': 'CMK_chungnam.mdx', 'cast': 'CMK_castercothan.mdx', 'target': 'CMK_target1.mdx', 'area': ['CMK_phamonghanh3.mdx', 'CMK_cothanca.mdx'], 'target_ground': True},   # [E]
    'Ngọc Nữ Tâm Kinh': {'main': 'CMK_target2.mdx'},   # [bị động]
    'Bạch Vân Hồi Vọng': {'main': 'CMK_target3.mdx'},   # [bị động]
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
# 1. Thu Nhạn Bàng Hoàng [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_thunhan.mdx   [riêng phái]
#         texture: KVCT3_Data\ICE_daoguang.blp
#         texture: KVCT3_Data\ICE_daoguang2.blp
#         texture: KVCT3_Data\Ice3.blp
#    trên địch bị trúng: CMK_target1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#    lớp thêm tại điểm 1: CMK_chungnam.mdx   [riêng phái]
#         texture: KVCT3_Data\t_daoguang2.blp
#
# 2. Kiếm Mộ Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_conguyet.mdx   [riêng phái]
#         texture: KVCT3_Data\Dawn_Slash.blp
#         texture: Textures\Flare.blp
#
# 3. Hồng Tụ Triền [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_hongtutrien.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\AuraRune8.blp
#         texture: ReplaceableTextures\Splats\TeleportTarget.blp
#         texture: KVCT3_Data\AZ_MagicMatrix24.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_Shockwave42.blp
#         texture: Textures\Ghost2.blp
#    trên địch bị trúng: CMK_target.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_daolight5.blp
#         texture: KVCT3_Data\Hero_Jingke_daolight6.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_light15.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_light13.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_light14.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#
# 4. Tịnh Ảnh Trầm Bích [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_tinhanhtrambich.mdx   [riêng phái]
#         texture: Abilities\Spells\NightElf\Starfall\Moon_Cresent.blp
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Units\Creeps\Medivh\GenericGlow2_mip1.blp
#         texture: UI\MiniMap\ping4.blp
#
# 5. Mộ Vân Ngưng Bích [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_movanbuff.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\FHGH01.blp
#         texture: KVCT3_Data\FHGH02.blp
#         texture: KVCT3_Data\FHGH03.blp
#         texture: KVCT3_Data\FHGH04.blp
#         texture: KVCT3_Data\FHGH05.blp
#         texture: KVCT3_Data\FHGH06.blp
#
# 6. Ngọc Nữ Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_hongtutrien.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\AuraRune8.blp
#         texture: ReplaceableTextures\Splats\TeleportTarget.blp
#         texture: KVCT3_Data\AZ_MagicMatrix24.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_Shockwave42.blp
#         texture: Textures\Ghost2.blp
#
# 7. Cô Nguyệt Bồi Hồi [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_conguyet.mdx   [riêng phái]
#         texture: KVCT3_Data\Dawn_Slash.blp
#         texture: Textures\Flare.blp
#    trên địch bị trúng: CMK_target1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#    lớp thêm tại điểm 1: CMK_conguyet2.mdx   [riêng phái]
#         texture: KVCT3_Data\Dawn_Slash.blp
#         texture: Textures\Flare.blp
#    lớp thêm tại điểm 2: CMK_chungnam.mdx   [riêng phái]
#         texture: KVCT3_Data\t_daoguang2.blp
#
# 8. Chung Nam Vãn Chiếu [D]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_chungnam.mdx   [riêng phái]
#         texture: KVCT3_Data\t_daoguang2.blp
#    trên địch bị trúng: CMK_target1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#
# 9. Hàn Sơn Độc Lập [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_phithienvu2.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_firering6.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Genericstar2_32.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_star.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_star1.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Knife_light2F.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Crack12.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow4.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow1.blp
#         texture: KVCT3_Data\TX_Star22.blp
#
# 10. Phi Thiên Vũ [F]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_phithienvu.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Undying_N1S_F_Grain9.blp
#         texture: KVCT3_Data\Hero_Undying_N1S_R_Star2.blp
#    trên địch bị trúng: CMK_phithienvu2.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_firering6.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Genericstar2_32.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_star.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_star1.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Knife_light2F.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_Crack12.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow4.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow.blp
#         texture: KVCT3_Data\Hero_TormentedSoul_N2S_glow1.blp
#         texture: KVCT3_Data\TX_Star22.blp
#
# 11. Cô Thân Chi Ảnh [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_chungnam.mdx   [riêng phái]
#         texture: KVCT3_Data\t_daoguang2.blp
#    lúc tung (trên tướng): CMK_castercothan.mdx   [riêng phái]
#         texture: KVCT3_Data\JN_huadiewu1.blp
#         texture: KVCT3_Data\JN_huadiewu2.blp
#    trên địch bị trúng: CMK_target1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star2.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star4.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star5.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star6.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star7.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star8.blp
#         texture: KVCT3_Data\AZ_star1.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N2S_E_Star10.blp
#    lớp thêm tại điểm 1: CMK_phamonghanh3.mdx   [riêng phái]
#         texture: KVCT3_Data\20huaxianzi_effect_Flare1B_p.blp
#         texture: KVCT3_Data\20huaxianzi_effect_FlareLightning_p.blp
#         texture: Textures\firering6.blp
#         texture: KVCT3_Data\20huaxianzi_effect_lightning4x4_p.blp
#         texture: KVCT3_Data\20huaxinazi_effect_lightning4.blp
#         texture: KVCT3_Data\20huaxianzi_effect02.blp
#    lớp thêm tại điểm 2: CMK_cothanca.mdx   [riêng phái]
#         texture: KVCT3_Data\JN_huixuanbiao_A_01.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_02.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_03.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_04.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_05.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_06.blp
#         texture: KVCT3_Data\JN_huixuanbiao_A_07.blp
#
# 12. Ngọc Nữ Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_target2.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_b.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_b.blp
#         texture: KVCT3_Data\txx110_4_b.blp
#         texture: KVCT3_Data\txx110_2_b.blp
#         texture: KVCT3_Data\txx110_3_b.blp
#
# 13. Bạch Vân Hồi Vọng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CMK_target3.mdx   [riêng phái]
#         texture: Textures\star4_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\white.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: ReplaceableTextures\TeamColor\TeamColor15.blp
#         texture: KVCT3_Data\AZGlow_4x4.blp
#         texture: Textures\Ghost1.blp
#         texture: Textures\Ghost2.blp
#         texture: KVCT3_Data\AZ_Shockwave5_B.blp
#         texture: KVCT3_Data\AZ_Shockwave23_B.blp
#         texture: KVCT3_Data\AZ_Splast1WT.blp
#         texture: KVCT3_Data\AZ_Flashb17_BB.blp
# ===== HẾT DANH MỤC =====
