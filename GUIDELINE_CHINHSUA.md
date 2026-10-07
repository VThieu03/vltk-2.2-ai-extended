# HƯỚNG DẪN CHỈNH SỬA THÔNG SỐ (ATTRIBUTES) CỦA MAP

Dự án này sử dụng Python để sinh ra (generate) các dữ liệu và file code JASS (`.w3u`, `.w3a`, `.j`) trước khi đưa vào bản đồ Warcraft 3. Vì vậy, để chỉnh sửa thông số game, bạn **không nên sửa trực tiếp trong map bằng World Editor**, mà hãy sửa trong các file Python cấu hình.

---

## 1. SỬ DỤNG FILE `config.py` (CÁCH DỄ NHẤT)

Tôi đã tạo sẵn cho bạn một file cấu hình tập trung tại đường dẫn:
👉 **`tools/config.py`**

Trong file này, bạn có thể dễ dàng sửa đổi các thông số cơ bản nhất của game:
- **`HERO_STAT_DIVIDER`**: Hệ số nén chỉ số nhân vật (mặc định = 5). Giảm số này nếu bạn muốn nhân vật mỗi lần lên cấp được cộng nhiều Máu/Mana/Str/Agi/Int hơn.
- **`BOSS_FIRST_SPAWN_MINUTE`** / **`MC_FIRST_SPAWN_MINUTE`**: Thời gian Boss và Võ Lâm Minh Chủ xuất hiện.
- **`WIN_KILLS_REQUIRED`**: Số mạng cần đạt được để win game trong chế độ Đấu trường.
- **`ELITE_DROP_MAX_TIER`** / **`BOSS_DROP_MAX_TIER`**: Bậc (Tier) của đồ rơi ra từ các loại quái/Boss.

**Cách áp dụng sau khi sửa:**
1. Mở file `tools/config.py` bằng Notepad, VSCode hoặc bất kỳ trình soạn thảo nào.
2. Đổi các con số bạn muốn và Lưu (Save) lại.
3. Chạy lệnh pipeline để tự động build lại map: 
   ```bash
   python scratchpad/run_pipeline_noui.py
   ```

---

## 2. CHỈNH SỬA SÂU HƠN (ADVANCED)

Nếu bạn muốn thay đổi các thuộc tính phức tạp hơn chưa có trong `config.py`, dưới đây là danh sách các file quản lý tương ứng:

### A. Chỉnh sửa Kỹ Năng Nhân Vật (Dame, Cooldown, Mana)
- File liên quan: **`tools/skills.py`** và **`tools/kskill_data.py`**
- Hầu hết các kỹ năng từ Kiếm Vũ Chí Tôn được lưu dữ liệu cơ bản tại `kskill_data.py`. Bạn có thể chỉnh sửa ID chiêu thức, loại hình (ví dụ: nội công, sát thương vật lý) tại đây.
- *Lưu ý:* Việc tính toán sát thương chiêu thức (damage) thường được tính thông qua JASS Engine của KVCT (Damage Engine). Nếu muốn thay đổi công thức sát thương tổng thể, bạn cần sửa ở `tools/jass/gameplay_04_combat.j`.

### B. Chỉnh sửa Trang Bị và Option (Dòng random đồ Diablo)
- File liên quan: **`tools/gameplay.py`** và **`tools/gameplay_items.py`**
- Hàm `items()` trong `gameplay_items.py` quy định tất cả các Option ngẫu nhiên (sát thương, hút máu, bạo kích, ngũ hành) mà trang bị có thể sở hữu khi rơi ra.
- Nếu bạn muốn thêm dòng mới hoặc tăng cường chỉ số của dòng đồ (ví dụ đồ hệ Hỏa sát thương cao hơn), hãy sửa logic trong `gameplay_items.py`.

### C. Chỉnh sửa Quái Vật (Máu, Giáp, Rớt đồ)
- File liên quan: **`tools/expand.py`** và **`tools/import_boss.py`**
- `expand.py` là nơi sinh ra các bãi quái farm trên bản đồ.
- `import_boss.py` điều chỉnh các Boss và Tuyệt Đại Cao Thủ. 

---

## TỔNG KẾT
Mọi sự thay đổi (dù bạn làm ở file Python nào) đều yêu cầu chạy lại file `run_pipeline_noui.py` để công cụ dịch thông số vào mã nguồn JASS và tạo ra file map `.w3x` cuối cùng.

Chúc bạn custom map vui vẻ!
