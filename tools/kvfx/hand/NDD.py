# NDD: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Huyết Đao Độc Sát": {   # [Q]
        "main": "NDD_huyetdao.mdx",
        "target": r"Abilities\Weapons\GargoyleMissile\GargoyleMissile.mdl",
    },
    "Ngũ Độc Đao Pháp": {   # [bị động]
        "main": "NDD_chucapcoc.mdx",
    },
    "Vô Hình Cổ": {   # [F]
        "main": "NDD_sauvohinh.mdx",
        "target": r"Abilities\Spells\NightElf\Immolation\ImmolationDamage.mdl",
    },
    "Bách Độc Xuyên Tâm": {   # [R]
        "main": "NDD_bachdocxuyentam.mdx",
        "target": r"Abilities\Weapons\GreenDragonMissile\GreenDragonMissile.mdl",
    },
    "Vạn Cổ Thực Tâm": {   # [bị động]
        "main": "NDD_vancobuff.mdx",
    },
    "Ngũ Độc Kỳ Kinh": {   # [bị động]
        "main": "NDD_huyetdao.mdx",
    },
    "Huyền Âm Trảm": {   # [W]
        "main": "NDD_huyenamdao.mdx",
        "cast": r"Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl",
        "target": "NDD_huyenamtarget.mdx",
    },
    "Chu Cáp Thanh Minh": {   # [D]
        "main": "NDD_chucapcoc.mdx",
        "target": r"Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl",
        "area": [
            "NDD_chucapeffect.mdx",
            r"Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl",
        ],
    },
    "Hóa Huyết Tiệt Mạch": {   # [bị động]
        "main": "NDD_huyetdao.mdx",
    },
    "Huyết Đỉnh Công": {   # [bị động]
        "main": "NDD_huyetdao.mdx",
    },
    "U Hồn Phệ Ảnh": {   # [E]
        "main": "NDD_uhonpheanh.mdx",
        "cast": [
            "NDD_uhonpheanh2.mdx",
            r"Abilities\Spells\Undead\DeathCoil\DeathCoilSpecialArt.mdl",
        ],
        "target": {"file": "NDD_uhonpheanhtarget.mdx", "ground": True},
        "area": ["NDD_uhonpheanh3.mdx", "NDD_uhoncast.mdx"],
    },
    "Thiên Thù Vạn Độc": {   # [bị động]
        "main": "NDD_bachdocxuyentam.mdx",
    },
    "U Minh Khô Lâu": {   # [T]
        "target": "NDC_uminhkholautarget.mdx",
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
# 1. Huyết Đao Độc Sát [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_huyetdao.mdx   [riêng phái]
#         texture: Textures\HeroDemonHunter.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Dust3.blp
#    trên địch bị trúng: Abilities\Weapons\GargoyleMissile\GargoyleMissile.mdl   [model gốc Warcraft III]
#
# 2. Ngũ Độc Đao Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_chucapcoc.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GW_hama.blp
#
# 3. Vô Hình Cổ [F]   (kind 14, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_sauvohinh.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: VLTK_data\KVCT3_Data\SauVoHinh.BLP
#         texture: Textures\Green_Glow3.blp
#    trên địch bị trúng: Abilities\Spells\NightElf\Immolation\ImmolationDamage.mdl   [model gốc Warcraft III]
#
# 4. Bách Độc Xuyên Tâm [R]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_bachdocxuyentam.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Blue_Star.blp
#    trên địch bị trúng: Abilities\Weapons\GreenDragonMissile\GreenDragonMissile.mdl   [model gốc Warcraft III]
#
# 5. Vạn Cổ Thực Tâm [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_vancobuff.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: Textures\Flare.blp
#
# 6. Ngũ Độc Kỳ Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_huyetdao.mdx   [riêng phái]
#         texture: Textures\HeroDemonHunter.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Dust3.blp
#
# 7. Huyền Âm Trảm [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_huyenamdao.mdx   [riêng phái]
#         texture: Textures\HeroLich.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#    lúc tung (trên tướng): Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl   [model gốc Warcraft III]
#    trên địch bị trúng: NDD_huyenamtarget.mdx   [riêng phái]
#         texture: Textures\Dust3.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Green_Star.blp
#         texture: Textures\RibbonNE1.blp
#         texture: Textures\ShockwaveWater1Black.blp
#         texture: Textures\DrainIn.blp
#
# 8. Chu Cáp Thanh Minh [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_chucapcoc.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GW_hama.blp
#    trên địch bị trúng: Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: NDD_chucapeffect.mdx   [riêng phái]
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\ShockwaveWater1.blp
#    lớp thêm tại điểm 2: Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl   [model gốc Warcraft III]
#
# 9. Hóa Huyết Tiệt Mạch [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_huyetdao.mdx   [riêng phái]
#         texture: Textures\HeroDemonHunter.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Dust3.blp
#
# 10. Huyết Đỉnh Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_huyetdao.mdx   [riêng phái]
#         texture: Textures\HeroDemonHunter.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Dust3.blp
#
# 11. U Hồn Phệ Ảnh [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_uhonpheanh.mdx   [riêng phái]
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): NDD_uhonpheanh2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Leaf4x4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave15.blp
#         texture: VLTK_data\KVCT3_Data\EarthSpirit_wave5.blp
#    trên địch bị trúng: NDD_uhonpheanhtarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\flare1_tail.blp
#         texture: VLTK_data\KVCT3_Data\FallingStar02_line.blp
#         texture: VLTK_data\KVCT3_Data\BF_shockwaveFx2c.blp
#         texture: VLTK_data\KVCT3_Data\Shockwave6_Green.blp
#         texture: VLTK_data\KVCT3_Data\Flare2_w.blp
#         texture: Textures\leaf4x4.blp
#         texture: VLTK_data\KVCT3_Data\FlameFx_white_8x8.blp
#         texture: VLTK_data\KVCT3_Data\flame4x4_blur.blp
#    lúc tung 2 (trên tướng): Abilities\Spells\Undead\DeathCoil\DeathCoilSpecialArt.mdl   [model gốc Warcraft III]
#    lớp thêm tại điểm 1: NDD_uhonpheanh3.mdx   [riêng phái]
#         texture: Textures\HeroLich.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\Green_Glow2.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#    lớp thêm tại điểm 2: NDD_uhoncast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_BloodDripRed.blp
#         texture: VLTK_data\KVCT3_Data\AZ_BloodRed2X2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_smoke_red_2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave2B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb16.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon36.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke5.blp
#
# 12. Thiên Thù Vạn Độc [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_bachdocxuyentam.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Blue_Star.blp
#
# 13. U Minh Khô Lâu [T]   (kind 15, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): NDD_chucapcoc.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GW_hama.blp
#    trên địch bị trúng: NDC_uminhkholautarget.mdx   [dùng chung (cùng dùng: NDC)]
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Dust3.blp
#         texture: Textures\Red_Glow1.blp
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Red_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_2x8.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Fire04_4x4.blp
#         texture: VLTK_data\KVCT3_Data\7fx_lightraysup_full2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb9.blp
#         texture: VLTK_data\KVCT3_Data\kulou001.blp
# ===== HẾT DANH MỤC =====
