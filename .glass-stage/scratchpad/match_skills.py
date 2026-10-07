import os
import sys

# Load KVCT skill names
sys.path.insert(0, r"D:\vltk-2.2-ai-extended\tools")
from kskill_data import load, CLASS

data = load()
skill_names = []
for h, cl in CLASS.items():
    sk = data.get(cl, [])
    for s in sk:
        skill_names.append(s["name"])

# Load Thien Kiem MDX files
tk_mdx = []
tk_dir = r"D:\thienkiem-dev\src\MDX"
for f in os.listdir(tk_dir):
    if f.lower().endswith(".mdx"):
        tk_mdx.append(f)

print(f"Total KVCT Skills: {len(skill_names)}")
print(f"Total Thien Kiem MDX: {len(tk_mdx)}")

# Try to do a naive match (remove spaces, unaccent)
import unicodedata
def normalize(s):
    s = ''.join(c for c in unicodedata.normalize('NFD', s)
                  if unicodedata.category(c) != 'Mn')
    return s.lower().replace(" ", "").replace("-", "")

matched = []
for name in skill_names:
    norm_name = normalize(name)
    for mdx in tk_mdx:
        norm_mdx = mdx.lower().replace(".mdx", "")
        if norm_name == norm_mdx or norm_name in norm_mdx or norm_mdx in norm_name:
            matched.append((name, mdx))

print(f"Matched {len(matched)} skills!")
for m in set(matched):
    print(f"{m[0]} -> {m[1]}")
