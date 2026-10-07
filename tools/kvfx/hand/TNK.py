# TNK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TNK.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Tàn Dương Như Huyết': {'main': 'TNK_tanduongnhuhuyet.mdx'},   # [Q]
    'Thiên Nhẫn Mâu Pháp': {'main': 'TNK_gianghai2.mdx'},   # [bị động]
    'Liệt Hỏa Tinh Thiên': {'main': 'MDX\\LietHoaTinhThien.mdx'},   # [R]
    'Ma Âm Phệ Phách': {'main': 'TNK_maamtarget.mdx'},   # [D]
    'Bi Tô Thanh Phong': {'main': 'TNK_tanduongnhuhuyet.mdx'},   # [bị động]
    'Thiên Ma Giải Thể': {'main': 'TNK_vanlong3.mdx'},   # [bị động]
    'Vân Long Kích': {'main': 'TNK_vanlongkich.mdx', 'cast': 'TNK_vanlongcast.mdx', 'target': 'TNK_vanlongtarget.mdx', 'cast_ground': True},   # [W]
    'Phi Hồng Vô Tích': {'main': 'TNK_phihongcast.mdx'},   # [F]
    'Cửu Khúc Hợp Thương': {'main': 'TNK_cuukhucbuff.MDX'},   # [bị động]
    'Vân Long Tam Hiện': {'main': 'MDX\\VanLong.mdx', 'cast': 'TNK_vanlongcast.mdx', 'target': 'TNK_vanlongtarget.mdx', 'area': ['TNK_vanlongkich.mdx']},   # [bị động]
    'Giang Hải Nộ Lan': {'main': 'TNK_gianghai1.mdx', 'cast': 'TNK_vanlongcast.mdx', 'target': 'TNK_gianghaitarget.mdx', 'area': ['TNK_gianghai2.mdx'], 'cast_ground': True, 'target_ground': True},   # [E]
    'Ma Viêm Tại Thiên': {'main': 'TNK_maamtarget.mdx'},   # [bị động]
    'Bích Nguyệt Phi Tinh': {'main': 'TNK_tanduongnhuhuyet.mdx'},   # [bị động]
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
# 1. Tàn Dương Như Huyết [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_tanduongnhuhuyet.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Splast1W.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\AZ_Knife_light2S.blp
#         texture: KVCT3_Data\AZ_RibbonFire.blp
#         texture: KVCT3_Data\BloodSmoke.blp
#         texture: KVCT3_Data\AZ_RibbonGhost.blp
#         texture: KVCT3_Data\AZ_GlowYellow.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
#
# 2. Thiên Nhẫn Mâu Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_gianghai2.mdx   [riêng phái]
#         texture: Textures\Dust5.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\white.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Fade.blp
#
# 3. Liệt Hỏa Tinh Thiên [R]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\LietHoaTinhThien.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Shockwave4.blp
#         texture: Textures\Star7b.blp
#
# 4. Ma Âm Phệ Phách [D]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_maamtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\kuwei_suolian.blp
#
# 5. Bi Tô Thanh Phong [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_tanduongnhuhuyet.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Splast1W.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\AZ_Knife_light2S.blp
#         texture: KVCT3_Data\AZ_RibbonFire.blp
#         texture: KVCT3_Data\BloodSmoke.blp
#         texture: KVCT3_Data\AZ_RibbonGhost.blp
#         texture: KVCT3_Data\AZ_GlowYellow.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
#
# 6. Thiên Ma Giải Thể [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_vanlong3.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\gn1.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\RibbonNE1_Pink.blp
#         texture: Textures\Red_Glow1.blp
#
# 7. Vân Long Kích [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_vanlongkich.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#         texture: KVCT3_Data\ZK-file2.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#         texture: KVCT3_Data\ZK-file1.blp
#    lúc tung (trên tướng): TNK_vanlongcast.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\Magic11.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Magic4.blp
#    trên địch bị trúng: TNK_vanlongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Splast1W.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\AZ_Knife_light2S.blp
#         texture: KVCT3_Data\kulouwang01_effect01.blp
#         texture: KVCT3_Data\Flare2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_RibbonFired.blp
#         texture: KVCT3_Data\AZ_Smoke1Ed.blp
#
# 8. Phi Hồng Vô Tích [F]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_phihongcast.mdx   [riêng phái]
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Dust6Color.blp
#         texture: Units\Human\Phoenix\RibbonNE1_Red.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Flame4.blp
#
# 9. Cửu Khúc Hợp Thương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_cuukhucbuff.MDX   [riêng phái]
#         texture: KVCT3_Data\eff2.blp
#
# 10. Vân Long Tam Hiện [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\VanLong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Red_star3.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Zap1_Red.blp
#    lúc tung (trên tướng): TNK_vanlongcast.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\Magic11.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Magic4.blp
#    trên địch bị trúng: TNK_vanlongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Splast1W.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\AZ_Knife_light2S.blp
#         texture: KVCT3_Data\kulouwang01_effect01.blp
#         texture: KVCT3_Data\Flare2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_RibbonFired.blp
#         texture: KVCT3_Data\AZ_Smoke1Ed.blp
#    lớp thêm tại điểm 1: TNK_vanlongkich.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#         texture: KVCT3_Data\ZK-file2.blp
#         texture: KVCT3_Data\RibbonNE1_White.blp
#         texture: KVCT3_Data\ZK-file1.blp
#
# 11. Giang Hải Nộ Lan [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_gianghai1.mdx   [riêng phái]
#         texture: Textures\Dust5.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\white.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Fade.blp
#    lúc tung (trên tướng): TNK_vanlongcast.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\Magic11.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Magic4.blp
#    trên địch bị trúng: TNK_gianghaitarget.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110.blp
#         texture: KVCT3_Data\txx110_4.blp
#         texture: KVCT3_Data\txx110_2.blp
#         texture: KVCT3_Data\txx110_3.blp
#    lớp thêm tại điểm 1: TNK_gianghai2.mdx   [riêng phái]
#         texture: Textures\Dust5.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\white.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Fade.blp
#
# 12. Ma Viêm Tại Thiên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_maamtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\kuwei_suolian.blp
#
# 13. Bích Nguyệt Phi Tinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TNK_tanduongnhuhuyet.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Splast1W.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\AZ_Knife_light2S.blp
#         texture: KVCT3_Data\AZ_RibbonFire.blp
#         texture: KVCT3_Data\BloodSmoke.blp
#         texture: KVCT3_Data\AZ_RibbonGhost.blp
#         texture: KVCT3_Data\AZ_GlowYellow.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
# ===== HẾT DANH MỤC =====
