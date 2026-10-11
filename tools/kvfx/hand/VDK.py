# VDK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
# Bằng chứng đọc từ code gốc KVCT (D:/kvct-dev/work/readable.j; EDM EDQ Ede EoR Eo8 là hằng số chuỗi đường dẫn model):
#   VDK_tamhoanthaonguyet    <- eiU (dòng 71145, Q: nổ 3 nhịp tại vị trí mục tiêu)
#   VDK_nhankiemsword        <- eZE (67059, W: đạn kiếm bay, scale 0.65)
#   VDK_nhankiemcast         <- eZK / eZ0 (67112 / 67073, W: tại chỗ tướng lúc tung), Jx0 (89390, R: vệt lướt tại vị trí tướng)
#   VDK_nhankiemtarget       <- ebi (67021, W: trên địch trúng), eNy (64637, F: trên địch trúng)
#   VDK_luongnghikiem        <- eNW (64669, F: đạn bay, scale 0.65)
#   VDK_vothuongkiem         <- J9X (77938, E: đạn bay, scale 1.5)
#   VDK_vothuongcastereffect <- J9A (77972, E: tại chỗ tướng lúc tung, sát đất)
#   VDK_vothuongcast         <- J9A (77975, E: tại chỗ tướng lúc tung, scale 0.7)
#   VDK_vothuongtarget / VDK_vocuckiemy <- J9j (77892 / 77895, E: trên địch trúng)
#   VDK_thattinhaura         <- JcZ (127103, ô 5 Thất Tinh Quyết: gắn tướng)
#   (AIlbSpecialArt - ebi 67024 - là model gốc WC3, không có trong kho KVCT nên không ghi;
#    NMC_phongsuongtoaianh trace báo ở ô 5/9/11 là SAI: "$AA" là số hex 170, không phải hằng AA)
VFX = {
    "Tam Hoàn Sáo Nguyệt": {   # [Q] — KVCT: đã đối chiếu
        "main": "VDK_tamhoanthaonguyet.mdx",
    },
    "Võ Đang Kiếm Pháp": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDK_vothuongkiem.mdx",
    },
    "Tọa Vọng Vô Ngã": {   # [D] KVCT không có hiệu ứng trong script
        "main": "MDX\\ToaVongVoNga.mdx",
        "cast": "VDK_vongacast.mdx",
    },
    "Lưu Tinh Cản Nguyệt": {   # [R] — KVCT: đã đối chiếu (Jx0: lướt, để VDK_nhankiemcast tại vị trí tướng)
        "main": "VDK_nhankiemcast.mdx",
    },
    "Thất Tinh Quyết": {   # [bị động] — KVCT: đã đối chiếu
        "main": "VDK_thattinhaura.mdx",
        "aura": "VDK_thattinhaura.mdx",
    },
    "Kiếm Khí Tung Hoành": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDK_tutieuhoanhvan.mdx",
    },
    "Nhân Kiếm Hợp Nhất": {   # [W] — KVCT: đã đối chiếu
        "main": {"file": "VDK_nhankiemsword.mdx", "scale": 0.65},
        "cast": {"file": "VDK_nhankiemcast.mdx", "ground": True},
        "target": {"file": "VDK_nhankiemtarget.mdx", "ground": True},
    },
    "Lưỡng Nghi Kiếm Pháp": {   # [F] — KVCT: đã đối chiếu
        "main": {"file": "VDK_luongnghikiem.mdx", "scale": 0.65},
        "target": {"file": "VDK_nhankiemtarget.mdx", "ground": True},
    },
    "Thái Nhất Chân Khí": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDK_thainhat.mdx",
    },
    "Mê Tung Huyễn Ảnh": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "MDX\\MeTungHuyenAnh.mdx",
    },
    "Vô Thượng Kiếm Đạo": {   # [E] — KVCT: đã đối chiếu (VDK_vocuckiemy cũng nổ trên địch trúng; chỉ có 1 ô target nên để ở area)
        "main": {"file": "VDK_vothuongkiem.mdx", "scale": 1.5},
        "cast": {"file": "VDK_vothuongcastereffect.mdx", "ground": True},
        "target": {"file": "VDK_vothuongtarget.mdx", "ground": True},
        "area": ["VDK_vothuongcast.mdx", "VDK_vocuckiemy.mdx"],
    },
    "Thái Cực Kiếm Pháp": {   # [bị động] KVCT không có hiệu ứng trong script
        "main": "VDK_vocuckiemy.mdx",
    },
    "Tử Tiêu Hoành Vân": {   # [T] KVCT không có hiệu ứng trong script
        "main": "VDK_tutieuhoanhvan.mdx",
        "buff": "VDK_tutieubuff.mdx",
    },
}

