# Pipeline build map, viết theo hướng đối tượng.
#   python tools/pipeline.py            build đủ các bước rồi chép map ra thư mục game
#   python tools/pipeline.py --no-ui    bỏ bước ui.py
#   (không có chạy từ giữa: các bước sửa src tại chỗ nên chạy lại một bước sẽ cộng dồn, phải build từ đầu)
# Mỗi bước là một script trong tools/, chạy trong tiến trình riêng qua tools/safe_open.py
# (thử lại khi Windows báo lỗi 1224 / OSError 22 do tiến trình khác đang map file vừa ghi).
import os
import shutil
import subprocess
import sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(TOOLS)


class BuildStep:
    """Một bước của pipeline: một script trong tools/."""

    def __init__(self, script, optional_tag=None):
        self.script = script
        self.tag = optional_tag  # "ui": bỏ được bằng --no-ui

    @property
    def path(self):
        return os.path.join(TOOLS, self.script)

    def run(self):
        print("=== Running %s ===" % self.script)
        wrapper = os.path.join(TOOLS, "safe_open.py")
        cmd = [sys.executable, wrapper, self.path] if os.path.exists(wrapper) else [sys.executable, self.path]
        res = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
        if res.stdout:
            print(res.stdout.strip())
        if res.returncode != 0:
            print("ERROR in %s: returncode %d" % (self.script, res.returncode))
            if res.stderr:
                print(res.stderr.strip())
            return False
        return True


class MapSync:
    """Chép map vừa build ra (các) thư mục game."""

    def __init__(self, source, targets):
        self.source = source
        self.targets = targets

    def run(self):
        print("\n=== Syncing map to target directories ===")
        for target in self.targets:
            folder = os.path.dirname(target)
            if not os.path.exists(folder):
                print("Skipped (folder not found): %s" % folder)
                continue
            try:
                shutil.copy2(self.source, target)
                print("Synced -> %s (%s bytes)" % (target, format(os.path.getsize(target), ",")))
            except PermissionError:
                print("Warning: File is locked by a running Warcraft III process: %s" % target)
            except Exception as e:
                print("Failed to copy to %s: %s" % (target, e))


class Pipeline:
    STEPS = [
        BuildStep("convert_text.py"),
        BuildStep("fix_script.py"),
        BuildStep("expand.py"),
        BuildStep("kvcreep.py"),
        BuildStep("skills.py"),
        BuildStep("tranphai.py"),
        BuildStep("import_boss.py"),
        BuildStep("tanlang.py"),
        BuildStep("lvl200.py"),
        BuildStep("kskill.py"),
        BuildStep("kskill_list.py"),
        BuildStep("gameplay.py"),
        BuildStep("describe.py"),
        BuildStep("kvequip.py"),
        BuildStep("icons.py"),
        BuildStep("kvgem.py"),
        BuildStep("vfx.py"),
        BuildStep("ui.py", "ui"),
        BuildStep("scale.py"),
        BuildStep("build.py"),
    ]
    OUT_MAP = os.path.join(ROOT, "build", "Tong Kim Beta.w3x")
    # chỉ 1 bản map mỗi lần build
    SYNC_TARGETS = [
        r"C:\Users\nguye\OneDrive\Documents\Warcraft III Public Test\Maps\Vo Lam Truyen Ky v2.2 AI 1.31.w3x",
    ]

    def __init__(self, skip_tags=()):
        self.steps = [s for s in self.STEPS if s.tag not in skip_tags]

    def run(self):
        for step in self.steps:
            if not step.run():
                return False
        print("\n>>> ALL PIPELINE STEPS PASSED SUCCESSFULLY! <<<")
        MapSync(self.OUT_MAP, self.SYNC_TARGETS).run()
        return True


def main(argv):
    skip = ("ui",) if "--no-ui" in argv else ()
    sys.exit(0 if Pipeline(skip).run() else 1)


if __name__ == "__main__":
    main(sys.argv[1:])
