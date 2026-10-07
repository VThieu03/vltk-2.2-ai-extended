# MGC: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/MGC.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Khai Thiên Thức': {'main': 'MGC_khaithienthuc.mdx', 'cast': 'MGC_buffcast.mdx'},   # [Q]
    'Minh Giáo Chùy Pháp': {'main': 'MGC_dongdat.mdx'},   # [bị động]
    'Khốn Hổ Vân Tiếu': {'main': 'MGC_khonhovantieueffect.mdx', 'cast': 'MGC_buffcast.mdx', 'target': 'MGC_phachdiatarget.mdx', 'area': ['MGC_khaithienthuc.mdx'], 'target_ground': True},   # [R]
    'Kim Qua Thiết Mã': {'main': 'MGC_kimquathietma.mdx'},   # [T]
    'Phách Địa Thế': {'main': 'MGC_phachdia.mdx', 'cast': 'MGC_buffcast.mdx', 'target': 'MGC_phachdiatarget.mdx', 'area': ['MGC_dongdat.mdx']},   # [D]
    'Ngự Mã Thuật': {'main': 'MGC_khuhothuc.mdx'},   # [bị động]
    'Long Thôn Thức': {'main': 'MGC_longthontarget.mdx', 'cast': 'MGC_buffcast.mdx', 'target': 'MGC_longthontarget.mdx'},   # [W]
    'Hồn Phách Phi Dương': {'main': 'MGC_honphach.mdx', 'target': 'MGC_xichtarget.mdx'},   # [F]
    'Cửu Hi Hỗn Dương': {'main': 'MGC_cuuhihonduong.mdx'},   # [bị động]
    'Liệt Diệm Thao Thiên': {'main': 'MGC_khaithienthuc.mdx'},   # [bị động]
    'Khu Hổ Thức': {'main': 'MGC_khuhothuc.mdx', 'cast': 'MGC_buffcast.mdx', 'target': 'MGC_khuhothuctarget.mdx'},   # [E]
    'Trấn Ngục Phá Thiên Kinh': {'main': 'MGC_khaithienthuc.mdx', 'area': ['MGC_kimquathietma.mdx']},   # [bị động]
    'Không Tuyệt Tâm Pháp': {'main': 'MGC_cuuhihonduong.mdx'},   # [bị động]
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
# 1. Khai Thiên Thức [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khaithienthuc.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star.blp
#         texture: Textures\star1.blp
#         texture: Textures\star2.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star3.blp
#         texture: Textures\star32.blp
#         texture: Textures\star4.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star6.blp
#         texture: Textures\Star8.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\Star9.blp
#    lúc tung (trên tướng): MGC_buffcast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Energy1.blp
#
# 2. Minh Giáo Chùy Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_dongdat.mdx   [riêng phái]
#         texture: KVCT3_Data\carck_tp_dust.blp
#         texture: KVCT3_Data\crack_tp.blp
#         texture: KVCT3_Data\chongjibo2.blp
#         texture: KVCT3_Data\flarer1white.blp
#         texture: KVCT3_Data\Knife_light1M.blp
#         texture: KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\flare4x4.blp
#         texture: KVCT3_Data\chongjibo3.blp
#         texture: KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 3. Khốn Hổ Vân Tiếu [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khonhovantieueffect.mdx   [riêng phái]
#         texture: KVCT3_Data\zd107.blp
#    lúc tung (trên tướng): MGC_buffcast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Energy1.blp
#    trên địch bị trúng: MGC_phachdiatarget.mdx   [riêng phái]
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Fire.blp
#         texture: Textures\star6.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave4white.blp
#         texture: KVCT3_Data\AZ_lightningBlack_2x2.blp
#         texture: KVCT3_Data\AZ_glow1.blp
#    lớp thêm tại điểm 1: MGC_khaithienthuc.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star.blp
#         texture: Textures\star1.blp
#         texture: Textures\star2.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star3.blp
#         texture: Textures\star32.blp
#         texture: Textures\star4.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star6.blp
#         texture: Textures\Star8.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\Star9.blp
#
# 4. Kim Qua Thiết Mã [T]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_kimquathietma.mdx   [riêng phái]
#         texture: abilities\Spells\NightElf\TrueshotAura\quartercircle2.blp
#         texture: textures\ghost2.blp
#
# 5. Phách Địa Thế [D]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_phachdia.mdx   [riêng phái]
#         texture: Units\Human\Uther\Uther.blp
#         texture: Textures\Yellow_Star.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Abilities\Weapons\PhoenixMissile\RibbonMagic1.blp
#         texture: Textures\Yellow_Star_Dim.blp
#         texture: Textures\Yellow_Glow.blp
#         texture: Textures\Yellow_Glow_Dim2.blp
#         texture: Textures\Sparkle_Anim.blp
#         texture: Textures\Shockwave1White.blp
#    lúc tung (trên tướng): MGC_buffcast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Energy1.blp
#    trên địch bị trúng: MGC_phachdiatarget.mdx   [riêng phái]
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: Textures\LavaLump.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Fire.blp
#         texture: Textures\star6.blp
#         texture: Textures\star4_32.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Shockwave4white.blp
#         texture: KVCT3_Data\AZ_lightningBlack_2x2.blp
#         texture: KVCT3_Data\AZ_glow1.blp
#    lớp thêm tại điểm 1: MGC_dongdat.mdx   [riêng phái]
#         texture: KVCT3_Data\carck_tp_dust.blp
#         texture: KVCT3_Data\crack_tp.blp
#         texture: KVCT3_Data\chongjibo2.blp
#         texture: KVCT3_Data\flarer1white.blp
#         texture: KVCT3_Data\Knife_light1M.blp
#         texture: KVCT3_Data\Knife_light2F.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\flare4x4.blp
#         texture: KVCT3_Data\chongjibo3.blp
#         texture: KVCT3_Data\crack3.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Rock01_04.blp
#         texture: Textures\white.blp
#         texture: KVCT3_Data\rock.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 6. Ngự Mã Thuật [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khuhothuc.mdx   [riêng phái]
#         texture: KVCT3_Data\shuangchui11.blp
#
# 7. Long Thôn Thức [W]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_longthontarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#    lúc tung (trên tướng): MGC_buffcast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Energy1.blp
#    trên địch bị trúng: MGC_longthontarget.mdx   [riêng phái]
#         texture: Textures\Shockwave1.blp
#         texture: Textures\GenericGlow5.blp
#
# 8. Hồn Phách Phi Dương [F]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_honphach.mdx   [riêng phái]
#         texture: KVCT3_Data\Ghost.blp
#         texture: KVCT3_Data\Mystic_Glow.blp
#    trên địch bị trúng: MGC_xichtarget.mdx   [riêng phái]
#         texture: UI\Glues\SinglePlayer\NightElfCampaign3D\Chains.blp
#         texture: Textures\GenericGlowFaded.blp
#
# 9. Cửu Hi Hỗn Dương [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_cuuhihonduong.mdx   [riêng phái]
#         texture: KVCT3_Data\circlegreen3.blp
#         texture: KVCT3_Data\energyringgreen.blp
#         texture: KVCT3_Data\flare.blp
#         texture: KVCT3_Data\glow5.blp
#         texture: KVCT3_Data\leaves2x2.blp
#
# 10. Liệt Diệm Thao Thiên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khaithienthuc.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star.blp
#         texture: Textures\star1.blp
#         texture: Textures\star2.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star3.blp
#         texture: Textures\star32.blp
#         texture: Textures\star4.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star6.blp
#         texture: Textures\Star8.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\Star9.blp
#
# 11. Khu Hổ Thức [E]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khuhothuc.mdx   [riêng phái]
#         texture: KVCT3_Data\shuangchui11.blp
#    lúc tung (trên tướng): MGC_buffcast.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\GenericGlow2_32.blp
#         texture: Textures\Energy1.blp
#    trên địch bị trúng: MGC_khuhothuctarget.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#         texture: Textures\Leaf4x4.blp
#         texture: KVCT3_Data\AZ_Shockwave15.blp
#         texture: KVCT3_Data\EarthSpirit_wave5.blp
#
# 12. Trấn Ngục Phá Thiên Kinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_khaithienthuc.mdx   [riêng phái]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Demolisher.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\star.blp
#         texture: Textures\star1.blp
#         texture: Textures\star2.blp
#         texture: Textures\star2_32.blp
#         texture: Textures\star3.blp
#         texture: Textures\star32.blp
#         texture: Textures\star4.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\star6.blp
#         texture: Textures\Star8.blp
#         texture: Textures\Star8b.blp
#         texture: Textures\Star8c.blp
#         texture: Textures\Star9.blp
#    lớp thêm tại điểm 1: MGC_kimquathietma.mdx   [riêng phái]
#         texture: abilities\Spells\NightElf\TrueshotAura\quartercircle2.blp
#         texture: textures\ghost2.blp
#
# 13. Không Tuyệt Tâm Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MGC_cuuhihonduong.mdx   [riêng phái]
#         texture: KVCT3_Data\circlegreen3.blp
#         texture: KVCT3_Data\energyringgreen.blp
#         texture: KVCT3_Data\flare.blp
#         texture: KVCT3_Data\glow5.blp
#         texture: KVCT3_Data\leaves2x2.blp
# ===== HẾT DANH MỤC =====
