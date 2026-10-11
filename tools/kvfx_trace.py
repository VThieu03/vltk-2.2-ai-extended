# Truy vết model hiệu ứng của từng chiêu KVCT từ code gốc (D:\kvct-dev\work\readable.j):
#   - tập hàm của chiêu = hàm tung chiêu (GetSpellAbilityId()==mã) + hàm nó gọi tới 4 tầng (bỏ lõi dùng chung,
#     logic lấy từ kvread.py) + các khối if trong TOÀN BỘ script có điều kiện nhắc tới mã chiêu
#     (GetUnitAbilityLevel(u,mã)...) hoặc "sG[..]==số phái và xT==ô" (nhánh học/nâng bị động kiểu hàm Jdn);
#   - mỗi chỗ nhắc tới model (hằng số chuỗi .mdl/.mdx hoặc chuỗi trực tiếp) được ghi: kiểu gọi, hàm, dòng, ngữ cảnh
#     (gắn ai, điểm nào, trong timer / vòng quét nhóm, hủy ngay hay lưu mảng giữ lâu, scale, Z) và vai trò ĐỀ XUẤT;
#   - so với cấu hình hiện tại tools/kvfx/hand/<PHÁI>.py (kvfx.get).
# Ghi build\kvfx_trace.json và docs\kvfx_trace.md.   python -B -I tools/kvfx_trace.py
import os, re, sys, json, collections

TOOLS = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, TOOLS)
import kvread as kr          # đọc readable.j lúc import: kr.L, kr.body, kr.calls, kr.consts, kr.handlers, kr.reach
from model import Phai
import kvfx

ROOT = os.path.abspath(os.path.join(TOOLS, ".."))
OUT_JSON = os.path.join(ROOT, "build", "kvfx_trace.json")
OUT_MD = os.path.join(ROOT, "docs", "kvfx_trace.md")
L = kr.L
DEPTH = 6     # số tầng gọi hàm đi theo từ hàm tung chiêu (kvread dùng 4; chuỗi timer CBC W eHR->..->eHw cần 5)
ROLES = ("main", "cast", "target", "area", "aura", "buff")

# ---------- 1. chỉ mục script ----------
# dòng bắt đầu của từng hàm (số dòng 1-based trong readable.j)
FSTART = {}
for i, l in enumerate(L):
    m = re.match(r"(?:constant\s+)?function (\w+)", l)
    if m and m.group(1) not in FSTART:
        FSTART[m.group(1)] = i + 1
# hằng số chuỗi model: tên -> đường dẫn
MODEL = {}
for l in L[kr.g0 + 1 : kr.g1]:
    m = re.match(r'\s*(?:constant\s+)?string\s+(\w+)="([^"]+\.md[lx])"\s*$', l, re.I)
    if m:
        MODEL[m.group(1)] = m.group(2).replace("\\\\", "\\")
MODEL_RE = re.compile(r"\b(" + "|".join(sorted(MODEL, key=len, reverse=True)) + r")\b")
LIT_RE = re.compile(r'"([^"]+\.md[lx])"', re.I)
DYN_RE = re.compile(r'"([^"]+)"\+[^"]*\+"(\.md[lx])"', re.I)


def base(path):
    """tên file model so sánh được: bỏ thư mục + đuôi, chữ thường"""
    return re.sub(r"\.md[lx]$", "", path.replace("\\\\", "\\").split("\\")[-1], flags=re.I).lower()


# hàm "hủy effect" (kiểu evc): nhận tham số effect và có DestroyEffect
DESTROY = {"DestroyEffect"} | {
    f for f, b in kr.body.items() if re.search(r"takes[^\n]*\beffect\b", b.split("\n")[0]) and "DestroyEffect" in b
}
# hàm được hẹn giờ: tên -> True (lặp) / False (1 lần)
TIMER = {}
for f, b in kr.body.items():
    for m in re.finditer(r"(?:TimerStart\([^,]+,[^,]+,|fS5\([^,]+,)\s*(true|false)\s*,\s*function (\w+)", b):
        TIMER[m.group(2)] = TIMER.get(m.group(2), False) or m.group(1) == "true"
# hàm tạo effect gián tiếp (nhận chuỗi model làm tham số): ghi nó dùng AddSpecialEffectTarget hay AddSpecialEffect
def wrapper_kind(f):
    b = kr.body.get(f, "")
    if "AddSpecialEffectTarget" in b:
        return "AddSpecialEffectTarget"
    if "AddSpecialEffect" in b:
        return "AddSpecialEffect"
    if "CreateUnit" in b:
        return "CreateUnit"
    return ""


