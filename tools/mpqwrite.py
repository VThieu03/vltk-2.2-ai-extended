# Rebuild an MPQ archive: copy every original block as-is (no recompression),
# replace or add files, then write fresh hash/block tables and a clean v0 header.
import hashlib, struct, zlib
from mpq import MPQ, hs, encrypt

HASH_EMPTY, HASH_DELETED = 0xFFFFFFFF, 0xFFFFFFFE
F_EXISTS, F_COMPRESS = 0x80000000, 0x200


def pack_file(data, sector):
    """Sectored, zlib-compressed, unencrypted (same layout as the original files)."""
    if not data:
        return b"", F_EXISTS
    chunks = []
    for i in range(0, len(data), sector):
        raw = data[i : i + sector]
        c = b"\x02" + zlib.compress(raw, 9)
        chunks.append(c if len(c) < len(raw) else raw)
    offs = [4 * (len(chunks) + 1)]
    for c in chunks:
        offs.append(offs[-1] + len(c))
    return struct.pack("<%dI" % len(offs), *offs) + b"".join(chunks), F_EXISTS | F_COMPRESS


def build(src_path, header_off, files, out_path, remove=(), keep_layout=False):
    """files: {mpq name: bytes}; remove: names to delete.
    keep_layout: copy the original archive body verbatim (every block keeps its offset, which
    files encrypted with FIX_KEY need) and append replaced/new files after it."""
    m = MPQ(src_path, header_off)
    hashes = [list(h) for h in m.hashes]
    # Grow a full hash table without knowing the stored names (protected maps have no listfile): a name's
    # home slot in a table k times bigger is its old home + j*old size, so k copies of the old table keep
    # every probe run (and every lookup) as it was, and leave k times the free slots for new files.
    used = sum(1 for h in hashes if h[4] not in (HASH_EMPTY, HASH_DELETED))
    k = 1
    while used * k + len(files) > len(hashes) * k * 0.75:
        k *= 2
    if k > 1:
        hashes = [list(h) for _ in range(k) for h in hashes]
    blocks = [list(b) for b in m.blocks]
    new_data = {}  # block index -> packed bytes

    def slot(name):
        a, b, i = hs(name, 1), hs(name, 2), hs(name, 0) % len(hashes)
        free = None
        for _ in range(len(hashes)):
            ha, hb, _, _, bi = hashes[i]
            if bi == HASH_EMPTY:
                return (free if free is not None else i), None
            if bi == HASH_DELETED:
                free = i if free is None else free
            elif ha == a and hb == b:
                return i, bi
            i = (i + 1) % len(hashes)
        if free is None:
            raise RuntimeError("hash table full")
        return free, None

    changed = {}  # block index -> new uncompressed data
    removed = set()
    for name in remove:
        i, bi = slot(name)
        if bi is not None:
            hashes[i][4] = HASH_DELETED
            blocks[bi][3] = 0
            removed.add(bi)

    for name, data in files.items():
        i, bi = slot(name)
        packed, flags = pack_file(data, m.sector)
        if bi is None:
            bi = len(blocks)
            blocks.append([0, 0, 0, 0])
            hashes[i] = [hs(name, 1), hs(name, 2), 0, 0, bi]
        blocks[bi][1:] = [len(packed), len(data), flags]
        new_data[bi] = packed
        changed[bi] = data

    # (attributes) holds the CRC32 (and file time) of every block; the 1.31 game checks it and
    # treats a replaced file whose CRC no longer matches as unreadable (war3map.j: no lobby slots)
    i, abi = slot("(attributes)")
    if abi is not None and "(attributes)" not in files and abi not in removed:
        att = bytearray(m.read("(attributes)"))
        ver, aflags = struct.unpack_from("<II", att)
        n_old, n = len(m.blocks), len(blocks)
        parts, p = [], 8
        for bit, size in ((1, 4), (2, 8), (4, 16)):  # CRC32, FILETIME, MD5 arrays
            if aflags & bit:
                parts.append(bytearray(att[p : p + n_old * size]) + bytearray(size * (n - n_old)))
                p += n_old * size
            else:
                parts.append(None)
        for bi, data in changed.items():
            if parts[0] is not None:
                struct.pack_into("<I", parts[0], 4 * bi, zlib.crc32(data) & 0xFFFFFFFF)
            if parts[2] is not None:
                parts[2][16 * bi : 16 * bi + 16] = hashlib.md5(data).digest()
        for bi in removed:
            for part, size in zip(parts, (4, 8, 16)):
                if part is not None:
                    part[size * bi : size * bi + size] = bytes(size)
        att = struct.pack("<II", ver, aflags) + b"".join(x for x in parts if x is not None)
        packed, flags = pack_file(att, m.sector)
        blocks[abi][1:] = [len(packed), len(att), flags]
        new_data[abi] = packed

    src = open(src_path, "rb")
    out = open(out_path, "wb")
    src.seek(0)
    out.write(src.read(header_off))  # HM3W header (map name, flags, ...)
    out.write(b"\0" * 32)  # MPQ header, filled in at the end
    pos = 32
    if keep_layout:
        end = max(ob[0] + ob[1] for ob in m.blocks if ob[3] & F_EXISTS)
        src.seek(header_off + 32)
        out.write(src.read(end - 32))
        pos = end
        for bi, b in enumerate(blocks):
            if not b[3] & F_EXISTS:
                blocks[bi] = [0, 0, 0, 0]
            elif bi in new_data:
                b[0] = pos
                out.write(new_data[bi])
                pos += len(new_data[bi])
            # untouched blocks keep their original offset
    for bi, b in enumerate(blocks if not keep_layout else []):
        if not b[3] & F_EXISTS:
            blocks[bi] = [0, 0, 0, 0]
            continue
        if bi in new_data:
            data = new_data[bi]
        else:
            src.seek(header_off + m.blocks[bi][0])
            data = src.read(m.blocks[bi][1])
        b[0] = pos
        out.write(data)
        pos += len(data)
    hto = pos
    hraw = b"".join(struct.pack("<IIHHI", *h) for h in hashes)
    out.write(encrypt(hraw, hs("(hash table)", 3)))
    pos += len(hraw)
    bto = pos
    braw = b"".join(struct.pack("<IIII", *b) for b in blocks)
    out.write(encrypt(braw, hs("(block table)", 3)))
    pos += len(braw)
    out.seek(header_off)
    out.write(struct.pack("<4sIIHHIIII", b"MPQ\x1a", 32, pos, 0, m.shift, hto, bto, len(hashes), len(blocks)))
    out.close()
    src.close()
