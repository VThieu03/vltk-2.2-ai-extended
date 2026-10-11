# DMPT: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Tán Hoa Tiêu": {   # [Q]
        "main": "DMPT_tanhoatieu.mdx",
        "target": "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl",
    },
    "Đường Môn Ám Khí": {   # [bị động]
        "main": "DMPT_cankhonnhattrich.mdx",
    },
    "Mê Ảnh Tung": {   # [F]
        "main": "DMPT_cankhonnhattrich2.mdx",
    },
    "Tôi Độc Thuật": {   # [bị động]
        "main": "DMPT_cankhonnhattrich3.mdx",
        "aura": "DMTT_toidocaura.mdx",
    },
    "Mãn Thiên Hoa Vũ": {   # [R]
        "main": "DMPT_cankhontarget.mdx",
        "target": "Abilities\\Weapons\\DemonHunterMissile\\DemonHunterMissile.mdl",
    },
    "Tâm Nhãn": {   # [bị động]
        "main": "MDX\\TamNhan.mdx",
    },
    "Cửu Cung Phi Tinh": {   # [W]
        "main": "DMPT_cuucung4.mdx",
        "target": "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl",
    },
    "Hàm Sa Xạ Ảnh": {   # [bị động]
        "main": "DMPT_cuucung5.mdx",
    },
    "Mê Hồn Trận": {   # [bị động]
        "main": "DMPT_mehontrap.mdx",
    },
    "Ảnh Tung Trận": {   # [D]
        "main": "DMPD_anhtungtranaura.mdx",
        "area": ["DMPD_anhtungtran.mdx"],
    },
    "Càn Khôn Nhất Trịch": {   # [E]
        "main": "DMPT_kimnguyenbao.mdx",
        "target": ["DMPT_cankhontarget.mdx", "DMPT_cankhonnhattrich3.mdx"],
        "area": ["DMPT_cankhonnhattrich2.mdx"],
    },
    "Truy Hồn Đoạt Mệnh": {   # [bị động]
        "main": "DMPT_thiettoahg.mdx",
    },
    "Thiết Tỏa Hoành Giang": {   # [T]
        "cast": {"file": "DMPT_thiettoahg.mdx", "ground": True},
        "target": {"file": "DMPT_thiettoataget.mdx", "ground": True},
        "buff": "DMPT_thiettoabuff.mdx",
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
# 1. Tán Hoa Tiêu [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_tanhoatieu.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\lingyongwq.blp
#    trên địch bị trúng: Objects\Spawnmodels\Critters\Albatross\CritterBloodAlbatross.mdl   [model gốc Warcraft III]
#
# 2. Đường Môn Ám Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cankhonnhattrich.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp
#         texture: Textures\Yellow_Star.blp
#
# 3. Mê Ảnh Tung [F]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cankhonnhattrich2.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp
#         texture: Textures\Yellow_Star.blp
#
# 4. Tôi Độc Thuật [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cankhonnhattrich3.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp
#         texture: Textures\Yellow_Star.blp
#    aura bị động (gắn tướng suốt): DMTT_toidocaura.mdx   [dùng chung (cùng dùng: DMPD, DMTT)]
#         texture: VLTK_data\KVCT3_Data\VenArt.BLP
#
# 5. Mãn Thiên Hoa Vũ [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cankhontarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\zd070.blp
#         texture: VLTK_data\KVCT3_Data\zd071.blp
#         texture: VLTK_data\KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\zd073.blp
#    trên địch bị trúng: Abilities\Weapons\DemonHunterMissile\DemonHunterMissile.mdl   [model gốc Warcraft III]
#
# 6. Tâm Nhãn [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\TamNhan.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: DMPD, DMTT)]
#         texture: Textures\Energy1Color.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Yellow_Star.blp
#
# 7. Cửu Cung Phi Tinh [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cuucung4.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ui_chilun_00.blp
#    trên địch bị trúng: Objects\Spawnmodels\Critters\Albatross\CritterBloodAlbatross.mdl   [model gốc Warcraft III]
#
# 8. Hàm Sa Xạ Ảnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_cuucung5.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ui_chilun_00.blp
#
# 9. Mê Hồn Trận [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_mehontrap.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Purple_Glow.blp
#         texture: VLTK_data\KVCT3_Data\LuuThuyQuyet.blp
#         texture: Textures\Yellow_Glow.blp
#
# 10. Ảnh Tung Trận [D]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPD_anhtungtranaura.mdx   [dùng chung (cùng dùng: DMPD)]
#         texture: VLTK_data\KVCT3_Data\mofazhendizuo2.blp
#    lớp thêm tại điểm 1: DMPD_anhtungtran.mdx   [dùng chung (cùng dùng: DMPD)]
#         texture: Buildings\Human\AltarOfKings\AltarOfKings.blp
#         texture: Buildings\Human\HumanLumberMill\HumanLumberMill.blp
#         texture: VLTK_data\KVCT3_Data\OrderFlag3.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\wavering_bw.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\smoke_bw.blp
#         texture: VLTK_data\KVCT3_Data\flarering_bw.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple01_bw.blp
#         texture: VLTK_data\KVCT3_Data\flareshot01_bw.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple02_bw.blp
#         texture: UI\MiniMap\ping4.blp
#
# 11. Càn Khôn Nhất Trịch [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_kimnguyenbao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JD-faguangyuanbao2.blp
#         texture: VLTK_data\KVCT3_Data\JD-faguangyuanbao1.blp
#         texture: ReplaceableTextures\TeamColor\TeamColor04.blp
#         texture: VLTK_data\KVCT3_Data\JD-faguangyuanbao3.blp
#    trên địch bị trúng: DMPT_cankhontarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\zd070.blp
#         texture: VLTK_data\KVCT3_Data\zd071.blp
#         texture: VLTK_data\KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\zd073.blp
#    trên địch bị trúng 2: DMPT_cankhonnhattrich3.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp
#         texture: Textures\Yellow_Star.blp
#    lớp thêm tại điểm 1: DMPT_cankhonnhattrich2.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0002.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0003.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0004.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0005.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0006.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0007.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0008.blp
#         texture: VLTK_data\KVCT3_Data\YXJNTX-jingqianbaozha-0009.blp
#         texture: Textures\Yellow_Star.blp
#
# 12. Truy Hồn Đoạt Mệnh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_thiettoahg.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv2.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv3.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv4.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv5.blp
#
# 13. Thiết Tỏa Hoành Giang [T]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DMPT_thiettoahg.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv2.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv3.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv4.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv5.blp
#    lúc tung (trên tướng): DMPT_thiettoahg.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv2.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\Shockwave1.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv3.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv4.blp
#         texture: VLTK_data\KVCT3_Data\JN_dituci_lv5.blp
#    trên địch bị trúng: DMPT_thiettoataget.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp
#         texture: Textures\GenericGlowFaded.blp
#    buff (trên tướng): DMPT_thiettoabuff.mdx   [riêng phái]
#         texture: Textures\star4.blp
# ===== HẾT DANH MỤC =====