# ---------- 2. phái -> số sG, ô -> mã chiêu (hàm J4k: set sG[oY]=N ... set Kuz[oY]="TVT" ... SaveInteger(o8,eRS(oY,Ff),ô,mã)) ----------
CLASS_NO, SLOT, CLASS_ABIL = {}, {}, {}      # code -> N ; mã chiêu (int) -> (N, ô) ; ability đánh dấu phái -> N
_n, _prev = None, ""
for l in L:
    m = re.match(r"set sG\[oY\]=(\d+)$", l)
    if m:
        _n = int(m.group(1))
        mm = re.match(r"if GetUnitAbilityLevel\(oy,(\$[0-9A-F]{8})\)>0 then$", _prev)
        if mm:
            CLASS_ABIL.setdefault(mm.group(1), _n)
        continue
    _prev = l
    m = re.match(r'set Kuz\[oY\]="(\w+)"$', l)
    if m and _n is not None:
        CLASS_NO.setdefault(m.group(1), _n)
        continue
    m = re.match(r"call SaveInteger\(o8,eRS\(oY,Ff\),(\d+),\$([0-9A-F]{8})\)$", l)
    if m and _n is not None:
        SLOT.setdefault(int(m.group(2), 16), (_n, int(m.group(1))))

# Q/W/E (đòn đánh autocast) của KVCT: orb gắn buff lên địch, khi đòn trúng hàm kiểu Jdd xét
#   if GetUnitAbilityLevel(oy,<ability phái>)>0 then
#     if GetUnitAbilityLevel(oR,$42xxxxxx)>0 then ... call <hàm chiêu Q> ... endif   (khối con thứ 1 = Q, 2 = W, 3 = E)
# ORB[(số phái, 0|1|2)] -> [(hàm, chỉ số dòng trong khối con, mã buff)]
ORB = collections.defaultdict(list)
_cls_re = re.compile(r"if GetUnitAbilityLevel\(oy,(\$[0-9A-F]{8})\)>0 then$")
_buf_re = re.compile(r"if GetUnitAbilityLevel\(\w+,\$(42[0-9A-F]{6})\)>0 then$")
for _f, _lines in kr.funcs.items():
    if "$42" not in kr.body[_f]:
        continue
    depth, cls, cls_depth, n, cur = 0, None, 0, 0, None
    for i, l in enumerate(_lines):
        s = l.strip()
        if s.startswith("if "):
            depth += 1
            m = _cls_re.match(s)
            if m and m.group(1) in CLASS_ABIL and cls is None:
                cls, cls_depth, n = CLASS_ABIL[m.group(1)], depth, 0
            elif cls is not None and depth == cls_depth + 1:
                mb = _buf_re.match(s)
                cur = None
                if mb and n < 3:
                    cur = (cls, n, bytes.fromhex(mb.group(1)).decode())
                    ORB[(cls, n)].append((_f, []))
                    n += 1
        elif s == "endif":
            if cls is not None and depth == cls_depth:
                cls = None
            if depth == cls_depth + 1:
                cur = None
            depth -= 1
        if cur is not None and cls is not None and depth >= cls_depth + 1:
            ORB[(cur[0], cur[1])][-1][1].append(i)
    # (ghi mã buff không cần cho truy vết; dòng code được trích đã chứa nó)


def split_args(s):
    """tách tham số ở mức ngoặc 0: 'a,f(b,c),d' -> [a, f(b,c), d]"""
    out, d, cur = [], 0, ""
    for ch in s:
        if ch == "," and d == 0:
            out.append(cur)
            cur = ""
            continue
        d += ch == "("
        d -= ch == ")"
        if d < 0:
            break
        cur += ch
    out.append(cur)
    return [a.strip() for a in out]


def enclosing_call(line, pos):
    """tên hàm có ngoặc bao quanh vị trí pos và vị trí mở ngoặc của nó"""
    d = 0
    for i in range(pos - 1, -1, -1):
        c = line[i]
        if c == ")":
            d += 1
        elif c == "(":
            if d == 0:
                m = re.search(r"(\w+)\s*$", line[:i])
                return (m.group(1) if m else ""), i
            d -= 1
    return "", -1


def blocks(f):
    """mỗi dòng của hàm f -> (danh sách điều kiện if bao quanh, có nằm trong vòng loop quét nhóm không)"""
    lines = kr.funcs[f]
    conds, loops, res = [], [], []
    # vòng loop có FirstOfGroup
    loop_rng, st = [], []
    for i, l in enumerate(lines):
        s = l.strip()
        if s == "loop":
            st.append(i)
        elif s == "endloop" and st:
            a = st.pop()
            if any("FirstOfGroup" in x for x in lines[a:i]):
                loop_rng.append((a, i))
    for i, l in enumerate(lines):
        s = l.strip()
        m = re.match(r"(if|elseif)\s+(.*)\s+then$", s)
        if m and m.group(1) == "if":
            conds.append(m.group(2))
        elif m:
            if conds:
                conds[-1] = m.group(2)
        elif s == "else":
            if conds:
                conds[-1] = "not(" + conds[-1] + ")"
        elif s == "endif":
            if conds:
                conds.pop()
        res.append((list(conds), any(a < i < b for a, b in loop_rng)))
    return res


