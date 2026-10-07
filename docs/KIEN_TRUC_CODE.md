# Kiến trúc code — Võ Lâm Truyền Kỳ v2.2 AI Extended

Tài liệu giải thích toàn bộ dự án cho người mới đọc code: map được build ra sao, mỗi file làm gì, engine chiêu KVCT chạy thế nào, và các bảng số liệu nằm ở đâu.

## 1. Ý tưởng chung

Dự án **không sửa map bằng World Editor**. Mọi thay đổi là **script Python** đọc map gốc, biến đổi, rồi đóng gói lại. Nhờ vậy:

- map gốc (`work\base.w3x`, `work\orig`) không bao giờ bị ghi đè;
- chạy lại pipeline luôn cho ra cùng một kết quả;
- mọi thay đổi nằm trong git dưới dạng code đọc được.

```
work\base.w3x  ──(tách file)──►  src\map\  ──(13 bước Python)──►  src\map\ đã sửa  ──(build.py)──►  build\*.w3x  ──►  Maps\
```

## 2. Pipeline build (chạy theo thứ tự)

Chạy tất cả: `python tools\pipeline.py` (lệnh cũ `python scratchpad\run_pipeline.py` vẫn dùng được; `--no-ui` bỏ bước ui; luôn build từ đầu vì các bước sửa `src` tại chỗ). Dừng ngay khi một bước lỗi, cuối cùng chạy pjass và chép 1 bản map vào `Warcraft III Public Test\Maps\`. Code: lớp `Pipeline` / `BuildStep` / `MapSync` trong `tools/pipeline.py`; dữ liệu phái dùng chung là lớp `Phai` trong `tools/model.py`.

| # | File | Làm gì |
|---|---|---|
| 1 | `convert_text.py` | Đổi chữ TCVN3 (font .VnTime cũ) của map sang Unicode. Luôn đọc bản gốc trong `work\orig`. |
| 2 | `fix_script.py` | Sửa lỗi có sẵn trong script gốc của tác giả (group chưa tạo, rò rỉ…). |
| 3 | `expand.py` | Mở rộng bản đồ về phía đông và ghép 2 khu vực lấy từ map Thiên Kiếm. |
| 4 | `skills.py` | Tên chiêu VLTK có dấu, thêm dòng hồi chiêu / nội lực vào mô tả. |
| 5 | `tranphai.py` | Chiêu trấn phái (phím T, cấp 15). |
| 6 | `import_boss.py` | 5 boss Tuyệt đại cao thủ từ Thiên Kiếm (model, texture, icon). |
| 7 | `lvl200.py` | Nâng cấp tối đa 40 → 200, chia lại chỉ số mỗi cấp. |
| 8 | `kskill.py` | **Sinh 400 chiêu KVCT**: ability trong `war3map.w3a` + bảng số liệu `build\kskill_table.j`. |
| 9 | `kskill_list.py` | Viết `docs\kvct_skill_table.md` (bảng chiêu theo phái). |
| 10 | `gameplay.py` | Ghép toàn bộ JASS (module `tools\jass\*.j` + `kskill.j` + `vlui.j`) vào `war3map.j`, thêm biến toàn cục, bảng đồ vật. |
| 11 | `describe.py` | Mô tả trang bị (chỉ số, ngũ hành, khảm). |
| 12 | `icons.py` | Icon đồ vật kiểu KVCT / VLKT. |
| 13 | `vfx.py` | Thay hiệu ứng War3 gốc bằng model KVCT cùng loại (lửa, băng, sét…). |
| 14 | `ui.py` | Giao diện ngọc bích, nút Hành Trang / Nhân Vật. |
| 15 | `scale.py` | Phóng to bản đồ ×1,5. |
| 16 | `build.py` | Đóng gói MPQ, kiểm tra pjass. |

Thư viện dùng chung (không phải bước pipeline): `mpq.py` / `mpqwrite.py` / `blast.py` (đọc, ghi file MPQ), `objdata.py` (đọc, ghi `w3a w3u w3t…`), `terrain.py` (địa hình), `tcvn3.py` (bảng mã chữ), `listfile.py` (khôi phục tên file trong MPQ). Công cụ phụ: `kaudit.py`, `kvread.py` (đọc code KVCT), `jfmt.py` (thụt lề JASS), `scan.py`, `ctx*.py`, `fontcheck.py`.

## 3. Code JASS chạy trong game

`gameplay.py` ghép các file sau thành một khối và chèn trước `zzVL_Init` trong `war3map.j`. Dòng chú thích `//` và dòng trống bị bỏ khi ghép (map chỉ nhận code), nên chú thích thoải mái trong file nguồn.

