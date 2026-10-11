"""Refresh only the generated zzVL_Items* table in already-integrated JASS scripts."""

import os
import re
import sys


TOOLS = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(TOOLS)
sys.path.insert(0, TOOLS)
import gameplay


def generated_block(rows):
    out = []
    parts = []
    for start in range(0, len(rows), 1200):
        name = "zzVL_Items%d" % (start // 1200)
        parts.append(name)
        out += ["function %s takes nothing returns nothing" % name]
        out += rows[start : start + 1200]
        out += ["endfunction"]
    out += ["function zzVL_Items takes nothing returns nothing"]
    out += ['call ExecuteFunc("%s")' % name for name in parts]
    out += ["endfunction"]
    return out


def refresh(path, block):
    data = open(path, "rb").read().decode("utf-8")
    starts = list(re.finditer(r"function zzVL_Items\d+ takes nothing returns nothing", data))
    if not starts:
        raise RuntimeError("generated table not found in " + path)
    dispatcher = re.search(r"function zzVL_Items takes nothing returns nothing", data[starts[-1].end() :])
    if not dispatcher:
        raise RuntimeError("zzVL_Items dispatcher not found in " + path)
    dispatcher_end = starts[-1].end() + dispatcher.end()
    end = data.index("endfunction", dispatcher_end) + len("endfunction")
    old_count = len(starts)
    updated = data[: starts[0].start()] + "\r".join(block) + data[end:]
    if os.path.basename(os.path.dirname(path)) == "build":
        updated = updated.replace("\r\n", "\n").replace("\r", "\n")
    open(path, "wb").write(updated.encode("utf-8"))
    return old_count, sum(line.startswith("function zzVL_Items") for line in block)


def main():
    block = generated_block(gameplay.table())
    paths = [
        os.path.join(ROOT, "src", "map", "Scripts", "war3map.j"),
        os.path.join(ROOT, "build", "war3map.j"),
    ]
    for path in paths:
        old, new = refresh(path, block)
        print("refreshed %s: %d -> %d table functions" % (os.path.relpath(path, ROOT), old, new))


if __name__ == "__main__":
    main()
