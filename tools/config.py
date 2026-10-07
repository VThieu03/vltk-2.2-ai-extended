# ==============================================================================
# TỆP CẤU HÌNH THÔNG SỐ (CONFIG) - VÕ LÂM TRUYỀN KỲ v2.2 AI EXTENDED
# ==============================================================================
# Hướng dẫn: Bạn có thể thay đổi các giá trị số ở dưới đây, sau đó lưu file lại
# và chạy lệnh `python scratchpad/run_pipeline_noui.py` để áp dụng vào map.
# ==============================================================================

# ---------------------------------------------------------
# 1. NHÂN VẬT (HEROES)
# ---------------------------------------------------------
# Hệ số nén chỉ số khi lên cấp 200 (Mặc định: 5)
# Bản gốc level max là 40, bản này là 200. Để game cân bằng, chỉ số tăng mỗi cấp bị chia cho 5.
# Nếu bạn muốn nhân vật lên cấp được cộng nhiều điểm thuộc tính (Str, Agi, Int) hơn, hãy giảm số này.
# Ví dụ: HERO_STAT_DIVIDER = 2 (nhân vật sẽ cực kỳ mạnh khi max cấp).
HERO_STAT_DIVIDER = 5

# ---------------------------------------------------------
# 2. THỜI GIAN VÀ SỰ KIỆN (EVENTS & BOSSES)
# ---------------------------------------------------------
# Phút thứ mấy Boss (Tuyệt Đại Cao Thủ) sẽ xuất hiện lần đầu tiên?
BOSS_FIRST_SPAWN_MINUTE = 7

# Phút thứ mấy Minh Chủ Võ Lâm sẽ xuất hiện lần đầu tiên?
MC_FIRST_SPAWN_MINUTE = 18

# Điều kiện thắng mạng (chế độ -win): Số mạng cần hạ gục để kết thúc trận đấu.
WIN_KILLS_REQUIRED = 150

# Hệ số Scale kích cỡ (phóng to) của Boss Tuyệt Đại Cao Thủ và Võ Lâm Minh Chủ
BOSS_SCALE_FACTOR = 5.0

# ---------------------------------------------------------
# 3. HỆ THỐNG RỚT ĐỒ (DROP SYSTEM)
# ---------------------------------------------------------
# Bậc trang bị (Tier) lớn nhất rớt ra từ quái Tinh Anh / Thủ Lĩnh (Mặc định: 4)
ELITE_DROP_MAX_TIER = 4

# Bậc trang bị lớn nhất rớt ra từ Boss (Mặc định: 5)
BOSS_DROP_MAX_TIER = 5

# ---------------------------------------------------------
# 4. TẦM ĐÁNH THƯỜNG CỦA TỪNG PHÁI (ATTACK RANGE)
# ---------------------------------------------------------
# Tầm đánh thường của tướng mỗi phái (đơn vị game; 100 = cận chiến). Phái đánh xa phải để số lớn (500-600) thì mới
# đứng yên đánh và tung chiêu từ xa; để 100 thì tướng chạy sát quái rồi mới đánh. Sửa số, lưu, rồi chạy lại pipeline.
# Giá trị mặc định = tầm hiện tại của tướng gốc (nhóm đánh xa: Phi Tiêu, Tụ Tiễn, Phi Đao, Cổ Mộ Châm, Đoàn Thị Chỉ
# nâng lên; các phái dùng khung Huyết Pháp Sư gốc đang có sẵn 600).
HERO_ATTACK_RANGE = {
    "NDD": 500, "TVD": 100, "VDK": 100, "TYD": 200, "TLQ": 100, "CBC": 500, "TLD": 500, "TVT": 100,
    "TNK": 100, "TLB": 100, "TVC": 100, "CBB": 500, "NMK": 500, "MGC": 100, "MGK": 500, "CMK": 100,
    "HSK": 100, "TDC": 500, "TDK": 100, "TYK": 500,
    "DMPT": 500, "DMTT": 500, "DMPD": 500, "NMC": 500, "CMC": 500, "DTC": 100, "HSQ": 500,
    "TND": 500, "CLK": 500, "NDC": 500, "VDQ": 500, "CLD": 500, "DTK": 500,
}

# ---------------------------------------------------------
# 5. KÍCH CỠ HIỆU ỨNG CHIÊU THỨC (SKILL EFFECT SIZE)
# ---------------------------------------------------------
# Phóng to / thu nhỏ hiệu ứng chính của MỌI chiêu lúc tung (phần trăm; 100 = nguyên bản, 150 = to gấp rưỡi).
SKILL_VFX_SCALE_PERCENT = 100
# Muốn chỉnh riêng một chiêu: thêm vào mục chiêu đó trong tools/kvfx/hand/<PHÁI>.py (số nhỏ hơn 10 = hệ số, 0.5 = một nửa,
# 1.5 = gấp rưỡi; số từ 10 trở lên = phần trăm):
#   "scale": 1.5          hiệu ứng chính (đạn bay / vùng)
#   "cast_scale": 0.5     hiệu ứng lúc tung trên tướng
#   "target_scale": 0.7   hiệu ứng trên địch bị trúng
# Các hệ số nhân với SKILL_VFX_SCALE_PERCENT ở trên.

