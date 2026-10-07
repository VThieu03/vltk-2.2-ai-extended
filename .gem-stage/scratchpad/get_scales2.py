import sys
with open(r'D:\kvct-dev\src\map\Units\UnitUI.slk', 'r') as f:
    lines = f.readlines()

current_id = None
model = None
scale = None

results = {}

for line in lines:
    if line.startswith('C;Y'):
        if model and scale:
            results[model] = scale
        model = None
        scale = None
    elif 'war3mapImported\\\\Hero_' in line:
        import re
        m = re.search(r'"war3mapImported\\\\([^"]+)\.mdl"', line)
        if m:
            model = m.group(1)
    elif 'X37;K' in line:
        import re
        m = re.search(r'X37;K([0-9.]+)', line)
        if m:
            scale = m.group(1)

if model and scale:
    results[model] = scale

for k, v in results.items():
    print(f'{k}: {v}')
