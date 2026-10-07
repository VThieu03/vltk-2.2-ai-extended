# PKWARE Data Compression Library "explode" (MPQ compression 0x08), port of Mark Adler's blast.c.
# Used by old (1.2x) maps.


class _Huff:
    def __init__(self, rep):
        self._build(rep)

    def _build(self, rep):
        length = []
        for b in rep:
            n = (b >> 4) + 1
            length += [b & 15] * n
        self.n = len(length)
        count = [0] * 14
        for l in length:
            count[l] += 1
        offs = [0] * 14
        for i in range(1, 13):
            offs[i + 1] = offs[i] + count[i]
        sym = [0] * self.n
        for s, l in enumerate(length):
            if l:
                sym[offs[l]] = s
                offs[l] += 1
        self.count = count
        self.symbol = sym


class _State:
    def __init__(self, data):
        self.data = data
        self.pos = 0
        self.bitbuf = 0
        self.bitcnt = 0

    def bits(self, need):
        val = self.bitbuf
        while self.bitcnt < need:
            if self.pos >= len(self.data):
                raise ValueError("explode: input ended")
            val |= self.data[self.pos] << self.bitcnt
            self.pos += 1
            self.bitcnt += 8
        self.bitbuf = val >> need
        self.bitcnt -= need
        return val & ((1 << need) - 1)

    def decode(self, h):
        code = first = index = 0
        bitbuf = self.bitbuf
        left = self.bitcnt
        length = 1
        nxt = 1
        while True:
            while left:
                code |= (bitbuf & 1) ^ 1  # codes are inverted
                bitbuf >>= 1
                count = h.count[length]
                if code < first + count:
                    self.bitbuf = bitbuf
                    self.bitcnt = (self.bitcnt - length) & 7
                    return h.symbol[index + (code - first)]
                index += count
                first += count
                first <<= 1
                code <<= 1
                length += 1
                left -= 1
            left = 13 - length
            if left == 0:
                raise ValueError("explode: bad code")
            if self.pos >= len(self.data):
                raise ValueError("explode: input ended")
            bitbuf = self.data[self.pos]
            self.pos += 1
            if left > 8:
                left = 8


_LITLEN = [
    11,
    124,
    8,
    7,
    28,
    7,
    188,
    13,
    76,
    4,
    10,
    8,
    12,
    10,
    12,
    10,
    8,
    23,
    8,
    9,
    7,
    6,
    7,
    8,
    7,
    6,
    55,
    8,
    23,
    24,
    12,
    11,
    7,
    9,
    11,
    12,
    6,
    7,
    22,
    5,
    7,
    24,
    6,
    11,
    9,
    6,
    7,
    22,
    7,
    11,
    38,
    7,
    9,
    8,
    25,
    11,
    8,
    11,
    9,
    12,
    8,
    12,
    5,
    38,
    5,
    38,
    5,
    11,
    7,
    5,
    6,
    21,
    6,
    10,
    53,
    8,
    7,
    24,
    10,
    27,
    44,
    253,
    253,
    253,
    252,
    252,
    252,
    13,
    12,
    45,
    12,
    45,
    12,
    61,
    12,
    45,
    44,
    173,
]
_LENLEN = [2, 35, 36, 53, 38, 23]
_DISTLEN = [2, 20, 53, 230, 247, 151, 248]
_BASE = [3, 2, 4, 5, 6, 7, 8, 9, 10, 12, 16, 24, 40, 72, 136, 264]
_EXTRA = [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8]
_LIT = _LEN = _DIST = None


def explode(data):
    global _LIT, _LEN, _DIST
    if _LIT is None:
        _LIT, _LEN, _DIST = _Huff(_LITLEN), _Huff(_LENLEN), _Huff(_DISTLEN)
    s = _State(data)
    lit = s.bits(8)
    if lit > 1:
        raise ValueError("explode: bad literal flag")
    dict_bits = s.bits(8)
    if dict_bits < 4 or dict_bits > 6:
        raise ValueError("explode: bad dictionary size")
    out = bytearray()
    while True:
        if s.bits(1):
            sym = s.decode(_LEN)
            length = _BASE[sym] + s.bits(_EXTRA[sym])
            if length == 519:
                break
            sym = 2 if length == 2 else dict_bits
            dist = (s.decode(_DIST) << sym) + s.bits(sym) + 1
            if dist > len(out):
                raise ValueError("explode: distance too far")
            start = len(out) - dist
            for k in range(length):
                out.append(out[start + k])
        else:
            out.append(s.decode(_LIT) if lit else s.bits(8))
    return bytes(out)
