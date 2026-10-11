# Hướng dẫn cho thành viên mới

Tài liệu này giúp bạn bắt tay vào dự án **Võ Lâm Truyền Kỳ v2.2 AI 1.31** (map Warcraft III 1.31) trong khoảng một buổi: dựng môi trường, build được map, biết sửa ở đâu khi cần đổi chỉ số, chiêu thức, trang bị, quái, boss, giao diện, và tránh các lỗi người mới hay gặp.

> Ghi công bắt buộc giữ nguyên: tác giả map **vnakira**; skill, model, icon Kiếm Vũ Chí Tôn (KVCT) của **Silva.Fox**.

---

## 0. Buổi đầu tiên: làm theo thứ tự này

1. Đọc mục 1 (nguyên tắc) và `WORKLOG.md` để biết dự án đang làm gì.
2. Cài môi trường (mục 2), chạy `python tools/pipeline.py --no-ui` cho tới khi thấy `pjass ok` (mục 3).
3. Vào game, mở map, gõ `-lvl` và `-gold` để chơi thử nhanh (mục 10).
4. Thử một thay đổi nhỏ và an toàn: đổi một số trong `tools/config.py` (ví dụ `DROP_EXPIRE_SECONDS`), build lại, xem trong game.
5. Đọc mục 6 (chiêu thức) và mục 9 (bẫy hay gặp) trước khi sửa gì lớn hơn.

---

## 1. Nguyên tắc quan trọng nhất

1. **Không sửa map bằng World Editor.** Mọi dữ liệu (đơn vị, chiêu, vật phẩm, script JASS) được **sinh ra từ Python** trong `tools/`. Sửa trực tiếp file `.w3x` sẽ bị ghi đè ở lần build sau.
2. **Sửa xong phải build bằng pipeline**, và pipeline phải in `pjass ok`. pjass kiểm tra cú pháp JASS; lỗi cú pháp làm map không chạy. Nhưng **pjass qua chưa có nghĩa là game chạy được**: lỗi giao diện, lỗi bộ nhớ chỉ lộ ra khi chơi thử (mục 9).
3. **Ghi việc vào `WORKLOG.md`.** Trước khi bắt đầu, ghi một dòng tóm tắt việc mình làm vào mục *"VỪA ĐƯỢC YÊU CẦU / ĐANG THỰC HIỆN"*. Làm xong thì ghi kết quả, và ghi rõ **đã thử trong game hay chưa**. Người sau (kể cả AI agent) đọc file này để biết đang dở việc gì. Quy tắc đầy đủ ở `AGENTS.md`.
4. **Không xoá mô tả trang bị** đã có ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]"), chỉ thêm vào.
5. **Sửa ít nhất có thể, theo thứ tự**: `config.py` → bảng dữ liệu (`kskill.py`, `kvfx/hand`, `farm_config.py`, `kvequip_data.py`) → JASS. Chỉ xuống JASS khi hai lớp trên không đủ.

---

## 2. Dựng môi trường

