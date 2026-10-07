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
DROP = {
    "gG": ("local integer ic=20", "local integer ic=45"),
    "kG": ("local integer ic=$A", "local integer ic=25"),
    "Rh": ("local integer ic=8", "local integer ic=20"),
}
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

# Give new KVCT equipment after the original hero-registration trigger assigns Jx[pid].
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
i = lines.index("function ZQ takes nothing returns nothing")
j = lines.index("endfunction", i)
hero_set = "set Jx[(1+GetPlayerId(GetOwningPlayer(GetTriggerUnit())))]=GetTriggerUnit()"
k = lines.index(hero_set, i, j)
if k + 1 >= j or lines[k + 1] != "set zzEQ_starterHero[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTriggerUnit()":
    lines.insert(k + 1, "set zzEQ_starterHero[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTriggerUnit()")
    lines.insert(k + 2, "call ExecuteFunc(\"zzEQ_GiveStarter\")")
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("starter KVCT gear hook added")

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

# The author's hero-kill trigger ("X đánh bại Y và nhận được N ngân lượng", Tống / Kim thủ lĩnh, danh hiệu) also fires for
# hero-type creeps of the neutral players (no player name: "Thieulmba đánh bại  và ..."). Run it only for heroes of players 0..9.
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
msg = [i for i, l in enumerate(lines) if '" đánh bại "+(Eo[(1+GetPlayerId(GetOwningPlayer(GetDyingUnit())))]' in l]
assert len(msg) == 1, "kill message line not found"
f = max(i for i in range(msg[0]) if lines[i].startswith("function ") and " takes nothing returns nothing" in lines[i])
guard = "if GetPlayerId(GetOwningPlayer(GetDyingUnit()))>9 then"
if lines[f + 1] != guard:
    lines[f + 1:f + 1] = [guard, "return", "endif"]
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("hero kill message: players 0..9 only")

# Hero revive (original trigger, function with "Hero_Revive" logic): waits 10 s on both branches; wait zzVL_ReviveTime(hero level) instead
# (config.py GAME REVIVE_*: 1-50 5 s, 51-100 7 s, 101-150 8 s, 151-200 10 s)
s = open(P, "rb").read().decode("utf-8")
lines = s.split(nl)
start = [i for i, l in enumerate(lines) if l.startswith("function ") and lines[i:lines.index("endfunction", i)].count("call TriggerSleepAction(10.)") == 2
         and any("ReviveHeroLoc(GetTriggerUnit()" in x for x in lines[i:lines.index("endfunction", i)])]
assert len(start) == 1, start
i = start[0]
j = lines.index("endfunction", i)
n = 0
for k in range(i, j):
    if lines[k] == "call TriggerSleepAction(10.)":
        lines[k] = "call TriggerSleepAction(zzVL_ReviveTime(GetHeroLevel(GetTriggerUnit())))"
        n += 1
assert n == 2, n
open(P, "wb").write(nl.join(lines).encode("utf-8"))
print("hero revive time by level: %d waits" % n)