# ---------- 3. ngữ cảnh 1 lần nhắc tới model ----------
CASTER_WORDS = ("GetSpellAbilityUnit()", "GetTriggerUnit()", "oy")
TARGET_WORDS = ("GetSpellTargetUnit()", "oR")


class Ctx:
    """giải biến trong 1 chiêu: x/y/unit của biến cục bộ (trong hàm) và mảng toàn cục (trong tập hàm của chiêu)"""

    def __init__(self, fnames):
        self.arr = {}
        for f in fnames:
            for l in kr.funcs.get(f, ()):
                m = re.match(r"set (\w+)\[\w+\]=(.+)$", l.strip())
                if m:
                    self.arr.setdefault(m.group(1), m.group(2))

    def resolve(self, expr, f, depth=0):
        """đẩy biểu thức về gốc: biến cục bộ / mảng -> giá trị gán"""
        expr = re.sub(r"\*1\.$", "", expr.strip())
        if depth > 4:
            return expr
        m = re.match(r"^(\w+)(\[\w+\])?$", expr)
        if not m:
            return expr
        name = m.group(1)
        if m.group(2):
            for l in kr.funcs.get(f, ()):        # ưu tiên lần gán trong cùng hàm
                mm = re.match(r"set " + re.escape(name) + r"\[\w+\]=(.+)$", l.strip())
                if mm:
                    return self.resolve(mm.group(1), f, depth + 1)
            if name in self.arr:
                return self.resolve(self.arr[name], f, depth + 1)
            return expr
        for l in kr.funcs.get(f, ()):
            mm = re.match(r"(?:local \w+ |set )" + re.escape(name) + r"=(.+)$", l.strip())
            if mm:
                return self.resolve(mm.group(1), f, depth + 1)
        return expr

    def who(self, expr, f, fog_vars):
        """mô tả đơn vị / điểm: tướng, mục tiêu, đơn vị trúng..."""
        e = re.sub(r"\*1\.$", "", expr.strip())
        mm = re.match(r"GetUnit[XY]\((\w+)\)$", e)
        if e in fog_vars or mm and mm.group(1) in fog_vars:     # biến FirstOfGroup: không giải tiếp (khai báo =null)
            return "hit", "đơn vị trúng (quét nhóm)"
        r = self.resolve(expr, f)
        mm = re.match(r"GetUnit[XY]\((.+)\)$", r)
        unit = self.resolve(mm.group(1), f) if mm else r
        if unit in fog_vars or "FirstOfGroup" in unit:
            return "hit", "đơn vị trúng (quét nhóm)"
        if unit in CASTER_WORDS:
            return "caster", "tướng"
        if unit in TARGET_WORDS:
            return "target", "mục tiêu chỉ định"
        if "GetSpellTarget" in r or "GetLocation" in r:
            return "point", "điểm chỉ định"
        return "other", r[:40]


