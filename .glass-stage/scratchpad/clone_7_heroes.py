import sys, os
sys.path.insert(0, 'tools')
import objdata

p = 'D:/vltk-dev-clone/src/map/war3map.w3u'
ver, tabs = objdata.parse(open(p, 'rb').read(), '.w3u')

heroes_to_add = {
    b'H025': 'Cổ Mộ Châm',
    b'H026': 'Cổ Mộ Kiếm',
    b'H027': 'Hoa Sơn Khí',
    b'H028': 'Hoa Sơn Kiếm',
    b'H029': 'Tiêu Dao Chưởng',
    b'H02A': 'Tiêu Dao Kiếm',
    b'H02B': 'Thúy Yên Song Đao',
}

custom_tab = tabs[1]
h00a = next(x for x in custom_tab if x[1] == b'H00A')

for hid, name in heroes_to_add.items():
    if not any(x[1] == hid for x in custom_tab):
        import copy
        new_hero = copy.deepcopy(h00a)
        new_hero[1] = hid
        for mod in new_hero[2][0]:
            if mod[0] == b'unam':
                mod[4] = name.encode('utf-8')
        custom_tab.append(new_hero)

out_data = objdata.write(ver, tabs, '.w3u')
with open(p, 'wb') as f:
    f.write(out_data)
print('Cloned 7 remaining heroes!')
