# TVD: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TVD.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Kinh Lôi Trảm [Q]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TVD_targeteffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: KVCT3_Data\TX_Star4.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: KVCT3_Data\TX_Star4.blp
#
# 2. Thiên Vương Đao Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#
# 3. Đoạn Hồn Thích [R]   (kind 3, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TVT_doanhonthich.mdx   [dùng chung (cùng dùng: TVC, TVT)]
#         texture: KVCT3_Data\HB02_weapon02.blp
#         texture: KVCT3_Data\HB02_ATTACK.blp
#         texture: Textures\RibbonNE1_White.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: KVCT3_Data\TX_Star4.blp
#
# 4. Kinh Lôi Phá Thiên [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#
# 5. Thiên Vương Chiến Ý [D]   (kind 7, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#
# 6. Thiên Canh Chiến Khí [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#
# 7. Phá Thiên Trảm [W]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#    trên địch bị trúng: TVD_targeteffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\[NFTS]2019826103036_0060[1].blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\[NFTS]2019826103036_0060[2].blp
#         texture: KVCT3_Data\[NFTS]2019826103036_0060[3].blp
#
# 8. Tĩnh Tâm Quyết [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phitinhtramthichbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\[AKE]000011.blp
#
# 9. Phi Tinh Trảm Thích [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phitinhtramthichbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\[AKE]000011.blp
#
# 10. Tung Hoành Bát Hoang [F]   (kind 8, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TVD_tunghoanhbathoangbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_SkeletonKing_N6S_light.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N6S_light3.blp
#         texture: KVCT3_Data\Hero_SkeletonKing_N6S_glow1.blp
#
# 11. Hào Hùng Trảm [E]   (kind 5, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TVD_tranphainewz2.mdx   [riêng phái]
#         texture: KVCT3_Data\ur05_0.blp
#         texture: KVCT3_Data\ur05_1.blp
#         texture: KVCT3_Data\ur05_2.blp
#         texture: KVCT3_Data\ur05_3.blp
#         texture: KVCT3_Data\ur05_4.blp
#         texture: KVCT3_Data\ur05_5.blp
#    lúc tung (trên tướng): TVD_tranphaicast.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-Knife light1.blp
#         texture: KVCT3_Data\ZK-Knife light2.BLP
#         texture: KVCT3_Data\ZK-Knife light5.blp
#         texture: KVCT3_Data\ZK-Knife light3.blp
#         texture: KVCT3_Data\ZK-Knife light6.blp
#         texture: KVCT3_Data\ZK-Knife light7.blp
#         texture: KVCT3_Data\ZK-Knife light4.blp
#         texture: KVCT3_Data\ZK-Knife light8.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: KVCT3_Data\TX_Star4.blp
#
# 12. Bát Phong Trảm [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TVD_targeteffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: KVCT3_Data\TX_Star2000.blp
#         texture: KVCT3_Data\TX_Star20.blp
#         texture: KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: KVCT3_Data\TX_Star4.blp
#
# 13. Thiên Mã Hành Không [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThienMaHanhKhong.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: TVC, TVT)]
#         texture: Textures\GenericGlow64.blp
#         texture: HoaHiemViDi.blp
# ===== HẾT DANH MỤC =====
