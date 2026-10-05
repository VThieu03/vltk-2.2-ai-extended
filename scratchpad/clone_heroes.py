import sys, os
sys.path.insert(0, 'tools')
import objdata

p = 'D:/vltk-dev-clone/src/map/war3map.w3u'
ver, tabs = objdata.parse(open(p, 'rb').read(), '.w3u')

heroes_to_add = {
    b'H020': 'Cái Bang Bổng',
    b'H021': 'Nga My Kiếm',
    b'H022': 'Minh Giáo Chùy',
    b'H023': 'Minh Giáo Kiếm',
    b'H024': 'Đoàn Thị Chỉ'
}

custom_tab = tabs[1]
h00a = next(x for x in custom_tab if x[1] == b'H00A')

for hid, name in heroes_to_add.items():
    if not any(x[1] == hid for x in custom_tab):
        # clone H00A
        import copy
        new_hero = copy.deepcopy(h00a)
        new_hero[1] = hid
        # replace unam
        for mod in new_hero[2][0]:
            if mod[0] == b'unam':
                mod[4] = name.encode('utf-8')
        custom_tab.append(new_hero)

out_data = objdata.write(ver, tabs, '.w3u')
with open(p, 'wb') as f:
    f.write(out_data)
print('Cloned heroes!')
