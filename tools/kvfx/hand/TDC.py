# TDC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Dương Ca Thiên Quân": {   # [Q]
        "main": "TDC_duongca.mdx",
        "cast": "TDC_caster.mdx",
        "buff": "TDC_target.mdx",
        "target": "TDC_wave1.mdx",
        "area": ["TDC_duongca.mdx"],
    },
    "Tiêu Dao Chưởng Pháp": {   # [bị động]
        "main": "TDC_baivanchuong.mdx",
    },
    "Hàn Tụ Huyệt": {   # [R]
        "main": "TDC_tuhuyet.mdx",
        "cast": "TDC_caster2.mdx",
        "target": "TDC_target.mdx",
        "area": ["TDC_stphucast.mdx"],
    },
    "Sưu Hồn Đại Pháp": {   # [bị động]
        "main": "TDC_baivanchuong.mdx",
    },
    "Diệm Nguyên Luân Hồi": {   # [bị động]
        "main": "TDC_diemnguyenbuff.mdx",
    },
    "Phục Nhật Xuất Vân": {   # [bị động]
        "main": "TDC_sinhtuphu11.mdx",
    },
    "Bạch Nhật Sâm Thần": {   # [W]
        "main": "TDC_bachnhat1.mdx",
        "cast": {"file": "TDC_caster.mdx", "ground": True},
        "target": "TDC_wave1.mdx",
        "area": ["TDC_bachnhat2.mdx"],
    },
    "Sinh Tử Phù": {   # [D]
        "main": "TDC_sinhtuphueffect.mdx",
        "cast": "TDC_sinhtuphucaster.MDX",
        "target": "TDC_target.mdx",
        "buff": "TDC_sinhtubuff.mdx",
    },
    "Hỗn Nhật Khí Quyết": {   # [bị động]
        "main": "TDC_honnhatbuff.mdx",
    },
    "Thiên Tàm Cửu Biến": {   # [F]
        "main": "TDC_thientamcb.mdx",
        "target": "TDC_wave1.mdx",
    },
    "Bài Sơn Đảo Hải": {   # [E]
        "main": "TDC_baisondh.mdx",
        "cast": "TDC_caster2.mdx",
        "target": "TDC_wave1.mdx",
        "area": ["TDC_baivanchuong.mdx"],
    },
    "Thái Hư Thần Công": {   # [bị động]
        "main": "TDC_thientamcb.mdx",
    },
    "Tung Bộ Quan Hỏa": {   # [T]
        "main": "TDC_tuhuyet.mdx",
        "cast": "TDC_caster.mdx",
        "target": "TDC_target.mdx",
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
# 1. Dương Ca Thiên Quân [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_duongca.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\White_64_Foam1.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#    buff (trên tướng): TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    lớp thêm tại điểm 1: TDC_duongca.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\White_64_Foam1.blp
#
# 2. Tiêu Dao Chưởng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_baivanchuong.mdx   [riêng phái]
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
#
# 3. Hàn Tụ Huyệt [R]   (kind 17, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_tuhuyet.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: VLTK_data\KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb17.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon42.blp
#    lúc tung (trên tướng): TDC_caster2.mdx   [riêng phái]
#         texture: Textures\Ghost1.blp
#         texture: VLTK_data\KVCT3_Data\BattlecastGlow.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    lớp thêm tại điểm 1: TDC_stphucast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Auroth_T.blp
#         texture: VLTK_data\KVCT3_Data\Tornado1.blp
#         texture: VLTK_data\KVCT3_Data\Shockwave_A1.blp
#         texture: Textures\star6.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#
# 4. Sưu Hồn Đại Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_baivanchuong.mdx   [riêng phái]
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
#
# 5. Diệm Nguyên Luân Hồi [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_diemnguyenbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1J.blp
#         texture: VLTK_data\KVCT3_Data\AZ_glow4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Smoke2x2A2_ice.blp
#
# 6. Phục Nhật Xuất Vân [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_sinhtuphu11.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: VLTK_data\KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb17.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon42.blp
#
# 7. Bạch Nhật Sâm Thần [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_bachnhat1.mdx   [riêng phái]
#         texture: Textures\Dust3x.blp
#         texture: Textures\LightningBall.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star8.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\Flare.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave1White4.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\star4.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#    lớp thêm tại điểm 1: TDC_bachnhat2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\TX_Star19.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Sven_N4_EF_07.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Sven_N3S_W_Target2_10.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Sven_N4_EF_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Sven_N4_EF_06.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star1.blp
#
# 8. Sinh Tử Phù [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_sinhtuphueffect.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\AZ_Flare6.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Tornado2b.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Shockwave12.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: VLTK_data\KVCT3_Data\Disruptor_Aghanim1_purple.blp
#    lúc tung (trên tướng): TDC_sinhtuphucaster.MDX   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\SetItems_N4S_Red_FlareLightning.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N4S_Red_lightning4.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N4S_Red_Flare2.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N4S_Red_Flare.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N5_TP_ef_16.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star1.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2004.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N5_TP_ef_05.blp
#         texture: VLTK_data\KVCT3_Data\SetItems_N5_TP_ef_06.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    buff (trên tướng): TDC_sinhtubuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a01.blp
#         texture: VLTK_data\KVCT3_Data\GameBABY_ss422a02.blp
#
# 9. Hỗn Nhật Khí Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_honnhatbuff.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\star4_32.blp
#
# 10. Thiên Tàm Cửu Biến [F]   (kind 18, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_thientamcb.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\Energy1.blp
#    trên địch bị trúng: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#
# 11. Bài Sơn Đảo Hải [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_baisondh.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Purple_Glow_Dim.blp
#         texture: Textures\Purple_Star.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01_yellow.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang02_yellow.blp
#         texture: VLTK_data\KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang03.blp
#    lúc tung (trên tướng): TDC_caster2.mdx   [riêng phái]
#         texture: Textures\Ghost1.blp
#         texture: VLTK_data\KVCT3_Data\BattlecastGlow.blp
#    trên địch bị trúng: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#    lớp thêm tại điểm 1: TDC_baivanchuong.mdx   [riêng phái]
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
#
# 12. Thái Hư Thần Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_thientamcb.mdx   [riêng phái]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\Energy1.blp
#
# 13. Tung Bộ Quan Hỏa [T]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_tuhuyet.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: VLTK_data\KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Flashb17.blp
#         texture: VLTK_data\KVCT3_Data\AZ_Ribbon42.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: VLTK_data\KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
# ===== HẾT DANH MỤC =====
