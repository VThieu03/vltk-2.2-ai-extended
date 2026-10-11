"""Reject native calls absent from the target Warcraft executable, even if pjass knows them."""
from pathlib import Path
import json
import re


MANIFEST = Path(__file__).resolve().parent / "data" / "warcraft-1.31.1-natives.json"
NON_CODE = re.compile(r'"(?:\\.|[^"\\])*"|//[^\r\n]*')


def unsupported_natives(script, common, supported):
    declarations = set(re.findall(r"^\s*(?:constant\s+)?native\s+(\w+)", common, re.M))
    identifiers = set(re.findall(r"\b[A-Za-z_]\w*\b", NON_CODE.sub(" ", script)))
    return sorted((identifiers & declarations) - set(supported))


def check(script_path, common_path):
    target = json.loads(MANIFEST.read_text(encoding="utf-8"))
    missing = unsupported_natives(Path(script_path).read_text(encoding="utf-8"),
                                  Path(common_path).read_text(encoding="utf-8"), target["natives"])
    if missing:
        raise ValueError("native(s) unavailable in Warcraft %s: %s" % (target["version"], ", ".join(missing)))
    print("Warcraft %s native compatibility ok" % target["version"])
