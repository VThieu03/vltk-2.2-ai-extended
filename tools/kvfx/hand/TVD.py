# TVD: BẢNG SỬA TAY (lớp duy nhất, không còn bảng auto). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    "Kinh Lôi Trảm": {   # [Q]
        "main": "TVD_targeteffect1.mdx",
        "target": "TVD_targeteffect1.mdx",
    },
    "Thiên Vương Đao Pháp": {   # [bị động]
        "main": "TVD_phathientram.mdx",
    },
    "Đoạn Hồn Thích": {   # [R]
        "main": "TVT_doanhonthich.mdx",
        "target": "TVD_targeteffect1.mdx",
    },
    "Kinh Lôi Phá Thiên": {   # [bị động]
        "main": "TVD_phathientram.mdx",
    },
    "Thiên Vương Chiến Ý": {   # [D]
        "main": "TVD_phathientram.mdx",
        "cast": "TVT_chienycast.mdx",
    },
    "Thiên Canh Chiến Khí": {   # [bị động]
        "main": "TVD_phathientram.mdx",
    },
    "Phá Thiên Trảm": {   # [W]
        "main": "TVD_phathientram.mdx",
        "target": "TVD_targeteffect2.mdx",
    },
    "Tĩnh Tâm Quyết": {   # [bị động]
        "main": "TVD_phitinhtramthichbuff.mdx",
    },
    "Phi Tinh Trảm Thích": {   # [bị động]
        "main": "TVD_phitinhtramthichbuff.mdx",
    },
    "Tung Hoành Bát Hoang": {   # [F]
        "main": "TVD_tunghoanhbathoangbuff.mdx",
    },
    "Hào Hùng Trảm": {   # [E]
        "main": "TVD_tranphainewz2.mdx",
        "cast": "TVD_tranphaicast.mdx",
        "target": ["TVD_targeteffect1.mdx", "TVD_targeteffect2.mdx"],
    },
    "Bát Phong Trảm": {   # [bị động]
        "main": "TVD_targeteffect1.mdx",
    },
    "Thiên Mã Hành Không": {   # [bị động]
        "main": "MDX\\ThienMaHanhKhong.mdx",
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
# 1. Kinh Lôi Trảm [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_targeteffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star4.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star4.blp
#
# 2. Thiên Vương Đao Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#
# 3. Đoạn Hồn Thích [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_doanhonthich.mdx   [dùng chung (cùng dùng: TVC, TVT)]
#         texture: VLTK_data\KVCT3_Data\HB02_weapon02.blp
#         texture: VLTK_data\KVCT3_Data\HB02_ATTACK.blp
#         texture: Textures\RibbonNE1_White.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star4.blp
#
# 4. Kinh Lôi Phá Thiên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#
# 5. Thiên Vương Chiến Ý [D]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#    lúc tung (trên tướng): TVT_chienycast.mdx   [dùng chung (cùng dùng: TVT)]
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
#         texture: VLTK_data\war3mapImported\CrossSword.blp
#
# 6. Thiên Canh Chiến Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#
# 7. Phá Thiên Trảm [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phathientram.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#    trên địch bị trúng: TVD_targeteffect2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[1].blp
#         texture: Textures\Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[2].blp
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[3].blp
#
# 8. Tĩnh Tâm Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phitinhtramthichbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\[AKE]000011.blp
#
# 9. Phi Tinh Trảm Thích [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_phitinhtramthichbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\[AKE]000011.blp
#
# 10. Tung Hoành Bát Hoang [F]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_tunghoanhbathoangbuff.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_SkeletonKing_N6S_light.blp
#         texture: VLTK_data\KVCT3_Data\Hero_SkeletonKing_N6S_light3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_SkeletonKing_N6S_glow1.blp
#
# 11. Hào Hùng Trảm [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_tranphainewz2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ur05_0.blp
#         texture: VLTK_data\KVCT3_Data\ur05_1.blp
#         texture: VLTK_data\KVCT3_Data\ur05_2.blp
#         texture: VLTK_data\KVCT3_Data\ur05_3.blp
#         texture: VLTK_data\KVCT3_Data\ur05_4.blp
#         texture: VLTK_data\KVCT3_Data\ur05_5.blp
#    lúc tung (trên tướng): TVD_tranphaicast.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light1.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light2.BLP
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light5.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light3.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light6.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light7.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light4.blp
#         texture: VLTK_data\KVCT3_Data\ZK-Knife light8.blp
#    trên địch bị trúng: TVD_targeteffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star4.blp
#    trên địch bị trúng 2: TVD_targeteffect2.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[1].blp
#         texture: Textures\Shockwave1White.blp
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[2].blp
#         texture: VLTK_data\KVCT3_Data\[NFTS]2019826103036_0060[3].blp
#
# 12. Bát Phong Trảm [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVD_targeteffect1.mdx   [riêng phái]
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_Star7.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star2000.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star20.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_glow2.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star1.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star3.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_star4.blp
#         texture: VLTK_data\KVCT3_Data\Hero_Jingke_N1s_light.blp
#         texture: VLTK_data\KVCT3_Data\TX_Star4.blp
#
# 13. Thiên Mã Hành Không [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThienMaHanhKhong.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: TVC, TVT)]
#         texture: Textures\GenericGlow64.blp
#         texture: VLTK_data\Loose\HoaHiemViDi.blp
# ===== HẾT DANH MỤC =====
