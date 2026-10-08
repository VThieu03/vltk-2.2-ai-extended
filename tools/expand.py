# Make the map wider and graft two areas of the author's Thien Kiem map into the new space.
#   - E new tile columns east of the map (unpathable boundary), two Thien Kiem areas pasted there:
#     terrain corners (ground textures / cliffs remapped to this map's lists), pathing, shadows, doodads
#     (Thien Kiem custom doodads copied with new ids + their models / textures)
#   - playable area + camera bounds widened (war3map.w3i and SetCameraBounds in the script)
#   - minimap image redrawn, minimap icons moved
#   - build\zones.txt: world rect of each pasted area, read by gameplay.py (Xa Phu, creep camps)
# Reads the original files (work\orig); run after fix_script.py.
import io, os, re, struct, sys

sys.path.insert(0, os.path.dirname(__file__))
import objdata, terrain
from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
ORIG = os.path.join(ROOT, "work", "orig")
SRC = os.path.join(ROOT, "src", "map")
TK = r"D:\thienkiem-dev\src"
E = 168  # new tile columns (east), enough for six separate level bands
# Thien Kiem areas: rough world rects (x0, x1, y0, y1), destination tile (x, y) of the bottom-left corner
ZONES = [
    ("Cổng Phía Trên", (-9472, -4608, -9472, -4608), (99, 10)),
    ("Cổng Phía Dưới", (-9472, -4608, -9472, -4608), (99, 66)),
    ("Xa Phu - Bãi Cấp 60 phía Bắc", (2048, 6656, -9472, -4608), (183, 10)),
    ("Xa Phu - Bãi Cấp 60 phía Nam", (2048, 6656, -9472, -4608), (183, 66)),
    ("Xa Phu - Bãi Cấp 80", (2048, 6656, -9472, -4608), (225, 10)),
    ("Xa Phu - Bãi Cấp 100", (2048, 6656, -9472, -4608), (225, 66)),
    ("Đấu Trường", (8352, 10720, -96, 6496), (142, 36)),  # Thien Kiem ARENA (rooms + field)
]
ARENA = "Đấu Trường"
MAXW = 40  # tiles available per zone
TEX_MAP = {
    b"Agrs": b"Zgrs",
    b"Agrd": b"Zgrs",
    b"Adrt": b"Zdrt",
    b"Adrg": b"Zdrg",
    b"Arck": b"Zbks",
    b"Alvd": b"Zvin",
    b"Qcbp": b"Ztil",
    b"Qdrr": b"Zdrt",
    b"Xgsb": b"Zgrs",
    b"Ygsb": b"Zgrs",
    b"Xblm": b"Yblm",
}


def rd(path):
    return open(path, "rb").read()


