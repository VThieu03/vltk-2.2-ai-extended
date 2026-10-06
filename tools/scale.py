# Make the whole map S times bigger (world coordinates x' = S*x around the origin): terrain corners,
# pathing / shadow cells and doodads are resampled / moved, camera bounds and playable size scaled, and in
# the script every absolute coordinate written as a number (Rect, CreateUnit, SetUnitPosition, ...) and
# the creep camp / zone points of gameplay.py. Unit / doodad sizes, skill ranges and offsets stay the same.
# The minimap image and icons need no change (the whole map keeps its proportions).
# Run after icons.py, before build.py.
import os, re, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import terrain

S = 1.5
SRC = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map")
# call name -> indexes of the arguments that are world x / y
CALLS = {
    "Rect": (0, 1, 2, 3), "SetRect": (1, 2, 3, 4), "Location": (0, 1), "MoveRectTo": (1, 2),
    "CreateUnit": (2, 3), "BlzCreateUnitWithSkin": (2, 3), "CreateItem": (1, 2), "CreateDestructable": (1, 2),
    "CreateDestructableZ": (1, 2), "SetUnitPosition": (1, 2), "SetUnitX": (1,), "SetUnitY": (1,),
    "IssuePointOrder": (2, 3), "IssuePointOrderById": (2, 3), "PanCameraToTimedForPlayer": (1, 2),
    "PanCameraToTimed": (0, 1), "SetCameraPosition": (0, 1), "SetCameraQuickPosition": (0, 1),
    "DefineStartLocation": (1, 2), "PingMinimap": (0, 1), "PingMinimapEx": (0, 1), "AddSpecialEffect": (1, 2),
    "GroupEnumUnitsInRange": (1, 2), "CreateFogModifierRadius": (2, 3), "SetCameraBounds": tuple(range(8)),
    "CreateTrackable": (1, 2), "CameraSetupSetDestPosition": (1, 2), "CreateUnitAtLocSaveLast": (), "ReviveHero": (1, 2),
}
NUM = re.compile(r"^(-?\d+\.?\d*|-?\.\d+)(?=$|[+\-])")


def split_args(s, i):
    """s[i] is '(' : list of (start, end) of the top-level arguments and the index after ')'"""
    depth, start, out, k, instr = 0, i + 1, [], i, False
    while k < len(s):
        c = s[k]
        if instr:
            if c == "\\":
                k += 1
            elif c == '"':
                instr = False
        elif c == '"':
            instr = True
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                out.append((start, k))
                return out, k + 1
        elif c == "," and depth == 1:
            out.append((start, k))
            start = k + 1
        k += 1
    raise ValueError("unbalanced call")


def scale_num(a):
    m = NUM.match(a)
    if not m:
        return a
    v = float(m.group(1)) * S
    return ("%d." % round(v)) + a[m.end():]


def script(s):
    pat = re.compile(r"\b(%s)\(" % "|".join(CALLS))
    out, p = [], 0
    for m in pat.finditer(s):
        if m.start() < p:
            continue
        idx = CALLS[m.group(1)]
        args, end = split_args(s, m.end() - 1)
        if m.group(1) == "Rect" and all(float(NUM.match(s[x:y]).group(1)) == 0 if NUM.match(s[x:y]) and NUM.match(s[x:y]).end() == y - x else False for x, y in args[:2]):
            idx = ()                                      # Rect(0,0,w,h): a size, moved later with MoveRectTo
        out.append(s[p:m.end()])
        parts = []
        for n, (a, b) in enumerate(args):
            t = s[a:b]
            parts.append(scale_num(t) if n in idx else t)
        out.append(",".join(parts) + ")")
        p = end
    out.append(s[p:])
    s = "".join(out)
    # gameplay.py: creep camps and zone entries
    s = re.sub(r"(set (?:zzVL_(?:cX|cY|zEx|zEy|homeX|homeY)\[\d+\]|vl_x|vl_y)=)(-?\d[\d.]*)(?=\s|$)", lambda m: m.group(1) + scale_num(m.group(2)), s)
    return s


def resample_w3e(w):
    nx, ny = round((w.mx - 1) * S) + 1, round((w.my - 1) * S) + 1
    pts = []
    for y in range(ny):
        oy = min(w.my - 1, int(y / S + .5))
        for x in range(nx):
            pts.append(bytearray(w.pt(min(w.mx - 1, int(x / S + .5)), oy)))
    w.mx, w.my, w.pts = nx, ny, pts
    w.ox, w.oy = w.ox * S, w.oy * S


def resample_grid(g, ow, oh, nw, nh):
    cells = bytearray(nw * nh)
    for y in range(nh):
        oy = min(oh - 1, int(y / S)) * ow
        for x in range(nw):
            cells[y * nw + x] = g.cells[oy + min(ow - 1, int(x / S))]
    g.cells = cells
    if g.header:
        g.w, g.h = nw, nh


def w3i(data, omx, omy, nmx, nmy):
    i3 = bytearray(data)
    p = 12
    for _ in range(4):
        p = i3.index(b"\0", p) + 1
    cam = struct.unpack_from("<8f", i3, p)
    struct.pack_into("<8f", i3, p, *[v * S for v in cam])
    p += 32
    comp = struct.unpack_from("<4i", i3, p)
    nc = [round(c * S) for c in comp]
    struct.pack_into("<4i", i3, p, *nc)
    p += 16
    struct.pack_into("<ii", i3, p, (nmx - 1) - nc[0] - nc[1], (nmy - 1) - nc[2] - nc[3])
    return bytes(i3)


def main():
    rd = lambda f: open(os.path.join(SRC, f), "rb").read()
    wr = lambda f, d: open(os.path.join(SRC, f), "wb").write(d)
    w = terrain.W3E(rd("war3map.w3e"))
    omx, omy = w.mx, w.my
    resample_w3e(w)
    for f, hdr in (("war3map.wpm", True), ("war3map.shd", False)):
        g = terrain.Grid(rd(f), hdr)
        resample_grid(g, (omx - 1) * 4, (omy - 1) * 4, (w.mx - 1) * 4, (w.my - 1) * 4)
        wr(f, g.write())
    wr("war3map.w3e", w.write())
    head, items, rest = terrain.read_doo(rd("war3map.doo"))
    for it in items:
        it["x"] *= S
        it["y"] *= S
    wr("war3map.doo", terrain.write_doo(head, items, rest))
    wr("war3map.w3i", w3i(rd("war3map.w3i"), omx, omy, w.mx, w.my))
    js = os.path.join("Scripts", "war3map.j")
    wr(js, script(rd(js).decode("utf-8")).encode("utf-8"))
    print("map x%.2f: %dx%d -> %dx%d tiles, %d doodads" % (S, omx - 1, omy - 1, w.mx - 1, w.my - 1, len(items)))


if __name__ == "__main__":
    main()
