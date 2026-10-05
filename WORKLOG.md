# Nhật ký công việc - VLTK v2.2 AI 1.31 (bản clone)

Thư mục làm việc: `D:\vltk-dev-clone`
Bản đồ trong game: `Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x`
Nhật ký trong game: `CustomMapData\VLTK\log.txt`
Build: `tools\` chạy lần lượt convert_text, fix_script, expand, skills, tranphai, import_boss, lvl200, gameplay, describe, icons, vfx, ui, scale, build rồi chép vào Maps (tắt game trước khi chép).
**Lưu ý khi sửa (cho cả Gemini):** sửa describe.py / gameplay.j bằng cách thêm vào, không chép đè file cũ; chạy đủ pipeline và kiểm tra mô tả còn dòng "Ngũ hành vũ khí", "Tiến cử", "[Khảm]".
Giữ ghi công tác giả: vnakira; icon KVCT: Silva.Fox.

## Đang làm / còn mở

| # | Yêu cầu | Trạng thái |
|---|---|---|
| 1 | Game bị treo (đứng hình) giữa trận | **Chưa sửa xong.** Treo ở 8:32 và 13:02, cả hai lần vài giây sau khi tướng chết trong Liên Đấu; ngay trước đó thường có chiêu "Tứ Tượng Đồng Quy". Lần 3 treo ở 8:45 ngay sau skill trấn phái Duy Ngã Độc Tôn (A0T1); mã skill này không có vòng lặp, chưa rõ. Đã thêm log mỗi giây ("tick") + log dọn đồ đất, vòng nhật ký 80 dòng. Chờ test tiếp. |
| 2 | Tooltip trang bị không hiện trong cửa hàng và 6 ô | Chưa sửa (có thể do cài đặt game). |
| 3 | Đưa tướng Thiên Kiếm (bộ kỹ năng gốc) vào VLTK | Tạm dừng, chờ chọn tướng (đề xuất Minh Giáo Chùy). |
| 5 | Bê bộ kỹ năng KVCT cho cả 21 tướng (học theo cấp 1-200, bỏ độ luyện) | Đang làm. |
| 4 | Map Thiên Kiếm + AI kiểu VLTK (farm theo level, Xa Phu, nhiệm vụ) | Tạm dừng; bản build "không chạy được", chờ biết lỗi cụ thể. |

## Đã làm trong phiên này (chưa thử trong game)

- Bê kỹ năng KVCT: Đã làm phái Cái Bang Chưởng (CBC). Chuyển Thời Thừa Lục Long (A0ED) và Triệt Y Thập Bát Điệt (A0X5) thành buff bản thân (kind 6) với chỉ số thực tế từ code KVCT (sát thương % và công cơ bản). Build pjass pass.
- Bê kỹ năng KVCT: Đã làm phái Võ Đang Khí (VDQ - H01S). Chuyển Tọa Vọng Vô Ngã (A0JO) thành buff (kind 6, giảm 18%+3%/cấp sát thương, duy trì 300s). Thuần Dương Vô Cực (A0JP) thành hộ thuẫn (kind 9, duy trì 20s). Vạn Kiếm Quy Tông (A0JS) thành nổ quanh thân phạm vi 1000 (khuôn mới kind 12).
- Bê kỹ năng KVCT: Đã làm phái Võ Đang Kiếm (VDK - E001). Cập nhật Lưu Tinh Cản Nguyệt (A0KG) thành kỹ năng lướt (kind 3). Lưỡng Nghi Kiếm Pháp (A0KH) nổ quanh thân 40 lần (kind 4). Tử Tiêu Hoành Vân (A0XM) nổ làm chậm địch (kind 4, status 4).
- Bê kỹ năng KVCT: Đã làm phái Thúy Yên Đao (TYD - E002). Mục Dã Lưu Tinh (A0CD) phóng đao (kind 2). Ngự Tuyết Ẩn (A0CE) thêm tàng hình (kind 6, status 5 - Wind Walk).
- Thêm phái mới từ KVCT: Đã tạo thêm **12 nhân vật phái mới hoàn toàn** để map VLTK giờ đây có đủ **33 phái** (tổng hợp đầy đủ mọi nhánh của Kiếm Vũ Chí Tôn / Kiếm Thế). Các phái thêm mới bao gồm:
  + Cổ Mộ Châm (CMC), Cổ Mộ Kiếm (CMK)
  + Hoa Sơn Khí (HSQ), Hoa Sơn Kiếm (HSK)
  + Tiêu Dao Chưởng (TDC), Tiêu Dao Kiếm (TDK)
  + Thúy Yên Song Đao (TYK)
  + Cái Bang Bổng (CBB), Nga My Kiếm (NMK)
  + Minh Giáo Chùy (MGC), Minh Giáo Kiếm (MGK)
  + Đoàn Thị Chỉ (DTC)
  Tất cả đã được gán model chuẩn xác từ file gốc, gắn vũ khí đúng loại và liên kết vào hệ thống NPC ngũ hành. Engine dịch kỹ năng đã import tự động toàn bộ 400 kỹ năng cho 33 hero này!
- Tăng kinh nghiệm và nhịp độ game: Rút ngắn timeline đạt cấp 200 từ 38 phút xuống còn 20 phút. Tăng giới hạn HandicapXP lên tối đa x15 (1500%) để người chơi dễ dàng đuổi kịp nhip độ.
- Quái mạnh dần theo thời gian: Quái rừng sinh ra sẽ được nhân máu và sát thương theo thời gian thực (hệ số = `0.6 + TimerGetElapsed / 600.`), nghĩa là cứ mỗi 10 phút quái sẽ mạnh thêm 100% so với gốc để tạo thử thách khi hero lên cấp nhanh.
- Điều kiện chiến thắng (Endgame): Mặc định đội nào đạt 150 mạng (hero kills) trước sẽ thắng. Người chơi có thể gõ lệnh `-win 100`, `-win 200`... để đổi mốc mạng.
- Nhấn Tab (OSKEY_TAB) để xóa chữ thông báo trên màn hình (ClearTextMessages cho LocalPlayer).
- Hiệu ứng skill thay đồng loạt bằng model KVCT (tools\vfx.py), texture KVCT3_Data nhúng vào map.
- UI (tools\ui.py + gameplay.j): bảng hành trang nền ngọc, nút tròn Hành Trang (B) / Nhân Vật (C), bảng Nhân Vật, khung đồng hồ / tỉ số, băng thông báo boss / Liên Đấu, icon ngân lượng / KNB / công / thủ.
- Bảng chỉ mục MPQ nới 1024 -> 2048 (mpqwrite.py) để chứa thêm file.

- Khôi phục mô tả trang bị (chỉ số, khảm, ngũ hành vũ khí, tiến cử, Yêu cầu) bị mất khi describe.py bị ghi đè lúc 20:19; giữ tên mới theo cấp của Gemini. Bản describe.py trước khi khôi phục: scratchpad\describe_gemini_backup.py.

- Phóng to toàn bộ map x1.5 (tools\scale.py, chạy sau icons, trước build): 168x128 -> 252x192 ô; địa hình, đường đi, bóng, cây/nhà, đơn vị đặt sẵn, vùng, camera, tọa độ trong script.
- Chậm nhịp game: kinh nghiệm người chơi x1.6 -> x0.9, máy x2.5 -> x1.3; vàng thêm cho máy +10 -> +4 mỗi giây.

- Hành trang: nguyên liệu/vật phẩm không phải trang bị cộng dồn thành 2, 3, 4...
- Dọn đồ rơi: cứ 60 giây quét, đồ nằm đất 1-2 phút bị xóa (kể cả gần quái/tướng); nhặt lên thì tính lại thời gian.
- Nút **Tự bán** trong hành trang: đồ rơi nhặt được mạnh hơn thì tự mặc và bán đồ cũ, yếu hơn thì tự bán; đồ đã khảm, đồ mua, phi phong không bị bán.
- **Tài phú** cho trang bị: cấp đồ x100 + chỉ số % ngẫu nhiên + 40 mỗi lỗ khảm; hiện trong mô tả và hành trang. Cường hóa không tính (đi theo ô).
- Nhật ký: ghi file ngay mỗi sự kiện, ghi tên người dùng chiêu, báo khi hơn 400 lần sát thương / 2 giây.

## Đã làm trước đó

- Boss Thiên Kiếm (Diệp Thanh thay h01D), phóng to, dời chỗ xuất hiện.
- Skill trấn phái (lấy từ Thiên Kiếm), mở ở cấp 15, phím T.
- Set đồ cơ bản + 10 bình thuốc đầu game; thuốc hồi cả máu và mana, cấp dùng 1/10/20/30/40, không mất khi bị đánh.
- Drop: mỗi loại trang bị tối đa 5 lần; nguyên liệu rơi đều, không giới hạn; bỏ rơi Bí Phổ.
- Hành trang: cộng dồn, tách, bán tại chỗ; nút đang dùng sáng lên, bấm lại để tắt; tự nhặt vào hành trang khi 6 ô đầy.
- Khảm: 2 lỗ, mỗi nguyên liệu một thuộc tính, không đè thuộc tính cũ.
- Cường hóa theo ô (giữ khi đổi đồ), cộng chỉ số gốc theo cấp đồ, đổi icon theo cấp; dùng Thủy tinh ngay trong hành trang.
- Tàng Bảo Các bán nguyên liệu 4000; giáp trụ / vũ khí bán đồ chế 5000, cần đủ nguyên liệu (hành trang, 6 ô, Thủ Khố); dòng "Yêu cầu"; thêm trang khi cửa hàng đầy.
- Chỉ số: sức mạnh -> máu + hồi máu; thân pháp -> né + tốc đánh; nội lực -> mana + hồi mana.
- Ngũ hành vũ khí (+8% sát thương): Mộc độc, Thổ choáng, Kim kháng + máu, Hỏa đốt, Thủy làm chậm + hồi phục; vũ khí có dòng tiến cử phái.
- Sát thương skill không còn tính theo máu.
- AI: mỗi tướng tối đa 1 món mỗi loại; bỏ AI tự mua đồ đầu game.
- Chọn tướng qua 5 NPC ngũ hành (không cần đứng gần).
- Đấu trường Thiên Kiếm ghép vào map; đấu trường cũ thành Lôi Đài.
- Đồng hồ trận góc trái, tỉ số giết/chết góc phải.
- Sửa icon xanh, đồ không bị xóa sau 1 phút, đầu game farm dễ hơn.

### Roadmap (Đề xuất của User)
- Viết lại toàn bộ hệ thống trang bị: Rơi đồ có chỉ số random (min/max opt) giống Diablo/Kiếm Thế.
- Bổ sung các chỉ số RPG nâng cao (Hút máu, Tỉ lệ chí mạng, Bỏ qua né tránh, Sát thương ngũ hành...) và tích hợp vào Damage Engine.
