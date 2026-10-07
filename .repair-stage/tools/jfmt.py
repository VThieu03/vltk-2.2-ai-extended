# Thut le cac file JASS (tools\kskill.j, tools\vlui.j, tools\jass\*.j): chi doi khoang trang dau dong,
# 4 dau cach moi cap khoi (function, if / elseif / else, loop, globals). Ma lenh giu nguyen tung ky tu.
# Chay: python tools\jfmt.py  (kiem tra: phan da bo khoang trang dau dong cua file truoc / sau phai trung nhau)
import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FILES = [os.path.join(HERE, "kskill.j"), os.path.join(HERE, "vlui.j")] + sorted(
    glob.glob(os.path.join(HERE, "jass", "*.j"))
)

OPEN = re.compile(r"^(function\b|if\b|loop\b|globals\b|(private |public |static )*method\b|struct\b)")
CLOSE = re.compile(r"^(endfunction|endif|endloop|endglobals|endmethod|endstruct)\b")
MID = re.compile(r"^(else|elseif)\b")


def fmt(text):
    out, depth = [], 0
    for line in text.split("\n"):
        s = line.strip()
        if not s:
            out.append("")
            continue
        if s.startswith("//"):  # comment: indent like the code that follows
            out.append("    " * depth + s)
            continue
        if CLOSE.match(s):
            depth = max(0, depth - 1)
            out.append("    " * depth + s)
        elif MID.match(s):
            out.append("    " * max(0, depth - 1) + s)
        else:
            out.append("    " * depth + s)
            if OPEN.match(s) and not s.startswith("function interface"):
                depth += 1
    return "\n".join(out), depth


def main():
    bad = 0
    for f in FILES:
        raw = open(f, "rb").read().decode("utf-8")
        crlf = "\r\n" in raw
        old = raw.replace("\r\n", "\n")
        new, depth = fmt(old)
        if [l.strip() for l in old.split("\n")] != [l.strip() for l in new.split("\n")] or depth != 0:
            print("SKIP (khoi khong can bang hoac ma bi doi):", f, "depth", depth)
            bad += 1
            continue
        if new != old:
            open(f, "wb").write((new.replace("\n", "\r\n") if crlf else new).encode("utf-8"))
            print("formatted", os.path.relpath(f, HERE))
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
