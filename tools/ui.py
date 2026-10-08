# Interface in the style of VLKT (Silva.Fox): textures for the panels (jade frame), the round Hanh Trang /
# Nhan Vat buttons (labels redrawn for this map's keys), gold / Kim Nguyen Bao / attack / armor / attribute
# icons of the console (war3mapSkin.txt). Textures are re-saved as BLP with power-of-two sides (the 1.31
# game shows other sizes as green squares). Run after vfx.py.
import io, os, re, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
from PIL import Image, ImageDraw, ImageFont
from icons import blp1_palette
from tcvn3 import _T
import config

TCVN3 = {v: chr(k) for k, v in _T.items()}  # VNVOGU is a TCVN3 font

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
BUTTONS = {
    "FrameButtonIcon_hanhtrang.tga": ("vl_ui_bag", "Hành Trang (B)"),
    "FrameButtonIcon_nhanvat.tga": ("vl_ui_hero", "Nhân Vật (I)"),
}
SKIN = {
    "GoldIcon": "vl_ui_gold",
    "LumberIcon": "vl_ui_knb",
    "InfoPanelIconDamageNormal": "vl_ui_atk",
    "InfoPanelIconDamageNormalNeutral": "vl_ui_atk",
    "InfoPanelIconDamageHero": "vl_ui_atk",
    "InfoPanelIconDamageHeroNeutral": "vl_ui_atk",
    "InfoPanelIconArmorHero": "vl_ui_def",
    "InfoPanelIconArmorHeroNeutral": "vl_ui_def",
    "InfoPanelIconArmorNormal": "vl_ui_def",
    "InfoPanelIconArmorNormalNeutral": "vl_ui_def",
    "InfoPanelIconHeroIconSTR": "vl_ui_attr",
    "InfoPanelIconHeroIconAGI": "vl_ui_attr",
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


def blp1_palette_rect(im, width, height):
    """Write an 8-bit paletted BLP1 with a rectangular power-of-two canvas."""
    im = im.convert("RGBA").resize((width, height), Image.LANCZOS)
    pal_img = im.convert("RGB").quantize(256, method=Image.Quantize.MEDIANCUT)
    colors = pal_img.getpalette()[:768]
    colors += [0] * (768 - len(colors))
    palette = b"".join(struct.pack("<4B", colors[3*i+2], colors[3*i+1], colors[3*i], 0) for i in range(256))
    mips, w, h = [], width, height
    while True:
        mip = im if (w, h) == (width, height) else im.resize((w, h), Image.LANCZOS)
        idx = mip.convert("RGB").quantize(palette=pal_img, dither=Image.Dither.NONE).tobytes()
        mips.append(idx + mip.getchannel("A").tobytes())
        if w == 1 and h == 1:
            break
        w, h = max(1, w // 2), max(1, h // 2)
    head = 4 + 4 * 6 + 64 + 64
    offs, sizes, pos = [], [], head + len(palette)
    for mip in mips:
        offs.append(pos)
        sizes.append(len(mip))
        pos += len(mip)
    offs += [0] * (16 - len(offs))
    sizes += [0] * (16 - len(sizes))
    return (b"BLP1" + struct.pack("<6I", 1, 8, width, height, 4, 1)
            + struct.pack("<16I", *offs) + struct.pack("<16I", *sizes)
            + palette + b"".join(mips))


def apply_custom_art():
    """Override generated UI art after the source-game textures are extracted."""
    def configured_image(key, required=False):
        value = config.UI_CUSTOM_IMAGES.get(key, "")
        if not value:
            if required:
                raise ValueError("config.UI_CUSTOM_IMAGES[%r] must point to a UI image" % key)
            return None
        path = value if os.path.isabs(value) else os.path.join(os.path.dirname(__file__), value)
        if not os.path.isfile(path):
            raise FileNotFoundError("UI image configured for %s was not found: %s" % (key, path))
        return Image.open(path).convert("RGBA")

    panel = configured_image("panel", required=True)
    save("vl_ui_panel", panel, 256)
    # A clean wood sample from the panel center keeps tiled backdrops in the same style.
    tile = configured_image("tile")
    if tile is None:
        tile = panel.crop((panel.width // 3, panel.height // 3,
                           panel.width * 2 // 3, panel.height * 2 // 3))
    save("vl_ui_tile", tile, 32)
    hud = configured_image("hud", required=True)
    box = hud.getchannel("A").getbbox()
    if box:
        hud = hud.crop(box)
    # The frame is placed at 0.8 x 0.1956 in JASS, a 4.09:1 aspect ratio.
    # Encode a rectangular BLP so minimap, portrait, bars, and all twelve skill slots stay aligned.
    out = os.path.join(SRC, "VLKT_Data", "VLKT_FrameUI_Bottom3.blp")
    open(out, "wb").write(blp1_palette_rect(hud, 1024, 256))
    for key, name, label in (("bag_button", "vl_ui_bag", "Hành Trang (B)"),
                             ("hero_button", "vl_ui_hero", "Nhân Vật (I)")):
        button = configured_image(key)
        if button is not None:
            save(name, relabel(button, label), 128)


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
    if d[:3] == b"ID3":  # drop the ID3 tag, keep the MPEG frames
        d = d[10 + ((d[6] << 21) | (d[7] << 14) | (d[8] << 7) | d[9]) :]
    open(os.path.join(SRC, "war3mapImported", "vl_nhacnen.mp3"), "wb").write(d)
    # VLKT interface (gameplay vlui.j): frame templates, bottom frame, hp / mp bars, panels (files kept as they are)
    for f in ("ek_frame.fdf", "ek_frame.toc"):
        out = os.path.join(SRC, "dl", f)
        os.makedirs(os.path.dirname(out), exist_ok=True)
        open(out, "wb").write(open(os.path.join(VLKT_SRC_DL, f), "rb").read())
    names = (
        ["HPBar%d.blp" % i for i in range(101)]
        + ["MPBar%d.blp" % i for i in range(101)]
        + ["lucchien.blp", "UIButton_trong.blp"]
    )
    for n_ in names:
        r = m.find((I + n_).encode("utf-8").decode("latin1"))
        open(os.path.join(SRC, "war3mapImported", n_), "wb").write(m.read_block(r[1], I + n_))
    os.makedirs(os.path.join(SRC, "VLKT_Data"), exist_ok=True)
    for n_ in ("VLKT_FrameUI_Bottom3.blp", "FrameUI_infopanel1.blp", "FrameUI_infopanel2.blp"):
        open(os.path.join(SRC, "VLKT_Data", n_), "wb").write(
            open(os.path.join(r"D:\Warcraft 1.31.1\VLKT_Data", n_), "rb").read()
        )
    # Project-owned art is applied last so later builds cannot replace it with base-map textures.
    apply_custom_art()
    # KVCT character 10-slot equipment icons
    kvct_path = r"D:\kvct-dev\work\base.w3x"
    if os.path.exists(kvct_path):
        with open(kvct_path, "rb") as kf:
            chunk = kf.read(1024 * 1024)
            off = chunk.find(b"MPQ\x1a")
            if off >= 0:
                sys.path.insert(0, r"D:\kvct-dev\tools")
                import importlib

                mpq = importlib.import_module("mpq")
                sys.path.pop(0)
                m_kvct = mpq.MPQ(kvct_path, off)
                eq_icons = {
                    "war3mapImported\\FrameUI_TBButton_1.blp": "vl_slot_bg_1.blp",
                    "war3mapImported\\FrameUI_TBButton_2.blp": "vl_slot_bg_2.blp",
                    "war3mapImported\\FrameUI_TBButton_3.blp": "vl_slot_bg_3.blp",
                    "war3mapImported\\FrameUI_TBButton_4.blp": "vl_slot_bg_4.blp",
                    "war3mapImported\\FrameUI_TBButton_5.blp": "vl_slot_bg_5.blp",
                    "war3mapImported\\Icon_PC_non1_1_1.blp": "vl_eq_1.blp",
                    "war3mapImported\\Icon_PC_ao1_1_1.blp": "vl_eq_2.blp",
                    "war3mapImported\\Icon_PC_lung1_1_1.blp": "vl_eq_3.blp",
                    "war3mapImported\\Icon_PC_tay1_1_1.blp": "vl_eq_4.blp",
                    "war3mapImported\\Icon_PC_giay1_1_1.blp": "vl_eq_5.blp",
                    "war3mapImported\\Icon_vk_kiem1.blp": "vl_eq_6.blp",
                    "war3mapImported\\Icon_TS_lien1_1.blp": "vl_eq_7.blp",
                    "war3mapImported\\Icon_TS_nhan1_1.blp": "vl_eq_8.blp",
                    "war3mapImported\\Icon_TS_boi1_1.blp": "vl_eq_9.blp",
                    "war3mapImported\\Icon_TS_phu1_1.blp": "vl_eq_10.blp",
                }
                from kskill import kv_image

                for src_k, dst_k in eq_icons.items():
                    r = m_kvct.find(src_k.encode("utf-8").decode("latin1"))
                    if r is not None and m_kvct.blocks[r[1]][2]:
                        raw = m_kvct.read_block(r[1], src_k)
                        im_k = kv_image(raw).resize((64, 64))
                        open(os.path.join(SRC, "war3mapImported", dst_k), "wb").write(blp1_palette(im_k, 64))
    print("ui: %d textures, %d buttons, %d skin keys" % (len(TEX), len(BUTTONS), len(SKIN)))


if __name__ == "__main__":
    main()
