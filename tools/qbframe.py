# Khung phẩm chất ô trang bị (hành trang / nhân vật, gameplay_08_ui.j zzVL_MakeSlot): 4 texture viền bo góc có
# quầng sáng mềm, màu sẵn theo phẩm chất (1 Thường trắng, 2 Tốt xanh, 3 Tuyệt tím, 4 Huyền thoại vàng; khớp màu tên).
# Giữa ô trong suốt nên icon không bị che.   python qbframe.py  ->  src\map\VLTK_data\UI\zzQB1..4.blp
import os, sys
from PIL import Image, ImageDraw, ImageFilter

sys.path.insert(0, os.path.dirname(__file__))
from icons import blp1_palette

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(ROOT, "src", "map", "VLTK_data", "UI")
COLORS = {1: (235, 235, 235), 2: (64, 128, 255), 3: (192, 64, 255), 4: (255, 204, 0)}
S = 256           # vẽ to rồi thu về 64 để viền mịn


def frame(rgb):
    w = max(2, S // 28)                              # độ dày viền chính
    r = S // 7                                       # bán kính bo góc
    box = (w, w, S - 1 - w, S - 1 - w)
    glow = Image.new("L", (S, S), 0)                 # quầng sáng mềm phía trong viền
    ImageDraw.Draw(glow).rounded_rectangle(box, r, outline=255, width=w * 3)
    glow = glow.filter(ImageFilter.GaussianBlur(S / 40)).point(lambda a: a * 55 // 100)
    line = Image.new("L", (S, S), 0)                 # viền sắc nét
    ImageDraw.Draw(line).rounded_rectangle(box, r, outline=255, width=w)
    a = Image.new("L", (S, S))
    a.putdata([max(g, l) for g, l in zip(glow.getdata(), line.getdata())])
    hi = tuple(min(255, c + (255 - c) // 2) for c in rgb)   # viền sáng hơn quầng
    im = Image.new("RGBA", (S, S), rgb + (0,))
    px = Image.new("RGBA", (S, S), hi + (0,))
    im = Image.composite(px, im, line)
    im.putalpha(a)
    return im


def main():
    os.makedirs(OUT, exist_ok=True)
    for q, rgb in COLORS.items():
        with open(os.path.join(OUT, "zzQB%d.blp" % q), "wb") as f:
            f.write(blp1_palette(frame(rgb)))
    print("qbframe: %d quality frames -> %s" % (len(COLORS), OUT))


if __name__ == "__main__":
    main()
