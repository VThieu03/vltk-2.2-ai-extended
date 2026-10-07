# TVC: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TVC.py). Sửa file này rồi chạy lại pipeline.
VFX = {
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Hành Vân Quyết': {'main': 'TVC_Hanhvan.mdx', 'target': 'TVC_thualongquyettarget.mdx'},   # [Q]
    'Thiên Vương Chùy Pháp': {'main': 'TVC_hoakinhquyet.mdx'},   # [bị động]
    'Đoạn Hồn Thích': {'main': 'TVT_doanhonthich.mdx'},   # [R]
    'Thiên Vương Bản Sinh': {'main': 'TVC_thualongquyet.mdx'},   # [bị động]
    'Kim Chung Tráo': {'main': 'TVC_kimchungtrao.mdx', 'cast': 'TVC_kimchungcast.mdx'},   # [F]
    'Bất Diệt Sát Ý': {'main': 'TVC_tramlongeffect1.mdx'},   # [bị động]
    'Thừa Long Quyết': {'main': 'TVC_thualongquyet.mdx', 'cast': 'TVC_thualongcast.mdx', 'target': 'TVC_thualongquyettarget.mdx', 'cast_ground': True},   # [W]
    'Trảm Long Quyết': {'main': 'TVC_tramlongeffect2.mdx', 'target': 'TVC_thualongquyettarget.mdx'},   # [D]
    'Càn Khôn Chùy': {'main': 'TVC_cankhonchuybuff.mdx'},   # [bị động]
    'Hóa Kinh Quyết': {'main': 'TVC_hoakinhquyet.mdx', 'target': 'TVC_thualongquyettarget.mdx', 'aura': 'TVC_hoakinhquyet.mdx'},   # [bị động]
    'Tung Hoành Tứ Hải': {'main': 'TVC_tranphaieffect1.mdx', 'area': ['TVC_tranphaieffect2.mdx', 'TVC_tranphaichuy.mdx']},   # [E]
    'Đảo Hư Thiên': {'main': 'TVC_hoakinhquyet.mdx'},   # [bị động]
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
# 1. Hành Vân Quyết [Q]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_Hanhvan.mdx   [riêng phái]
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\pixies1.blp
#         texture: Textures\Ghost2.blp
#         texture: Textures\Shockwave4white.blp
#         texture: Textures\Shockwave1.blp
#    trên địch bị trúng: TVC_thualongquyettarget.mdx   [riêng phái]
#         texture: Textures\Catapult.blp
#         texture: Textures\Shockwave1b.blp
#         texture: Textures\Dust5A.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave1.blp
#
# 2. Thiên Vương Chùy Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_hoakinhquyet.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\HowlOfTerror\Skull1.blp
#         texture: KVCT3_Data\D00871.blp
#         texture: Textures\Shockwave10.blp
#
# 3. Đoạn Hồn Thích [R]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVT_doanhonthich.mdx   [dùng chung (cùng dùng: TVD, TVT)]
#         texture: KVCT3_Data\HB02_weapon02.blp
#         texture: KVCT3_Data\HB02_ATTACK.blp
#         texture: Textures\RibbonNE1_White.blp
#
# 4. Thiên Vương Bản Sinh [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_thualongquyet.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#
# 5. Kim Chung Tráo [F]   (kind 7, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_kimchungtrao.mdx   [riêng phái]
#         texture: KVCT3_Data\effect_jinzhongzhao.blp
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\GenericGlow2c.blp
#         texture: Textures\CrystalSheild.blp
#    lúc tung (trên tướng): TVC_kimchungcast.mdx   [riêng phái]
#         texture: Textures\star6.blp
#         texture: Textures\Dust5A.blp
#         texture: Textures\star5tga.blp
#         texture: Textures\firering4.blp
#         texture: Textures\Yellow_Glow.blp
#
# 6. Bất Diệt Sát Ý [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_tramlongeffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\effect_bomb_16_1.blp
#         texture: KVCT3_Data\effect_bomb_16_2.blp
#         texture: KVCT3_Data\effect_bomb_16_3.blp
#         texture: KVCT3_Data\effect_bomb_16_4.blp
#         texture: KVCT3_Data\effect_bomb_16_5.blp
#         texture: KVCT3_Data\effect_bomb_16_6.blp
#         texture: KVCT3_Data\effect_bomb_16_7.blp
#
# 7. Thừa Long Quyết [W]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_thualongquyet.mdx   [riêng phái]
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TVC_thualongcast.mdx   [riêng phái]
#         texture: Textures\AxeBladeBlueSteel.blp
#         texture: KVCT3_Data\AZ_Particle_DragonSlash_01.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Shockwave29.blp
#         texture: Textures\Shockwave1.blp
#         texture: Textures\Shockwave11.blp
#         texture: Textures\Shockwave10.blp
#    trên địch bị trúng: TVC_thualongquyettarget.mdx   [riêng phái]
#         texture: Textures\Catapult.blp
#         texture: Textures\Shockwave1b.blp
#         texture: Textures\Dust5A.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave1.blp
#
# 8. Trảm Long Quyết [D]   (kind 3, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_tramlongeffect2.mdx   [riêng phái]
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Dust3x.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\Shockwave10.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Doodads\Cinematic\EyeOfSargeras\Demon_Rune_Cracks.blp
#         texture: Textures\RingOFire.blp
#    trên địch bị trúng: TVC_thualongquyettarget.mdx   [riêng phái]
#         texture: Textures\Catapult.blp
#         texture: Textures\Shockwave1b.blp
#         texture: Textures\Dust5A.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave1.blp
#
# 9. Càn Khôn Chùy [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_cankhonchuybuff.mdx   [riêng phái]
#         texture: war3mapImported\t3_effect_selectioncirclesmall1.blp
#
# 10. Hóa Kinh Quyết [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_hoakinhquyet.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\HowlOfTerror\Skull1.blp
#         texture: KVCT3_Data\D00871.blp
#         texture: Textures\Shockwave10.blp
#    trên địch bị trúng: TVC_thualongquyettarget.mdx   [riêng phái]
#         texture: Textures\Catapult.blp
#         texture: Textures\Shockwave1b.blp
#         texture: Textures\Dust5A.blp
#         texture: ReplaceableTextures\Weather\Clouds8x8.blp
#         texture: Textures\rock64.blp
#         texture: Textures\Shockwave1.blp
#    aura bị động (gắn tướng suốt): TVC_hoakinhquyet.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\HowlOfTerror\Skull1.blp
#         texture: KVCT3_Data\D00871.blp
#         texture: Textures\Shockwave10.blp
#
# 11. Tung Hoành Tứ Hải [E]   (kind 4, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_tranphaieffect1.mdx   [riêng phái]
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: Textures\Flare.blp
#         texture: KVCT3_Data\AZ_Smoke1E.blp
#         texture: KVCT3_Data\AZ_Flash6.blp
#         texture: KVCT3_Data\Flare2.blp
#         texture: KVCT3_Data\AZ_Stone1x2.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Rune10.blp
#         texture: KVCT3_Data\AZ_Smoke_yello2x2.blp
#         texture: KVCT3_Data\AZ_Flashb2p.blp
#         texture: KVCT3_Data\AZ_Crack33.blp
#    lớp thêm tại điểm 1: TVC_tranphaieffect2.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave1x.blp
#         texture: KVCT3_Data\AZ_Smoke9.blp
#         texture: KVCT3_Data\AZ_Stone6_1x2.blp
#         texture: Textures\Shockwave1.blp
#    lớp thêm tại điểm 2: TVC_tranphaichuy.mdx   [riêng phái]
#         texture: KVCT3_Data\shuangchui11.blp
#
# 12. Đảo Hư Thiên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): TVC_hoakinhquyet.mdx   [riêng phái]
#         texture: Abilities\Spells\Other\HowlOfTerror\Skull1.blp
#         texture: KVCT3_Data\D00871.blp
#         texture: Textures\Shockwave10.blp
#
# 13. Thiên Mã Hành Không [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\ThienMaHanhKhong.mdx   [dùng chung (model Thiên Kiếm) (cùng dùng: TVD, TVT)]
#         texture: Textures\GenericGlow64.blp
#         texture: HoaHiemViDi.blp
# ===== HẾT DANH MỤC =====
