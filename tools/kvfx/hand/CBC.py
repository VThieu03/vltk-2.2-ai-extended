# Cái Bang Chưởng (CBC): bảng SỬA TAY, thắng bảng tự sinh trong tools/kvfx/auto/CBC.py.
# Bằng chứng đọc từ code gốc KVCT (D:\kvct-dev\work\readable.j; HJ Hq El8 KPH Qh QO QG HF là hằng số chuỗi chứa đường dẫn model):
#   CBC_hanglong      <- e6l (dòng 59711, Q), eHw / eHT (68462 / 68561, W)
#   CBC_casting       <- eHR (68622, W: lúc tung), Jkt / Jk1 (89144 / 89220, E: lúc tung)
#   CBC_dulong        <- Jk1 (89214, E: đạn bay)
#   CBC_flame         <- JkN (89177, E: nổ trên địch bị trúng)
#   CBC_hoatbatluuthu <- Jdn (126008, ô 5: Túy Điệp Cuồng Vũ, gắn vào tướng)
# Khóa mỗi chiêu: main (model chính), cast (trên tướng lúc tung), target (trên địch bị trúng), area (thêm lớp tại điểm).
VFX = {
    "Hàng Long Hữu Hối": {"main": "CBC_hanglong.mdx","scale": 1.5},   # thêm "scale": 1.5 để to gấp rưỡi
    "Phi Long Tại Thiên": {"main": "CBC_hanglong.mdx", "cast": "CBC_luclongbuff.mdx","cast_scale": 0.1, "target": "CBC_casting.mdx","cast_scale": 0.5, "target_ground": True, "area": ["VolcanoMissile.mdx"], "cast_ground": True},
    "Long Du Thiên Địa": {"main": "CBC_dulong.mdx", "cast": "CBC_casting.mdx", "cast_scale": 0.1, "target": "CBC_flame.mdx", "target_ground": True, "area": ["CBC_flame.mdx"], "cast_ground": True},
    "Túy Điệp Cuồng Vũ": {"main": "CBC_hoatbatluuthu.mdx", "aura": "CBC_hoatbatluuthu.mdx"},
    "Thời Thừa Lục Long": {"main": "CBC_luclongbuff.mdx", "cast": "CBC_luclongcast.mdx"},
    "Triệt Y Thập Bát Điệt": {"main": "CBC_trietytbd.mdx"},
    "Giáng Long Chưởng": {"main": "CBC_gianglong.mdx"},
    # --- thêm tự động bởi kvfx_fill.py: model đang có hiệu lực của các chiêu còn lại (sửa tự do) ---
    'Cái Bang Chưởng Pháp': {'main': 'CBC_effect.mdx'},   # [bị động]
    'Hóa Hiểm Vi Di': {'main': 'MDX\\HoaHiemViDi.mdx'},   # [bị động]
    'Tiềm Long Tại Uyên': {'main': 'MDX\\TiemLong.mdx'},   # [bị động]
    'Trảo Long Công': {'main': 'MDX\\TraoLongCong.mdx'},   # [bị động]
    'Thần Long Bài Vĩ': {'main': 'CBC_flame.mdx'},   # [bị động]
    'Bá Vương Tá Giáp': {'main': 'CBC_bavuongbuff.mdx'},   # [bị động]
    'Giáng Long Chưởng': {'main': 'MDX\\GiangLong.mdx'},   # [bị động]
    'Triệt Y Thập Bát Điệt': {'main': 'CBC_trietytbd.mdx'},   # [D]
}

# Đổi texture của model (xem danh mục bên dưới).
TEXTURES = {
    
}
#python tools/kvfx_doc.py
#chạy lưu 
#build lại python scratchpad/run_pipeline.py

# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) =====
# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:
#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}
#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\Flame4.blp"}
#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)
# Sửa xong chạy lại pipeline (scratchpad/run_pipeline.py) để áp dụng.
#
# 1. Hàng Long Hữu Hối [Q]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_hanglong.mdx   [riêng phái]
#         texture: KVCT3_Data\KhangLongHuuHoi.blp
#         texture: Textures\Red_Glow2.blp
#
# 2. Cái Bang Chưởng Pháp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_effect.mdx   [riêng phái]
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Lords0000.blp
#         texture: Textures\Lords0001.blp
#         texture: Textures\Lords0002.blp
#         texture: Textures\Lords0003.blp
#         texture: Textures\Lords0004.blp
#         texture: Textures\Lords0005.blp
#         texture: Textures\Lords0006.blp
#         texture: Textures\Lords0007.blp
#         texture: Textures\Water_Particles.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\LavaLump2.blp
#
# 3. Hóa Hiểm Vi Di [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\HoaHiemViDi.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\Yellow_Glow3.blp
#         texture: HoaHiemViDi.blp
#
# 4. Thời Thừa Lục Long [R]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_luclongbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\FlyingDragon.blp
#    lúc tung (trên tướng): CBC_luclongcast.mdx   [riêng phái]
#         texture: Textures\Flame4.blp
#
# 5. Túy Điệp Cuồng Vũ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_hoatbatluuthu.mdx   [riêng phái, phái khác cũng dùng: CBB]
#         texture: KVCT3_Data\GenericGlowFadedA.blp
#         texture: KVCT3_Data\AZ_MagicMatrix17_White.blp
#    aura bị động (gắn tướng suốt): CBC_hoatbatluuthu.mdx   [riêng phái, phái khác cũng dùng: CBB]
#         texture: KVCT3_Data\GenericGlowFadedA.blp
#         texture: KVCT3_Data\AZ_MagicMatrix17_White.blp
#
# 6. Tiềm Long Tại Uyên [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\TiemLong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: UI\MiniMap\ping4.blp
#         texture: Textures\Purple_Glow.blp
#         texture: Abilities\Spells\Undead\VampiricAura\AuraRune6.blp
#         texture: SoPhuong.blp
#
# 7. Phi Long Tại Thiên [W]   (kind 16, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_hanglong.mdx   [riêng phái]
#         texture: KVCT3_Data\KhangLongHuuHoi.blp
#         texture: Textures\Red_Glow2.blp
#    lúc tung (trên tướng): CBC_luclongbuff.mdx   [riêng phái]
#         texture: Textures\GenericGlow64.blp
#         texture: KVCT3_Data\FlyingDragon.blp
#    trên địch bị trúng: CBC_casting.mdx   [riêng phái]
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_3.blp
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_4.blp
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_5.blp
#    lớp thêm tại điểm 1: VolcanoMissile.mdx   [dùng chung]
#         texture: Textures\Dust5A.blp
#         texture: Textures\Clouds8x8.blp
#         texture: Textures\LavaLump2.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\EQ_Rock2.blp
#         texture: Textures\Red_Glow3.blp
#
# 8. Trảo Long Công [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\TraoLongCong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\GenericGlow64.blp
#         texture: Textures\star5tga.blp
#
# 9. Thần Long Bài Vĩ [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_flame.mdx   [riêng phái]
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Red_star2.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Red_Glow3.blp
#
# 10. Bá Vương Tá Giáp [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_bavuongbuff.mdx   [riêng phái]
#         texture: KVCT3_Data\long1.blp
#         texture: KVCT3_Data\long2.blp
#         texture: KVCT3_Data\long3.blp
#
# 11. Long Du Thiên Địa [E]   (kind 5, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_dulong.mdx   [riêng phái]
#         texture: Textures\RedDragon.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\Shockwave1White.blp
#         texture: Textures\Red_Glow3.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\LavaLump.blp
#    lúc tung (trên tướng): CBC_casting.mdx   [riêng phái]
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_3.blp
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_4.blp
#         texture: KVCT3_Data\BY_Wood_Eff_Odr_Psy_Int_Imp_5.blp
#    trên địch bị trúng: CBC_flame.mdx   [riêng phái]
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Red_star2.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Red_Glow3.blp
#    lớp thêm tại điểm 1: CBC_flame.mdx   [riêng phái]
#         texture: Textures\LavaLump2.blp
#         texture: Textures\Red_star2.blp
#         texture: ReplaceableTextures\Splats\ThunderClapUbersplat.blp
#         texture: Textures\Dust5ABlack.blp
#         texture: Textures\RingOFire.blp
#         texture: Textures\Tornado2b.blp
#         texture: Textures\Clouds8x8Fire.blp
#         texture: Textures\Clouds8x8Mod.blp
#         texture: Textures\Red_Glow3.blp
#
# 12. Giáng Long Chưởng [bị động]   (kind 0, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): MDX\GiangLong.mdx   [dùng chung (model Thiên Kiếm)]
#         texture: Textures\WaterBlobs1.blp
#         texture: Textures\White_64_Foam1.blp
#         texture: Textures\Lords0000.blp
#         texture: Textures\Lords0001.blp
#         texture: Textures\Lords0002.blp
#         texture: Textures\Lords0003.blp
#         texture: Textures\Lords0004.blp
#         texture: Textures\Lords0005.blp
#         texture: Textures\Lords0006.blp
#         texture: Textures\Lords0007.blp
#         texture: Textures\Water_Particles.blp
#         texture: Textures\ShockwaveWater1.blp
#         texture: Textures\LavaLump2.blp
#
# 13. Triệt Y Thập Bát Điệt [D]   (kind 6, bảng tay)
#    chính (đạn bay / vùng / hiệu ứng): CBC_trietytbd.mdx   [riêng phái]
#         texture: Textures\Flame4.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield2.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield3.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield1.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield5.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield6.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_E_Shield7.blp
#         texture: KVCT3_Data\Hero_EmberSpirit_N4S_C_Target6.blp
# ===== HẾT DANH MỤC =====