# ---------------------------------------------------------
# 6. HIỆU ỨNG TRẠNG THÁI GẮN LÊN ĐỊCH (STATUS EFFECT MODELS)
# ---------------------------------------------------------
# Trạng thái mà đòn đánh / chiêu gây ra: 2 định thân, 3 choáng, 4 làm chậm, 5 bỏng (nhận thêm 50% sát thương).
# Model KVCT gắn lên địch suốt thời gian trạng thái. Để "" nếu muốn bỏ. Tên model nằm trong war3mapImported.
# Cột thứ hai: số giây mỗi lần model chạy hết một lượt (model chỉ có Birth, như Effect_fire2 ~2 giây, thì game đặt lại model
# sau mỗi lượt cho tới hết trạng thái); 0 = model tự lặp (có Stand).
STATUS_VFX = {
    2: ("Effect_dinhthan.mdx", 0),     # định thân: BoundBuff.blp (dây trói)
    4: ("Effect_dongbang.mdx", 0),     # làm chậm: Ice3b.blp, AZ_Crack28.blp (băng)
    5: ("Effect_fire2.mdx", 1.8),      # bỏng: Lords0000-0007.blp, LavaLump2.blp (lửa)
}

# ---------------------------------------------------------
# 7. ĐẠN BAY CỦA ĐÒN ĐÁNH THƯỜNG (ATTACK PROJECTILE)
# ---------------------------------------------------------
# Tốc độ đạn mặc định cho mọi phái (900 = nhìn rõ đạn bay, 1500 = gần như tức thì):
ATTACK_PROJECTILE_SPEED = 900
# Hiệu ứng bay từ tướng tới mục tiêu mỗi đòn đánh thường: ("tên model.mdx",) dùng tốc độ mặc định ở trên; muốn phái nào bay nhanh / chậm
# riêng thì ghi thêm số sau tên model: ("tên model.mdx", 1200) và số đó được áp dụng cho phái ấy. ("",) = không có đạn (đánh trúng ngay). Model là file trong war3mapImported (model KVCT của phái,
# xem danh mục trong tools/kvfx/hand/<PHÁI>.py). Nên chọn model kiểu "đạn" (có chuyển động, có đoạn Death), không dùng model buff / aura.
# Cột chú thích: model của Q / W / E của phái để tham khảo.
HERO_ATTACK_PROJECTILE = {
    "CBB": ("",),   # gợi ý: Q=CBB_bong.mdx; W=CBB_bong.mdx; E=CBB_bong.mdx
    "CBC": ("",),   # gợi ý: Q=CBC_hanglong.mdx; W=CBC_hanglong.mdx; E=CBC_dulong.mdx
    "CLD": ("",),   # gợi ý: Q=CLD_cuongphong.mdx; W=CLD_ngaotuyet.mdx; E=CLD_canhphong2.mdx
    "CLK": ("",),   # gợi ý: W=CLK_thientetanloi.mdx; E=CLK_loidongcuuthien.mdx
    "CMC": ("",),   # gợi ý: Q=CMC_lyhan.mdx; W=CMC_lyhan.mdx; E=CMC_cham5_5.mdx
    "CMK": ("",),   # gợi ý: Q=CMK_thunhan.mdx; W=CMK_conguyet.mdx; E=CMK_chungnam.mdx
    "DMPD": ("",),   # gợi ý: Q=DMPD_phidao1.mdx; W=DMPD_nhiephonwave1_1.mdx; E=DMPD_voanhxuyen.mdx
    "DMPT": ("",),   # gợi ý: Q=DMPT_tanhoatieu.mdx; W=DMPT_cuucung4.mdx; E=DMPT_cankhonnhattrich3.mdx
    "DMTT": ("",),   # gợi ý: Q=DMTT_doancannhan.mdx; W=DMTT_baovu.mdx; E=DMTT_khongtuocvu1.mdx
    "DTC": ("",),   # gợi ý: W=DTC_canduongeffect1.mdx; E=DTC_thienlongchi1.mdx
    "DTK": ("",),   # gợi ý: Q=DTK_kimngocmanduong.mdx; W=DTK_lucmachcaster.mdx; E=DTK_lucmachcaster.mdx
    "HSK": ("",),   # gợi ý: E=HSK_thienthandaohuyen.mdx
    "HSQ": ("",),   # gợi ý: Q=HSQ_thanhvan.mdx; W=HSQ_mavansword.mdx; E=HSQ_phachthach.mdx
    "MGC": ("",),   # gợi ý: Q=MGC_khaithienthuc.mdx; W=MGC_longthontarget.mdx; E=MGC_khuhothuc.mdx
    "MGK": ("",),   # gợi ý: E=MGK_thanhhoaln.mdx
    "NDC": ("",),   # gợi ý: Q=NDC_effect1.mdx; W=NDC_amphong1.mdx; E=NDC_quytrao.mdx
    "NDD": ("",),   # gợi ý: Q=NDD_huyetdao.mdx; W=NDD_huyenamdao.mdx; E=NDD_uhonpheanh2.mdx
    "NMC": ("",),   # gợi ý: Q=NMC_tutuongdq.mdx; W=NMC_diepdetanghoa.mdx; E=NMC_nguyethoaeffect.mdx
    "NMK": ("",),   # gợi ý: Q=NMK_thoisongeffect.mdx; W=NMK_kiemanhphatquang.mdx; E=NMK_bangsuongkiem.mdx
    "TDC": ("",),   # gợi ý: Q=TDC_duongca.mdx; W=TDC_bachnhat1.mdx; E=TDC_wave1.mdx
    "TDK": ("",),   # gợi ý: Q=TDK_tramvankiem2.mdx; W=TDK_techieukiem.mdx; E=TDK_kiemchungdan4.mdx
    "TLB": ("",),   # gợi ý: Q=TLB_targeteffect.mdx; W=TLB_lasatcon11.mdx; E=TLB_vidaeffect.mdx
    "TLD": ("",),   # gợi ý: Q=TLD_phucmadp.mdx; W=TLD_votuongtram.mdx; E=TLD_tamgioihoasen.mdx
    "TLQ": ("",),   # gợi ý: Q=TLQ_longtraohotrao.mdx; W=TLQ_kimcuongphucma.mdx; E=TLQ_votuongeffect.mdx
    "TND": ("",),   # gợi ý: Q=TND_danchifire.mdx; W=TND_thienngoaistone.mdx; E=TND_tathoafire.mdx
    "TNK": ("",),   # gợi ý: Q=TNK_tanduongnhuhuyet.mdx; W=TNK_vanlongkich.mdx; E=TNK_gianghai1.mdx
    "TVC": ("",),   # gợi ý: Q=TVC_Hanhvan.mdx; W=TVC_thualongquyet.mdx; E=TVC_tranphaieffect1.mdx
    "TVD": ("",),   # gợi ý: Q=TVD_targeteffect1.mdx; W=TVD_phathientram.mdx; E=TVD_tranphainewz2.mdx
    "TVT": ("",),   # gợi ý: Q=TVT_hoiphonglacnhan.mdx; W=TVT_truytinheffect.mdx; E=TVT_bavuongtramkim_target.mdx
    "TYD": ("",),   # gợi ý: Q=TYD_mucda.mdx; W=TYD_bangtunghoasen.mdx; E=TYD_bangtuocdao1.mdx
    "TYK": ("",),   # gợi ý: Q=TYK_phongquyen.mdx; W=TYK_bangtamtientu2.mdx; E=TYK_thuyanh1.mdx
    "VDK": ("",),   # gợi ý: Q=VDK_tamhoanthaonguyet.mdx; W=VDK_nhankiemsword.mdx; E=VDK_vothuongkiem.mdx
    "VDQ": ("",),   # gợi ý: Q=VDQ_baccapnhiphuc.mdx; W=VDQ_thaicuc.mdx; E=VDQ_cuucung1.mdx
}

