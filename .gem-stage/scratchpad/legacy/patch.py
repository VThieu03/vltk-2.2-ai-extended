import sys
import re

with open('tools/gameplay.py', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add group zzVL_deadArena to GLOBALS
content = content.replace("constant integer zzVL_XAPHU='h0XP'\"\"\"", "constant integer zzVL_XAPHU='h0XP'\ngroup zzVL_deadArena=null\"\"\"")

# 2. Add Jass functions to DROP_FN (anywhere in the array is fine, it's injected before zzVL_Drop)
jass_code = """
    "function zzVL_InArena takes unit u returns boolean",
    "local real x=GetUnitX(u)",
    "local real y=GetUnitY(u)",
    "return x>8300. and x<10800. and y>-200. and y<6600.",
    "endfunction",
    "function zzVL_ReviveArenaDeadAction takes nothing returns nothing",
    "local unit u=GetEnumUnit()",
    "local player p=GetOwningPlayer(u)",
    "call ReviveHeroLoc(u,GetPlayerStartLocationLoc(p),true)",
    "call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_MAX_LIFE))",
    "call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA))",
    "call PanCameraToTimedForPlayer(p,GetStartLocationX(GetPlayerStartLocation(p)),GetStartLocationY(GetPlayerStartLocation(p)),.0)",
    "endfunction",
    "function zzVL_ReviveArenaDead takes nothing returns nothing",
    "if zzVL_deadArena!=null then",
    "call ForGroup(zzVL_deadArena,function zzVL_ReviveArenaDeadAction)",
    "call GroupClear(zzVL_deadArena)",
    "endif",
    "endfunction",
"""
content = content.replace('DROP_FN = [', 'DROP_FN = [\n' + jass_code)

# 3. Add to script() to inject the python list modifications
py_code = """
    f = lines.index("function xS takes nothing returns nothing")
    lines.insert(f + 1, "if zzVL_InArena(GetTriggerUnit()) then")
    lines.insert(f + 2, "if zzVL_deadArena==null then")
    lines.insert(f + 3, "set zzVL_deadArena=CreateGroup()")
    lines.insert(f + 4, "endif")
    lines.insert(f + 5, "call GroupAddUnit(zzVL_deadArena,GetTriggerUnit())")
    lines.insert(f + 6, "return")
    lines.insert(f + 7, "endif")
"""

idx = content.find('lines[f] = "function zzVL_Wz0 takes nothing returns nothing"')
if idx != -1:
    content = content[:idx] + py_code.strip() + "\n    " + content[idx:]

# 4. Modify GroupClear(V) and GroupClear(E) to also call zzVL_ReviveArenaDead
py_code2 = """
    for i in range(len(lines)-1, -1, -1):
        if lines[i] == "call GroupClear(V)":
            lines.insert(i + 1, "call zzVL_ReviveArenaDead()")
        if lines[i] == "call GroupClear(E)":
            lines.insert(i + 1, "call zzVL_ReviveArenaDead()")
"""
idx = content.find('for i in range(g + 1 + len(DROP_FN), len(lines)):')
if idx != -1:
    content = content[:idx] + py_code2.strip() + "\n    " + content[idx:]


with open('tools/gameplay.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Patched gameplay.py successfully')
