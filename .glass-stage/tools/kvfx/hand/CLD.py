# CLD: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/CLD.py). Sửa file này rồi chạy lại pipeline.
VFX = {
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
# 1. Cuồng Phong Sậu Điện [Q]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): CLD_cuongphong.mdx   [riêng phái]
#         texture: abilities\Spells\Other\Tornado\ShadowWalk1.blp
#         texture: abilities\Spells\Other\Tornado\wind.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\GenericGlow2c.blp
#    lúc tung (trên tướng): CLD_buffcast.MDX   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\AuraRune8.blp
#         texture: Textures\DemonRune4.blp
#         texture: Textures\star2.blp
#    trên địch bị trúng: CLD_effecttarget.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\Flare.blp
#         texture: KVCT3_Data\Bakua_b.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\lensflare1Ax.blp
#         texture: Textures\lensflare1A.blp
#
# 2. Côn Lôn Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_canhphong2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_leaf_2x2.blp
#         texture: KVCT3_Data\SmokeA2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: Textures\rock64.blp
#
# 3. Thanh Phong Phù [F]   (kind 7, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_tamthanhbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_LeafGreen.blp
#    trên địch bị trúng: CLD_hoiphongtarget2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light1o.blp
#         texture: KVCT3_Data\AZ_GlowBlue2.blp
#         texture: Textures\Smoke.blp
#         texture: KVCT3_Data\AZ_Knife_light2j.blp
#    lớp thêm tại điểm 1: CLD_canhphong.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\Tornado\ShadowWalk1.blp
#         texture: KVCT3_Data\Knife_light1M.blp
#         texture: Textures\Dust3x.blp
#         texture: KVCT3_Data\lightning1.blp
#         texture: KVCT3_Data\ShadowWalk3p.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\CloudSingle.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\rock64.blp
#    lớp thêm tại điểm 2: CLD_canhphong2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_leaf_2x2.blp
#         texture: KVCT3_Data\SmokeA2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: Textures\rock64.blp
#
# 4. Tụ Nguyên Thuật [R]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_tunguyenthuatbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\Blind.blp
#
# 5. Nhất Khí Tam Thanh [D]   (kind 6, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): NMC_phongsuongtoaianh.mdx   [dùng chung (cùng dùng: HSK, NMC)]
#         texture: Textures\lensflare1A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow2_64_blue.blp
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Clouds8x8FadeWhite.blp
#         texture: Textures\RibbonBlur1.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Abilities\Spells\Undead\VampiricAura\AuraRune6.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\GenericGlow5.blp
#         texture: Textures\GenericGlowX_Mod2.blp
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\clouds_anim1.blp
#         texture: Textures\CloudSingle.blp
#
# 6. Thiên Thanh Địa Trọc [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_tamthanhbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\star2.blp
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\Leaf4x4.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_LeafGreen.blp
#
# 7. Ngạo Tuyết Tiếu Phong [W]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): CLD_ngaotuyet.mdx   [riêng phái]
#         texture: KVCT3_Data\tx926_1.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\tx926_2.blp
#         texture: KVCT3_Data\tx926_3.blp
#         texture: KVCT3_Data\tx926_4.blp
#         texture: KVCT3_Data\tx926_5.blp
#         texture: KVCT3_Data\tx926_6.blp
#         texture: KVCT3_Data\tx926_7.blp
#    lúc tung (trên tướng): CLD_ngaotuyetcast.mdx   [riêng phái]
#         texture: KVCT3_Data\z-DaoG jhxcom_2001.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2021.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2000.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2010.blp
#    trên địch bị trúng: CLD_ngaotuyettarget.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Ghost1.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\star6.blp
#         texture: KVCT3_Data\AZ_Star3.blp
#         texture: KVCT3_Data\AZ_Flare1Q.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: KVCT3_Data\AZ_Smoke8x8a.blp
#    lớp thêm tại điểm 1: CLD_hoiphongphatlieu.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light3.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light4.blp
#         texture: KVCT3_Data\AZ_Smoke1ED.blp
#
# 8. Hồi Phong Phất Liễu [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_hoiphongphatlieu.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light3.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light4.blp
#         texture: KVCT3_Data\AZ_Smoke1ED.blp
#    trên địch bị trúng: CLD_hoiphongtarget2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light1o.blp
#         texture: KVCT3_Data\AZ_GlowBlue2.blp
#         texture: Textures\Smoke.blp
#         texture: KVCT3_Data\AZ_Knife_light2j.blp
#    lớp thêm tại điểm 1: CLD_canhphong.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\Tornado\ShadowWalk1.blp
#         texture: KVCT3_Data\Knife_light1M.blp
#         texture: Textures\Dust3x.blp
#         texture: KVCT3_Data\lightning1.blp
#         texture: KVCT3_Data\ShadowWalk3p.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\CloudSingle.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\rock64.blp
#    lớp thêm tại điểm 2: CLD_canhphong2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_leaf_2x2.blp
#         texture: KVCT3_Data\SmokeA2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: Textures\rock64.blp
#
# 9. Lưỡng Nghi Chân Khí [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_buffphanluongnghi.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Star2012.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_13.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_14.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow3.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow5.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_star1.blp
#    buff (trên tướng): CLD_luongnghibuff.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Sputtering.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\star4_32.blp
#         texture: KVCT3_Data\AZ_Fire2_4x8.blp
#
# 10. Phản Lưỡng Nghi Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_buffphanluongnghi.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Star2012.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_13.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_14.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow3.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow5.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_star1.blp
#    buff (trên tướng): CLD_luongnghibuff.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Sputtering.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\star4_32.blp
#         texture: KVCT3_Data\AZ_Fire2_4x8.blp
#
# 11. Cửu Thiên Canh Phong [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): CLD_canhphong2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: Textures\Dust3.blp
#         texture: KVCT3_Data\AZ_leaf_2x2.blp
#         texture: KVCT3_Data\SmokeA2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: Textures\rock64.blp
#    lúc tung (trên tướng): CLD_ngaotuyetcast.mdx   [riêng phái]
#         texture: KVCT3_Data\z-DaoG jhxcom_2001.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2021.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2000.blp
#         texture: KVCT3_Data\z-DaoG jhxcom_2010.blp
#    trên địch bị trúng: CLD_hoiphongtarget2.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light1o.blp
#         texture: KVCT3_Data\AZ_GlowBlue2.blp
#         texture: Textures\Smoke.blp
#         texture: KVCT3_Data\AZ_Knife_light2j.blp
#    lớp thêm tại điểm 1: CLD_canhphong.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\Tornado\ShadowWalk1.blp
#         texture: KVCT3_Data\Knife_light1M.blp
#         texture: Textures\Dust3x.blp
#         texture: KVCT3_Data\lightning1.blp
#         texture: KVCT3_Data\ShadowWalk3p.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Dust6.blp
#         texture: Textures\CloudSingle.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\rock64.blp
#    lớp thêm tại điểm 2: CLD_hoiphongphatlieu.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Knife_light3.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Knife_light4.blp
#         texture: KVCT3_Data\AZ_Smoke1ED.blp
#
# 12. Vô Nhân Vô Ngã [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): MDX\VoNhanVoNga.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\GenericGlow64.blp
#         texture: Bakua_b.blp
#
# 13. Sương Ngạo Côn Lôn [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): CLD_buffphanluongnghi.mdx   [riêng phái]
#         texture: KVCT3_Data\TX_Star2012.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_13.blp
#         texture: KVCT3_Data\Hero_FarSeer_N1_ef_14.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow3.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_glow5.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_light2x2_1.blp
#         texture: KVCT3_Data\Hero_FarSeer_N2S_star1.blp
#    buff (trên tướng): CLD_luongnghibuff.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Sputtering.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Dust3.blp
#         texture: Textures\star4_32.blp
#         texture: KVCT3_Data\AZ_Fire2_4x8.blp
# ===== HẾT DANH MỤC =====
