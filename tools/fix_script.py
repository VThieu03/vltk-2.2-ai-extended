# Bug fixes in the original script (applied to src\map\Scripts\war3map.j after convert_text.py).
# dh / th (boss drop to nearby heroes): "local group g" was never created, so the first use read an
# uninitialized local and the thread stopped: the drops never happened. Create it, destroy it at the end.
import os, re
P = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), "src", "map", "Scripts", "war3map.j")
s = open(P, "rb").read().decode("utf-8")
nl = "\r" if "\r\n" not in s and "\r" in s else ("\r\n" if "\r\n" in s else "\n")
lines = s.split(nl)
fixed = []
i = 0
while i < len(lines):
    m = re.match(r"function (dh|th) takes nothing returns nothing$", lines[i])
    if m:
        j = i
        while lines[j] != "endfunction":
            if lines[j] == "local group g":
                lines[j] = "local group g=CreateGroup()"
            j += 1
        if lines[j - 1] != "call DestroyGroup(g)":
            lines.insert(j, "call DestroyGroup(g)")
            lines.insert(j + 1, "set g=null")
        fixed.append(m.group(1))
    i += 1
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("fixed:", fixed)

# Drop rate of creeps (user request): the author's 3 death handlers roll GetRandomInt(1,100)<=ic.
#   gG elite creeps (Manh Lang, Thich Lang, Dai Hung) 20% -> 45% (2 items)
#   kG creeps level 10-39 10% -> 25%,  Rh creeps level 2-9 8% -> 20%
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
DROP = {"gG": ("local integer ic=20", "local integer ic=45"),
        "kG": ("local integer ic=$A", "local integer ic=25"),
        "Rh": ("local integer ic=8", "local integer ic=20")}
done = []
for name, (old, new) in DROP.items():
    i = lines.index("function %s takes nothing returns nothing" % name)
    j = lines.index("endfunction", i)
    k = lines.index(old, i, j)
    lines[k] = new
    done.append(name)
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("drop rates:", done)

# Starting money (user request): every player starts with 1000 gold (set by the gameplay module) and the
# hero pick no longer gives user players a "Tien xu" coin item (sold for 2000).
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
i = lines.index("function ZQ takes nothing returns nothing")
j = lines.index("endfunction", i)
k = lines.index("call UnitAddItemByIdSwapped('I06Z',GetTriggerUnit())", i, j)
del lines[k]
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("start coin removed")

# The Hanh Trang keeps a player's bag items hidden on the ground. The author's cleanup removes every item
# with no hero within 600 (St, every few seconds) and the items in two base rects (mM, MM): skip hidden ones.
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
done = []
for name in ("St", "mM", "MM"):
    i = lines.index("function %s takes nothing returns nothing" % name)
    j = lines.index("endfunction", i)
    for k in range(i, j):
        if lines[k] == "call RemoveItem(GetEnumItem())":
            lines[k] = "if IsItemVisible(GetEnumItem()) then" + nl + "call RemoveItem(GetEnumItem())" + nl + "endif"
            done.append(name)
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("item cleanup skips hidden items:", done)
