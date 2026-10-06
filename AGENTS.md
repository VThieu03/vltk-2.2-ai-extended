# QUY TẮC BẮT BUỘC DÀNH CHO MỌI AI AGENT TRONG DỰ ÁN

> **QUAN TRỌNG NHẤT (ĐỌC ĐẦU TIÊN TRƯỚC KHI LÀM BẤT KỲ VIỆC GÌ):**
> 1. **BẮT BUỘC ĐỌC FILE `WORKLOG.md`**: Mọi AI agent khi nhận nhiệm vụ mới hoặc bắt đầu phiên làm việc mới **BẮT BUỘC** phải đọc file [WORKLOG.md](file:///d:/vltk-2.2-ai-extended/WORKLOG.md) đầu tiên để nắm bức tranh toàn cảnh, tiến độ hiện tại và danh sách công việc đang làm.
> 2. **CƠ CHẾ PHÒNG NGỪA HẾT TOKEN / NGẮT PHIÊN**:
>    - Mỗi khi Người Dùng (User) yêu cầu làm một chức năng hoặc nhiệm vụ mới, **trước khi trả lời hay code sâu**, AI agent phải **tóm tắt nhanh yêu cầu đó vào mục "ĐANG LÀM / VỪA ĐƯỢC YÊU CẦU" của `WORKLOG.md`**.
>    - Điều này đảm bảo nếu bị cạn token giữa chừng, rớt mạng hoặc sang phiên mới, AI agent tiếp theo chỉ cần mở `WORKLOG.md` là biết ngay việc đang làm dở mà không bị mất dấu hay hỏi lại User.
> 3. **BẢO VỆ DỮ LIỆU & PIPELINE BUILD**:
>    - Khi sửa code, chỉ thêm/mở rộng logic, KHÔNG ghi đè làm mất mô tả trang bị ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]").
>    - Giữ nguyên ghi công tác giả: vnakira; icon KVCT: Silva.Fox.
>    - Sau khi sửa JASS/Python, phải chạy qua pipeline kiểm tra pjass đạt 100% không có lỗi cú pháp.

---

## TỔNG QUAN BỨC TRANH DỰ ÁN (PROJECT BIG PICTURE)

### 1. Mục tiêu dự án
* Hiện đại hóa và mở rộng map Warcraft III: **Võ Lâm Truyền Kỳ v2.2 AI 1.31** (`Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`).
* Kết hợp tài nguyên kỹ năng, mô hình và hiệu ứng từ **Kiếm Vũ Chí Tôn (KVCT)** (tác giả Silva.Fox).
* Tái cấu trúc thành game RPG hành động có chiều sâu:
  - Hệ thống 33 môn phái (21 phái VLTK gốc + 12 phái mới từ KVCT).
  - Hệ thống 400 kỹ năng đặc sắc từ KVCT (học theo cấp 1-200, bỏ hệ thống độ luyện rườm rà).
  - Hệ thống trang bị ngẫu nhiên Diablo-style (22 dòng chỉ số, 12 loại bảo thạch khảm, cường hóa theo ô giữ nguyên khi thay trang bị).
  - Tối ưu AI máy, nhịp độ trận đấu, giao diện UI ngọc bích, hiển thị chỉ số chi tiết.

### 2. Kiến trúc mã nguồn & Pipeline
* **Mã nguồn JASS chính**: Đã được module hóa từ `gameplay.j` khổng lồ thành 8 module rõ ràng trong thư mục `tools/jass/`:
  - `gameplay_01_core.j`: Hằng số, hàm tiện ích, cấu trúc dữ liệu cơ bản.
  - `gameplay_02_farm.j`: Quái rừng, bãi farm, kinh nghiệm, tốc độ hồi quái theo thời gian.
  - `gameplay_03_tranphai.j`: Kỹ năng trấn phái (cấp 15, phím T).
  - `gameplay_04_combat.j`: Damage Engine, kháng 5 hệ, né tránh, chính xác, bạo kích, hút máu.
  - `gameplay_05_quests.j`: Nhiệm vụ, Xa phu, Dã Tẩu, Boss Diệp Thanh.
  - `gameplay_06_events.j`: Đấu trường, Liên Đấu, Lôi Đài, điều kiện thắng mạng (-win).
  - `gameplay_07_ai.j`: Trí tuệ nhân tạo (AI hero farm, mua sắm đồ, tung chiêu).
  - `gameplay_08_ui.j`: Hệ thống hành trang (B), bảng nhân vật 22 chỉ số (C), auto-sell, thông báo.
* **Pipeline Build**: Khi sửa đổi, chạy các tool theo thứ tự:
  `convert_text` -> `fix_script` -> `expand` -> `skills` -> `tranphai` -> `import_boss` -> `lvl200` -> `gameplay` -> `describe` -> `icons` -> `vfx` -> `ui` -> `scale` -> `build`.
* **Kỹ năng KVCT**:
  - `tools/kskill_data.py`: Dữ liệu 33 phái, id kỹ năng, loại chiêu thức.
  - `tools/kskill.py` & `tools/kskill.j`: Bộ máy sinh và thực thi logic kỹ năng KVCT vào game.
  - `tools/kaudit.py` & `docs/kvct_audit.md`: Công cụ đối soát tính năng kỹ năng đã làm / chưa làm.

### 3. Quy trình làm việc khi nhận việc từ User
1. Đọc [WORKLOG.md](file:///d:/vltk-2.2-ai-extended/WORKLOG.md).
2. Ghi vắn tắt mục tiêu User vừa yêu cầu vào `WORKLOG.md` (mục "Đang làm / Vừa được yêu cầu").
3. Thực hiện sửa đổi, kiểm tra tính toàn vẹn (pjass pass 100%, không xung đột code).
4. Cập nhật lại kết quả vào `WORKLOG.md` sau khi hoàn thành.
