# TYD: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TYD.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Mục Dã Lưu Tinh [Q]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYD_mucda.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: Textures\star4.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Frost2.blp
#
# 2. Thúy Yên Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtunghoasen.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flash6-b.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Petal4-b.blp
#
# 3. Tuyết Ảnh [bị động]   (kind 0, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYD_daptuyetbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\DapTuyetVoNgan.blp
#         texture: Textures\star5tga.blp
#    aura bị động (gắn tướng suốt): TYK_tuyetanh.mdx   [dùng chung (cùng dùng: TYK)]
#         texture: Textures\star5tga.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\snowflake2.blp
#
# 4. Ngự Tuyết Ẩn [R]   (kind 19, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_effectcast.mdx   [dùng chung (cùng dùng: TYK)]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#    buff (trên tướng): TYD_daptuyetbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\DapTuyetVoNgan.blp
#         texture: Textures\star5tga.blp
#
# 5. Hộ Thể Hàn Băng [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtuocdao2.mdx   [riêng phái]
#         texture: KVCT3_Data\ws_005_sw_1.blp
#
# 6. Băng Cơ Ngọc Cốt [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtuochoasen.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flash6-b.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Petal4-b.blp
#
# 7. Băng Tung Vô Ảnh [W]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtunghoasen.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flash6-b.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Petal4-b.blp
#    lớp thêm tại điểm 1: TYD_bangtungvoanh.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Ice3b.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\RibbonBlur1.blp
#
# 8. Đạp Tuyết Vô Ngấn [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_daptuyetbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\DapTuyetVoNgan.blp
#         texture: Textures\star5tga.blp
#    lớp thêm tại điểm 1: TYD_luuphonghoituyet.mdx   [riêng phái]
#         texture: Textures\Frost3.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Star8c.blp
#
# 9. Hàn Nguyệt Yên Tỏa [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_banglongpha.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\11renyugongzhu_effectA.blp
#         texture: KVCT3_Data\11renyugongzhu_effectB.blp
#
# 10. Tương Tư [D]   (kind 20, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bufftuongtu.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: abilities\Spells\Human\Banish\GenericGlow2bA.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\star32.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Ghost2.blp
#
# 11. Băng Tước Việt Chi [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtuocdao1.mdx   [riêng phái]
#         texture: KVCT3_Data\ws_005_sw_1.blp
#    lớp thêm tại điểm 1: TYD_bangtuocdao2.mdx   [riêng phái]
#         texture: KVCT3_Data\ws_005_sw_1.blp
#    lớp thêm tại điểm 2: TYD_bangtuochoasen.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flash6-b.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Petal4-b.blp
#
# 12. Băng Tâm Thiến Ảnh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TYD_bangtunghoasen.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Flash6-b.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Petal4-b.blp
#    lớp thêm tại điểm 1: TYD_bangtungvoanh.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Ice3b.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\RibbonBlur1.blp
#    lớp thêm tại điểm 2: TYD_bangtuocdao1.mdx   [riêng phái]
#         texture: KVCT3_Data\ws_005_sw_1.blp
#
# 13. Dạ Lai Tây Phong [F]   (kind 4, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TYK_huyenbang.mdx   [dùng chung (cùng dùng: TYK)]
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Integration_Ice_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_2_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Sequence_Ice_1_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_War3_Frame_Ring_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Ice_3_4x4_2.blp
# ===== HẾT DANH MỤC =====