# ---------------------------------------------------------
# 8. VŨ KHÍ TẦN LĂNG (TRÙNG SINH 11)
# ---------------------------------------------------------
# Vũ khí Tần Lăng (mã ITW0..ITWA theo loại vũ khí) bán trong cửa hàng bên dưới, THAY cho trang bị chế đang bán ở đó.
# Mỗi người chơi chỉ thấy / mua được loại vũ khí đúng với phái của mình (kiếm, đao, thương, ...).
# Mua tốn: vàng (số bên dưới) + 1 vũ khí +10 cùng loại (trong hành trang hoặc đang mặc) + 1 Tần Lăng Hòa Thị Bích.
# Thiếu điều kiện nào thì game hoàn vàng, báo rõ còn thiếu gì.
# Giá vàng một món vũ khí Tần Lăng (giá hiện trên cửa hàng cũng lấy từ số này):
TANLANG_WEAPON_GOLD = 20000
# Mã đơn vị cửa hàng bán vũ khí Tần Lăng (mặc định n00K = Cửa hàng vũ khí; n00M = Tàng Bảo Các, tiệm nguyên liệu cũ "tạp hóa").
# Chỉ đổi khi muốn chuyển sang cửa hàng khác; hàng chế cũ của cửa hàng đó sẽ bị thay bằng vũ khí Tần Lăng.
TANLANG_SHOP_UNIT = "n00K"

