"""Store Warcraft III assets by type while preserving their archive paths at build time."""
import os
import re
import shutil
import struct

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MAP = os.path.join(ROOT, "src", "map")
DATA = os.path.join(MAP, "VLTK_data")
GROUPS = {".mdx": "Models", ".mdl": "Models", ".blp": "Textures", ".tga": "Textures"}
OTHER = "Other"
CATEGORIES = {"Models", "Textures", OTHER}


def category_path(relative):
    group = GROUPS.get(os.path.splitext(relative)[1].lower(), OTHER)
    return os.path.join(DATA, group, *relative.split("/"))


def archive_path(relative):
    """Return the new in-map path for an old VLTK_data-relative path."""
    relative = relative.replace("/", "\\")
    if relative.split("\\", 1)[0] in CATEGORIES:
        return "VLTK_data\\" + relative
    group = GROUPS.get(os.path.splitext(relative)[1].lower(), OTHER)
    return "VLTK_data\\" + group + "\\" + relative


def rewrite_references(data):
    """Rewrite VLTK_data paths in text and variable-length object data."""
    pattern = re.compile(rb"VLTK_data(?P<sep>\\+)(?P<tail>[^\x00\"'\r\n]*?\.(?:mdx|mdl|blp|tga|mp3|toc))", re.I)

    def replace(match):
        sep = match.group("sep")
        tail = re.sub(rb"\\+", lambda _: b"\\", match.group("tail")).replace(b"/", b"\\")
        new = archive_path(tail.decode("latin1")).encode("latin1")
        slash = b"\\\\" if len(sep) > 1 else b"\\"
        return new.replace(b"\\", slash)

    data = pattern.sub(replace, data)
    # Several UI textures are assembled from a directory prefix plus a dynamic filename.
    for old, new in (
        (b"VLTK_data\\\\war3mapImported\\\\", b"VLTK_data\\\\Textures\\\\war3mapImported\\\\"),
        (b"VLTK_data\\war3mapImported\\", b"VLTK_data\\Textures\\war3mapImported\\"),
    ):
        data = data.replace(old, new)
    return data


def rewrite_mdx_textures(data):
    """Rewrite TEXS paths without changing the fixed 260-byte MDX texture fields."""
    if not data.startswith(b"MDLX"):
        return data
    result = bytearray(data)
    offset = 4
    while offset + 8 <= len(result):
        tag = result[offset : offset + 4]
        size = struct.unpack_from("<I", result, offset + 4)[0]
        end = offset + 8 + size
        if end > len(result):
            break
        if tag == b"TEXS":
            if size % 268:
                raise ValueError("invalid MDX TEXS size")
            for record in range(offset + 8, end, 268):
                field = record + 4
                old = bytes(result[field : field + 260]).split(b"\0", 1)[0]
                new = rewrite_references(old)
                if len(new) >= 260:
                    raise ValueError("MDX texture path exceeds 259 bytes: " + repr(new))
                result[field : field + 260] = new.ljust(260, b"\0")
        offset = end
    return bytes(result)


def categorized_files():
    for group in CATEGORIES:
        base = os.path.join(DATA, group)
        if not os.path.isdir(base):
            continue
        for root, _, files in os.walk(base):
            for name in files:
                yield group, os.path.join(root, name)


def activate():
    """Materialize legacy paths for existing pipeline steps; returns whether staging was activated."""
    if not any(os.path.isdir(os.path.join(DATA, name)) for name in CATEGORIES):
        return False
    for group, source in categorized_files():
        relative = os.path.relpath(source, os.path.join(DATA, group)).replace("\\", "/")
        destination = os.path.join(DATA, *relative.split("/"))
        os.makedirs(os.path.dirname(destination), exist_ok=True)
        if os.path.exists(destination):
            with open(source, "rb") as a, open(destination, "rb") as b:
                if a.read() != b.read():
                    raise FileExistsError("asset exists in both categorized and build paths: " + relative)
        else:
            shutil.copy2(source, destination)
    return True


def collapse():
    """Move staged legacy-path assets back into their type directories after a pipeline run."""
    if not os.path.isdir(DATA):
        return
    for root, dirs, files in os.walk(DATA):
        dirs[:] = [name for name in dirs if name not in CATEGORIES]
        for name in files:
            source = os.path.join(root, name)
            relative = os.path.relpath(source, DATA).replace("\\", "/")
            destination = category_path(relative)
            os.makedirs(os.path.dirname(destination), exist_ok=True)
            os.replace(source, destination)
    for group in CATEGORIES:
        base = os.path.join(DATA, group)
        if os.path.isdir(base):
            for root, dirs, files in os.walk(base, topdown=False):
                for name in dirs:
                    path = os.path.join(root, name)
                    if not os.listdir(path):
                        os.rmdir(path)
            if not os.listdir(base):
                os.rmdir(base)
    old_dirs = []
    for root, dirs, _ in os.walk(DATA):
        if os.path.normcase(root) == os.path.normcase(DATA):
            dirs[:] = [name for name in dirs if name not in CATEGORIES]
        old_dirs.extend(os.path.join(root, name) for name in dirs)
    for path in reversed(old_dirs):
        try:
            if not os.listdir(path):
                os.rmdir(path)
        except OSError:
            pass
