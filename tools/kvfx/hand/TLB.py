# TLB: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Phổ Độ Côn Pháp": {   # [Q]
        "main": "TLB_targeteffect.mdx",
        "target": "TLB_targeteffect.mdx",
    },
    "Thiếu Lâm Côn Pháp": {   # [bị động]
        "main": "TLB_lasatcon2.mdx",
    },
    "Dịch Cân Kinh": {   # [bị động]
        "main": "TLB_nhuythuccotcong.mdx",
    },
    "A La Hán Thần Công": {   # [bị động]
        "main": "TLB_targeteffect.mdx",
        "aura": "TLD_lahantran.mdx",
    },
    "Bất Động Minh Vương": {   # [D]
        "main": "TLB_batdongbuff.mdx",
        "cast": "TLB_batdongcast.mdx",
        # Effect\Protectionaura.mdx is referenced by object data but absent from the KVCT asset archive.
        "target": r"Abilities\Spells\Human\DivineShield\DivineShieldTarget.mdl",
        "buff": "war3mapImported\\Effect_fire2.mdx",
    },
    "Như Lai Thiên Diệp": {   # [bị động]
        "main": "TLB_vidaeffect.mdx",
    },
    "Thất Tinh La Sát Côn": {   # [W]
        "main": "TLB_lasatcon11.mdx",
        "target": "TLB_targeteffect.mdx",
        "area": ["TLB_lasatcon2.mdx"],
        "cast": ["TLB_lasatcon11.mdx", "TLB_lasatcon2.mdx"],
    },
    "Túy Tiên Bát Côn": {   # [R]
        "main": "TLB_lasatcon11.mdx",
        "target": "TLB_targeteffect.mdx",
        "cast": ["TLB_lasatcon11.mdx", "TLB_lasatcon2.mdx"],
        "area": ["TLB_lasatcon2.mdx", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl"],
    },
    "Kim Cang Bất Hoại": {   # [bị động]
        "main": "TLB_kimcangbuff.mdx",
    },
    "Như Ý Thúc Cốt Công": {   # [F]
        "main": "TLB_nhuythuccotcong.mdx",
    },
    "Vi Đà Hiến Chử": {   # [E]
        "main": "TLB_vidaeffect.mdx",
        "cast": "TLB_vidacast.mdx",
        "target": {"file": "TLB_vidatarget.mdx", "ground": True},
        "area": ["TLB_vidatarget.mdx", "TLB_vidaeffect.mdx"],
    },
    "Ma Kha Vô Lượng": {   # [bị động]
        "main": "TLB_tuytienbatcon.mdx",
        "aura": "Abilities\\Spells\\NightElf\\FaerieDragonInvis\\FaerieDragon_Invis.mdl",
    },
    "Tẩy Tủy Kinh": {   # [bị động]
        "main": "TLB_vidaeffect.mdx",
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
# 1. Phổ Độ Côn Pháp [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_targeteffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon13.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave25.blp
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon13.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave25.blp
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#
# 2. Thiếu Lâm Côn Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 3. Dịch Cân Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_nhuythuccotcong.mdx   [riêng phái]
#         texture: Textures\sun.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Red_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flash4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb2p.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\jswuqi1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune6.blp
#         texture: VLTK_data\KVCT3_Data\Xin_E_Effect.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune2.blp
#         texture: Textures\Yellow_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave31.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon03.blp
#
# 4. A La Hán Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_targeteffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon13.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave25.blp
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#    aura bị động (gắn tướng suốt): TLD_lahantran.mdx   [dùng chung (cùng dùng: TLD)]
#         texture: Textures\LavaLump.blp
#         texture: VLTK_data\KVCT3_Data\tx208-1.blp
#         texture: VLTK_data\KVCT3_Data\tx208-2.blp
#
# 5. Bất Động Minh Vương [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_batdongbuff.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo_frost.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#    lúc tung (trên tướng): TLB_batdongcast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\EarthSpirit_F3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1x.blp
#         texture: VLTK_data\KVCT3_Data\Flare2.blp
#    trên địch bị trúng: Abilities\Spells\Human\DivineShield\DivineShieldTarget.mdl   [model gốc Warcraft III]
#    buff (trên tướng): Effect_fire2.mdx   [dùng chung (cùng dùng: NMC)]
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Lords0000.blp
#         texture: Textures\Lords0001.blp
#         texture: Textures\Lords0002.blp
#         texture: Textures\Lords0003.blp
#         texture: Textures\Lords0004.blp
#         texture: Textures\Lords0005.blp
#         texture: Textures\Lords0006.blp
#         texture: Textures\Lords0007.blp
#         texture: Textures\Water_Particles.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\LavaLump2.blp
#
# 6. Như Lai Thiên Diệp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave21.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave17.blp
#         texture: VLTK_data\KVCT3_Data\star2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
#
# 7. Thất Tinh La Sát Côn [W]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon11.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    lúc tung (trên tướng): TLB_lasatcon11.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon13.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave25.blp
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#    lúc tung 2 (trên tướng): TLB_lasatcon2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    lớp thêm tại điểm 1: TLB_lasatcon2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 8. Túy Tiên Bát Côn [R]   (kind 18, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon11.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    lúc tung (trên tướng): TLB_lasatcon11.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon13.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave25.blp
#         texture: VLTK_data\KVCT3_Data\BlastFlash.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#    lúc tung 2 (trên tướng): TLB_lasatcon2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    lớp thêm tại điểm 1: TLB_lasatcon2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\carck_tp_dust.blp
#         texture: VLTK_data\KVCT3_Data\crack_tp.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo2.blp
#         texture: VLTK_data\KVCT3_Data\flarer1white.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light1M.blp
#         texture: VLTK_data\KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\flare4x4.blp
#         texture: VLTK_data\KVCT3_Data\chongjibo3.blp
#         texture: VLTK_data\KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: VLTK_data\KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#    lớp thêm tại điểm 2: Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl   [model gốc Warcraft III]
#
# 9. Kim Cang Bất Hoại [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_kimcangbuff.mdx   [riêng phái]
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\star4_32.blp
#         texture: Abilities\Spells\Undead\RegenerationAura\DarkSummon.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: VLTK_data\KVCT3_Data\Flare.blp
#         texture: Textures\Eyes.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Textures\ToonSmokeX.blp
#         texture: Textures\star5tga.blp
#
# 10. Như Ý Thúc Cốt Công [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_nhuythuccotcong.mdx   [riêng phái]
#         texture: Textures\sun.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Red_Glow2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flash4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb2p.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\jswuqi1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune6.blp
#         texture: VLTK_data\KVCT3_Data\Xin_E_Effect.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Rune2.blp
#         texture: Textures\Yellow_Glow3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave31.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon03.blp
#
# 11. Vi Đà Hiến Chử [E]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave21.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave17.blp
#         texture: VLTK_data\KVCT3_Data\star2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TLB_vidacast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\animeslash.blp
#         texture: VLTK_data\KVCT3_Data\animeslashp.blp
#         texture: Textures\GenericGlow1.blp
#    trên địch bị trúng: TLB_vidatarget.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP
#    lớp thêm tại điểm 1: TLB_vidatarget.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP
#    lớp thêm tại điểm 2: TLB_vidaeffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave21.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave17.blp
#         texture: VLTK_data\KVCT3_Data\star2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
#
# 12. Ma Kha Vô Lượng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_tuytienbatcon.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Knife_light1M.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1U.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Splast2x2.blp
#         texture: Textures\Flare.blp
#    aura bị động (gắn tướng suốt): Abilities\Spells\NightElf\FaerieDragonInvis\FaerieDragon_Invis.mdl   [model gốc Warcraft III]
#
# 13. Tẩy Tủy Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave21.blp
#         texture: VLTK_data\KVCT3_Data\AZ_FlareWhite1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb5.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave17.blp
#         texture: VLTK_data\KVCT3_Data\star2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
# ===== HẾT DANH MỤC =====
