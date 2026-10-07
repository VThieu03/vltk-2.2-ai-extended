# TLB: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/TLB.py). Sửa file này rồi chạy lại pipeline.
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
# 1. Phổ Độ Côn Pháp [Q]   (kind 16, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLB_targeteffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Shockwave9.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\Flare.blp
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Shockwave9.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\Flare.blp
#
# 2. Thiếu Lâm Côn Pháp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon2.mdx   [riêng phái]
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
# 3. Dịch Cân Kinh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_nhuythuccotcong.mdx   [riêng phái]
#         texture: Textures\sun.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Red_Glow2.blp
#         texture: KVCT3_Data\AZ_Flash4.blp
#         texture: KVCT3_Data\AZ_Flashb2p.blp
#         texture: KVCT3_Data\AZ_Flashb5.blp
#         texture: KVCT3_Data\jswuqi1.blp
#         texture: KVCT3_Data\AZ_Rune6.blp
#         texture: KVCT3_Data\Xin_E_Effect.blp
#         texture: KVCT3_Data\AZ_Rune3.blp
#         texture: KVCT3_Data\AZ_Rune2.blp
#         texture: Textures\Yellow_Glow3.blp
#         texture: KVCT3_Data\AZ_Shockwave31.blp
#         texture: KVCT3_Data\AZ_Ribbon03.blp
#
# 4. A La Hán Thần Công [bị động]   (kind 0, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLB_targeteffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Shockwave9.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\Flare.blp
#    aura bị động (gắn tướng suốt): TLD_lahantran.mdx   [dùng chung (cùng dùng: TLD)]
#         texture: Textures\LavaLump.blp
#         texture: KVCT3_Data\tx208-1.blp
#         texture: KVCT3_Data\tx208-2.blp
#
# 5. Bất Động Minh Vương [D]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_batdongbuff.mdx   [riêng phái]
#         texture: Textures\Ghost2.blp
#         texture: KVCT3_Data\chongjibo_frost.blp
#         texture: KVCT3_Data\chongjibo2.blp
#    lúc tung (trên tướng): TLB_batdongcast.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Shockwave1White.blp
#         texture: KVCT3_Data\EarthSpirit_F3.blp
#         texture: KVCT3_Data\AZ_Shockwave1x.blp
#         texture: KVCT3_Data\Flare2.blp
#
# 6. Như Lai Thiên Diệp [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: KVCT3_Data\AZ_FlareWhite1.blp
#         texture: KVCT3_Data\AZ_Flashb5.blp
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
#
# 7. Thất Tinh La Sát Côn [W]   (kind 4, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon11.mdx   [riêng phái]
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
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Shockwave9.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\Flare.blp
#    lớp thêm tại điểm 1: TLB_lasatcon2.mdx   [riêng phái]
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
# 8. Túy Tiên Bát Côn [R]   (kind 18, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLB_lasatcon11.mdx   [riêng phái]
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
#    trên địch bị trúng: TLB_targeteffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Ribbon13.blp
#         texture: KVCT3_Data\AZ_Shockwave9.blp
#         texture: KVCT3_Data\AZ_Shockwave25.blp
#         texture: KVCT3_Data\BlastFlash.blp
#         texture: KVCT3_Data\Flare.blp
#    lớp thêm tại điểm 1: TLB_lasatcon2.mdx   [riêng phái]
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
# 9. Kim Cang Bất Hoại [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_kimcangbuff.mdx   [riêng phái]
#         texture: Textures\Green_Glow3.blp
#         texture: Textures\star4_32.blp
#         texture: Abilities\Spells\Undead\RegenerationAura\DarkSummon.blp
#         texture: UI\Glues\SinglePlayer\NightElf_Exp\NightElfFemaleEyeGlow1.blp
#         texture: KVCT3_Data\Flare.blp
#         texture: Textures\Eyes.blp
#         texture: Textures\clouds_anim1_bw.blp
#         texture: Textures\ToonSmokeX.blp
#         texture: Textures\star5tga.blp
#
# 10. Như Ý Thúc Cốt Công [F]   (kind 6, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_nhuythuccotcong.mdx   [riêng phái]
#         texture: Textures\sun.blp
#         texture: Textures\Flare.blp
#         texture: Textures\Red_Glow2.blp
#         texture: KVCT3_Data\AZ_Flash4.blp
#         texture: KVCT3_Data\AZ_Flashb2p.blp
#         texture: KVCT3_Data\AZ_Flashb5.blp
#         texture: KVCT3_Data\jswuqi1.blp
#         texture: KVCT3_Data\AZ_Rune6.blp
#         texture: KVCT3_Data\Xin_E_Effect.blp
#         texture: KVCT3_Data\AZ_Rune3.blp
#         texture: KVCT3_Data\AZ_Rune2.blp
#         texture: Textures\Yellow_Glow3.blp
#         texture: KVCT3_Data\AZ_Shockwave31.blp
#         texture: KVCT3_Data\AZ_Ribbon03.blp
#
# 11. Vi Đà Hiến Chử [E]   (kind 4, bảng KVCT tự sinh)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: KVCT3_Data\AZ_FlareWhite1.blp
#         texture: KVCT3_Data\AZ_Flashb5.blp
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
#    lúc tung (trên tướng): TLB_vidacast.mdx   [riêng phái]
#         texture: KVCT3_Data\animeslash.blp
#         texture: KVCT3_Data\animeslashp.blp
#         texture: Textures\GenericGlow1.blp
#    trên địch bị trúng: TLB_vidatarget.mdx   [riêng phái]
#         texture: Textures\LightningBall.blp
#         texture: Textures\Zap1_Red.blp
#         texture: Textures\grad2d.blp
#         texture: Textures\Clouds8x8Fade.blp
#         texture: Textures\rock64.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang02.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang03.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang04.blp
#         texture: KVCT3_Data\mirrorzi_effect_tianshanliuyangzhang01.blp
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang05.BLP
#         texture: KVCT3_Data\mirrorzi_effect_rulaishenzhang_fire.BLP
#
# 12. Ma Kha Vô Lượng [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_tuytienbatcon.mdx   [riêng phái]
#         texture: Textures\Shockwave10.blp
#         texture: KVCT3_Data\AZ_Knife_light1M.blp
#         texture: Textures\RibbonNE1_blue.blp
#         texture: KVCT3_Data\AZ_Shockwave1U.blp
#         texture: KVCT3_Data\AZ_Splast2x2.blp
#         texture: Textures\Flare.blp
#
# 13. Tẩy Tủy Kinh [bị động]   (kind 0, chọn theo tên / tk_mapping)
#    chính (đạn bay / vùng / hiệu ứng): TLB_vidaeffect.mdx   [riêng phái]
#         texture: KVCT3_Data\AZ_Firering1A.blp
#         texture: Textures\star5tga.blp
#         texture: KVCT3_Data\AZ_Shockwave21.blp
#         texture: KVCT3_Data\AZ_FlareWhite1.blp
#         texture: KVCT3_Data\AZ_Flashb5.blp
#         texture: KVCT3_Data\AZ_Shockwave17.blp
#         texture: KVCT3_Data\star2x2.blp
#         texture: KVCT3_Data\AZ_Flashb3.blp
#         texture: Textures\Flare.blp
# ===== HẾT DANH MỤC =====
