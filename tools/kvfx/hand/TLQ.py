# TLQ: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Long Trảo Hổ Trảo": {   # [Q]
        "main": "TLQ_longtraohotrao.mdx",
        "target": "TLQ_targeteffect.mdx",
    },
    "Thiếu Lâm Quyền Pháp": {   # [bị động]
        "main": "TLQ_kimcangchuongeffect2.mdx",
    },
    "Dịch Cân Kinh": {   # [bị động]
        "main": "TLQ_kimcuongchuongefffect3.mdx",
    },
    "Sư Tử Hống": {   # [R]
        "main": "TLQ_sutuhong.mdx",
        "target": ["TLQ_targeteffect.mdx", "HydraliskImpact.mdx"],
        "buff": "TLQ_sutuhongbuff.mdx",
    },
    "Bồ Đề Tâm Pháp": {   # [D]
        "main": "TLQ_kimcuongeff2.mdx",
        "cast": "TLD_bodetamphapcast.mdx",
    },
    "Như Lai Thiên Diệp": {   # [bị động]
        "main": "TLQ_nhulai.mdx",
    },
    "Kim Cương Phục Ma": {   # [W]
        "main": "TLQ_kimcuongphucma.mdx",
        "target": {"file": "TLQ_kimcuongtarget.mdx", "ground": True},
        "area": ["TLQ_kimcuongeff2.mdx"],
    },
    "La Hán Kim Thân": {   # [F]
        "main": "TLQ_lahanbuff.mdx",
        "cast": "TLQ_lahankimthancast.mdx",
        "buff": "TLQ_lahanbuff2.mdx",
    },
    "Đạt Ma Võ Kinh": {   # [bị động]
        "main": "TLQ_nhulai.mdx",
    },
    "Hỗn Nguyên Nhất Khí": {   # [bị động]
        "main": "MDX\\HonNguyenNhatKhi.mdx",
    },
    "Đại Lực Kim Cang Chưởng": {   # [E]
        "main": "TLQ_votuongeffect.mdx",
        "target": {"file": "TLQ_targeteffect.mdx", "ground": True},
        "area": ["TLQ_kimcangchuongeffect1.mdx", "TLQ_kimcuongchuongefffect3.mdx"],
    },
    "Vô Tướng Thần Công": {   # [bị động]
        "main": "TLQ_votuongeffect.mdx",
    },
    "Thiên Thủ Như Lai Ấn": {   # [T]
        "main": "TLQ_nhulai.mdx",
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
# 1. Long Trảo Hổ Trảo [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_longtraohotrao.mdx   [riêng phái]
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Palm.BLP
#         texture: Textures\Flame4.blp
#         texture: Textures\lensflare1A.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\LavaLump2.blp
#    trên địch bị trúng: TLQ_targeteffect.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: abilities\Spells\NightElf\Blink\Star11d.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#
# 2. Thiếu Lâm Quyền Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_kimcangchuongeffect2.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#
# 3. Dịch Cân Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_kimcuongchuongefffect3.mdx   [riêng phái]
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\star4.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3-1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke_yello2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning27.blp
#         texture: Textures\Flare.blp
#
# 4. Sư Tử Hống [R]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_sutuhong.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_01.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_04.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_07.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_08.blp
#         texture: VLTK_data\KVCT3_Data\Hero_EarthShaker_N3S_A_source_09.blp
#    trên địch bị trúng: TLQ_targeteffect.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: abilities\Spells\NightElf\Blink\Star11d.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    trên địch bị trúng 2: HydraliskImpact.mdx   [dùng chung (cùng dùng: DMTT, TVT)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#    buff (trên tướng): TLQ_sutuhongbuff.mdx   [riêng phái]
#         texture: Textures\pixies1.blp
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Doodads\Cinematic\IcecrownObelisk\Glow_Runes.blp
#
# 5. Bồ Đề Tâm Pháp [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_kimcuongeff2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Flare.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_LightningBall.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Crack.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White11.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_lightning24x4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_2lightning.blp
#    lúc tung (trên tướng): TLD_bodetamphapcast.mdx   [dùng chung (cùng dùng: TLD)]
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\firering4.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_NE.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\GodCorss.blp
#
# 6. Như Lai Thiên Diệp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_nhulai.mdx   [riêng phái]
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\YuNie1.blp
#         texture: VLTK_data\KVCT3_Data\YuNie2.blp
#
# 7. Kim Cương Phục Ma [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_kimcuongphucma.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\Zap1.blp
#         texture: Textures\Blue_Star2.blp
#         texture: VLTK_data\KVCT3_Data\Buddha.blp
#         texture: VLTK_data\KVCT3_Data\PhatQuangChienKhi.blp
#         texture: Textures\GenericGlow64.blp
#    trên địch bị trúng: TLQ_kimcuongtarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    lớp thêm tại điểm 1: TLQ_kimcuongeff2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Flare.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_LightningBall.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Crack.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_Shockwave1White11.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_lightning24x4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_STormSpirit_N2S_2lightning.blp
#
# 8. La Hán Kim Thân [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_lahanbuff.mdx   [riêng phái]
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\star4.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3-1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke_yello2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning27.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TLQ_lahankimthancast.mdx   [riêng phái]
#         texture: Textures\Star8.blp
#         texture: Textures\Star7b.blp
#         texture: Textures\firering1A.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\DemonRune5.blp
#         texture: VLTK_data\KVCT3_Data\Buddha.blp
#    buff (trên tướng): TLQ_lahanbuff2.mdx   [riêng phái]
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\star4.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3-1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke_yello2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning27.blp
#         texture: Textures\Flare.blp
#
# 9. Đạt Ma Võ Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_nhulai.mdx   [riêng phái]
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\YuNie1.blp
#         texture: VLTK_data\KVCT3_Data\YuNie2.blp
#
# 10. Hỗn Nguyên Nhất Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\HonNguyenNhatKhi.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#         texture: VLTK_data\Loose\Ping.blp
#
# 11. Đại Lực Kim Cang Chưởng [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_votuongeffect.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\star2_32.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: VLTK_data\KVCT3_Data\PalmShaoLin.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    trên địch bị trúng: TLQ_targeteffect.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: abilities\Spells\NightElf\Blink\Star11d.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\star32.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#    lớp thêm tại điểm 1: TLQ_kimcangchuongeffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\rlz.blp
#    lớp thêm tại điểm 2: TLQ_kimcuongchuongefffect3.mdx   [riêng phái]
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\AuraRune7Green.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\star4.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3-1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke_yello2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Lightning27.blp
#         texture: Textures\Flare.blp
#
# 12. Vô Tướng Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_votuongeffect.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\star2_32.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: VLTK_data\KVCT3_Data\PalmShaoLin.blp
#         texture: VLTK_data\KVCT3_Data\BuddhistRoar.blp
#
# 13. Thiên Thủ Như Lai Ấn [T]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLQ_nhulai.mdx   [riêng phái]
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\YuNie1.blp
#         texture: VLTK_data\KVCT3_Data\YuNie2.blp
# ===== HẾT DANH MỤC =====
