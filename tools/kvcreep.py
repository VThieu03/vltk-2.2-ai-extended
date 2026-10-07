# Import six KVCT creep models and define custom units with visible farm levels.
# Run after expand.py (it restores the map's source object data) and before gameplay.py.
import copy
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import kvcreep_data as D
from mpq import MPQ

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
KVCT = r"D:\kvct-dev\work\base.w3x"
CODE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DEST = "war3mapImported\\KVCTCreeps\\"


def rawcode(n):
    return ("Q" + CODE[n // 36] + CODE[n % 36] + "1").encode("ascii")


def set_field(mods, field, typ, value):
    for mod in mods:
        if mod[0] == field.encode("ascii"):
            mod[3] = typ
            mod[4] = value.encode("utf-8") if typ == 3 else struct.pack("<i", value)
            return
    mods.append([field.encode("ascii"), None, None, typ,
                 value.encode("utf-8") if typ == 3 else struct.pack("<i", value), b"\0\0\0\0"])


def textures(data, fallback, archive):
    i = 4
    while i + 8 <= len(data):
        tag, size = data[i:i + 4], struct.unpack_from("<I", data, i + 4)[0]
        if tag == b"TEXS":
            for p in range(i + 8, i + 8 + size, 268):
                old = data[p + 4:p + 264].split(b"\0", 1)[0].decode("latin1")
                if not old:
                    continue
                exists = archive.read(old) is not None
                if not exists and old.lower().startswith(("kvct3_data\\", "war3mapimported\\")):
                    repl = fallback.encode("ascii") + b"\0"
                    data[p + 4:p + 264] = repl.ljust(260, b"\0")
        i += 8 + size
    return data


def main():
    head = open(KVCT, "rb").read(1 << 20)
    archive = MPQ(KVCT, head.find(b"MPQ\x1a"))
    units_path = os.path.join(SRC, "war3map.w3u")
    of_tables = objdata.ObjectFile.load(units_path)
    version, tables = of_tables.ver, of_tables.tables
    template = next((x for x in tables[1] if x[1] == b"n006"), None)
    if template is None:
        raise RuntimeError("KVCT creep base template n006 is missing")
    template_base, template_sets = template[0], template[2]
    if template_base != b"nwlt":
        raise RuntimeError("Unexpected base unit for n006: %r" % template_base)

    models_dir = os.path.join(SRC, DEST.replace("\\", os.sep))
    os.makedirs(models_dir, exist_ok=True)
    codes = set()
    specs = []
    ix = 0
    for level, normal, special, normal_skin, special_skin in D.TIERS:
        for model, name, skin in (
            (normal, "Quái KVCT cấp %d" % level, normal_skin),
            (special, "Tinh Anh KVCT cấp %d" % level, special_skin),
        ):
            code = rawcode(ix)
            ix += 1
            model_name = model + ".mdx"
            model_data = archive.read("war3mapImported\\" + model_name)
            if model_data is None:
                raise RuntimeError("KVCT creep model missing: " + model_name)
            model_data = textures(bytearray(model_data), skin, archive)
            model_path = DEST + model_name
            open(os.path.join(models_dir, model_name), "wb").write(model_data)

            mods = copy.deepcopy(template_sets)
            fields = mods[0]
            set_field(fields, "unam", 3, name)
            set_field(fields, "umdl", 3, model_path)
            set_field(fields, "utip", 3, "Cấp đề xuất: %d" % level)
            set_field(fields, "utub", 3, "Quái rừng Kiếm Vũ Chí Tôn. Sức mạnh tăng theo bãi cấp %d." % level)
            set_field(fields, "ulev", 0, level)
            set_field(fields, "uhpm", 0, 500 + level * 110)
            set_field(fields, "ua1b", 0, 10 + level * 2)
            set_field(fields, "ubdi", 0, 0)
            set_field(fields, "ubsi", 0, 0)
            new_obj = [template_base, code, mods]
            tables[1].append(new_obj)
            codes.add(code)
            specs.append((level, code.decode("ascii"), model_name))

    of_tables.save()
    print("kvcreep: imported %d KVCT models and defined %d farm unit types" % (ix, len(specs)))
    for level, code, model in specs:
        print("  level %d %s %s" % (level, code, model))


if __name__ == "__main__":
    main()
