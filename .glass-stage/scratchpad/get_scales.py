import sys, re
slk = open(r'D:\kvct-dev\src\map\Units\UnitUI.slk', 'r').read()
rows = slk.split('C;Y')
scales = {}
for r in rows:
    if 'Hero_' in r:
        match_model = re.search(r'X3;K"war3mapImported\\\\(Hero_[^.]+)\.mdl"', r)
        match_scale = re.search(r'X37;K([0-9.]+)', r)
        if match_model and match_scale:
            scales[match_model.group(1)] = match_scale.group(1)
for k, v in scales.items():
    print(k, v)
