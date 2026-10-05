# Hướng dẫn cho trợ lý AI: chép kỹ năng KVCT sang bản VLTK

Bạn đang giúp hoàn thiện bản đồ Warcraft III 1.31 **Võ Lâm Truyền Kỳ v2.2 AI** (thư mục `D:\vltk-dev-clone`).
Việc cần làm: làm cho kỹ năng của 21 tướng chạy **giống map KVCT (Kiếm Vũ Chí Tôn, tác giả Silva.Fox)**, theo từng phái.
Đọc hết tài liệu này trước khi sửa bất cứ file nào.

## 1. Quy tắc bắt buộc

1. **Không chép đè file.** Chỉ sửa đúng đoạn cần sửa (thêm / thay một đoạn), không viết lại cả file từ bản cũ.
   Đã từng mất cả hệ thống mô tả trang bị vì một file `describe.py` bị chép đè.
2. **Không đọc, không trích, không in phần khóa kích hoạt / VIP / "KEY PASS" của KVCT** (trong `readable.j` có đoạn
   so mã người chơi nhập). Gặp thì bỏ qua.
3. Giữ ghi công: VLTK của **vnakira**, KVCT / VLKT của **Silva.Fox**.
4. Sau khi sửa phải chạy đủ pipeline (mục 3) và build phải ra `pjass ok` + `ok ... VLTK-1.31.w3x`.
5. Ghi lại việc đã làm vào `D:\vltk-dev-clone\WORKLOG.md`.

## 2. Bản đồ các file

| Đường dẫn | Nội dung |
|---|---|
| `D:\kvct-dev\work\readable.j` | Script KVCT (143 nghìn dòng, **bị làm rối tên** bởi GRT) |
| `D:\kvct-dev\src\map\Units\CampaignAbilityStrings.txt` | Tên, mô tả, icon, phím, order, Animnames của mọi skill KVCT |
| `D:\kvct-dev\src\map\Units\AbilityData.slk` | Hồi chiêu (Cool1), tầm (Rng1) của skill KVCT |
| `D:\kvct-dev\src\map\Units\UnitUI.slk` | Model và cỡ (modelScale) của tướng KVCT |
| `D:\kvct-dev\work\base.w3x` | Archive KVCT (đọc bằng `D:\kvct-dev\tools\mpq.py`, header ở 107008) |
| `D:\KVCT31_Data\KVCT3_Data\` | Gói texture ngoài của KVCT (model KVCT tham chiếu tới đây) |
| `D:\vltk-dev-clone\tools\kskill_data.py` | Đọc skill KVCT, ghép tướng VLTK ↔ phái KVCT (`CLASS`, `HERO`), phân loại khuôn, đọc cờ hiệu ứng |
| `D:\vltk-dev-clone\tools\kskill.py` | Tạo ability X000…, icon, model, bảng `build\kskill_table.j`; **`OVR`** = số liệu riêng đọc từ code KVCT |
| `D:\vltk-dev-clone\tools\kskill.j` | Bộ máy skill (JASS): khuôn chiêu, trạng thái, lướt, liên hoàn lao, buff, hộ thuẫn… |
| `D:\vltk-dev-clone\tools\kvread.py` | Tìm hàm tung chiêu của từng skill trong `readable.j`, xuất `docs\kvct_skills.md` |
| `D:\vltk-dev-clone\tools\kaudit.py` | Bảng soát mô tả KVCT ↔ cơ chế đang chạy, xuất `docs\kvct_audit.md` |

Ghép tướng VLTK ↔ phái KVCT (mã phái là tiền tố tên skill KVCT, ví dụ `TVT03_Doan Hon Thich`):
E000 NDD, H002 TVD, E001 VDK, E002 TYD, E003 DMPT, H00Z TLQ, H014 TND, H00A CBC, H009 CLK, H01E TLD,
H01F TVT, H01L NDC, H01M DMTT, E005 NMC, H01P TNK, H01S VDQ, H01U CLD, H00L TLB, H00U DTK, H00V TVC, E006 DMPD.

## 3. Build

```
T=D:/vltk-dev-clone/tools
for s in convert_text fix_script expand skills tranphai import_boss lvl200 kskill gameplay describe icons vfx ui scale build; do
  python $T/$s.py || break
done
```
Rồi chép `D:\vltk-dev-clone\build\VLTK-1.31.w3x` sang
`C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`
(báo "busy" nghĩa là game đang mở: nhờ người dùng tắt game).

## 4. Cách đã lấy kỹ năng từ KVCT (làm theo đúng các bước này)

### Bước A — dữ liệu mô tả (tự động, đã xong)
`kskill_data.load()` đọc `CampaignAbilityStrings.txt`: mỗi skill KVCT có `[AXXX]`, `Name=<PHAI><số>_<tên>`,
`Researchtip`, `Researchubertip` (mô tả, có ô trống `! @ # $` mà KVCT điền lúc chơi), `Art` (icon), `Order`,
`Animnames`. Hồi chiêu / tầm lấy từ `AbilityData.slk` (`kskill.kv_slk()`).
Icon KVCT là BLP1 nén JPEG — **PIL giải mã sai màu**, phải dùng `kskill.kv_image()`.

### Bước B — tìm code tung chiêu trong `readable.j`
1. Đổi mã skill ra số hex: `A01M` → `$4130314D`.
2. Tìm hằng số giữ mã đó: `grep -n "=\$4130314D" readable.j` → ví dụ `constant integer E8k=$4130314D`.
3. Tìm hàm điều kiện: `grep -n "GetSpellAbilityId()==E8k" readable.j` → `function eOv ... return GetSpellAbilityId()==E8k and eOV()`.
   Hàm `eOV` là chỗ chiêu bắt đầu.
