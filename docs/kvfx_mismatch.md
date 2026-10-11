# Danh sách chiêu bị trace đánh dấu lệch

Trace tự động hiện đánh dấu **119** mục lệch (từ `build/kvfx_trace.json`). Đây là danh sách cần đọc cùng dòng call site; nhãn có thể là khác vai trò, khác model, giới hạn biểu diễn hoặc false positive, không đồng nghĩa tất cả là lỗi game.

Đây là các mục cần rà thủ công, không mặc định mọi khác biệt của heuristic đều là lỗi thật. `KVCT` là phát hiện từ script gốc; `Cấu hình` là VFX đang khai báo.

## NDD - Ngũ Độc Đao

### U Hồn Phệ Ảnh (`A07N`, phím E, kind 5)
- KVCT: DeathCoilSpecialArt.mdl -> main (thấp; Jsj:92803); NDD_uhonpheanhtarget.mdl -> target (cao; JsA:92876); NDD_uhonpheanh.mdl -> main (cao; Jsg:92925); NDD_uhonpheanh3.mdl -> main (cao; Jsg:92934); NDD_uhonpheanh2.mdl -> cast (cao; Jsq:92991); NDD_uhoncast.mdl -> main (trung; Jsq:92992).
- Cấu hình: `{"main": "NDD_uhonpheanh.mdx", "cast": ["NDD_uhonpheanh2.mdx", "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl"], "target": "NDD_uhonpheanhtarget.mdx", "target_ground": true, "area": ["NDD_uhonpheanh3.mdx", "NDD_uhoncast.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["deathcoilspecialart: KVCT main / cấu hình cast", "ndd_uhoncast: KVCT main / cấu hình area", "ndd_uhonpheanh3: KVCT main / cấu hình area"]}

## TVD - Thiên Vương Đao

### Đoạn Hồn Thích (`A01M`, phím R, kind 3)
- KVCT: TVT_doanhonthich.mdx -> target (cao; eOp:48828).
- Cấu hình: `{"main": "TVT_doanhonthich.mdx", "target": "TVD_targeteffect1.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvd_targeteffect1"], "role_diff": ["tvt_doanhonthich: KVCT target / cấu hình main"]}

