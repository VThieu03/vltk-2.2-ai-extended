import sys, os
sys.path.insert(0, r"D:\kvct-dev\tools")
import importlib
mpq = importlib.import_module("mpq")
sys.path.pop(0)

kvct_path = r"D:\kvct-dev\work\base.w3x"
with open(kvct_path, "rb") as kf:
    chunk = kf.read(1024 * 1024)
    off = chunk.find(b"MPQ\x1a")
    if off >= 0:
        m = mpq.MPQ(kvct_path, off)
        r = m.find("(listfile)")
        if r is not None:
            listfile = m.read_block(r[1], "(listfile)").decode("utf-8", errors="ignore")
            with open(r"d:\vltk-2.2-ai-extended\scratchpad\kvct_ui_files.txt", "w", encoding="utf-8") as f:
                for line in listfile.splitlines():
                    if "ui" in line.lower() or "fdf" in line.lower() or "toc" in line.lower() or "bottom" in line.lower() or "skill" in line.lower() or "bar" in line.lower():
                        f.write(line + "\n")
