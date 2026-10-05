# Which Vietnamese Unicode letters a TrueType font maps (cmap format 4, Windows Unicode)
import struct, sys

VN = "ăâđêôơưàảãáạằẳẵắặầấậèẻẽéẹềểễếệìỉĩíịòỏõóọồổỗốộờởỡớợùủũúụừửữứựỳỷỹýỵĐ"


def cmap_has(d, chars):
    n = struct.unpack(">H", d[4:6])[0]
    tabs = {d[12 + 16 * i:16 + 16 * i]: struct.unpack(">II", d[20 + 16 * i:28 + 16 * i]) for i in range(n)}
    off, _ = tabs[b"cmap"]
    nt = struct.unpack(">H", d[off + 2:off + 4])[0]
    found = {}
    for i in range(nt):
        pid, eid, so = struct.unpack(">HHI", d[off + 4 + 8 * i:off + 12 + 8 * i])
        st = off + so
        fmt = struct.unpack(">H", d[st:st + 2])[0]
        found[(pid, eid)] = fmt
        if pid == 3 and eid == 1 and fmt == 4:
            segx2 = struct.unpack(">H", d[st + 6:st + 8])[0]
            seg = segx2 // 2
            ends = struct.unpack(">%dH" % seg, d[st + 14:st + 14 + segx2])
            starts = struct.unpack(">%dH" % seg, d[st + 16 + segx2:st + 16 + 2 * segx2])
            ok = [c for c in chars if any(s <= ord(c) <= e for s, e in zip(starts, ends))]
            return len(ok), found
    return 0, found


if __name__ == "__main__":
    d = open(sys.argv[1], "rb").read()
    print(cmap_has(d, VN), "of", len(VN))
