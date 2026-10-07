# TDK: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TDK.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Trảm Vân Kiếm': {'main': 'TDK_tramvankiem2.mdx', 'target': 'TDK_target.mdx'},   # [Q]
    'Tiêu Dao Kiếm Pháp': {'main': 'TDK_danphuongcd.mdx'},   # [bị động]
    'Đan Phượng Dẫn': {'main': 'TDK_danphuongdan5.mdx', 'target': 'TDK_targeteffect2.mdx', 'area': ['TDK_danphuongdan.mdx']},   # [R]
    'Chân Hỏa Hộ Thể': {'main': 'TDK_chanhoabuff.mdx', 'buff': 'TDK_chanhoabuff2.mdx'},   # [bị động]
    'Sơ Hoa Dẫn': {'main': 'TDK_buffsohoa.mdx'},   # [F]
    'Đoản Ca Hành': {'main': 'TDK_kiemchungdan4.mdx'},   # [bị động]
    'Tê Chiếu Phồn Thương': {'main': 'TDK_techieukiem.mdx', 'target': 'TDK_targeteffect2.mdx'},   # [W]
    'Kiếm Chủng Dẫn': {'main': 'TDK_kiemchungdan4.mdx', 'target': 'TDK_targeteffect2.mdx'},   # [D]
    'Bính Nhược Quan Hỏa': {'main': 'TDK_chanhoabuff.mdx', 'buff': 'TDK_chanhoabuff2.mdx'},   # [bị động]
    'Ngang Nhật Đồ': {'main': 'TDK_techieukiem.mdx'},   # [bị động]
    'Bách Điểu Triều Phượng': {'main': 'TDK_kiemchungdan4.mdx', 'target': 'TDK_targeteffect2.mdx', 'area': ['TDK_bachdieukiem.mdx']},   # [E]
    'Phần Phách Tru Tâm': {'main': 'TDK_tramvankiem2.mdx'},   # [bị động]
    'Hỏa Hải Vô Nhai': {'main': 'TDK_hoahai.mdx'},   # [bị động]
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
# 1. Trảm Vân Kiếm [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_tramvankiem2.mdx   [riêng phái]
#         texture: Textures\star32.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Dust5ABlack.blp
#    trên địch bị trúng: TDK_target.mdx   [riêng phái]
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star4.blp
#         texture: TerrainArt\Ashenvale\Ashen_DirtGrass.blp
#
# 2. Tiêu Dao Kiếm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_danphuongcd.mdx   [riêng phái]
#         texture: KVCT3_Data\JD-2021-GUANGHTX-b.blp
#         texture: KVCT3_Data\JD-2021-GUANGHTX-d.blp
#         texture: KVCT3_Data\JD-2021-GUANGHTX -1.blp
#
# 3. Đan Phượng Dẫn [R]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_danphuongdan5.mdx   [riêng phái]
#         texture: KVCT3_Data\fh1122.blp
#         texture: KVCT3_Data\fh3344.blp
#         texture: KVCT3_Data\JD2_02.blp
#    trên địch bị trúng: TDK_targeteffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_r.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_r.blp
#         texture: KVCT3_Data\txx110_4_r.blp
#         texture: KVCT3_Data\txx110_2_r.blp
#         texture: KVCT3_Data\txx110_3_r.blp
#    lớp thêm tại điểm 1: TDK_danphuongdan.mdx   [riêng phái]
#         texture: Textures\GenericGlowFaded.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Frost2.blp
#         texture: Textures\Frost3.blp
#         texture: Textures\Shockwave_Ice1.blp
#         texture: Textures\snowflake2.blp
#         texture: KVCT3_Data\AZ_Petal1.blp
#         texture: KVCT3_Data\effect_lingyuquan.blp
#
# 4. Chân Hỏa Hộ Thể [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_chanhoabuff.mdx   [riêng phái]
#         texture: KVCT3_Data\JN_tianmodun1.blp
#         texture: KVCT3_Data\JN_tianmodun2.blp
#    buff (trên tướng): TDK_chanhoabuff2.mdx   [riêng phái]
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\LavaLump2.blp
#         texture: units\Demon\Felgaurd\FelGuard.blp
#         texture: Textures\Knife_spinningBlade.blp
#         texture: UI\Glues\SinglePlayer\Orc_Exp\Stars3.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\GenericGlow2b.blp
#
# 5. Sơ Hoa Dẫn [F]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_buffsohoa.mdx   [riêng phái]
#         texture: KVCT3_Data\huaban_3.blp
#
# 6. Đoản Ca Hành [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_kiemchungdan4.mdx   [riêng phái]
#         texture: KVCT3_Data\JL2-1.blp
#         texture: KVCT3_Data\JL2-2.blp
#         texture: Textures\Smoke.blp
#
# 7. Tê Chiếu Phồn Thương [W]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_techieukiem.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\star2.blp
#         texture: KVCT3_Data\zhuxian.blp
#         texture: Textures\Flare.blp
#    trên địch bị trúng: TDK_targeteffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_r.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_r.blp
#         texture: KVCT3_Data\txx110_4_r.blp
#         texture: KVCT3_Data\txx110_2_r.blp
#         texture: KVCT3_Data\txx110_3_r.blp
#
# 8. Kiếm Chủng Dẫn [D]   (kind 13, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_kiemchungdan4.mdx   [riêng phái]
#         texture: KVCT3_Data\JL2-1.blp
#         texture: KVCT3_Data\JL2-2.blp
#         texture: Textures\Smoke.blp
#    trên địch bị trúng: TDK_targeteffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_r.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_r.blp
#         texture: KVCT3_Data\txx110_4_r.blp
#         texture: KVCT3_Data\txx110_2_r.blp
#         texture: KVCT3_Data\txx110_3_r.blp
#
# 9. Bính Nhược Quan Hỏa [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_chanhoabuff.mdx   [riêng phái]
#         texture: KVCT3_Data\JN_tianmodun1.blp
#         texture: KVCT3_Data\JN_tianmodun2.blp
#    buff (trên tướng): TDK_chanhoabuff2.mdx   [riêng phái]
#         texture: Textures\GenericGlow1.blp
#         texture: Textures\LavaLump2.blp
#         texture: units\Demon\Felgaurd\FelGuard.blp
#         texture: Textures\Knife_spinningBlade.blp
#         texture: UI\Glues\SinglePlayer\Orc_Exp\Stars3.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\Energy1.blp
#         texture: Textures\Flame4.blp
#         texture: Textures\GenericGlow2b.blp
#
# 10. Ngang Nhật Đồ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_techieukiem.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\star2.blp
#         texture: KVCT3_Data\zhuxian.blp
#         texture: Textures\Flare.blp
#
# 11. Bách Điểu Triều Phượng [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_kiemchungdan4.mdx   [riêng phái]
#         texture: KVCT3_Data\JL2-1.blp
#         texture: KVCT3_Data\JL2-2.blp
#         texture: Textures\Smoke.blp
#    trên địch bị trúng: TDK_targeteffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\txx110_5_r.blp
#         texture: KVCT3_Data\txx110_1.blp
#         texture: KVCT3_Data\txx110_r.blp
#         texture: KVCT3_Data\txx110_4_r.blp
#         texture: KVCT3_Data\txx110_2_r.blp
#         texture: KVCT3_Data\txx110_3_r.blp
#    lớp thêm tại điểm 1: TDK_bachdieukiem.mdx   [riêng phái]
#         texture: KVCT3_Data\WQ06.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\star32.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Shockwave_Ice1.blp
#
# 12. Phần Phách Tru Tâm [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_tramvankiem2.mdx   [riêng phái]
#         texture: Textures\star32.blp
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\RibbonNE1_White.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Blue_Glow2.blp
#         texture: Textures\Dust5ABlack.blp
#
# 13. Hỏa Hải Vô Nhai [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TDK_hoahai.mdx   [riêng phái]
#         texture: KVCT3_Data\GodBoy_saboguanghuan01.blp
#         texture: KVCT3_Data\Moon_texiao_fugaihongzha_01_xulie_baozhahuohua.blp
#         texture: KVCT3_Data\GodBoy_saboguanghuan02.blp
# ===== HẾT DANH MỤC =====
