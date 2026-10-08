# VDK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Tam Hoàn Sáo Nguyệt': {'main': 'VDK_tamhoanthaonguyet.mdx'},   # [Q]
    'Võ Đang Kiếm Pháp': {'main': 'VDK_vothuongkiem.mdx'},   # [bị động]
    'Tọa Vọng Vô Ngã': {'main': 'MDX\\ToaVongVoNga.mdx', 'cast': 'VDK_vongacast.mdx'},   # [D]
    'Lưu Tinh Cản Nguyệt': {'main': 'VDK_nhankiemcast.mdx'},   # [R]
    'Thất Tinh Quyết': {'main': 'VDK_thattinhaura.mdx', 'aura': 'VDK_thattinhaura.mdx'},   # [bị động]
    'Kiếm Khí Tung Hoành': {'main': 'VDK_tutieuhoanhvan.mdx'},   # [bị động]
    'Nhân Kiếm Hợp Nhất': {'main': 'VDK_nhankiemsword.mdx', 'cast': 'VDK_nhankiemcast.mdx', 'target': 'VDK_nhankiemtarget.mdx', 'cast_ground': True, 'target_ground': True},   # [W]
    'Lưỡng Nghi Kiếm Pháp': {'main': 'VDK_luongnghikiem.mdx'},   # [F]
    'Thái Nhất Chân Khí': {'main': 'VDK_thainhat.mdx'},   # [bị động]
    'Mê Tung Huyễn Ảnh': {'main': 'MDX\\MeTungHuyenAnh.mdx'},   # [bị động]
    'Vô Thượng Kiếm Đạo': {'main': 'VDK_vothuongkiem.mdx', 'cast': 'VDK_vothuongcastereffect.mdx', 'target': 'VDK_vothuongtarget.mdx', 'area': ['VDK_vocuckiemy.mdx'], 'cast_ground': True, 'target_ground': True},   # [E]
    'Thái Cực Kiếm Pháp': {'main': 'VDK_vocuckiemy.mdx'},   # [bị động]
    'Tử Tiêu Hoành Vân': {'main': 'VDK_tutieuhoanhvan.mdx', 'buff': 'VDK_tutieubuff.mdx'},   # [T]
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
# 1. Tam Hoàn Sáo Nguyệt [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tamhoanthaonguyet.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\BlueSqGlow.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 2. Võ Đang Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vothuongkiem.mdx   [riêng phái]
#         texture: KVCT3_Data\ZapBlue1.blp
#         texture: KVCT3_Data\CircleBlue.blp
#         texture: KVCT3_Data\StarBlue.blp
#         texture: KVCT3_Data\ZapLightning1X4.blp
#         texture: KVCT3_Data\GlowBlue.blp
#         texture: KVCT3_Data\222.blp
#
# 3. Tọa Vọng Vô Ngã [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ToaVongVoNga.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: VDQ)]
#         texture: Textures\GenericGlow64.blp
#         texture: YinYang_a.blp
#    lúc tung (trên tướng): VDK_vongacast.mdx   [riêng phái]
#         texture: KVCT3_Data\ThaiCuc.blp
#         texture: Textures\Yellow_Glow3.blp
#
# 4. Lưu Tinh Cản Nguyệt [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_nhankiemcast.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#
# 5. Thất Tinh Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_thattinhaura.mdx   [riêng phái]
#         texture: KVCT3_Data\ThatTinhQuyet.blp
#    aura bị động (gắn tướng suốt): VDK_thattinhaura.mdx   [riêng phái]
#         texture: KVCT3_Data\ThatTinhQuyet.blp
#
# 6. Kiếm Khí Tung Hoành [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tutieuhoanhvan.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Effect_AZ_GenericGlow.blp
#         texture: KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp
#         texture: KVCT3_Data\Effect_AZ_Shockwave2B.blp
#
# 7. Nhân Kiếm Hợp Nhất [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_nhankiemsword.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: KVCT3_Data\ColdSword2.BLP
#    lúc tung (trên tướng): VDK_nhankiemcast.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#    trên địch bị trúng: VDK_nhankiemtarget.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\BlueSqGlow.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 8. Lưỡng Nghi Kiếm Pháp [F]   (kind 17, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_luongnghikiem.mdx   [riêng phái]
#         texture: KVCT3_Data\thorarrow.blp
#         texture: KVCT3_Data\Blue_Glow3.blp
#
# 9. Thái Nhất Chân Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_thainhat.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: KVCT3_Data\YinYang_a.blp
#
# 10. Mê Tung Huyễn Ảnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\MeTungHuyenAnh.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Zap1.blp
#         texture: Bakua_b.blp
#
# 11. Vô Thượng Kiếm Đạo [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vothuongkiem.mdx   [riêng phái]
#         texture: KVCT3_Data\ZapBlue1.blp
#         texture: KVCT3_Data\CircleBlue.blp
#         texture: KVCT3_Data\StarBlue.blp
#         texture: KVCT3_Data\ZapLightning1X4.blp
#         texture: KVCT3_Data\GlowBlue.blp
#         texture: KVCT3_Data\222.blp
#    lúc tung (trên tướng): VDK_vothuongcastereffect.mdx   [riêng phái]
#         texture: KVCT3_Data\Dawn_Slash_Lightning_01.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_02.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_03.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_04.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_05.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_06.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_07.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_08.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_09.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_10.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_11.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_12.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_13.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_14.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_15.blp
#         texture: KVCT3_Data\Dawn_Slash_Lightning_16.blp
#         texture: KVCT3_Data\Dawn_lightning1.blp
#         texture: KVCT3_Data\Dawn_lightning2.blp
#    trên địch bị trúng: VDK_vothuongtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star2.blp
#         texture: KVCT3_Data\Hero_Jingke_N3s_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_star.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_glow1.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_glow.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N4s_star2.blp
#    lớp thêm tại điểm 1: VDK_vocuckiemy.mdx   [riêng phái]
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#
# 12. Thái Cực Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vocuckiemy.mdx   [riêng phái]
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp
#         texture: KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#
# 13. Tử Tiêu Hoành Vân [T]   (kind 18, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tutieuhoanhvan.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Effect_AZ_GenericGlow.blp
#         texture: KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp
#         texture: KVCT3_Data\Effect_AZ_Shockwave2B.blp
#    buff (trên tướng): VDK_tutieubuff.mdx   [riêng phái]
#         texture: KVCT3_Data\GameBABY_a1101.blp
#         texture: KVCT3_Data\GameBABY_a1102.blp
# ===== HẾT DANH MỤC =====
