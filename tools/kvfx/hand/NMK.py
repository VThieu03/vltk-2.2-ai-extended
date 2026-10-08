# NMK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Thôi Song Vọng Nguyệt': {'main': 'NMK_thoisongeffect.mdx', 'area': ['NMK_thoisongvongnguyet.mdx']},   # [Q]
    'Từ Hàng Phổ Độ': {'main': 'NMK_tuhang.mdx', 'area': ['NMK_tuhang2.mdx', 'NMK_effect8.mdx']},   # [R]
    'Thiên Phật Thiên Diệp': {'main': 'NMK_thienphatbuff.mdx'},   # [D]
    'Mộng Điệp': {'main': 'NMK_effect8.mdx'},   # [bị động]
    'Phật Tâm Từ Hựu': {'main': 'NMK_kiemanhphatquang.mdx'},   # [bị động]
    'Ba La Tâm Kinh': {'main': 'NMK_kiemanhphatquangtarget.mdx'},   # [bị động]
    'Kiếm Ảnh Phật Quang': {'main': 'NMK_kiemanhphatquang.mdx', 'target': 'NMK_kiemanhphatquangtarget.mdx', 'target_ground': True},   # [W]
    'Thanh Âm Phạn Xướng': {'main': 'NMK_thoisongvongnguyet.mdx'},   # [bị động]
    'Thanh Tâm Tịnh Khí': {'main': 'NMK_tuhang.mdx'},   # [bị động]
    'Liên Hoa Tâm Kinh': {'main': 'NMK_tuhang2.mdx'},   # [bị động]
    'Băng Sương Điện Phóng': {'main': 'NMK_bangsuongkiem.mdx', 'target': 'NMK_bangsuongtarget.mdx', 'buff': 'NMK_thienphatbuff.mdx', 'area': ['NMK_bangsuongeffect.mdx']},   # [E]
    'Độ Nguyên Công': {'main': 'NMK_thoisongvongnguyet.mdx'},   # [bị động]
    'Bế Nguyệt Phất Trần': {'main': 'NMK_thoisongvongnguyet.mdx'},   # [bị động]
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
# 1. Thôi Song Vọng Nguyệt [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongeffect.mdx   [riêng phái]
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
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#    lớp thêm tại điểm 1: NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
#
# 2. Từ Hàng Phổ Độ [R]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_tuhang.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Zap1_Red.blp
#         texture: KVCT3_Data\SenEmei01.blp
#    lớp thêm tại điểm 1: NMK_tuhang2.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Shockwave_blue.blp
#         texture: Textures\rainTail.blp
#    lớp thêm tại điểm 2: NMK_effect8.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#
# 3. Thiên Phật Thiên Diệp [D]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thienphatbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\heianhuanxiang1.BLP
#         texture: KVCT3_Data\heianhuanxiang2.blp
#
# 4. Mộng Điệp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_effect8.mdx   [riêng phái]
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#
# 5. Phật Tâm Từ Hựu [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquang.mdx   [riêng phái]
#         texture: KVCT3_Data\leshandafo01.blp
#         texture: KVCT3_Data\leshandafo02.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX.blp
#
# 6. Ba La Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquangtarget.mdx   [riêng phái]
#         texture: Textures\firering6.blp
#         texture: Textures\grad2d.blp
#         texture: KVCT3_Data\20huaxianzi_effect_Tornado1E.blp
#         texture: KVCT3_Data\20huaxianzi_effect_snowflake01.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp
#         texture: KVCT3_Data\20huaxinazi_effect_lightning4.blp
#         texture: KVCT3_Data\20huaxianzi_effect_hua.blp
#
# 7. Kiếm Ảnh Phật Quang [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_kiemanhphatquang.mdx   [riêng phái]
#         texture: KVCT3_Data\leshandafo01.blp
#         texture: KVCT3_Data\leshandafo02.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX.blp
#    trên địch bị trúng: NMK_kiemanhphatquangtarget.mdx   [riêng phái]
#         texture: Textures\firering6.blp
#         texture: Textures\grad2d.blp
#         texture: KVCT3_Data\20huaxianzi_effect_Tornado1E.blp
#         texture: KVCT3_Data\20huaxianzi_effect_snowflake01.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star4.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\20huaxianzi_effect_Smoke3_2x2.blp
#         texture: KVCT3_Data\20huaxinazi_effect_lightning4.blp
#         texture: KVCT3_Data\20huaxianzi_effect_hua.blp
#
# 8. Thanh Âm Phạn Xướng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
#
# 9. Thanh Tâm Tịnh Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_tuhang.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Zap1_Red.blp
#         texture: KVCT3_Data\SenEmei01.blp
#
# 10. Liên Hoa Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_tuhang2.mdx   [riêng phái]
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Shockwave_blue.blp
#         texture: Textures\rainTail.blp
#
# 11. Băng Sương Điện Phóng [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_bangsuongkiem.mdx   [riêng phái]
#         texture: Buildings\Human\ArcaneSanctum\ArcaneSanctum.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\222.blp
#    trên địch bị trúng: NMK_bangsuongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\tx019-1.blp
#         texture: KVCT3_Data\tx019-2.blp
#         texture: KVCT3_Data\tx019-3.blp
#    buff (trên tướng): NMK_thienphatbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\heianhuanxiang1.BLP
#         texture: KVCT3_Data\heianhuanxiang2.blp
#    lớp thêm tại điểm 1: NMK_bangsuongeffect.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
#         texture: KVCT3_Data\AZ_SnowGlobe0.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\AZ_GlowBlue.blp
#         texture: Textures\Ice3b.blp
#         texture: KVCT3_Data\az_crack48.tga
#
# 12. Độ Nguyên Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
#
# 13. Bế Nguyệt Phất Trần [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NMK_thoisongvongnguyet.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\Tornado2b.blp
# ===== HẾT DANH MỤC =====