4. Lần theo các hàm nó gọi. **Bỏ qua phần lõi dùng chung** (hàm hẹn giờ `fS5/fSj/fSM`, cấp phát chỉ số `emK/em3`,
   sát thương `ftC/en9`, chỉ số `e80`, âm thanh `evd`…). Chỉ đọc phần riêng của chiêu.
   Có thể dùng `python tools\kvread.py` để liệt kê sẵn hàm riêng của từng skill (57 skill có hàm tung chiêu riêng).
5. Những hằng số hay gặp: `rF95=.03125` (nhịp 1/32 giây), `skkcd=48` (mỗi bước lướt), `$C8`=200, `$15E`=350,
   `$3E8`=1000, `$2BC`=700, `$12C`=300. Model hiệu ứng nằm ở các hằng `constant string X="war3mapImported\\...mdx"`.
6. Ghi ra: chiêu làm gì, theo thứ tự nào, model nào, gắn vào đâu (`AddSpecialEffect` tại chỗ hay
   `AddSpecialEffectTarget(...,"origin")`), cỡ (`BlzSetSpecialEffectScale`), bán kính, số mục tiêu tối đa,
   số lần lặp, nhịp, thời gian buff, công thức theo cấp (ví dụ `70+30*LoadInteger(o8,eRS(oY,oB),5)` = 70 + 30 × cấp skill).

### Bước C — đưa vào bản VLTK
- Nếu chiêu khớp một khuôn có sẵn trong `kskill.j` thì chỉ cần thêm số liệu vào `OVR` trong `kskill.py`:
  `"A01W": {"dur": 300, "stats": [(12, 70, 30), (3, 3, 1)]}` (stat là chỉ số của `zzVL_af`: 1 hút máu,
  3 bạo kích %, 4 tốc đánh %, 5 sát thương %, 6 giảm sát thương nhận, 7 sinh lực, 11 phòng thủ, 12 công cơ bản, 13 tốc chạy).
- Khuôn hiện có (`kind`): 1 đánh mục tiêu, 2 quét phía trước, 3 lướt (bước 48, bóng mờ, đánh vùng 200 cuối đường),
  4 nổ quanh thân, 5 đạn bay xuyên, 6 buff bản thân, 7 buff phe ta, 8 miễn khống chế, 9 hộ thuẫn,
  11 liên hoàn lao (Bôn Lôi). Đặt bằng `"kind": N` trong `OVR`.
- Cờ hiệu ứng (khóa 252, bit): 1 đẩy lùi, 2 kéo, 4 hút máu, 8 độc/bỏng mỗi giây, 16 hồi máu, 32 sát thương quanh
  mỗi giây, 64 miễn sát thương, 128 phản đòn, 512 giảm kháng, 1024 phát động khi máu < 40%, 2048 hình lửa.
- Nếu chiêu cần cơ chế mới: viết hàm mới trong `kskill.j` (theo mẫu `zzKS_Dash`, `zzKS_Chain`), thêm một `kind`
  mới, nhánh mới trong `zzKS_OnCast`, rồi gán qua `OVR`.

### Bước D — kiểm tra
- `python tools\kaudit.py` → xem lại `docs\kvct_audit.md`.
- Build phải qua pjass. Ghi phái đã làm vào WORKLOG.

## 5. Quy tắc viết JASS trong `kskill.j` / `gameplay.j`

- Mọi biến cục bộ đặt tên `vl_...` và khai báo **trước** mọi câu lệnh trong hàm.
- Biến toàn cục mới khai trong `GLOBALS` của `tools\gameplay.py` (ví dụ `real array zzKS_dimm`).
- Hàm phải được định nghĩa **trước** chỗ gọi; nếu không được thì gọi qua `ExecuteFunc("ten")`.
- Chuỗi đường dẫn trong JASS dùng `\\` (ví dụ `"war3mapImported\\TVT_bonloitarget.mdl"`).
- Không viết chú thích `//` trong dòng code của map ở chỗ khác ngoài đầu dòng (pipeline tự bỏ dòng chú thích).
- Không vòng lặp không có điểm dừng; bảng dài phải chia luồng (giới hạn số lệnh của JASS).
- Khi sửa file Python bằng script, **cẩn thận dấu `\`** (`\v`, `\k`, `\0` từng làm hỏng file). An toàn nhất là sửa bằng
  công cụ chỉnh sửa trực tiếp, hoặc dùng `chr(92)`.

## 6. Tiến độ (cập nhật khi làm)

| Phái | Trạng thái |
|---|---|
| TVT Thiên Vương Thương | Đã làm: Đoạn Hồn Thích (lướt + bóng mờ + vùng 200), Bôn Lôi (liên hoàn lao 7 lần, vùng 350), Chiến Ý (300 giây, 70+30/cấp). Q/W/E chạy qua lõi KVCT, chưa đọc được. |
| CBC, VDQ, … 19 phái còn lại | Chưa làm theo code. Xem `docs\kvct_skills.md` để biết chiêu nào có hàm riêng. |

## 7. Mẫu yêu cầu giao việc

> Làm phái **<mã phái>** (tướng VLTK **<mã tướng>**). Với từng skill trong `docs\kvct_skills.md` có hàm tung chiêu riêng:
> đọc code KVCT theo mục 4B, ghi lại cơ chế và số liệu thật, đưa vào `OVR` hoặc khuôn mới theo mục 4C,
> build theo mục 3, chạy `kaudit.py`, và ghi vào WORKLOG. Không chép đè file, không đụng phần VIP.
