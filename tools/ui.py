# Interface in the style of VLKT (Silva.Fox): textures for the panels (jade frame), the round Hanh Trang /
# Nhan Vat buttons (labels redrawn for this map's keys), gold / Kim Nguyen Bao / attack / armor / attribute
# icons of the console (war3mapSkin.txt). Textures are re-saved as BLP with power-of-two sides (the 1.31
# game shows other sizes as green squares). Run after vfx.py.
import io, os, re, sys
sys.path.insert(0, os.path.dirname(__file__))
from PIL import Image, ImageDraw, ImageFont
from icons import blp1_palette
from tcvn3 import _T

TCVN3 = {v: chr(k) for k, v in _T.items()}                # VNVOGU is a TCVN3 font

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
FONT = os.path.join(ROOT, "work", "VNVOGU.TTF")
VLKT_TOOLS = r"D:\vlkt-dev\tools"
VLKT = r"D:\vlkt-dev\work\base.w3x"
VLKT_OFF = 106496
VLKT_SRC_DL = os.path.join("D:" + chr(92), "vlkt-dev", "src", "map", "dl")
I = "war3mapImported\\"
# VLKT texture -> (our name, side)
TEX = {
    "FrameUI_AT.blp": ("vl_ui_panel", 256),
    "FrameUI_daquytrong.blp": ("vl_ui_tile", 32),
    "UIButton_bac.tga": ("vl_ui_gold", 128),
    "UIButton_kim.tga": ("vl_ui_knb", 128),
    "ATTUIButton_HeroAttack.blp": ("vl_ui_atk", 64),
    "ATTUIButton_HeroDefense.blp": ("vl_ui_def", 64),
    "ATTUIButton_HeroAttribute.blp": ("vl_ui_attr", 64),
}
BUTTONS = {"FrameButtonIcon_hanhtrang.tga": ("vl_ui_bag", "Hành Trang (B)"),
           "FrameButtonIcon_nhanvat.tga": ("vl_ui_hero", "Nhân Vật (C)")}
SKIN = {
    "GoldIcon": "vl_ui_gold", "LumberIcon": "vl_ui_knb",
    "InfoPanelIconDamageNormal": "vl_ui_atk", "InfoPanelIconDamageNormalNeutral": "vl_ui_atk",
    "InfoPanelIconDamageHero": "vl_ui_atk", "InfoPanelIconDamageHeroNeutral": "vl_ui_atk",
    "InfoPanelIconArmorHero": "vl_ui_def", "InfoPanelIconArmorHeroNeutral": "vl_ui_def",
    "InfoPanelIconArmorNormal": "vl_ui_def", "InfoPanelIconArmorNormalNeutral": "vl_ui_def",
    "InfoPanelIconHeroIconSTR": "vl_ui_attr", "InfoPanelIconHeroIconAGI": "vl_ui_attr",
    "InfoPanelIconHeroIconINT": "vl_ui_attr",
}


def vlkt():
    sys.path.insert(0, VLKT_TOOLS)
    import importlib
    for k in [k for k in sys.modules if k == "mpq"]:
        del sys.modules[k]
    mpq = importlib.import_module("mpq")
    sys.path.pop(0)
    del sys.modules["mpq"]
    return mpq.MPQ(VLKT, VLKT_OFF)


def image(m, name):
    r = m.find((I + name).encode("utf-8").decode("latin1"))
    from kskill import kv_image
    return kv_image(m.read_block(r[1], I + name))


def save(name, im, side):
    p = os.path.join(SRC, "war3mapImported", name + ".blp")
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "wb").write(blp1_palette(im, side))


def relabel(im, text):
    """the VLKT button has its key in the label strip at the bottom: paint the strip again with ours"""
    im = im.resize((128, 128), Image.LANCZOS)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 90, 127, 118), fill=(10, 10, 10, 235))
    f = ImageFont.truetype(FONT, 17)
    text = "".join(TCVN3.get(c, c) for c in text)
    w = d.textlength(text, font=f)
    d.text(((128 - w) / 2, 93), text, font=f, fill=(255, 255, 255, 255), stroke_width=1, stroke_fill=(0, 0, 0, 255))
    return im


def main():
    m = vlkt()
    for src, (name, side) in TEX.items():
        save(name, image(m, src), side)
    for src, (name, text) in BUTTONS.items():
        save(name, relabel(image(m, src), text), 128)
    p = os.path.join(SRC, "war3mapSkin.txt")
    s = open(p, "rb").read().decode("utf-8")
    nl = "\r\n" if "\r\n" in s else "\n"
    for k, v in SKIN.items():
        line = "%s=%s%s.blp" % (k, I, v)
        if re.search(r"(?m)^%s=" % k, s):
            s = re.sub(r"(?m)^%s=[^\r\n]*" % k, line.replace("\\", "\\\\"), s)
        else:
            s = s.replace("[CustomSkin]" + nl, "[CustomSkin]" + nl + line + nl, 1)
    open(p, "wb").write(s.encode("utf-8"))
    # background music of KVCT (played by gameplay.j zzVL_Music)
    sys.path.insert(0, os.path.dirname(__file__))
    import vfx
    d = vfx.read(vfx.vlkt(), "Sound" + chr(92) + "snd_background.mp3")
    if d[:3] == b"ID3":                                   # drop the ID3 tag, keep the MPEG frames
        d = d[10 + ((d[6] << 21) | (d[7] << 14) | (d[8] << 7) | d[9]):]
    open(os.path.join(SRC, "war3mapImported", "vl_nhacnen.mp3"), "wb").write(d)
    # VLKT interface (gameplay vlui.j): frame templates, bottom frame, hp / mp bars, panels (files kept as they are)
    for f in ("ek_frame.fdf", "ek_frame.toc"):
        out = os.path.join(SRC, "dl", f)
        os.makedirs(os.path.dirname(out), exist_ok=True)
        open(out, "wb").write(open(os.path.join(VLKT_SRC_DL, f), "rb").read())
    names = ["HPBar%d.blp" % i for i in range(101)] + ["MPBar%d.blp" % i for i in range(101)] + ["lucchien.blp", "UIButton_trong.blp"]
    for n_ in names:
        r = m.find((I + n_).encode("utf-8").decode("latin1"))
        open(os.path.join(SRC, "war3mapImported", n_), "wb").write(m.read_block(r[1], I + n_))
    os.makedirs(os.path.join(SRC, "VLKT_Data"), exist_ok=True)
    for n_ in ("VLKT_FrameUI_Bottom3.blp", "FrameUI_infopanel1.blp", "FrameUI_infopanel2.blp"):
        open(os.path.join(SRC, "VLKT_Data", n_), "wb").write(open(os.path.join(r"D:\Warcraft 1.31.1\VLKT_Data", n_), "rb").read())
    print("ui: %d textures, %d buttons, %d skin keys" % (len(TEX), len(BUTTONS), len(SKIN)))


if __name__ == "__main__":
    main()
