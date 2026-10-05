import os

with open('tools/gameplay.py', 'r', encoding='utf-8') as f:
    content = f.read()

target = 'rows.append("call SaveInteger(zzVL_ht,\'%s\',57,%d)" % (iid, lv))'

new_heroes = ['H020', 'H021', 'H022', 'H023', 'H024', 'H025', 'H026', 'H027', 'H028', 'H029', 'H02A', 'H02B']
inject = []
for h in new_heroes:
    inject.append(f'    rows.append("call GroupAddUnit(Ge, CreateUnit(Player(15), \'{h}\', 0, 0, 0))")')

new_content = target + '\n' + '\n'.join(inject)

content = content.replace(target, new_content)

with open('tools/gameplay.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
