# Read/write War3 object modification files (w3u w3t w3b w3h: simple; w3a w3d w3q: with level/data).
# Format v1 (1.24): version, then original table and custom table; each object = old id, new id,
# mod count, mods = id, type, [level, data pointer] (0 int 1 real 2 unreal 3 string), value, end marker.
import struct

EXT = {".w3a", ".w3d", ".w3q"}


def parse(data, ext):
    p = 0

    def i32():
        nonlocal p
        v = struct.unpack_from("<i", data, p)[0]
        p += 4
        return v

    def raw(n):
        nonlocal p
        v = data[p:p + n]
        p += n
        return v

    ver = i32()
    if ver not in (1, 2):
        raise ValueError("object file version %d" % ver)
    tables = []
    for _ in range(2):
        objs = []
        for _ in range(i32()):
            old, new = raw(4), raw(4)
            sets = []
            nset = i32() if ver >= 3 else 1
            for _ in range(nset):
                mods = []
                for _ in range(i32()):
                    mid = raw(4)
                    lvl = dp = None
                    typ = i32()
                    if ext in EXT:
                        lvl, dp = i32(), i32()
                    if typ == 3:
                        e = data.index(b"\0", p)
                        val = data[p:e]
                        p = e + 1
                    else:
                        val = raw(4)
                    end = raw(4)
                    mods.append([mid, lvl, dp, typ, val, end])
                sets.append(mods)
            objs.append([old, new, sets])
        tables.append(objs)
    if p != len(data):
        raise ValueError("trailing %d bytes" % (len(data) - p))
    return ver, tables


def write(ver, tables, ext):
    out = [struct.pack("<i", ver)]
    for objs in tables:
        out.append(struct.pack("<i", len(objs)))
        for old, new, sets in objs:
            out += [old, new]
            for mods in sets:
                out.append(struct.pack("<i", len(mods)))
                for mid, lvl, dp, typ, val, end in mods:
                    out.append(mid)
                    out.append(struct.pack("<i", typ))
                    if ext in EXT:
                        out.append(struct.pack("<ii", lvl, dp))
                    out.append(val + b"\0" if typ == 3 else val)
                    out.append(end)
    return b"".join(out)
