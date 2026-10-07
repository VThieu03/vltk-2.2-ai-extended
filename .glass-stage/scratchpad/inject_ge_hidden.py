import os

with open('tools/gameplay.py', 'r', encoding='utf-8') as f:
    content = f.read()

import re
# Remove the old inject
content = re.sub(r'\n    rows\.append\("call GroupAddUnit\(Ge, CreateUnit\(Player\(15\), \'H02[^\']+\', 0, 0, 0\)\)"\)', '', content)

target = 'rows.append("call SaveInteger(zzVL_ht,\'%s\',57,%d)" % (iid, lv))'

new_heroes = ['H020', 'H021', 'H022', 'H023', 'H024', 'H025', 'H026', 'H027', 'H028', 'H029', 'H02A', 'H02B']
inject = []
for h in new_heroes:
    inject.append(f'    rows.append("set zzVL_pickU = CreateUnit(Player(15), \'{h}\', 0, 0, 0)")')
    inject.append(f'    rows.append("call ShowUnit(zzVL_pickU, false)")')
    inject.append(f'    rows.append("call GroupAddUnit(Ge, zzVL_pickU)")')

new_content = target + '\n' + '\n'.join(inject)

content = content.replace(target, new_content)

with open('tools/gameplay.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