def findings_in(f, line_filter, ctx, via):
    """quét các dòng của hàm f (line_filter(i) True) tìm model"""
    out = []
    lines = kr.funcs[f]
    bl = blocks(f)
    fog = set(re.findall(r"set (\w+)=FirstOfGroup", "\n".join(lines)))
    text_all = "\n".join("\n".join(kr.funcs[g]) for g in ctx.fnames)
    for i, l in enumerate(lines):
        if not line_filter(i, bl[i][0]):
            continue
        clean = re.sub(r'"[^"]*"', lambda m: " " * len(m.group(0)), l)
        refs = [(m.group(1), MODEL[m.group(1)], m.start()) for m in MODEL_RE.finditer(clean)]
        refs += [(None, m.group(1).replace("\\\\", "\\"), m.start()) for m in LIT_RE.finditer(l)]
        # tên ghép động: "war3mapImported\\X"+I2S(..)+".mdl" -> X*.mdl
        refs += [(None, m.group(1).replace("\\\\", "\\") + "*" + m.group(2), m.start()) for m in DYN_RE.finditer(l)]
        for const, path, pos in refs:
            fn, op = enclosing_call(l, pos)
            d = {"model": path.split("\\")[-1], "path": path, "const": const, "func": f,
                 "line": FSTART[f] + i, "code": l.strip()[:160], "via": via, "in_group_loop": bl[i][1],
                 "timer": TIMER.get(f)}
            args = split_args(l[op + 1 :]) if op >= 0 else []
            who = ("other", "")
            if fn in ("AddSpecialEffectTarget", "AddSpellEffectTargetById"):
                d["call"] = "AddSpecialEffectTarget"
                d["attach"] = args[2].strip('"') if len(args) > 2 else ""
                who = ctx.who(args[1], f, fog) if len(args) > 1 else who
            elif fn in ("AddSpecialEffect", "AddSpecialEffectLoc"):
                d["call"] = fn
                who = ctx.who(args[1], f, fog) if len(args) > 1 else who
            elif fn:
                k = wrapper_kind(fn)
                d["call"] = "qua hàm %s" % fn + (" (%s)" % k if k else "")
                # tham số đơn vị của hàm bọc: lấy tham số đầu tiên là unit đã biết
                for a in args:
                    w = ctx.who(a, f, fog)
                    if w[0] in ("caster", "target", "hit"):
                        who = w
                        break
            else:
                d["call"] = "gán biến (dùng gián tiếp)"
            d["who"], d["who_text"] = who
            # biến giữ effect
            outer, _ = enclosing_call(l, op) if op >= 0 else ("", -1)
            var = None
            mv = re.match(r"(?:set |local effect )(\w+(?:\[\w+\])?)=", l.strip())
            if outer in DESTROY:
                d["life"] = "hủy ngay"
            elif mv and d["call"].startswith("Add"):
                var = mv.group(1)
                vname = var.split("[")[0]
                after = "\n".join(lines[i + 1 :])
                killed_here = re.search(r"\b(%s)\(%s\b" % ("|".join(DESTROY), re.escape(var)), after)
                if "[" in var:
                    moved = re.search(r"BlzSetSpecialEffect(?:Position|X|Y)\(%s\[" % re.escape(vname), text_all)
                    d["life"] = "lưu mảng %s, giữ lâu%s" % (var, ", có di chuyển (đạn bay)" if moved else "")
                    d["moved"] = bool(moved)
                elif killed_here:
                    d["life"] = "hủy ngay (biến %s)" % var
                else:
                    d["life"] = "lưu biến %s" % var
                # scale / Z ngay sau đó
                for l2 in lines[i + 1 : i + 16]:
                    ms = re.search(r"(?:Blz)?SetSpecialEffectScale\(%s,([^)]+)\)" % re.escape(var), l2)
                    if ms and "scale" not in d:
                        d["scale"] = num(ms.group(1))
                    mz = re.search(r"BlzSetSpecialEffectZ\(%s,(.+)\)$" % re.escape(var), l2.strip())
                    if mz and "z" not in d:
                        d["z"] = mz.group(1) + (" (e7n = độ cao nền)" if "e7n(" in mz.group(1) else "")
            else:
                d["life"] = "?"
            role_guess(d, via)
            out.append(d)
    return out


def num(s):
    s = s.replace("*1.", "").strip()
    try:
        return float(int(s[1:], 16)) if s.startswith("$") else float(s)
    except ValueError:
        return s


def role_guess(d, via):
    """vai trò đề xuất + độ tin cậy + lý do"""
    passive = via.startswith("bị động")
    w, call, life = d["who"], d["call"], d.get("life", "?")
    kept = life.startswith("lưu")
    if w == "hit" or d["in_group_loop"] and call.startswith("Add"):
        r = ("target", "cao", "trên đơn vị trúng trong vòng quét nhóm")
    elif d.get("moved"):
        r = ("main", "cao", "effect lưu mảng và được di chuyển (đạn bay)")
    elif call.startswith("Add") and kept and "[" in life and not (call == "AddSpecialEffectTarget" and w == "caster"):
        r = ("main", "trung", "effect lưu mảng giữ lâu (vùng / đạn tại chỗ)")
    elif call == "AddSpecialEffectTarget" and w == "caster":
        if passive:
            r = ("aura", "trung", "gắn lên tướng trong nhánh bị động")
        elif kept:
            r = ("buff", "trung", "gắn lên tướng, giữ lâu")
        else:
            r = ("cast", "cao" if not d["timer"] else "trung", "gắn lên tướng, hủy ngay")
    elif call == "AddSpecialEffectTarget" and w == "target":
        r = ("target", "trung", "gắn lên mục tiêu chỉ định")
    elif call.startswith("AddSpecialEffect") and w == "caster":
        if d["timer"]:
            r = ("area", "trung", "tại chỗ tướng, trong timer")
        else:
            r = ("cast", "trung" if life.startswith("hủy") else "thấp", "tại chỗ tướng lúc tung")
    elif call.startswith("AddSpecialEffect"):
        if d["timer"]:
            r = ("area", "trung", "tại điểm, trong timer%s" % (" lặp" if d["timer"] else ""))
        else:
            r = ("area", "trung" if life.startswith("hủy") else "thấp", "tại điểm (%s)" % (d["who_text"] or "?"))
    elif passive:
        r = ("aura", "trung" if w == "caster" or "Target" in call else "thấp", "nhánh bị động, %s" % call)
    elif w == "hit":
        r = ("target", "trung", call)
    else:
        r = ("main", "thấp", "dùng gián tiếp (%s), cần xem tay" % call)
    d["role"], d["conf"], d["why"] = r