# ---------------------------------------------------------
# 10. ICON THEO BẬC CƯỜNG HÓA (để chọn bộ icon màu: xám → xanh → tím → cam → vàng)
# ---------------------------------------------------------
# Mặc định để trống {} = dùng bộ icon hiện tại (cam → vàng, bảng "HIEN_TAI_dang_dung.png"). Muốn dùng bộ icon KVCT khác cho một ô,
# thêm một dòng: khóa là số ô (1 nón, 2 áo, 3 lưng, 4 tay, 5 giày, 7 liên, 8 nhẫn, 9 bội, 10 phù) hoặc "w0".."w10" cho vũ khí
# (loại: 0 kiếm, 1 đao, 2 thương, 3 chùy, 4 triền thủ, 5 côn, 6 tụ tiễn, 7 phi đao, 8 trường đao, 9 đại đao, 10 phi tiêu);
# giá trị là (mẫu tên icon, danh sách 12 chỉ số cho bậc +0..+10 và Tần Lăng). Mẫu có {k} là chỗ thay chỉ số. Xem các bảng icon trong
# docs/kvequip_icons/ (mỗi icon ghi tên, ví dụ TB5_3 = bộ "Icon_TB5_{k}" chỉ số 3). Ví dụ vũ khí kiếm dùng bộ TB1 (xám, xanh, tím, cam, vàng):
#   "w0": ("Icon_TB1_{k}", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9]),
# Ví dụ nón dùng bộ TBTC4 (xanh lá, xanh dương, tím, cam, vàng; bậc 1-9, +10 dùng lại bậc 9):
#   1: ("Icon_TBTC4_{k}", [1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9, 9]),
# Icon phải có trong KVCT (xem bảng); chỉ đổi icon, tên và chỉ số của bậc giữ nguyên.
EQUIP_ICONS = {
}

# ---------------------------------------------------------
# 11. HUYỀN TINH DẠNG ĐIỂM (không tạo item thường trên terrain)
# ---------------------------------------------------------

# Huyền Tinh dạng GlassPoint. Quái không tạo vật phẩm rơi; số điểm được cộng thẳng cho chủ tướng hạ quái.
# Mục tiêu được tính theo toàn bộ 10 ô trang bị: khoảng 90 điểm phút 20, 225 phút 30, 825 phút 40.
GLASS_ENABLED = 1
GLASS_POINTS_AT_20 = 90
GLASS_POINTS_AT_30 = 225
GLASS_POINTS_AT_40 = 825
GLASS_CATCHUP_KILLS = 6
GLASS_MAX_POINTS_PER_KILL = 15
GLASS_VALUE_NORMAL = 1
GLASS_VALUE_ELITE = 3
GLASS_VALUE_LEADER = 5
GLASS_VALUE_BOSS_MIN = 6
GLASS_VALUE_BOSS_MAX = 7
GLASS_VALUE_SPECIAL_BOSS_MIN = 8
GLASS_VALUE_SPECIAL_BOSS_MAX = 10
# +1..+10; no downgrade. Failure consumes points and adds item-specific pity.
GLASS_ENHANCE_COST = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
GLASS_SUCCESS_RATE = [100] * 10
GLASS_PITY_REQUIRED = [0, 0, 1, 1, 2, 2, 3, 4, 5, 6]

# ---------------------------------------------------------
# 13. RƠI BẢO THẠCH (IG<loại><bậc>) - giống Huyền tinh: không mở khóa theo phút, rơi ngẫu nhiên theo loại quái
# ---------------------------------------------------------
# Loại quái: 0 = quái thường, 1 = Tinh Anh, 2 = Thủ Lĩnh, 3 = Boss (Hoàng Kim, Tần Thủy Hoàng...).
# Mỗi lần giết: GD_CHANCE_PCT[loại] % rơi GD_COUNT[loại] viên; mỗi viên loại (1..6) và bậc ngẫu nhiên trong GD_TIERS[loại].
GD_ENABLED = 1
GD_TIERS = {0: (1, 3), 1: (4, 6), 2: (4, 6), 3: (7, 9)}   # (bậc thấp nhất, bậc cao nhất)
GD_CHANCE_PCT = {0: 12, 1: 60, 2: 80, 3: 100}               # tỉ lệ rơi % mỗi lần giết
GD_COUNT = {0: 1, 1: 1, 2: 1, 3: 2}                        # số viên mỗi lần rơi

