# TLD: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TLD.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Phục Ma Đao Pháp [Q]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLD_phucmadp.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\star2_32.blp
#
# 2. Thiếu Lâm Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: KVCT3_Data\tx208-1.blp
#         texture: KVCT3_Data\tx208-2.blp
#
# 3. Dịch Cân Kinh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_phucmadp.mdx   [riêng phái]
#         texture: Textures\firering1A.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Clouds8x8Grey.blp
#         texture: Textures\star2_32.blp
#
# 4. A La Hán Thần Công [bị động]   (kind 0, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: KVCT3_Data\tx208-1.blp
#         texture: KVCT3_Data\tx208-2.blp
#    aura bị động (gắn tướng suốt): TLD_lahantran.mdx   [riêng phái, phái khác cũng dùng: TLB]
#         texture: Textures\LavaLump.blp
#         texture: KVCT3_Data\tx208-1.blp
#         texture: KVCT3_Data\tx208-2.blp
#
# 5. Bồ Đề Tâm Pháp [D]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_bodetamphapcast.mdx   [riêng phái]
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
#         texture: KVCT3_Data\GodCorss.blp
#
# 6. Như Lai Thiên Diệp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_thientrucdao.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star2.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 7. Thiên Trúc Tuyệt Đao [W]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\BuddhistRoar.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#    lớp thêm tại điểm 1: TLD_thientrucdao.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star2.blp
#
# 8. Hàng Long Bất Vũ [F]   (kind 8, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_hanglongbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\BOSS_Heilong02.blp
#         texture: KVCT3_Data\Seal81.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TLD_hanglongcast.mdx   [riêng phái]
#         texture: Textures\star3.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\star4.blp
#         texture: Textures\Green_firering2b.blp
#         texture: Textures\Rune1d.blp
#         texture: Textures\Red_Glow3.blp
#
# 9. Đạt Ma Bế Tức [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_datmabetucbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\Buddha.BLP
#
# 10. Đại Thừa Như Lai Chú [R]   (kind 13, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLD_daithua.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: UI\Widgets\Glues\GlueScreen-RadioButton-ButtonDisabled.blp
#         texture: Textures\star6.blp
#         texture: ReplaceableTextures\Selection\SpellAreaOfEffect_basic.blp
#         texture: Textures\GenericGlow2_64.blp
#    buff (trên tướng): TLD_daithuabuff.mdx   [riêng phái]
#         texture: UI\MiniMap\ping4.blp
#         texture: KVCT3_Data\BuddhistRoar.blp
#    lớp thêm tại điểm 1: TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\BuddhistRoar.blp
#
# 11. Quy Thiền Đao Pháp [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLD_tamgioihoasen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\AZ_texturesPetal2.blp
#         texture: KVCT3_Data\AZ_Petal1.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#    lớp thêm tại điểm 1: TLD_votuongtram.mdx   [riêng phái]
#         texture: Textures\HeroGoblinAlchemistBLUE.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\BloodWhiteSmall.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\snowflake.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\BuddhistRoar.blp
#    lớp thêm tại điểm 2: TLD_tamgioidao.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_N2s_light2.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_light3.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star.blp
#         texture: KVCT3_Data\Hero_EncHantress_N2S_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#
# 12. Thiền Nguyên Công [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_thientrucdao.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Slayer_N5_Flare.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow6.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_light.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow4.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_glow.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star1.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_smoke.blp
#         texture: KVCT3_Data\Hero_Slayer_N10S_star2.blp
#    trên địch bị trúng: TLD_thientructarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 13. Trảm Ma Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLD_tamgioihoasen.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\AZ_texturesPetal2.blp
#         texture: KVCT3_Data\AZ_Petal1.blp
# ===== HẾT DANH MỤC =====