def orb_roots(no, sk, core=()):
    """Q/W/E: các hàm được gọi trong khối buff đòn đánh (ORB) của chiêu"""
    if no is None or sk.key not in ("Q", "W", "E"):
        return []
    out = set()
    for f, idx in ORB.get((no, "QWE".index(sk.key)), ()):
        for i in idx:
            l = re.sub(r'"[^"]*"', '""', kr.funcs[f][i])
            out |= {g for g in re.findall(r"\b(\w+)\s*\(", l) if g in kr.funcs and g not in core}
    return sorted(out)


# ---------- 4. từng chiêu ----------
def skill_trace(phai, sk, core, ctx_cache):
    kv = sk["kv"]
    abil = kr.raw(kv)
    hs = kr.handlers(kv)
    own = [f for f in kr.reach(hs, DEPTH) if f not in core] if hs else []
    names = {c for c, x in kr.consts.items() if x == abil}
    id_re = re.compile(r"(\$%08X\b%s)" % (abil, "".join(r"|\b%s\b" % re.escape(n) for n in names)))
    no, slot = SLOT.get(abil, (CLASS_NO.get(phai.code), None))
    sg_re = re.compile(r"\bsG\[\w+\]==%s\b" % no) if no is not None else None
    slot_re = re.compile(r"\b(?!sG\b)\w+==%d\b" % slot) if slot else None

    def in_skill_block(conds):
        if any(id_re.search(c) and "GetSpellAbilityId" not in c for c in conds):
            return "khối if nhắc mã chiêu"
        if sg_re and slot_re and any(sg_re.search(c) for c in conds) and any(slot_re.search(c) for c in conds if not sg_re.search(c)):
            return "nhánh sG==%s/ô %d" % (no, slot)
        return None

    # khối if trong toàn script
    blk_funcs = {}
    for f in kr.funcs:
        bl = None
        b = kr.body[f]
        if not (id_re.search(b) or (sg_re and sg_re.search(b))):
            continue
        bl = blocks(f)
        hit = [i for i, (c, _) in enumerate(bl) if in_skill_block(c)]
        if hit:
            blk_funcs[f] = (hit, in_skill_block(bl[hit[0]][0]))
    # hàm được gọi từ trong khối (1 tầng, bỏ lõi)
    def callees(f, idx):
        out = set()
        for i in idx:
            l = re.sub(r'"[^"]*"', '""', kr.funcs[f][i])
            out |= {g for g in re.findall(r"\b(\w+)\s*\(", l) if g in kr.funcs and g not in core}
            out |= {g for g in re.findall(r"function (\w+)", l) if g in kr.funcs and g not in core}
        return out

    called = set()
    for f, (hit, _) in blk_funcs.items():
        called |= callees(f, hit)
    # Q/W/E: khối buff đòn đánh (ORB) -> hàm chiêu được gọi, đi tiếp 4 tầng như hàm tung chiêu
    orb = [f for f, _ in ORB.get((no, "QWE".index(sk.key)), ())] if no is not None and sk.key in ("Q", "W", "E") else []
    roots = orb_roots(no, sk, core)
    own = own + [h for h in kr.reach(roots, DEPTH) if h not in core and h not in own]
    fnames = set(own) | set(blk_funcs) | called
    ctx = Ctx(fnames)
    ctx.fnames = fnames
    fs = []
    pas = "bị động: " if sk.is_passive else ""
    for f in sorted(own, key=lambda g: FSTART[g]):
        fs += findings_in(f, lambda i, c: True, ctx, pas + ("hàm tung chiêu" if f in hs else "hàm của chiêu"))
    seen = {(x["func"], x["line"]) for x in fs}
    for f, (hit, why) in sorted(blk_funcs.items(), key=lambda kv_: FSTART[kv_[0]]):
        hs_ = set(hit)
        fs += [x for x in findings_in(f, lambda i, c: i in hs_, ctx, pas + why) if (x["func"], x["line"]) not in seen]
    seen = {(x["func"], x["line"]) for x in fs}
    for f in sorted(called - set(own) - set(blk_funcs), key=lambda g: FSTART[g]):
        fs += [x for x in findings_in(f, lambda i, c: True, ctx, pas + "hàm gọi từ khối của chiêu") if (x["func"], x["line"]) not in seen]
    # các hàm bọc chỉ chuyển tiếp (call X(HJ,...) rồi X tự AddSpecialEffect(tham số)) đã được tính ở dòng gọi
    # gợi ý hiệu ứng nằm ở object data: ability / buff được gắn (UnitAddAbility, fNW = gắn buff qua trigger CE)
    hint = set()
    for f in set(own) | set(blk_funcs):
        for m in re.finditer(r"\b(UnitAddAbility|fNW)\((\w+),(\w+|\$[0-9A-F]{8})\)", kr.body[f]):
            a = m.group(3) if m.group(1) == "UnitAddAbility" else m.group(2)
            v = int(a[1:], 16) if a.startswith("$") else kr.consts.get(a)
            if v:
                hint.add("%s %s" % (m.group(1), v.to_bytes(4, "big").decode("latin-1")))
    return {"objdata_hint": sorted(hint), "handlers": hs +["%s (đòn đánh kèm buff)" % f for f in orb], "own_funcs": len(own), "block_funcs": sorted(blk_funcs), "findings": fs}