# ---------------------------------------------------------
# 12. BẢO THẠCH (tiệm tạp hóa - nâng bậc)
# ---------------------------------------------------------
# Bảo thạch có 6 loại x 9 bậc. Ở tiệm tạp hóa (đơn vị GEM_SHOP_UNIT) chọn tiệm, mua viên bảo thạch loại nào là nâng loại đó lên một bậc.
# Nâng bậc t lên t+1 tốn: N(t) = GEM_UP_BASE + GEM_UP_STEP * (t-1) viên bảo thạch CÙNG LOẠI, CÙNG BẬC t
#   + vàng theo cấp số cộng: lên bậc 2 = GEM_UP_GOLD, mỗi bậc sau thêm GEM_UP_GOLD_STEP (mặc định 1000, 2000 ... lên bậc 9 = 8000). Bậc 9 là tối đa.
# Mặc định BASE 2, STEP 1:   bậc 1->2: 2 viên | 2->3: 3 | 3->4: 4 | 4->5: 5 | 5->6: 6 | 6->7: 7 | 7->8: 8 | 8->9: 9 viên.
# Ví dụ BASE 3, STEP 2:      3, 5, 7, 9, 11, 13, 15, 17 viên.
GEM_UP_BASE = 2
GEM_UP_STEP = 1
GEM_UP_GOLD = 1000          # vàng nâng lên bậc 2
GEM_UP_GOLD_STEP = 1000     # thêm mỗi bậc sau
# Mã đơn vị tiệm nâng bảo thạch (mặc định n00M = Tàng Bảo Các, đổi tên "Tiệm tạp hóa - Nâng bảo thạch"; không còn bán nguyên liệu).
GEM_SHOP_UNIT = "n00M"
KQTRC_SHOP_UNIT = "n00L"          # cửa hàng giáp cũ đã bỏ, nay bán đá thuộc tính
KQTRC_STONE_GOLD = {1: 20000, 2: 40000, 3: 80000}  # Tốt, Trung, Cao
POTION_GOLD = {"phea": 200, "pghe": 450, "pman": 800, "pgma": 1250, "pres": 2000}
POTION_BULK_AMOUNT = 10
POTION_STACK_LIMIT = 10
POTION_AUTO_THRESHOLD_PCT = 50
POTION_REGEN_SECONDS = 4

# ---------------------------------------------------------
# 14. ẢNH GIAO DIỆN (UI CUSTOM ART)
# ---------------------------------------------------------
# Thay PNG/JPG ở đây để đổi hình UI. Đường dẫn tương đối tính từ thư mục tools/;
# cũng chấp nhận đường dẫn tuyệt đối. Ảnh sẽ tự chuyển sang BLP khi chạy pipeline.
# Panel cần ảnh vuông; HUD cần ảnh ngang trong suốt, bố cục 12 ô kỹ năng.
# Để trống tile thì lấy mẫu gỗ từ panel; để trống 2 ảnh nút thì dùng icon KVCT mặc định.
UI_CUSTOM_IMAGES = {
    "panel": "ui_custom/panel.png",
    "hud": "ui_custom/hud.png",
    "tile": "ui_custom/tile.png",
    "bag_button": "ui_custom/bag_button.png",
    "hero_button": "",
}

