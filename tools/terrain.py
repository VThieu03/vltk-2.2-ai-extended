# Read / write the terrain files: war3map.w3e (tile corners), war3map.wpm (pathing, 4x4 cells per tile),
# war3map.shd (shadows, same layout) and war3map.doo (doodads, format 8 / 11).
import struct


class W3E:
    def __init__(self, data):
        self.magic, self.ver = data[:4], struct.unpack_from("<i", data, 4)[0]
        self.tileset = data[8:9]
        self.custom = struct.unpack_from("<i", data, 9)[0]
        p = 13
        n = struct.unpack_from("<i", data, p)[0]
        p += 4
        self.ground = [data[p + 4 * i : p + 4 * i + 4] for i in range(n)]
        p += 4 * n
        n = struct.unpack_from("<i", data, p)[0]
        p += 4
        self.cliffs = [data[p + 4 * i : p + 4 * i + 4] for i in range(n)]
        p += 4 * n
        self.mx, self.my = struct.unpack_from("<ii", data, p)
        p += 8
        self.ox, self.oy = struct.unpack_from("<ff", data, p)
        p += 8
        self.pts = [bytearray(data[p + 7 * i : p + 7 * i + 7]) for i in range(self.mx * self.my)]
        assert p + 7 * self.mx * self.my == len(data)

    def pt(self, x, y):
        return self.pts[y * self.mx + x]

    def write(self):
        out = (
            [
                self.magic,
                struct.pack("<i", self.ver),
                self.tileset,
                struct.pack("<i", self.custom),
                struct.pack("<i", len(self.ground)),
            ]
            + self.ground
            + [struct.pack("<i", len(self.cliffs))]
            + self.cliffs
        )
        out += [struct.pack("<ii", self.mx, self.my), struct.pack("<ff", self.ox, self.oy)]
        out += [bytes(t) for t in self.pts]
        return b"".join(out)

    # tile corner fields
    @staticmethod
    def texture(t):
        return t[4] & 0x0F

    @staticmethod
    def set_texture(t, v):
        t[4] = (t[4] & 0xF0) | v

    @staticmethod
    def cliff_tex(t):
        return t[6] >> 4

    @staticmethod
    def set_cliff_tex(t, v):
        t[6] = (t[6] & 0x0F) | (v << 4)


class Grid:
    """wpm / shd: one byte per cell, 4x4 cells per tile, rows from the bottom"""

    def __init__(self, data, header):
        self.header = header
        if header:
            self.magic, self.ver, self.w, self.h = data[:4], *struct.unpack_from("<iii", data, 4)
            self.cells = bytearray(data[16:])
        else:
            self.cells = bytearray(data)
        assert not header or len(self.cells) == self.w * self.h

    def write(self):
        if self.header:
            return self.magic + struct.pack("<iii", self.ver, self.w, self.h) + bytes(self.cells)
        return bytes(self.cells)


def read_doo(data):
    magic, ver, sub, n = data[:4], *struct.unpack_from("<iii", data, 4)
    p = 16
    items = []
    for _ in range(n):
        s = p
        did, var = data[p : p + 4], struct.unpack_from("<i", data, p + 4)[0]
        x, y, z, ang, sx, sy, sz = struct.unpack_from("<7f", data, p + 8)
        p += 8 + 28 + 2  # flags, life
        p += 4  # item table pointer
        nsets = struct.unpack_from("<i", data, p)[0]
        p += 4
        for _ in range(nsets):
            k = struct.unpack_from("<i", data, p)[0]
            p += 4 + 8 * k
        p += 4  # editor id
        items.append({"id": did, "x": x, "y": y, "raw": bytearray(data[s:p])})
    rest = data[p:]  # special doodads section
    return (magic, ver, sub), items, rest


def write_doo(head, items, rest):
    magic, ver, sub = head
    out = [magic, struct.pack("<iii", ver, sub, len(items))]
    for i, it in enumerate(items):
        raw = bytearray(it["raw"])
        struct.pack_into("<ff", raw, 8, it["x"], it["y"])
        struct.pack_into("<i", raw, len(raw) - 4, i)  # editor id: unique
        out.append(bytes(raw))
    out.append(rest)
    return b"".join(out)