def summarize(fs):
    """model -> tập vai trò đề xuất (độ tin cậy cao nhất)"""
    rank = {"cao": 3, "trung": 2, "thấp": 1}
    out = {}
    for x in fs:
        b = base(x["model"])
        cur = out.setdefault(b, {"model": x["model"], "roles": {}})
        if rank[x["conf"]] > rank.get(cur["roles"].get(x["role"]), 0):
            cur["roles"][x["role"]] = x["conf"]
    return out


def config_roles(cl, name):
    cfg = kvfx.get(cl, name)
    out = {}
    for r in ROLES:
        v = cfg.get(r)
        for m in (v if isinstance(v, (list, tuple)) else [v] if v else []):
            out.setdefault(base(m), set()).add(r)
    return out, cfg


def compare(summ, cfg):
    import fnmatch
    cfg = {k: set(v) for k, v in cfg.items()}
    for w in [k for k in summ if "*" in k]:          # tên ghép động X*.mdl: gộp các model cấu hình khớp mẫu
        for k in [k for k in cfg if fnmatch.fnmatch(k, w)]:
            cfg.setdefault(w, set()).update(cfg.pop(k))
    kvs, cfs = set(summ), set(cfg)
    missing = sorted(kvs - cfs)
    extra = sorted(cfs - kvs)
    role_diff = []
    for b in sorted(kvs & cfs):
        prop = set(summ[b]["roles"])
        if not (prop & cfg[b]):
            role_diff.append("%s: KVCT %s / cấu hình %s" % (b, "+".join(sorted(prop)), "+".join(sorted(cfg[b]))))
    if not summ and not cfg:
        st = "không hiệu ứng (khớp)"
    elif not summ:
        st = "KVCT không có hiệu ứng"
    elif not missing and not extra and not role_diff:
        st = "khớp"
    else:
        st = "lệch"
    return {"status": st, "missing": missing, "extra": extra, "role_diff": role_diff}


