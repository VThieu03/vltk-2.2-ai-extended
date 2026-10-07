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
# 9. CƯỜNG HÓA TRANG BỊ BẰNG NÚT "+" (thủy tinh)
# ---------------------------------------------------------
# Trong bảng nhân vật (phím C) bấm dấu "+" nhỏ cạnh ô trang bị để cường hóa +1, trừ thủy tinh đang có trong hành trang / Thủ Khố.
# Số thủy tinh cần cho một lần cường hóa từ bậc t lên t+1 là CẤP SỐ CỘNG: CUONGHOA_TT_BASE + CUONGHOA_TT_STEP * t
# (mặc định 1, 1: +0->+1 cần 1, +1->+2 cần 2 ... +9->+10 cần 10; tổng 55). Ví dụ BASE=2, STEP=3: cần 2, 5, 8, 11...
CUONGHOA_TT_BASE = 1
CUONGHOA_TT_STEP = 1

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
# 11. RƠI THỦY TINH (nguyên liệu cường hóa) THEO NHỊP THỜI GIAN
# ---------------------------------------------------------
# Quái bãi farm rơi thủy tinh theo "lịch": mỗi tướng được rơi dần để đúng mốc thời gian có bấy nhiêu món đồ đủ thủy tinh cường hóa +10.
# Một món +10 tốn 10*CUONGHOA_TT_BASE + 45*CUONGHOA_TT_STEP thủy tinh (mặc định 55). Số món (tích lũy) theo từng phút của trận:
TT_ITEMS_AT_20 = 2.5     # phút 20: ít nhất 2-3 món +10
TT_ITEMS_AT_30 = 5.5     # phút 30: 5-6 món
TT_ITEMS_AT_40 = 10.0    # phút 40: đủ 10 món (cả bộ)
# Hệ số dư (%), phòng thủy tinh bị nhặt sót hoặc bán / dùng việc khác; 110 = rơi nhiều hơn lịch 10%.
TT_MARGIN_PCT = 110
# Mỗi lần giết quái rơi bù 1/N phần còn thiếu so với lịch (N nhỏ = rơi gọn thành ít cục lớn, N lớn = rơi đều nhiều cục nhỏ).
TT_CATCHUP_KILLS = 6
# Tối đa số thủy tinh rơi trong một cục (một lần giết).
TT_MAX_PER_KILL = 15
# Tinh anh x1.5, thủ lĩnh x2, boss x3 số thủy tinh của một lần rơi (vẫn tính vào lịch, nên không làm lệch tổng).

# ---------------------------------------------------------
# 13. RƠI BẢO THẠCH (IG<loại><bậc>) THEO LỊCH PHÚT (tools/jass/gameplay_16_gemdrop.j)
# ---------------------------------------------------------
# Quái bãi farm rơi bảo thạch (loại 1..6 ngẫu nhiên, bậc 1..9) theo "lịch" từng người: mỗi bậc có mục tiêu số viên tích lũy theo phút,
# thiếu bao nhiêu thì mỗi lần giết rơi bù 1/GD_CATCHUP_KILLS phần thiếu (chọn bậc theo trọng số phần thiếu: bậc mới mở hiếm, bậc cũ dồi dào).
# Tinh anh x1.5, thủ lĩnh x2, boss x3 (vẫn tính vào lịch). Mục tiêu bậc t tại phút m = GD_TIER_START[t] + tốc độ * (m - mở bậc), 0 trước khi mở,
# tốc độ = (GD_TIER_N40[t] - GD_TIER_START[t]) / (40 - mở bậc); bậc 9 (N40 = None) tăng GD_T9_PER_MIN viên mỗi phút sau phút 40.
GD_ENABLED = 1
GD_TIER_UNLOCK = [0, 4, 8, 12, 16, 22, 28, 33, 40]     # phút mở bậc 1..9
# Bộ đồ chính có 10 ô, mỗi ô 2 lỗ khảm (zzVL_Kham: "lỗ x/2") = 20 viên. Đến phút 40 phải có ít nhất bấy nhiêu viên bậc 8.
GD_FILL_SLOTS = 20
GD_MARGIN_PCT = 110                                    # hệ số dư (%) cho bậc 8 (phòng nhặt sót / bán / đổi loại)
GD_TIER_N40 = [8, 8, 8, 8, 10, 12, 14, round(GD_FILL_SLOTS * GD_MARGIN_PCT / 100), None]   # số viên tích lũy từng bậc tại phút 40
GD_TIER_START = [1, 1, 1, 1, 1, 1, 1, 1, 1]            # số viên mục tiêu ngay khi mở bậc (cục đầu tiên)
GD_T9_PER_MIN = 0.5                                    # bậc 9: viên / phút sau phút 40
GD_CATCHUP_KILLS = 4                                   # mỗi lần giết rơi bù 1/N phần thiếu
GD_MAX_PER_KILL = 2                                    # tối đa viên một lần giết (quái thường / tinh anh / thủ lĩnh)
GD_MAX_PER_KILL_BOSS = 3                               # tối đa viên một lần giết boss
# Bảng tóm tắt (mô phỏng 200 ván, 4-12 lần giết / phút; số viên bậc 1..9 trung bình mỗi người):
#   phút 20: b1 ~4.7  b2 ~4.1  b3 ~3.7  b4 ~3.0  b5 ~2.5                                   (tổng ~17-19)
#   phút 30: b1 ~6.3  b2 ~6.0  b3 ~5.9  b4 ~5.6  b5 ~6.1  b6 ~5.7  b7 ~2.6                (tổng ~38-40)
#   phút 40: b1-b4 ~8 mỗi bậc  b5 ~10  b6 ~11.8  b7 ~13.5  b8 ~20-21 (đủ 20 ô khảm)  b9 ~1 (từ phút 40; 0.5 viên/phút sau đó)
# Chỉ 2 lần giết / phút thì bậc 8 chỉ ~13 viên tại phút 40 (trần 2 viên mỗi lần giết); từ 4 lần giết / phút trở lên đủ.

# ---------------------------------------------------------
# 12. BẢO THẠCH (tiệm tạp hóa - nâng bậc)
# ---------------------------------------------------------
# Bảo thạch có 6 loại x 9 bậc. Ở tiệm tạp hóa (đơn vị GEM_SHOP_UNIT) chọn tiệm, mua viên bảo thạch loại nào là nâng loại đó lên một bậc.
# Nâng bậc t lên t+1 tốn: N(t) = GEM_UP_BASE + GEM_UP_STEP * (t-1) viên bảo thạch CÙNG LOẠI, CÙNG BẬC t  +  GEM_UP_GOLD vàng (cố định). Bậc 9 là tối đa.
# Mặc định BASE 2, STEP 1:   bậc 1->2: 2 viên | 2->3: 3 | 3->4: 4 | 4->5: 5 | 5->6: 6 | 6->7: 7 | 7->8: 8 | 8->9: 9 viên.
# Ví dụ BASE 3, STEP 2:      3, 5, 7, 9, 11, 13, 15, 17 viên.
GEM_UP_BASE = 2
GEM_UP_STEP = 1
GEM_UP_GOLD = 500
# Mã đơn vị tiệm nâng bảo thạch (mặc định n00M = Tàng Bảo Các, đổi tên "Tiệm tạp hóa - Nâng bảo thạch"; không còn bán nguyên liệu).
GEM_SHOP_UNIT = "n00M"
