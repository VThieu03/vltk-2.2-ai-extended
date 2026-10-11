# Làm mới work\orig (bản gốc rời file mà convert_text.py và expand.py luôn đọc) từ work\base.w3x sau khi sửa
# địa hình / doodad bằng World Editor. work\orig KHÔNG tự đồng bộ với base.w3x: pipeline chỉ đọc, không ghi nó.
#   1. Mở work\base.w3x bằng World Editor, sửa địa hình / doodad, Save (CTRL+S) - lưu đè chính file này.
#   2. python tools\refresh_orig.py
#   3. python tools\pipeline.py  (--no-ui nếu muốn bỏ bước ui) - địa hình mới sẽ nằm trong mọi bản build sau này.
# Dùng work\listfile.txt (danh sách tên file trong base.w3x, tools\listfile.py sinh ra) để biết cần trích file nào.
import os, sys

sys.path.insert(0, os.path.dirname(__file__))
from mpq import MPQ

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE = os.path.join(ROOT, "work", "base.w3x")
LISTFILE = os.path.join(ROOT, "work", "listfile.txt")
OUT = os.path.join(ROOT, "work", "orig")
OFF = 512


def main():
    archive = MPQ(BASE, OFF)
    names = [line.strip() for line in open(LISTFILE, encoding="utf-8", errors="ignore") if line.strip()]
    written = skipped = 0
    for name in names:
        data = archive.read(name)
        if data is None:
            skipped += 1
            continue
        path = os.path.join(OUT, *name.replace("/", "\\").split("\\"))
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wb") as f:
            f.write(data)
        written += 1
    print("refresh_orig: %d file chép từ %s vào %s (%d tên trong listfile không có trong archive)" % (
        written, BASE, OUT, skipped))


if __name__ == "__main__":
    main()
