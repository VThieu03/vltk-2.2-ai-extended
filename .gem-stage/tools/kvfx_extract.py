# Doc model hieu ung cua tung chieu KVCT tu CODE GOC (D:\kvct-dev\work\readable.j) va ghi tools\kvct_vfx_auto.py:
#   hang so chuoi model (constant string X="war3mapImported\CLS_xxx.mdl") hoac chuoi viet thang trong ham
#   -> cac ham RIENG cua chieu (ham xu ly cast + ham no goi toi, bo phan loi dung chung, nhu kvread.py)
#   -> model chia vai theo ten: cast (tren tuong luc tung), target (tren dich trung), buff (tren tuong), main (hieu ung).
# Chieu khong tim duoc ham rieng / model nao thi khong co muc: kskill.py tu chon theo ten roi dung tk_mapping.
# Chay: python kvfx_extract.py
import os, re, sys, collections

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kvread as kr
from kskill_data import CLASS, load

HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, "kvfx", "auto")
LISTFILE = r"D:\kvct-dev\work\listfile.txt"
have = {
    os.path.basename(l.strip().replace("\\", "/")).lower()
    for l in open(LISTFILE, encoding="utf-8", errors="ignore")
    if l.strip().lower().endswith(".mdx")
}

str_const = {}  # constant name -> model basename (.mdx)
for l in kr.L[kr.g0 + 1 : kr.g1]:
    m = re.match(r'\s*(?:constant\s+)?string\s+(\w+)="([^"]+\.md[xl])"', l, re.I)
    if m:
        str_const[m.group(1)] = os.path.basename(m.group(2).replace("\\\\", "/").replace("\\", "/"))[:-4] + ".mdx"


def models_of(fname):
    """models used by one function, in order of appearance"""
    b = kr.body[fname]
    out = []
    for m in re.finditer(r'"([^"]+\.md[xl])"|\b(\w+)\b', b, re.I):
        if m.group(1):
            name = os.path.basename(m.group(1).replace("\\\\", "/").replace("\\", "/"))[:-4] + ".mdx"
        elif m.group(2) in str_const:
            name = str_const[m.group(2)]
        else:
            continue
        if name.lower() in have and name not in out:
            out.append(name)
    return out


def usage():
    """model -> 'ground' when KVCT creates it at a point (AddSpecialEffect(M,x,y): fire / hole / wave on the floor) and never
    attached to a unit; 'attach' otherwise. A floor model attached to a unit shows as a flat picture above its head."""
    gnd, att = set(), set()
    names = {}
    for c, mdl in str_const.items():
        names.setdefault(mdl, set()).add(c)
    for l in kr.L:
        for m in re.finditer(r'AddSpecialEffect(Target)?\(("[^"]+"|\w+)', l):
            ref = m.group(2)
            mdl = (
                os.path.basename(ref.strip('"').replace("\\\\", "/").replace("\\", "/"))[:-4] + ".mdx"
                if ref.startswith('"')
                else str_const.get(ref)
            )
            if mdl:
                (att if m.group(1) else gnd).add(mdl)
    return {m: "ground" for m in gnd - att}


USAGE = usage()


def role(name, cl):
    w = name[:-4].lower()
    w = w[len(cl) + 1 :] if w.startswith(cl.lower() + "_") else w
    return (
        "cast"
        if "cast" in w
        else "target"
        if re.search(r"target|hit|taget", w)
        else "buff"
        if re.search(r"buff|aura", w)
        else "main"
    )


def autocast_handlers():
    """class -> [Q, W, E handler function]: the dispatcher of the autocast buffs (Jdd) has one block per sect marker
    (if GetUnitAbilityLevel(oy,MARKER)>0 ... call F ...), the sect table gives the marker's class (set Kuz[oY]="CLS")"""
    marker_cls, marker = {}, None
    for l in kr.L:
        m = re.match(r"\s*if GetUnitAbilityLevel\(oy,\$([0-9A-Fa-f]{8})\)>0 then", l)
        if m:
            marker = m.group(1).upper()
        m = re.match(r'\s*set Kuz\[oY\]="(\w+)"', l)
        if m and marker:
            marker_cls.setdefault(m.group(1), marker)
    out, cur = {}, None
    inside = False
    for l in kr.L:
        if l.startswith("function Jdd "):
            inside = True
            continue
        if inside and l.startswith("endfunction"):
            break
        if not inside:
            continue
        m = re.match(r"if GetUnitAbilityLevel\(oy,\$([0-9A-Fa-f]{8})\)>0 then", l)
        if m:
            cur = m.group(1).upper()
            out[cur] = []
            continue
        m = re.match(r"call (\w+)\(", l)
        if m and cur and m.group(1) != "UnitRemoveAbility" and m.group(1) in kr.funcs:
            out[cur].append(m.group(1))
    return {c: out.get(mk, []) for c, mk in marker_cls.items()}


