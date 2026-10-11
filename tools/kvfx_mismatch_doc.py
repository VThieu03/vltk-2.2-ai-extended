"""Write a focused Markdown report of skills marked mismatched by kvfx_trace."""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TRACE = ROOT / "build" / "kvfx_trace.json"
OUTPUT = ROOT / "docs" / "kvfx_mismatch.md"


def render(trace):
    rows = [
        (school, skill)
        for school in trace["phai"]
        for skill in school["skills"]
        if skill.get("compare", {}).get("status") == "lệch"
    ]
    lines = [
        "# Danh sách chiêu bị trace đánh dấu lệch",
        "",
        f"Trace tự động hiện đánh dấu **{len(rows)}** mục lệch (từ `build/kvfx_trace.json`). Đây là danh sách cần đọc cùng dòng call site; nhãn có thể là khác vai trò, khác model, giới hạn biểu diễn hoặc false positive, không đồng nghĩa tất cả là lỗi game.",
        "",
        "Đây là các mục cần rà thủ công, không mặc định mọi khác biệt của heuristic đều là lỗi thật. `KVCT` là phát hiện từ script gốc; `Cấu hình` là VFX đang khai báo.",
        "",
    ]

    for school in trace["phai"]:
        mismatches = [
            skill
            for skill in school["skills"]
            if skill.get("compare", {}).get("status") == "lệch"
        ]
        if not mismatches:
            continue
        lines.extend((f"## {school['code']} - {school['name']}", ""))
        for skill in mismatches:
            passive = " [bị động]" if skill.get("passive") else ""
            lines.append(
                f"### {skill['name']} (`{skill['kv']}`, phím {skill.get('key', '-')}, "
                f"kind {skill.get('kind', '-')}){passive}"
            )
            findings = "; ".join(
                f"{item['model']} -> {item.get('role', '?')} "
                f"({item.get('conf', '?')}; {item.get('func', '?')}:{item.get('line', '?')})"
                for item in skill.get("findings", [])
            )
            lines.append(f"- KVCT: {findings or 'không truy được model cụ thể'}.")
            current = json.dumps(skill.get("config", {}), ensure_ascii=False)
            lines.append(f"- Cấu hình: `{current}`")
            compare = json.dumps(skill.get("compare", {}), ensure_ascii=False)
            lines.append(f"- Chênh lệch: {compare}")
            lines.append("")
    return "\n".join(lines)


if __name__ == "__main__":
    data = json.loads(TRACE.read_text(encoding="utf-8"))
    OUTPUT.write_text(render(data), encoding="utf-8")
    print(f"Wrote {OUTPUT.relative_to(ROOT)}")
