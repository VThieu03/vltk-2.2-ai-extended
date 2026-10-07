# python audit_put.py CODE file.md : replace the "### ... (CODE)" section of docs/kvct_audit.md by file.md
import re, sys
code, src = sys.argv[1], sys.argv[2]
p = "docs/kvct_audit.md"
s = open(p, encoding="utf-8", newline="").read()
nl = "\r\n" if "\r\n" in s else "\n"
new = open(src, encoding="utf-8").read().strip("\n").replace("\r\n", "\n").replace("\n", nl)
m = re.search(r"(?m)^### [^\n]*\(" + code + r"\)[^\n]*\r?\n", s)
assert m, code
n = re.search(r"(?m)^### ", s[m.end():])
end = m.end() + n.start() if n else len(s)
s = s[:m.start()] + new + nl + nl + s[end:]
open(p, "w", encoding="utf-8", newline="").write(s)