| File | Nội dung |
|---|---|
| `jass\gameplay_01_core.j` | Hằng số, hàm tiện ích, chỉ số chính của tướng. |
| `jass\gameplay_02_farm.j` | Quái rừng, bãi farm, kinh nghiệm, rơi đồ, trang bị. |
| `jass\gameplay_03_tranphai.j` | Chiêu trấn phái, độc theo nhịp (`zzVL_TpPoison`), đánh phụ (`zzVL_TpHit`). |
| `jass\gameplay_04_combat.j` | **Damage engine** `zzVL_OnDamageBody`: chí mạng, kháng ngũ hành, né tránh, bỏng, suy yếu, gọi `zzKS_OnHit` / `zzKS_OnHurt`. |
| `jass\gameplay_05_quests.j` | Nhiệm vụ, Xa phu, Dã Tẩu, boss Diệp Thanh. |
| `jass\gameplay_06_events.j` | Đấu trường, Liên Đấu, Lôi Đài, điều kiện thắng. |
| `jass\gameplay_07_ai.j` | AI máy: farm, mua đồ, tung chiêu. |
| `jass\gameplay_08_ui.j` | Hành trang (B), bảng nhân vật (C), tự bán đồ, thông báo. |
| `kskill.j` | **Engine chiêu KVCT** (mục 4). |
| `vlui.j` | Khung giao diện. |
| `gameplay.j` | Bản ghép tự sinh từ các module (đừng sửa tay). |

Quy ước tên: `zzVL_*` là code gameplay, `zzKS_*` là engine chiêu KVCT, biến cục bộ bắt đầu bằng `vl_`. Mọi số liệu lưu trong một hashtable chung `zzVL_ht`.

## 4. Engine chiêu KVCT (`kskill.py` + `kskill.j`)

### 4.1 Hai nửa

- **`kskill.py` (lúc build)**: đọc danh sách chiêu từng phái (`kskill_data.py`), số liệu đối chiếu KVCT (bảng `OVR`), rồi tạo ability trong `war3map.w3a` và viết các dòng `SaveInteger(zzVL_ht, 'X078', 240, 13)` vào `build\kskill_table.j`.
- **`kskill.j` (trong game)**: khi tướng tung chiêu hay đánh trúng, đọc lại các số đó từ hashtable và thực hiện.

Nói cách khác: **Python ghi số liệu, JASS đọc số liệu**. Muốn chỉnh một chiêu, gần như luôn chỉ cần sửa dòng `OVR` của nó trong `kskill.py`.

### 4.2 Ví dụ một dòng OVR

```python
"A0FK": {"kind": 13, "nodmg": 1, "suck": 1, "hits": 4, "gap": 2, "rad": 270, "radr": 30,
         "far": 740, "max": 7, "st": 5, "ch": 100, "sd": 3, "fx": 2},
```

Đọc là: Hỏa Liên Phần Hoa (A0FK) là **trận tại điểm** (kind 13), không sát thương, hút vào giữa, 4 nhịp cách 2 giây, bán kính 270 + 30 × bậc, đặt xa tối đa 740, tối đa 7 mục tiêu, trạng thái 5 (bỏng) 100% trong 3 giây, cờ kéo (fx 2).

