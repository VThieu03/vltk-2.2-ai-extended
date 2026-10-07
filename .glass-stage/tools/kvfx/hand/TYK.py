# TYK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TYK.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Phong Quyển Tàn Tuyết [Q]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_phongquyen.mdx   [riêng phái]
#         texture: Textures\snowflake.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\rainTail.blp
#    lúc tung (trên tướng): TYK_effectcast.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#
# 2. Thúy Yên Kiếm Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_bangtamtientu2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Flashb2P_2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_smokeT1.blp
#         texture: KVCT3_Data\AZ_Snowflake2.blp
#
# 3. Tuyết Ảnh [bị động]   (kind 0, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#    aura bị động (gắn tướng suốt): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#
# 4. Vũ Đả Lê Hoa [R]   (kind 5, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_huyenbang.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp
#    lúc tung (trên tướng): TYK_effectcast.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#
# 5. Hộ Thể Hàn Băng [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_hothehanbang.mdx   [riêng phái]
#         texture: KVCT3_Data\GameBABY_ss422a01.blp
#         texture: KVCT3_Data\GameBABY_ss422a02.blp
#    lớp thêm tại điểm 1: TYK_huyenbang.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp
#
# 6. Băng Cốt Tuyết Tâm [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#
# 7. Băng Tâm Tiên Tử [W]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_bangtamtientu2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Flashb2P_2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_smokeT1.blp
#         texture: KVCT3_Data\AZ_Snowflake2.blp
#    lúc tung (trên tướng): TYK_effectcast.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#    buff (trên tướng): TYK_Buffbangtam.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: KVCT3_Data\chongjibo_frost.blp
#         texture: KVCT3_Data\chongjibo2.blp
#    lớp thêm tại điểm 1: TYK_bangtamtientu1.mdx   [riêng phái]
#         texture: KVCT3_Data\jianxiashaon1.blp
#
# 8. Phi Tự Phiêu Hoa [D]   (kind 13, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_phituphieuhoaeffect.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\Dust3x.blp
#         texture: Abilities\Spells\Human\Blizzard\Frost3test.blp
#    lúc tung (trên tướng): TYK_effectcast.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#    trên địch bị trúng: TYK_phituphieuhoaeffect.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\Dust3x.blp
#         texture: Abilities\Spells\Human\Blizzard\Frost3test.blp
#
# 9. Phù Vân Tán Tuyết [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#
# 10. Băng Tâm Ngọc Lăng [F]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_Buffbangtam.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: KVCT3_Data\chongjibo_frost.blp
#         texture: KVCT3_Data\chongjibo2.blp
#    lớp thêm tại điểm 1: TYK_bangtamtientu1.mdx   [riêng phái]
#         texture: KVCT3_Data\jianxiashaon1.blp
#    lớp thêm tại điểm 2: TYK_bangtamtientu2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Flashb2P_2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_smokeT1.blp
#         texture: KVCT3_Data\AZ_Snowflake2.blp
#
# 11. Thủy Ánh Mạn Tú [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_thuyanh1.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_RibbonNE2S.blp
#         texture: KVCT3_Data\AZ_Smoke2x2A1.blp
#         texture: KVCT3_Data\AZ_water6.blp
#    lúc tung (trên tướng): TYK_effectcast.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#    trên địch bị trúng: TYK_phituphieuhoaeffect.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\Dust3x.blp
#         texture: Abilities\Spells\Human\Blizzard\Frost3test.blp
#    lớp thêm tại điểm 1: TYK_thuyanhmantu.mdx   [riêng phái]
#         texture: KVCT3_Data\icespirit.blp
#    lớp thêm tại điểm 2: TYK_thuyanheffect2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#
# 12. Thập Diện Mai Phục [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#
# 13. Tuyết Ánh Hồng Trần [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYK_tuyetanh.mdx   [riêng phái, phái khác cũng dùng: TYD]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
# ===== HẾT DANH MỤC =====
