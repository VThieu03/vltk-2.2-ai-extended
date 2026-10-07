# Build the 1.31 version: files from src\map replace the ones in work\base.w3x (archive layout kept,
# 2 imported files are encrypted with a position-dependent key), script checked with pjass.
#   python build.py [--out X.w3x]
import os, struct, subprocess, sys, zlib

sys.path.insert(0, os.path.dirname(__file__))
from mpqwrite import build
from mpq import MPQ, hs

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
BASE = os.path.join(ROOT, "work", "base.w3x")
OFF = 512
SRC = os.path.join(ROOT, "src", "map")


def pjass(path):
    d = os.path.join(ROOT, "work", "pjass")
    r = subprocess.run(
        [os.path.join(d, "pjass.exe"), "common.j", "Blizzard.j", path],
        cwd=d,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    out = (r.stdout + r.stderr).splitlines()
    errs = [
        l for l in out if l.startswith(path) and "is uninitialized" not in l and "failed with" not in l
    ]  # same warnings as the original
    if errs:
        print("\n".join(errs[:20]))
        sys.exit("pjass: %d error(s)" % len(errs))
    # pjass must have read the whole file (a "//" comment in a CR-only file used to swallow the rest of it)
    want = open(path, "rb").read().count(b"\n") + 1
    seen = [
        l for l in out if l.startswith("Parse successful") and l.replace("\\", "/").endswith(path.replace("\\", "/"))
    ]
    got = int(seen[0].split()[2]) if seen else -1
    if got < want - 1:
        sys.exit("pjass read %d of %d lines" % (got, want))
    print("pjass ok (%d lines)" % got)


def block_index(m, name):
    a, b, i = hs(name, 1), hs(name, 2), hs(name, 0) % len(m.hashes)
    while m.hashes[i][4] != 0xFFFFFFFF:
        if m.hashes[i][0] == a and m.hashes[i][1] == b and m.hashes[i][4] != 0xFFFFFFFE:
            return m.hashes[i][4]
        i = (i + 1) % len(m.hashes)
    raise KeyError(name)


def main():
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else os.path.join(ROOT, "build", "Tong Kim Beta.w3x")
    files = {}
    for root, _, fs in os.walk(SRC):  # includes war3mapImported\kv (icons from icons.py)
        for f in fs:
            full = os.path.join(root, f)
            files[os.path.relpath(full, SRC).replace("/", "\\")] = open(full, "rb").read()
    js = os.path.join(ROOT, "build", "war3map.j")
    os.makedirs(os.path.dirname(js), exist_ok=True)
    # The original script ends its lines with a bare CR. Both pjass and the 1.31 game read a "//" comment up
    # to LF, so one comment swallowed the rest of the script (config included: empty lobby). Ship CRLF.
    try:
        s = files["Scripts\\war3map.j"].replace(b"\r\n", b"\n").replace(b"\r", b"\n")
        files["Scripts\\war3map.j"] = s.replace(b"\n", b"\r\n")
        open(js, "wb").write(s)
    except KeyError as e:
        print("KeyError! Available keys:", [k for k in files.keys() if 'war3map' in k])
        raise e
    pjass(js)
    build(BASE, OFF, files, out, keep_layout=True)
    v = MPQ(out, OFF)
    att = v.read("(attributes)")
    crcs = struct.unpack_from("<%dI" % len(v.blocks), att, 8)
    for name, data in files.items():
        assert v.read(name) == data, "verify failed: " + name
        assert crcs[block_index(v, name)] == zlib.crc32(data) & 0xFFFFFFFF, "(attributes) CRC: " + name
    print("ok", out, os.path.getsize(out), "bytes,", len(files), "files from src")


if __name__ == "__main__":
    main()
