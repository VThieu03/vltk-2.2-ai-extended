# Model hieu ung cua tung chieu KVCT, chia theo phai:
#   auto/<PHAI>.py  tu sinh tu code goc KVCT (python tools/kvfx_extract.py)
#   hand/<PHAI>.py  sua tay, thang auto/
# get(phai, ten_chieu) -> {"main", "cast", "target", "area", ...} hoac {} (khong co: kskill.py chon theo ten / tk_mapping)
import importlib


def _load(kind, cl):
    try:
        return importlib.import_module("kvfx.%s.%s" % (kind, cl)).VFX
    except ImportError:
        return {}


def get(cl, name):
    e = dict(_load("auto", cl).get(name) or {})
    e.update(_load("hand", cl).get(name) or {})          # hand keys win, the others (aura ...) come from auto
    return e


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

