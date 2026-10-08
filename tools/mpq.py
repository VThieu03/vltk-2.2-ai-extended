import struct, zlib, bz2


def _crypt_table():
    t = [0] * 0x500
    seed = 0x00100001
    for i in range(0x100):
        idx = i
        for _ in range(5):
            seed = (seed * 125 + 3) % 0x2AAAAB
            a = (seed & 0xFFFF) << 16
            seed = (seed * 125 + 3) % 0x2AAAAB
            b = seed & 0xFFFF
            t[idx] = a | b
            idx += 0x100
    return t


CT = _crypt_table()


def hs(s, typ):
    s1, s2 = 0x7FED7FED, 0xEEEEEEEE
    for ch in s.upper().replace('/', '\\').encode('latin1'):
        s1 = (CT[(typ << 8) + ch] ^ (s1 + s2)) & 0xFFFFFFFF
        s2 = (ch + s1 + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
    return s1


def decrypt(data, key):
    n = len(data) // 4
    w = list(struct.unpack('<%dI' % n, data[: n * 4]))
    s2 = 0xEEEEEEEE
    for i in range(n):
        s2 = (s2 + CT[0x400 + (key & 0xFF)]) & 0xFFFFFFFF
        v = w[i] ^ ((key + s2) & 0xFFFFFFFF)
        key = ((((~key) << 0x15) + 0x11111111) | (key >> 0x0B)) & 0xFFFFFFFF
        s2 = (v + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
        w[i] = v
    return struct.pack('<%dI' % n, *w) + data[n * 4 :]


def encrypt(data, key):
    n = len(data) // 4
    w = list(struct.unpack('<%dI' % n, data[: n * 4]))
    s2 = 0xEEEEEEEE
    for i in range(n):
        s2 = (s2 + CT[0x400 + (key & 0xFF)]) & 0xFFFFFFFF
        v = w[i]
        w[i] = v ^ ((key + s2) & 0xFFFFFFFF)
        key = ((((~key) << 0x15) + 0x11111111) | (key >> 0x0B)) & 0xFFFFFFFF
        s2 = (v + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
    return struct.pack('<%dI' % n, *w) + data[n * 4 :]


F_IMPLODE, F_COMPRESS, F_ENCRYPT, F_FIXKEY = 0x100, 0x200, 0x10000, 0x20000
F_SINGLE, F_CRC, F_EXISTS = 0x1000000, 0x4000000, 0x80000000


def decompress(buf, outsize):
    if len(buf) >= outsize:
        return buf[:outsize]
    m = buf[0]
    d = buf[1:]
    if m & 0x10:
        d = bz2.decompress(d)
        m &= ~0x10
    if m & 0x02:
        d = zlib.decompress(d)
        m &= ~0x02
    if m & 0x08:
        from blast import explode  # PKWARE implode, old maps

        d = explode(d)
        m &= ~0x08
    if m:
        raise ValueError('unsupported compression 0x%x' % buf[0])
    return d


class MPQ:
    def __init__(self, path, header_off):
        self.path = path
        self.f = open(path, 'rb')
        self.base = header_off
        self.f.seek(header_off)
        h = self.f.read(32)
        _, _, _, fmt, self.shift, hto, bto, self.hcount, self.bcount = struct.unpack('<IIIHHIIII', h)
        self.hto = (header_off + hto) & 0xFFFFFFFF
        self.bto = (header_off + bto) & 0xFFFFFFFF
        self.sector = 512 << self.shift
        self.f.seek(self.hto)
        hraw = decrypt(self.f.read(self.hcount * 16), hs('(hash table)', 3))
        self.hashes = [struct.unpack('<IIHHI', hraw[i * 16 : i * 16 + 16]) for i in range(self.hcount)]
        self.f.seek(self.bto)
        braw = decrypt(self.f.read(self.bcount * 16), hs('(block table)', 3))
        self.blocks = [list(struct.unpack('<IIII', braw[i * 16 : i * 16 + 16])) for i in range(self.bcount)]

    def find(self, name):
        a, b, i = hs(name, 1), hs(name, 2), hs(name, 0) % self.hcount
        start = i
        while True:
            ha, hb, loc, plat, bi = self.hashes[i]
            if bi == 0xFFFFFFFF:
                return None
            if ha == a and hb == b and bi != 0xFFFFFFFE and bi < self.bcount:
                return i, bi
            i = (i + 1) % self.hcount
            if i == start:
                return None

    def read_block(self, bi, name):
        off, csize, fsize, flags = self.blocks[bi]
        off = (self.base + off) & 0xFFFFFFFF
        self.f.seek(off)
        raw = self.f.read(csize)
        key = 0
        if flags & F_ENCRYPT:
            key = hs(name.replace('/', '\\').split('\\')[-1], 3)
            if flags & F_FIXKEY:
                key = ((key + (off - self.base)) ^ fsize) & 0xFFFFFFFF
        if flags & F_SINGLE:
            if flags & F_ENCRYPT:
                raw = decrypt(raw, key)
            return decompress(raw, fsize) if flags & F_COMPRESS else raw[:fsize]
        nsec = (fsize + self.sector - 1) // self.sector
        if not flags & (F_COMPRESS | F_IMPLODE):
            out = b''
            for s in range(nsec):
                chunk = raw[s * self.sector : (s + 1) * self.sector]
                if flags & F_ENCRYPT:
                    chunk = decrypt(chunk, key + s)
                out += chunk
            return out[:fsize]
        ntab = nsec + 1 + (1 if flags & F_CRC else 0)
        tab = raw[: ntab * 4]
        if flags & F_ENCRYPT:
            tab = decrypt(tab, (key - 1) & 0xFFFFFFFF)
        offs = struct.unpack('<%dI' % ntab, tab)
        out = []
        for s in range(nsec):
            chunk = raw[offs[s] : offs[s + 1]]
            if flags & F_ENCRYPT:
                chunk = decrypt(chunk, (key + s) & 0xFFFFFFFF)
            want = min(self.sector, fsize - s * self.sector)
            out.append(decompress(chunk, want))
        return b''.join(out)

    def read(self, name):
        r = self.find(name)
        if r is None:
            return None
        return self.read_block(r[1], name)
