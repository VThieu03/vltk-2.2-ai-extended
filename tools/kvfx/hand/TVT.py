# TVT: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TVT.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Hồi Phong Lạc Nhạn': {'main': 'TVT_hoiphonglacnhan.mdx', 'area': ['HydraliskImpact.mdx']},   # [Q]
    'Thiên Vương Thương Pháp': {'main': 'TVT_buffkinhloiphathien.mdx', 'target': 'TVT_bavuongtramkim_target.mdx', 'area': ['TVT_bonloithuong.mdx', 'TVT_bavuongeffect1.mdx']},   # [bị động]
    'Đoạn Hồn Thích': {'main': 'TVT_doanhonthich.mdx', 'buff': 'TVT_buffdoanhonthich.mdx'},   # [R]
    'Kinh Lôi Phá Thiên': {'main': 'TVT_buffkinhloiphathien.mdx'},   # [bị động]
    'Thiên Vương Chiến Ý': {'main': 'TVT_buffkinhloiphathien.mdx', 'cast': 'TVT_chienycast.mdx', 'target': 'TVT_bavuongtramkim_target.mdx', 'area': ['TVT_bavuongeffect1.mdx', 'TVT_bavuongeffect2.mdx']},   # [D]
    'Thiên Canh Chiến Khí': {'main': 'TVT_buffkinhloiphathien.mdx', 'cast': 'TVT_chienycast.mdx'},   # [bị động]
    'Truy Tinh Trục Nguyệt': {'main': 'TVT_truytinheffect.mdx', 'target': 'TVT_truytinhtarget.mdx', 'area': ['HydraliskImpact.mdx']},   # [W]
    'Bôn Lôi Toàn Long Thương': {'main': 'TVT_bonloithuong.mdx', 'target': 'TVT_bonloitarget.mdx'},   # [F]
    'Liên Hoàn Đoạt Mệnh Thương': {'main': 'TVT_doatmenhbuff.mdx', 'area': ['TVT_bonloithuong.mdx']},   # [bị động]
    'Hoành Hành Vô Kỵ': {'main': 'TVT_hoanhhanhbuff.mdx'},   # [T]
    'Bá Vương Trạm Kim': {'main': 'TVT_bavuongtramkim_target.mdx', 'target': 'TVT_bavuongtramkim_target.mdx'},   # [E]
    'Huyết Chiến Bát Phương': {'main': 'TVT_bonloithuong.mdx', 'cast': 'TVT_chienycast.mdx'},   # [bị động]
    'Thiên Mã Hành Không': {'main': 'MDX\\ThienMaHanhKhong.mdx'},   # [bị động]
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
# 1. Hồi Phong Lạc Nhạn [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_hoiphonglacnhan.mdx   [riêng phái]
#         texture: Textures\RibbonNE1_Red2.blp
#         texture: Textures\Shockwave_Ice1.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#    lớp thêm tại điểm 1: HydraliskImpact.mdx   [dùng chung (cùng dùng: DMTT, TLQ)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#
# 2. Thiên Vương Thương Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_buffkinhloiphathien.mdx   [riêng phái]
#         texture: Textures\Dust3x.blp
#         texture: Textures\CloudSingleBlend.blp
#         texture: KVCT3_Data\tx_zj_01.blp
#         texture: KVCT3_Data\tx_zj_02.blp
#         texture: KVCT3_Data\tx_zj_03.blp
#    trên địch bị trúng: TVT_bavuongtramkim_target.mdx   [riêng phái]
#         texture: KVCT3_Data\zd070.blp
#         texture: KVCT3_Data\zd071.blp
#         texture: KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\zd073.blp
#    lớp thêm tại điểm 1: TVT_bonloithuong.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\Wirlwinds.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterWake3.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Shockwave4white.blp
#    lớp thêm tại điểm 2: TVT_bavuongeffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#
# 3. Đoạn Hồn Thích [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_doanhonthich.mdx   [riêng phái, phái khác cũng dùng: TVC, TVD]
#         texture: KVCT3_Data\HB02_weapon02.blp
#         texture: KVCT3_Data\HB02_ATTACK.blp
#         texture: Textures\RibbonNE1_White.blp
#    buff (trên tướng): TVT_buffdoanhonthich.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_glow2.blp
#         texture: KVCT3_Data\AZ_Ribbon1X.blp
#         texture: KVCT3_Data\AZ_WhiteFire6x6.blp
#         texture: KVCT3_Data\AZ_Shockwave31.blp
#         texture: KVCT3_Data\AZ_Shockwave1t.blp
#         texture: Textures\Flare.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 4. Kinh Lôi Phá Thiên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_buffkinhloiphathien.mdx   [riêng phái]
#         texture: Textures\Dust3x.blp
#         texture: Textures\CloudSingleBlend.blp
#         texture: KVCT3_Data\tx_zj_01.blp
#         texture: KVCT3_Data\tx_zj_02.blp
#         texture: KVCT3_Data\tx_zj_03.blp
#
# 5. Thiên Vương Chiến Ý [D]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_buffkinhloiphathien.mdx   [riêng phái]
#         texture: Textures\Dust3x.blp
#         texture: Textures\CloudSingleBlend.blp
#         texture: KVCT3_Data\tx_zj_01.blp
#         texture: KVCT3_Data\tx_zj_02.blp
#         texture: KVCT3_Data\tx_zj_03.blp
#    lúc tung (trên tướng): TVT_chienycast.mdx   [riêng phái]
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
#         texture: war3mapImported\CrossSword.blp
#    trên địch bị trúng: TVT_bavuongtramkim_target.mdx   [riêng phái]
#         texture: KVCT3_Data\zd070.blp
#         texture: KVCT3_Data\zd071.blp
#         texture: KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\zd073.blp
#    lớp thêm tại điểm 1: TVT_bavuongeffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#    lớp thêm tại điểm 2: TVT_bavuongeffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#
# 6. Thiên Canh Chiến Khí [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_buffkinhloiphathien.mdx   [riêng phái]
#         texture: Textures\Dust3x.blp
#         texture: Textures\CloudSingleBlend.blp
#         texture: KVCT3_Data\tx_zj_01.blp
#         texture: KVCT3_Data\tx_zj_02.blp
#         texture: KVCT3_Data\tx_zj_03.blp
#    lúc tung (trên tướng): TVT_chienycast.mdx   [riêng phái]
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
#         texture: war3mapImported\CrossSword.blp
#
# 7. Truy Tinh Trục Nguyệt [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_truytinheffect.mdx   [riêng phái]
#         texture: KVCT3_Data\ZK-barb protrusion.blp
#         texture: KVCT3_Data\ZY-LZ3.BLP
#    trên địch bị trúng: TVT_truytinhtarget.mdx   [riêng phái]
#         texture: KVCT3_Data\Hero_Juggernaut_N7S_light6.blp
#         texture: KVCT3_Data\Hero_Juggernaut_N7S_star.blp
#         texture: KVCT3_Data\Hero_Juggernaut_N7S_star2.blp
#    lớp thêm tại điểm 1: HydraliskImpact.mdx   [dùng chung (cùng dùng: DMTT, TLQ)]
#         texture: Textures\Dust3.blp
#         texture: Textures\BloodSplutWhite.blp
#
# 8. Bôn Lôi Toàn Long Thương [F]   (kind 11, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_bonloithuong.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\Wirlwinds.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterWake3.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Shockwave4white.blp
#    trên địch bị trúng: TVT_bonloitarget.mdx   [riêng phái]
#         texture: KVCT3_Data\zd070.blp
#         texture: KVCT3_Data\zd071.blp
#         texture: KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\zd073.blp
#
# 9. Liên Hoàn Đoạt Mệnh Thương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_doatmenhbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\GlowYellow.blp
#         texture: KVCT3_Data\Circle.blp
#         texture: KVCT3_Data\flame2x2.blp
#         texture: KVCT3_Data\Spark.blp
#    lớp thêm tại điểm 1: TVT_bonloithuong.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\Wirlwinds.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterWake3.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Shockwave4white.blp
#
# 10. Hoành Hành Vô Kỵ [T]   (kind 8, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_hoanhhanhbuff.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\Effect_AZ_GenericGlow.blp
#         texture: KVCT3_Data\Effect_AZ_MagicMatrix7(1).blp
#         texture: KVCT3_Data\Effect_AZ_Shockwave2B.blp
#
# 11. Bá Vương Trạm Kim [E]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_bavuongtramkim_target.mdx   [riêng phái]
#         texture: KVCT3_Data\zd070.blp
#         texture: KVCT3_Data\zd071.blp
#         texture: KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\zd073.blp
#    trên địch bị trúng: TVT_bavuongtramkim_target.mdx   [riêng phái]
#         texture: KVCT3_Data\zd070.blp
#         texture: KVCT3_Data\zd071.blp
#         texture: KVCT3_Data\zd072.blp
#         texture: Textures\Shockwave1White.blp
#         texture: KVCT3_Data\zd073.blp
#
# 12. Huyết Chiến Bát Phương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_bonloithuong.mdx   [riêng phái]
#         texture: Textures\GenericGlow2b.blp
#         texture: Textures\Wirlwinds.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\WaterWake3.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: Textures\Shockwave4white.blp
#    lúc tung (trên tướng): TVT_chienycast.mdx   [riêng phái]
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
#         texture: war3mapImported\CrossSword.blp
#
# 13. Thiên Mã Hành Không [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThienMaHanhKhong.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: TVC, TVD)]
#         texture: Textures\GenericGlow64.blp
#         texture: HoaHiemViDi.blp
# ===== HẾT DANH MỤC =====