# ---------------------------------------------------------
# 15. HỆ NGOẠI CÔNG / NỘI CÔNG CỦA TỪNG PHÁI
# ---------------------------------------------------------
# "ngoai" = ngoại công (binh khí), "noi" = nội công (chưởng, khí, chỉ, châm...). Sửa chữ ở cột phải để đổi hệ.
# Hệ quyết định:
#   - dòng trang bị nào có tác dụng: "STVL ngoại công" chỉ cộng cho phái ngoại, "STVL nội công" chỉ cộng cho phái nội
#     (cộng vào cả đánh thường lẫn kỹ năng);
#   - sát thương kỹ năng tính theo chỉ số nào (PHE_SKILL_SCALE bên dưới);
#   - né tránh: đòn của phái ngoại bị né bằng "né tránh ngoại công", đòn của phái nội bằng "né tránh nội công";
#   - bảng nhân vật (I) ghi "Hệ: Ngoại công" / "Hệ: Nội công".
CLASS_PHE = {
    "TLD": "ngoai",  # Thiếu Lâm Đao
    "TLQ": "ngoai",  # Thiếu Lâm Quyền
    "TLB": "ngoai",  # Thiếu Lâm Bổng
    "TVD": "ngoai",  # Thiên Vương Đao
    "TVT": "ngoai",  # Thiên Vương Thương
    "TVC": "ngoai",  # Thiên Vương Chùy
    "DMPT": "ngoai", # Đường Môn Phi Tiêu
    "DMTT": "ngoai", # Đường Môn Tụ Tiễn
    "DMPD": "ngoai", # Đường Môn Phi Đao
    "NDD": "ngoai",  # Ngũ Độc Đao
    "NDC": "noi",    # Ngũ Độc Chưởng
    "NMK": "noi",    # Nga My Kiếm
    "NMC": "noi",    # Nga My Chưởng
    "TYD": "ngoai",  # Thúy Yên Đao
    "TYK": "noi",    # Thúy Yên Kiếm
    "CBB": "ngoai",  # Cái Bang Bổng
    "CBC": "noi",    # Cái Bang Chưởng
    "TNK": "ngoai",  # Thiên Nhẫn Kích
    "TND": "noi",    # Thiên Nhẫn Đao (ma đao, nội công)
    "VDK": "ngoai",  # Võ Đang Kiếm
    "VDQ": "noi",    # Võ Đang Khí
    "CLD": "ngoai",  # Côn Lôn Đao
    "CLK": "noi",    # Côn Lôn Kiếm (lôi pháp, nội công)
    "DTK": "noi",    # Đoàn Thị Khí
    "DTC": "ngoai",    # Đoàn Thị Chỉ
    "MGC": "ngoai",  # Minh Giáo Chùy
    "MGK": "noi",  # Minh Giáo Kiếm
    "CMC": "noi",    # Cổ Mộ Châm
    "CMK": "ngoai",  # Cổ Mộ Kiếm
    "HSQ": "noi",    # Hoa Sơn Khí
    "HSK": "ngoai",  # Hoa Sơn Kiếm
    "TDC": "noi",    # Tiêu Dao Chưởng
    "TDK": "ngoai",  # Tiêu Dao Kiếm
}
# Sức mạnh đòn kỹ năng = % sát thương vũ khí + hệ số × Sức mạnh / Thân pháp / Nội công (số thập phân được).
#                 (% vũ khí, Sức mạnh, Thân pháp, Nội công)
PHE_SKILL_SCALE = {
    "ngoai": (100, 1.0, 0.5, 0.5),
    "noi":   (100,  1.0, 0.5, 0.5),
}
# Né tránh nội công gốc = Nội công × hệ số này (né tránh ngoại công gốc vẫn = Thân pháp / 2), cộng dòng "né tránh" trang bị.
PHE_DODGE_NOI_PER_INT = 0.5
#Sửa xong thì chạy python tools/pipeline.py.

# ---------------------------------------------------------
# 16. KHUÔN Ô TRANG BỊ TRONG BẢNG NHÂN VẬT (phím I)
# ---------------------------------------------------------
# Tọa độ màn hình của WC3: x 0 (trái) .. 0.8 (phải), y 0 (dưới) .. 0.6 (trên).
#   x, y  : góc trên-trái của ô đầu tiên trong cột
#   size  : cạnh ô (khung bấm)
#   step  : khoảng cách dọc giữa hai ô
#   inset : icon thụt vào mỗi cạnh so với khung ô (0 = phủ kín khung; tăng lên để icon nhỏ lại, nằm giữa khuôn)
#   dx, dy: dịch cả cột sang phải (+) / trái (-), lên (+) / xuống (-) để khớp khuôn UI
# Cột trái: Nón, Áo, Yêu Đái, Hộ Uyển, Hài; cột phải: Vũ Khí, Hạng Liên, Giới Chỉ, Ngọc Bội, Hộ Thân Phù.
# Nút "+" cường hóa đi theo cột (cột trái: bên phải ô; cột phải: bên trái ô).
EQUIP_UI = {
    "icon_left":  {"x": 0.025, "y": 0.482, "size": 0.032, "step": 0.048, "inset": 0.003, "dx": 0.0, "dy": 0.0},
    "icon_right": {"x": 0.322, "y": 0.482, "size": 0.032, "step": 0.048, "inset": 0.003, "dx": 0.0, "dy": 0.0},
}

