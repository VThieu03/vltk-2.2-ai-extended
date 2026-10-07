import os

root_expr = 'os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))'

def patch_file(relpath, replacements):
    path = os.path.join(os.path.dirname(__file__), "..", relpath)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    for old, new in replacements:
        if old not in content:
            print(f'Warning: {old} not found in {relpath}')
            continue
        content = content.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Patched:', relpath)

patch_file('tools/build.py', [(r'ROOT = r"D:\vltk-dev-clone"', 'ROOT = ' + root_expr)])
patch_file('tools/convert_text.py', [(r'ROOT = r"D:\vltk-dev-clone"', 'ROOT = ' + root_expr)])
patch_file('tools/ctx.py', [(r'root = r"D:\vltk-dev-clone\src\map"', 'root = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/ctx2.py', [(r'r"D:\vltk-dev-clone\src\map"', 'os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/describe.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/expand.py', [(r'ROOT = r"D:\vltk-dev-clone"', 'ROOT = ' + root_expr)])
patch_file('tools/fix_script.py', [(r'P = r"D:\vltk-dev-clone\src\map\Scripts\war3map.j"', 'P = os.path.join(' + root_expr + ', "src", "map", "Scripts", "war3map.j")')])
patch_file('tools/gameplay.py', [
    (r'SRC = r"D:\vltk-dev-clone\src\map"', 'ROOT = ' + root_expr + '\nSRC = os.path.join(ROOT, "src", "map")'),
    (r'open(r"D:\vltk-dev-clone\build\skills_table.j"', 'open(os.path.join(ROOT, "build", "skills_table.j")'),
    (r'open(r"D:\vltk-dev-clone\build\tranphai_table.j"', 'open(os.path.join(ROOT, "build", "tranphai_table.j")'),
    (r'open(r"D:\vltk-dev-clone\build\kskill_table.j"', 'open(os.path.join(ROOT, "build", "kskill_table.j")')
])
patch_file('tools/gameplay_items.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/icons.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/import_boss.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/kskill.py', [
    (r'SRC = r"D:\vltk-dev-clone\src\map"', 'ROOT = ' + root_expr + '\nSRC = os.path.join(ROOT, "src", "map")'),
    (r'TABLE = r"D:\vltk-dev-clone\build\kskill_table.j"', 'TABLE = os.path.join(ROOT, "build", "kskill_table.j")')
])
patch_file('tools/lvl200.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/scale.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
patch_file('tools/scan.py', [(r'r"D:\vltk-dev-clone\src\map\Scripts\war3map.j"', 'os.path.join(' + root_expr + ', "src", "map", "Scripts", "war3map.j")')])
patch_file('tools/skills.py', [(r'ROOT = r"D:\vltk-dev-clone"', 'ROOT = ' + root_expr)])
patch_file('tools/tranphai.py', [(r'ROOT = r"D:\vltk-dev-clone"', 'ROOT = ' + root_expr)])
patch_file('tools/ui.py', [
    (r'SRC = r"D:\vltk-dev-clone\src\map"', 'ROOT = ' + root_expr + '\nSRC = os.path.join(ROOT, "src", "map")'),
    (r'FONT = r"D:\vltk-dev-clone\work\VNVOGU.TTF"', 'FONT = os.path.join(ROOT, "work", "VNVOGU.TTF")')
])
patch_file('tools/vfx.py', [(r'SRC = r"D:\vltk-dev-clone\src\map"', 'SRC = os.path.join(' + root_expr + ', "src", "map")')])
print('All patched!')