def tk_tile(x, y, w):
    return int((x - w.ox) // 128), int((y - w.oy) // 128)


def tight_box(wpm, w, rect):
    """tile box (tx0, ty0, tx1, ty1) of walkable cells inside rect, 2 tiles of margin"""
    x0, x1, y0, y1 = rect
    a, b = tk_tile(x0, y0, w)
    c, d = tk_tile(x1, y1, w)
    xs, ys = [], []
    for ty in range(b, d):
        for tx in range(a, c):
            cell = wpm.cells[(ty * 4 + 2) * wpm.w + tx * 4 + 2]
            if not cell & 0x02:
                xs.append(tx)
                ys.append(ty)
    return max(min(xs) - 2, a), max(min(ys) - 2, b), min(max(xs) + 3, c), min(max(ys) + 3, d)


def main():
    vw = terrain.W3E(rd(os.path.join(ORIG, "war3map.w3e")))
    vp = terrain.Grid(rd(os.path.join(ORIG, "war3map.wpm")), True)
    vs = terrain.Grid(rd(os.path.join(ORIG, "war3map.shd")), False)
    tw = terrain.W3E(rd(os.path.join(TK, "war3map.w3e")))
    tp = terrain.Grid(rd(os.path.join(TK, "war3map.wpm")), True)
    ts = terrain.Grid(rd(os.path.join(TK, "war3map.shd")), False)
    omx, omy = vw.mx, vw.my
    # 1. widen: each row gets E copies of its last (boundary) corner
    pts = []
    for y in range(omy):
        row = vw.pts[y * omx : (y + 1) * omx]
        pts += row + [bytearray(row[-1]) for _ in range(E)]
    vw.pts, vw.mx = pts, omx + E
    ow, nw = vp.w, vp.w + 4 * E
    for g in (vp, vs):
        cells = bytearray()
        for y in range(4 * (omy - 1)):
            row = g.cells[y * ow : (y + 1) * ow]
            cells += row + bytes([row[-1]]) * (4 * E)
        g.cells = cells
    vp.w = nw
    # textures / cliffs
    tex_index = {}

    def tex(i):
        name = tw.ground[i]
        name = name if name in vw.ground else TEX_MAP.get(name, name)
        if name not in vw.ground:
            if len(vw.ground) >= 16:
                name = b"Zgrs"
            else:
                vw.ground.append(name)
        return vw.ground.index(name)

    zones_out = []
    for zname, rect, (dx, dy) in ZONES:
        tx0, ty0, tx1, ty1 = tight_box(tp, tw, rect)
        tx1 = min(tx1, tx0 + MAXW)
        w, h = tx1 - tx0, ty1 - ty0
        assert dx + w + 2 < vw.mx and dy + h < omy - 4, (zname, w, h)
        for y in range(h + 1):
            for x in range(w + 1):
                t = bytearray(tw.pt(tx0 + x, ty0 + y))
                if x in (0, w) or y in (0, h):  # keep the zone closed: boundary corners on the rim
                    t = bytearray(vw.pt(dx + x, dy + y))
                else:
                    ti = terrain.W3E.texture(t)
                    if ti not in tex_index:
                        tex_index[ti] = tex(ti)
                    terrain.W3E.set_texture(t, tex_index[ti])
                    if terrain.W3E.cliff_tex(t) != 15:
                        terrain.W3E.set_cliff_tex(t, 0)
                vw.pts[(dy + y) * vw.mx + dx + x] = t
        for cy in range(4 * h):
            for cx in range(4 * w):
                src = (ty0 * 4 + cy) * tp.w + tx0 * 4 + cx
                dst = (dy * 4 + cy) * vp.w + dx * 4 + cx
                vp.cells[dst] = tp.cells[src]
                vs.cells[dst] = ts.cells[src]
        sx, sy = tw.ox + tx0 * 128, tw.oy + ty0 * 128  # world origin of the area in Thien Kiem
        nx, ny = vw.ox + dx * 128, vw.oy + dy * 128  # and here
        zones_out.append((zname, sx, sy, nx, ny, w * 128, h * 128))
    # 2. doodads
    head, vitems, rest = terrain.read_doo(rd(os.path.join(ORIG, "war3map.doo")))
    _, titems, _ = terrain.read_doo(rd(os.path.join(TK, "war3map.doo")))
    tdd = objdata.ObjectFile.load(os.path.join(TK, "war3map.w3d")).tables
    w3d = objdata.ObjectFile.load(os.path.join(SRC, "war3map.w3d"))  # converted by convert_text.py
    vdd = w3d.tables
    tk_custom = {n: (o, s) for o, n, s in tdd[1]}
    used_ids = {n for o, n, s in vdd[1]}
    rename, assets = {}, set()
    k = 0
    for zname, sx, sy, nx, ny, w, h in zones_out:
        for it in titems:
            if sx + 64 <= it["x"] < sx + w - 64 and sy + 64 <= it["y"] < sy + h - 64:
                did = it["id"]
                if did in tk_custom:
                    if did not in rename:
                        new = ("DK%02d" % k).encode()
                        k += 1
                        assert new not in used_ids
                        rename[did] = new
                        o, s = tk_custom[did]
                        vdd[1].append([o, new, s])
                        for m in s[0]:
                            if m[0] == b"dfil":
                                assets.add(m[4].decode("latin1"))
                    did = rename[did]
                raw = bytearray(it["raw"])
                raw[0:4] = did
                vitems.append({"id": did, "x": it["x"] - sx + nx, "y": it["y"] - sy + ny, "raw": raw})
    # 3. models + their imported textures
    copied = []
    for a in sorted(assets):
        mdx = re.sub(r"\.mdl$", ".mdx", a, flags=re.I)
        p = os.path.join(TK, mdx)
        if not os.path.exists(p):
            print("model not in Thien Kiem:", mdx)
            continue
        data = rd(p)
        files = {mdx: data}
        i = data.find(b"TEXS")
        if i >= 0:
            n = struct.unpack_from("<i", data, i + 4)[0] // 268
            for j in range(n):
                tex_path = data[i + 8 + 268 * j + 4 : i + 8 + 268 * j + 264].split(b"\0")[0].decode("latin1")
                if tex_path and os.path.exists(os.path.join(TK, tex_path)):
                    files[tex_path] = rd(os.path.join(TK, tex_path))
        for f, d in files.items():
            out = os.path.join(SRC, f)
            os.makedirs(os.path.dirname(out), exist_ok=True)
            open(out, "wb").write(d)
            copied.append(f)
    # 4. w3i: playable width and camera bounds
    i3 = bytearray(rd(os.path.join(ORIG, "war3map.w3i")))
    p = 12
    for _ in range(4):
        p = i3.index(b"\0", p) + 1
    cam = list(struct.unpack_from("<8f", i3, p))
    maxx = max(cam[0::2])
    cam = [v + E * 128 if (i % 2 == 0 and v == maxx) else v for i, v in enumerate(cam)]
    struct.pack_into("<8f", i3, p, *cam)
    p += 32 + 16
    pw = struct.unpack_from("<i", i3, p)[0]
    struct.pack_into("<i", i3, p, pw + E)
    # 5. script camera bounds
    js = os.path.join(SRC, "Scripts", "war3map.j")
    s = rd(js).decode("utf-8")
    line = re.search(r"call SetCameraBounds\([^\r\n]*\)", s).group(0)
    # Extract the actual right margin from the script
    m = re.search(r"([0-9\.]+)-GetCameraMargin\(CAMERA_MARGIN_RIGHT\)", line)
    if m:
        old_val = m.group(1)
        new_val = "%d." % (int(float(old_val)) + E * 128)
        s = s.replace(
            line,
            line.replace(
                old_val + "-GetCameraMargin(CAMERA_MARGIN_RIGHT)", new_val + "-GetCameraMargin(CAMERA_MARGIN_RIGHT)"
            ),
        )
    open(js, "wb").write(s.encode("utf-8"))

    # 6. minimap icons + image (the 256 px minimap shows the whole map, longest side fitted, centred)
    def fit(mx, my):
        sc = 256.0 / max(mx - 1, my - 1)
        return sc, (256 - (mx - 1) * sc) / 2, (256 - (my - 1) * sc) / 2

    so, ox0, oy0 = fit(omx, omy)
    sn, ox1, oy1 = fit(vw.mx, vw.my)
    mm = bytearray(rd(os.path.join(ORIG, "war3map.mmp")))
    n = struct.unpack_from("<i", mm, 4)[0]
    for j in range(n):
        q = 8 + 16 * j
        x, y = struct.unpack_from("<ii", mm, q + 4)
        tx, ty = (x - ox0) / so, (y - oy0) / so
        struct.pack_into("<ii", mm, q + 4, int(ox1 + tx * sn), int(oy1 + ty * sn))
    img = Image.new("RGB", (256, 256), (0, 0, 0))
    px = img.load()
    for yy in range(256):
        for xx in range(256):
            tx, ty = (xx - ox1) / sn, ((255 - yy) - oy1) / sn
            if 0 <= tx < vw.mx - 1 and 0 <= ty < vw.my - 1:
                c = vp.cells[int(ty * 4) * vp.w + int(tx * 4)]
                if c & 0x02:
                    col = (0, 0, 0)
                elif not c & 0x40:
                    col = (40, 70, 130)
                else:
                    hgt = struct.unpack_from("<h", vw.pt(int(tx), int(ty)), 0)[0]
                    k2 = max(-30, min(30, (hgt - 8192) // 16))
                    col = (95 + k2, 110 + k2, 60 + k2)
                px[xx, yy] = col
    sys.path.insert(0, os.path.dirname(__file__))
    from icons import blp1_palette

    open(os.path.join(SRC, "war3mapMap.blp"), "wb").write(blp1_palette(img, 256))
    # write everything
    open(os.path.join(SRC, "war3map.w3e"), "wb").write(vw.write())
    open(os.path.join(SRC, "war3map.wpm"), "wb").write(vp.write())
    open(os.path.join(SRC, "war3map.shd"), "wb").write(vs.write())
    open(os.path.join(SRC, "war3map.doo"), "wb").write(terrain.write_doo(head, vitems, rest))
    w3d.save()
    open(os.path.join(SRC, "war3map.w3i"), "wb").write(bytes(i3))
    open(os.path.join(SRC, "war3map.mmp"), "wb").write(bytes(mm))

    # points for gameplay.py: entry (Xa Phu arrival, west side) and creep camps (open ground, 700 apart)
    def open_ground(x, y, r):
        cx, cy = int((x - vw.ox) / 32), int((y - vw.oy) / 32)
        for yy in range(cy - r, cy + r + 1):
            for xx in range(cx - r, cx + r + 1):
                if vp.cells[yy * vp.w + xx] & 0x02:
                    return False
        return True

    def write_farm_zone(f, zname, nx, ny, w, h, level, tele):
        nx, ny, w, h = int(nx), int(ny), int(w), int(h)
        cand = [
            (x, y)
            for y in range(ny + 256, ny + h - 256, 160)
            for x in range(nx + 256, nx + w - 256, 160)
            if open_ground(x, y, 4)
        ]
        if len(cand) < 5:
            raise RuntimeError("Bãi farm không đủ điểm đi được: %s (%d điểm)" % (zname, len(cand)))
        mid = ny + h / 2
        entry = min(cand, key=lambda c: (c[0] - nx) + abs(c[1] - mid))
        camps = []
        for min_gap in (700, 500, 350):
            camps = []
            for c in sorted(cand, key=lambda c: (c[0] * 7 + c[1] * 13) % 997):
                if all((c[0] - d[0]) ** 2 + (c[1] - d[1]) ** 2 >= min_gap**2 for d in camps + [entry]):
                    camps.append(c)
            if len(camps) >= 4:
                break
        camps = camps[:4]
        f.write(
            "%s\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%d\n"
            % (zname, nx, ny, nx + w, ny + h, entry[0], entry[1], " ".join("%d:%d" % c for c in camps), level, tele)
        )
        print("  %s (cấp %d): entry %s, %d camps%s" % (zname, level, entry, len(camps), " / Xa Phu" if tele else ""))

    with open(os.path.join(ROOT, "build", "zones.txt"), "w", encoding="utf-8") as f:
        for zname, sx, sy, nx, ny, w, h in zones_out:
            if zname == ARENA:  # not a farm zone: offset for gameplay.py
                open(os.path.join(ROOT, "build", "arena.txt"), "w").write("%d %d %d %d" % (sx, sy, nx, ny))
                continue
            if zname.startswith("Cổng "):
                # Split each of the two gate-side fields into three adjacent level bands.
                # These six bands remain walk-in farms; only the distant fields get Xa Phu NPCs.
                direction = "phía trên" if "Trên" in zname else "phía dưới"
                for i, level in enumerate((1, 20, 40)):
                    x0 = int(nx) + int(w) * i // 3
                    x1 = int(nx) + int(w) * (i + 1) // 3
                    write_farm_zone(f, "Bãi Cấp %d - Cổng %s" % (level, direction), x0, ny, x1 - x0, h, level, 0)
                continue
            level = 60 if "Cấp 60" in zname else (80 if "Cấp 80" in zname else 100)
            write_farm_zone(f, zname, nx, ny, w, h, level, 1)
    print(
        "map %dx%d -> %dx%d tiles, textures %d, doodads +%d (custom types %d), files copied %d"
        % (
            omx - 1,
            omy - 1,
            vw.mx - 1,
            vw.my - 1,
            len(vw.ground),
            len(vitems) - len(terrain.read_doo(rd(os.path.join(ORIG, "war3map.doo")))[1]),
            len(rename),
            len(copied),
        )
    )
    for z in zones_out:
        print("  %s: %d x %d tiles at world (%d, %d)" % (z[0], z[5] // 128, z[6] // 128, z[3], z[4]))


if __name__ == "__main__":
    main()