# Đổi texture của model (xem danh mục bên dưới).
TEXTURES = {
    
}

# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) =====
# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:
#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}
#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\Flame4.blp"}
#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)
# Sửa xong chạy lại pipeline (tools/pipeline.py) để áp dụng.
#
# 1. Tam Hoàn Sáo Nguyệt [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tamhoanthaonguyet.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\BlueSqGlow.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 2. Võ Đang Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vothuongkiem.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZapBlue1.blp
#         texture: VLTK_data\KVCT3_Data\CircleBlue.blp
#         texture: VLTK_data\KVCT3_Data\StarBlue.blp
#         texture: VLTK_data\KVCT3_Data\ZapLightning1X4.blp
#         texture: VLTK_data\KVCT3_Data\GlowBlue.blp
#         texture: VLTK_data\KVCT3_Data\222.blp
#
# 3. Tọa Vọng Vô Ngã [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ToaVongVoNga.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: VDQ)]
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\Loose\YinYang_a.blp
#    lúc tung (trên tướng): VDK_vongacast.mdx   [riêng phái, phái khác cũng dùng: VDQ]
#         texture: VLTK_data\KVCT3_Data\ThaiCuc.blp
#         texture: Textures\Yellow_Glow3.blp
#
# 4. Lưu Tinh Cản Nguyệt [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_nhankiemcast.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#
# 5. Thất Tinh Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_thattinhaura.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ThatTinhQuyet.blp
#    aura bị động (gắn tướng suốt): VDK_thattinhaura.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ThatTinhQuyet.blp
#
# 6. Kiếm Khí Tung Hoành [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tutieuhoanhvan.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_GenericGlow.blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_Shockwave2B.blp
#
# 7. Nhân Kiếm Hợp Nhất [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_nhankiemsword.mdx   [riêng phái]
#         texture: Textures\Blue_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\ColdSword2.BLP
#    lúc tung (trên tướng): VDK_nhankiemcast.mdx   [riêng phái]
#         texture: Textures\RibbonBlur1.blp
#    trên địch bị trúng: VDK_nhankiemtarget.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\BlueSqGlow.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 8. Lưỡng Nghi Kiếm Pháp [F]   (kind 17, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_luongnghikiem.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\thorarrow.blp
#         texture: VLTK_data\KVCT3_Data\Blue_Glow3.blp
#    trên địch bị trúng: VDK_nhankiemtarget.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\BlueSqGlow.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 9. Thái Nhất Chân Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_thainhat.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: VLTK_data\KVCT3_Data\YinYang_a.blp
#
# 10. Mê Tung Huyễn Ảnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\MeTungHuyenAnh.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Zap1.blp
#         texture: VLTK_data\Loose\Bakua_b.blp
#
# 11. Vô Thượng Kiếm Đạo [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vothuongkiem.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZapBlue1.blp
#         texture: VLTK_data\KVCT3_Data\CircleBlue.blp
#         texture: VLTK_data\KVCT3_Data\StarBlue.blp
#         texture: VLTK_data\KVCT3_Data\ZapLightning1X4.blp
#         texture: VLTK_data\KVCT3_Data\GlowBlue.blp
#         texture: VLTK_data\KVCT3_Data\222.blp
#    lúc tung (trên tướng): VDK_vothuongcastereffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_01.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_02.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_03.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_04.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_05.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_06.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_07.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_08.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_09.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_10.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_11.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_12.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_13.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_14.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_15.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_Slash_Lightning_16.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning1.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning2.blp
#    trên địch bị trúng: VDK_vothuongtarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N2s_star2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N3s_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_star.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_glow1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_glow.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N4s_star2.blp
#    lớp thêm tại điểm 1: VDK_vothuongcast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\gumujianzhen.blp
#    lớp thêm tại điểm 2: VDK_vocuckiemy.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#
# 12. Thái Cực Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_vocuckiemy.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_1_4x2.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_10_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_9_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_3_4x4.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Integration_Lightning_1.blp
#         texture: VLTK_data\KVCT3_Data\BY_Wood_Effect_Texture_Sequence_Lightning_8_4x4.blp
#
# 13. Tử Tiêu Hoành Vân [T]   (kind 18, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): VDK_tutieuhoanhvan.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_GenericGlow.blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp
#         texture: VLTK_data\KVCT3_Data\Effect_AZ_Shockwave2B.blp
#    buff (trên tướng): VDK_tutieubuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GameBABY_a1101.blp
#         texture: VLTK_data\KVCT3_Data\GameBABY_a1102.blp
# ===== HẾT DANH MỤC =====
