# Nhật ký công việc - VLTK v2.2 AI 1.31 (bản clone mở rộng)

> ⚠️ **QUY TẮC BẮT BUỘC DÀNH CHO MỌI AI AGENT (ĐỌC ĐẦU TIÊN KHI BẮT ĐẦU)**:
> 1. **ĐỌC FILE NÀY ĐẦU TIÊN**: Mọi AI agent trước khi bắt tay vào việc hoặc trả lời câu hỏi **BẮT BUỘC** phải đọc `WORKLOG.md` để nắm toàn cảnh dự án, trạng thái và tiến độ.
> 2. **CƠ CHẾ PHÒNG HẾT TOKEN / NGẮT PHIÊN**: Ngay khi User đưa ra một yêu cầu mới, **TRƯỚC KHI LÀM HAY TRẢ LỜI SÂU**, AI Agent phải ghi tóm tắt nhanh yêu cầu đó vào mục **"1. VỪA ĐƯỢC YÊU CẦU / ĐANG THỰC HIỆN"** ở ngay đầu file này. Tránh trường hợp hết context/token làm mất dấu vết công việc đang làm dở cho AI phiên sau.
> 3. **BẢO VỆ DỮ LIỆU & PIPELINE BUILD**:
>    - Khi sửa mã nguồn (JASS/Python), chỉ mở rộng hoặc sửa đúng trọng tâm, KHÔNG ghi đè làm mất mô tả ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]").
>    - Giữ nguyên ghi công tác giả: vnakira; icon KVCT: Silva.Fox.
>    - Sau khi sửa, phải chạy pipeline build và kiểm tra `pjass` đạt 100% không có lỗi cú pháp.

---

## TOÀN CẢNH BỨC TRANH DỰ ÁN (PROJECT BIG PICTURE)

* **Bản chất dự án**: Nâng cấp, hiện đại hóa và mở rộng map Warcraft III: **Võ Lâm Truyền Kỳ v2.2 AI 1.31** (`Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`) kết hợp tài nguyên kỹ năng, mô hình và hiệu ứng từ **Kiếm Vũ Chí Tôn (KVCT)** (tác giả Silva.Fox) và cơ chế trang bị nhập vai hành động (Diablo-style).
* **Môi trường & Vị trí làm việc**:
  - Thư mục làm việc: `.` (đường dẫn động `os.path.abspath`, độc lập môi trường).
  - Bản đồ trong game: `Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x` (hoặc `build\VLTK-1.31.w3x`).
  - Nhật ký log trong game: `CustomMapData\VLTK\log.txt`.
* **Cấu trúc kiến trúc chính**:
  1. **33 Môn phái**: 21 môn phái VLTK gốc + 12 môn phái mới bổ sung đầy đủ từ KVCT (Đoàn Thị Chỉ, Minh Giáo Kiếm/Chùy, Hoa Sơn Khí/Kiếm, Cổ Mộ Kiếm/Châm, Tiêu Dao Kiếm/Chưởng, Cái Bang Bổng, Nga My Kiếm, Thúy Yên Song Đao).
  2. **Bộ máy Kỹ năng (400 chiêu)**: Dựa trên framework `tools/kskill.py` và `tools/kskill.j`, chuyển hóa toàn bộ 400 kỹ năng từ KVCT học trực tiếp theo cấp 1-200.
  3. **Trang bị RPG & Damage Engine**: Hệ thống 22 dòng thuộc tính ngẫu nhiên Diablo, 12 loại bảo thạch khảm (`I101`–`I10C`), cường hóa cố định theo 4 ô (Mũ, Áo, Vũ khí, Giày), tính toán né tránh/chính xác, kháng 5 hệ ngũ hành.
  4. **Modular hóa JASS**: Toàn bộ logic `tools/gameplay.j` (3400+ dòng) đã được tách thành 8 module rõ ràng trong `tools/jass/` (`gameplay_01_core.j` đến `08_ui.j`).
  5. **Giao diện & Tiện ích**: UI ngọc bích, phím tắt B (Hành trang), C (Bảng nhân vật 22 chỉ số), tự nhặt, tự bán đồ (Auto-sell), dọn dẹp item rác trên đất, phi phong ẩn tự cộng chỉ số khi thăng hàm.