# ---------------------------------------------------------
# 17. THÔNG SỐ CHIẾN ĐẤU / KỸ NĂNG (mỗi dòng sinh hàm JASS zzCF_<TÊN>(); số nguyên ra integer, số thập phân ra real)
# ---------------------------------------------------------
# Đổi số ở đây rồi build lại, không cần sửa JASS. Ghi số thập phân có dấu chấm (1.0, không ghi 1) cho thông số dạng real.
GAME = {
    # --- Sát thương kỹ năng KVCT (tools/kskill.j zzKS_Hit):
    #     sức mạnh đòn × (GOC + MOI_BAC × bậc) × (1 + NHIEU_DON × (số đòn - 1)) / số đòn + CONG_MOI_BAC × bậc
    "SKILL_DMG_GOC": 0.9,
    "SKILL_DMG_MOI_BAC": 0.17,
    "SKILL_DMG_NHIEU_DON": 0.3,
    "SKILL_DMG_CONG_MOI_BAC": 20.0,
    "HERO_DMG_NHAN": 0.65,          # mọi nguồn sát thương lên tướng: còn 65%, tăng thời gian sống sót
    "HERO_SKILL_DMG_NHAN": 0.45,    # sát thương kỹ năng lên tướng nhân thêm 45% sau hệ số chung
    "KHINH_CONG_DISTANCE": 420.0,   # quãng lướt theo hướng tướng đang quay
    "KHINH_CONG_TIME": 0.375,       # thời gian lướt (giây)
    "KHINH_CONG_IMMUNE": 0.45,      # miễn sát thương trong lúc lướt và 0.075 giây đệm
    "KHINH_CONG_COOLDOWN": 4.0,    # hồi chiêu khinh công
    "CAP_KY_NANG_PCT": 10.0,        # mỗi "cấp kỹ năng +1" trên trang bị: +% sát thương kỹ năng
    # --- Kháng, né, đánh trúng (gameplay_04_combat.j)
    "KHANG_TOI_DA": 80,             # kháng ngũ hành tối đa %
    "NE_TOI_DA": 500,               # tỉ lệ né tối đa (phần nghìn: 500 = 50%)
    "NE_QUAI": 50,                  # né tránh của quái / unit không phải tướng
    "DANH_TRUNG_QUAI": 50,          # đánh trúng của quái
    # --- Trạng thái
    "BI_THUONG_NHAN": 1.15,         # bị thương (fx 512): nhân sát thương nhận
    "BONG_NHAN": 1.5,               # bỏng: nhân sát thương nhận
    "SUY_YEU_TOI_DA": 20,           # suy yếu: giảm sát thương gây ra tối đa %
    "NGU_HANH_VU_KHI_NHAN": 1.08,   # vũ khí có ngũ hành: nhân sát thương
    # --- Bộ ngũ hành (hệ của tướng, theo cấp bộ)
    "KIM_SAT_THUONG_MOI_CAP": 0.05, # Kim: +sát thương mỗi cấp bộ
    "KIM_CHOANG_PCT_MOI_CAP": 2,    # Kim: tỉ lệ choáng % mỗi cấp
    "KIM_CHOANG_GIAY": 0.5,
    "KIM_CHOANG_HOI": 3.0,          # mỗi mục tiêu tối đa 1 lần / số giây này
    "MOC_DOC_GIAY": 5.0,            # Mộc: độc kéo dài / hồi
    "MOC_DOC_MOI_CAP": 0.006,       # Mộc: mỗi giây × sát thương đòn × cấp
    "THUY_CHAM_MOI_CAP": 0.05,      # Thủy: chậm % mỗi cấp (0.05 = 5%)
    "THUY_CHAM_GIAY": 2.0,
    "HOA_GAP_DOI_PCT_MOI_CAP": 4,   # Hỏa: tỉ lệ đòn gấp đôi % mỗi cấp
    "HOA_THIEU_DOT_GIAY": 3.0,      # Hỏa: thiêu đốt (giảm 50% hồi máu)
    "THO_PHAN_CHAN_MOI_CAP": 0.02,  # Thổ: trả lại sát thương mỗi cấp
    "THO_PHAN_CHAN_HOI": 0.3,       # Thổ: giãn cách phản chấn (giây)
    "QUAN_HAM_SAT_THUONG": 0.0125,  # mỗi bậc QUAN ẤN (8 bậc): +sát thương (8 bậc x 1.25% = 10%)
    "CLOAK_DEF_PER_TIER": 4,        # phi phong: mỗi bậc cộng phòng thủ
    "CLOAK_STAT_PER_TIER": 1,       # phi phong: mỗi bậc cộng Sức mạnh / Thân pháp / Nội công
    "CLOAK_HP_PER_TIER": 200,       # phi phong: mỗi bậc cộng sinh lực
    # --- Khung mô tả vật phẩm khi rê chuột (hành trang / nhân vật): rộng, cao mỗi dòng chữ, số ký tự mỗi dòng (để tính cao khung)
    "TIP_WIDTH": 0.30,
    "TIP_LINE_H": 0.0082,
    "TIP_CHARS": 56,
    # --- Thời gian HỒI SINH của tướng theo cấp tướng lúc chết (giây): cấp <= LV1 hồi T1, <= LV2 hồi T2, <= LV3 hồi T3, còn lại T4
    "REVIVE_LV1": 50,
    "REVIVE_LV2": 100,
    "REVIVE_LV3": 150,
    "REVIVE_T1": 5.0,
    "REVIVE_T2": 7.0,
    "REVIVE_T3": 8.0,
    "REVIVE_T4": 10.0,
    # --- Hành trang (phím B): số ô (tối đa 99), số cột, góc trên-trái và bề rộng khung (tọa độ màn hình 0..0.8 x 0..0.6).
    #     Ô được chia đều trong khung; chiều cao khung tự tính theo số hàng. Khung gốc rộng 0.31; hiện dùng 85% = 0.2635.
    "BAG_SLOTS": 60,
    "BAG_COLS": 10,
    "BAG_X": 0.475,
    "BAG_Y": 0.565,
    "BAG_W": 0.2635,
    # --- Bộ ngũ hành (đủ 10 ô trang bị): cấp bộ = món thấp nhất; món KVCT +0 = cấp 1, từ bậc dưới đây lên cấp 2..5
    "BO_CAP2_TU_BAC": 1,
    "BO_CAP3_TU_BAC": 4,
    "BO_CAP4_TU_BAC": 7,
    "BO_CAP5_TU_BAC": 10,
    # --- Khảm (hành trang): Tách bảo thạch khỏi trang bị
    "KHAM_SO_LO": 2,                # số lỗ khảm mỗi trang bị
    "KHAM_TACH_VANG": 2000,         # vàng phải trả cho MỖI viên khi tách khỏi trang bị
}

