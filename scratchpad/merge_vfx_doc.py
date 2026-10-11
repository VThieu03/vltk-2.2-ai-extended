"""Merge the per-school KVFX catalogs into one browsable Markdown file."""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "tools" / "kvfx" / "doc"
OUTPUT = ROOT / "docs" / "kvfx_catalog_full.md"


def main():
    files = sorted(p for p in DOCS.glob("*.md") if p.stem != "TRANG_THAI")
    status = DOCS / "TRANG_THAI.md"
    codes = [p.stem for p in files]
    lines = [
        "# Danh mục đầy đủ model + texture của mọi chiêu, mọi phái",
        "",
        "Tự sinh từ `tools/kvfx/doc/*.md`; nguồn cấu hình là `tools/kvfx/hand/<PHÁI>.py`.",
        "Làm mới bằng `python -B -I tools/kvfx_doc.py` rồi `python -B -I scratchpad/merge_vfx_doc.py`.",
        "",
        "## Mục lục (theo mã phái)",
        "",
        " · ".join(f"[{code}](#{code.lower()})" for code in codes),
        "",
    ]
    for path in files:
        body = path.read_text(encoding="utf-8").strip()
        title = body.splitlines()[0].removeprefix("# ")
        lines.extend((f"## {path.stem} - {title}", "", body, ""))
    if status.exists():
        body = status.read_text(encoding="utf-8").strip()
        lines.extend(("## TRANG_THAI", "", body, ""))
    OUTPUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUTPUT.relative_to(ROOT)} ({len(files)} schools)")


if __name__ == "__main__":
    main()