| Cần có | Ghi chú |
|---|---|
| Python 3 + Pillow (`pip install pillow`) | chạy các tool trong `tools/` (Pillow dùng để xử lý icon, texture) |
| Warcraft III **1.31.1** (bản Public Test) | để chơi thử map. Bản này chạy **32-bit**, bộ nhớ có hạn (mục 9.4) |
| VSCode (khuyên dùng) | mở cả thư mục dự án |
| Map KVCT gốc và `D:\KVCT31_Data` | nguồn model, texture, icon KVCT mà pipeline chép sang |
| Thư mục `D:\kvct-dev\work\` | chỉ cần khi đối chiếu chiêu với code KVCT gốc (`readable.j`) |

Map sau khi build tự được chép sang:
`Documents\Warcraft III Public Test\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`

---

## 3. Build map

```bash
python tools/pipeline.py --no-ui  # dùng lệnh này (tools/ui.py hiện không có trong worktree)
python tools/pipeline.py          # build đầy đủ, khi tools/ui.py có mặt
```

Pipeline chạy lần lượt các script trong `tools/` (thứ tự khai báo trong `tools/pipeline.py`):

```
convert_text → fix_script → expand → kvcreep → skills → tranphai → import_boss → tanlang → lvl200
→ kskill → kskill_list → gameplay → kvunit_models → describe → kvequip → icons → qbframe → kvgem
→ vfx → texshrink → ui → scale → build
```

rồi chép map sang thư mục Public Test. Pipeline luôn chạy **từ đầu**: các bước sửa `src/` tại chỗ, nên không chạy riêng một bước ở giữa.

Kết quả tốt:
```
pjass ok (41xxx lines)
>>> ALL PIPELINE STEPS PASSED SUCCESSFULLY! <<<
Synced -> ...\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x
```

Lỗi hay gặp:

| Thông báo | Cách xử lý |
|---|---|
| `File is locked by a running Warcraft III process` | Map đã build (`build/Tong Kim Beta.w3x`) nhưng **chưa chép** được. Tắt game rồi build lại, hoặc chép `build/Tong Kim Beta.w3x` sang thư mục Maps với tên khác. |
| `ERROR in <bước>.py` + `SyntaxError` | Thường do sửa tay file Python bị thiếu dấu phẩy hoặc thừa dấu nháy (mục 9.1). Traceback ghi rõ file và dòng. |
| Lỗi lạ, dữ liệu cũ không đổi dù đã sửa | Xoá các thư mục `__pycache__` trong `tools/` rồi build lại. |
| `pjass` báo lỗi | Đọc số dòng trong `build/war3map.j`, tìm hàm tương ứng trong `tools/jass/*.j` hoặc `tools/kskill.j`. |

---

## 4. Bản đồ thư mục

```
tools/
  config.py            ← chỉnh thông số (chỗ sửa nhiều nhất)
  farm_config.py       ← 10 bãi farm: tên, dải cấp, điểm Xa Phu, điểm sinh quái
  pipeline.py          ← lệnh build
  kskill.py            ← dữ liệu chiêu KVCT (bảng OVR, mốc mở chiêu, hồi chiêu)
  kskill.j             ← code chạy chiêu trong game (JASS)
  kskill_data.py       ← danh sách 33 phái, mã chiêu
  kvfx/hand/<PHÁI>.py  ← hiệu ứng hình ảnh (model) từng chiêu theo phái
  kvcreep.py           ← quái KVCT ở các bãi farm mới
  kvunit_models.py     ← đổi model quái / boss / NPC có sẵn của map sang model KVCT
  kvequip.py, kvequip_data.py ← trang bị KVCT, bậc cường hoá, Tần Lăng, Hòa Thị Bích
  kvgem.py             ← bảo thạch
  tanlang.py           ← boss Tần Thủy Hoàng (dữ liệu đơn vị)
  qbframe.py           ← sinh khung màu phẩm chất ô trang bị
  texshrink.py         ← thu nhỏ texture KVCT để game không hết bộ nhớ
  gameplay.py          ← ghép các module JASS + khai báo biến toàn cục
  jass/gameplay_XX_*.j ← logic game chia theo module (mục 7)
src/map/               ← dữ liệu map gốc đã giải nén (model, texture trong src/map/VLTK_data/)
build/                 ← map và script sinh ra (không sửa tay)
docs/                  ← tài liệu
WORKLOG.md             ← nhật ký công việc
```

---

## 5. Chỉnh thông số trong `tools/config.py`

Đây là nơi sửa nhanh nhất, không cần biết JASS. File chia thành các mục có đánh số:

| Mục | Nội dung | Ví dụ khoá |
|---|---|---|
| 1 | Nhân vật | `HERO_STAT_DIVIDER` |
| 2 | Thời gian sự kiện, boss | `BOSS_FIRST_SPAWN_MINUTE`, `MC_FIRST_SPAWN_MINUTE`, `WIN_KILLS_REQUIRED`, `BOSS_SCALE_FACTOR` |
| 3 | Rơi đồ | `ELITE_DROP_MAX_TIER`, `BOSS_DROP_MAX_TIER` |
| 4 | Tầm đánh thường từng phái | `HERO_ATTACK_RANGE = {"CBC": 500, ...}` |
| 5 | Cỡ hiệu ứng chiêu toàn cục | `SKILL_VFX_SCALE_PERCENT` |
| 6 | Model trạng thái (choáng, bỏng…) | `STATUS_VFX` |
| 7 | Đạn đánh thường | `ATTACK_PROJECTILE_SPEED`, `HERO_ATTACK_PROJECTILE` |
| 8 | Vũ khí Tần Lăng | `TANLANG_WEAPON_GOLD`, `TANLANG_SHOP_UNIT` |
| 10 | Icon theo bậc cường hoá | `EQUIP_ICONS` |
| 11 | Huyền tinh dạng điểm | `GLASS_*` |
| 12–13 | Bảo thạch: nâng bậc, tỉ lệ rơi | `GEM_UP_*`, `GD_CHANCE_PCT`, `GD_TIERS` |
| 14 | Ảnh giao diện | `UI_CUSTOM_IMAGES` |
| 15 | Phái ngoại công / nội công | `CLASS_PHE` |
| 16 | Vị trí ô trang bị bảng nhân vật | `icon_left`, `icon_right` |
| **17** | **Chiến đấu, kỹ năng, kinh nghiệm, túi đồ, hồi sinh** (dict `GAME`) | xem dưới |
| 18 | Phi phong, Quan ấn | |
| cuối file | Hồi chiêu tối thiểu, texture, model đồ rơi | `SKILL_MIN_COOLDOWN`, `TEX_MAX_SIDE`, `DROP_ITEM_MODEL` |

### Dict `GAME` (mục 17)

Mỗi dòng trong `GAME` tự sinh thành một hàm JASS `zzCF_<TÊN>()`. Số nguyên thành `integer`, số có dấu chấm thành `real`. Muốn thêm thông số mới cho code JASS: thêm một dòng ở đây (**nhớ dấu phẩy cuối dòng**), rồi trong JASS gọi `zzCF_TEN_MOI()`.

Các khoá hay chỉnh:

| Khoá | Ý nghĩa |
|---|---|
| `SKILL_DMG_GOC`, `SKILL_DMG_MOI_BAC` | sát thương chiêu = đánh thường × (gốc + mỗi bậc × bậc) |
| `SKILL_DMG_CONG_MOI_BAC` | sát thương cố định cộng thêm mỗi bậc chiêu |
| `HERO_DMG_NHAN`, `HERO_SKILL_DMG_NHAN` | hệ số sát thương lên tướng (cho trận đánh lâu hơn) |
| `KILL_XP_BASE`, `KILL_XP_PER_CAMP_LEVEL` | XP mỗi quái = XP gốc + XP theo cấp quái |
| `KILL_XP_ELITE_MUL`, `KILL_XP_LEADER_MUL` | Tinh Anh / Thủ Lĩnh tính bằng bao nhiêu quái thường |
| `CATCHUP_MINUTES`, `CATCHUP_GOLD` | chu kỳ kéo cấp tướng tụt hậu; vàng cho tướng không cần kéo |
| `REVIVE_LV1..3`, `REVIVE_T1..4` | thời gian hồi sinh theo cấp tướng lúc chết |
| `SKILL_STAT_PER_POINT` | sau khi học đủ võ công, mỗi cấp + bấy nhiêu thuộc tính chính |
| `KHINH_CONG_*` | quãng lướt, thời gian, hồi chiêu khinh công |
| `DROP_EXPIRE_SECONDS` | đồ rơi không ai nhặt tự xoá sau bấy nhiêu giây |
| `DROP_GLOW_MODEL`, `DROP_GLOW_SCALE` | vòng sáng màu phẩm chất dưới đồ rơi |
| `BAG_SLOTS`, `BAG_COLS`, `BAG_X/Y/W` | số ô và vị trí, kích thước hành trang |
| `KHAM_SO_LO`, `KHAM_TACH_VANG` | số lỗ khảm; vàng tách mỗi viên |
| `KHANG_TOI_DA`, `NE_TOI_DA` | trần kháng ngũ hành, trần né |
| `KIM_*`, `MOC_*`, `THUY_*`, `HOA_*`, `THO_*` | hiệu ứng bộ ngũ hành theo cấp bộ |

> Đường dẫn model trong `GAME` ghi thẳng vào JASS nên phải dùng `\\` (ví dụ `r"UI\\Feedback\\SelectionCircle\\SelectionCircle.mdl"`).

### Bãi farm và Xa Phu: `tools/farm_config.py`

`FARM_ZONES` là nguồn duy nhất cho 10 bãi farm: `name` (tên hiện trong menu Xa Phu), `level_min`/`level_max` (dải cấp), `entry` (điểm Xa Phu đưa tới), `camps` (4 điểm sinh quái), `teleport` (bật/tắt trong menu). Tọa độ phải nằm trên đất đi được, `expand.py` sẽ kiểm tra và báo lỗi nếu sai. Tên có ngoặc thì viết liền trong một cặp nháy: `"Đào hoa đảo (Trên)"`, **không** viết `"Đào hoa đảo"(Trên)"`.

---

## 6. Chỉnh sửa chiêu thức (skill)

Mỗi phái có 13 chiêu lấy từ KVCT. Phím: **Q W E** là chiêu sát thương chính (một số chiêu tự tung theo đòn đánh, bật/tắt bằng chuột phải vào icon), **R D F T** bấm tay, còn lại là bị động. Chiêu chọn điểm bấm phím là tung ngay tại con trỏ chuột; chuột xa quá tầm thì chiêu vẫn tung theo hướng chuột ở mép tầm.

### 6.1 Tra cứu chiêu

- `docs/kvct_skill_table.md`: bảng chiêu từng phái (tên, mã `X0xx`, phím, loại, số đòn, cấp mở).
- Phần chú thích cuối mỗi file `tools/kvfx/hand/<PHÁI>.py`: kind, model và texture đang dùng của từng chiêu.

Mỗi chiêu có hai mã: **mã KVCT** (`A0F5`, dùng trong bảng OVR) và **mã trong map** (`X084`).

### 6.2 Đổi cách chiêu hoạt động: bảng `OVR` trong `tools/kskill.py`

Tìm theo tên chiêu: mỗi mục có dòng chú thích `# >>> Tên chiêu [PHÁI]` ngay phía trên. Ví dụ:

```python
# >>> Tật Hỏa Liêu Nguyên [TND]
"A0F6": {"kind": 13, "hits": 2, "gap": .4, "rad": 350, "max": 12, "st": 5, "ch": 40, "sd": 2, "fx": 8 | 2048},
```

Khoá thường dùng (bảng giải thích đầy đủ nằm ngay đầu `kskill.py`, mục "CHÚ GIẢI CÁC KHÓA VIẾT TẮT"):

| Khoá | Ý nghĩa |
|---|---|
| `kind` | loại chiêu, quyết định chiêu chạy kiểu gì (bảng dưới) |
| `hits`, `gap` | số đợt đánh, giãn cách giữa các đợt (giây) |
| `rad` | bán kính vùng / tầm |
| `max` | số địch tối đa trúng mỗi đợt |
| `st`, `ch`, `sd` | trạng thái gây ra (1 thọ thương, 2 định thân, 3 choáng, 4 chậm, 5 bỏng), tỉ lệ %, thời gian (giây) |
| `dur` | thời gian buff (giây) |
| `stats` | chỉ số bị động / buff cộng thêm, ví dụ `[(5, 10, 2)]` = sát thương +10% +2% mỗi bậc |
| `fx` | các bit hiệu ứng đòn (kéo, đẩy, hút máu…), xem `zzKS_Fx` trong `kskill.j` |
| `anim` | đổi động tác ra chiêu của tướng |

Bảng `kind`:

| kind | Kiểu | kind | Kiểu |
|---|---|---|---|
| 0 | bị động | 13 | trận tại điểm, nhiều nhịp |
| 1 | đánh một mục tiêu | 14 / 20 / 21 | bật / tắt |
| 2 | quét hình nón | 15 | bùa chú tại điểm |
| 3 | lướt tới điểm | 16 | đánh lan tại mục tiêu |
| 4 | nổ quanh thân | 17 | đánh ngẫu nhiên quanh thân |
| 5 | đạn bay | 18 | trận quanh thân |
| 6 / 7 | buff bản thân / buff phe ta | 19 | ẩn thân |

Ví dụ thật: muốn một chiêu đánh vùng **cố định tại điểm** thay vì bám theo mục tiêu, đổi `kind` 16 hoặc 17 thành 13. **Không sửa bảng `KIND` toàn cục** (ảnh hưởng mọi chiêu cùng loại) và không sửa `src/map/war3map.w3a` (pipeline ghi đè).

### 6.3 Hồi chiêu

- Hồi chiêu gốc lấy từ KVCT.
- Chiêu **bấm tay** có hồi chiêu tối thiểu theo phím: `SKILL_MIN_COOLDOWN` trong `config.py` (ví dụ Q 3 giây, R 12 giây). KVCT dài hơn thì giữ KVCT.
- Chiêu **tự tung theo đòn đánh** không bị giới hạn này (đã phụ thuộc tốc đánh).
- Tooltip mỗi chiêu tự ghi dòng "Hồi chiêu: X giây".

### 6.4 Đổi hiệu ứng hình ảnh: `tools/kvfx/hand/<PHÁI>.py`

```python
"Phách Thạch Phá Ngọc": {   # [E]
    "main": {"file": "HSQ_phachthach.mdx", "scale": 0.6},    # hiệu ứng chính (đạn / vùng), thu nhỏ còn 60%
    "cast": {"file": "HSQ_caster.mdx", "ground": True},      # lúc ra chiêu, đặt dưới đất
    "target": "HSQ_target.mdx",                              # trên người bị trúng
    "area": ["HSQ_mavankk2.mdx", "HSQ_phangoc2.mdx"],        # các lớp phủ vùng
},
```

- Một model viết dạng chuỗi, hoặc dạng `{"file": ..., "scale": 0.8, "ground": True}` để chỉnh cỡ / đặt dưới đất.
- **Chiêu dài quá, to quá:** thêm `"scale"` (< 1 là nhỏ lại). `scale` thu đều cả dài lẫn rộng, và chỉ đổi **hình**. Muốn thu cả **vùng gây sát thương** thì thêm `"rad": 300` vào cùng mục.
- Đổi texture của model: bảng `TEXTURES` trong cùng file.
- Mỗi file có phần chú thích cuối liệt kê model gốc KVCT và texture để tham khảo; đối chiếu thêm ở `docs/kvfx_trace.md`, `docs/kvfx_mismatch.md`.
- Dùng đúng model/texture gốc KVCT, không tự đổi màu hiệu ứng sang hệ khác (ví dụ độc thành lửa).

Cách game hiển thị hiệu ứng (để hiểu khi thấy lạ):
- Hiệu ứng trúng đòn được đặt **cố định tại chỗ trúng**, quay theo hướng người đánh → địch. Nó không gắn vào người địch, nên địch xoay người thì hiệu ứng không xoay theo.
- Nhiều model KVCT không có animation xuất hiện, chỉ có Stand ngắn. `kskill.py` (`fx_holds`) đọc animation từng model lúc build và giữ những model ngắn cho hết animation rồi mới xoá. Model hào quang lặp thì xoá ngay. Nếu một hiệu ứng mới thêm vào biến mất quá nhanh hoặc đứng mãi không tắt, xem phần này.

### 6.5 Đổi mốc mở chiêu và cách cộng điểm

- `UNLOCK` trong `tools/kskill.py`: cấp mở từng chiêu theo thứ tự (hiện `1, 5, 10, … 120`).
- Mỗi cấp tướng tự cộng 1 điểm. Chiêu mới mở được bậc 1 ngay, rồi điểm ưu tiên chiêu chủ động bậc thấp nhất. Chiêu bị động được cộng khi tụt dưới một nửa bậc chủ động. Logic nằm ở `zzKS_Ranks` trong `tools/kskill.j`.
- Sát thương theo bậc: xem `SKILL_DMG_*` ở mục 5.

---

## 7. Logic game (JASS) theo module

Chỉ sửa khi `config.py` và các bảng dữ liệu không đủ. Các file trong `tools/jass/` được ghép lại theo thứ tự số.

| File | Nội dung |
|---|---|
| `gameplay_01_core.j` | hàm tiện ích, hằng số, khoá dữ liệu trang bị (`zzIT_*`), ghi log |
| `gameplay_02_farm.j` | quái rừng, bãi farm, kinh nghiệm khi giết quái, dòng chỉ số ngẫu nhiên |
| `gameplay_03_tranphai.j` | phần dùng chung của trấn phái cũ (đòn đánh, độc, hộ thuẫn) |
| `gameplay_04_combat.j` | damage engine, kháng, né, bạo kích, làm chậm |
| `gameplay_05_quests.j` | nhiệm vụ, Xa phu, Dã Tẩu, boss Diệp Thanh |
| `gameplay_06_events.j` | Đấu trường, Liên Đấu, Lôi Đài, boss, thắng mạng, log mỗi phút |
| `gameplay_07_ai.j` | AI máy: farm, mua đồ, tung chiêu |
| `gameplay_08_ui.j` | hành trang (B), bảng nhân vật, khảm, so sánh trang bị, khinh công, lệnh GM |
| `gameplay_09_equip.j` | trang bị KVCT, phẩm chất, cường hoá |
| `gameplay_10_shop.j` | cửa hàng vũ khí Tần Lăng |
| `gameplay_11_tanlang.j` | sự kiện Tần Thủy Hoàng, rơi Hòa Thị Bích |
| `gameplay_12_drop.j` | rơi đồ, vòng sáng theo phẩm chất, tự xoá đồ |
| `gameplay_14..17_*.j` | bảo thạch, nâng bảo thạch, đá thuộc tính |

Quy ước khi viết JASS:
- Biến toàn cục mới: khai báo trong chuỗi `GLOBALS` của `tools/gameplay.py`.
- Khai báo `local` phải nằm **trước** mọi câu lệnh trong hàm (pjass báo lỗi nếu sai).
- Hàm phải được định nghĩa **trước** chỗ gọi. Gọi hàm định nghĩa ở module sau: dùng `ExecuteFunc("TenHam")`.
- Vòng lặp nặng (nhiều ô, nhiều chuỗi) có thể vượt giới hạn lệnh của WC3 và bị cắt ngang. Chia nhỏ bằng `ExecuteFunc`, như `zzVL_RefreshRow`.
- Dữ liệu gắn vào vật phẩm / đơn vị lưu trong hashtable `zzVL_ht` theo `GetHandleId`. **Handle id được game dùng lại** sau khi vật phẩm bị xoá, nên tạo vật phẩm mới thì `FlushChildHashtable` trước (xem `zzDR_MakeOne`). Không thì đồ mới mang theo dữ liệu cũ (số lỗ khảm, đá…). Chọn số khoá mới thì tra `docs/JASS_KHOA.md` để không trùng.
- Sửa trigger gốc của map (trong `src/map/Scripts/war3map.j`) bằng cách thay chuỗi trong `tools/gameplay.py`, không sửa tay. Lưu ý quái KVCT là **đơn vị kiểu tướng**, chủ là phe trung lập ("Người chơi 25"). Điều kiện "tướng chết" phải kèm kiểm tra chủ là người chơi (`GetPlayerId(...) < 12`).
- **Giao diện (frame):** xem mục 9.2.

Tài liệu sâu hơn: `docs/KIEN_TRUC_CODE.md` (kiến trúc), `docs/JASS_KHOA.md` (số khoá hashtable).

---

## 8. Trang bị, bảo thạch, quái, boss

| Muốn đổi | Sửa ở |
|---|---|
| Chỉ số gốc trang bị, hệ số theo bậc cường hoá | `tools/kvequip_data.py` |
| Dòng chỉ số ngẫu nhiên, ngưỡng phẩm chất | `gameplay_02_farm.j` (`zzVL_RollAffix`), `gameplay_12_drop.j` (`zzDR_Quality`) |
| Màu khung phẩm chất ô trang bị (trắng / xanh / tím / vàng) | `tools/qbframe.py` (`COLORS`, độ dày, bo góc) |
| Vật phẩm đặc biệt (Hòa Thị Bích…): tên, icon, hình dưới đất (`ifil`) | `tools/kvequip.py` |
| Giá, cửa hàng Tần Lăng | `config.py` mục 8; logic mua ở `gameplay_10_shop.j` |
| Bảo thạch | `config.py` mục 12–13, `docs/BAOTHACH_SPEC.md` |
| Model quái / boss / NPC có sẵn của map | bảng `CREEPS`, `BOSSES`, `NPCS` trong `tools/kvunit_models.py` |
| Quái ở bãi farm mới (cấp, tooltip, điểm gắn thanh máu) | `tools/kvcreep.py`, `tools/kvcreep_data.py` |
| Boss Tần Thủy Hoàng (máu, cỡ, chiêu) | `tools/tanlang.py`, `gameplay_11_tanlang.j` |
| Boss Đấu trường / Minh Chủ | `gameplay_06_events.j` |

Icon vật phẩm phải là BLP **64×64** (kích thước không phải lũy thừa 2 hiện ô xanh trên 1.31). Icon KVCT 44 hay 56 điểm ảnh được tự chuyển. Khi tự kiểm tra icon KVCT bằng Pillow, lưu ý Pillow giải sai BLP nén JPEG của KVCT (màu đảo, kênh trong suốt sai). Dùng `kskill.kv_image` để xem đúng.

---

## 9. Bẫy hay gặp (đọc trước khi sửa lớn)

### 9.1 Thiếu dấu phẩy, thừa dấu nháy trong file Python

Lỗi phổ biến nhất khi sửa tay `config.py`, `farm_config.py`, `kvfx/hand/*.py`. Build dừng với `SyntaxError`. Kiểm tra nhanh trước khi build:

```bash
python -m py_compile tools/config.py tools/farm_config.py tools/kvfx/hand/TVT.py
```

### 9.2 Giao diện: pjass qua nhưng game crash hoặc mất thao tác

- Một số thao tác frame làm game **crash ngay lúc vào** dù pjass vẫn qua: `BlzFrameSetLevel`, backdrop chồng lên frame có sẵn, bám vào frame gốc của game (`ORIGIN_FRAME_UBERTOOLTIP`), tạo cụm frame HUD rồi ẩn.
- Frame kiểu `FRAME` phủ lên nút sẽ **nuốt cú nhấp chuột** (đã từng làm hành trang không mang được đồ). Lớp trang trí phủ lên nút phải là `BACKDROP` và gắn thẳng vào nút.
- `BlzFrameSetVertexColor` không tô màu được texture trắng như mong đợi. Cần màu thì làm sẵn texture có màu (như `qbframe.py`).
- Sửa giao diện xong **luôn vào game thử**.

### 9.3 Hiệu ứng gắn vào đơn vị

`AddSpecialEffectTarget` làm hiệu ứng xoay và chạy theo đơn vị. Hiệu ứng trúng đòn nên đặt cố định bằng `AddSpecialEffect` + `BlzSetSpecialEffectZ/Yaw` (xem `zzKS_Layer`). Khi xoá hiệu ứng KVCT, dùng `zzKS_Hold(effect, model)` thay cho `DestroyEffect` để model ngắn kịp hiện.

### 9.4 Hết bộ nhớ giữa trận

Warcraft 1.31 bản 32-bit crash với "Not enough memory resources" khi nạp quá nhiều model và texture. `texshrink.py` thu texture hiệu ứng KVCT về tối đa `TEX_MAX_SIDE` (256) điểm ảnh. Khi thêm model hoặc texture mới cỡ lớn, đừng tăng số này nếu không thật cần. Mỗi phút, game ghi vào log số đơn vị và số handle (`handle:`). Số handle tăng đều qua từng phút là dấu hiệu rò rỉ trong code: tạo timer, group, location, effect mà không huỷ.

### 9.5 File map bị khoá

Game đang mở thì pipeline không chép đè được map. Tắt game trước khi build, hoặc chép `build/Tong Kim Beta.w3x` sang tên khác để thử.

---

## 10. Chơi thử nhanh (lệnh GM trong game)

Gõ vào khung chat khi chơi thử:

| Lệnh | Tác dụng |
|---|---|
| `-lvl` / `-maxlvl` / `-rex` | lên cấp tối đa (200) |
| `-lvl <số>` | đặt cấp tướng |
| `-gold` / `-gold <số>` | thêm 100.000 vàng / số vàng chỉ định |
| `-knb` / `-knb <số>` | thêm Kim Nguyên Bảo |
| `-fullcuong` | cường hoá cả 10 ô trang bị lên +10 |
| `-fullht` | nạp rất nhiều Huyền Tinh (điểm cường hoá) |

Các lệnh này nằm ở `zzVL_OnGmCheat` trong `gameplay_08_ui.j`.

Khi gặp lỗi, gửi kèm các file sau:
- Nhật ký trong game: `Documents\Warcraft III Public Test\CustomMapData\VLTK\log.txt` (80 dòng gần nhất, có giờ trong trận).
- Báo lỗi khi crash: `Documents\Warcraft III Public Test\Errors\<ngày giờ>\` (file `.txt` ghi nguyên nhân, `War3Log.txt` ghi cảnh báo của game).
- Ảnh chụp màn hình và mô tả đang làm gì lúc lỗi (phái nào, chiêu nào, phút thứ mấy).

---

## 11. Quy trình một lần sửa

1. Đọc `WORKLOG.md`, ghi một dòng việc mình sắp làm.
2. Sửa `config.py` → nếu chưa đủ thì bảng dữ liệu (`kskill.py`, `kvfx/hand`, `farm_config.py`…) → nếu vẫn chưa đủ thì JASS.
3. Kiểm tra cú pháp file Python vừa sửa (mục 9.1), tắt game, chạy `python tools/pipeline.py --no-ui`, kiểm tra `pjass ok` và dòng `Synced`.
4. Vào game chơi thử phần vừa sửa, đủ lâu nếu sửa liên quan bộ nhớ (trên 30 phút).
5. Ghi kết quả vào `WORKLOG.md`: đã sửa gì, file nào, đã thử trong game hay chưa.

## 12. Tài liệu khác trong `docs/`

| File | Nội dung |
|---|---|
| `KIEN_TRUC_CODE.md` | kiến trúc code chi tiết |
| `JASS_KHOA.md` | số khoá hashtable đã dùng |
| `kvct_skill_table.md`, `kvct_skills.md` | bảng chiêu, số liệu chiêu KVCT |
| `kvct_audit.md` | chiêu nào đã làm / chưa làm so với KVCT |
| `kvfx_trace.md`, `kvfx_mismatch.md`, `kvfx_catalog_full.md` | đối chiếu hiệu ứng với KVCT gốc |
| `TRANGBI_SPEC.md`, `KVCT_TRANGBI.md`, `BAOTHACH_SPEC.md` | thiết kế trang bị, bảo thạch |
| `LOI_CHOI.md` | luật chơi cho người chơi |
| `HUONG_DAN_AI_KVCT.md` | hướng dẫn cho AI agent làm việc với KVCT |
| `../GUIDELINE_CHINHSUA.md` | hướng dẫn chỉnh thông số (bản cũ, ngắn) |
