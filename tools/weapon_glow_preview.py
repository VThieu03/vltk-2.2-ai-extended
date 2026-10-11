"""Export generated MDX glow geometry and emitter parameters for visual QA."""
import base64
import io
import json
import struct
from pathlib import Path

from PIL import Image
import weapon_glow as glow


def export(src):
    model = glow.chunks(glow.clone_with_glow(glow.model_path(src, "VK_daoTND").read_bytes(), 5))
    meshes = []
    for source in glow.records(model[b"GEOS"])[-2:]:
        info = glow.geoset_info(source)
        def values(tag, fmt, width):
            at, count = info[tag]
            return [round(value, 5) for row in struct.iter_unpack(fmt, source[at:at + count * width]) for value in row]
        uv = source.index(b"UVBS", info["sequence_extents"][0])
        count = struct.unpack_from("<I", source, uv + 4)[0]
        groups, offset = [], 0
        bindings = values(b"MATS", "<I", 4)
        for size in values(b"MTGC", "<I", 4):
            size = int(size)
            groups.append([int(v) for v in bindings[offset:offset + size]])
            offset += size
        at, count_skin = info[b"GNDX"]
        skin = [groups[g] for g in source[at:at + count_skin]]
        meshes.append({"positions": values(b"VRTX", "<3f", 12),
                       "normals": values(b"NRMS", "<3f", 12),
                       "indices": [int(v) for v in values(b"PVTX", "<H", 2)],
                       "uv": [round(v, 5) for v in struct.unpack_from("<%df" % (count * 2), source, uv + 8)],
                       "skin": skin})
    textures = {}
    for kind in ("arc", "spark", "flame"):
        png = io.BytesIO()
        Image.open(io.BytesIO(glow.vfx_texture(kind))).save(png, format="PNG")
        textures[kind] = "data:image/png;base64," + base64.b64encode(png.getvalue()).decode("ascii")
    emitters, flames = [], []
    for record in glow.records(model[b"PRE2"]):
        name = record[8:88].split(b"\0", 1)[0]
        if name not in (b"Element spark", b"Element flame"):
            continue
        node = struct.unpack_from("<I", record, 88)[0]
        target = flames if name == b"Element flame" else emitters
        target.append({"position": list(struct.unpack_from("<3f", model[b"PIVT"], node * 12)),
                       "parent": struct.unpack_from("<I", record, 92)[0],
                       "speed": struct.unpack_from("<f", record, 100)[0],
                       "latitude": struct.unpack_from("<f", record, 108)[0],
                       "gravity": struct.unpack_from("<f", record, 112)[0],
                       "life": struct.unpack_from("<f", record, 116)[0],
                       "middle": struct.unpack_from("<f", record, 152)[0],
                       "alpha": list(record[192:195]),
                       "scale": list(struct.unpack_from("<3f", record, 195)),
                       "frames": list(struct.iter_unpack("<3I", record[207:255])),
                       "emission": list(struct.iter_unpack("<If", record[287:]))})
    shell_positions = []
    for shell in glow.records(model[b"GEOS"])[-4:-2]:
        at, count = glow.geoset_info(shell)[b"VRTX"]
        shell_positions.append([round(v, 5) for v in struct.unpack_from("<%df" % (count * 3), shell, at)])
    nodes = []
    for bone in glow.bone_records(model[b"BONE"]):
        if bone[4:84].split(b"\0", 1)[0].startswith(b"Lightning "):
            nodes.append({"id": struct.unpack_from("<I", bone, 84)[0],
                          "keys": [list(key) for key in struct.iter_unpack("<I3f", bone[112:-8])]})
    return {"meshes": meshes, "textures": textures, "emitters": emitters, "flames": flames,
            "shellPositions": shell_positions, "shells": glow.SHELLS, "arcLayers": glow.ARC_LAYERS,
            "nodes": nodes, "wigglePeriod": glow.WIGGLE_PERIOD,
            "arcColours": glow.ARC_COLOURS, "lightningColour": glow.LIGHTNING_COLOUR}


if __name__ == "__main__":
    print(json.dumps(export(Path(__file__).resolve().parents[1] / "src" / "map"), separators=(",", ":")))
