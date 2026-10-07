import sys
import re

with open('tools/gameplay.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the broken block
broken = \"\"\"f = lines.index("function Wz takes nothing returns nothing")
    f = lines.index("function xS takes nothing returns nothing")
    lines.insert(f + 1, "if zzVL_InArena(GetTriggerUnit()) then")
    lines.insert(f + 2, "if zzVL_deadArena==null then")
    lines.insert(f + 3, "set zzVL_deadArena=CreateGroup()")
    lines.insert(f + 4, "endif")
    lines.insert(f + 5, "call GroupAddUnit(zzVL_deadArena,GetTriggerUnit())")
    lines.insert(f + 6, "return")
    lines.insert(f + 7, "endif")\"\"\"

fixed = \"\"\"f_xS = lines.index("function xS takes nothing returns nothing")
    # find end of locals
    local_idx = f_xS + 1
    while lines[local_idx].startswith("local "):
        local_idx += 1
    lines.insert(local_idx, "if zzVL_InArena(GetTriggerUnit()) then")
    lines.insert(local_idx + 1, "if zzVL_deadArena==null then")
    lines.insert(local_idx + 2, "set zzVL_deadArena=CreateGroup()")
    lines.insert(local_idx + 3, "endif")
    lines.insert(local_idx + 4, "call GroupAddUnit(zzVL_deadArena,GetTriggerUnit())")
    lines.insert(local_idx + 5, "return")
    lines.insert(local_idx + 6, "endif")
    f = lines.index("function Wz takes nothing returns nothing")\"\"\"

content = content.replace(broken, fixed)

with open('tools/gameplay.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Fixed gameplay.py successfully')
