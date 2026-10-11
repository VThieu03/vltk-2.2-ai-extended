# Model hieu ung cua tung chieu KVCT, chia theo phai:
#   hand/<PHAI>.py  bang sua tay (da bo lop auto/ tu sinh)
# get(phai, ten_chieu) -> {"main", "cast", "target", "area", ...} hoac {} (khong co: kskill.py chon theo ten / tk_mapping)
# Moi lop (main/cast/target/aura/buff) trong hand/<PHAI>.py la chuoi ten model, hoac {"file":.., "scale":.., "ground":..}
# khi can chinh kich thuoc / dan xuong dat (thay the cac khoa phang cu scale/cast_scale/target_scale/cast_ground/
# target_ground tung de go trung khoa va am tham mat gia tri - vd CBC.py "Phi Long Tai Thien" truoc day co
# hai "cast_scale" trong cung dict). get() chuan hoa ca 2 dang ve vocab phang ma kskill.py dang doc.
import importlib

_SCALE_KEY = {"main": "scale", "cast": "cast_scale", "target": "target_scale"}
_SLOTS = ("main", "cast", "target", "aura", "buff")


def _load(kind, cl):
    try:
        return importlib.import_module("kvfx.%s.%s" % (kind, cl)).VFX
    except ImportError:
        return {}


def _slot(v):
    """1 model cua 1 lop: chuoi ten file (dang cu / don gian), hoac {"file", "scale", "ground"} (dang moi)."""
    if isinstance(v, dict):
        return v.get("file"), v.get("scale"), bool(v.get("ground"))
    return v, None, False


def get(cl, name):
    raw = dict(_load("hand", cl).get(name) or {})
    out = {}
    for slot in _SLOTS:
        if slot not in raw:
            continue
        v = raw[slot]
        if isinstance(v, (list, tuple)):
            out[slot] = [_slot(x)[0] for x in v]
            continue
        f, sc, gr = _slot(v)
        out[slot] = f
        if sc is not None and slot in _SCALE_KEY:
            out[_SCALE_KEY[slot]] = sc
        if gr and slot in ("cast", "target"):
            out[slot + "_ground"] = True
    if "area" in raw:
        area = raw["area"] if isinstance(raw["area"], (list, tuple)) else [raw["area"]]
        out["area"] = [_slot(x)[0] for x in area]
    for k, v in raw.items():          # khoa khac (dang cu con lai, HAND_OVR: hits/gap/rad/...): giu nguyen
        if k not in _SLOTS and k != "area":
            out[k] = v
    return out


def texture_overrides():
    """model -> {old texture: new texture} from TEXTURES of every hand/<PHAI>.py (applied to the model file at build)"""
    import glob, os

    out = {}
    for f in sorted(glob.glob(os.path.join(os.path.dirname(__file__), "hand", "*.py"))):
        cl = os.path.basename(f)[:-3]
        if cl == "__init__":
            continue
        try:
            mod = importlib.import_module("kvfx.hand." + cl)
        except ImportError:
            continue
        for model, mp in getattr(mod, "TEXTURES", {}).items():
            out.setdefault(model, {}).update(mp)
    return out

