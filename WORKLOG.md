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

- [ ] **Yêu cầu User (08/10/2026):** *"cường hóa bằng huyền tinh: đổi mọi 'thủy tinh' thành 'huyền tinh'; đọc phần mô tả cường hóa bằng huyền tinh rồi làm lại; nút + cường hóa không nhấn được, vẽ to hơn"* → đổi tên vật phẩm I00W + mô tả (describe.py), thông báo / config / tài liệu; nút + to hơn, nổi trên khung. Chú ý: trước đó gọi nhầm "huyền tinh" là Thủy tinh I00W; User xác nhận đó là cùng một thứ.
  - XONG (chờ test game, chưa commit): đổi mọi chữ 'Thủy tinh' thành 'Huyền tinh' trong tools/*.py, tools/jass/*.j, docs (giữ mã I00W và tên hàm zzGL_*); `describe.py` đặt tên + tooltip + mô tả I00W từ `config.GLASS_*` (chi phí từng bậc, tỉ lệ thành công, bảo hiểm) nên đổi config thì mô tả tự theo; nút + to hơn: 0.028 vuông, vị trí (.061 / .293), nổi `BlzFrameSetLevel` 8, chữ to. Hệ huyền tinh dạng điểm (`gameplay_13_glass.j`, config mục 11 `GLASS_*`) là phần User / phiên khác đang làm, không động tới logic. pjass ok 38315.

- [x] **Yêu cầu User (08/10/2026):** lúc bắt đầu game, mọi nhân vật được trang bị sẵn 10 món KVCT +0 tại đúng ô bảng Nhân Vật; slot vũ khí lấy theo môn phái. Hook chạy sau khi map gán `Jx`, khởi tạo cấp +0, ẩn vật phẩm khỏi mặt đất, cộng chỉ số nền và hiển thị `+0` trên cả 10 ô. Build đủ pipeline, `pjass ok (38377 lines)`, 102,925,129 bytes; SHA-256 build/Public Test trùng `7A553B22D978C3D2EAC3E68AB9F680B9A67F85E54F78D1620715DF7BE6B61F39`.
- [x] **Yêu cầu User (08/10/2026):** hoàn thiện asset UI theo concept rồng bằng các hình hiện có: panel, HUD, tile và nút hành trang đã đưa vào `UI_CUSTOM_IMAGES`; theo chỉ dẫn “dừng tạo ảnh”, `hero_button` để trống dùng hình mặc định có sẵn. Build đủ pipeline, `pjass ok (38377 lines)`, map Public Test cập nhật cùng checksum `7A553B22D978C3D2EAC3E68AB9F680B9A67F85E54F78D1620715DF7BE6B61F39`.

- [x] **Yêu cầu User (08/10/2026):** đưa đường dẫn ảnh UI tùy chỉnh ra `tools/config.py` trong biến `UI_CUSTOM_IMAGES`: `panel`, `hud`, `tile`, `bag_button`, `hero_button`; path tương đối tính từ `tools/` hoặc absolute, ảnh tùy chọn để rỗng sẽ dùng mặc định. UI pipeline tự nạp ảnh và chuyển sang BLP. Cấu hình hiện dùng panel/HUD/tile/nút hành trang; `hero_button` để rỗng theo chỉ dẫn dừng tạo ảnh và dùng icon mặc định.

- [ ] **Yêu cầu User (08/10/2026):** *"làm lại phần skill ở auto, có skill nào add vào VFX hết đi"* → mọi chiêu của mọi phái có mục trong `VFX` của `tools/kvfx/hand/<PHAI>.py` (giá trị hiệu lực hiện tại lấy từ `build/kskill_table.j`: main / cast / target / area / aura, ground), không ghi đè mục User đã viết; chạy lại `kvfx_extract.py` cho auto. Cần: `kskill.py` nhận list cho cast / target / buff, escape `\` và không chép model `MDX\` (Thiên Kiếm) khi dùng từ bảng tay. Công cụ: `tools/kvfx_fill.py`.
  - XONG: `tools/kvfx_fill.py` thêm 423 chiêu còn thiếu vào `VFX` của `hand/<PHAI>.py` (mục User đã viết giữ nguyên); `kskill.py`: `cast` / `target` / `buff` nhận chuỗi hoặc list, hàm `reg` (không chép model `MDX\` Thiên Kiếm), `esc` (escape `\` trong chuỗi JASS), model `buff` nay cũng được chép; auto chạy lại bằng `kvfx_extract.py`. Kiểm tra: các hàng model / hiệu ứng trong `kskill_table.j` trước và sau giống hệt (1102 hàng). Lưu ý: ghi vào `src` hay lỗi `OSError 22` ngẫu nhiên, chạy lại (có khi 3 lần) là qua.
- **TẠM DỪNG (08/10/2026):** bảo thạch KVCT — GEMDATA và GEMSHOP bị ngắt vì giới hạn phiên API (hết hạn ~13:50 giờ Seoul), GEMDROP đã xong (`gameplay_16_gemdrop.j`, `docs/baothach/GEMDROP_VABAN.md`, config mục 13). Cần chạy lại GEMDATA (đã có `baothach.tsv` dở dang) rồi GEMSHOP, sau đó nối: móc `zzGD_Drop` trong `zzDR_DropKind`, thứ tự ghép module (14 trước 02, 16 sau 14 và trước 12), đoạn Python khóa 360-399 vào `kvequip.py`, bỏ rơi nguyên liệu (`zzVL_CampDeath`, `gameplay.py` DROP_FN / MATS).
- [x] **Yêu cầu User (07–08/10/2026):** đổi phong cách giao diện trong game theo mẫu UI gỗ tối/đồng chạm khắc, chọn khung rồng: bảng nhân vật/hành trang và HUD đáy gồm minimap, chân dung, thanh sinh lực/nội lực, đủ 12 ô kỹ năng; không vẽ lại 10 icon ô trang bị trống, giữ nguyên logic trang bị/cường hóa. Thêm texture dự án vào pipeline (`tools/ui_custom/`), dùng BLP chữ nhật đúng tỷ lệ HUD. Pipeline đủ, `pjass ok (38312 lines)`, build 102,920,438 bytes; SHA-256 build và map Public Test trùng `0B91513C3498CAA5B0050995045BC1F4A4F496C8E9548AF7D9B6AE0823986DA4`. Chưa xác nhận trực tiếp trong game.
- [x] **Báo lỗi User (07/10/2026):** nút `+` bấm không tăng cường hóa; hover làm tooltip che/vướng thao tác và người chơi phải bấm lệch góc ô để mặc đồ. Chuyển nút túi, nút ô nhân vật và dấu `+` sang BUTTON hitbox đầy đủ; bỏ thao tác disable/enable ngay trong callback click; bỏ tooltip native trùng lặp và làm khung hover riêng không nhận click. `pjass ok (38312 lines)`, build 102,857,280 bytes, SHA-256 build/map Public Test khớp `BC6F58F7C50F89C203C8C702EC29A08CF71B364016DA4DE4866C3BFD8EAA5956`. User xác nhận phạm vi UI tự vẽ còn gồm thanh kỹ năng và khung minimap.
- [x] **Yêu cầu User (07/10/2026):** thêm phím M mở menu truyền tống Xa Phu miễn phí, hoạt động như click Xa Phu; thêm lệnh GM `-fullht` cấp đầy Huyền Tinh để test; build/pjass và cập nhật map Public Test. M mở cùng dialog/điểm đến của Xa Phu từ mọi nơi, chỉ cần có tướng sống; `-fullht` đặt số dư lên 1.000.000.000 điểm. Build `pjass ok (38316 lines)`, 102,857,314 bytes; checksum build/map đích trùng `E082E688EB8B6C107D1944202AAB18F5C2659FAB015E3B3D394CBAD4BDA16657`.
- [x] **Yêu cầu User (07/10/2026):** khi rê chuột lên trang bị phải xem được đầy đủ thuộc tính; kiểm tra và sửa tooltip trang bị trong ô nhân vật và hành trang, build/pjass rồi cập nhật map Public Test. Thêm tooltip hover tùy biến đọc mô tả mở rộng của vật phẩm cho 10 ô nhân vật, 30 ô túi và ô Thủ Khố; nội dung gồm tên, cường hóa, chỉ số, affix và tài phú. Build `pjass ok (38288 lines)`, 102,857,177 bytes. Map đích SHA-256 trùng build: `64C97CB6ABEEBE5A5067D613EC69916BE32B351A90E23BFC589138B43D70AC13`.
- [x] **Yêu cầu User (07/10/2026):** sau khi hoàn thiện trang bị/cường hóa và UI nhân vật, rà soát cải thiện toàn luồng từ đầu đến cuối, sửa các lỗi/tắc nghẽn tìm thấy, build/pjass, cập nhật map Public Test và báo các thay đổi. Rà soát phát hiện bảng nhân vật chỉ cộng tài phú 6/10 ô; sửa cộng đủ 10. Dùng chung ánh xạ ô trang bị KVCT/đồ cũ để thao tác hành trang, cường hóa và kế thừa cấp không lệch ô; cập nhật túi ngay sau khi quy đổi Huyền Tinh. Nút `+` thành chắc chắn thành công khi đủ vật liệu (giữ chi phí theo cấp). Dời bảng chữ chỉ số sang phải để không đè nút `+`. Build cuối `pjass ok (38218 lines)`, 102,856,623 bytes; SHA-256 build và map đích trùng `8569BFD1E50488C2B5DE4E074C971C50A4D31CE28B726536CA1050EC116BE5FF`.
- [x] **Yêu cầu User (07/10/2026):** bỏ trang bị khởi đầu được tặng từ hệ thống cũ, tránh cấp cùng bộ đồ cũ với trang bị/phôi KVCT mới. Đã bỏ cấp 4 món mũ/áo/vũ khí/giày cũ; bình máu ban đầu vẫn giữ.
- [x] **Yêu cầu User (07/10/2026):** đảm bảo mọi phôi/trang bị mới có cường hóa +0, tự trang bị vào đúng ô nhân vật; kiểm tra nút `+` ở UI cường hóa với Huyền Tinh/Thủy Tinh và sửa để vật liệu dùng được, cấp tăng đúng. Phôi vẫn khởi đầu +0; thao tác mặc dùng chỉ số ô chuẩn `zzEQ_Slot` và kế thừa nâng cấp của ô đang mặc.
- [x] **Yêu cầu User (07/10/2026):** hai khu sát thành được chia thành sáu dải đi bộ: cấp 1/20/40 ở phía trên và phía dưới; mỗi dải có bốn điểm spawn. Cấp 60/60/80/100 giữ trong vùng xa, đi bằng Xa Phu; menu chỉ tạo/lộ Xa Phu cho các vùng này. Mở rộng chỉ số JASS cho 10 khu và tách chỉ số nút dialog để không đè nhau. Pipeline đủ, `pjass ok (38224 lines)`, build 102,856,667 bytes trên map 264x128. Map Public Test đã được cập nhật; SHA-256 `529C412E0A3CF0B6A0A29EB3E9D9CFE61B810D092FB972613E806EFC2495E548`.
- [ ] **Sự cố User (07/10/2026):** crash log mới nhất báo cấp phát 4,294,945,024 bytes (gần 4 GiB); log cũ cho thấy bản map trước vào trận được vài phút. Bản mới vừa tăng terrain từ 252x192 lên 396x192, nên đã bỏ phóng to thừa (giữ 6 bãi farm/24 điểm ở terrain 264x128), chạy lại toàn pipeline staging và `pjass ok (38069 lines)`, build 102,862,844 bytes. Đã ghi đè map Public Test và checksum trùng `6A9B6040D36440EB3BFEAA4D2E3B7AE4206C88EA8054DB84EB0B4746D08FB795`. Chờ xác nhận thử lại trong game; chưa có khả năng xác nhận runtime trong phiên này.
- [x] **Yêu cầu User (07/10/2026):** đổi model quái sang 12 model KVCT; bố trí sáu bãi farm cấp 1/20/40/60/80/100, mỗi bãi 4 điểm spawn (24 điểm), chỉ số quái tăng theo cấp và mỗi điểm tối đa 1 Tinh Anh/Thủ Lĩnh đang sống. Pipeline staging chạy đủ, `pjass ok (38069 lines)`, build 102,961,052 bytes (396x192). Model KVCT không kèm texture `KVCT3_Data` trong archive nguồn nên đã ánh xạ texture sang skin Warcraft III có sẵn để model hiển thị. Đã cập nhật map Public Test; SHA-256 hai bản trùng `22F4796D2063F08B255232FD3842205389F58DD33B3DEECC78C7A4A3F2581DE2`.
- [x] **Yêu cầu User (07/10/2026):** chỉ Tinh Anh/Thủ Lĩnh và boss rơi phôi KVCT +0 dùng icon mặc định; mặc phôi mới kế thừa cấp cường hóa của ô/món đang mặc mà không nhân đôi cấp trên món cũ. Mỗi bãi spawn tối đa 1 Tinh Anh hoặc Thủ Lĩnh còn sống. Đã tích hợp và build cùng yêu cầu model/bãi farm phía trên.

- [x] **Yêu cầu User (07/10/2026):** bỏ hệ drop trang bị/nguyên liệu cũ; quái thường, tinh anh, thủ lĩnh, boss chỉ gọi drop bảo thạch KVCT và Huyền Tinh. Nút `+`/dùng Huyền Tinh xử lý được trang bị KVCT lẫn ô trang bị cũ; Huyền Tinh dùng sai mục tiêu không bị tiêu thụ. Bảng nhân vật được chỉnh bố cục/chữ dễ đọc hơn. Vòng câm lặng có giới hạn 14 kỹ năng và tick dự phòng tự mở lại kỹ năng khi hết hạn. Pipeline staging hoàn tất, `pjass ok (37956 lines)`, build 101,618,011 bytes. Đã ghi đè map Public Test Maps và xác nhận SHA-256 bản build/bản đích trùng `D9BD63CF93DB27AADA89287A464E9FB6B3E0A54E027AB0CCDD6F08BE33E55A25`. Chưa trực tiếp vào trận để xác nhận thao tác thực tế.

- [x] **Yêu cầu User (07/10/2026):** sửa lỗi map đang chạy: Thủy Tinh không hoạt động, bảng nhân vật khó đọc, nút `+` không cường hóa được, một số hiệu ứng kỹ năng khóa kỹ năng vô thời hạn; đã sửa trong JASS, build/pjass pass và cập nhật map test (chưa trực tiếp vào trận xác nhận runtime).

- [x] **Yêu cầu User (07/10/2026):** chép đè `VLTK-GemGlassComplete.w3x` lên map cũ `Vo Lam Truyen Ky v2.2 AI 1.31.w3x` tại thư mục Warcraft III Public Test; file cũ đã được thay bằng build mới (101,617,667 bytes).

- [x] **Yêu cầu User (07/10/2026):** *"xong thì làm phần thủy tinh, thiếu hình ảnh thì lấy bên KVCT về đây"* — hoàn thiện hệ Thủy Tinh theo đặc tả đính kèm: điểm tài nguyên trực tiếp, tiến độ theo mốc trận, tăng cường hóa có xác suất/bảo hiểm theo từng món; dùng icon KVCT nếu UI cần. Hoàn tất gems trước, sau đó tích hợp và build/pjass trong staging vì Warcraft đang khóa map gốc.


- [x] **Yêu cầu User (07/10/2026):** *"làm cho xong đi"* — hoàn thiện GEMDATA/GEMSHOP/GEMDROP end-to-end: sinh 54 vật phẩm bảo thạch và icon KVCT, ghép module, thay chỉ số khảm cũ, build/pjass xác nhận.

- [x] **Yêu cầu User (07/10/2026):** *"làm tiếp các phần mà claude với gemini chưa hoàn thành"* — tiếp tục các hạng mục còn dở đã ghi trong WORKLOG; ưu tiên hoàn tất nhánh bảo thạch GEMDROP/GEMSHOP đang active, tích hợp và chạy pipeline/pjass. Đã hoàn tất module 14/15/16, khảm lookup theo metadata, shop nâng bậc, gemdrop, icon/object data; pipeline và pjass đã pass 37,903 dòng.


- [ ] **GEMDROP (07/10/2026):** viết `tools/jass/gameplay_16_gemdrop.j` (`zzGD_Drop`, rơi bảo thạch IG<loại><bậc> theo lịch phút, bù thiếu theo bậc) + `config.py` mục 13 + bản vá `docs/baothach/GEMDROP_VABAN.md` (bỏ rơi nguyên liệu zzVL_mat, móc zzDR_DropKind, ghi hashtable 360-399 trong kvequip.py). Chưa chạy pipeline / pjass, chưa commit.

- [ ] **Yêu cầu User (07/10/2026):** *"không còn drop nguyên liệu ghép đồ; bảo thạch lấy thuộc tính KVCT; tiệm tạp hóa nâng bậc bảo thạch, công thức theo cấp số cộng; bảo thạch rơi đủ nhiều để phút 40 có bảo thạch bậc 8 9 dùng; lấy icon bảo thạch KVCT về; sửa chỉ số cho hợp game"*. Bước 1: khảo sát bảo thạch KVCT (`readable.j`, icon `Icon_BB*`) và hệ khảm hiện tại (`zzVL_Kham*`, 12 loại bảo thạch, I101..I10C); sau đó thiết kế + làm (dự kiến chia nhóm GEM-DATA / GEM-SHOP / GEM-DROP như đợt trang bị).

- [ ] **Yêu cầu User (07/10/2026):** *"tính tỉ lệ drop huyền tinh để đến phút 20 ít nhất 2-3 món +10, phút 30 5-6 món, phút 40 full đồ"* (hiểu "huyền tinh" = Thủy tinh I00W, nguyên liệu cường hóa; map không có vật phẩm tên Huyền tinh — cần User xác nhận) → rơi theo LỊCH: `config.py` mục 11 (`TT_ITEMS_AT_20/30/40` = 2.5 / 5.5 / 10 món, `TT_MARGIN_PCT` 110, `TT_CATCHUP_KILLS` 6, `TT_MAX_PER_KILL` 15), `kvequip.py` ghi hashtable 0/342-347, `gameplay_12_drop.j`: `zzDR_CrystalTarget` (số thủy tinh tích lũy theo phút = số món × (10*base + 45*step) × dư), `zzDR_Crystal` (mỗi lần giết quái bãi rơi bù 1/6 phần thiếu so với lịch, tinh anh x1.5, thủ lĩnh x2, boss x3, tối đa 15 một cục), gọi từ `zzDR_DropKind`. Mô phỏng Python (2-12 kill/phút): phút 20 ≈ 2.4-2.7 món, phút 30 ≈ 5.2-5.9, phút 40 ≈ 9.8-10.8. pjass ok 37059. Chưa test game, chưa commit.

- [ ] **Yêu cầu User (07/10/2026):** *"dùng bộ icon ban đầu nhưng +0 là bộ xám cấp 1 của KVCT, tăng dần lên bộ trùng sinh +6 hiện tại làm +10"* → `tools/kvequip_data.py`: `KF_WEAPON = [1,2,3,4,5,7,9,11,12,13,14,20]`, `KF_ARMOR = [1,2,3,4,5,6,8,10,11,12,13,13]` (kf1 xám, kf2 xanh lá, kf3 xanh dương, kf4 tím, kf5-10 cam, kf11+ vàng; +10 = bộ ts6 cũ, Tần Lăng kf20); tên trang bị theo kf của bậc. `EQUIP_ICONS` (config mục 10) giữ làm tùy chọn, mặc định trống. Bảng `docs/kvequip_icons/HIEN_TAI_dang_dung.png` đã cập nhật. pjass ok 36996. Chưa test game, chưa commit.

- [ ] **Yêu cầu User (07/10/2026):** *"tên trang bị đã làm chưa; cường hóa bấm dấu + nhỏ cạnh ô trang bị, trừ thủy tinh, số cần theo cấp số cộng; +0 lấy bộ mặc định rồi xanh tím cam vàng (làm theo phương án đề nghị)"* → tên: có (`kvequip_names.py`, tên KVCT theo bậc). Nút +: 10 nút `+` trong bảng nhân vật (`gameplay_08_ui.j`, `zzVL_PlusDo` / `zzVL_PlusCount`, click qua `zzVL_OnFrameClick` mã 100+), số thủy tinh = `CUONGHOA_TT_BASE + CUONGHOA_TT_STEP * bậc` (config mục 9, ghi vào hashtable 0/340-341 trong `kvequip.py`). Icon: `config.EQUIP_ICONS` (mục 10) chọn bộ icon KVCT cho từng ô / loại vũ khí; bảng icon tham khảo trong `docs/kvequip_icons/` (TB_vukhi_10bac xám-xanh-tím-cam-vàng, TBTC, TBAH, TBDH, HIEN_TAI_dang_dung). Mặc định giữ bộ hiện tại; chờ User chọn bộ. pjass ok 36996. Chưa test game, chưa commit.

- [ ] **TRANG BỊ KVCT (07/10/2026) — TÍCH HỢP XONG, chờ test game, chưa commit.** 4 nhóm agent (DATA / SHOP / BOSS / DROP, đặc tả `docs/TRANGBI_SPEC.md`, bản vá `docs/trangbi/*_VABAN.md`) đã xong; điều phối đã nối: thứ tự ghép module trong `tools/gameplay.py` (01, 09, 02, 03, 04, 05, 12, 06, 07, 08, 10, 11), bước `tanlang.py` (sau import_boss) và `kvequip.py` (sau describe) trong `scratchpad/run_pipeline.py`, `zzSH_Init` / `zzTL_Init` (ExecuteFunc trong zzVL_Init), áp 3 bản vá DROP (zzVL_OnDeath, zzVL_BossKilled, bỏ vòng rơi cũ ở zzVL_CampDeath). Quy tắc User thêm: trường đao + đại đao cho phái đao, phi tiêu cho DMPT; dòng chỉ số theo ô (`zzEQ_AffixSlots`: k5/16/19 vũ khí, k6/7 nón+áo, k8-10 liên, k20 áo+giày; nhẫn chỉ +kỹ năng, hiếm 15%); 1-3 dòng mỗi món (`zzEQ_LineCount` 50/35/15), min-max mỗi dòng (`zzEQ_AffixMin/Max`); cường hóa nhân dòng ngẫu nhiên (`zzEQ_LineValue`, +10 = 400%), dòng +kỹ năng chỉ 1 + bậc*3/10 (tối đa +4 ở +10); Tần Thủy Hoàng phút 20 mỗi 5 phút, đội hạ boss +20% chỉ số chính 3 phút. pjass ok 36892 dòng. CHƯA TEST TRONG GAME.

- [ ] **Yêu cầu User (07/10/2026):** *"boss Tần Thủy Hoàng xuất hiện phút 20, mỗi 5 phút 1 lần; team ăn boss nhận buff +20% chỉ số thuộc tính chính, kéo dài 3 phút"* → `gameplay_11_tanlang.j`: `zzTL_FirstMinute`=20, `zzTL_Interval`=5, `zzTL_BuffPercent`=20, `zzTL_BuffSeconds`=180, `zzTL_Buff(hero)` (cộng 20% chỉ số cao nhất trong Str/Agi/Int bằng ModifyHeroStat, hết hạn trả lại, nhận lại thì làm mới). Gọi từ `zzTL_OnDeath` cho đồng minh của người hạ boss. Chưa build.

- [ ] **DROP (trang bị KVCT, 07/10/2026)**: đã viết `tools/jass/gameplay_12_drop.j` (`zzDR_Drop`, `zzDR_DropKind`; bảng tỉ lệ ở đầu file) + bản vá `docs/trangbi/DROP_VABAN.md` (sửa `zzVL_OnDeath`, `zzVL_BossKilled`; 12 ghép sau 02, 09 và trước 06). Chưa chạy pipeline.

- [x] **Nhóm BOSS (trang bị, 07/10/2026):** boss Tần Thủy Hoàng (đơn vị `n0TL`, rơi `ITHB`) viết xong: `tools/tanlang.py` + `tools/jass/gameplay_11_tanlang.j` (chưa chạy pipeline, chưa pjass); móc nối ghi ở `docs/trangbi/BOSS_VABAN.md` (gọi `ExecuteFunc("zzTL_Init")` trong zzVL_Init; thêm `tanlang.py` sau `import_boss.py`).

- [ ] **Yêu cầu User (07/10/2026):** *"tạm xong skill, chuyển qua trang bị: copy hết trang bị KVCT từ trùng sinh 1 đến 10 qua map; không làm trùng sinh mà làm CƯỜNG HÓA: +1 ứng với icon / model trang bị trùng sinh 1, +2, +3 … +10 ứng với trùng sinh 10. Vũ khí ts 11 = 'Vũ khí Tần Lăng': boss Tần Thủy Hoàng rơi 'Tần Lăng Hòa Thị Bích'; mua item vũ khí Tần Lăng cần vàng + vũ khí +10 có sẵn + Hòa Thị Bích. Item vũ khí Tần Lăng bán ở tiệm tạp hóa thay cho trang bị hiện có. Đổi lại hệ thống vũ khí giống KVCT: đao, kiếm, triền thủ, thương..."*
  - Bước 1: khảo sát trang bị KVCT (`D:\kvct-dev`, `D:\Maps\KVCT v3.195.w3x`): loại, 10 ô, bậc trùng sinh 1-11, icon / model, chỉ số, vũ khí theo loại; đối chiếu với hệ trang bị hiện tại (`tools/gameplay_items.py`, 22 dòng chỉ số, cường hóa theo ô). Ghi kết quả khảo sát và kế hoạch ở dưới trước khi sửa.
  - KHẢO SÁT XONG (docs/KVCT_TRANGBI.md): trang bị KVCT do SCRIPT tạo (bảng ô KU2 / icon KjF, 11 loại vũ khí K5N / Kjx, icon `icon_vk_<loại>#` # = 1..20 bậc), không có danh sách vật phẩm sẵn để chép; có boss Tần Thủy Hoàng + Tần Lăng. Chưa sửa code. Chờ User chốt các quyết định thiết kế (đã hỏi) và tránh đụng việc 10 ô của phiên khác (`gameplay_items.py`, `describe.py`).

- [ ] **Nhóm DATA - làm lại hệ trang bị KVCT (07/10/2026, theo docs/TRANGBI_SPEC.md mục 4):** tạo `tools/kvequip.py` + `tools/kvequip_data.py` (vật phẩm ITV0..ITVA, ITS1..ITS5/ITS7..ITSA, ITW0..ITWA, ITHB trong w3t, icon KVCT bậc 7..20 vào `war3mapImported\kvq\`, hàng bảng ghi thẳng vào war3map.j) và `tools/jass/gameplay_09_equip.j` (zzEQ_Tier/SetTier/Slot/WeaponType/CanUse/IsPlus10Weapon...); sửa móc nối trong gameplay_02_farm.j (AffixSum), gameplay_08_ui.j (mặc đồ, Thủy tinh, GM). Chưa chạy pipeline (điều phối chạy). Bản vá cho file ngoài ranh giới: `docs/trangbi/DATA_VABAN.md`.
  - DATA XONG (chưa chạy pipeline): pjass sạch trên bản ghép thử. Thêm: bảng ô <-> dòng chỉ số ngẫu nhiên `zzEQ_AffixSlots` (gameplay_09_equip.j), phái đao dùng thêm trường đao / đại đao, DMPT dùng thêm phi tiêu (khóa 400+w trên loại tướng). Cần điều phối: thứ tự ghép module + bước kvequip.py (xem DATA_VABAN.md).

- [ ] **Yêu cầu User (07/10/2026):** *"hiệu ứng đạn bay khi đánh thường (tốc đánh đã phụ thuộc thân pháp)"* → `config.HERO_ATTACK_PROJECTILE = {phái: ("model.mdx", tốc độ)}` (33 phái, mặc định "" = không đạn; chú thích gợi ý model Q/W/E), `kskill.py` ghi `ua1m` / `ua1z` của tướng và chép model. Đã thử CBC → CBC_dulong 900 (w3u ghi đúng) rồi trả lại. Cũng thêm HAND_OVR: hits/gap/rad/max/st/ch/sd/dur/far/radr/wid/psec sửa trong `kvfx/hand/<PHAI>.py`. pjass ok 34850.

- [ ] **Yêu cầu User (07/10/2026):** *"sửa trong file CBC.py có áp dụng không; muốn texture nằm trong các file py như file cấu hình cho dễ sửa"* → `tools/kvfx/hand/<PHAI>.py` (33 file) nay có `VFX`, `TEXTURES = {"model.mdx": {"cu.blp": "moi.blp"}}` (kskill.py `patch_textures` sửa bảng TEXS của model trong src khi build, đã thử đổi Shield4 → Flame4 thành công rồi trả lại) và khối DANH MỤC model + texture từng chiêu dưới dạng chú thích (`tools/kvfx_catalog.py`, chạy qua `kvfx_doc.py`, chỉ ghi đè giữa hai dòng BEGIN / END, phần User viết tay giữ nguyên). Sửa file có hiệu lực SAU KHI chạy lại pipeline.

- [ ] **Yêu cầu User (07/10/2026):** *"không có texture cho các skill hỗ trợ chủ động à? ví dụ CBC Triệt Y Thập Bát Điệt"* → nguyên nhân: buff tự thân chỉ phát model 1 lần (`DestroyEffect` ngay) nên model lặp (Stand, như `CBC_trietytbd` shield) bị tắt tức thì. Sửa: khóa 294 (model có Stand, `model_loops` trong `kskill.py`), `zzKS_SelfFx` (`kskill.j`) giữ model trên tướng suốt thời gian buff (zzKS_Buff, ẩn thân, hộ thuẫn, miễn khống chế, miễn thương khi bị đánh); model không lặp vẫn phát 1 lần. 286 chiêu có cờ. pjass ok.

- [ ] **Yêu cầu User (07/10/2026):** *"đòn đánh để lại hiệu ứng cháy lửa đâu, tôi muốn xem; thêm vào các phái tùy đòn đánh, xem texture"* → `config.STATUS_VFX` (trạng thái 2 định thân → Effect_dinhthan, 4 chậm → Effect_dongbang, 5 bỏng → Effect_fire2 đặt lại mỗi 1,8 giây vì model chỉ có Birth ~2 giây), `zzKS_StatusFx` / `zzKS_StatusTick` trong `kskill.j` gắn lên địch suốt thời gian trạng thái, thay hiệu ứng cũ; `kvfx_doc.py` ghi "Trạng thái gây ra" cho từng chiêu + `tools/kvfx/doc/TRANG_THAI.md`. Lưu ý: KVCT không có model bỏng riêng đọc được (Effect_bong = BongDaAcCau, bóng, không phải lửa); chọn Effect_fire2 (Lords*.blp) vì phiên trước đã map IncinerateBuff → Effect_fire2. pjass ok 34544.

- [ ] **Yêu cầu User (07/10/2026):** *"build lại, đánh giá cấu hình tầm đánh Cái Bang; ghi trong tất cả phái mô tả model + texture của từng chiêu (riêng phái / dùng chung) để tự sửa"* → `tools/kvfx_doc.py` sinh `tools/kvfx/doc/<PHAI>.md` (33 file) từ `build/kskill_table.j` + texture đọc từ `.mdx`; bị động không aura ghi chú "không phát hiệu ứng". Build pjass ok 34492 với tầm đánh User đã sửa (CBC 500...).

- [ ] **Yêu cầu User (07/10/2026):** *"sửa lại tầm đánh của các phái đánh xa, ghi ra file config để tự sửa; có phái tung chiêu được từ xa nhưng đánh thường lại chạy lại gần quái rồi mới tung"* → tầm đánh (aran / BlzSetUnitWeaponRealField range) theo phái, đặt trong `tools/config.py`.
  - XONG (chờ test game, chưa commit): `config.HERO_ATTACK_RANGE` (33 phái; DMTT 600, CMC 550, DTC 500, HSQ 500 nâng lên, các phái còn lại giữ tầm hiện tại) áp trong `kskill.py` (ua1r + uacq). `config.SKILL_VFX_SCALE_PERCENT` + `"scale"` trong `kvfx/hand/<PHAI>.py` → khóa 290 / 291, `zzKS_Pop` / `zzKS_PopT` / `zzKS_Size` (`kskill.j`) phóng to hiệu ứng chính lúc tung. Bảng nhân vật (C): rê chuột vào icon bị động hiện hộp mô tả chung (`zzVL_PassTipOn/Off`, sự kiện MOUSE_ENTER/LEAVE, EscMenuBackdrop + TEXT; BlzFrameSetTooltip không hiện). Aura CBC Túy Điệp có khóa 287 (kvfx.get hợp nhất hand + auto). Bỏng: model Effect_fire2 (IncinerateBuff) gắn trên quái suốt thời gian bỏng thay model lửa sàn `TND_tathoafire` (gây hình phẳng trên đầu); model sàn (target_ground) đặt dưới chân quái, không gắn ngực. pjass ok 34492.

- [ ] **Yêu cầu User (07/10/2026, kèm 2 ảnh chụp game):** (1) rê chuột vào skill trong bảng nhân vật (C, hàng 6 icon dưới) phải hiện mô tả; (2) chiêu bị động có aura phải hiện (CBC Túy Điệp không hiện: bảng hand/CBC.py thắng auto và không có khóa aura → sửa `kvfx.get` hợp nhất); (3) hiệu ứng bỏng / lửa gắn lên quái bị lỗi texture (hình 1D trên đầu khi di chuyển / chết).

- [ ] **Yêu cầu User (07/10/2026):** *"dựng bảng chiêu → model theo code KVCT cho toàn bộ phái; skill nào không làm được thì dùng tk mapping"*
  - Cách làm: tự động lần hằng số model (`constant string X="war3mapImported\CLS_xxx.mdl"`) → hàm dùng nó trong `D:\kvct-dev\work
  - XONG (chờ test game, chưa commit): `tools/kvfx_extract.py` đọc readable.j (hằng số chuỗi model → hàm dùng nó; chiêu Q/W/E tìm qua bộ điều phối autocast `Jdd`, marker → phái) rồi ghi bảng theo phái `tools/kvfx/auto/<PHAI>.py` (tự sinh, ghi đè khi chạy lại); `tools/kvfx/hand/<PHAI>.py` sửa tay thắng auto (hiện có CBC); `tools/kvfx/__init__.py` `get(phái, tên chiêu)`. `kskill.py`: bảng KVCT > tự chọn theo tên; có bảng thì thắng cả `tk_mapping`. 156 / 200 chiêu bấm + autocast có bảng; 44 chưa (chủ yếu buff dùng lõi chung: Tọa Vọng Vô Ngã, Bồ Đề Tâm Pháp, Thiên Vương Chiến Ý...; Q/W/E của MGK, HSK, CLK) → dùng tự chọn theo tên / tk_mapping. Bị động không có hàm cast nên không có bảng (không thấy hiệu ứng). pjass ok 34353 dòng.
  - Bị động (User hỏi vì sao không làm được): KVCT chỉ có 13 chỗ gọi `JcZ(true,"model",...)` trong các hàm điều phối bị động (Jdn JdY Jd8 Jdu JdL; chọn phái bằng `sG[oY]==N`, chiêu bằng `xT==ô`) → gắn model aura lên tướng suốt thời gian có chiêu; mọi bị động khác không có model. `kvfx_extract.py` đọc các chỗ đó (`passive_auras`) → mục `aura` trong `kvfx/auto`; `kskill.py` ghi khóa 287; `zzKS_Tick` gắn effect bền lên tướng khi chiêu mở. 12 chiêu có aura (Túy Điệp Cuồng Vũ, Lôi Đình Quyết, Tôi Độc Thuật, Bắc Minh Thần Công, A La Hán Thần Công, Hóa Kinh Quyết, Tuyết Ảnh, Thất Tinh Quyết). pjass ok 34365.
eadable.j` → chiêu sở hữu hàm đó (tái dùng `tools/kvread.py`) → `tools/kvct_vfx.py` (KVCT_VFX sinh tự động + bảng tay CBC). Chiêu không lần được → giữ tự chọn theo tên / `tk_mapping.py`.

- [ ] **Yêu cầu User (07/10/2026):** *"làm skill từ map KVCT (D:\Maps\KVCT v3.195.w3x), toàn bộ skill chưa có hoạt ảnh"*
  - Bước 1: khảo sát hiện trạng hiệu ứng (kskill.py chọn 1 model/chiêu, khóa 250), model KVCT nào có, chiêu nào thiếu / dùng model sai; lập bảng chiêu → model theo lớp (cast / đường bay / va chạm / mục tiêu). Chỉ đọc để hiểu, không bê code bị làm rối.
  - Khảo sát: 33 phái có 464 model KVCT (tiền tố phái), map chỉ dùng 1 model / chiêu (khóa 250) cho mọi lớp nên 201 model không dùng (target 56, cast 50, buff 138...). Bước 1 XONG: `kskill.py` chọn thêm model theo vai trò tên (cast → khóa 280 gắn lên tướng lúc tung `zzKS_Run`; target → khóa 281 gắn lên địch bị trúng `zzKS_Status`, tối đa 1 lần / 0,4 giây / địch); model chính ưu tiên loại không phải cast / target. 92 chiêu có thêm model. pjass ok 34094 dòng. Chưa test trong game, chưa commit.
  - Cái Bang Chưởng (User: hiệu ứng chưa đẹp): log cho thấy lớp sai (E dùng hoatbatluuthu của Túy Điệp; Q/W dùng model Thiên Kiếm `MDX\KhangLongHuuHoi` do `tools/tk_mapping.py` của phiên khác ghi đè). Đã lần code KVCT (readable.j) → `tools/kvct_vfx.py` (bảng KVCT_VFX, kèm số dòng bằng chứng) thắng cả tự chọn lẫn TK_OVERRIDES: 5 chiêu CBC. Các phái khác chưa có bảng này, vẫn chọn theo tên.
  - Còn lại: model buff 138 chưa gắn (buff dùng khóa 250), đạn bay dùng 1 model, hoạt ảnh tướng (`aani` = Animnames KVCT) cần kiểm từng chiêu; chiêu không có model riêng vẫn dùng model chung của phái.
  - Bước 2 XONG (theo yêu cầu "làm hết"): vai trò mở rộng: cast (khóa 280/282), target (281/283), buff (284), lớp hiệu ứng thêm (285/286); chiêu buff phát 280/284 trong `zzKS_Buff`; model chung của phái ("caster" / "target" không mang tên chiêu) gán cho chiêu tấn công chưa có. 331 dòng model phụ, model KVCT chưa dùng 201 → còn khoảng 50 (chủ yếu model trấn phái của `tranphai.py`). Hoạt ảnh tướng: KVCT gần như không gọi SetUnitAnimation trong script (11 chỗ, không phải chiêu), hoạt ảnh đến từ `Animnames` (spell / attack / spell,throw / spell,slam) → `aani`, map đã sao y; chiêu autocast dùng hoạt ảnh đánh thường. pjass ok 34357 dòng. Chưa test trong game, chưa commit.

- [ ] **Yêu cầu User (07/10/2026):** *"refactoring lại toàn bộ dự án, chỗ code nối liền khó đọc thì làm cho đẹp và giải thích toàn bộ code"*
  - Kế hoạch: thụt lề tự động các file JASS chưa thụt lề (chỉ khoảng trắng, kiểm tra bằng so sánh mã đã bỏ khoảng trắng + pjass), viết `docs/KIEN_TRUC_CODE.md` giải thích kiến trúc / luồng / bảng khóa hashtable. Không đổi logic.
  - XONG: `tools/jfmt.py` thụt lề kskill.j, vlui.j, các module jass (mã sau khi bỏ khoảng trắng y hệt); black -l 120 -S cho 30 file Python (bỏ qua gameplay.py, kskill.py, lvl200.py vì phiên khác đang sửa); `docs/KIEN_TRUC_CODE.md`. Build: `war3map.j` đầu ra trùng từng dòng với trước, pjass ok. Chưa commit.

- [x] **Yêu cầu User (07/10/2026):** *"mượn hiệu ứng chưởng lực của skill tương ứng trong map của tôi, lọc skill và copy hiệu ứng chưởng lực"*
  - Kế hoạch:
    - Viết tool dò tên kỹ năng KVCT với các tên file `MDX` trong mã nguồn Thiên Kiếm. Kết quả match được 57 tuyệt kỹ (Giáng Long Chưởng, Thái Cực Thần Công, Bạo Vũ Lê Hoa...).
    - Tự động copy `MDX` và tự quét copy các `BLP` liên quan sang `war3mapImported\MDX\`.
    - Viết script `tk_mapping.py` để inject thẳng vào `kskill.py`, ghi đè các `250` (Art path) sang dùng hiệu ứng Thiên Kiếm.


- [x] **Yêu cầu User (07/10/2026):** *"viết 1 guildline hướng dẫn khi tôi muốn chỉnh chỉ số gì trong game, và viết ra 1 file config để dễ sửa thuộc tính hơn"*
  - Kế hoạch:
    - Tạo `tools/config.py` chứa các config cơ bản (HERO_STAT_DIVIDER, BOSS_FIRST_SPAWN_MINUTE, v.v.).
    - Tích hợp import `config.py` vào `tools/lvl200.py` và `tools/gameplay.py`.
    - Tạo file markdown `GUIDELINE_CHINHSUA.md` để hướng dẫn chi tiết cách User chỉnh thông số bằng Python pipeline thay vì World Editor.


- [x] **Yêu cầu User (06/10/2026):** *"làm rồi còn phải xem tương tác khi bind kỹ năng vào đấy nữa, và không làm mất di chuyển của nhân vật + các nút a s d đánh tay, có thể giữ nguyên chức năng nhưng không hiển thị"*
  - Kế hoạch:
    - Ẩn các nút lệnh mặc định (Move, Stop, Hold, Attack) của nhân vật mà không làm mất chức năng (vẫn dùng phím tắt M, S, H, A được).
    - Sử dụng `BlzUnitDisableAbility(unit, 'Amov', false, true)` và `'Aatk'` để ẩn UI mà giữ nguyên logic.

- [x] **Yêu cầu User (06/10/2026):** *"làm phần giao diện UI giống của KVCT luôn, thanh kỹ năng đấy"*
  - **Đã làm:**
    - Phát hiện ra project đã có sẵn mã nguồn giao diện KVCT/VLKT (`tools/vlui.j`) và các UI texture (như `VLKT_FrameUI_Bottom3.blp`, `UIButton_trong.blp`).
    - Giao diện này trước đây bị ẩn dưới lệnh chat `-vlkt`.
    - Đã sửa hàm `zzUI_Setup` trong `vlui.j` để tự động nạp giao diện thanh kỹ năng (skill bar), máu/mana (HP/MP bar), và khung UI tùy chỉnh của KVCT ngay khi vào game mà không cần phải gõ lệnh.
    - Cập nhật lại pipeline và pjass báo lỗi 0.

- [x] **Yêu cầu User (06/10/2026):** *"trong phím B chỉ chứa trang bị chứ không mang trang bị nữa, mang trang bị thì trang bị đó sẽ hiện vào trong tab C nhân vật"*
  - **Đã làm:** 
    - Gỡ bỏ hoàn toàn 6 ô "Đang mang" cũ nằm trong bảng Hành trang (phím B). 
    - Căn chỉnh lại giao diện B (đẩy các nút và lưới ô đồ dự trữ lên trên) cho khỏi bị trống.
    - Bây giờ khi bấm trang bị ở hành trang (B), trang bị sẽ chuyển hoàn toàn sang 10 ô bên tab Nhân Vật (phím C), không còn bị nhân đôi/hiển thị thừa ở tab B nữa.
    - Cập nhật lại tool quét `pjass` thành công không lỗi.

- [ ] **Yêu cầu User (06/10/2026):** *"tăng sức mạnh cho tuyệt đại cao thủ và boss võ lâm minh chủ, cho boss cũng cast chiêu theo hệ, tạo scale size boss lên 5 lần"*
  - Kế hoạch: 
    - Tăng mạnh chỉ số máu/đam của `zzVL_boss` và `zzVL_mc`.
    - Scale kích thước lên 5.
    - Cấu hình 5 loại Boss đại diện cho Ngũ Hành (Kim, Mộc, Thủy, Hỏa, Thổ) và gán logic AI hoặc dummy cast chiêu thức theo hệ.

- [ ] **Yêu cầu User (06/10/2026):** *"bây giờ tạm gác lại hệ thống trang bị, chuyển sang hệ thống sinh quái tinh anh và thủ lĩnh"*
  - Trạng thái: HOÀN THÀNH.
  - Chi tiết:
    + Quái thường: chỉ còn rớt nguyên liệu/Thủy Tinh, hoàn toàn không rớt đồ.
    + Quái Tinh Anh (10%): máu x3, dmg x3, to hơn (1.3x) và có Aura xanh. Thưởng người giết 200 Vàng, 300 EXP. Rớt nguyên liệu x3 và có xác suất rớt tối đa 3 món trang bị phẩm 2 hoặc 3.
    + Quái Thủ Lĩnh (2%): máu x8, dmg x8, to hơn (1.6x) và có Inner Fire đỏ. Thưởng người giết 1000 Vàng, 1500 EXP. Rớt nguyên liệu x6 và có xác suất rớt tối đa 6 món trang bị phẩm 2 hoặc 3.
    + Boss / Minh Chủ: rớt trực tiếp 5 - 8 món trang bị phẩm 5 (bậc 5 cao nhất).

- [ ] **Yêu cầu User (06/10/2026):** *"đọc phần kvct_audit để làm lại toàn bộ đơn vị đo lường của skill và skill"*
  - Kế hoạch: đọc hết `docs/kvct_audit.md`, so cột KVCT với cột Map từng chiêu, tìm lệch đơn vị (ngưỡng vs khoảng, giây vs nhịp, điểm vs %, kéo/hút/đẩy, cộng dồn, sau N đòn, khi bị đánh), sửa OVR `tools/kskill.py` (+ engine `tools/kskill.j` khi cần), ghi "Giống (chưa test)". Tiến độ theo phái ghi ở đây.
  - Đã đọc audit (429 dòng chiêu: 130 Giống, 244 Gần giống, 55 Khác). Nhóm lệch đơn vị lặp lại: proc chung "30% thêm 25%" (18), "nhận thêm 15% / 4 giây" thay giảm kháng (11), bán kính/rộng lệch (11), thời gian cố định thay công thức (9), "khi bị đánh" chưa làm (8), độc 5 nhịp vs N lần, điểm KVCT → % map, tê liệt/hỗn loạn = choáng. Chờ User chọn thứ tự.
  - [x] Nhóm 1 (phát động riêng): khóa 180/177 tỉ lệ, 179/178 % sát thương (`pch`, `pmul`), `zzKS_pch`/`zzKS_pmul` cho bị động gắn Q/W/E; 13 chiêu điền số KVCT, audit cập nhật.
  - [x] Nhóm 2 (thời gian / bán kính): độ rộng đạn khóa 167 (`wid`, 48 chiêu lấy từ chú thích KVCT); cộng tầng tham số hóa `zzKS_StackAdd` (khóa 173/172/171/170, `stk`; Liên Hoàn Đoạt Mệnh Thương 5+bậc tầng, 8 giây, 3%); "low" thêm tỉ lệ / giãn cách theo bậc (169/168, `lowr`; Thiên Vương Bản Sinh 25+5×bậc%); Ngự Tuyết Ẩn buff 2,8+0,1×bậc giây (khóa 174). Chưa làm: Kim Cang Bất Hoại (KVCT không ghi công thức giãn cách).
  - [x] Nhóm 3 (độc N lần): `zzVL_TpPoison` ô 5 = số nhịp (mặc định 5 cho nơi gọi khác); khóa 166 `psec`, 14 chiêu lấy từ chú thích KVCT (12 chiêu không ghi số giữ 5).
  - [x] Nhóm 4 ("khi bị đánh"): `zzKS_hurt` + `zzKS_OnHurt` (gọi từ `gameplay_04_combat.j`); khóa 165 `onhurt` 1 = bị động máu thấp chỉ phát khi vừa bị đánh (A01R, A0BQ, A0FM, A04G, A02F, A07I Huyết Đỉnh Công mới), 2 = cộng tầng khi bị đánh (Mê Tung Huyễn Ảnh 16 tầng 5 giây, Càn Khôn Chùy bậc+5 tầng 6 giây 6%).
  - [x] Nhóm 5 (suy yếu): khóa 164 `wdur` thời gian KVCT cho bị động gắn Q/W/E (Vạn Cổ 30, Nghịch Chuyển 10, Bi Ma 30, Luyện Ngục 12, Bi Tô 30 giây). Mức % giữ 15% (thang map).
  - Tất cả: pjass sạch phần này; build vẫn chặn bởi `zzVL_AiGear` (việc khác). Chưa test trong game, chưa commit.
  - [x] Theo yêu cầu thêm: Kim Cang Bất Hoại giãn cách 3→6 giây theo bậc (khóa 168 nay là phần mười giây / bậc trên 1); suy yếu `zzKS_Weak`/`zzKS_WeakArea` (khóa 162/161/160 `weak`; nguồn bị suy yếu gây −% sát thương tối đa 20 trong `gameplay_04_combat.j`, tốc đánh chậm 20% qua `BlzSetUnitAttackCooldown`): Mê Hồn Trận (onhurt 3), Hồn Phách Phi Dương. Pipeline PASS (pjass 33941 dòng), map đã sync. Còn 48 chiêu "Khác" chưa làm (liệt kê trong câu trả lời 06/10).
  - Sửa kèm: Chu Cáp Thanh Minh trong KVCT đúng là "kéo 100" → hút vào giữa chỉ bật bằng khóa 181 (`suck`, chỉ A0FK).

- [ ] **Yêu cầu User (06/10/2026):** *"Hỏa Liên Phần Hoa không thực sự hút kẻ địch vào"*
  - Nguyên nhân: `zzKS_FieldTick` chỉ dịch 100 đơn vị mỗi nhịp 2 giây (SetUnitPosition) → gần như không thấy. Sửa: hàm mới `zzKS_Pull`/`zzKS_PullTick` (`tools/kskill.j`) trượt mượt kẻ địch về cách tâm 80 trong 0,3 giây (10 bước × 0,03 s), dừng nếu gặp địa hình không đi được. Áp cho mọi trận có fx 2. pjass: phần này sạch; build vẫn hỏng vì `zzVL_AiGear` (không phải của phiên này).

- [ ] **Yêu cầu User (06/10/2026):** *"Cái Bang, Thời Thừa Lục Long không buff cho 6 đòn đánh (kỹ năng) kế tiếp"*
  - Làm: khóa 182 (`bhits`) trong `tools/kskill.py` (A0ED: 6); `tools/kskill.j` `zzKS_BhUse` trừ 1 lượt mỗi lần tung chiêu (`zzKS_OnCast`) hoặc đánh thường (`zzKS_OnHit`), về 0 thì hết buff (`zzKS_bufEnd`=0); biến `zzKS_bhN`/`zzKS_bhAb` trong `tools/gameplay.py`. Phần này pjass sạch; build đang hỏng vì lỗi khác: `zzVL_AiGear` (local khai báo sau lệnh, việc trang bị 10 ô đang làm song song) → map chưa sync.

- [ ] **Yêu cầu User (06/10/2026):** *"chạy code KVCT nguyên bản thì sao"* → đồng ý thử theo từng phái, bắt đầu Thiên Nhẫn (TND H014 / TNK H01P). Bước 1: khảo sát code gốc `D:\kvct-dev\src\map\war3map.j` (144k dòng): hàm chiêu, hệ nền phụ thuộc, ID đối tượng; báo khối lượng trước khi port.
  - Khảo sát: script KVCT bị làm rối bởi GRT ("Protect by GRT, Fragile Team"): tên hàm/biến vô nghĩa (6691 hàm), ID ability ghi dạng hex ($41304634 = A0F4). Chiêu được đăng ký theo bảng ô (SaveInteger(o8,eRS(oY,Ff),slot,id) + f5w(...)), dòng ~81530 cho TND; logic chạy theo phái/ô chứ không theo ID. Port nguyên bản = phải giải rối từng hàm và kéo theo hệ nền. Chờ User quyết.

- [ ] **Yêu cầu User (06/10/2026):** *"thiết kế theo hướng dùng skill đó đánh, chứ không ra đòn đánh thường nữa; những skill tạm thời không thiết kế được mà đã đánh dấu rồi thì bê skill đó từ map Thiên Kiếm về"*
  - (1) Q/W/E autocast: chiêu thay thế đòn đánh thường (không cộng sát thương đánh thường + chiêu). (2) Các chiêu KVCT đã đánh dấu "chưa làm được / khác" trong `docs/kvct_audit.md`: lấy bản tương ứng từ `D:	hienkiem-dev` (`src/War3map.j`, w3a). Tiến độ ghi bên dưới.
  - **(1) XONG (chờ test):** `zzKS_repl` (khai báo trong `tools/gameplay.py`): `zzKS_OnHit` bật cờ khi buff autocast Q/W/E tung chiêu, `zzVL_OnDamageBody` (`gameplay_04_combat.j`) đặt sát thương đòn đánh thường = 0 khi cờ bật. Chiêu bị động tự phát 10% (kind 249) vẫn cộng thêm như cũ. pjass ok, map sync.
  - **(2) Khảo sát:** trong `docs/kvct_audit.md` có 55 dòng "Khác"; chỉ 5 tên trùng với Thiên Kiếm (Bất Diệt Bất Tuyệt, Vân Long Tam Hiện, Liệt Diệm Thao Thiên, Trấn Ngục Phá Thiên Kinh, Thập Diện Mai Phục) và số liệu cũng khác KVCT. Chưa port, chờ User chọn hướng.

- [ ] **Yêu cầu User (06/10/2026):** *"phái thiên nhẫn bật autocast rồi mà đánh thường không ra skill"* → *"đọc chiêu auto cast của map thiên kiếm (D:\thienkiem-dev) xem cách nó hoạt động rồi bê về"*
  - Đã đọc Thiên Kiếm: mỗi chiêu autocast là bản sao Poison Arrows (`AEpa`), `abuf` đặt ở dataptr **0** với buff riêng của chiêu (`B00L,B00L,B00L`), `adur`/`ahdu` 0.1, `atar` air,enemies,ground, tốn 10 mana. Trigger sát thương: `DamageType==ATTACK` + mục tiêu có buff đó + nguồn là tướng → gỡ buff rồi tung chiêu.
  - Khác với `tools/kskill.py`: `abuf` ghi dataptr **1** (nghi bị bỏ qua, E dùng `AHca` buff `Bhea` có thể không bao giờ xuất hiện), dùng 3 base khác nhau (ANba/AEpa/AHca) và buff chung của Blizzard. **Đã sửa (bước 1, tối thiểu):** `abuf` về dataptr 0 và lặp 3 lần như Thiên Kiếm, `adur`/`ahdu` 0.01 → 0.1 trong `tools/kskill.py`; pipeline + pjass ok (33496 dòng), map đã sync. Chờ User test lại Thiên Nhẫn; nếu vẫn không ra thì bước 2: đổi sang base `AEpa` + buff riêng từng chiêu (w3h).

- [ ] **Yêu cầu User:** *"làm hệ thống trang bị của map tôi thành hệ thống trang bị 10 item đấy, tức là 10 món đấy nhặt được và trang bị trong hệ thống nhân vật"*
  - Biến toàn bộ hệ thống trang bị trong game thành 10 món trang bị thực thể (nhặt được, mua được, lưu trong túi đồ và mặc trực tiếp vào 10 ô nhân vật):
    + 10 loại trang bị: Nón, Áo, Yêu Đái, Hộ Uyển, Hài, Vũ Khí, Hạng Liên, Giới Chỉ, Ngọc Bội, Hộ Thân Phù.
    + Khi nhặt hoặc bấm mặc trong Hành Trang (B): tự động nhận diện đúng slot 0..9 của 10 ô nhân vật.
    + Lưu item đang mặc vào mảng `zzVL_equipItem[pid*10 + slot]`, lấy icon/tên/chỉ số thật của món đồ đó hiển thị lên 10 ô trên bảng phím C.
    + Nếu ô đã có đồ: tháo đồ cũ ra chuyển về túi đồ / hành trang và mặc đồ mới vào.
    + Cập nhật các nguồn rơi đồ (creeps, bosses), shop bán đồ hỗ trợ đầy đủ cả trang sức (liên, nhẫn, bội, phù) và phòng cụ (yêu đái, hộ uyển).
    + Tính toán và kích hoạt toàn bộ thuộc tính, dòng affix, khảm ngọc và cường hóa của món đồ đang mặc lên nhân vật.

- [x] **Yêu cầu User:** *"dùng nguyên bộ trang bị của KVCT, bao gồm liên nhẫn phù bội, yêu đái nữa"* & *"lúc bấm phím nhân vật lên sẽ có 10 ô chia thành 2 hàng mỗi bên 5 ô"*
  - **Trạng thái:** HOÀN THÀNH 100%. Pipeline pass, pjass pass (33,340 lines), build map và tự động đồng bộ sang Warcraft III test maps thành công.
  - **Chi tiết đã thực hiện:**
    1. **10 Slot Trang Bị KVCT Chuẩn:**
       - Cột trái (5 ô Phòng Cụ): 1. Nón (Mũ), 2. Áo (Giáp), 3. Yêu Đái (Lưng), 4. Hộ Uyển (Tay), 5. Hài (Giày).
       - Cột phải (5 ô Binh Khí & Trang Sức): 6. Vũ Khí, 7. Hạng Liên (Dây chuyền), 8. Giới Chỉ (Nhẫn), 9. Ngọc Bội, 10. Hộ Thân Phù.
    2. **Tài nguyên Giao diện (Textures & BLP):**
       - Trích xuất 14 texture BLP từ `D:\kvct-dev\work\base.w3x` (MPQ offset 107008), chuẩn hóa power-of-two (64x64) không bị lỗi màn hình xanh 1.31:
         + 5 ô nền viền ngọc trống: `vl_slot_bg_1.blp` .. `vl_slot_bg_5.blp`.
         + 10 icon trang bị mẫu chuẩn KVCT: `vl_eq_1.blp` đến `vl_eq_10.blp`.
       - Tự động hóa quá trình trích xuất trong `tools/ui.py`.
    3. **Hệ thống Logic Cường Hóa & Chỉ số (`tools/jass/`):**
       - Chuyển đổi toàn bộ mảng cường hóa `zzVL_cuong` sang hệ 10 slot (`pid*10 + slot`).
       - `gameplay_03_tranphai.j`: Hỗ trợ `zzVL_CuongSlot` cường hóa độc lập từng slot từ 0..9 lên tới +10.
       - `gameplay_02_farm.j`: `zzVL_AffixSum` cộng dồn toàn diện 22 dòng thuộc tính theo 10 slot cường hóa (STVL ngoại/nội công, kháng 5 hệ, hút máu, hút mana, bạo kích, chính xác, né tránh, giảm sát thương nhận, tăng cấp kỹ năng).
    4. **Bảng Giao Diện Nhân Vật Phím C (`gameplay_08_ui.j`):**
       - Mở rộng bảng nhân vật rộng 0.350, cao 0.380 với tông màu khung ngọc bích chuẩn KVCT.
       - 5 ô phòng cụ thẳng hàng bên trái (`X = 0.025`), 5 ô trang sức/vũ khí bên phải (`X = 0.322`).
       - Ở giữa là bảng hiển thị 22 chỉ số chi tiết, danh hiệu quân hàm và ngũ hành.
       - Bên dưới giữ nguyên 6 nút kỹ năng bị động (passive skills).
       - Mỗi ô trang bị có hiển thị cấp cường hóa (+0..+10), cấp phẩm chất và Tooltip tương tác hiển thị chi tiết chỉ số khi rê chuột vào.
    5. **Lệnh GM Test Nhanh:**
       - `-cuong <1-10>`: Cường hóa trực tiếp ô tương ứng (1: Nón .. 10: Phù).
       - `-fullcuong`: Cường hóa toàn bộ 10 ô trang bị lên +10 tức thì và cập nhật trực tiếp bảng chỉ số.


- [ ] **Yêu cầu User:** *"đã làm phần skill giống với KVCT nhất chưa, tại có nhiều skill do bạn tự bịa ra đúng không"*
  - Việc: đối chiếu từng phái (theo thứ tự `CLASS` trong `tools/kskill_data.py`, bắt đầu NDD/E000) với code gốc KVCT (`D:\kvct-dev`: cast handler trong script, số liệu SLK), sửa/thêm OVR trong `tools/kskill.py`, chỉ mở rộng `tools/kskill.j` khi bắt buộc. Q/W/E giữ autocast; không đưa lại độ luyện / dummy summon.
  - Sau mỗi phái: chạy `scratchpad/run_pipeline.py` (pjass pass), viết lại mục phái đó trong `docs/kvct_audit.md` (Giống / Gần giống / Khác + lý do), commit `tools/`, `docs/`, `WORKLOG.md`, push nhánh `claude/review-refactor-3tabff`.
  - Phát hiện chung: (1) `kskill.py` chỉ dùng `kind`/`dur`/`stats` của OVR, các khóa `hits`/`status`/`sdur`/`fx` bị bỏ qua; (2) Q/W/E autocast chỉ ra 1 đợt; (3) danh sách chiêu mỗi phái lấy theo tiền tố tên, KVCT thật có bảng riêng từng phái (có chiêu dùng chung + ô 14); (4) "thọ thương" của KVCT là câm lặng (Silence), map làm thành chảy máu.
  - Sửa engine (cộng thêm, `tools/kskill.j`): `zzKS_Run` (mọi đợt, cả khi autocast), trạng thái theo đợt + thời gian 1/10 giây, thọ thương = khóa chiêu KVCT của tướng, bán kính / tối đa mục tiêu / giãn cách theo từng chiêu, bị động gắn vào Q/W/E (`zzKS_pfx`, `zzKS_steal`), nổ 3 tầng (fx 16384), kiểu 13 trận tại điểm, 14 bật/tắt (AI không tự tắt: `gameplay_07_ai.j` kind 4), 15 bùa chú tại điểm. Phái trong `KV_ORDER` (`kskill_data.py`) dùng bảng chiêu của KVCT và OVR đầy đủ.
  - Tiến độ: [x] NDD (E000), [x] TVD (H002), [x] VDK (E001), [x] TYD (E002), [x] DMPT (E003), [x] TLQ (H00Z), [x] TND (H014), [x] CBC (H00A), [x] CLK (H009), [x] TLD (H01E), [x] TVT (H01F), [x] NDC (H01L), [x] DMTT (H01M), [x] NMC (E005), [x] TNK (H01P), [x] VDQ (H01S), [x] CLD (H01U).
- [ ] **Yêu cầu User (đợt 2, nhánh `kvct-doi-chieu-2`):** tiếp tục đối chiếu 16 phái còn lại theo thứ tự `CLASS`: TLB (H00L), DTK (H00U), TVC (H00V), DMPD (E006), CBB (H020), NMK (H021), MGC (H022), MGK (H023), DTC (H024), CMC (H025), CMK (H026), HSQ (H027), HSK (H028), TDC (H029), TDK (H02A), TYK (H02B). Cách làm như đợt 1; xong hết thì mở PR vào `main`. Phiên bị ngắt: đọc dòng tiến độ đợt 2 bên dưới.
  - Tiến độ đợt 2: [x] TLB (H00L), [x] DTK (H00U) (thêm khóa 183 vào `kskill.j`: chiêu tung kèm Q/W/E); [x] TVC (H00V); [x] DMPD (E006); [x] CBB (H020); [x] NMK (H021); [x] MGC (H022); [x] MGK (H023); [x] DTC (H024); [x] CMC (H025); [x] CMK (H026); [x] HSQ (H027); [x] HSK (H028); [x] TDC (H029); [x] TDK (H02A); [x] TYK (H02B). Đủ 33 phái đã đối chiếu (đợt 1: 17, đợt 2: 16); còn mở PR. Lưu ý: `tools/ui.py` đang bị sửa dở ngoài phiên này (thiếu `import mpq`) làm `run_pipeline.py` dừng ở ui.py; dùng `scratchpad/run_pipeline_noui.py` để kiểm pjass, không commit ui.py (ghi chú code đọc sẵn ở `scratchpad/notes_<phái>.md`, không commit)

- [ ] **Yêu cầu User (06/10/2026, giữa đợt 2):** *"dùng skill được rồi nhưng ra skill nhìn hoạt ảnh không giống, đôi lúc bị lỗi, không mượt, và game trở nên giật lag hơn, tìm cách để game bớt lag hơn"* (dùng Opus cho phần phức tạp).
  - Việc: phân tích nguyên nhân lag của engine KVCT (`tools/kskill.j`: timer 1/32 s của đạn, quét nhóm mỗi tick, hiệu ứng mỗi lần trúng, số đợt/hit), đề xuất + áp dụng giảm tải (giữ hành vi), ghi kết quả vào mục này. Làm xen kẽ với đối chiếu phái (đợt 2).
  - Kết quả đợt 1 (06/10/2026): Opus đọc code (`scratchpad/lag_report.md`, không commit). Nguyên nhân chính: bóng ảo khi lướt (model tướng nặng mỗi 1/32 s), chiêu nhiều đợt không giới hạn mục tiêu (mỗi địch một hiệu ứng + sự kiện sát thương), mỗi đạn một timer 0,03 s + group tạo / hủy mỗi tick, lướt kích Q W E trên tối đa 7 địch. Đã sửa trong `kskill.j` (chỉ giảm tải, pjass ok 32916 dòng): bóng ảo mỗi 3 bước, chiêu không giới hạn (khóa 259 = 0) tối đa 12 địch mỗi lần (Area / Fly / Field / Toggle / Curse), tối đa 4 hiệu ứng trúng mỗi lần đánh vùng, lướt chỉ kích Q W E trên 3 địch đầu.
  - Đợt 2 giảm lag (theo yêu cầu "làm 1, 4, 7", hiểu là các mục 1 / 4 / 7 của danh sách giải pháp Opus): đạn dùng MỘT timer chung và MỘT group chung (`zzKS_FlyOne`, `zzKS_Fly`, mảng `zzKS_mis` tối đa 399 đạn, id âm trong hashtable; thay `CountUnitsInGroup` bằng bộ đếm trong hashtable); ghi file nhật ký `zzVL_Log` tối đa 1 lần / 3 giây (trước đây mỗi lần tung chiêu ghi file và mỗi giây một lần, mỗi lần ghi file là một cú đứng hình). pjass ok 33067 dòng (kiểm trên worktree sạch từ HEAD vì `gameplay_02/03/08` và `ui.py` đang bị sửa dở ngoài phiên này, làm `run_pipeline.py` lỗi).
  - Chưa làm (cần thử trong game, rủi ro cao hơn): ~~một timer chung cho mọi đạn, group dùng lại~~ (đã làm), AI chỉ tung chiêu gần người chơi, chỉnh tốc độ / scale / độ cao đạn theo KVCT (đạn map nhanh ~2x và to ~2,5x so với `eST` của KVCT), chọn lại model đạn từng chiêu.

- [x] **Yêu cầu User (06/10/2026):** *"riêng phái côn lôn kiếm skill q auto cast tay với đánh thường, w e phải cast tay; phái thiên nhẫn w cast tay"* (ghi đè quy tắc "Q/W/E autocast" cho các phái này).
  - Làm: `MANUAL_QWE` trong `tools/kskill_data.py` (CLK: W, E; TND và TNK: W), `kskill.py` không gán autocast cho các phím đó (thành chiêu bấm), `kskill_list.py` và `docs/kvct_audit.md` cập nhật. Hiểu "thiên nhẫn" = cả Thiên Nhẫn Đao (TND) lẫn Thiên Nhẫn Kích (TNK). pjass ok 32872 dòng.

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

### Hoàn tất tiếp nối (07/10/2026)
- Bảo thạch: tích hợp 54 item (6 loại × 9 bậc), icon lấy trực tiếp từ KVCT, lookup chỉ số/metadata, khảm, nâng bậc tại shop, và drop theo tiến độ game; bỏ nhánh rơi nguyên liệu ghép trang bị.
- Thủy Tinh: chuyển thành điểm cộng trực tiếp, lịch 90/225/825 điểm ở phút 20/30/40, thưởng boss theo cấp, cường hóa +1..+10 theo từng item, không tụt cấp, tỷ lệ và pity theo cấu hình; I00W cũ được đổi sang điểm khi thao tác cường hóa.
- Build staging thành công, pjass pass 37,903 dòng; map: `build/VLTK-GemGlassComplete.w3x` (101,617,667 bytes). Đã đồng bộ `war3map.w3t`, `Scripts/war3map.j` và 54 icon vào `src/map`; không thể đồng bộ `war3map.w3u` do file vẫn bị tiến trình Warcraft khóa. Bản build staging đã chứa dữ liệu cập nhật và đã chép vào `C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\VLTK-GemGlassComplete.w3x` để chạy. Map đã sẵn trong Warcraft III Public Test; chưa khởi chạy ván test trực tiếp.

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
- [ ] (SHOP, 07/10/2026) Vũ khí Tần Lăng: đã viết tools/jass/gameplay_10_shop.j (zzSH_Init/zzSH_OnBuy), config mục 8 (TANLANG_WEAPON_GOLD, TANLANG_SHOP_UNIT), gameplay.py (table/shops); cần móc `ExecuteFunc("zzSH_Init")` vào zzVL_Init, xem docs/trangbi/SHOP_VABAN.md
