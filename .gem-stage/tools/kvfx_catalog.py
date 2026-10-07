# Ghi DANH MỤC model + texture của một phái vào file cấu hình sửa tay tools/kvfx/hand/<PHÁI>.py (dạng chú thích), để người sửa
# nhìn thấy ngay chiêu nào dùng model / texture nào và sửa ngay trong file đó. Phần do tay viết trong file được giữ nguyên:
# chỉ đoạn nằm giữa hai dòng BEGIN / END bị ghi đè mỗi lần chạy.
import os

HERE = os.path.dirname(os.path.abspath(__file__))
BEGIN = "# ===== DANH MỤC MODEL + TEXTURE (tự sinh bởi kvfx_doc.py; chỉ đoạn giữa hai dòng này bị ghi đè) ====="
END = "# ===== HẾT DANH MỤC ====="
HELP = [
    "# Đọc danh mục này để biết chiêu nào đang dùng model / texture nào. Muốn đổi:",
    '#   - đổi model:   thêm vào VFX mục của chiêu, ví dụ  "Tên chiêu": {"main": "X.mdx", "cast": "Y.mdx", "target": "Z.mdx", "area": ["W.mdx"], "scale": 1.5}',
    '#   - đổi texture: thêm vào TEXTURES, ví dụ  "model.mdx": {"texture_cu.blp": "Textures\\\\Flame4.blp"}',
    "#     (áp cho model đó ở MỌI chiêu và MỌI phái dùng nó; texture mới là texture của game hoặc nằm trong KVCT)",
    "# Sửa xong chạy lại pipeline (scratchpad/run_pipeline.py) để áp dụng.",
]


def write_catalog(cl, cat):
    path = os.path.join(HERE, "kvfx", "hand", cl + ".py")
    block = "\n".join([BEGIN] + HELP + cat + [END])
    if os.path.exists(path):
        text = open(path, encoding="utf-8").read()
    else:
        text = (
            "# %s: BẢNG SỬA TAY (thắng bảng tự sinh trong tools/kvfx/auto/%s.py). Sửa file này rồi chạy lại pipeline.\n"
            "VFX = {\n}\n" % (cl, cl)
        )
    if "\nTEXTURES" not in text and not text.startswith("TEXTURES"):
        text = text.rstrip("\n") + "\n\n# Đổi texture của model (xem danh mục bên dưới).\nTEXTURES = {\n}\n"
    if BEGIN in text and END in text:
        a = text.index(BEGIN)
        b = text.index(END) + len(END)
        text = text[:a] + block + text[b:]
    else:
        text = text.rstrip("\n") + "\n\n" + block + "\n"
    open(path, "w", encoding="utf-8").write(text)
