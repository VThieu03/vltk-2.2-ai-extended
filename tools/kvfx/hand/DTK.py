# DTK: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.

VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Kim Ngọc Mãn Đường": {   # [Q]
        "main": "DTK_kimngocmanduong.mdx", "scale": 0.3,
        "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl",
    },
    "Đoàn Thị Tâm Pháp": {   # [bị động]
        "main": "DTK_khithontarget.mdx",
    },
    "Bắc Minh Thần Công": {   # [bị động]
        "main": "MDX\\BacMinhThanCong.mdx",
        "aura": "DTK_bacminhaura.mdx",
    },
    "Lục Kiếm Tề Phát": {   # [bị động]
        "main": "DTK_luckiemtarget.mdx","scale": 0.3,
    },
    "Khô Vinh Thiền Công": {   # [bị động]
        "main": "DTK_luckiemtarget.mdx",
    },
    "Đoàn Gia Khí Kiếm": {   # [bị động]
        "main": "DTK_lucmachtarget42.mdx",
    },
    "Lục Mạch Thần Kiếm": {   # [W]
        "main": "DTK_lucmachcaster.mdx","scale": 0.3,
        "cast": "DTK_lucmachcaster.mdx","scale": 0.3,
        "target": "DTK_lucmachtarget42.mdx","scale": 0.3,
    },
    "Kinh Thiên Nhất Kiếm": {   # [R]
        "main": "DTK_kimngocmanduong.mdx","scale": 0.3,
    },
    "Bách Hồng Thực Nhật": {   # [bị động]
        "main": "DTK_lucmachthankiem3.mdx",
    },
    "Luyện Khí Hoàn Thần": {   # [bị động]
        "main": "DTK_luyenkhibuff.mdx",
        "area": ["DTK_luyenkhihh.mdx", "DTK_luyenkhi.mdx"],
    },
    "Khí Thôn Vạn Lý": {   # [E]
        "main": "DTK_khithonvanly.mdx","scale": 0.3,
        "target": {"file": "DTK_khithoneffect.mdx", "ground": True},
    },
    "Thiên Long Thần Công": {   # [bị động]
        "main": "DTK_lucmachthankiem6.mdx",
    },
    "Ám Hương Sơ Ảnh": {   # [bị động]
        "main": "DTK_luyenkhi.mdx",
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
# 1. Kim Ngọc Mãn Đường [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [riêng phái, phái khác cũng dùng: DTC]
#         texture: VLTK_data\KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning1.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning2.blp
#    trên địch bị trúng: Abilities\Spells\Undead\FrostArmor\FrostArmorDamage.mdl   [model gốc Warcraft III]
#
# 2. Đoàn Thị Tâm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_khithontarget.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\RibbonNE1_blue.blp
#
# 3. Bắc Minh Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\BacMinhThanCong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\star4.blp
#    aura bị động (gắn tướng suốt): DTK_bacminhaura.mdx   [riêng phái]
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\Blue_Star2.blp
#
# 4. Lục Kiếm Tề Phát [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luckiemtarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx019-1.blp
#         texture: VLTK_data\KVCT3_Data\tx019-2.blp
#         texture: VLTK_data\KVCT3_Data\tx019-3.blp
#
# 5. Khô Vinh Thiền Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luckiemtarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx019-1.blp
#         texture: VLTK_data\KVCT3_Data\tx019-2.blp
#         texture: VLTK_data\KVCT3_Data\tx019-3.blp
#
# 6. Đoàn Gia Khí Kiếm [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachtarget42.mdx   [riêng phái]
#         texture: Textures\Frost3.blp
#         texture: Textures\Star7b.blp
#         texture: VLTK_data\KVCT3_Data\tx061.blp
#
# 7. Lục Mạch Thần Kiếm [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachcaster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_BallisticQ1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Tornado11b.blp
#         texture: Textures\Flare.blp
#         texture: Textures\sun.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave14.blp
#         texture: Textures\Tornado2b.blp
#    lúc tung (trên tướng): DTK_lucmachcaster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_BallisticQ1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Tornado11b.blp
#         texture: Textures\Flare.blp
#         texture: Textures\sun.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave14.blp
#         texture: Textures\Tornado2b.blp
#    trên địch bị trúng: DTK_lucmachtarget42.mdx   [riêng phái]
#         texture: Textures\Frost3.blp
#         texture: Textures\Star7b.blp
#         texture: VLTK_data\KVCT3_Data\tx061.blp
#
# 8. Kinh Thiên Nhất Kiếm [R]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_kimngocmanduong.mdx   [riêng phái, phái khác cũng dùng: DTC]
#         texture: VLTK_data\KVCT3_Data\Dawn_slash_Shoot.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning1.blp
#         texture: VLTK_data\KVCT3_Data\Dawn_lightning2.blp
#
# 9. Bách Hồng Thực Nhật [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachthankiem3.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx09_3.blp
#
# 10. Luyện Khí Hoàn Thần [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_luyenkhibuff.mdx   [riêng phái]
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\CrystalSheild.blp
#         texture: Textures\star4.blp
#    lớp thêm tại điểm 1: DTK_luyenkhihh.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare6.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Tornado2b.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave12.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: VLTK_data\KVCT3_Data\Disruptor_Aghanim1_purple.blp
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
# 11. Khí Thôn Vạn Lý [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_khithonvanly.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\flareshot01_bw.blp
#         texture: VLTK_data\KVCT3_Data\dust3.blp
#         texture: VLTK_data\KVCT3_Data\RoyalGlow.blp
#         texture: Textures\Purple_Star.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple01_bw.blp
#         texture: VLTK_data\KVCT3_Data\flaresimple02_bw.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: VLTK_data\KVCT3_Data\smoke_bw.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: VLTK_data\KVCT3_Data\flash01_bw.blp
#    trên địch bị trúng: DTK_khithoneffect.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Knife_light1o.blp
#         texture: VLTK_data\KVCT3_Data\AZ_GlowBlue2.blp
#         texture: Textures\Smoke.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Knife_light2j.blp
#
# 12. Thiên Long Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): DTK_lucmachthankiem6.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\tx09_6.blp
#
# 13. Ám Hương Sơ Ảnh [bị động]   (kind 0, bảng tay)
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
