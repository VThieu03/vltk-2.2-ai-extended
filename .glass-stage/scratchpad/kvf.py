# helper: python kvf.py ab A0D5 ... (where an ability id is used) | fn name ... (print a function) | cls DTK (skills + ids)
import re, sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
R = r"D:\kvct-dev\work\readable.j"
L = open(R, encoding="utf-8", errors="ignore").read().replace("\r\n", "\n").split("\n")
g1 = L.index("endglobals")
consts = {}
for l in L[:g1]:
    m = re.match(r"\s*(?:constant\s+)?integer\s+(\w+)=(?:\$([0-9A-Fa-f]{8})|(\d{9,10}))\s*$", l)
    if m:
        consts[m.group(1)] = int(m.group(2), 16) if m.group(2) else int(m.group(3))
funcs, order, cur = {}, [], None
for i, l in enumerate(L):
    m = re.match(r"(?:constant\s+)?function (\w+)", l)
    if m and i > g1:
        cur = m.group(1); funcs[cur] = []; order.append(cur)
    if cur:
        funcs[cur].append(l)
        if l.strip() == "endfunction":
            cur = None
def raw(i): return int.from_bytes(i.encode(), "big")
def ab(a):
    v = raw(a)
    names = [c for c, x in consts.items() if x == v]
    alt = "|".join([re.escape("$%08X" % v)] + names)
    pat = re.compile(r"(?<![\w$])(" + alt + r")(?![\w])", re.I)
    out = []
    for f in order:
        for l in funcs[f]:
            if pat.search(l):
                out.append((f, l.strip()))
    return names, out
if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "ab":
        for a in sys.argv[2:]:
            names, out = ab(a)
            print("##", a, names)
            for f, l in out[:40]:
                print("  ", f, "|", l[:170])
    elif cmd == "fn":
        for n in sys.argv[2:]:
            print("\n".join(funcs.get(n, ["? " + n])))
