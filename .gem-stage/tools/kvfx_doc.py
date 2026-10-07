# Viet mo ta model + texture cua tung chieu, moi phai 1 file: tools/kvfx/doc/<PHAI>.md  (de tu sua sau nay)
# Nguon su that = nhung gi map dang dung: build/kskill_table.j (model moi chieu) + file .mdx trong src/map/war3mapImported (texture).
# Chay sau pipeline: python tools/kvfx_doc.py
import collections
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import config
import kvfx
import kskill
from kvfx_catalog import write_catalog
import vfx
from kskill_data import CLASS, load

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
IMP = os.path.join(ROOT, "src", "map", "war3mapImported")
OUT = os.path.join(HERE, "kvfx", "doc")
ROLE = {
    250: "chính (đạn bay / vùng / hiệu ứng)",
    280: "lúc tung (trên tướng)",
    282: "lúc tung 2 (trên tướng)",
    281: "trên địch bị trúng",
    283: "trên địch bị trúng 2",
    284: "buff (trên tướng)",
    285: "lớp thêm tại điểm 1",
    286: "lớp thêm tại điểm 2",
    287: "aura bị động (gắn tướng suốt)",
}
STATUS_NAME = {1: ("thọ thương (câm lặng)", None), 2: ("định thân", None), 3: ("choáng", None), 4: ("làm chậm", None), 5: ("bỏng (nhận thêm 50% sát thương)", None)}
CLASS_OF_PREFIX = {c: c for c in set(CLASS.values())}


def textures_of(model):
    path = os.path.join(IMP, *model.split("\\"))
    if not os.path.exists(path):
        return None
    return vfx.textures(open(path, "rb").read())


