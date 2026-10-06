import os, subprocess, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
TOOLS = os.path.join(ROOT, "tools")

pipeline = [
    "convert_text.py",
    "fix_script.py",
    "expand.py",
    "skills.py",
    "tranphai.py",
    "import_boss.py",
    "lvl200.py",
    "kskill.py",
    "gameplay.py",
    "describe.py",
    "icons.py",
    "vfx.py",
    "ui.py",
    "scale.py",
    "build.py"
]

for step in pipeline:
    script_path = os.path.join(TOOLS, step)
    print(f"=== Running {step} ===")
    res = subprocess.run([sys.executable, script_path], cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if res.stdout:
        print(res.stdout.strip())
    if res.returncode != 0:
        print(f"ERROR in {step}: returncode {res.returncode}")
        if res.stderr:
            print(res.stderr.strip())
        sys.exit(1)

print("\n>>> ALL PIPELINE STEPS PASSED SUCCESSFULLY! <<<")

# Auto-sync built map to Warcraft III maps directory and local Maps folder
import shutil
out_map = os.path.join(ROOT, "build", "VLTK-1.31.w3x")
sync_targets = [
    os.path.join(ROOT, "Maps", "Vo Lam Truyen Ky v2.2 AI 1.31.w3x"),
    r"C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x"
]

print("\n=== Syncing map to target directories ===")
for target in sync_targets:
    target_dir = os.path.dirname(target)
    if os.path.exists(target_dir):
        shutil.copy2(out_map, target)
        print(f"Synced -> {target} ({os.path.getsize(target):,} bytes)")
    else:
        print(f"Skipped (folder not found): {target_dir}")

