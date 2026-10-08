# TDC: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Dương Ca Thiên Quân': {'main': 'TDC_duongca.mdx', 'cast': 'TDC_caster.mdx', 'target': 'TDC_target.mdx', 'area': ['TDC_wave1.mdx']},   # [Q]
    'Tiêu Dao Chưởng Pháp': {'main': 'TDC_baivanchuong.mdx'},   # [bị động]
    'Hàn Tụ Huyệt': {'main': 'TDC_tuhuyet.mdx', 'cast': 'TDC_caster2.mdx', 'target': 'TDC_target.mdx'},   # [R]
    'Sưu Hồn Đại Pháp': {'main': 'TDC_baivanchuong.mdx'},   # [bị động]
    'Diệm Nguyên Luân Hồi': {'main': 'TDC_diemnguyenbuff.mdx'},   # [bị động]
    'Phục Nhật Xuất Vân': {'main': 'TDC_sinhtuphu11.mdx'},   # [bị động]
    'Bạch Nhật Sâm Thần': {'main': 'TDC_bachnhat1.mdx', 'cast': 'TDC_caster.mdx', 'target': 'TDC_target.mdx', 'area': ['TDC_bachnhat2.mdx', 'TDC_wave1.mdx'], 'cast_ground': True},   # [W]
    'Sinh Tử Phù': {'main': 'TDC_sinhtuphueffect.mdx', 'cast': 'TDC_sinhtuphucaster.MDX', 'target': 'TDC_target.mdx', 'buff': 'TDC_sinhtubuff.mdx'},   # [D]
    'Hỗn Nhật Khí Quyết': {'main': 'TDC_honnhatbuff.mdx'},   # [bị động]
    'Thiên Tàm Cửu Biến': {'main': 'TDC_thientamcb.mdx'},   # [F]
    'Bài Sơn Đảo Hải': {'main': 'TDC_wave1.mdx', 'cast': 'TDC_caster2.mdx', 'target': 'TDC_target.mdx', 'area': ['TDC_baisondh.mdx']},   # [E]
    'Thái Hư Thần Công': {'main': 'TDC_thientamcb.mdx'},   # [bị động]
    'Tung Bộ Quan Hỏa': {'main': 'TDC_tuhuyet.mdx', 'cast': 'TDC_caster.mdx', 'target': 'TDC_target.mdx'},   # [T]
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
# 1. Dương Ca Thiên Quân [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_duongca.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\White_64_Foam1.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    lớp thêm tại điểm 1: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#
# 2. Tiêu Dao Chưởng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_baivanchuong.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP
#
# 3. Hàn Tụ Huyệt [R]   (kind 17, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_tuhuyet.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_Flashb17.blp
#         texture: KVCT3_Data\AZ_Ribbon42.blp
#    lúc tung (trên tướng): TDC_caster2.mdx   [riêng phái]
#         texture: Textures\Ghost1.blp
#         texture: KVCT3_Data\BattlecastGlow.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#
# 4. Sưu Hồn Đại Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_baivanchuong.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP
#
# 5. Diệm Nguyên Luân Hồi [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_diemnguyenbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave1J.blp
#         texture: KVCT3_Data\AZ_glow4.blp
#         texture: KVCT3_Data\AZ_Smoke2x2A2_ice.blp
#
# 6. Phục Nhật Xuất Vân [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_sinhtuphu11.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_Flashb17.blp
#         texture: KVCT3_Data\AZ_Ribbon42.blp
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
#         texture: KVCT3_Data\AZ_Shockwave1White4.blp
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\star4.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    lớp thêm tại điểm 1: TDC_bachnhat2.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Star19.blp
#         texture: KVCT3_Data\Hero_Sven_N4_EF_07.blp
#         texture: KVCT3_Data\Hero_Sven_N3S_W_Target2_10.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Sven_N4_EF_05.blp
#         texture: KVCT3_Data\Hero_Sven_N4_EF_06.blp
#         texture: KVCT3_Data\TX_Star1.blp
#    lớp thêm tại điểm 2: TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#
# 8. Sinh Tử Phù [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_sinhtuphueffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Flare6.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Tornado2b.blp
#         texture: KVCT3_Data\AZ_Shockwave12.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: KVCT3_Data\Disruptor_Aghanim1_purple.blp
#    lúc tung (trên tướng): TDC_sinhtuphucaster.MDX   [riêng phái]
#         texture: KVCT3_Data\SetItems_N4S_Red_FlareLightning.blp
#         texture: KVCT3_Data\SetItems_N4S_Red_lightning4.blp
#         texture: KVCT3_Data\SetItems_N4S_Red_Flare2.blp
#         texture: KVCT3_Data\SetItems_N4S_Red_Flare.blp
#         texture: KVCT3_Data\SetItems_N5_TP_ef_16.blp
#         texture: KVCT3_Data\TX_Star1.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\TX_Star2004.blp
#         texture: KVCT3_Data\SetItems_N5_TP_ef_05.blp
#         texture: KVCT3_Data\SetItems_N5_TP_ef_06.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    buff (trên tướng): TDC_sinhtubuff.mdx   [riêng phái]
#         texture: KVCT3_Data\GameBABY_ss422a01.blp
#         texture: KVCT3_Data\GameBABY_ss422a02.blp
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
#
# 11. Bài Sơn Đảo Hải [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDC_wave1.mdx   [riêng phái]
#         texture: Textures\Blue_Star2.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TDC_caster2.mdx   [riêng phái]
#         texture: Textures\Ghost1.blp
#         texture: KVCT3_Data\BattlecastGlow.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
#    lớp thêm tại điểm 1: TDC_baisondh.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Purple_Glow_Dim.blp
#         texture: Textures\Purple_Star.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01_yellow.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang02_yellow.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang03.blp
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
#         texture: KVCT3_Data\RibbonNE2.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_Flashb17.blp
#         texture: KVCT3_Data\AZ_Ribbon42.blp
#    lúc tung (trên tướng): TDC_caster.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_06.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_04.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_05.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_01.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_02.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_12.blp
#         texture: KVCT3_Data\Hero_PhantomAssassin_N6_ef_10.blp
#    trên địch bị trúng: TDC_target.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Shockwave9.blp
# ===== HẾT DANH MỤC =====
