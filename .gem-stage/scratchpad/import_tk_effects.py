import os
import shutil
import re
import sys
import unicodedata

sys.path.insert(0, r"D:\vltk-2.2-ai-extended\tools")
from kskill_data import load, CLASS

data = load()
skill_names = []
for h, cl in CLASS.items():
    sk = data.get(cl, [])
    for s in sk:
        skill_names.append(s["name"])

tk_dir = r"D:\thienkiem-dev\src"
tk_mdx_dir = os.path.join(tk_dir, "MDX")
dest_map_dir = r"D:\vltk-2.2-ai-extended\src\map"

tk_mdx = []
for f in os.listdir(tk_mdx_dir):
    if f.lower().endswith(".mdx"):
        tk_mdx.append(f)

def normalize(s):
    s = ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn')
    return s.lower().replace(" ", "").replace("-", "")

matched = {}
for name in skill_names:
    norm_name = normalize(name)
    for mdx in tk_mdx:
        norm_mdx = mdx.lower().replace(".mdx", "")
        if norm_name == norm_mdx or norm_name in norm_mdx or norm_mdx in norm_name:
            # Prefer exact matches if possible, otherwise first match
            if name not in matched or norm_name == norm_mdx:
                matched[name] = mdx

def extract_textures(mdx_path):
    textures = []
    try:
        content = open(mdx_path, "rb").read()
        # Find all strings that look like texture paths (e.g. .blp, .tga)
        # Using a regex to extract printable strings
        strings = re.findall(b'[a-zA-Z0-9_\\\\/\-\s]+\.(?:blp|tga|BLP|TGA)', content)
        for s in strings:
            textures.append(s.decode('utf-8', errors='ignore'))
    except Exception as e:
        print(f"Error reading {mdx_path}: {e}")
    return textures

print(f"Importing {len(matched)} skills...")

# Generate tk_mapping.py for kskill.py to use
map_file = open(r"D:\vltk-2.2-ai-extended\tools\tk_mapping.py", "w", encoding="utf-8")
map_file.write("TK_OVERRIDES = {\n")

imported_models = set()
for skill, mdx in matched.items():
    mdx_src = os.path.join(tk_mdx_dir, mdx)
    mdx_rel = f"MDX\\{mdx}"
    mdx_dst = os.path.join(dest_map_dir, "MDX", mdx)
    
    if mdx_src not in imported_models:
        os.makedirs(os.path.dirname(mdx_dst), exist_ok=True)
        shutil.copy(mdx_src, mdx_dst)
        imported_models.add(mdx_src)
        
        # Copy required textures
        textures = extract_textures(mdx_src)
        for tex in textures:
            tex_clean = tex.replace("/", "\\")
            tex_src = os.path.join(tk_dir, tex_clean)
            
            # If not found directly, maybe it's in the root or Textures dir?
            if not os.path.exists(tex_src):
                basename = os.path.basename(tex_clean)
                alt_paths = [
                    os.path.join(tk_dir, basename),
                    os.path.join(tk_dir, "Textures", basename),
                    os.path.join(tk_dir, "ReplaceableTextures", "CommandButtons", basename)
                ]
                for p in alt_paths:
                    if os.path.exists(p):
                        tex_src = p
                        break
            
            if os.path.exists(tex_src):
                tex_dst = os.path.join(dest_map_dir, tex_clean)
                os.makedirs(os.path.dirname(tex_dst), exist_ok=True)
                shutil.copy(tex_src, tex_dst)
                print(f"  Copied texture: {tex_clean}")
            else:
                print(f"  Warning: Texture not found {tex_clean}")

    # Map the skill
    map_file.write(f'    "{skill}": r"{mdx_rel}",\n')
    print(f"Mapped: {skill} -> {mdx_rel}")

map_file.write("}\n")
map_file.close()

print("Done importing and mapping.")
