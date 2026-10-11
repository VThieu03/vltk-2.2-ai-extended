# Import KVCT creep models and their original textures, then define farm unit types.
# Run after expand.py (it restores the map's source object data) and before gameplay.py.
import copy
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata
import kvcreep_data as D
import farm_config
import vfx
from mpq import MPQ

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.path.join(ROOT, "src", "map")
KVCT = r"D:\kvct-dev\work\base.w3x"
DEST = "VLTK_data\\war3mapImported\\KVCTCreeps\\"


def set_field(mods, field, typ, value):
    for mod in mods:
        if mod[0] == field.encode("ascii"):
            mod[3] = typ
            mod[4] = value.encode("utf-8") if typ == 3 else struct.pack("<i", value)
            return
    mods.append([field.encode("ascii"), None, None, typ,
                 value.encode("utf-8") if typ == 3 else struct.pack("<i", value), b"\0\0\0\0"])


def copy_texture(name, archive):
    source = archive.read(name)
    external = os.path.join(vfx.KVCT_DATA, *name.split("\\"))
    if source is None and os.path.isfile(external):
        with open(external, "rb") as file:
            source = file.read()
    if source is None:
        raise FileNotFoundError("KVCT creep texture missing: " + name)
    destination = os.path.join(SRC, *vfx.map_texture_path(name).split("\\"))
    os.makedirs(os.path.dirname(destination), exist_ok=True)
    if os.path.isfile(destination):
        with open(destination, "rb") as file:
            if file.read() == source:
                return
    # khác bản gốc (texshrink.py đã thu nhỏ ở lần build trước): chép lại bản gốc, texshrink chạy sau sẽ thu nhỏ lại
    with open(destination, "wb") as file:
        file.write(source)


def center_overhead(data):
    """Keep the overhead name/health anchor above the model, not its bounds."""
    data = bytes(data)
    chunks = {}
    pos = 4
    while pos + 8 <= len(data):
        tag = data[pos:pos + 4]
        size = struct.unpack_from("<I", data, pos + 4)[0]
        if pos + 8 + size > len(data):
            raise ValueError("Invalid MDX chunk size: %r" % tag)
        chunks[tag] = (pos, size)
        pos += 8 + size
    if pos != len(data) or b"ATCH" not in chunks or b"PIVT" not in chunks:
        raise ValueError("Creep MDX missing ATCH/PIVT chunk")

    ap, az = chunks[b"ATCH"]
    pp, pz = chunks[b"PIVT"]
    if pz % 12:
        raise ValueError("Invalid MDX pivot count")
    found = None
    offset = ap + 8
    while offset < ap + 8 + az:
        record_size = struct.unpack_from("<I", data, offset)[0]
        node_size = struct.unpack_from("<I", data, offset + 4)[0]
        if record_size < 364 or offset + record_size > ap + 8 + az or node_size < 96:
            raise ValueError("Invalid MDX attachment")
        name = data[offset + 8:offset + 88].split(b"\0", 1)[0].lower()
        if name.startswith(b"overhead"):
            found = struct.unpack_from("<I", data, offset + 88)[0]
            break
        offset += record_size
    if found is not None:
        if found >= pz // 12:
            raise ValueError("Overhead pivot index out of range")
        pivot = pp + 8 + found * 12
        z = struct.unpack_from("<f", data, pivot + 8)[0]
        out = bytearray(data)
        struct.pack_into("<3f", out, pivot, 0., 0., z)
        return bytes(out)

    # Models without an Overhead attachment make Warcraft position the name/bar
    # from animated bounds, which may be far away when particles enlarge them.
    model_pos, model_size = chunks[b"MODL"]
    max_z = struct.unpack_from("<f", data, model_pos + 8 + model_size - 8)[0]
    height = max(100., min(260., max_z + 20.))
    object_id = pz // 12
    record = (struct.pack("<II80sIII", 364, 96, b"Overhead Ref", object_id,
                          0xFFFFFFFF, 2048) + bytes(260) + struct.pack("<I", 0))
    out = bytearray(data)
    out[ap + 8 + az:ap + 8 + az] = record
    struct.pack_into("<I", out, ap + 4, az + len(record))
    pp += len(record)
    out[pp + 8 + pz:pp + 8 + pz] = struct.pack("<3f", 0., 0., height)
    struct.pack_into("<I", out, pp + 4, pz + 12)
    return bytes(out)


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
    specs = []
    ix = 0
    for level, normal, special in D.TIERS:
        level_min, level_max = farm_config.level_range(level)
        for model, name in (
            (normal, "Quái KVCT cấp %d" % level_min),
            (special, "Tinh Anh KVCT cấp %d" % level_min),
        ):
            code = D.rawcode(ix).encode("ascii")
            ix += 1
            model_name = model + ".mdx"
            model_data = archive.read("war3mapImported\\" + model_name)
            if model_data is None:
                raise RuntimeError("KVCT creep model missing: " + model_name)
            for texture in vfx.textures(model_data):
                if texture.lower().startswith(("kvct3_data\\", "war3mapimported\\")):
                    copy_texture(texture, archive)
            model_data = vfx.rewrite_model_textures(model_data)
            model_data = center_overhead(model_data)
            model_path = DEST + model_name
            open(os.path.join(models_dir, model_name), "wb").write(model_data)

            mods = copy.deepcopy(template_sets)
            fields = mods[0]
            set_field(fields, "unam", 3, name)
            set_field(fields, "umdl", 3, model_path)
            set_field(fields, "utip", 3, "Bãi đề xuất: cấp %d-%d" % (level_min, level_max))
            set_field(fields, "utub", 3, "Cấp quái thực: %d. Bãi farm phù hợp tướng cấp %d-%d." % (level_min, level_min, level_max))
            set_field(fields, "ulev", 0, level)
            set_field(fields, "uhpm", 0, 500 + level * 110)
            set_field(fields, "ua1b", 0, 10 + level * 2)
            set_field(fields, "ubdi", 0, 0)
            set_field(fields, "ubsi", 0, 0)
            new_obj = [template_base, code, mods]
            tables[1].append(new_obj)
            specs.append((level, code.decode("ascii"), model_name))

    of_tables.save()

    # Lỗi cân bằng có sẵn của map gốc (User báo 10/10/2026): quái "Cua" (nsc3) ở bãi cua có kỹ năng bị động A0E3
    # ("Tuyết Anh", gốc Ablo) làm chậm người bị đánh trúng tới 20 giây thật - quá dài so với mọi hiệu ứng chậm khác
    # trong map (1-4 giây), cảm giác như chậm mãi không hết. Rút ngắn còn 2 giây, không đổi tên/icon/chỉ số khác.
    w3a_path = os.path.join(SRC, "war3map.w3a")
    of_a = objdata.ObjectFile.load(w3a_path)
    na = 0
    for tab in of_a.tables:
        for o, n, sets in tab:
            if (o if tab is of_a.tables[0] else n) == b"A0E3":
                for m in sets[0]:
                    if m[0] in (b"adur", b"ahdu"):
                        m[4] = struct.pack("<f", 2.0)
                        na += 1
    if na == 0:
        raise RuntimeError("kvcreep: khong tim thay abilty A0E3 (Cua - lam cham) de rut ngan thoi gian")
    of_a.save()

    print("kvcreep: imported %d KVCT models and defined %d farm unit types" % (ix, len(specs)))
    for level, code, model in specs:
        print("  level %d %s %s" % (level, code, model))


if __name__ == "__main__":
    main()
