# list script lines that have non-ASCII characters outside string literals
import re
j = open(r"D:\vltk-dev-clone\src\map\Scripts\war3map.j", "rb").read().decode("utf-8")
L = j.replace("\r\n", "\n").replace("\r", "\n").split("\n")
LIT = re.compile(r'"(?:[^"\\]|\\.)*"')
n = 0
for i, l in enumerate(L):
    s = LIT.sub("", l)
    if any(ord(c) > 127 for c in s):
        print(i + 1, l[:160])
        n += 1
        if n > 10:
            break