# ---------------------------------------------------------
# 18. PHI PHONG (15 bậc) VÀ QUAN ẤN (8 bậc) THEO KVCT (tên + màu chữ lấy từ code KVCT: fBO / K_8, shop.tsv)
# ---------------------------------------------------------
# Cả hai tăng theo CÔNG TRẠNG của người chơi (hạ tướng +10, hỗ trợ +4, hạ boss +15..40, nhiệm vụ +8 ...). Đạt mốc là lên bậc.
#   - Phi phong: danh hiệu [..] hiện trên đầu tướng + cộng chỉ số theo bậc (CLOAK_*_PER_TIER trong GAME).
#   - Quan ấn: chức quan hiện trước tên tướng, mỗi bậc cộng sát thương (QUAN_HAM_SAT_THUONG trong GAME).
# Mỗi dòng: (mã màu RRGGBB, tên, [tên phi phong đầy đủ của KVCT], công trạng cần). Muốn lên bậc nhanh / chậm hơn: sửa số cuối.
PHI_PHONG = [
    ("7fff00", "Siêu Phàm",  "Phi Phong Siêu Phàm Hi Ký",          30),
    ("0078d7", "Xuất Trần",  "Phi Phong Xuất Trần Kinh Hồng",      80),
    ("9370db", "Lăng Tuyệt", "Phi Phong Lăng Tuyệt Vụ Ảnh",       150),
    ("9370db", "Kinh Thế",   "Phi Phong Kinh Thế Độc Vũ",         250),
    ("ffa500", "Ngự Không",  "Phi Phong Ngự Không Phùng Hư",      400),
    ("ffa500", "Hỗn Thiên",  "Phi Phong Hỗn Thiên Trấn Nguyên",   600),
    ("ffa500", "Sồ Phượng",  "Phi Phong Sồ Phượng Linh Vũ",       850),
    ("ffa500", "Tiềm Long",  "Phi Phong Tiềm Long Ngâm Uyên",    1150),
    ("ffff00", "Chí Tôn",    "Phi Phong Chí Tôn Truyền Thuyết",  1500),
    ("ffff00", "Vô Song",    "Phi Phong Vô Song Vương Giả",      1950),
    ("ffff00", "Đại Thánh",  "Phi Phong Huyền Tinh Đại Thánh",   2500),
    ("ffff00", "Siêu Thần",  "Siêu Thần Nhật Tuyệt Nhẫn",        3200),
    ("ffff00", "Trấn Thiên", "Phi Phong Trấn Thiên Vương",       4000),
    ("ffff00", "Phong Vân",  "Phi Phong Phong Vân Vương Giả",    5000),
    ("ffff00", "Thần Thoại", "Phi Phong Thần Thoại Vương Giả",   6200),
]
# Quan ấn (KVCT: Trí Sự ... Hoàng Đế): (mã màu, tên, công trạng cần)
QUAN_AN = [
    ("0078d7", "Trí Sự",     40),
    ("9370db", "Tư Mã",     120),
    ("ffa500", "Thái Thú",  250),
    ("ffa500", "Thiếu Khanh", 450),
    ("ffa500", "Thượng Khanh", 750),
    ("ffa500", "Quốc Công", 1200),
    ("ffff00", "Thừa Tướng", 2000),
    ("ffff00", "Hoàng Đế",  3500),
]
