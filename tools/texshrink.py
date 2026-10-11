# Thu nhỏ texture hiệu ứng KVCT (thư mục KVCT3_Data) để Warcraft 1.31 bản 32-bit không hết bộ nhớ giữa trận
# (crash "Not enough memory resources" phút 27, 10/10/2026: 2832 texture ~570 MB khi giải nén, 226 texture 512/1024 px
# của KVCT3_Data chiếm ~350 MB). Cạnh dài nhất > TEX_MAX_SIDE thì thu về TEX_MAX_SIDE (giữ tỉ lệ, lũy thừa 2).
# Chạy lại không thu nhỏ thêm. Bản gốc đầy đủ: D:\KVCT31_Data\KVCT3_Data (tools/cleanup_kvct3_data.py).
#   python texshrink.py
import io, os, struct, sys
from PIL import Image

sys.path.insert(0, os.path.dirname(__file__))
import config
from kskill import kv_image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
MAX = getattr(config, "TEX_MAX_SIDE", 256)


def blp1_rgba(im):
    """BLP1 256 màu + alpha 8 bit, đủ chuỗi mipmap, mọi kích thước lũy thừa 2 (blp1_palette của icons.py chỉ làm ô vuông)."""
    w, h = im.size
    pal_img = im.convert("RGB").quantize(256, method=Image.Quantize.MEDIANCUT)
    pal = pal_img.getpalette()[:768]
    pal += [0] * (768 - len(pal))
    palette = b"".join(struct.pack("<4B", pal[3 * i + 2], pal[3 * i + 1], pal[3 * i], 0) for i in range(256))
    mips = []
    while True:
        m = im if (w, h) == im.size else im.resize((w, h), Image.LANCZOS)
        mips.append(m.convert("RGB").quantize(palette=pal_img, dither=Image.Dither.NONE).tobytes() + m.getchannel("A").tobytes())
        if (w, h) == (1, 1) or len(mips) == 16:
            break
        w, h = max(1, w // 2), max(1, h // 2)
    offs, sizes, pos = [], [], 4 + 4 * 6 + 64 + 64 + len(palette)
    for d in mips:
        offs.append(pos)
        sizes.append(len(d))
        pos += len(d)
    offs += [0] * (16 - len(offs))
    sizes += [0] * (16 - len(sizes))
    return (b"BLP1" + struct.pack("<6I", 1, 8, im.size[0], im.size[1], 4, 1) + struct.pack("<16I", *offs)
            + struct.pack("<16I", *sizes) + palette + b"".join(mips))


def shrink(path):
    data = open(path, "rb").read()
    if data[:4] != b"BLP1":
        return 0
    w, h = struct.unpack_from("<2I", data, 12)
    if max(w, h) <= MAX:
        return 0
    im = kv_image(data) if struct.unpack_from("<I", data, 4)[0] == 0 else Image.open(io.BytesIO(data)).convert("RGBA")
    k = max(w, h) // MAX
    im = im.resize((max(1, w // k), max(1, h // k)), Image.LANCZOS)
    out = blp1_rgba(im)
    open(path, "wb").write(out)
    return len(data) - len(out)


def main():
    n = saved = 0
    for dp, dn, fn in os.walk(SRC):
        if os.path.basename(dp).lower() != "kvct3_data":
            continue
        for f in fn:
            if f.lower().endswith(".blp"):
                s = shrink(os.path.join(dp, f))
                if s:
                    n += 1
                    saved += s
    print("texshrink: %d texture KVCT3_Data thu về <= %d px (file nhỏ đi %d KB)" % (n, MAX, saved // 1024))


if __name__ == "__main__":
    main()