### 4.3 Các kiểu chiêu (`kind`, khóa 240)

| kind | Kiểu | Hàm chính |
|---|---|---|
| 0 | Bị động | `zzKS_Tick` (mỗi giây) |
| 1 | Đánh mục tiêu | `zzKS_Strike` |
| 2 | Quét nón phía trước | `zzKS_Area` |
| 3 | Lướt tới điểm | lướt + đánh trên đường |
| 4 | Nổ quanh thân | `zzKS_Area` |
| 5 | Đạn bay (xuyên) | `zzKS_Missile` → `zzKS_FlyOne` |
| 6 / 7 | Buff bản thân / phe ta | `zzKS_Buff` |
| 8 | Miễn khống chế | |
| 9 | Hộ thuẫn | |
| 13 | Trận tại điểm (nhiều nhịp) | `zzKS_Field` → `zzKS_FieldTick` |
| 14 / 20 / 21 | Bật / tắt | `zzKS_Auto` |
| 15 | Bùa chú tại điểm | |
| 16 | Đánh lan tại mục tiêu | `zzKS_Area` |
| 17 | Đánh ngẫu nhiên quanh thân | `zzKS_Random` |
| 18 | Trận quanh thân | `zzKS_Field` |
| 19 | Ẩn thân | |

### 4.4 Luồng chạy trong game

```
Tướng bấm chiêu ──► zzKS_OnCast ──► zzKS_Run ──► zzKS_Do (theo kind) ──► zzKS_Fx (hiệu ứng phụ, trạng thái)
                                       └─ nhiều đợt: timer zzKS_Again

Đánh thường trúng ──► zzVL_OnDamageBody (gameplay_04_combat.j)
                        ├─ zzKS_OnHit: Q/W/E autocast (thấy buff Bdba/Bpoa/Bhea trên mục tiêu)
                        │             → zzKS_Run, đòn đánh thường thành 0 (chiêu thay đòn đánh)
                        │             + bị động tự phát, cộng tầng, trừ lượt buff (zzKS_BhUse)
                        └─ zzKS_OnHurt (khi tướng bị đánh): cộng tầng, Mê Hồn Trận

Mỗi giây ──► zzKS_Tick: chỉ số bị động, buff hết hạn, bị động máu thấp
```

### 4.5 Bảng khóa hashtable của một chiêu

Khóa ghi trên ability (`zzVL_ht, 'Xnnn', khóa`). Tên trong ngoặc là tên tham số trong `OVR`.

| Khóa | Ý nghĩa |
|---|---|
| 240 | kiểu chiêu (`kind`) |
| 241 | số đợt / nhịp (`hits`) |
| 242 / 243 / 244 | trạng thái, tỉ lệ %, thời gian (1/10 giây) (`st`, `ch`, `sd`) |
| 246 | thời gian buff giây (`dur`), 222 cộng thêm mỗi bậc (`durr`) |
| 247 / 248 | chỉ số buff / bị động (`stats`) |
| 249 | tự phát khi đánh |
| 250 | model hiệu ứng |
| 252 | cờ hiệu ứng phụ `fx` (bảng 4.6) |
| 257 / 258 / 259 | bán kính, giãn cách giữa nhịp (1/100 giây), tối đa mục tiêu (`rad`, `gap`, `max`) |
| 196 / 194 | bán kính cộng mỗi bậc (`radr`), điểm đặt xa nhất (`far`) |
| 239 / 245 | bị động gắn vào Q(0) W(1) E(2) hay tất cả (3), và cờ fx gắn kèm (`link`, `lfx`) |
| 221–217 | bị động máu thấp: miễn sát thương, giãn cách, hồi %, miễn khống chế, tỉ lệ (`low`) |
| 189 | ngưỡng máu % (`lowat`) |
| 182 | buff hết sau N đòn / chiêu (`bhits`) |
| 181 | hút vào tâm trận (`suck`) |
| 180 / 177, 179 / 178 | phát động thêm sát thương: tỉ lệ + mỗi bậc, % sát thương + mỗi bậc (`pch`, `pmul`) |
| 174 | thời gian buff ẩn thân cộng mỗi bậc (`hidebufr`) |
| 173 / 172 / 171 / 170 | cộng tầng: tối đa, + mỗi bậc, giây, % mỗi tầng (`stk`) |
| 169 / 168 | bị động máu thấp: tỉ lệ + mỗi bậc, giãn cách + 1/10 giây mỗi bậc (`lowr`) |
| 167 | độ rộng đạn (`wid`) |
| 166 | số nhịp độc (`psec`) |
| 165 | khi bị đánh: 1 bị động máu thấp, 2 cộng tầng, 3 suy yếu quanh thân (`onhurt`) |
| 164 | thời gian suy yếu của bị động (`wdur`) |
| 162 / 161 / 160 | suy yếu: %, giây, phạm vi (`weak`) |