AUTO = autocast_handlers()


def passive_auras():
    """class -> {skill slot: model}: the passive dispatchers (Jdn JdY Jd8 Jdu JdL ...) pick the sect by sG[oY]==N and the
    skill by xT==slot, then JcZ(true,"model",...) puts a model on the hero for as long as the skill is on"""
    sg_cls, n_ = {}, None
    for l in kr.L:
        m = re.match(r"\s*set sG\[oY\]=(\d+)\s*$", l)
        if m:
            n_ = int(m.group(1))
        m = re.match(r'\s*set Kuz\[oY\]="(\w+)"', l)
        if m and n_ is not None:
            sg_cls.setdefault(n_, m.group(1))
            n_ = None
    out, g, slot = {}, None, None
    for l in kr.L:
        if l.startswith("function "):
            g = slot = None
        m = re.search(r"sG\[oY\]==(\d+)", l)
        if m and re.match(r"\s*(if|elseif)", l):
            g, slot = int(m.group(1)), None
        m = re.match(r"\s*(?:if|elseif) xT==(\d+) then", l)
        if m:
            slot = int(m.group(1))
        m = re.search(r'JcZ\(true,"([^"]+)"', l)
        if m and g in sg_cls and slot:
            name = os.path.basename(m.group(1).replace("\\\\", "/").replace("\\", "/"))[:-4] + ".mdx"
            out.setdefault(sg_cls[g], {})[slot] = name
    return out


AURA = passive_auras()


def handlers_of(cl, s):
    hs = kr.handlers(s["kv"])
    if not hs and s["key"] in ("Q", "W", "E") and len(AUTO.get(cl, [])) >= 3:
        hs = [AUTO[cl]["QWE".index(s["key"])]]
    return hs


def main():
    data = load()
    per = {}
    for hero, cl in CLASS.items():
        for s in data.get(cl, [])[:14]:
            hs = handlers_of(cl, s)
            per[(cl, s["kv"])] = (s, hs, kr.reach(hs, 4))
    count = collections.Counter(f for _, _, r in per.values() for f in r)
    core = {f for f, c in count.items() if c > 6}
    table, miss = {}, []
    for hero, cl in CLASS.items():
        for s in data.get(cl, [])[:14]:
            _, hs, r = per[(cl, s["kv"])]
            if not hs:
                aura = AURA.get(cl, {}).get(data[cl].index(s) + 1)
                if aura and aura.lower() in have:
                    table["%s|%s" % (cl, s["name"])] = {"aura": aura, "from": "passive dispatcher (JcZ)"}
                    continue
                miss.append((cl, s["name"], "no cast handler"))
                continue
            order = list(hs) + sorted(f for f in r if f not in hs and f not in core)
            seen = []
            for f in order:
                if f in core:
                    continue
                for x in models_of(f):
                    if x not in seen:
                        seen.append((x))
            roles = collections.defaultdict(list)
            for x in seen:
                roles[role(x, cl)].append(x)
            if not seen:
                miss.append((cl, s["name"], "no model in its functions"))
                continue
            e = {}
            main_ = (roles["buff"] + roles["main"]) if s["kind"] in (6, 7, 8, 9) else (roles["main"] + roles["buff"])
            if main_:
                e["main"] = main_[0]
                if main_[1:]:
                    e["area"] = main_[1:3]
            elif roles["cast"] or roles["target"]:
                e["main"] = (roles["cast"] + roles["target"])[0]
            if roles["cast"] and roles["cast"][0] != e.get("main"):
                e["cast"] = roles["cast"][0]
            if roles["target"] and roles["target"][0] != e.get("main"):
                e["target"] = roles["target"][0]
            for r_ in ("cast", "target"):
                if e.get(r_) and USAGE.get(e[r_]) == "ground":
                    e[r_ + "_ground"] = True
            e["from"] = ",".join(hs)
            table["%s|%s" % (cl, s["name"])] = e
    by = {}
    for k, e in table.items():
        cl, name = k.split("|", 1)
        by.setdefault(cl, {})[name] = e
    os.makedirs(OUT_DIR, exist_ok=True)
    for cl in sorted(set(CLASS.values())):
        lines = [
            "# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong",
            "# tools/kvfx/hand/%s.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j" % cl,
            "VFX = {",
        ]
        for n, e in sorted(by.get(cl, {}).items()):
            lines.append("    %r: %r," % (n, e))
        lines.append("}")
        open(os.path.join(OUT_DIR, cl + ".py"), "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("skills with a table entry: %d, without: %d -> %s" % (len(table), len(miss), OUT_DIR))
    for c, n, why in miss[:400]:
        print("  - %s %s: %s" % (c, n, why))


if __name__ == "__main__":
    main()
