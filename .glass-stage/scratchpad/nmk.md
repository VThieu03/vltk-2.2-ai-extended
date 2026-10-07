### Nga My Kiếm (NMK) — đã đối chiếu code KVCT (06/10/2026)

Nguồn: `readable.j` (bảng `set Kuz[oY]="NMK"`; Q `J30`/`JKi`/`JKQ`, W `eqw`/`eqv`/`eqV`, E `ed9`/`ede`/`edf`, R `Jfq`/`Jf6`, D `J0r`/`J0S`, Phật Tâm Từ Hựu `Jet`/`Jer`/`Jeq`, bị động `Jd8`, mật tịch `JlJ`), `AbilityData.slk`. Bảng kỹ năng theo KVCT: 13 chiêu. Trước đây Q 2 đạn, W 3 đạn, E 5 đạn đều có số đợt đúng nhưng không có tầm / giãn cách / số mục tiêu / chậm; R và D là buff 20 giây; các bị động đều là chỉ số đoán theo mô tả.

Khác biệt chung: sát thương theo công thức của map; chỉ số bị động / buff theo thang của map; trạng thái của Q / W / E là làm chậm.

| Chiêu | Phím | Cơ chế trong KVCT (code) | Map làm gì | Trạng thái |
|---|---|---|---|---|
| Thôi Song Vọng Nguyệt | Q (autocast) | 2 đạn cách 0,2 giây bay 600 (rộng 100) xuyên, tối đa 7 mỗi đạn; 30% chậm 2 giây | 2 đạn cách 0,2 giây bay 600, xuyên, tối đa 7; 30% chậm 2 giây | Giống |
| Từ Hàng Phổ Độ | R | Vùng cố định tại chỗ bán kính 500: mỗi đồng minh (tướng) nhận 4 lần hồi, mỗi giây một lần, (6 + 1/cấp)% sinh lực tối đa của người tung; 4 giây, giãn cách 8 giây | Buff phe ta: hồi một lần (10 + 2/cấp)% sinh lực tối đa của người nhận | Gần giống (hồi một lần thay vì 4 lần; bán kính 1000 của engine; hồi theo sinh lực người nhận) |
| Thiên Phật Thiên Diệp | D | Mọi tướng phe ta trong 1000 (đồng đội 60%), 1200 giây: hiệu quả của Mộng Điệp, Phật Tâm, Ba La, Thanh Âm, Thanh Tâm (mỗi cái không vượt cấp D) | Buff phe ta 1200 giây: giảm sát thương nhận + sinh lực tối đa | Gần giống (gộp thành 2 chỉ số, không tách từng hiệu quả) |
| Mộng Điệp | - | Qua D: hồi phục sinh lực / nội lực %; bản thân: băng công % | Bị động: sát thương % | Gần giống (không có hồi phục) |
| Phật Tâm Từ Hựu | - | Qua D: sinh lực / nội lực tối đa %; bị đánh thường khi sinh lực ≤40%: hồi 100% sinh lực, miễn trạng thái 3,8 + 0,2/cấp giây, giãn cách 45 giây | Sinh lực tối đa; sinh lực dưới 40%: hồi 100%, 4 giây miễn khống chế, giãn cách 45 giây | Gần giống (không phải điều kiện "bị đánh thường"; chưa có miễn sát thương nếu code có) |
| Ba La Tâm Kinh | - | Qua D: kháng tất cả; bản thân: phát huy lực tấn công, tỉ lệ chậm | Bị động: sát thương %, kháng trạng thái | Gần giống |
| Kiếm Ảnh Phật Quang | W (autocast) | 3 đạn cách 0,15 giây bay 900 (rộng 165) xuyên, tối đa 7 mỗi đạn; 35% chậm 2 giây | 3 đạn cách 0,15 giây bay 900, xuyên, tối đa 7; 35% chậm 2 giây | Giống |
| Thanh Âm Phạn Xướng | - | Qua D: kháng thời gian trạng thái | Bị động: kháng trạng thái | Gần giống |
| Thanh Tâm Tịnh Khí | - | Qua D: chịu sát thương chí mạng −%; bản thân: kháng chí mạng | Bị động: giảm sát thương nhận | Gần giống |
| Liên Hoa Tâm Kinh | - | Bị động: tốc đánh, băng công %, phát huy lực tấn công | Bị động: tốc đánh + sát thương % | Giống |
| Băng Sương Điện Phóng | E (autocast) | 5 kiếm tỏa hình sao (0, ±72, ±144°), kiếm đổi hướng một lần về phía mục tiêu rồi bay thẳng, tổng ~1080 (rộng 150), tối đa 7 mỗi kiếm; 40% chậm 2 giây | Quạt 5 đạn (góc 10°) bay 1080, xuyên, tối đa 7; 40% chậm 2 giây | Gần giống (không tỏa hình sao rồi quay lại, đạn xếp quạt hẹp) |
| Độ Nguyên Công | - | Nội công, sinh khí; E: +(10 + 2/cấp)% sát thương và hút 5% sinh lực | Sinh lực tối đa; E hút 5% sinh lực | Gần giống (chưa có +% sát thương của E) |
| Bế Nguyệt Phất Trần | - | Bị động: sát thương hệ Hỏa, vật công nội, tốc đánh, chí mạng | Bị động: tốc đánh + chí mạng | Gần giống (không có hệ Hỏa / vật công nội) |

Mật tịch của KVCT chưa làm: khi chịu sát thương chí tử hủy sát thương và hồi 50% sinh lực (giãn cách 300 giây), mỗi 5 giây hồi 8% sinh lực + nội lực.
