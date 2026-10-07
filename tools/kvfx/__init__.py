# Model hieu ung cua tung chieu KVCT, chia theo phai:
#   hand/<PHAI>.py  bang sua tay (da bo lop auto/ tu sinh)
# get(phai, ten_chieu) -> {"main", "cast", "target", "area", ...} hoac {} (khong co: kskill.py chon theo ten / tk_mapping)
import importlib


def _load(kind, cl):
    try:
        return importlib.import_module("kvfx.%s.%s" % (kind, cl)).VFX
    except ImportError:
        return {}


def get(cl, name):
    return dict(_load("hand", cl).get(name) or {})


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

