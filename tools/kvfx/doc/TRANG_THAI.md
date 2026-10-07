# Model trạng thái gắn lên địch (cấu hình: `STATUS_VFX` trong `tools/config.py`)

Tự sinh bởi `python tools/kvfx_doc.py`. Mỗi trạng thái do đòn đánh / chiêu gây ra sẽ gắn model dưới đây lên địch trong suốt thời gian
trạng thái. Đổi model: sửa `STATUS_VFX`; đổi hình: sửa texture của model trong Retera Model Studio.

| Trạng thái | Model | Lượt chạy | Texture |
|---|---|---|---|
| định thân | `Effect_dinhthan.mdx` | tự lặp | `KVCT3_Data\BoundBuff.BLP` |
| làm chậm | `Effect_dongbang.mdx` | tự lặp | `war3mapImported\AZ_Crack28.blp`, `Textures\Ice3b.blp`, `Textures\Clouds8x8FadeWhite.blp`, `Textures\star5tga.blp` |
| bỏng (nhận thêm 50% sát thương) | `Effect_fire2.mdx` | đặt lại mỗi 1.8 giây | `Textures\WaterBlobs1.blp`, `Textures\White_64_Foam1.blp`, `Textures\Lords0000.blp`, `Textures\Lords0001.blp`, `Textures\Lords0002.blp`, `Textures\Lords0003.blp`, `Textures\Lords0004.blp`, `Textures\Lords0005.blp`, `Textures\Lords0006.blp`, `Textures\Lords0007.blp`, `Textures\Water_Particles.blp`, `Textures\ShockwaveWater1.blp`, `Textures\LavaLump2.blp` |

Trạng thái **choáng** và **thọ thương** vẫn dùng hiệu ứng gốc của game (choáng: Thunderclap trên đầu); thọ thương không có hiệu ứng.
