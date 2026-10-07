# Chạy một bước pipeline với open() bọc lại: ghi file trong src lỗi OSError 22 (Windows) thì ghi nhật ký và thử lại.
import builtins, io, os, runpy, sys, time

_open = builtins.open
LOG = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "scratchpad", "oserror22.log")


def _log(msg):
    with _open(LOG, "a", encoding="utf-8") as f:
        f.write(time.strftime("%H:%M:%S ") + msg + "\n")


def _why(file):
    # mã lỗi Windows thật (CRT gom lỗi lạ, vd 1224 ERROR_USER_MAPPED_FILE, thành errno 22)
    import ctypes
    k = ctypes.WinDLL("kernel32", use_last_error=True)
    k.CreateFileW.restype = ctypes.c_void_p
    h = k.CreateFileW(str(os.path.abspath(file)), 0x40000000, 7, None, 5, 0x80, None)  # GENERIC_WRITE, OPEN_ALWAYS
    if h in (None, ctypes.c_void_p(-1).value):
        return ctypes.get_last_error()
    k.CloseHandle(ctypes.c_void_p(h))
    return "open ok"


def safe_open(file, mode="r", *a, **k):
    for i in range(20):
        try:
            return _open(file, mode, *a, **k)
        except OSError as e:
            if e.errno != 22 or i == 19:
                raise
            _log("winapi=%s" % _why(file))
            _log("open %s %r winerror=%s try %d (%s)" % (mode, file, getattr(e, "winerror", None), i, os.path.basename(sys.argv[0])))
            time.sleep(0.5)


builtins.open = safe_open
script = sys.argv[1]
sys.argv = [script] + sys.argv[2:]
sys.path.insert(0, os.path.dirname(script))
runpy.run_path(script, run_name="__main__")
