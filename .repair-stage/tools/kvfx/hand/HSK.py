# HSK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/HSK.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Bạch Hồng Quán Nhật [Q]   (kind 16, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_bachhong.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_b.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_b.blp
#         texture: KVCT3_Data\txx110_4_b.blp
#         texture: KVCT3_Data\txx110_2_b.blp
#         texture: KVCT3_Data\txx110_3_b.blp
#
# 2. Kiếm Tông Tổng Quyết [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_phakiemthuc.mdx   [riêng phái]
#         texture: KVCT3_Data\BF_DaoGuang_1.blp
#         texture: KVCT3_Data\BF_Lizi.blp
#
# 3. Long Nhiễu Thân [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_kiemvu.mdx   [riêng phái]
#         texture: ReplaceableTextures\TeamColor\TeamColor09.blp
#         texture: KVCT3_Data\qingtongjian.blp
#         texture: KVCT3_Data\qingtongjianGH.blp
#         texture: Textures\GenericGlow2c.blp
#
# 4. Thiên Thân Đảo Huyền [E]   (kind 13, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSK_thienthandaohuyen.mdx   [riêng phái]
#         texture: ReplaceableTextures\TeamColor\TeamColor09.blp
#         texture: KVCT3_Data\qingtongjianGH.blp
#         texture: Textures\Clouds8x8Fire.blp
#    trên địch bị trúng: HSK_thienthantarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_N2s_light6.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star2.blp
#    buff (trên tướng): HSK_thienthanaura.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_03.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_05.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_11.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_02.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_01.blp
#         texture: KVCT3_Data\TX_Star2020.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_04.blp
#    lớp thêm tại điểm 1: HSK_thienthanaura2.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_03.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_05.blp
#         texture: KVCT3_Data\Hero_Butcher_N5_ef_11.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_02.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_01.blp
#         texture: KVCT3_Data\TX_Star2020.blp
#         texture: KVCT3_Data\Hero_Butcher_N6_VFX_04.blp
#
# 5. Kim Nhạn Hoành Không [R]   (kind 6, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): NMC_phongsuongtoaianh.mdx   [dùng chung (cùng dùng: CLD, NMC)]
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
#    lúc tung (trên tướng): HSK_kimnhancast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#
# 6. Hi Di Kiếm Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_thienthantarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_N2s_light6.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star2.blp
#
# 7. Thương Tùng Nghênh Khách [W]   (kind 5, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_thuongtungkiem.mdx   [riêng phái]
#         texture: KVCT3_Data\jxqy3M_B_07.blp
#         texture: Textures\Flare.blp
#    trên địch bị trúng: HSK_thuongtungtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_N2s_light6.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star2.blp
#
# 8. Thái Nhạc Tam Thanh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_thuongtungtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_N2s_light6.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N2s_star2.blp
#
# 9. Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm [D]   (kind 6, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): HSK_doatmenhbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\ArcaneRune.blp
#    lúc tung (trên tướng): HSK_doatmenhcast.mdx   [riêng phái]
#         texture: Textures\grad2b.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\GenericGlowFaded.blp
#         texture: KVCT3_Data\Hero_ShadowFiend_N4_ef_11.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_12.blp
#         texture: KVCT3_Data\TX_Star2004.blp
#
# 10. Phá Kiếm Thức [bị động]   (kind 4, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_phakiemthuc.mdx   [riêng phái]
#         texture: KVCT3_Data\BF_DaoGuang_1.blp
#         texture: KVCT3_Data\BF_Lizi.blp
#
# 11. Cửu Kiếm Hợp Nhất [bị động]   (kind 5, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_cuukiem.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_TemplarAssassin_N1_star4.blp
#         texture: KVCT3_Data\TX_Star2004.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp
#         texture: KVCT3_Data\TX_Star5.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_15.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_02.blp
#
# 12. Nhất Kiếm Phá Vạn Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_phakiemthuc.mdx   [riêng phái]
#         texture: KVCT3_Data\BF_DaoGuang_1.blp
#         texture: KVCT3_Data\BF_Lizi.blp
#
# 13. Độc Cô Cửu Kiếm [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): HSK_cuukiem.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_TemplarAssassin_N1_star4.blp
#         texture: KVCT3_Data\TX_Star2004.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_01.blp
#         texture: KVCT3_Data\TX_Star5.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_15.blp
#         texture: KVCT3_Data\Hero_TemplarAssassin_N3S_ef_02.blp
# ===== HẾT DANH MỤC =====
