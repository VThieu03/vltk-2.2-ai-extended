import os

slk = open(r"D:\kvct-dev\src\map\Units\AbilityData.slk", encoding="utf-8", errors="ignore").read()
cols, rows = {}, {}
for l in slk.split("\n"):
    if l.startswith("C;"):
        f = {p[0]: p[1:] for p in l.strip().split(";")[1:] if p}
        y = int(f["Y"]) if "Y" in f else cur_y
        cur_y = y
        x, v = int(f["X"]), f.get("K", "").strip('"')
        if y == 1:
            cols[v] = x
            inv_cols = {x: v for v, x in cols.items()}
        rows.setdefault(y, {})[x] = v

for r in rows.values():
    code = r.get(1, "")
    if code in ("A06U", "A08K", "A07N", "A0G2"):  # Some Q/W/E abilities
        print("Code:", code)
        for col_name, x in cols.items():
            if x in r and r[x]:
                print(f"  {col_name}: {r[x]}")
