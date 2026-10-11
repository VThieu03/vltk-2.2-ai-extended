# TND: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    "Thiên Ngoại Lưu Tinh": {
        "main": {"file": "TND_thienngoaistone.mdx", "scale": 0.1},
        "cast": {"file": "TND_tathoacast.mdx", "ground": True},
        "target": "TND_tathoatarget.mdx",
        "area": ["TND_thienngoaifire.mdx"],
        "hits": 1,
    },
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Đạn Chỉ Liệt Diệm": {   # [Q]
        "main": "TND_thoisonfire.mdx",
        "target"  : "TND_thoisonfire.mdx",
    },
    "Thiên Nhẫn Đao Pháp": {   # [bị động]
        "main": "TND_thienngoaifire.mdx",
        "cast": "TND_thienngoailuutinhcaster.mdx",
        "area": ["TND_thienngoaistone.mdx"],
    },
    "Hỏa Liên Phần Hoa": {   # [D]
        "main": "TND_hoalienhole.mdx",
        "target": "TND_hoalieneffect.mdx",
    },
    "Thôi Sơn Điền Hải": {   # [R]
        "main": "TND_thoisonfire.mdx",
        "target": "TND_thoisonfire.mdx",
    },
    "Nhiếp Hồn Loạn Tâm": {   # [F]
        "main": "TND_nhiephoneffect.mdx",
        "target": "TND_nhiephontarget.mdx",
    },
    "Xí Không Ma Diệm": {   # [bị động]
        "main": "TND_madao.mdx",
    },
    "Thúc Phọc Chú": {   # [bị động]
        "main": "TND_thucphocchubuff.mdx",
    },
    "Nghịch Chuyển Tâm Kinh": {   # [bị động]
        "main": "TND_nghichchuyenbuff.mdx",
    },
    "Ma Đao Thôn Thần": {   # [T]
        "main": "TND_madao.mdx",
    },
    "Tật Hỏa Liêu Nguyên": {   # [E]
        "main": "TND_tathoafire.mdx",
        "cast": {"file": "TND_tathoacast.mdx", "ground": True},
        "target": "TND_tathoatarget.mdx",
        "area": ["TND_bladerain.mdx", "TND_tathoafire2.mdx"],
    },
    "Ma Diệm Thất Sát": {   # [bị động]
        "main": "TND_thienngoaifire.mdx",
    },
    "Huyền Minh Hấp Tinh": {   # [bị động]
        "main": "TND_nghichchuyenbuff.mdx",
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
# 1. Đạn Chỉ Liệt Diệm [Q]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_danchifire.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Abilities\Spells\Demon\DarkPortal\DemonRune1backup.blp
#
# 2. Thiên Nhẫn Đao Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_thienngoaifire.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Crack12.blp
#         texture: VLTK_data\KVCT3_Data\Xin_T2_O.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Crack11.blp
#    lúc tung (trên tướng): TND_thienngoailuutinhcaster.mdx   [riêng phái]
#         texture: Textures\star4_32.blp
#         texture: Textures\Flare.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Star3.blp
#         texture: Textures\RibbonNE1_blue.blp
#    lớp thêm tại điểm 1: TND_thienngoaistone.mdx   [riêng phái]
#         texture: units\Demon\Infernal\Infernal.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\star32.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\grad2b.blp
#
# 3. Hỏa Liên Phần Hoa [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_hoalienhole.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\xuanwo1.blp
#         texture: Textures\Clouds8x8Mod.blp
#    trên địch bị trúng: TND_hoalieneffect.mdx   [riêng phái]
#         texture: Textures\Star7b.blp
#
# 4. Thôi Sơn Điền Hải [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_thoisonfire.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\FireAnima4x4.blp
#         texture: Textures\Flare.blp
#    trên địch bị trúng: TND_thoisonfire.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\FireAnima4x4.blp
#         texture: Textures\Flare.blp
#
# 5. Nhiếp Hồn Loạn Tâm [F]   (kind 15, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_nhiephoneffect.mdx   [riêng phái]
#         texture: Textures\star6.blp
#         texture: Textures\firering4.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Clouds8x8Black.blp
#         texture: Textures\Ghost1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb9.blp
#         texture: VLTK_data\KVCT3_Data\AZ_ICEWOLF-Fire1.blp
#         texture: Textures\LavaLump2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_AuraRune5.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Crack10.blp
#    trên địch bị trúng: TND_nhiephontarget.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp
#         texture: Textures\GenericGlowFaded.blp
#
# 6. Xí Không Ma Diệm [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_madao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Mr.War3_Mingjiaowq.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Mr.War3_Mingjiaowq2.BLP
#         texture: Textures\LavaLump2.blp
#
# 7. Thiên Ngoại Lưu Tinh [W]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_thienngoaistone.mdx   [riêng phái]
#         texture: units\Demon\Infernal\Infernal.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\star32.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\grad2b.blp
#    lúc tung (trên tướng): TND_thienngoailuutinhcaster.mdx   [riêng phái]
#         texture: Textures\star4_32.blp
#         texture: Textures\Flare.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Star3.blp
#         texture: Textures\RibbonNE1_blue.blp
#    lớp thêm tại điểm 1: TND_thienngoaifire.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Crack12.blp
#         texture: VLTK_data\KVCT3_Data\Xin_T2_O.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Crack11.blp
#
# 8. Thúc Phọc Chú [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_thucphocchubuff.mdx   [riêng phái]
#         texture: Textures\GenericGlowX.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: VLTK_data\KVCT3_Data\GenericGlow33b_A.blp
#         texture: Textures\LavaLump2.blp
#
# 9. Nghịch Chuyển Tâm Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_nghichchuyenbuff.mdx   [riêng phái]
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\clouds_anim1.blp
#
# 10. Ma Đao Thôn Thần [T]   (kind 21, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_madao.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Mr.War3_Mingjiaowq.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\Mr.War3_Mingjiaowq2.BLP
#         texture: Textures\LavaLump2.blp
#
# 11. Tật Hỏa Liêu Nguyên [E]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_tathoafire.mdx   [riêng phái, phái khác cũng dùng: NMK]
#         texture: Textures\Clouds8x8Fade.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_01.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_1X6.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_02.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_03.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_04.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\KVCT3_Data\MirrorZI_effect_baxianjian01_00.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8.blp
#    lúc tung (trên tướng): TND_tathoacast.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_GlowYellow.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave30.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon441.blp
#    trên địch bị trúng: TND_tathoatarget.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Flame8x8.blp
#    lớp thêm tại điểm 1: TND_bladerain.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\BF_FlameFx_black_8x8.blp
#         texture: VLTK_data\KVCT3_Data\FlareLine1b_Fx.blp
#         texture: Textures\snowflake2.blp
#         texture: VLTK_data\KVCT3_Data\BF_lineFx_white.blp
#         texture: VLTK_data\KVCT3_Data\PikeMagnaBlue.blp
#         texture: VLTK_data\KVCT3_Data\BF_FlareamberFx_4x2.blp
#         texture: VLTK_data\KVCT3_Data\smoke8x8.blp
#         texture: Textures\LavaLump2.blp
#    lớp thêm tại điểm 2: TND_tathoafire2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_RibbonFire.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke3_2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smokewhite2x2.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave2B.blp
#         texture: VLTK_data\KVCT3_Data\AZ_smoke4x4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\LavaLump.blp
#         texture: VLTK_data\KVCT3_Data\Fire2x2.BLP
#         texture: VLTK_data\KVCT3_Data\AZ_Crack4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Splast1x.blp
#
# 12. Ma Diệm Thất Sát [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_thienngoaifire.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Crack12.blp
#         texture: VLTK_data\KVCT3_Data\Xin_T2_O.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Crack11.blp
#
# 13. Huyền Minh Hấp Tinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TND_nghichchuyenbuff.mdx   [riêng phái]
#         texture: Textures\Red_Glow2.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow2_64.blp
#         texture: Textures\clouds_anim1.blp
# ===== HẾT DANH MỤC =====