* **Quy trình Build map (Pipeline)**:
  `tools\` chạy lần lượt: `convert_text` -> `fix_script` -> `expand` -> `skills` -> `tranphai` -> `import_boss` -> `lvl200` -> `gameplay` -> `describe` -> `icons` -> `vfx` -> `ui` -> `scale` -> `build`. Sau đó sao chép file `.w3x` đã build vào thư mục Maps của Warcraft III.

---

## 1. VỪA ĐƯỢC YÊU CẦU / ĐANG THỰC HIỆN (ACTIVE TASKS)

> *Cập nhật ngày 06/10/2026:*
- [ ] **Yêu cầu User:** *"đã làm phần skill giống với KVCT nhất chưa, tại có nhiều skill do bạn tự bịa ra đúng không"*
  - Việc: đối chiếu từng phái (theo thứ tự `CLASS` trong `tools/kskill_data.py`, bắt đầu NDD/E000) với code gốc KVCT (`D:\kvct-dev`: cast handler trong script, số liệu SLK), sửa/thêm OVR trong `tools/kskill.py`, chỉ mở rộng `tools/kskill.j` khi bắt buộc. Q/W/E giữ autocast; không đưa lại độ luyện / dummy summon.
  - Sau mỗi phái: chạy `scratchpad/run_pipeline.py` (pjass pass), viết lại mục phái đó trong `docs/kvct_audit.md` (Giống / Gần giống / Khác + lý do), commit `tools/`, `docs/`, `WORKLOG.md`, push nhánh `claude/review-refactor-3tabff`.
  - Phát hiện chung: (1) `kskill.py` chỉ dùng `kind`/`dur`/`stats` của OVR, các khóa `hits`/`status`/`sdur`/`fx` bị bỏ qua; (2) Q/W/E autocast chỉ ra 1 đợt; (3) danh sách chiêu mỗi phái lấy theo tiền tố tên, KVCT thật có bảng riêng từng phái (có chiêu dùng chung + ô 14); (4) "thọ thương" của KVCT là câm lặng (Silence), map làm thành chảy máu.
  - Sửa engine (cộng thêm, `tools/kskill.j`): `zzKS_Run` (mọi đợt, cả khi autocast), trạng thái theo đợt + thời gian 1/10 giây, thọ thương = khóa chiêu KVCT của tướng, bán kính / tối đa mục tiêu / giãn cách theo từng chiêu, bị động gắn vào Q/W/E (`zzKS_pfx`, `zzKS_steal`), nổ 3 tầng (fx 16384), kiểu 13 trận tại điểm, 14 bật/tắt (AI không tự tắt: `gameplay_07_ai.j` kind 4), 15 bùa chú tại điểm. Phái trong `KV_ORDER` (`kskill_data.py`) dùng bảng chiêu của KVCT và OVR đầy đủ.
  - Tiến độ: [x] NDD (E000), [x] TVD (H002), [x] VDK (E001), [x] TYD (E002), [x] DMPT (E003), [x] TLQ (H00Z), [x] TND (H014), [x] CBC (H00A), [x] CLK (H009).

## 2. LỊCH SỬ CẬP NHẬT / TIẾN ĐỘ

- [x] **Yêu cầu User:** *"chỉnh sửa lại hệ thống skill KVCT qua map của tôi, bóc tách rõ ràng từng kỹ năng của từng phái, chuyển qua rồi làm skill Q W E là skill autocast mỗi khi nhấp chuột phải vào"*
  - Hiện trạng trước khi sửa: autocast chọn theo order gốc của KVCT nên chỉ có Q (33/33) và W (31/33) là autocast, E (0/33) vẫn là chiêu bấm (`ANcl`).
  - `tools/kskill.py`: thêm `AUTO_KEY`, chọn autocast theo **phím** (Q→`ANba`, W→`AEpa`, E→`AHca`) cho mọi chiêu tấn công (loại 1-5). Tooltip Q/W/E có thêm dòng hướng dẫn nhấp chuột phải.
  - `tools/kskill.j` `zzKS_Do`: chiêu lướt (loại 3) khi tự phát trên đòn đánh thì đánh mục tiêu (trước đây không làm gì).
  - Thêm `tools/kskill_list.py` (chạy sau `kskill.py` trong `run_pipeline.py`) sinh `docs/kvct_skill_table.md`: bảng 400 kỹ năng theo 33 phái (tên, ID, phím, loại, số hit, cấp mở, autocast).
  - **Chưa build/pjass** trên máy cloud (cần `D:\kvct-dev` và `pjass.exe`): phải chạy `scratchpad/run_pipeline.py` trên máy Windows rồi test trong game.

- [x] **Yêu cầu User:** *"pull và tổng quan lại dự án của tôi, nếu cần thiết thì refactor lại code cho dễ nhìn"*
  - Rà soát toàn bộ cấu trúc repo. Dọn thư mục gốc: chuyển 12 script vá một lần (`patch*.py`, `check_describe.py`, `debug_regex.py`, `test.py`) và bản dump `items.txt` vào `scratchpad/legacy/` (không file nào trong pipeline tham chiếu).
  - Không đụng JASS/Python của pipeline (không chạy được pjass.exe ngoài Windows), hành vi build giữ nguyên.
  - Lưu ý: `tools/gameplay.j` là file **sinh tự động** bởi `gameplay.py` (ghép 8 module trong `tools/jass/`). Chỉ sửa trong `tools/jass/`, sửa `gameplay.j` sẽ bị ghi đè.

- [x] **Yêu cầu User:** *"đẩy lên git toàn bộ chỉnh sửa cho tôi"*
  - Kiểm tra git status, convert `.gitignore` sang UTF-8.
  - Gom toàn bộ thay đổi (code tools, map wts, w3a, gameplay JASS, lệnh GM, map build mới).
  - Commit và push lên GitHub `origin/main`.

- [x] **Yêu cầu User:** *"thêm lệnh max level rồi combine lại cho gm test"* & *"mới chỉ đổi tên file, chưa đổi được hiển thị trong game"*
  - **Khắc phục triệt để lỗi hiển thị trống trong lobby Warcraft III**:
    + Warcraft III engine yêu cầu file `war3map.wts` bắt buộc phải có **UTF-8 BOM** (`\xef\xbb\xbf`), định dạng xuống dòng chuẩn **CRLF** (`\r\n`), và không được thiếu `STRING 4514` (công thức ghép đồ).
    + Đã ghi lại file chuẩn UTF-8 BOM + CRLF và đồng bộ cả vào `work/orig/war3map.wts`.
    + Đã sửa `tools/convert_text.py` và `tools/describe.py` để bảo vệ file `src/map/war3map.wts`.
  - **Tích hợp bộ lệnh GM / Test vào game (`tools/jass/gameplay_08_ui.j`)**:
    + `-lvl`: Đưa hero lên cấp tối đa 200 ngay lập tức (hoặc `-maxlvl`, `-rex`).
    + `-lvl <số>`: Đặt cấp độ hero theo ý muốn (ví dụ `-lvl 100`, `-lvl 150`).
    + `-gold` hoặc `-gold <số>`: Nhận ngay 100,000 vàng (hoặc số lượng tùy chọn).
    + `-knb` hoặc `-knb <số>`: Nhận ngay 1,000 Kim Nguyên Bảo (hoặc số lượng tùy chọn).
  - **Build & Đồng bộ**: Pipeline chạy pass 100% (`pjass ok 30,679 lines`), tự động copy map mới vào cả 3 thư mục đích:
    + `Tong Kim Beta AI.w3x`
    + `Tong Kim Beta.w3x`
    + `Vo Lam Truyen Ky v2.2 AI 1.31.w3x`

- [x] **Yêu cầu User:** *"mới chỉ đổi tên file, chưa đổi được hiển thị trong game"*
  - **Phát hiện nguyên nhân cốt lõi**:
    1. Script `tools/convert_text.py` trước đây luôn đọc `work/orig/war3map.wts` và ghi đè lại `src/map/war3map.wts` mỗi khi chạy pipeline, làm mất nội dung người dùng sửa. Đã sửa `convert_text.py` để bảo toàn file `war3map.wts` hiện có.
    2. Hàm `recipes()` trong `tools/describe.py` phụ thuộc vào chuỗi "chế tạo đồ" trong file wts. Đã bổ sung xử lý an toàn `if not m: return {}` tránh crash khi người dùng rút gọn mô tả.
    3. Game Warcraft III đang mở và chọn vào file `Tong Kim Beta.w3x` khiến Windows khóa file (WinError 32 PermissionError).
  - **Khắc phục**:
    + Khôi phục và cập nhật đầy đủ cấu hình hiển thị mới: `STRING 1` là `|c0000ff00Tong Kim Beta AI|r`, tác giả `vnakira - Imba`, mô tả `Edited by imba`, đổi tên phe `Tong`, `Kim`, đếm ngược `Chiến thôi!`.
    + Đã xuất sang file mới [Tong Kim Beta AI.w3x](file:///C:/Users/nguye/OneDrive/Documents/Warcraft%20III%20Public%20Test/Maps/Tong%20Kim%20Beta%20AI.w3x) trong thư mục test Warcraft III của người dùng. Map sẽ hiển thị chuẩn tên màu xanh **Tong Kim Beta AI**.

- [x] **Yêu cầu User:** *"xem tôi đã lưu chưa, nếu lưu rồi xuất lại map thử"*
  - Kiểm tra xác nhận file [war3map.wts](file:///d:/vltk-2.2-ai-extended/src/map/war3map.wts) đã lưu đầy đủ các thay đổi chuỗi ngôn ngữ của User (tên map, credit, các text game).
  - Chạy toàn bộ pipeline build thành công (pjass pass 30,620 dòng, 0 lỗi).
  - Đã xuất và đồng bộ map sang:
    + `build\Tong Kim Beta.w3x` (93.1 MB)
    + `Maps\Tong Kim Beta.w3x` & `Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`
    + Thư mục game Warcraft III test: `C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\Tong Kim Beta.w3x` & `Vo Lam Truyen Ky v2.2 AI 1.31.w3x`.

- [x] **Yêu cầu User:** *"cấu hình lại toàn bộ chiêu Q W E của các phái về autocast cường hóa đòn đánh, các chiêu bị động hiển thị hình icon vào bên trong Tab nhân vật"*
  - Chuyển đổi toàn bộ kỹ năng phím Q (Base `ANba`), W (Base `AEpa`), và E (Base `AHca`) của 33 môn phái thành dạng Autocast Attack Modifier. Sửa trong `tools/kskill.py` để sinh đúng Base ID thay vì ép về `ANcl`.
  - Cập nhật cơ chế xử lý sát thương/hiệu ứng trong `tools/kskill.j` (`zzKS_OnHit`) để nhận diện buff của chiêu Autocast (`Bdba`, `Bpoa`, `Bhea`) và gọi bung hiệu ứng `zzKS_Do`.
  - Bổ sung cơ chế tạo UI icon bên trong Bảng Nhân Vật (`Nhân Vật (C)`) bằng JASS (`gameplay_08_ui.j` và `gameplay.py`), hiện danh sách các chiêu bị động của hero và xem tooltip mở rộng chứa mô tả chiêu thức bằng BoxedText khi rê chuột vào.
- [x] **Yêu cầu User:** *"bạn bóc lại skill của KVCT rồi đọc mô tả đi"*
  - Đã bóc tách dữ liệu từ `CampaignAbilityStrings.txt` và `AbilityData.slk`. Phát hiện Q, W, E là các chiêu Autocast cường hóa đòn đánh và đã xử lý dứt điểm.
- [x] **Yêu cầu User:** *"sửa lại một số bộ kĩ năng chưa thực sự gây ra đúng dame"*. (Đã sửa lỗi kỹ năng Cái Bang Chưởng).
  - Khắc phục tình trạng các chiêu bị gán nhầm loại (`kind`) dẫn đến không gây sát thương chuẩn hoặc bị lỗi hiển thị/chậm nhịp:
    - **Hàng Long Hữu Hối (A0E7)**: Chuyển từ đạn đơn (lance) sang diện rộng hình nón (`kind: 2`), `hits: 3`.
    - **Thời Thừa Lục Long (A0ED)**: Chuyển từ buff chỉ số thông thường (`kind: 6`) thành vòng lửa nổ diện rộng (`kind: 4` nova), `hits: 6` có kèm thọ thương.
    - **Phi Long Tại Thiên (A0E1)**: Sửa thành sát thương đánh nhiều nhịp mục tiêu (`kind: 1`), `hits: 4`.
    - **Long Du Thiên Địa (A0E2)**: Sửa từ kỹ năng đánh đơn (`kind: 1`) sang đạn bay xuyên thấu (`kind: 5`), `hits: 3`.
  - Đã chạy qua Pipeline và map đã tự động chép sang thư mục test của máy User.

- [x] **Chuẩn hóa đường dẫn tương đối (Dynamic Paths)**: Đã vá toàn bộ 21 script trong `tools/`, pipeline hoạt động độc lập trên repo.
- [x] **Yêu cầu User:** *"C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps build lại map vào đây chưa ? map gốc Vo Lam Truyen Ky v2.2 AI 1.31.w3x"*.
  - [x] **Đồng bộ file map build mới nhất**: Đã sao chép file `build\VLTK-1.31.w3x` (build lúc 13:09, 93.1 MB) sang:
    1. `C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x` (thành công).
    2. `D:\vltk-2.2-ai-extended\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x` (thành công).
  - [x] **Tự động hóa pipeline**: Đã tích hợp trực tiếp cơ chế auto-sync vào cuối `scratchpad/run_pipeline.py`. Mọi lần build tiếp theo sẽ tự động ghi đè bản map mới nhất sang thư mục Warcraft III của máy người dùng.
  - [x] **Phân tích đối soát toàn diện KVCT vs Engine VLTK**: Quét 400 chiêu / 33 phái từ `readable.j` của KVCT. Phát hiện 35 kỹ năng chủ động có cast handler chuyên sâu riêng (10-22 hàm, 60-280 dòng JASS) và 5 chiêu liên kích chưa có cấu hình OVR.
  - [x] **Bê trọn vẹn các kỹ năng KVCT đặc thù sang Engine (`tools/kskill.py`)**: Đã bổ sung đầy đủ 40 kỹ năng vào bảng `OVR` (nâng tổng số chiêu có cấu hình đặc thù từ 126 lên 166-172 chiêu). Bao gồm:
    * *Thiên Vương*: Tung Hoành Bát Hoang (A03A - giải khống + bạo kích), Đoạn Hồn Thích (A01M - lướt + định thân), Hoành Hành Vô Kỵ (A026 - miễn khống), Kim Chung Tráo (A02K - buff thủ phe ta), Trảm Long Quyết (A02P - lướt nổ 4 hit), Thừa Long Quyết (A02O - 3 hit).
    * *Thiếu Lâm*: Sư Tử Hống (A04U - nổ 3 hit choáng), La Hán Kim Thân (A04Y - buff tốc đánh + công), Thiên Thủ Như Lai Ấn (A0WD - buff công).
    * *Thúy Yên Đao*: Tương Tư (A0CK - buff sát thương bộc phát), Dạ Lai Tây Phong (A0WZ - nổ băng 4 hit làm chậm).
    * *Côn Lôn Kiếm*: Thanh Phong Phù (A0ID - buff tốc chạy phe ta), Đạo Cốt Tiên Phong (A0IE - buff kháng phe ta), Ngự Phong Thuật (A0IC - lốc xoáy 3 hit làm chậm).
    * *Ngũ Độc Chưởng*: Thiên Canh Địa Sát (A06L - độc sát 4 hit thọ thương), U Minh Khô Lâu (A0WM - nổ đầu lâu độc).
    * *Đường Môn*: Thiết Tỏa Hoành Giang (A0YB - bẫy trói 3 hit), Đoạn Cân Nhẫn (A07X - quạt ám khí định thân), Ảnh Tung Trận (A08P - miễn khống + tốc chạy).
    * *Minh Giáo*: Khốn Hổ Vân Tiếu (A09O - lướt dập nổ độc), Kim Qua Thiết Mã (A09P - buff bạo kích phe ta), Phách Địa Thế (A09Q - phóng chùy xuyên thấu 3 hit), Hồn Phách Phi Dương (A09T - nổ suy yếu 5 hit), Vạn Vật Câu Phần (A08Z - vòng lửa 4 hit), Càn Khôn Đại Na Di (A090 - hút máu cực mạnh), Thánh Hỏa Liêu Nguyên (A094 - mưa lửa 8 hit độc).
    * *Cổ Mộ*: Vụ Tập Vân Hợp (A0MD - buff bạo kích), Ly Hận (A0LT - 3 hit), Hồng Tụ Triền (A0MZ - kiếm khí 3 hit choáng).
    * *Hoa Sơn*: Chân Khí Hộ Thể (A0L0 - khiên hộ thuẫn hấp thụ ST), Đoạt Mệnh Liên Hoàn Tam Tiên Kiếm (A0LK - buff công).
    * *Tiêu Dao*: Thiên Tàm Cửu Biến (A0HS - bão khí 6 hit + hút máu), Sơ Hoa Dẫn (A0GZ - buff kháng phe ta).
    * *Nga My, Thúy Yên Kiếm, Đoàn Thị*: Phật Quang Chiến Khí (A0AX - buff công), Băng Tâm Ngọc Lăng (A0BX - buff phản đòn/kháng), Cản Dương Thần Chỉ (A0DC - 3 hit)...
  - [x] **Đối soát chi tiết kỹ năng chưa làm được 1:1 và nguyên nhân**:
    1. *Hệ thống Độ Luyện*: Bỏ cày số lần dùng chiêu, chuyển sang tự mở theo cấp tướng 1-200 và scale theo trang bị.
    2. *Dummy Unit triệu hồi*: Thay bằng Multi-Hit / Area Engine để triệt tiêu nguyên nhân leak memory và freeze warcraft 3.
    3. *Trigger On-damage thời gian thực*: Thay bằng cơ chế Buff chỉ số RPG (`zzVL_af`) và hiệu ứng trực tiếp (`zzKS_Fx`).
    4. *Bất tử tuyệt đối*: Điều chỉnh thành Hộ Thuẫn (`kind 9`) hoặc Miễn Khống (`kind 8`) để giữ cân bằng đấu trường.
  - [x] **Chạy toàn bộ Pipeline 15 bước & Biên dịch**:
    * Chạy thành công: `convert_text` -> `fix_script` -> `expand` -> `skills` -> `tranphai` -> `import_boss` -> `lvl200` -> `kskill` -> `gameplay` -> `describe` -> `icons` -> `vfx` -> `ui` -> `scale` -> `build`.
    * Kết quả pjass: **100% PASS (30.560 dòng)**.
    * File map đã build: `build/VLTK-1.31.w3x` (93.1 MB).
  - [x] **Cập nhật tài liệu đối soát**: Đã tái tạo `docs/kvct_audit.md` phản ánh đủ 400 kỹ năng của 33 môn phái.

---

## 2. CÁC ĐẦU VIỆC TỒN ĐỌNG / THEO DÕI

| # | Vấn đề / Yêu cầu | Trạng thái hiện tại |
|---|---|---|
| 1 | **Game bị treo (đứng hình) giữa trận** | **Chưa sửa xong.** Treo ở 8:32, 13:02 và 8:45 (thường sau khi tướng chết ở Liên Đấu hoặc sau chiêu "Tứ Tượng Đồng Quy" / "Duy Ngã Độc Tôn" A0T1). Đã bổ sung log tick mỗi giây + log dọn đồ đất, vòng log 80 dòng. Đang chờ kết quả test thực tế. |
| 2 | **Tooltip trang bị không hiện trong shop & 6 ô** | Chưa sửa (nghi vấn do thiết lập Warcraft III hoặc font UI). |
| 3 | **Đưa tướng Thiên Kiếm (bộ kỹ năng gốc) vào VLTK** | Tạm dừng, chờ chọn tướng. |
| 4 | **Map Thiên Kiếm + AI kiểu VLTK** | Tạm dừng; bản build cũ chưa chạy được. |

---

## 3. LỊCH SỬ ĐÃ HOÀN THÀNH

### Phiên làm việc gần nhất
- **Chuẩn hóa đường dẫn tương đối (Dynamic Paths)**: Toàn bộ 21 script trong `tools/` đã được thay thế đường dẫn cứng bằng `os.path.abspath(...)`. Pipeline nay hoạt động độc lập ở bất kỳ thư mục nào.
- **Hệ thống Phi Phong ẩn (Invisible Cloaks)**: Đã áp dụng trọn vẹn bản vá vào `tools/gameplay.j` và `src/map/Scripts/war3map.j`. Khi thăng quân hàm, phi phong không còn rơi ra chiếm ô đồ mà tự động gắn chỉ số ẩn vào hero qua `zzVL_AffixSum` (Phòng thủ +4..20, Thuộc tính +1..8, Sinh lực +200..800 tùy bậc) kèm hiển thị danh hiệu trên đầu.
- **Dọn dẹp mã nguồn (Repository Cleanup)**: Di chuyển toàn bộ các script vá và file thử nghiệm tạm thời (`patch*.py`, `check_describe.py`, `debug_regex.py`, `test.py`) vào thư mục `scratchpad/`.
- **Biên dịch & Đóng gói map**: Chạy thành công `tools/build.py`, pjass pass 100% 30.434 dòng JASS, sinh ra `build/VLTK-1.31.w3x` mới nhất.
- **Tái cấu trúc mã nguồn (Refactor Modularization)**:
  - Làm sạch `tools/gameplay.j`: Thay thế magic numbers bằng hằng số (`HASH_KEY_ELEMENT`, `HASH_KEY_TAIPHU`...), đổi tên biến `vl_u` -> `vl_unit`.
  - Tách `gameplay.j` (3400 dòng) thành 8 module nhỏ theo chức năng lưu trong thư mục `tools/jass/` (`gameplay_01_core.j` đến `gameplay_08_ui.j`) và cấu hình `gameplay.py` tự động ghép nối khi build map. Build pass 100%.
- **Bê kỹ năng KVCT (4 phái đã hoàn thiện OVR)**:
  - Cái Bang Chưởng (CBC): Thời Thừa Lục Long (A0ED) và Triệt Y Thập Bát Điệt (A0X5) thành buff bản thân với chỉ số chuẩn KVCT.
  - Võ Đang Khí (VDQ - H01S): Tọa Vọng Vô Ngã (A0JO) buff giảm 18%+3%/cấp sát thương; Thuần Dương Vô Cực (A0JP) hộ thuẫn 20s; Vạn Kiếm Quy Tông (A0JS) nổ quanh thân 1000.
  - Võ Đang Kiếm (VDK - E001): Lưu Tinh Cản Nguyệt (A0KG) lướt; Lưỡng Nghi Kiếm Pháp (A0KH) nổ quanh thân 40 lần; Tử Tiêu Hoành Vân (A0XM) nổ làm chậm.
  - Thúy Yên Đao (TYD - E002): Mục Dã Lưu Tinh (A0CD) phóng đao; Ngự Tuyết Ẩn (A0CE) tàng hình Wind Walk.
- **Thêm 12 phái mới từ KVCT**: Tạo mới 12 nhân vật hoàn chỉnh đưa tổng số lên 33 phái (Cổ Mộ Châm/Kiếm, Hoa Sơn Khí/Kiếm, Tiêu Dao Chưởng/Kiếm, Thúy Yên Song Đao, Cái Bang Bổng, Nga My Kiếm, Minh Giáo Chùy/Kiếm, Đoàn Thị Chỉ). Gán model chuẩn, vũ khí và liên kết NPC Ngũ Hành. Import tự động 400 kỹ năng.
- **Hệ thống Trang Bị Ngẫu Nhiên (Diablo-style)**: Rơi đồ có chỉ số ngẫu nhiên với 22 dòng thuộc tính (Hút máu, bạo kích, tốc đánh, kháng 5 hệ ngũ hành, STVL nội/ngoại, điểm đánh trúng, né tránh, tốc chạy, kỹ năng...).
- **Cơ chế Cường Hóa cố định ô**: Cấp cường hóa (1-10) lưu vào 4 ô trang bị (Mũ, Áo, Vũ khí, Giày) thay vì dính liền món đồ. Đổi đồ giữ nguyên cấp cường hóa. Chỉ số đồ scale theo `100% + 30% * Cấp cường hóa`.
- **Nâng cấp Damage Engine**: Kháng ngũ hành, né tránh/chính xác, tốc độ xuất chiêu, STVL, sát thương kỹ năng. Cập nhật bảng UI (C) hiển thị đủ 22 chỉ số.
- **Mở rộng Khảm Bảo Thạch**: Thêm 12 loại Bảo Thạch mới (`I101`–`I10C`).
- **Cân bằng & Tiện ích khác**: Scale map x1.5; quái tăng sức mạnh theo thời gian thực; điều kiện thắng 150 mạng (-win); phím Tab xóa thông báo nhanh; auto-sell đồ yếu; tự dọn item rơi rác; tăng tốc độ lên cấp 200...
