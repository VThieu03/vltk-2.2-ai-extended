# DTK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/DTK.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Kim Ngọc Mãn Đường [Q]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [riêng phái, phái khác cũng dùng: DTC]
#         texture: KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: KVCT3_Data\Dawn_lightning1.blp
#         texture: KVCT3_Data\Dawn_lightning2.blp
#
# 2. Đoàn Thị Tâm Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_khithontarget.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\RibbonNE1_blue.blp
#
# 3. Bắc Minh Thần Công [bị động]   (kind 0, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): MDX\BacMinhThanCong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\star4.blp
#    aura bị động (gắn tướng suốt): DTK_bacminhaura.mdx   [riêng phái]
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\Blue_Star2.blp
#
# 4. Lục Kiếm Tề Phát [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luckiemtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\tx019-1.blp
#         texture: KVCT3_Data\tx019-2.blp
#         texture: KVCT3_Data\tx019-3.blp
#
# 5. Khô Vinh Thiền Công [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luckiemtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\tx019-1.blp
#         texture: KVCT3_Data\tx019-2.blp
#         texture: KVCT3_Data\tx019-3.blp
#
# 6. Đoàn Gia Khí Kiếm [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachtarget42.mdx   [riêng phái]
#         texture: Textures\Frost3.blp
#         texture: Textures\Star7b.blp
#         texture: KVCT3_Data\tx061.blp
#
# 7. Lục Mạch Thần Kiếm [W]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachcaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_BallisticQ1.blp
#         texture: KVCT3_Data\AZ_Tornado11b.blp
#         texture: Textures\Flare.blp
#         texture: Textures\sun.blp
#         texture: KVCT3_Data\AZ_Shockwave14.blp
#         texture: Textures\Tornado2b.blp
#    lúc tung (trên tướng): DTK_lucmachcaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_BallisticQ1.blp
#         texture: KVCT3_Data\AZ_Tornado11b.blp
#         texture: Textures\Flare.blp
#         texture: Textures\sun.blp
#         texture: KVCT3_Data\AZ_Shockwave14.blp
#         texture: Textures\Tornado2b.blp
#    trên địch bị trúng: DTK_lucmachtarget42.mdx   [riêng phái]
#         texture: Textures\Frost3.blp
#         texture: Textures\Star7b.blp
#         texture: KVCT3_Data\tx061.blp
#
# 8. Kinh Thiên Nhất Kiếm [R]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [riêng phái, phái khác cũng dùng: DTC]
#         texture: KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: KVCT3_Data\Dawn_lightning1.blp
#         texture: KVCT3_Data\Dawn_lightning2.blp
#
# 9. Bách Hồng Thực Nhật [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachthankiem3.mdx   [riêng phái]
#         texture: KVCT3_Data\tx09_3.blp
#
# 10. Luyện Khí Hoàn Thần [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luyenkhibuff.mdx   [riêng phái]
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\star4.blp
#    lớp thêm tại điểm 1: DTK_luyenkhihh.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Flare6.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Tornado2b.blp
#         texture: KVCT3_Data\AZ_Shockwave12.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: KVCT3_Data\Disruptor_Aghanim1_purple.blp
#    lớp thêm tại điểm 2: DTK_luyenkhi.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow2.blp
#         texture: Textures\Flare.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\rainTail.blp
#         texture: Textures\snowflake2.blp
#         texture: Textures\Blue_Star2.blp
#
# 11. Khí Thôn Vạn Lý [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachcaster.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_BallisticQ1.blp
#         texture: KVCT3_Data\AZ_Tornado11b.blp
#         texture: Textures\Flare.blp
#         texture: Textures\sun.blp
#         texture: KVCT3_Data\AZ_Shockwave14.blp
#         texture: Textures\Tornado2b.blp
#    trên địch bị trúng: DTK_khithonvanly.mdx   [riêng phái]
#         texture: KVCT3_Data\flareshot01_bw.blp
#         texture: KVCT3_Data\dust3.blp
#         texture: KVCT3_Data\RoyalGlow.blp
#         texture: Textures\Purple_Star.blp
#         texture: KVCT3_Data\flaresimple01_bw.blp
#         texture: KVCT3_Data\flaresimple02_bw.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: KVCT3_Data\smoke_bw.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: KVCT3_Data\flash01_bw.blp
#
# 12. Thiên Long Thần Công [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachthankiem6.mdx   [riêng phái]
#         texture: KVCT3_Data\tx09_6.blp
#
# 13. Ám Hương Sơ Ảnh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luyenkhi.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow2.blp
#         texture: Textures\Flare.blp
#         texture: Textures\snowflake.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\rainTail.blp
#         texture: Textures\snowflake2.blp
#         texture: Textures\Blue_Star2.blp
# ===== HẾT DANH MỤC =====