### Hào Hùng Trảm (`A03D`, phím E, kind 1)
- KVCT: TVD_targeteffect2.mdl -> target (cao; eAX:57831); TVD_tranphainewz2.mdl -> main (cao; eAM:57860); TVD_tranphaicast.mdl -> main (thấp; eAg:57911); TVD_targeteffect1.mdl -> main (thấp; eAg:57929); NMC_phongsuongtoaianh.mdl -> main (thấp; JdY:124174).
- Cấu hình: `{"main": "TVD_tranphainewz2.mdx", "cast": "TVD_tranphaicast.mdx", "target": ["TVD_targeteffect1.mdx", "TVD_targeteffect2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": [], "role_diff": ["tvd_targeteffect1: KVCT main / cấu hình target", "tvd_tranphaicast: KVCT main / cấu hình cast"]}

## VDK - Võ Đang Kiếm

### Tam Hoàn Sáo Nguyệt (`A0JX`, phím Q, kind 1)
- KVCT: VDK_tamhoanthaonguyet.mdl -> area (trung; eiU:71145).
- Cấu hình: `{"main": "VDK_tamhoanthaonguyet.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["vdk_tamhoanthaonguyet: KVCT area / cấu hình main"]}

### Lưu Tinh Cản Nguyệt (`A0KG`, phím R, kind 1)
- KVCT: VDK_nhankiemsword.mdl -> main (trung; eZE:67059); VDK_nhankiemcast.mdl -> area (trung; eZ0:67073); VDK_nhankiemcast.mdl -> cast (trung; eZK:67112); VDK_tamhoanthaonguyet.mdl -> area (trung; eiU:71145); VDK_vothuongkiem.mdl -> main (trung; J9X:77938); VDK_vothuongcastereffect.mdl -> main (trung; J9A:77972); VDK_vothuongcast.mdl -> main (trung; J9A:77975); VDK_nhankiemcast.mdl -> area (trung; Jx0:89390).
- Cấu hình: `{"main": "VDK_nhankiemcast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["vdk_nhankiemsword", "vdk_tamhoanthaonguyet", "vdk_vothuongcast", "vdk_vothuongcastereffect", "vdk_vothuongkiem"], "extra": [], "role_diff": ["vdk_nhankiemcast: KVCT area+cast / cấu hình main"]}

### Thất Tinh Quyết (`A0KA`, phím , kind 1) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; JdL:127101); VDK_thattinhaura.mdx -> aura (trung; JdL:127103).
- Cấu hình: `{"main": "VDK_thattinhaura.mdx", "aura": "VDK_thattinhaura.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": [], "role_diff": []}

### Nhân Kiếm Hợp Nhất (`A0JY`, phím W, kind 1)
- KVCT: VDK_nhankiemtarget.mdl -> target (cao; ebi:67021); AIlbSpecialArt.mdl -> target (cao; ebi:67024); VDK_nhankiemsword.mdl -> main (cao; eZE:67059); VDK_nhankiemcast.mdl -> area (trung; eZ0:67073); VDK_nhankiemcast.mdl -> cast (trung; eZK:67112).
- Cấu hình: `{"main": "VDK_nhankiemsword.mdx", "scale": 0.65, "cast": "VDK_nhankiemcast.mdx", "cast_ground": true, "target": "VDK_nhankiemtarget.mdx", "target_ground": true}`
- Chênh lệch: {"status": "lệch", "missing": ["ailbspecialart"], "extra": [], "role_diff": []}

### Thái Nhất Chân Khí (`A0KB`, phím , kind 6) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; JdL:127138).
- Cấu hình: `{"main": "VDK_thainhat.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["vdk_thainhat"], "role_diff": []}

### Vô Thượng Kiếm Đạo (`A0JZ`, phím E, kind 1)
- KVCT: VDK_vothuongtarget.mdl -> target (cao; J9j:77892); VDK_vocuckiemy.mdl -> target (cao; J9j:77895); VDK_vothuongkiem.mdl -> main (cao; J9X:77938); VDK_vothuongcastereffect.mdl -> main (trung; J9A:77972); VDK_vothuongcast.mdl -> main (trung; J9A:77975); NMC_phongsuongtoaianh.mdl -> main (thấp; JdL:127164).
- Cấu hình: `{"main": "VDK_vothuongkiem.mdx", "scale": 1.5, "cast": "VDK_vothuongcastereffect.mdx", "cast_ground": true, "target": "VDK_vothuongtarget.mdx", "target_ground": true, "area": ["VDK_vothuongcast.mdx", "VDK_vocuckiemy.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": [], "role_diff": ["vdk_vocuckiemy: KVCT target / cấu hình area", "vdk_vothuongcast: KVCT main / cấu hình area", "vdk_vothuongcastereffect: KVCT main / cấu hình cast"]}

## TYD - Thúy Yên Đao

### Tuyết Ảnh (`A0BO`, phím , kind 0) [bị động]
- KVCT: TYK_tuyetanh.mdl -> aura (trung; Jdu:125556).
- Cấu hình: `{"main": "TYD_daptuyetbuff.mdx", "aura": "TYK_tuyetanh.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tyd_daptuyetbuff"], "role_diff": []}

### Ngự Tuyết Ẩn (`A0CE`, phím R, kind 6)
- KVCT: TYK_effectcast.mdx -> cast (cao; ebl:66678).
- Cấu hình: `{"main": "TYK_effectcast.mdx", "buff": "TYD_daptuyetbuff.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tyd_daptuyetbuff"], "role_diff": ["tyk_effectcast: KVCT cast / cấu hình main"]}

### Băng Tung Vô Ảnh (`A0CG`, phím W, kind 2)
- KVCT: TYD_bangtunghoasen.mdl -> target (cao; J4i:83835); TYD_bangtungvoanh.mdl -> main (cao; JaE:83876); FrostArmorDamage.mdl -> cast (cao; Ja0:83916).
- Cấu hình: `{"main": "TYD_bangtunghoasen.mdx", "cast": "FrostArmorDamage.mdx", "area": ["TYD_bangtungvoanh.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tyd_bangtunghoasen: KVCT target / cấu hình main", "tyd_bangtungvoanh: KVCT main / cấu hình area"]}

### Băng Tước Việt Chi (`A0CL`, phím E, kind 5)
- KVCT: TYD_bangtuochoasen.mdl -> target (cao; Jaf:83986); TYD_bangtuocdao1.mdl -> main (cao; Jae:84022); TYD_bangtuocdao2.mdl -> main (cao; Jae:84024); TYD_bangtuocdao1.mdl -> main (cao; Ja4:84089); TYD_bangtuocdao2.mdl -> main (cao; Ja4:84091); FrostArmorDamage.mdl -> cast (cao; Ja4:84096).
- Cấu hình: `{"main": "TYD_bangtuocdao1.mdx", "cast": "FrostArmorDamage.mdx", "area": ["TYD_bangtuocdao2.mdx", "TYD_bangtuochoasen.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tyd_bangtuocdao2: KVCT main / cấu hình area", "tyd_bangtuochoasen: KVCT target / cấu hình area"]}

### Dạ Lai Tây Phong (`A0WZ`, phím F, kind 4)
- KVCT: TYK_huyenbang.mdx -> cast (trung; e_O:47348).
- Cấu hình: `{"main": "TYK_huyenbang.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tyk_huyenbang: KVCT cast / cấu hình main"]}

## DMPT - Đường Môn Phi Tiêu

### Tôi Độc Thuật (`A07W`, phím , kind 1) [bị động]
- KVCT: DMTT_toidocaura.mdl -> aura (trung; Jd8:124882).
- Cấu hình: `{"main": "DMPT_cankhonnhattrich3.mdx", "aura": "DMTT_toidocaura.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["dmpt_cankhonnhattrich3"], "role_diff": []}

### Mãn Thiên Hoa Vũ (`A08J`, phím R, kind 4)
- KVCT: DMPD_manthienhoavu*.mdl -> main (trung; e1P:65594); DemonHunterMissile.mdl -> target (cao; e1P:65603); DMPD_manthienhoavu*.mdl -> main (trung; e1z:65639).
- Cấu hình: `{"main": "DMPT_cankhontarget.mdx", "target": "Abilities\\Weapons\\DemonHunterMissile\\DemonHunterMissile.mdl"}`
- Chênh lệch: {"status": "lệch", "missing": ["dmpd_manthienhoavu*"], "extra": ["dmpt_cankhontarget"], "role_diff": []}

### Ảnh Tung Trận (`A08P`, phím D, kind 8)
- KVCT: DMPD_anhtungtran.mdl -> main (trung; eLs:44144); DMPD_anhtungtranaura.mdl -> main (trung; eLs:44146).
- Cấu hình: `{"main": "DMPD_anhtungtranaura.mdx", "area": ["DMPD_anhtungtran.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmpd_anhtungtran: KVCT main / cấu hình area"]}

### Truy Hồn Đoạt Mệnh (`A0YA`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jd8:125340).
- Cấu hình: `{"main": "DMPT_thiettoahg.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["dmpt_thiettoahg"], "role_diff": []}

### Thiết Tỏa Hoành Giang (`A0YB`, phím T, kind 1)
- KVCT: DMPT_thiettoahg.mdl -> cast (trung; JKg:74290); DMPT_thiettoataget.mdl -> target (cao; JKg:74297).
- Cấu hình: `{"cast": "DMPT_thiettoahg.mdx", "cast_ground": true, "target": "DMPT_thiettoataget.mdx", "target_ground": true, "buff": "DMPT_thiettoabuff.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["dmpt_thiettoabuff"], "role_diff": []}

## TLQ - Thiếu Lâm Quyền

### Long Trảo Hổ Trảo (`A04S`, phím Q, kind 1)
- KVCT: TLQ_longtraohotrao.mdl -> target (cao; etu:63620).
- Cấu hình: `{"main": "TLQ_longtraohotrao.mdx", "target": "TLQ_targeteffect.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tlq_targeteffect"], "role_diff": ["tlq_longtraohotrao: KVCT target / cấu hình main"]}

### Sư Tử Hống (`A04U`, phím R, kind 4)
- KVCT: HydraliskImpact.mdx -> target (cao; eiw:70933); TLQ_sutuhong.mdl -> main (trung; eiP:70966); HydraliskImpact.mdx -> target (cao; eiP:70980).
- Cấu hình: `{"main": "TLQ_sutuhong.mdx", "target": ["TLQ_targeteffect.mdx", "HydraliskImpact.mdx"], "buff": "TLQ_sutuhongbuff.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tlq_sutuhongbuff", "tlq_targeteffect"], "role_diff": []}

### Đại Lực Kim Cang Chưởng (`A055`, phím E, kind 5)
- KVCT: TLQ_targeteffect.mdl -> target (cao; e_7:47044); TLQ_votuongeffect.mdl -> target (cao; e_7:47050); TLQ_kimcangchuongeffect1.mdl -> main (cao; e_w:47095); TLQ_kimcuongchuongefffect3.mdl -> main (cao; e_w:47099); TLQ_lahanbuff.mdl -> main (thấp; e_z:47148).
- Cấu hình: `{"main": "TLQ_votuongeffect.mdx", "target": "TLQ_targeteffect.mdx", "target_ground": true, "area": ["TLQ_kimcangchuongeffect1.mdx", "TLQ_kimcuongchuongefffect3.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["tlq_lahanbuff"], "extra": [], "role_diff": ["tlq_kimcangchuongeffect1: KVCT main / cấu hình area", "tlq_kimcuongchuongefffect3: KVCT main / cấu hình area", "tlq_votuongeffect: KVCT target / cấu hình main"]}

## TND - Thiên Nhẫn Đao

### Đạn Chỉ Liệt Diệm (`A0F4`, phím Q, kind 1)
- KVCT: TND_danchifire.mdl -> main (trung; JD5:86483); FireBallMissile.mdl -> cast (cao; JDX:86494).
- Cấu hình: `{"main": "TND_danchifire.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["fireballmissile"], "extra": [], "role_diff": []}

### Hỏa Liên Phần Hoa (`A0FK`, phím D, kind 5)
- KVCT: AncientProtectorMissile.mdl -> area (trung; ePT:38073); TND_hoalieneffect.mdl -> area (trung; ege:58173); TND_hoalienhole.mdl -> main (trung; eg9:58215).
- Cấu hình: `{"main": "TND_hoalienhole.mdx", "area": ["TND_hoalieneffect.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["ancientprotectormissile"], "extra": [], "role_diff": []}

### Nhiếp Hồn Loạn Tâm (`A0FL`, phím F, kind 1)
- KVCT: TND_nhiephoneffect.mdl -> area (trung; eZm:67411); TND_nhiephontarget.mdx -> target (cao; eZm:67420).
- Cấu hình: `{"main": "TND_nhiephoneffect.mdx", "target": "TND_nhiephontarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tnd_nhiephoneffect: KVCT area / cấu hình main"]}

### Thiên Ngoại Lưu Tinh (`A0F5`, phím W, kind 1)
- KVCT: TND_thienngoaifire.mdl -> area (trung; J0j:73186); TND_thienngoaifire.mdl -> area (trung; J0j:73206); TND_thienngoaistone.mdl -> area (trung; J0X:73245); TND_thienngoailuutinhcaster.mdl -> cast (trung; J0M:73284); FireBallMissile.mdl -> cast (cao; J0M:73285).
- Cấu hình: `{"main": "TND_thienngoaistone.mdx", "scale": 0.1, "cast": "TND_thienngoailuutinhcaster.mdx", "cast_ground": true, "area": ["TND_thienngoaifire.mdx"], "hits": 1}`
- Chênh lệch: {"status": "lệch", "missing": ["fireballmissile"], "extra": [], "role_diff": ["tnd_thienngoaistone: KVCT area / cấu hình main"]}

### Ma Đao Thôn Thần (`A0FP`, phím T, kind 5)
- KVCT: RedDragonMissile.mdl -> target (cao; etC:63262); RedDragonMissile.mdl -> main (cao; ets:63297); TND_tathoatarget.mdl -> target (cao; e1a:65306); TND_madao.mdl -> main (cao; e1D:65344).
- Cấu hình: `{"main": "TND_madao.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["reddragonmissile", "tnd_tathoatarget"], "extra": [], "role_diff": []}

### Tật Hỏa Liêu Nguyên (`A0F6`, phím E, kind 1)
- KVCT: TND_tathoatarget.mdl -> area (trung; Jhl:95280); TND_tathoafire2.mdl -> main (trung; JhO:95308); TND_flamefire.mdl -> main (trung; JhO:95312); TND_tathoatarget.mdl -> target (cao; JhO:95322); TND_tathoacast.mdl -> cast (trung; JhU:95370); TND_tathoafire.mdl -> area (trung; JhU:95380); FireBallMissile.mdl -> cast (cao; JhU:95381); TND_bladerain.mdl -> area (trung; JhU:95382).
- Cấu hình: `{"main": "TND_tathoafire.mdx", "cast": "TND_tathoacast.mdx", "cast_ground": true, "target": "TND_tathoatarget.mdx", "area": ["TND_bladerain.mdx", "TND_tathoafire2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["fireballmissile", "tnd_flamefire"], "extra": [], "role_diff": ["tnd_tathoafire: KVCT area / cấu hình main", "tnd_tathoafire2: KVCT main / cấu hình area"]}

## CBC - Cái Bang Chưởng

### Hóa Hiểm Vi Di (`A0E8`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:125987).
- Cấu hình: `{"main": "MDX\\HoaHiemViDi.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["hoahiemvidi"], "role_diff": []}

### Long Du Thiên Địa (`A0E2`, phím E, kind 1)
- KVCT: CBC_casting.mdl -> area (trung; Jkt:89144); CBC_flame.mdl -> target (cao; JkN:89177); FireBallMissile.mdl -> target (cao; JkN:89178); CBC_dulong.mdl -> main (cao; Jk1:89214); CBC_casting.mdl -> cast (trung; Jk1:89220); FireBallMissile.mdl -> cast (cao; Jk1:89285); FireBallMissile.mdl -> cast (cao; Jk1:89286).
- Cấu hình: `{"main": "CBC_dulong.mdx", "cast": "CBC_casting.mdx", "cast_scale": 0.1, "cast_ground": true, "target": "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", "area": ["CBC_flame.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["cbc_flame: KVCT target / cấu hình area"]}

## CLK - Côn Lôn Kiếm

### Cuồng Lôi Chấn Địa (`A0HV`, phím Q, kind 1)
- KVCT: CLK_cuongloi.mdl -> area (trung; e_E:46592).
- Cấu hình: `{"main": "CLK_cuongloi.mdx", "area": ["CLK_thienloichannhac.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["clk_thienloichannhac"], "role_diff": ["clk_cuongloi: KVCT area / cấu hình main"]}

### Lôi Động Cửu Thiên (`A0IA`, phím E, kind 1)
- KVCT: CLK_loidongcuuthien.mdl -> area (trung; etz:63505); CLK_loidongcuuthien.mdl -> area (trung; etT:63518).
- Cấu hình: `{"main": "CLK_loidongcuuthien.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["clk_loidongcuuthien: KVCT area / cấu hình main"]}

### Thiên Lôi Chấn Nhạc (`A0IB`, phím R, kind 1)
- KVCT: CLK_thienloichannhac.mdl -> area (trung; J08:73049); CLK_set5.mdl -> target (cao; J08:73057); CLK_thienloichannhac.mdl -> area (trung; J0u:73095).
- Cấu hình: `{"main": "CLK_thienloichannhac.mdx", "target": "CLK_set5.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["clk_thienloichannhac: KVCT area / cấu hình main"]}

## TLD - Thiếu Lâm Đao

### Phục Ma Đao Pháp (`A03H`, phím Q, kind 1)
- KVCT: BansheeMissile.mdl -> target (cao; eQC:69372); TLD_phucmadp.mdx -> main (cao; eQs:69410).
- Cấu hình: `{"main": "TLD_phucmadp.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["bansheemissile"], "extra": [], "role_diff": []}

### Đại Thừa Như Lai Chú (`A040`, phím R, kind 1)
- KVCT: AncientProtectorMissile.mdl -> area (trung; ePT:38073); TLD_daithua.mdl -> area (trung; e_W:47183); TLD_votuongtram.mdl -> target (cao; e_W:47189).
- Cấu hình: `{"main": "TLD_daithua.mdx", "buff": "TLD_daithuabuff.mdx", "area": ["TLD_votuongtram.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["ancientprotectormissile"], "extra": ["tld_daithuabuff"], "role_diff": ["tld_daithua: KVCT area / cấu hình main", "tld_votuongtram: KVCT target / cấu hình area"]}

## TVT - Thiên Vương Thương

### Đoạn Hồn Thích (`A01M`, phím R, kind 3)
- KVCT: TVT_doanhonthich.mdx -> target (cao; eOp:48828).
- Cấu hình: `{"main": "TVT_doanhonthich.mdx", "buff": "TVT_buffdoanhonthich.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvt_buffdoanhonthich"], "role_diff": ["tvt_doanhonthich: KVCT target / cấu hình main"]}

### Truy Tinh Trục Nguyệt (`A020`, phím W, kind 2)
- KVCT: TVT_truytinhtarget.mdl -> main (thấp; Js8:92543); HydraliskImpact.mdx -> target (cao; Js8:92550); TVT_truytinheffect.mdx -> main (thấp; Jsu:92579).
- Cấu hình: `{"main": "TVT_truytinheffect.mdx", "target": "TVT_truytinhtarget.mdx", "area": ["HydraliskImpact.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["hydraliskimpact: KVCT target / cấu hình area", "tvt_truytinhtarget: KVCT main / cấu hình target"]}

### Bôn Lôi Toàn Long Thương (`A021`, phím F, kind 4)
- KVCT: TVT_bonloitarget.mdl -> target (cao; Ja5:85102).
- Cấu hình: `{"main": "TVT_bonloithuong.mdx", "target": "TVT_bonloitarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvt_bonloithuong"], "role_diff": []}

### Bá Vương Trạm Kim (`A01N`, phím E, kind 2)
- KVCT: TVT_bavuongtramkim_target.mdl -> target (cao; e6e:59103); TVT_bavuongeffect*.mdl -> main (cao; e69:59143); TVT_bavuongeffect*.mdl -> main (cao; JaF:84326); TVT_bavuongtramkim_target.mdl -> target (cao; Jam:84374); NMC_phongsuongtoaianh.mdl -> main (thấp; JdY:123971).
- Cấu hình: `{"main": "TVT_bavuongeffect1.mdx", "target": "TVT_bavuongtramkim_target.mdx", "area": ["TVT_bavuongeffect2.mdx", "TVT_bavuongeffect3.mdx", "TVT_bavuongeffect4.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": [], "role_diff": []}

## NDC - Ngũ Độc Chưởng

### Thiên Canh Địa Sát (`A06L`, phím R, kind 1)
- KVCT: CleaveDamageTarget.mdl -> area (trung; JCY:91223); NDC_thiencanhds.mdl -> area (trung; JCu:91246); SkeletalMageMissile.mdl -> cast (cao; JCd:91287); SkeletalMageMissile.mdl -> cast (cao; JCd:91288).
- Cấu hình: `{"main": "NDC_thiencanhds.mdx", "cast": "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "area": ["Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["ndc_thiencanhds: KVCT area / cấu hình main"]}

### Âm Phong Thực Cốt (`A06S`, phím W, kind 1)
- KVCT: KeeperGroveMissile.mdl -> target (cao; J4y:83041); NDC_amphong1.mdl -> main (trung; J4W:83080); NDC_amphong3.mdl -> main (trung; J4W:83081); NDC_amphong2.mdl -> main (trung; J4W:83082); NDC_amphongcast.mdl -> cast (cao; J4W:83085); SkeletalMageMissile.mdl -> cast (cao; J4W:83086); SkeletalMageMissile.mdl -> cast (cao; J4W:83087).
- Cấu hình: `{"main": "NDC_amphong1.mdx", "cast": "NDC_amphongcast.mdx", "target": "Abilities\\Weapons\\KeeperGroveMissile\\KeeperGroveMissile.mdl", "area": ["NDC_amphong3.mdx", "NDC_amphong2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["skeletalmagemissile"], "extra": [], "role_diff": ["ndc_amphong2: KVCT main / cấu hình area", "ndc_amphong3: KVCT main / cấu hình area"]}

### Hóa Cốt Miên Chưởng (`A06T`, phím D, kind 1)
- KVCT: NDC_hoacotbuff.mdl -> main (trung; JoE:86875); NDC_hoacotmienchuong2.mdl -> area (trung; JoE:86878).
- Cấu hình: `{"main": "NDC_hoacotmienchuong2.mdx", "buff": "NDC_hoacotbuff.mdx", "area": ["NDC_hoacotbuff.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["ndc_hoacotbuff: KVCT main / cấu hình area+buff", "ndc_hoacotmienchuong2: KVCT area / cấu hình main"]}

### U Minh Quỷ Trảo (`A071`, phím E, kind 1)
- KVCT: NDC_quytrao3.mdl -> main (cao; JFE:93145); GreenDragonMissile.mdl -> target (cao; JF0:93162); NDC_amphongcast.mdl -> cast (cao; JFK:93200); NDC_uminheffect.mdl -> area (trung; JFK:93201); NDC_quytrao2.mdl -> area (trung; JFK:93202); SkeletalMageMissile.mdl -> cast (cao; JF3:93247); SkeletalMageMissile.mdl -> cast (cao; JF3:93248); NDC_quytrao.mdl -> cast (cao; JF3:93249).
- Cấu hình: `{"main": "NDC_quytrao3.mdx", "cast": "NDC_amphongcast.mdx", "target": "NDC_uminhkholautarget.mdx", "area": ["NDC_uminheffect.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["greendragonmissile", "ndc_quytrao", "ndc_quytrao2", "skeletalmagemissile"], "extra": ["ndc_uminhkholautarget"], "role_diff": []}

## DMTT - Đường Môn Tụ Tiễn

### Thiên La Địa Võng (`A07R`, phím Q, kind 5)
- KVCT: DMTT_tanghondinh.mdl -> main (thấp; eOK:48550); HydraliskImpact.mdl -> target (cao; eOe:48590); DMTT_doancannhan.mdl -> main (cao; eO9:48626); SkeletalMageMissile.mdl -> target (cao; JCX:91428); SkeletalMageMissile.mdl -> main (cao; JCM:91461); SkeletalMageMissile.mdl -> target (cao; JCA:91494); SkeletalMageMissile.mdl -> main (cao; JCg:91547).
- Cấu hình: `{"main": "DMTT_doancannhan.mdx", "target": "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "area": ["DMTT_tanghondinh.mdx", "HydraliskImpact.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmtt_tanghondinh: KVCT main / cấu hình area", "hydraliskimpact: KVCT target / cấu hình area"]}

### Đoạn Cân Nhẫn (`A07X`, phím R, kind 6)
- KVCT: DMTT_tanghondinh.mdl -> main (thấp; eOK:48550); HydraliskImpact.mdl -> target (cao; eOe:48590); DMTT_doancannhan.mdl -> main (cao; eO9:48626).
- Cấu hình: `{"main": "DMTT_doancannhan.mdx", "cast": "DMTT_tanghondinh.mdx", "target": "Abilities\\Weapons\\HydraliskImpact\\HydraliskImpact.mdl"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmtt_tanghondinh: KVCT main / cấu hình cast"]}

### Bạo Vũ Lê Hoa (`A082`, phím W, kind 1)
- KVCT: DMTT_tanghondinh.mdl -> main (thấp; eOK:48550); HydraliskImpact.mdl -> target (cao; eOe:48590); DMTT_doancannhan.mdl -> main (cao; eO9:48626); HydraliskImpact.mdx -> target (cao; Jao:84168); DMTT_baovucham.mdl -> main (cao; Jak:84212); HydraliskImpact.mdx -> target (cao; Jax:84240); DMTT_baovu.mdl -> main (trung; JaC:84279).
- Cấu hình: `{"main": "DMTT_baovu.mdx", "target": "Abilities\\Weapons\\HydraliskImpact\\HydraliskImpact.mdl", "area": ["DMTT_baovucham.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["dmtt_doancannhan", "dmtt_tanghondinh"], "extra": [], "role_diff": ["dmtt_baovucham: KVCT main / cấu hình area"]}

### Xuyên Vân Tiễn (`A083`, phím D, kind 5)
- KVCT: IllidanMissile.mdl -> main (trung; JJV:78580); IllidanMissile.mdl -> target (cao; JJw:78651); IllidanMissile.mdl -> main (cao; JJP:78700).
- Cấu hình: `{"main": "Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", "target": ["Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", "DMTT_xuyenvantientarget.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["dmtt_xuyenvantientarget"], "role_diff": []}

### Khổng Tước Vũ (`A08B`, phím E, kind 1)
- KVCT: DMTT_tanghondinh.mdl -> main (thấp; eOK:48550); HydraliskImpact.mdl -> target (cao; eOe:48590); DMTT_doancannhan.mdl -> main (cao; eO9:48626); DMTT_truytinhtrucdien.mdl -> area (trung; Jkk:88242); DMTT_khongtuocvu1.mdl -> target (cao; JkF:88327); DMTT_khongtuocvu2.mdl -> main (cao; Jkh:88371); DMTT_khongtuocvu1.mdl -> target (cao; Jkc:88403); DMTT_khongtuocvu1.mdl -> main (cao; Jkm:88444); DMTT_khongtuocvu3.mdl -> cast (cao; Jkm:88445).
- Cấu hình: `{"main": "DMTT_khongtuocvu1.mdx", "cast": "DMTT_khongtuocvu3.mdx", "target": "DMTT_khongtuocvu1.mdx", "area": ["DMTT_khongtuocvu2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["dmtt_doancannhan", "dmtt_tanghondinh", "dmtt_truytinhtrucdien", "hydraliskimpact"], "extra": [], "role_diff": ["dmtt_khongtuocvu2: KVCT main / cấu hình area"]}

## NMC - Nga My Chưởng

### Tứ Tượng Đồng Quy (`A0AR`, phím Q, kind 5)
- KVCT: FrostArmorDamage.mdl -> target (cao; Jsn:92615); NMC_tutuongdq.mdl -> main (cao; JsL:92655); NMC_tutuongtarget.mdl -> area (trung; Jsl:92711).
- Cấu hình: `{"main": "NMC_tutuongdq.mdx", "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", "buff": "NMC_vantuongbuff.mdx", "area": ["NMC_tutuongtarget.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["nmc_vantuongbuff"], "role_diff": []}

### Phật Quang Chiến Khí (`A0AX`, phím R, kind 7)
- KVCT: TLHD_khaphuyet.mdl -> area (trung; e6O:59805).
- Cấu hình: `{"main": "TLHD_khaphuyet.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tlhd_khaphuyet: KVCT area / cấu hình main"]}

### Phong Sương Toái Ảnh (`A0B1`, phím W, kind 5)
- KVCT: NMC_diepdetanghoa.mdl -> area (trung; Jx1:90444); AvengerMissile.mdl -> target (cao; Jxb:90481); NMC_phongsuongtoaianh.mdl -> main (cao; JxZ:90526); NMC_phongsuongtarget.mdl -> cast (trung; JxH:90563).
- Cấu hình: `{"main": "NMC_diepdetanghoa.mdx", "target": "NMC_phongsuongtarget.mdx", "target_ground": true, "area": ["NMC_phongsuongtoaianh.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["avengermissile"], "extra": [], "role_diff": ["nmc_diepdetanghoa: KVCT area / cấu hình main", "nmc_phongsuongtarget: KVCT cast / cấu hình target", "nmc_phongsuongtoaianh: KVCT main / cấu hình area"]}

### Vạn Tướng Thần Công (`A0B7`, phím D, kind 6)
- KVCT: NMC_vantuongbuff.mdl -> main (thấp; J9c:77524).
- Cấu hình: `{"main": "NMC_vantuongbuff.mdx", "target": "NMC_tutuongtarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["nmc_tutuongtarget"], "role_diff": []}

## TNK - Thiên Nhẫn Kích

### Tàn Dương Như Huyết (`A0G0`, phím Q, kind 1)
- KVCT: Phoenix_Missile_mini.mdl -> target (cao; eiq:71278); Phoenix_Missile_mini.mdl -> buff (trung; eiS:71312); TNK_tanduongnhuhuyet.mdl -> target (trung; eiS:71313).
- Cấu hình: `{"main": "TNK_tanduongnhuhuyet.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["phoenix_missile_mini"], "extra": [], "role_diff": ["tnk_tanduongnhuhuyet: KVCT target / cấu hình main"]}

### Liệt Hỏa Tinh Thiên (`A0G5`, phím R, kind 1)
- KVCT: RedDragonMissile.mdl -> target (cao; etC:63262); RedDragonMissile.mdl -> main (cao; ets:63297); TND_tathoatarget.mdl -> target (cao; e1a:65306); TND_madao.mdl -> main (cao; e1D:65344).
- Cấu hình: `{"main": "MDX\\LietHoaTinhThien.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["reddragonmissile", "tnd_madao", "tnd_tathoatarget"], "extra": ["liethoatinhthien"], "role_diff": []}

### Ma Âm Phệ Phách (`A0G6`, phím D, kind 4)
- KVCT: TNK_maamtarget.mdl -> target (cao; eNQ:65111).
- Cấu hình: `{"main": "TNK_maamtarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tnk_maamtarget: KVCT target / cấu hình main"]}

### Vân Long Kích (`A0G1`, phím W, kind 1)
- KVCT: TNK_vanlongtarget.mdl -> target (cao; J9s:77414); TNK_vanlongkich.mdl -> main (cao; J9F:77454); TNK_vanlongcast.mdl -> main (trung; J9F:77458).
- Cấu hình: `{"main": "TNK_vanlongkich.mdx", "cast": "TNK_vanlongcast.mdx", "cast_ground": true, "target": "TNK_vanlongtarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tnk_vanlongcast: KVCT main / cấu hình cast"]}

### Phi Hồng Vô Tích (`A0G8`, phím F, kind 3)
- KVCT: LargeBuildingFire1.mdl -> area (trung; eHx:68269); FireBallMissile.mdl -> target (cao; eHx:68285); TNK_phihongcast.mdl -> main (trung; eHC:68324); TNK_phihongcast.mdl -> buff (trung; eHC:68326).
- Cấu hình: `{"main": "TNK_phihongcast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["fireballmissile", "largebuildingfire1"], "extra": [], "role_diff": []}

### Vân Long Tam Hiện (`A0G9`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126344).
- Cấu hình: `{"main": "MDX\\VanLong.mdx", "cast": "TNK_vanlongcast.mdx", "target": "TNK_vanlongtarget.mdx", "area": ["TNK_vanlongkich.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["tnk_vanlongcast", "tnk_vanlongkich", "tnk_vanlongtarget", "vanlong"], "role_diff": []}

### Giang Hải Nộ Lan (`A0G2`, phím E, kind 5)
- KVCT: TNK_gianghaitarget.mdl -> target (cao; eAc:57369); TNK_gianghai1.mdl -> main (cao; eAm:57400); TNK_gianghai2.mdl -> main (cao; eAm:57402); TNK_vanlongcast.mdl -> main (trung; eAp:57432).
- Cấu hình: `{"main": "TNK_gianghai1.mdx", "cast": "TNK_vanlongcast.mdx", "cast_ground": true, "target": "TNK_gianghaitarget.mdx", "target_ground": true, "area": ["TNK_gianghai2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tnk_gianghai2: KVCT main / cấu hình area", "tnk_vanlongcast: KVCT main / cấu hình cast"]}

## VDQ - Võ Đang Khí

### Bác Cập Nhị Phục (`A0J9`, phím Q, kind 1)
- KVCT: VDQ_baccapnhiphuc.mdl -> area (trung; J4l:83281); SpiritOfVengeanceMissile.mdl -> cast (cao; J4l:83282).
- Cấu hình: `{"main": "VDQ_baccapnhiphuc.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["spiritofvengeancemissile"], "extra": [], "role_diff": ["vdq_baccapnhiphuc: KVCT area / cấu hình main"]}

### Thiên Địa Vô Cực (`A0JA`, phím W, kind 4)
- KVCT: VDQ_thiendia.mdl -> area (trung; JCO:91326); VDQ_thiendiatarget.mdl -> target (cao; JCO:91335); VDQ_thaicuc.mdl -> main (trung; JCU:91364); VDQ_thiendiacaster.mdl -> main (trung; JCU:91365); SpiritOfVengeanceMissile.mdl -> cast (cao; JCU:91366).
- Cấu hình: `{"main": "VDQ_thaicuc.mdx", "scale": 1.5, "target": "VDQ_thiendiatarget.mdx", "target_ground": true, "area": ["VDQ_thiendia.mdx", "VDQ_thiendiacaster.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["spiritofvengeancemissile"], "extra": [], "role_diff": ["vdq_thiendiacaster: KVCT main / cấu hình area"]}

### Vạn Kiếm Quy Tông (`A0JS`, phím R, kind 1)
- KVCT: VDQ_vongakiem.mdl -> target (cao; J9D:77341); VDQ_thiendiatarget.mdl -> target (cao; J9D:77342).
- Cấu hình: `{"main": "VDQ_vongakiem.mdx", "target": "VDQ_thiendiatarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["vdq_vongakiem: KVCT target / cấu hình main"]}

### Cửu Cung Bát Quái (`A0JB`, phím E, kind 4)
- KVCT: VDQ_vongakiem.mdl -> area (trung; JDm:85812); VDQ_thiendiacaster.mdl -> target (cao; JDm:85822); VDQ_cuucung1.mdl -> main (trung; JDG:85875); VDQ_cuucung1.mdl -> main (trung; JDG:85879); VDQ_cuucung2.mdl -> main (trung; JDG:85883); VDQ_thaicuc.mdl -> main (trung; JDG:85886); SpiritOfVengeanceMissile.mdl -> cast (cao; JDp:85922).
- Cấu hình: `{"main": "VDQ_cuucung1.mdx", "target": "VDQ_thiendiacaster.mdx", "target_ground": true, "area": ["VDQ_cuucung2.mdx", "VDQ_thaicuc.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["spiritofvengeancemissile", "vdq_vongakiem"], "extra": [], "role_diff": ["vdq_cuucung2: KVCT main / cấu hình area", "vdq_thaicuc: KVCT main / cấu hình area"]}

## CLD - Côn Lôn Đao

### Ngạo Tuyết Tiếu Phong (`A0IL`, phím W, kind 1)
- KVCT: CLD_hoiphongtarget2.mdl -> target (cao; eg2:58398); CLD_hoiphongphatlieu.mdl -> main (trung; egV:58433); CLD_ngaotuyettarget.mdl -> target (cao; Jxh:89767); CLD_ngaotuyet.mdl -> main (cao; Jxc:89805); CLD_ngaotuyetcast.mdl -> main (trung; Jxc:89809).
- Cấu hình: `{"main": "CLD_ngaotuyet.mdx", "cast": "CLD_ngaotuyetcast.mdx", "cast_ground": true, "target": "CLD_ngaotuyettarget.mdx", "area": ["CLD_hoiphongphatlieu.mdx", "CLD_hoiphongtarget2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["cld_hoiphongphatlieu: KVCT main / cấu hình area", "cld_hoiphongtarget2: KVCT target / cấu hình area", "cld_ngaotuyetcast: KVCT main / cấu hình cast"]}

### Cửu Thiên Canh Phong (`A0IM`, phím E, kind 1)
- KVCT: CLD_hoiphongtarget2.mdl -> target (cao; eg2:58398); CLD_hoiphongphatlieu.mdl -> main (trung; egV:58433); CLD_canhphong2.mdl -> main (trung; JDT:86110); CLD_canhphong.mdl -> main (cao; JDW:86180); CLD_ngaotuyetcast.mdl -> main (trung; JDW:86184).
- Cấu hình: `{"main": "CLD_canhphong2.mdx", "cast": "CLD_ngaotuyetcast.mdx", "cast_ground": true, "target": "CLD_hoiphongtarget2.mdx", "area": ["CLD_canhphong.mdx", "CLD_hoiphongphatlieu.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["cld_canhphong: KVCT main / cấu hình area", "cld_hoiphongphatlieu: KVCT main / cấu hình area", "cld_ngaotuyetcast: KVCT main / cấu hình cast"]}

## TLB - Thiếu Lâm Bổng

### A La Hán Thần Công (`A03K`, phím , kind 5) [bị động]
- KVCT: TLD_lahantran.mdl -> aura (trung; JdY:124226).
- Cấu hình: `{"main": "TLB_targeteffect.mdx", "aura": "TLD_lahantran.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tlb_targeteffect"], "role_diff": []}

### Vi Đà Hiến Chử (`A04O`, phím E, kind 4)
- KVCT: TLB_vidatarget.mdl -> area (trung; J9v:77571); TLB_vidaeffect.mdl -> area (trung; J9w:77621); TLB_vidaeffect.mdl -> target (cao; J9w:77633); TLB_vidatarget.mdl -> target (cao; J9w:77635); TLB_vidatarget.mdl -> cast (trung; J9P:77663); TLB_vidacast.mdl -> main (thấp; J9P:77664).
- Cấu hình: `{"main": "TLB_vidaeffect.mdx", "cast": "TLB_vidacast.mdx", "target": "TLB_vidatarget.mdx", "target_ground": true, "area": ["TLB_vidatarget.mdx", "TLB_vidaeffect.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tlb_vidacast: KVCT main / cấu hình cast"]}

## DTK - Đoàn Thị Khí

### Bắc Minh Thần Công (`A0CQ`, phím , kind 1) [bị động]
- KVCT: DTK_bacminhaura.mdl -> aura (trung; Jdu:125785).
- Cấu hình: `{"main": "MDX\\BacMinhThanCong.mdx", "aura": "DTK_bacminhaura.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["bacminhthancong"], "role_diff": []}

### Lục Mạch Thần Kiếm (`A0D6`, phím W, kind 5)
- KVCT: DTK_lucmachtarget42.mdl -> target (cao; eNh:64408); DTK_lucmachthankiem*.mdl -> main (cao; eNc:64450); DTK_lucmachcaster.mdl -> main (trung; eNG:64506).
- Cấu hình: `{"main": "DTK_lucmachcaster.mdx", "cast": "DTK_lucmachcaster.mdx", "target": "DTK_lucmachtarget42.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["dtk_lucmachthankiem*"], "extra": [], "role_diff": []}

### Khí Thôn Vạn Lý (`A0D7`, phím E, kind 5)
- KVCT: DTK_lucmachtarget42.mdl -> target (cao; eNh:64408); DTK_lucmachthankiem*.mdl -> main (cao; eNc:64450); DTK_lucmachcaster.mdl -> main (trung; eNG:64506); DTK_khithoneffect.mdl -> target (cao; JkJ:88119); DTK_khithonvanly.mdl -> main (cao; Jk4:88154).
- Cấu hình: `{"main": "DTK_khithonvanly.mdx", "target": "DTK_khithoneffect.mdx", "target_ground": true}`
- Chênh lệch: {"status": "lệch", "missing": ["dtk_lucmachcaster", "dtk_lucmachtarget42", "dtk_lucmachthankiem*"], "extra": [], "role_diff": []}

## TVC - Thiên Vương Chùy

### Hành Vân Quyết (`A02C`, phím Q, kind 1)
- KVCT: MakuraMissile.mdl -> target (cao; eAY:57619); TVC_Hanhvan.mdl -> main (thấp; eA8:57657).
- Cấu hình: `{"main": "TVC_Hanhvan.mdx", "target": ["TVC_thualongquyettarget.mdx", "MakuraMissile.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvc_thualongquyettarget"], "role_diff": []}

### Đoạn Hồn Thích (`A01M`, phím R, kind 3)
- KVCT: TVT_doanhonthich.mdx -> target (cao; eOp:48828).
- Cấu hình: `{"main": "TVT_doanhonthich.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tvt_doanhonthich: KVCT target / cấu hình main"]}

### Kim Chung Tráo (`A02K`, phím F, kind 7)
- KVCT: TVC_kimchungtrao.mdx -> main (thấp; eSF:61412).
- Cấu hình: `{"main": "TVC_kimchungtrao.mdx", "cast": "TVC_kimchungcast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvc_kimchungcast"], "role_diff": []}

### Trảm Long Quyết (`A02P`, phím D, kind 3)
- KVCT: AncientProtectorMissile.mdl -> area (trung; ePT:38073); TVC_tramlongeffect1.mdl -> area (trung; eLK:43922); TVC_thualongquyettarget.mdl -> target (cao; eLK:43929); TVC_tramlongeffect2.mdl -> area (trung; eLf:43974); TVC_thualongquyettarget.mdl -> target (cao; eLf:43981); TVC_tramlongeffect2.mdl -> cast (cao; eLe:44016).
- Cấu hình: `{"main": "TVC_tramlongeffect2.mdx", "target": "TVC_thualongquyettarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["ancientprotectormissile", "tvc_tramlongeffect1"], "extra": [], "role_diff": ["tvc_tramlongeffect2: KVCT area+cast / cấu hình main"]}

### Hóa Kinh Quyết (`A02U`, phím , kind 1) [bị động]
- KVCT: TVC_hoakinhquyet.mdl -> aura (trung; JdY:124062).
- Cấu hình: `{"main": "TVC_hoakinhquyet.mdx", "target": "TVC_thualongquyettarget.mdx", "aura": "TVC_hoakinhquyet.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tvc_thualongquyettarget"], "role_diff": []}

## DMPD - Đường Môn Phi Đao

### Tôi Độc Thuật (`A07W`, phím , kind 1) [bị động]
- KVCT: DMTT_toidocaura.mdl -> aura (trung; Jd8:124882).
- Cấu hình: `{"main": "DMPD_manthienhoavu3.mdx", "aura": "DMTT_toidocaura.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["dmpd_manthienhoavu3"], "role_diff": []}

### Nhiếp Hồn Nguyệt Ảnh (`A08K`, phím W, kind 5)
- KVCT: DMPD_nhiephonwave1_1.mdl -> main (cao; Jx5:90172); DMPD_nhiephonwave2_1.mdl -> main (trung; JxX:90200); DMPD_nhiephontarget.mdl -> area (trung; JxA:90289); DMPD_nhiephontarget.mdl -> area (trung; JxA:90290); DMPD_nhiephontarget.mdl -> area (trung; JxA:90291).
- Cấu hình: `{"main": "DMPD_nhiephonwave1_1.mdx", "area": ["DMPD_nhiephonwave2_1.mdx", "DMPD_nhiephontarget.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmpd_nhiephonwave2_1: KVCT main / cấu hình area"]}

### Ảnh Tung Trận (`A08P`, phím D, kind 8)
- KVCT: DMPD_anhtungtran.mdl -> main (trung; eLs:44144); DMPD_anhtungtranaura.mdl -> main (trung; eLs:44146).
- Cấu hình: `{"main": "DMPD_anhtungtranaura.mdx", "area": ["DMPD_anhtungtran.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmpd_anhtungtran: KVCT main / cấu hình area"]}

### Vô Ảnh Xuyên (`A08S`, phím E, kind 5)
- KVCT: CritterBloodAlbatross.mdl -> target (cao; JFh:93497); DMPD_voanhxuyen_2.mdl -> main (trung; JFc:93530); GreenDragonMissile.mdl -> target (cao; JFm:93555); DMPD_voanhxuyen.mdl -> cast (cao; JFp:93612); DMPD_voanhxuyen_11.mdl -> main (cao; JFp:93613).
- Cấu hình: `{"main": "DMPD_voanhxuyen_11.mdx", "cast": "DMPD_voanhxuyen.mdx", "target": ["Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", "Abilities\\Weapons\\GreenDragonMissile\\GreenDragonMissile.mdl"], "area": ["DMPD_voanhxuyen_2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dmpd_voanhxuyen_2: KVCT main / cấu hình area"]}

## CBB - Cái Bang Bổng

### Tiêu Dao Công (`A0ET`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126087).
- Cấu hình: `{"main": "CBB_bongtarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["cbb_bongtarget"], "role_diff": []}

### Túy Điệp Cuồng Vũ (`A0E9`, phím , kind 1) [bị động]
- KVCT: CBC_hoatbatluuthu.mdl -> aura (trung; Jdn:126008).
- Cấu hình: `{"main": "CBB_firetarget.mdx", "aura": "CBC_hoatbatluuthu.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["cbb_firetarget"], "role_diff": []}

### Đả Cẩu Bổng Pháp (`A0EU`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126133).
- Cấu hình: `{"main": "CBB_dacautran.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["cbb_dacautran"], "role_diff": []}

### Bổng Quỷnh Lược Địa (`A0EM`, phím E, kind 1)
- KVCT: CBB_dacautran.mdl -> main (trung; Jan:84875); CBB_minhsatthuhao.mdl -> main (trung; Jan:84881); CBB_tranphai2.mdl -> target (cao; Jal:84980); CBB_bong.mdl -> main (cao; JaB:85030); CBB_bongquynheffect.mdl -> main (cao; JaB:85035); CBB_thienhavocaucaster.mdl -> cast (cao; JaU:85073).
- Cấu hình: `{"main": "CBB_bong.mdx", "cast": "CBB_thienhavocaucaster.mdx", "area": ["CBB_bongquynheffect.mdx", "CBB_tranphai2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["cbb_dacautran", "cbb_minhsatthuhao"], "extra": [], "role_diff": ["cbb_bongquynheffect: KVCT main / cấu hình area", "cbb_tranphai2: KVCT target / cấu hình area"]}

## NMK - Nga My Kiếm

### Từ Hàng Phổ Độ (`A0A6`, phím R, kind 7)
- KVCT: NMK_effect8.mdl -> area (trung; JfX:76123); NMK_tuhang.mdx -> cast (trung; Jf6:76205); NMK_tuhang2.mdl -> cast (trung; Jf6:76206).
- Cấu hình: `{"main": "NMK_tuhang.mdx", "cast": "NMK_tuhang.mdx", "area": ["NMK_tuhang2.mdx", "NMK_effect8.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["nmk_tuhang2: KVCT cast / cấu hình area"]}

### Băng Sương Điện Phóng (`A0AO`, phím E, kind 5)
- KVCT: NMK_bangsuongeffect.mdl -> area (trung; edf:44965); NMK_bangsuongtarget.mdl -> target (cao; edf:44982); NMK_bangsuongkiem.mdl -> main (cao; ede:45026).
- Cấu hình: `{"main": "NMK_bangsuongkiem.mdx", "target": "NMK_bangsuongtarget.mdx", "buff": "NMK_thienphatbuff.mdx", "area": ["NMK_bangsuongeffect.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["nmk_thienphatbuff"], "role_diff": []}

## MGC - Minh Giáo Chùy

### Khai Thiên Thức (`A09M`, phím Q, kind 1)
- KVCT: MGC_khaithienthuc.mdl -> area (trung; e6n:59614); MGC_khaithienthuc.mdl -> target (cao; e6n:59621).
- Cấu hình: `{"main": "MGC_khaithienthuc.mdx", "cast": "MGC_buffcast.mdx", "target": "MGC_khaithienthuc.mdx", "area": ["MGC_khaithienthuc.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["mgc_buffcast"], "role_diff": []}

### Khốn Hổ Vân Tiếu (`A09O`, phím R, kind 3)
- KVCT: MGC_khonhovantieueffect.mdl -> area (trung; e6Z:60047); MGC_phachdiatarget.mdl -> area (trung; e6Z:60071); MGC_khaithienthuc.mdl -> target (cao; e6Z:60077).
- Cấu hình: `{"main": "MGC_khonhovantieueffect.mdx", "cast": "MGC_buffcast.mdx", "target": "MGC_khaithienthuc.mdx", "area": ["MGC_khonhovantieueffect.mdx", "MGC_phachdiatarget.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["mgc_buffcast"], "role_diff": []}

### Phách Địa Thế (`A09Q`, phím D, kind 5)
- KVCT: MGC_dongdat.mdl -> area (trung; eZL:67652); ChimaeraAcidMissile.mdl -> target (cao; eZU:67709); MGC_phachdia.mdl -> main (cao; eZ5:67754).
- Cấu hình: `{"main": "MGC_phachdia.mdx", "cast": "MGC_buffcast.mdx", "target": "MGC_phachdiatarget.mdx", "area": ["MGC_dongdat.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["chimaeraacidmissile"], "extra": ["mgc_buffcast", "mgc_phachdiatarget"], "role_diff": []}

### Long Thôn Thức (`A09S`, phím W, kind 1)
- KVCT: DeathCoilMissile.mdl -> main (cao; etB:63705); MGC_longthontarget.mdl -> target (cao; etO:63723).
- Cấu hình: `{"main": "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", "cast": "MGC_buffcast.mdx", "target": "MGC_longthontarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["mgc_buffcast"], "role_diff": []}

### Khu Hổ Thức (`A09Z`, phím E, kind 2)
- KVCT: MGC_khuhothuctarget.mdl -> target (cao; eqo:60283); MGC_khuhothuc.mdl -> main (cao; eqk:60314); MGC_khuhothuc.mdl -> main (cao; eqF:60371); MGC_khuhothuctarget.mdl -> target (cao; eqh:60398); MGC_khuhothuctarget.mdl -> cast (cao; eqc:60436).
- Cấu hình: `{"main": "MGC_khuhothuc.mdx", "cast": "MGC_buffcast.mdx", "target": "MGC_khuhothuctarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["mgc_buffcast"], "role_diff": []}

## MGK - Minh Giáo Kiếm

### Thánh Hỏa Lệnh Pháp (`A095`, phím F, kind 1)
- KVCT: NMC_phongsuongtoaianh.mdl -> main (thấp; Jd8:125108).
- Cấu hình: `{"main": "MGK_thanhhoalenhbuff.mdx", "cast": "MGK_thanhhoacast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["mgk_thanhhoacast", "mgk_thanhhoalenhbuff"], "role_diff": []}

## DTC - Đoàn Thị Chỉ

### Thần Chỉ Điểm Huyệt (`A0DB`, phím Q, kind 1)
- KVCT: FrostArmorDamage.mdl -> target (cao; JCx:90905); FrostArmorDamage.mdl -> cast (cao; JCC:90946); FrostArmorDamage.mdl -> cast (cao; JCC:90947).
- Cấu hình: `{"main": "MDX\\ThanChi.mdx", "cast": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["thanchi"], "role_diff": []}

### Cản Dương Thần Chỉ (`A0DC`, phím W, kind 1)
- KVCT: DTC_Img.mdx -> main (trung; Jar:85244); DTC_canduongeffect1.mdl -> area (trung; Jat:85257); DTC_canduongeffect1.mdl -> area (trung; Jat:85258); FrostArmorDamage.mdl -> target (cao; Jat:85268); DTC_canduongchi.mdl -> target (cao; Jat:85269); DTC_canduongeffect1.mdl -> cast (cao; JaN:85316); DTC_canduongeffect1.mdl -> cast (cao; JaN:85317).
- Cấu hình: `{"main": "DTC_Img.mdx", "cast": "DTC_canduongeffect1.mdx", "target": "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", "area": ["DTC_canduongchi.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dtc_canduongchi: KVCT target / cấu hình area"]}

### Thiên Long Thần Chỉ (`A0DD`, phím E, kind 1)
- KVCT: DTC_Img.mdx -> main (trung; JCr:91612); DTC_canduongeffect1.mdl -> area (trung; JCt:91625); DTC_canduongeffect1.mdl -> area (trung; JCt:91626); DTC_tranphai22.mdl -> target (cao; JCt:91635); DTC_thienlongchi1.mdl -> main (trung; JCN:91669); DTC_canduongeffect1.mdl -> cast (cao; JCN:91700); DTC_canduongeffect1.mdl -> cast (cao; JCN:91701).
- Cấu hình: `{"main": "DTC_thienlongchi1.mdx", "cast": "DTC_canduongeffect1.mdx", "area": ["DTC_Img.mdx", "DTC_tranphai22.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["dtc_img: KVCT main / cấu hình area", "dtc_tranphai22: KVCT target / cấu hình area"]}

## CMC - Cổ Mộ Châm

### Ngọc Phong Châm (`A0MA`, phím D, kind 5)
- KVCT: CMC_lyhan.mdl -> main (trung; eQK:69120); CMC_ngocphongtarget.mdl -> target (cao; JxT:89968); CMC_ngocphongcham.mdl -> main (cao; Jxy:90008).
- Cấu hình: `{"main": "CMC_ngocphongcham.mdx", "target": "CMC_ngocphongtarget.mdx", "buff": "CMC_ngocphongbuff.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["cmc_lyhan"], "extra": ["cmc_ngocphongbuff"], "role_diff": []}

### Bi Sầu (`A0LU`, phím E, kind 1)
- KVCT: CMC_chamtarget.mdl -> target (cao; eQ0:69087); CMC_lyhan.mdl -> main (cao; eQK:69120); CMC_chamtarget.mdl -> target (cao; JaP:84624); CMC_bisau.mdl -> main (cao; Jaz:84661); CMC_cham5_5.mdl -> cast (cao; Jay:84731); CMC_bisau.mdl -> cast (cao; Jay:84732); CMC_bisau.mdl -> cast (cao; Jay:84733).
- Cấu hình: `{"main": "CMC_bisau.mdx", "cast": ["CMC_cham5_5.mdx", "CMC_bisau.mdx"], "target": "CMC_chamtarget.mdx", "target_ground": true}`
- Chênh lệch: {"status": "lệch", "missing": ["cmc_lyhan"], "extra": [], "role_diff": []}

## CMK - Cổ Mộ Kiếm

### Thu Nhạn Bàng Hoàng (`A0ML`, phím Q, kind 1)
- KVCT: CMK_chungnam.mdl -> main (cao; JD3:85511); CMK_target1.mdl -> target (cao; JD9:85565); CMK_chungnam.mdl -> main (cao; JDJ:85610); SpiritOfVengeanceMissile.mdl -> target (cao; Jh5:95430); CMK_thunhan.mdl -> main (cao; Jhj:95465); SpiritOfVengeanceMissile.mdl -> target (cao; JhX:95485); CMK_thunhan.mdl -> main (cao; JhM:95519); SpiritOfVengeanceMissile.mdl -> cast (cao; JhM:95523).
- Cấu hình: `{"main": "CMK_thunhan.mdx", "cast": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "target": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "area": ["CMK_chungnam.mdx", "CMK_target1.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["cmk_chungnam: KVCT main / cấu hình area", "cmk_target1: KVCT target / cấu hình area"]}

### Hồng Tụ Triền (`A0MZ`, phím R, kind 1)
- KVCT: CMK_hongtutrien.mdl -> main (trung; egP:58514).
- Cấu hình: `{"main": "CMK_hongtutrien.mdx", "target": "CMK_target.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["cmk_target"], "role_diff": []}

### Cô Nguyệt Bồi Hồi (`A0MM`, phím W, kind 1)
- KVCT: CMK_chungnam.mdl -> main (cao; JD3:85511); CMK_target1.mdl -> target (cao; JD9:85565); CMK_chungnam.mdl -> main (cao; JDJ:85610); CMK_target2.mdl -> target (cao; JFt:94182); CMK_conguyet.mdl -> main (cao; JFN:94215); CMK_conguyet2.mdl -> main (cao; JFN:94224); CMK_target2.mdl -> target (cao; JF1:94245); CMK_conguyet.mdl -> main (cao; JFb:94281); CMK_conguyet2.mdl -> main (cao; JFb:94287); SpiritOfVengeanceMissile.mdl -> cast (cao; JFb:94292).
- Cấu hình: `{"main": "CMK_conguyet.mdx", "cast": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "target": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "area": ["CMK_conguyet2.mdx", "CMK_target2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["cmk_chungnam", "cmk_target1"], "extra": [], "role_diff": ["cmk_conguyet2: KVCT main / cấu hình area", "cmk_target2: KVCT target / cấu hình area"]}

### Cô Thân Chi Ảnh (`A0MN`, phím E, kind 1)
- KVCT: CMK_chungnam.mdl -> main (cao; JD3:85511); CMK_target1.mdl -> target (cao; JD9:85565); CMK_chungnam.mdl -> main (cao; JDJ:85610); CMK_phamonghanh3.mdl -> area (trung; JhE:94354); CMK_target3.mdl -> target (cao; Jh0:94377); CMK_cothanca.mdl -> main (cao; JhK:94410); CMK_castercothan.mdl -> main (cao; JhK:94417); CMK_target3.mdl -> target (cao; Jh3:94445); CMK_cothanca.mdl -> main (cao; Jhf:94484); CMK_castercothan.mdl -> main (cao; Jhf:94488); CMK_castercothan.mdl -> buff (trung; Jhf:94492).
- Cấu hình: `{"main": "CMK_cothanca.mdx", "cast": "CMK_castercothan.mdx", "target": "CMK_target3.mdx", "buff": "CMK_castercothan.mdx", "area": ["CMK_phamonghanh3.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["cmk_chungnam", "cmk_target1"], "extra": [], "role_diff": []}

## HSQ - Hoa Sơn Khí

### Thanh Vân Tống Sảng (`A0KJ`, phím Q, kind 1)
- KVCT: SpiritOfVengeanceMissile.mdl -> target (cao; JEX:72170); HSQ_thanhvan.mdl -> area (trung; JEM:72197); SpiritOfVengeanceMissile.mdl -> cast (cao; JEM:72198).
- Cấu hình: `{"main": "HSQ_thanhvan.mdx", "cast": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "target": "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["hsq_thanhvan: KVCT area / cấu hình main"]}

### Phách Thạch Phá Ngọc (`A0KL`, phím E, kind 5)
- KVCT: HSQ_mavankk2.mdl -> area (trung; eZ6:67823); HSQ_caster.mdl -> area (trung; eZ6:67824); HSQ_mavankk2.mdl -> area (trung; eZq:67862); HSQ_caster.mdl -> area (trung; eZq:67863); HSQ_phangoc2.mdl -> area (trung; eZt:67896); VoidWalkerMissile.mdl -> target (cao; eZt:67902); HSQ_caster.mdl -> cast (trung; eZN:67939); HSQ_phachthach.mdl -> main (thấp; eZN:67940); SpiritOfVengeanceMissile.mdl -> cast (cao; eZN:67941).
- Cấu hình: `{"main": "HSQ_phachthach.mdx", "cast": "HSQ_caster.mdx", "cast_ground": true, "target": "Abilities\\Weapons\\VoidWalkerMissile\\VoidWalkerMissile.mdl", "area": ["HSQ_mavankk2.mdx", "HSQ_phangoc2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["spiritofvengeancemissile"], "extra": [], "role_diff": []}

## HSK - Hoa Sơn Kiếm

### Bạch Hồng Quán Nhật (`A0L6`, phím Q, kind 1)
- KVCT: HSK_thuongtungtarget.mdl -> target (cao; e_C:46783); HSK_cuukiem.mdl -> main (cao; e_s:46835); HSK_thuongtungtarget.mdl -> target (cao; eZi:68032); HSK_phakiemthuc.mdl -> main (trung; eH0:68079); HSK_bachhong.mdl -> target (cao; J4g:83523).
- Cấu hình: `{"main": "HSK_bachhong.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["hsk_cuukiem", "hsk_phakiemthuc", "hsk_thuongtungtarget"], "extra": [], "role_diff": ["hsk_bachhong: KVCT target / cấu hình main"]}

### Thiên Thân Đảo Huyền (`A0LO`, phím E, kind 4)
- KVCT: HSK_thienthantarget.mdl -> target (cao; JKk:73771); HSK_thienthandaohuyen.mdl -> main (trung; JKx:73805); HSK_thienthanaura2.mdl -> main (trung; JKx:73810).
- Cấu hình: `{"main": "HSK_thienthandaohuyen.mdx", "target": "HSK_thienthantarget.mdx", "buff": "HSK_thienthanaura.mdx", "area": ["HSK_thienthanaura2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["hsk_thienthanaura"], "role_diff": ["hsk_thienthanaura2: KVCT main / cấu hình area"]}

### Kim Nhạn Hoành Không (`A0LP`, phím R, kind 6)
- KVCT: NMC_phongsuongtoaianh.mdl -> main (thấp; eSU:61870).
- Cấu hình: `{"main": "NMC_phongsuongtoaianh.mdx", "cast": "HSK_kimnhancast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["hsk_kimnhancast"], "role_diff": []}

### Thương Tùng Nghênh Khách (`A0L7`, phím W, kind 1)
- KVCT: HSK_thuongtungtarget.mdl -> target (cao; e_C:46783); HSK_cuukiem.mdl -> main (cao; e_s:46835); HSK_thuongtungtarget.mdl -> target (cao; eZi:68032); HSK_phakiemthuc.mdl -> main (trung; eH0:68079); HSK_thuongtungtarget.mdl -> target (cao; Jsm:92107); HSK_thuongtungkiem.mdl -> main (cao; JsG:92140).
- Cấu hình: `{"main": "HSK_thuongtungkiem.mdx", "target": "HSK_thuongtungtarget.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["hsk_cuukiem", "hsk_phakiemthuc"], "extra": [], "role_diff": []}

### Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm (`A0LK`, phím D, kind 6)
- KVCT: HSK_doatmenhbuff.mdx -> main (thấp; eOT:48959).
- Cấu hình: `{"main": "HSK_doatmenhbuff.mdx", "cast": "HSK_doatmenhcast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["hsk_doatmenhcast"], "role_diff": []}

## TDC - Tiêu Dao Chưởng

### Dương Ca Thiên Quân (`A0H5`, phím Q, kind 1)
- KVCT: TDC_wave1.mdl -> target (cao; JDg:86543); TDC_target.mdx -> buff (trung; JD6:86573); TDC_target.mdx -> buff (trung; JD6:86574); TDC_duongca.mdl -> area (trung; JD6:86575).
- Cấu hình: `{"main": "TDC_duongca.mdx", "cast": "TDC_caster.mdx", "target": "TDC_wave1.mdx", "buff": "TDC_target.mdx", "area": ["TDC_duongca.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": ["tdc_caster"], "role_diff": []}

### Sưu Hồn Đại Pháp (`A0HL`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126509).
- Cấu hình: `{"main": "TDC_baivanchuong.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["tdc_baivanchuong"], "role_diff": []}

### Sinh Tử Phù (`A0HQ`, phím D, kind 1)
- KVCT: TDC_target.mdl -> target (cao; eQZ:70476); TDC_sinhtuphu1*.mdl -> main (cao; eQH:70510); TDC_sinhtuphueffect.mdl -> main (trung; eQi:70569).
- Cấu hình: `{"main": "TDC_sinhtuphueffect.mdx", "cast": "TDC_sinhtuphucaster.MDX", "target": "TDC_target.mdx", "buff": "TDC_sinhtubuff.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["tdc_sinhtuphu1*"], "extra": ["tdc_sinhtubuff", "tdc_sinhtuphucaster"], "role_diff": []}

### Bài Sơn Đảo Hải (`A0H7`, phím E, kind 5)
- KVCT: TDC_baivanchuong.mdl -> area (trung; J4N:83653); CBC_effect.mdl -> target (cao; J4N:83669); TDC_wave1.mdl -> target (cao; J41:83704); TDC_baisondh.mdl -> main (cao; J4b:83752); TDC_caster2.mdl -> cast (cao; J4Q:83798).
- Cấu hình: `{"main": "TDC_baisondh.mdx", "cast": "TDC_caster2.mdx", "target": "TDC_wave1.mdx", "area": ["TDC_baivanchuong.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["cbc_effect"], "extra": [], "role_diff": []}

## TDK - Tiêu Dao Kiếm

### Đan Phượng Dẫn (`A0GV`, phím R, kind 4)
- KVCT: TDK_targeteffect2.mdl -> target (cao; e_1:47558); TDK_danphuongdan5.mdl -> main (trung; e_b:47599); TDK_danphuongdan.mdl -> main (trung; e_b:47603).
- Cấu hình: `{"main": "TDK_danphuongdan5.mdx", "target": "TDK_targeteffect2.mdx", "area": ["TDK_danphuongdan.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": [], "extra": [], "role_diff": ["tdk_danphuongdan: KVCT main / cấu hình area"]}

### Chân Hỏa Hộ Thể (`A0GW`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126413).
- Cấu hình: `{"main": "TDK_chanhoabuff.mdx", "buff": "TDK_chanhoabuff2.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["tdk_chanhoabuff", "tdk_chanhoabuff2"], "role_diff": []}

### Ngang Nhật Đồ (`A0H1`, phím , kind 0) [bị động]
- KVCT: NMC_phongsuongtoaianh.mdl -> aura (trung; Jdn:126458).
- Cấu hình: `{"main": "TDK_techieukiem.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["nmc_phongsuongtoaianh"], "extra": ["tdk_techieukiem"], "role_diff": []}

### Bách Điểu Triều Phượng (`A0GG`, phím E, kind 5)
- KVCT: TDK_targeteffect3.mdl -> target (cao; J4U:83330); TDK_kiemchungdan4.mdl -> main (trung; J45:83366); TDK_target.mdl -> target (cao; J4j:83390); TDK_bachdieukiem.mdl -> main (cao; J4X:83434); TDK_targeteffect2.mdl -> cast (cao; J4A:83501).
- Cấu hình: `{"main": "TDK_bachdieukiem.mdx", "cast": "TDK_targeteffect2.mdx", "target": "TDK_target.mdx", "area": ["TDK_kiemchungdan4.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["tdk_targeteffect3"], "extra": [], "role_diff": ["tdk_kiemchungdan4: KVCT main / cấu hình area"]}

## TYK - Thúy Yên Kiếm

### Phong Quyển Tàn Tuyết (`A0BM`, phím Q, kind 5)
- KVCT: FrostArmorDamage.mdl -> target (cao; eQ9:69206); TYK_phongquyen.mdx -> main (cao; eQJ:69242); FrostArmorDamage.mdl -> cast (cao; eQJ:69246).
- Cấu hình: `{"main": "TYK_phongquyen.mdx", "cast": "TYK_effectcast.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["frostarmordamage"], "extra": ["tyk_effectcast"], "role_diff": []}

### Băng Tâm Tiên Tử (`A0BU`, phím W, kind 1)
- KVCT: FrostArmorDamage.mdl -> area (trung; edC:45133); TYK_bangtamtientu2.mdl -> target (cao; edF:45164); TYK_bangtamtientu1.mdl -> main (cao; edh:45201); TYK_bangtamtientu2.mdl -> main (cao; edh:45211); FrostArmorDamage.mdl -> cast (cao; edc:45242).
- Cấu hình: `{"main": "TYK_bangtamtientu2.mdx", "cast": "TYK_effectcast.mdx", "buff": "TYK_Buffbangtam.mdx", "area": ["TYK_bangtamtientu1.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["frostarmordamage"], "extra": ["tyk_buffbangtam", "tyk_effectcast"], "role_diff": ["tyk_bangtamtientu1: KVCT main / cấu hình area"]}

### Phi Tự Phiêu Hoa (`A0BV`, phím D, kind 1)
- KVCT: TYK_phituphieuhoa.mdl -> area (trung; eHj:68789); FrostArmorDamage.mdl -> target (cao; eHj:68798); TYK_phituphieuhoaeffect.mdl -> main (trung; eHX:68826).
- Cấu hình: `{"main": "TYK_phituphieuhoaeffect.mdx", "cast": "TYK_effectcast.mdx", "target": "TYK_phituphieuhoaeffect.mdx"}`
- Chênh lệch: {"status": "lệch", "missing": ["frostarmordamage", "tyk_phituphieuhoa"], "extra": ["tyk_effectcast"], "role_diff": []}

### Thủy Ánh Mạn Tú (`A0BY`, phím E, kind 5)
- KVCT: TYK_phituphieuhoa.mdl -> area (trung; eHj:68789); FrostArmorDamage.mdl -> target (cao; eHj:68798); TYK_phituphieuhoaeffect.mdl -> main (trung; eHX:68826); FrostArmorDamage.mdl -> area (trung; JsV:92207); TYK_thuyanheffect1.mdl -> target (cao; Js7:92244); TYK_thuyanh1.mdl -> main (cao; Jsw:92287); TYK_thuyanhmantu.mdl -> main (cao; Jsw:92294); FrostArmorDamage.mdl -> cast (cao; Jsw:92298); TYK_thuyanheffect2.mdl -> main (cao; Jsw:92299).
- Cấu hình: `{"main": "TYK_thuyanh1.mdx", "cast": "TYK_effectcast.mdx", "target": "TYK_phituphieuhoaeffect.mdx", "target_ground": true, "area": ["TYK_thuyanhmantu.mdx", "TYK_thuyanheffect2.mdx"]}`
- Chênh lệch: {"status": "lệch", "missing": ["frostarmordamage", "tyk_phituphieuhoa", "tyk_thuyanheffect1"], "extra": ["tyk_effectcast"], "role_diff": ["tyk_phituphieuhoaeffect: KVCT main / cấu hình target", "tyk_thuyanheffect2: KVCT main / cấu hình area", "tyk_thuyanhmantu: KVCT main / cấu hình area"]}