def main():
    table = open(os.path.join(ROOT, "build", "kskill_table.j"), encoding="utf-8").read()
    per = collections.defaultdict(dict)  # skill id -> {key: model}
    for m in re.finditer(r"call SaveStr\(zzVL_ht,'(\w{4})',(\d+),\"war3mapImported\\([^\"]+)\"\)", table):
        k = int(m.group(2))
        if k in ROLE:
            per[m.group(1)][k] = m.group(3).replace("\\\\", "\\").lstrip("\\")
    stat = collections.defaultdict(dict)  # skill id -> {242 status, 243 chance %, 244 tenths of a second}
    for m in re.finditer(r"call SaveInteger\(zzVL_ht,'(\w{4})',(242|243|244),(\d+)\)", table):
        stat[m.group(1)][int(m.group(2))] = int(m.group(3))
    flags = collections.defaultdict(dict)
    for m in re.finditer(r"call SaveInteger\(zzVL_ht,'(\w{4})',(288|289|290|294),(\d+)\)", table):
        flags[m.group(1)][int(m.group(2))] = int(m.group(3))
    hero_skill = collections.defaultdict(dict)  # hero -> index -> skill id
    for m in re.finditer(r"call SaveInteger\(zzVL_ht,'(\w{4})',(2[01]\d),'(X\d+|Y\d+)'\)", table):
        hero_skill[m.group(1)][int(m.group(2)) - 200] = m.group(3)
    # which classes use a model (to tell "own" from "shared")
    users = collections.defaultdict(set)
    data = load()
    for hero, cl in CLASS.items():
        for i, s in enumerate(data[cl][:14]):
            sid = hero_skill[hero].get(i)
            for mdl in per.get(sid, {}).values():
                users[mdl].add(cl)
    os.makedirs(OUT, exist_ok=True)
    for hero, cl in CLASS.items():
        lines = [
            "# %s (%s): model và texture của từng chiêu" % (cl, hero),
            "",
            "Tự sinh bởi `python tools/kvfx_doc.py` (đừng sửa tay file này). Muốn đổi model: sửa `tools/kvfx/hand/%s.py`" % cl,
            "(các khóa `main`, `cast`, `target`, `area`, `aura`, `scale`), chạy lại pipeline rồi chạy lại `kvfx_doc.py`.",
            "Muốn đổi hình của một model: mở file `.mdx` trong `src/map/war3mapImported` bằng Retera Model Studio và sửa",
            "texture (`.blp`) liệt kê ở dưới. **Riêng phái** = model mang tiền tố `%s_`; **dùng chung** = model của phái khác," % cl,
            "hoặc model chung của game (`Effect_*`, `MDX/*` của Thiên Kiếm...), sửa sẽ ảnh hưởng cả các phái khác.",
            "",
        ]
        cat = []
        for i, s in enumerate(data[cl][:14]):
            sid = hero_skill[hero].get(i)
            o = kskill.OVR.get(s["kv"], {})
            kind = o.get("kind", s["kind"])
            src = "bảng tay" if kvfx.get(cl, s["name"]) and os.path.exists(os.path.join(HERE, "kvfx", "hand", cl + ".py")) and s["name"] in kvfx._load("hand", cl) else "bảng KVCT tự sinh" if kvfx.get(cl, s["name"]) else "chọn theo tên / tk_mapping"
            lines.append("## %d. %s%s  (id %s, kind %s)" % (i + 1, s["name"], " [%s]" % s["key"] if s["key"] else " [bị động]", sid, kind))
            lines.append("Nguồn model: **%s**" % src)
            cat += ["#", "# %d. %s%s   (kind %s, %s)" % (i + 1, s["name"], " [%s]" % s["key"] if s["key"] else " [bị động]", kind, src)]
            if flags[sid].get(294) and kind in (6, 7, 8, 9, 19):
                lines.append("Hiển thị: model chính **lặp (có Stand)**, game giữ nó trên tướng suốt thời gian buff.")
            st = stat.get(sid, {})
            if st.get(242):
                name_, per_ = STATUS_NAME.get(st[242], (str(st[242]), None))
                mdl_ = config.STATUS_VFX.get(st[242], ("", 0))[0]
                lines.append(
                    "Trạng thái gây ra: **%s** %d%% trong %.1f giây%s"
                    % (name_, st.get(243, 0), st.get(244, 10) / 10.0, " → model trạng thái `%s` (xem TRANG_THAI.md)" % mdl_ if mdl_ else "")
                )
            ms = per.get(sid, {})
            if not ms:
                lines += ["", "Không có model hiệu ứng.", ""]
                continue
            if kind == 0 and 287 not in ms:
                lines += ["", "*Chiêu bị động: KVCT không gắn hiệu ứng cho loại này, game không phát model bên dưới (chỉ là model dự phòng theo tên).*"]
            lines += ["", "| Vai trò | Model | Texture | Loại |", "|---|---|---|---|"]
            for k in sorted(ms):
                mdl = ms[k]
                base = os.path.basename(mdl.replace("\\", "/"))
                own = base.upper().startswith(cl + "_")
                shared = sorted(c for c in users[mdl] if c != cl)
                kind_txt = "riêng phái" if own and not shared else ("riêng phái, phái khác cũng dùng: " + ", ".join(shared)) if own else ("dùng chung" + (" (model Thiên Kiếm)" if mdl.upper().startswith("MDX\\") else "") + (" (cùng dùng: " + ", ".join(shared) + ")" if shared else ""))
                tex = textures_of(mdl)
                tex_txt = "không thấy file model" if tex is None else (", ".join("`%s`" % t for t in tex) or "(không có texture ngoài)")
                extra = []
                if k in (281, 280) and flags[sid].get(288 if k == 281 else 289):
                    extra.append("đặt dưới đất (model sàn)")
                if k == 250 and flags[sid].get(290):
                    extra.append("kích cỡ %d%%" % flags[sid][290])
                lines.append("| %s%s | `%s` | %s | %s |" % (ROLE[k], " (" + ", ".join(extra) + ")" if extra else "", mdl, tex_txt, kind_txt))
                cat.append("#    %s: %s   [%s]" % (ROLE[k], mdl, kind_txt))
                for t_ in tex or []:
                    cat.append("#         texture: %s" % t_)
            lines.append("")
        open(os.path.join(OUT, cl + ".md"), "w", encoding="utf-8").write("\n".join(lines))
        write_catalog(cl, cat)
    t = [
        "# Model trạng thái gắn lên địch (cấu hình: `STATUS_VFX` trong `tools/config.py`)",
        "",
        "Tự sinh bởi `python tools/kvfx_doc.py`. Mỗi trạng thái do đòn đánh / chiêu gây ra sẽ gắn model dưới đây lên địch trong suốt thời gian",
        "trạng thái. Đổi model: sửa `STATUS_VFX`; đổi hình: sửa texture của model trong Retera Model Studio.",
        "",
        "| Trạng thái | Model | Lượt chạy | Texture |",
        "|---|---|---|---|",
    ]
    for st_, (mdl_, per_) in sorted(config.STATUS_VFX.items()):
        tex_ = textures_of(mdl_)
        t.append("| %s | `%s` | %s | %s |" % (STATUS_NAME[st_][0], mdl_, "tự lặp" if not per_ else "đặt lại mỗi %.1f giây" % per_, "không thấy file" if tex_ is None else ", ".join("`%s`" % x for x in tex_)))
    t += ["", "Trạng thái **choáng** và **thọ thương** vẫn dùng hiệu ứng gốc của game (choáng: Thunderclap trên đầu); thọ thương không có hiệu ứng.", ""]
    open(os.path.join(OUT, "TRANG_THAI.md"), "w", encoding="utf-8").write("\n".join(t))
    print("wrote %d files -> %s" % (len(set(CLASS.values())), OUT))


if __name__ == "__main__":
    main()
