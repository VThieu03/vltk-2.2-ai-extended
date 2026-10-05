# Classify the map's equipment for the set bonus: slot (1 hat, 2 armor, 3 weapon, 4 boots) and tier
# (1 base, 2..4 = +1..+3, 5 = golden / named artifact), from the converted names in src\map\war3map.w3t.
import os, re, sys, unicodedata
sys.path.insert(0, os.path.dirname(__file__))
import objdata

SRC = r"D:\vltk-dev-clone\src\map"
SLOTS = [  # checked in this order ("Phá Quân Hài" is boots, not a hat)
    (4, {"hai", "ngoa", "ly"}),
    
    (2, {"sam", "y", "bao", "giap", "thuong", "trang"}),
    (3, {"kiem", "dao", "mau", "san", "soc", "phien", "hoan", "phu", "phach", "duyen", "tieu", "khi"}),
    (1, {"mao", "quan", "can", "khoi", "mu"}),
]
SLOT_NAME = {1: "Mũ", 2: "Áo", 3: "Vũ khí", 4: "Giày"}
GOLD = ("|c0000ff00", "|c00ff0000", "|c00ff80ff", "|c00808000")


def plain(s):
    s = re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", s)
    s = s.replace("đ", "d").replace("Đ", "D")
    return "".join(c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn").lower()


def items():
    ver, tabs = objdata.parse(open(os.path.join(SRC, "war3map.w3t"), "rb").read(), ".w3t")
    out = []
    for ti, tab in enumerate(tabs):
        for old, new, sets in tab:
            d = {m[0]: m[4] for m in sets[0]}
            name = d.get(b"unam", b"").decode("utf-8")
            cls = d.get(b"icla", b"").decode("utf-8")
            tip = d.get(b"utub", b"").decode("utf-8")
            iid = (old if ti == 0 else new).decode("latin1")
            if not name or cls in ("Charged", "Miscellaneous", "PowerUp", "Campaign"):
                continue
            words = set(re.findall(r"[a-z]+", plain(name)))
            slot = next((s for s, keys in SLOTS if words & keys), 0)
            if not slot:
                continue
            m = re.search(r"\+\s*([123])", name)
            tier = int(m.group(1)) + 1 if m else 1
            if "hoàng kim" in tip.lower() or name.startswith(GOLD):
                tier = 5
            out.append((iid, slot, tier, name))
    return out


if __name__ == "__main__":
    for iid, slot, tier, name in items():
        print(iid, SLOT_NAME[slot], tier, name)


