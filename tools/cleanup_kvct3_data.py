"""Keep only KVCT3_Data files referenced by map assets; preserve a full hash manifest."""

import argparse
import csv
import hashlib
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / "src" / "map"
DATA = MAP / "VLTK_data" / "Textures" / "KVCT3_Data"
BACKUP = Path(r"D:\KVCT31_Data\KVCT3_Data")
MANIFEST = ROOT / "docs" / "kvct3_data_manifest.tsv"
PATH_RE = re.compile(rb"(?:VLTK_data[\\/](?:Textures[\\/])?)?KVCT3_Data[\\/][^\x00\r\n\"<>|]*?\.(?:blp|tga)", re.I)


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def relative_lookup(directory):
    return {
        path.relative_to(directory).as_posix().lower(): path
        for path in directory.rglob("*")
        if path.is_file()
    }


def referenced_textures():
    referenced = set()
    imported = MAP / "VLTK_data" / "Models" / "war3mapImported"
    for model in imported.rglob("*.mdx"):
        data = model.read_bytes()
        texs = data.find(b"TEXS")
        if texs < 0 or texs + 8 > len(data):
            continue
        count = int.from_bytes(data[texs + 4 : texs + 8], "little", signed=True) // 268
        for index in range(max(0, count)):
            start = texs + 8 + 268 * index + 4
            raw = data[start : start + 260].split(b"\0", 1)[0]
            normalized = raw.decode("latin-1").replace("\\", "/")
            parts = normalized.split("/")
            if len(parts) > 2 and parts[0].lower() == "vltk_data":
                parts = parts[1:]
            if len(parts) > 1 and parts[0].lower() == "textures":
                parts = parts[1:]
            if len(parts) > 1 and parts[0].lower() == "kvct3_data":
                referenced.add("/".join(parts[1:]).lower())

    # Also catch direct texture paths in object data and scripts, not only model TEXS blocks.
    for path in MAP.rglob("*"):
        if not path.is_file() or DATA == path or DATA in path.parents:
            continue
        try:
            content = path.read_bytes()
        except OSError:
            continue
        for raw in PATH_RE.findall(content):
            normalized = raw.decode("latin-1").replace("\\", "/")
            parts = normalized.split("/")
            if len(parts) > 2 and parts[0].lower() == "vltk_data":
                parts = parts[1:]
            if len(parts) > 1 and parts[0].lower() == "textures":
                parts = parts[1:]
            if len(parts) > 1 and parts[0].lower() == "kvct3_data":
                referenced.add("/".join(parts[1:]).lower())
    return referenced


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="write manifest and prune unreferenced duplicates")
    args = parser.parse_args()
    if not DATA.is_dir() or not BACKUP.is_dir():
        raise SystemExit("KVCT3_Data or its verified external backup is missing")

    source = relative_lookup(DATA)
    backup = relative_lookup(BACKUP)
    if source.keys() - backup.keys():
        raise SystemExit("source contains files absent from the verified backup; refusing cleanup")

    rows = []
    different = []
    for relative, path in sorted(source.items()):
        other = backup[relative]
        source_hash = sha256(path)
        backup_hash = sha256(other)
        if path.stat().st_size != other.stat().st_size or source_hash != backup_hash:
            different.append(relative)
        rows.append([path.relative_to(DATA).as_posix(), path.stat().st_size, source_hash, ""])
    if different:
        raise SystemExit("source and backup differ; refusing cleanup: " + ", ".join(different[:10]))

    refs = referenced_textures()
    missing_source = sorted(name for name in refs if name not in source)
    missing_both = sorted(name for name in refs if name not in source and name not in backup)
    keep = refs & source.keys()
    remove = source.keys() - keep
    for row in rows:
        row[3] = "keep: referenced" if row[0].lower() in keep else "remove: unused duplicate"

    if args.apply:
        with MANIFEST.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.writer(stream, delimiter="\t", lineterminator="\n")
            writer.writerow(["relative_path", "bytes", "sha256", "disposition"])
            writer.writerows(rows)
        root = DATA.resolve()
        for relative in sorted(remove):
            path = source[relative].resolve()
            if not path.is_relative_to(root):
                raise SystemExit("refusing path outside KVCT3_Data: " + str(path))
            path.unlink()

    print("files:", len(source), "referenced:", len(keep), "unused:", len(remove))
    print("referenced but absent from VLTK_data:", len(missing_source), missing_source[:10])
    print("referenced but absent in both copies:", len(missing_both), missing_both[:10])
    print("backup hash verification: exact for all files present in VLTK_data")
    print("mode:", "applied" if args.apply else "dry-run")
    if args.apply:
        print("manifest:", MANIFEST)


if __name__ == "__main__":
    main()