Khóa ghi trên loại tướng (`zzVL_ht, 'H014', khóa`): 200 + i là chiêu thứ i, 230 + i cấp mở, 260 / 261 / 262 là chiêu ở phím Q / W / E.

### 4.6 Cờ `fx` (khóa 252, cộng bit)

| Bit | Hiệu ứng |
|---|---|
| 1 | đẩy lùi 140 |
| 2 | kéo (trận: kéo 100 về tâm, hoặc hút vào giữa nếu có khóa 181) |
| 4 | hút sinh lực |
| 8 | độc theo nhịp |
| 32 | nhiều nhịp theo thời gian buff |
| 64 | miễn sát thương 3 giây |
| 128 | phản đòn |
| 512 | mục tiêu nhận thêm sát thương (giảm kháng) |
| 1024 | bị động máu thấp |
| 2048 | độc dạng lửa |
| 4096 | hồi nội lực |
| 8192 | cộng tầng |
| 16384 | 3 lần trúng thì nổ |
| 65536 | phát động thêm sát thương |
| 131072 | phá % sinh lực (không phải tướng) |

### 4.7 Model hiệu ứng theo phái (`tools/kvfx/`)

Mỗi chiêu có thể có tới 5 lớp hiệu ứng: `main` (khóa 250, hiệu ứng chính), `cast` (280, trên tướng lúc tung), `target` (281, trên địch bị trúng), `buff` (284), `area` (285 / 286, thêm lớp tại điểm). Nguồn dữ liệu, ưu tiên từ cao xuống thấp:

1. `tools/kvfx/hand/<PHAI>.py`: sửa tay, kèm bằng chứng (số dòng trong `readable.j`). Muốn chỉnh model của một chiêu thì sửa ở đây.
2. Không có bảng: `kskill.py` chọn model theo tên chiêu, rồi `tk_mapping.py` (model Thiên Kiếm) nếu có.

## 5. Thêm hoặc sửa một chiêu (cách làm chuẩn)

1. Tìm ID chiêu trong `docs\kvct_skills.md` (ví dụ `A0FK`).
2. Sửa dòng `OVR` của nó trong `tools\kskill.py`. Nếu cần hành vi mới: thêm một khóa mới (ghi trong `ex = {…}` của `kskill.py`) và đoạn JASS đọc khóa đó trong `kskill.j`.
3. Chạy `python scratchpad\run_pipeline.py`, đợi `pjass ok`.
4. Cập nhật dòng chiêu đó trong `docs\kvct_audit.md` và ghi vào `WORKLOG.md`.

## 6. Quy tắc giữ code đẹp

- JASS: chạy `python tools\jfmt.py` sau khi sửa để thụt lề 4 dấu cách mỗi khối. Công cụ chỉ đổi khoảng trắng đầu dòng và tự từ chối file có khối không cân bằng.
- Python: `python -m black -l 120 -S tools\<file>.py`.
- Không sửa `tools\gameplay.j`, `build\*`, `src\map\Scripts\war3map.j` bằng tay: chúng được sinh lại mỗi lần build.