def main():
    phais = Phai.all()
    # lõi dùng chung: như kvread (hàm được >6 chiêu chạm tới)
    reach_all = {}
    for p in phais:
        for s in p.skills:
            roots = kr.handlers(s["kv"]) + orb_roots(CLASS_NO.get(p.code), s)
            reach_all[(p.code, s["kv"])] = kr.reach(roots, DEPTH)
    count = collections.Counter(f for r in reach_all.values() for f in r)
    core = {f for f, c in count.items() if c > 6}
    res, used = [], set()
    stat = collections.Counter()
    for p in phais:
        pr = {"code": p.code, "name": p.name, "class_no": CLASS_NO.get(p.code), "skills": []}
        for s in p.skills:
            t = skill_trace(p, s, core, None)
            summ = summarize(t["findings"])
            cfgr, cfg = config_roles(p.code, s.name)
            cmp_ = compare(summ, cfgr)
            stat[cmp_["status"]] += 1
            used |= {x["const"] for x in t["findings"] if x["const"]}
            used |= {base(x["model"]) for x in t["findings"]}
            pr["skills"].append({"name": s.name, "kv": s["kv"], "key": s.key, "kind": s.kind,
                                 "passive": s.is_passive, "slot": SLOT.get(kr.raw(s["kv"]), (None, None))[1],
                                 **t, "proposal": summ, "config": {k: v for k, v in cfg.items()}, "compare": cmp_})
        res.append(pr)
    # model mồ côi: hằng số model của phái (tiền tố PHÁI_) hoặc Effect_* / MDX\ không chiêu nào dùng
    for pr in res:
        pre = pr["code"].lower() + "_"
        pr["orphans"] = sorted({MODEL[c] for c in MODEL if base(MODEL[c]).startswith(pre) and base(MODEL[c]) not in used})
    shared_orphans = sorted({MODEL[c] for c in MODEL if (base(MODEL[c]).startswith("effect_") or MODEL[c].lower().startswith("mdx\\"))
                             and base(MODEL[c]) not in used})
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    json.dump({"phai": res, "shared_orphans": shared_orphans, "stat": dict(stat)},
              open(OUT_JSON, "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=list)
    write_md(res, shared_orphans, stat)
    print("skills %d: %s -> %s, %s" % (sum(stat.values()), dict(stat), OUT_JSON, OUT_MD))


def write_md(res, shared_orphans, stat):
    o = ["# Truy vết model hiệu ứng KVCT theo chiêu (tự động - tools/kvfx_trace.py)", "",
         "Nguồn: `D:\\kvct-dev\\work\\readable.j`. Thống kê so với `tools/kvfx/hand/<PHÁI>.py`: "
         + ", ".join("%s: %d" % kv for kv in sorted(stat.items())) + ".", "",
         "Mỗi dòng phát hiện: `model` — kiểu gọi — hàm:dòng — ngữ cảnh → **vai trò đề xuất** (độ tin cậy; lý do). "
         "Xem mục cuối để biết cách đọc và giới hạn.", ""]
    for pr in res:
        o += ["## %s - %s (sG=%s)" % (pr["code"], pr["name"], pr["class_no"]), ""]
        for s in pr["skills"]:
            c = s["compare"]
            o.append("### %s (%s, %s, kind %s%s) — %s" % (s["name"], s["kv"], "phím " + s["key"] if s["key"] else "bị động",
                                                            s["kind"], ", ô %s" % s["slot"] if s["slot"] else "", c["status"]))
            o.append("- Hàm tung chiêu: %s; hàm riêng %d; khối if/nhánh: %s" % (
                ", ".join(s["handlers"]) or "không có", s["own_funcs"], ", ".join(s["block_funcs"]) or "-"))
            if not s["findings"]:
                o.append("- KVCT: **không có hiệu ứng** (không thấy model nào trong code của chiêu)%s" % (
                    "; có gắn ability/buff (model có thể nằm ở object data): " + ", ".join(s["objdata_hint"]) if s["objdata_hint"] else ""))
            for x in s["findings"]:
                ctx = [x["who_text"] and "đối tượng: " + x["who_text"], x.get("attach") and "attach \"%s\"" % x["attach"],
                       x["timer"] is not None and ("timer lặp" if x["timer"] else "timer 1 lần"),
                       x["in_group_loop"] and "trong vòng quét nhóm", x.get("life"),
                       "scale %s" % x["scale"] if "scale" in x else "", "Z %s" % x["z"] if "z" in x else "", x["via"]]
                o.append("- `%s` — %s — %s:%d — %s → **%s** (%s; %s)" % (
                    x["model"], x["call"], x["func"], x["line"], "; ".join(str(v) for v in ctx if v), x["role"], x["conf"], x["why"]))
            if s["proposal"]:
                o.append("- Đề xuất gộp: " + "; ".join("%s: %s" % (v["model"], "+".join("%s(%s)" % r for r in sorted(v["roles"].items())))
                                                       for v in s["proposal"].values()))
            cf = {k: v for k, v in s["config"].items() if k in ROLES}
            o.append("- Cấu hình hiện tại: %s" % (json.dumps(cf, ensure_ascii=False) if cf else "(trống)"))
            if c["missing"]:
                o.append("- Thiếu model (KVCT có, cấu hình chưa): " + ", ".join(c["missing"]))
            if c["extra"]:
                o.append("- Thừa model (cấu hình có, KVCT không dùng ở chiêu này): " + ", ".join(c["extra"]))
            if c["role_diff"]:
                o.append("- Vai trò khác: " + "; ".join(c["role_diff"]))
            o.append("")
        if pr["orphans"]:
            o += ["**Model mồ côi của phái %s** (hằng số có, không chiêu nào dùng): %s" % (pr["code"], ", ".join(pr["orphans"])), ""]
    o += ["## Model mồ côi dùng chung (Effect_* / MDX\\)", "", ", ".join(shared_orphans) or "-", ""]
    o += [l for l in NOTES.strip("\n").split("\n")]
    open(OUT_MD, "w", encoding="utf-8").write("\n".join(o) + "\n")


NOTES = """
## Cách đọc & độ tin cậy & giới hạn đã biết

**Cách tìm code của chiêu**
- Hàm tung chiêu: hàm có `GetSpellAbilityId()==<mã>` (mã hex hoặc hằng số integer), cộng các hàm nó gọi / hẹn giờ tới 4 tầng;
  bỏ "lõi" = hàm được >6 chiêu chạm tới (giống kvread.py), nên hiệu ứng nằm trong lõi dùng chung KHÔNG được tính.
- Khối if trong toàn script có điều kiện nhắc mã chiêu (vd `GetUnitAbilityLevel(u,$41304533)>0`) - thường là hiệu ứng khi đòn trúng / bị động.
- Nhánh bị động: hàm kiểu `Jdn` có `if sG[oY]==<số phái>` lồng `if xT==<ô>`; số phái và ô lấy từ hàm khởi tạo tướng
  (`set sG[oY]=N`, `set Kuz[oY]="MÃ"`, `SaveInteger(o8,eRS(oY,Ff),ô,mã chiêu)`). Ô khớp với mã chiêu nên không phụ thuộc thứ tự.
- Hàm được gọi từ bên trong khối/nhánh đó (1 tầng, bỏ lõi) cũng được quét.
- Q/W/E của KVCT KHÔNG có hàm GetSpellAbilityId: là orb gắn buff lên địch; hàm kiểu `Jdd` (khi đòn trúng) có
  `if GetUnitAbilityLevel(oy,<ability đánh dấu phái>)>0` lồng 3 khối `if GetUnitAbilityLevel(oR,$42xxxxxx)>0` theo thứ tự Q, W, E
  (CBC: B03U→e6B, B03V→eHR, B03W→Jk1). Hàm gọi trong khối con được đi tiếp DEPTH tầng như hàm tung chiêu.
- Chiêu "KVCT không có hiệu ứng" thường là buff (D/F/R) mà model nằm ở object data (art của ability/buff được gắn qua
  `UnitAddAbility` / `fNW`) - tool ghi các mã đó làm gợi ý; script không có tên model nên tool không thấy.

**Cách phân vai trò (đề xuất, không phải chân lý)**
- target: effect tạo trên/tại đơn vị lấy từ `FirstOfGroup` (vòng quét nhóm) → cao; gắn lên mục tiêu chỉ định (`oR`) → trung.
- main: effect lưu vào biến MẢNG và có `BlzSetSpecialEffectPosition/X/Y` trên mảng đó → đạn bay (cao); lưu mảng không di chuyển → vùng giữ lâu (trung).
- cast: gắn lên tướng (`oy`/GetTriggerUnit) hoặc tại chỗ tướng rồi hủy ngay, không nằm trong timer.
- buff: gắn lên tướng và giữ lâu; aura: gắn lên tướng trong nhánh bị động (hoặc hàm bọc như `JcZ(true,"x.mdl",...)`).
- area: AddSpecialEffect tại điểm khác (điểm chỉ định / điểm lưu) hoặc bất kỳ điểm nào trong timer, hủy ngay.
- thấp: model dùng gián tiếp (gán biến, qua hàm bọc không rõ) - cần xem tay dòng code được trích.
- "hủy ngay" = bọc trong `DestroyEffect` hoặc hàm hủy kiểu `evc` (hàm nhận effect và gọi DestroyEffect), hoặc biến cục bộ được hủy sau đó trong cùng hàm.

**So sánh với cấu hình** (`kvfx.get`, so tên file không đuôi, không thư mục, chữ thường)
- khớp: cùng tập model và mỗi model có ít nhất một vai trò đề xuất trùng vai trò trong cấu hình.
- lệch: có model thiếu / thừa / vai trò khác. "KVCT không có hiệu ứng": code KVCT không có model nhưng cấu hình có
  (thường là model MDX\\ của Thiên Kiếm / VLTK gán thêm - không sai, chỉ là không có gốc KVCT).

**Giới hạn đã biết**
- Đơn vị "tướng"/"mục tiêu" đoán theo tên biến đã giải mã (`oy` = caster, `oR` = mục tiêu) và GetSpellAbilityUnit/GetTriggerUnit/GetSpellTargetUnit;
  biến mảng được giải 1 lần gán đầu tiên (`set QX[ou]=oy`) - có thể sai nếu mảng gán nhiều chỗ.
- Model đi qua biến (vd `set C5[oY]="...mdl"` rồi dùng ở chỗ khác, hay hằng số được truyền làm tham số rồi hàm bọc tạo effect)
  chỉ ghi ở dòng nhắc tên, vai trò thấp / "qua hàm X". Effect tạo trong lõi dùng chung (vd hàm hiệu ứng trúng đòn chung) không thấy.
- Nhiều phái dùng chung hàm (bản sao code, hằng số trùng đường dẫn như Eyv/EgF): mỗi chiêu chỉ thấy bản mà handler của nó gọi.
- Một model có thể vừa đạn bay vừa nổ, hoặc được dùng lúc tung ở một hàm và trúng đòn ở hàm khác: đề xuất gộp liệt kê mọi vai trò.
  Ví dụ CBC Long Du Thiên Địa: CBC_casting tại vị trí địch trong Jkt (gọi lại từ JkN) bị xếp "area", trong khi Jk1 cho "cast".
- Hiệu ứng tạo bằng CreateUnit (dummy mang model qua dữ liệu object) không có tên model trong script nên không thấy.
- Điều kiện `xT==ô` khớp theo mẫu `<biến>==<ô>` bên trong khối `sG==<phái>` - có thể bắt nhầm biến khác cùng giá trị (hiếm).
"""

if __name__ == "__main__":
    main()
