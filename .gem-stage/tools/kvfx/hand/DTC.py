# DTC: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/DTC.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Thần Chỉ Điểm Huyệt [Q]   (kind 16, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThanChi.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\WaterWake3.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\Bubble.blp
#         texture: Textures\White_64_Foam1.blp
#
# 2. Đoàn Thị Chỉ Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_canduongchi.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_GlowYellowb.blp
#         texture: KVCT3_Data\AZ_Flare1R1b.blp
#         texture: KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: KVCT3_Data\lightning4x4.blp
#
# 3. Nhất Dương Chỉ [R]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [dùng chung (cùng dùng: DTK)]
#         texture: KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: KVCT3_Data\Dawn_lightning1.blp
#         texture: KVCT3_Data\Dawn_lightning2.blp
#
# 4. Lăng Ba Vi Bộ [F]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_langbacast.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\tx163-1.blp
#         texture: KVCT3_Data\tx163-2.blp
#         texture: KVCT3_Data\tx163-3.blp
#
# 5. Từ Bi Quyết [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: KVCT3_Data\AFB_lltsfx.blp
#         texture: KVCT3_Data\AFB_TT1.blp
#
# 6. Kim Ngọc Chỉ Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi2.mdx   [riêng phái]
#         texture: KVCT3_Data\bd100.blp
#         texture: Textures\Shockwave10.blp
#
# 7. Cản Dương Thần Chỉ [W]   (kind 4, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\TX_daji.blp
#    lớp thêm tại điểm 1: DTC_Img.mdx   [riêng phái]
#         texture: KVCT3_Data\Mr.War3_PJWH.blp
#    lớp thêm tại điểm 2: DTC_canduongchi.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_GlowYellowb.blp
#         texture: KVCT3_Data\AZ_Flare1R1b.blp
#         texture: KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: KVCT3_Data\lightning4x4.blp
#
# 8. Huyền Băng Cửu Kiếp [D]   (kind 16, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_Img.mdx   [riêng phái]
#         texture: KVCT3_Data\Mr.War3_PJWH.blp
#
# 9. Diệu Đề Chỉ [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_dieudebuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\Precision.blp
#
# 10. Thí Nguyên Quyết [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thinguyenbuff.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#
# 11. Thiên Long Thần Chỉ [E]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: KVCT3_Data\AFB_lltsfx.blp
#         texture: KVCT3_Data\AFB_TT1.blp
#    lớp thêm tại điểm 1: DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\TX_daji.blp
#    lớp thêm tại điểm 2: DTC_Img.mdx   [riêng phái]
#         texture: KVCT3_Data\Mr.War3_PJWH.blp
#
# 12. Càn Thiên Chỉ Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_thienlongchi1.mdx   [riêng phái]
#         texture: KVCT3_Data\AFB_lltsfx.blp
#         texture: KVCT3_Data\AFB_TT1.blp
#    lớp thêm tại điểm 1: DTC_thienlongchi2.mdx   [riêng phái]
#         texture: KVCT3_Data\bd100.blp
#         texture: Textures\Shockwave10.blp
#
# 13. Bách Bộ Xuyên Dương [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): DTC_bachbobuff.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\DemonRune2.blp
#         texture: Textures\DemonRune3.blp
#         texture: KVCT3_Data\massteleportcircle.blp
#         texture: Textures\ribbonne1_blue.blp
#    lớp thêm tại điểm 1: DTC_canduongchi.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_GlowYellowb.blp
#         texture: KVCT3_Data\AZ_Flare1R1b.blp
#         texture: KVCT3_Data\MG_Lightning1_fxb.blp
#         texture: KVCT3_Data\lightning4x4.blp
#    lớp thêm tại điểm 2: DTC_canduongeffect1.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\TX_daji.blp
# ===== HẾT DANH MỤC =====
