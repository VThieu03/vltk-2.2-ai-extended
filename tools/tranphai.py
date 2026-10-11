# Thuốc hồi 5 bậc: chỉnh lượng hồi của các ability thuốc (gameplay.py POTIONS; A0TB là bậc cuối, nhân từ A009).
# (Tuyệt học trấn phái kiểu Thiên Kiếm A0T0-A0TA đã BỎ: trấn phái = skill ô 11 của KVCT, chạy trong kskill.)
# Ghi src\map\war3map.w3a. Chạy sau skills.py.
import os, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import config

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")

POTION_ABIL = {b"A009": 400, b"A0CS": 900, b"A0CT": 1600, b"A0CW": 2500, b"A0TB": 4000}


def m(mid, typ, val, lvl=0, dp=0):
    if typ == 3:
        v = val.encode("utf-8")
    elif typ == 0:
        v = struct.pack("<i", val)
    else:
        v = struct.pack("<f", val)
    return [mid, lvl, dp, typ, v, b"\0\0\0\0"]


def main():
    p = os.path.join(SRC, "war3map.w3a")
    of_tabs = objdata.ObjectFile.load(p)
    ver, tabs = of_tabs.ver, of_tabs.tables
    # potions: one kind heals life and mana over 15 s, 5 tiers (gameplay.py POTIONS), not stopped by damage
    tabs[1][:] = [o for o in tabs[1] if o[1] != b"A0TB"]
    base = next(o for o in tabs[1] if o[1] == b"A009")
    tabs[1].append([base[0], b"A0TB", [[list(x) for x in base[2][0]]]])
    for o, n, sets in tabs[1]:
        if n in POTION_ABIL:
            amount = POTION_ABIL[n]
            sets[0][:] = [x for x in sets[0] if x[0] not in (b"irl1", b"irl2", b"irl5", b"adur", b"ahdu")]
            sets[0] += [
                m(b"irl1", 2, float(amount), 1, 1),
                m(b"irl2", 2, float(amount), 1, 2),
                m(b"irl5", 0, 0, 1, 5),
                m(b"adur", 2, float(config.POTION_REGEN_SECONDS), 1),
                m(b"ahdu", 2, float(config.POTION_REGEN_SECONDS), 1),
            ]
    of_tabs.save()
    print("potion abilities:", len(POTION_ABIL))


if __name__ == "__main__":
    main()
