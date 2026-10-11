"""Build element-coloured weapon clones from their actual MDX meshes (KVCT: Silva.Fox).

The original geosets, textures, bones and animations stay byte-for-byte intact.
Two thin additive shells share the weapon's skinning, so the light follows its
shape and animations rather than a separately oriented sword-shaped effect.
Surface-fitted lightning bends on its own global clock, with scrolling pulses
and model-space sparks. No world-space lightning handles or motion history.
"""
from pathlib import Path
from functools import lru_cache
import math
import struct


ELEMENTS = {1: (255, 215, 48), 2: (65, 225, 95), 3: (220, 160, 65),
            4: (70, 155, 255), 5: (255, 70, 45)}
WHITE_TEXTURE = "VLTK_data\\war3mapImported\\WeaponGlow\\white.tga"
ARC_TEXTURE = "VLTK_data\\war3mapImported\\WeaponGlow\\arc.tga"
SPARK_TEXTURE = "VLTK_data\\war3mapImported\\WeaponGlow\\spark.tga"
FLAME_TEXTURE = "VLTK_data\\war3mapImported\\WeaponGlow\\flame.tga"
SHELLS = ((.6, .34), (2.5, .12))
ARC_LAYERS = ((2.8, .40), (.9, 1.))
ARC_COLOURS = ((55, 155, 255), (225, 248, 255))
LIGHTNING_COLOUR = (85, 180, 255)
VFX_MARGIN = 40.
WIGGLE_PERIOD = 600
# Confirmed against the actual mesh silhouettes; these tips face the negative axis.
REVERSE_FLOW = {"VK_chuongngav1", "VK_chuongv3_chuongdoc-left", "VK_phitieuv1"}


def hot_colour(colour):
    return tuple(round(value * .45 + 255 * .55) for value in colour)
CHUNK_ORDER = [b"VERS", b"MODL", b"SEQS", b"GLBS", b"MTLS", b"TEXS", b"TXAN",
               b"GEOS", b"GEOA", b"BONE", b"LITE", b"HELP", b"ATCH", b"PIVT",
               b"PREM", b"PRE2", b"RIBB", b"CAMS", b"EVTS", b"CLID"]


def pack_chunks(model):
    order = CHUNK_ORDER + [tag for tag in model if tag not in CHUNK_ORDER]
    return b"MDLX" + b"".join(struct.pack("<4sI", tag, len(model[tag])) + model[tag]
                               for tag in order if tag in model)


def chunks(data):
    if data[:4] != b"MDLX":
        raise ValueError("not an MDX model")
    result = {}
    at = 4
    while at < len(data):
        if at + 8 > len(data):
            raise ValueError("truncated MDX chunk header")
        tag, size = struct.unpack_from("<4sI", data, at)
        at += 8
        if at + size > len(data) or tag in result:
            raise ValueError("invalid MDX chunk: " + repr(tag))
        result[tag] = data[at:at + size]
        at += size
    return result


def records(data):
    result = []
    at = 0
    while at < len(data):
        if at + 4 > len(data):
            raise ValueError("truncated MDX record header")
        size = struct.unpack_from("<I", data, at)[0]
        if size < 4 or at + size > len(data):
            raise ValueError("invalid MDX record size")
        result.append(data[at:at + size])
        at += size
    return result


def bone_records(data):
    """BONE stores the generic-node size, followed by two extra geoset IDs."""
    result, at = [], 0
    while at < len(data):
        if at + 4 > len(data):
            raise ValueError("truncated bone")
        size = struct.unpack_from("<I", data, at)[0]
        if size < 96 or at + size + 8 > len(data):
            raise ValueError("invalid bone size")
        result.append(data[at:at + size + 8])
        at += size + 8
    return result


def geoset_info(data):
    """Locate the arrays and scalar fields of a classic (version 800) geoset."""
    at = 4
    info = {}
    for tag, width in ((b"VRTX", 12), (b"NRMS", 12), (b"PTYP", 4),
                       (b"PCNT", 4), (b"PVTX", 2), (b"GNDX", 1),
                       (b"MTGC", 4), (b"MATS", 4)):
        if data[at:at + 4] != tag:
            raise ValueError("missing geoset field: " + repr(tag))
        count = struct.unpack_from("<I", data, at + 4)[0]
        info[tag] = (at + 8, count)
        at += 8 + count * width
    info["material"] = at
    info["extent"] = at + 12
    at += 40
    count = struct.unpack_from("<I", data, at)[0]
    info["sequence_extents"] = (at + 4, count)
    at += 4 + count * 28
    if data[at:at + 4] != b"UVAS":
        raise ValueError("missing geoset UVAS")
    count = struct.unpack_from("<I", data, at + 4)[0]
    at += 8
    for _ in range(count):
        if data[at:at + 4] != b"UVBS":
            raise ValueError("missing geoset UVBS")
        n = struct.unpack_from("<I", data, at + 4)[0]
        at += 8 + n * 8
    if at != len(data) or info[b"VRTX"][1] != info[b"NRMS"][1]:
        raise ValueError("invalid geoset arrays")
    return info


def grow_extent(data, at, amount):
    radius, *bounds = struct.unpack_from("<7f", data, at)
    struct.pack_into("<7f", data, at, radius + amount,
                     *(x - amount for x in bounds[:3]),
                     *(x + amount for x in bounds[3:]))


def shell_geoset(source, material, amount):
    data = bytearray(source)
    info = geoset_info(data)
    vp, count = info[b"VRTX"]
    np, _ = info[b"NRMS"]
    normals = {}
    vertices = list(struct.iter_unpack("<3f", data[vp:vp + count * 12]))
    # Vertices at hard UV/normal seams need a common offset to keep the light shell closed.
    for index, point in enumerate(vertices):
        key = tuple(round(x, 4) for x in point)
        normal = struct.unpack_from("<3f", data, np + index * 12)
        old = normals.setdefault(key, [0., 0., 0.])
        for axis in range(3):
            old[axis] += normal[axis]
    for index, point in enumerate(vertices):
        normal = normals[tuple(round(x, 4) for x in point)]
        length = math.sqrt(sum(x * x for x in normal))
        if length:
            struct.pack_into("<3f", data, vp + index * 12,
                             *(point[a] + amount * normal[a] / length for a in range(3)))
    struct.pack_into("<I", data, info["material"], material)
    grow_extent(data, info["extent"], amount)
    ep, count = info["sequence_extents"]
    for at in range(ep, ep + count * 28, 28):
        grow_extent(data, at, amount)
    return bytes(data)


def glow_material(texture, alpha, global_sequence):
    track = b"KMTA" + struct.pack("<III", 3, 1, global_sequence)
    track += b"".join(struct.pack("<If", time, value) for time, value in
                      ((0, alpha * .7), (900, alpha), (1800, alpha * .7)))
    # AddAlpha, unshaded, two-sided, depth test enabled, no depth writes.
    layer = struct.pack("<IIIiiIf", 28 + len(track), 4, 0x91, texture, -1, 0, alpha) + track
    return struct.pack("<IiI4sI", 20 + len(layer), 1, 0, b"LAYS", 1) + layer


def glow_animation(source, geoset, colour):
    alpha = struct.unpack_from("<f", source, 4)[0] if source else 1.
    tracks = []
    at = 28
    while source and at < len(source):
        tag, count, interpolation, sequence = struct.unpack_from("<4sIII", source, at)
        if tag not in (b"KGAO", b"KGAC"):
            raise ValueError("unknown geoset animation track")
        width = 1 if tag == b"KGAO" else 3
        size = 16 + count * (4 + width * 4 * (3 if interpolation > 1 else 1))
        if at + size > len(source):
            raise ValueError("truncated geoset animation track")
        if tag == b"KGAO":
            tracks.append(source[at:at + size])
        at += size
    tail = b"".join(tracks)
    red, green, blue = colour
    return struct.pack("<IfI3fI", 28 + len(tail), alpha, 2,
                       blue / 255., green / 255., red / 255., geoset) + tail


def element_particles(data, colour):
    result = []
    red, green, blue = (v / 255. for v in colour)
    for record in records(data):
        emitter = bytearray(record)
        node_size = struct.unpack_from("<I", emitter, 4)[0]
        segment = 4 + node_size + 56
        if node_size < 96 or segment + 36 > len(emitter):
            raise ValueError("invalid particle emitter")
        for at in range(segment, segment + 36, 12):
            light = max(struct.unpack_from("<3f", emitter, at))
            struct.pack_into("<3f", emitter, at, blue * light, green * light, red * light)
        result.append(emitter)
    return b"".join(result)


def unit(vector):
    length = math.sqrt(sum(v * v for v in vector))
    return tuple(v / length for v in vector) if length else (0., 0., 1.)


def surface_paths(geosets, reverse=False):
    """Slice referenced triangles, not bounding boxes or unused hero-body vertices."""
    triangles, loose = [], []
    for source in geosets:
        info = geoset_info(source)
        def values(tag, fmt, width):
            at, count = info[tag]
            return list(struct.iter_unpack(fmt, source[at:at + count * width]))
        vertices = values(b"VRTX", "<3f", 12)
        normals = values(b"NRMS", "<3f", 12)
        bones = values(b"MATS", "<I", 4)
        groups, offset = [], 0
        for size, in values(b"MTGC", "<I", 4):
            groups.append(tuple(b[0] for b in bones[offset:offset + size]))
            offset += size
        at, count = info[b"GNDX"]
        skin = [groups[g] for g in source[at:at + count]]
        points = list(zip(vertices, normals, skin))
        at, count = info[b"PVTX"]
        faces = list(struct.iter_unpack("<3H", source[at:at + count * 2]))
        triangles.extend(tuple(points[i] for i in face) for face in faces)
        if not faces:
            loose.extend(points)
    referenced = [v for face in triangles for v in face] or loose
    if not referenced:
        raise ValueError("weapon has no surface points")
    low = [min(p[0][a] for p in referenced) for a in range(3)]
    high = [max(p[0][a] for p in referenced) for a in range(3)]
    axis = max(range(3), key=lambda a: high[a] - low[a])
    side = [a for a in range(3) if a != axis]
    paths = []
    for strand in range(2):
        path = []
        for step in range(49):
            t = step / 48.
            angle = t * math.tau * 2 + strand * math.pi + .22 * math.sin(step * 2.4)
            radial = [0., 0., 0.]
            radial[side[0]], radial[side[1]] = math.cos(angle), math.sin(angle)
            plane = low[axis] + (.06 + .9 * t) * (high[axis] - low[axis])
            segments = []
            for face in triangles:
                hits = []
                for first, second in ((face[0], face[1]), (face[1], face[2]), (face[2], face[0])):
                    delta = second[0][axis] - first[0][axis]
                    if abs(delta) < 1e-7:
                        continue
                    mix = (plane - first[0][axis]) / delta
                    if 0 <= mix <= 1:
                        position = tuple(a + (b - a) * mix for a, b in zip(first[0], second[0]))
                        normal = unit(tuple(a + (b - a) * mix for a, b in zip(first[1], second[1])))
                        hits.append((position, normal, (first if mix < .5 else second)[2]))
                if len(hits) >= 2:
                    segments.append(hits[:2])
            if segments:
                ends = [hit[0] for segment in segments for hit in segment]
                centre = [(min(p[a] for p in ends) + max(p[a] for p in ends)) / 2 for a in range(3)]
                radius = [(max(p[a] for p in ends) - min(p[a] for p in ends)) / 2 for a in range(3)]
                target = [centre[a] + radial[a] * radius[a] for a in range(3)]
                candidates = []
                for first, second in segments:
                    delta = [b - a for a, b in zip(first[0], second[0])]
                    length = sum(v * v for v in delta)
                    mix = max(0., min(1., sum((target[a] - first[0][a]) * delta[a] for a in range(3)) / length)) if length else 0.
                    point = tuple(first[0][a] + delta[a] * mix for a in range(3))
                    normal = unit(tuple(a + (b - a) * mix for a, b in zip(first[1], second[1])))
                    candidates.append((sum((p - q) ** 2 for p, q in zip(point, target)), point, normal, (first if mix < .5 else second)[2]))
                _, point, normal, binding = min(candidates, key=lambda c: c[0])
                if sum(a * b for a, b in zip(normal, radial)) < 0:
                    normal = tuple(-v for v in normal)
            else:
                point, normal, binding = min(referenced, key=lambda p: abs(p[0][axis] - plane))
                normal = tuple(radial)
            clearance = 3.6 + 1.1 * math.sin(step * 2.7 + strand)
            position = tuple(point[a] + normal[a] * clearance for a in range(3))
            path.append((position, normal, binding))
        paths.append(path[::-1] if reverse else path)
    return paths


def animate_lightning(model, paths):
    """Skin only the arcs to small animated children of their actual source nodes."""
    sequence = len(model[b"GLBS"]) // 4
    model[b"GLBS"] += struct.pack("<I", WIGGLE_PERIOD)
    pivots = model.get(b"PIVT", b"")
    bones, cache, output = [], {}, []
    for strand, path in enumerate(paths):
        animated = []
        for index, (point, normal, binding) in enumerate(path):
            control = min(8, (index + 3) // 6)
            anchor, outward, _ = path[control * 6]
            first, last = path[max(0, control * 6 - 1)][0], path[min(48, control * 6 + 1)][0]
            direction = unit(tuple(b - a for a, b in zip(first, last)))
            tangent = unit((direction[1] * outward[2] - direction[2] * outward[1],
                            direction[2] * outward[0] - direction[0] * outward[2],
                            direction[0] * outward[1] - direction[1] * outward[0]))
            targets = []
            for parent in binding:
                key = (strand, control, parent)
                if key not in cache:
                    node = len(pivots) // 12
                    cache[key] = node
                    keys = []
                    for time in range(0, WIGGLE_PERIOD + 1, 75):
                        phase = (time % WIGGLE_PERIOD) * math.tau / WIGGLE_PERIOD + control * 2.399 + strand * 1.7
                        amplitude = .5 + .5 * math.sin(math.pi * control / 8)
                        offset = tuple(amplitude * (1.3 * tangent[a] * math.sin(phase)
                                       + .65 * outward[a] * math.sin(phase * 2 + .7)) for a in range(3))
                        keys.append(struct.pack("<I3f", time, *offset))
                    track = b"KGTR" + struct.pack("<III", len(keys), 1, sequence) + b"".join(keys)
                    name = ("Lightning %d %d %d" % key).encode("ascii")
                    bones.append(struct.pack("<I80sIII", 96 + len(track), name, node, parent, 0x100)
                                 + track + struct.pack("<ii", -1, -1))
                    pivots += struct.pack("<3f", *anchor)
                targets.append(cache[key])
            animated.append((point, normal, tuple(targets)))
        output.append(animated)
    model[b"BONE"] = model.get(b"BONE", b"") + b"".join(bones)
    model[b"PIVT"] = pivots
    return output


def extent_for(points, margin=0.):
    low = [min(p[a] for p in points) - margin for a in range(3)]
    high = [max(p[a] for p in points) + margin for a in range(3)]
    radius = max(math.sqrt(sum(v * v for v in p)) for p in points) + margin
    return struct.pack("<7f", radius, *low, *high)


def arc_geoset(paths, material, width, sequence_count):
    points, normals, bindings, uv, faces = [], [], [], [], []
    strips = [(path, strand * .5) for strand, path in enumerate(paths)]
    for strand, path in enumerate(paths):
        for index in (10, 24, 38):
            point, normal, skin = path[index + 1]
            fork = (tuple(p + n * 3. for p, n in zip(point, normal)), normal, skin)
            strips.append(([path[index], fork, path[index + 2]], strand * .5 + index / 48.))
    for path, phase in strips:
        for index, (first, second) in enumerate(zip(path, path[1:])):
            direction = unit(tuple(b - a for a, b in zip(first[0], second[0])))
            start = len(points)
            for sample, u in ((first, index), (second, index + 1)):
                point, normal, binding = sample
                cross = unit((direction[1] * normal[2] - direction[2] * normal[1],
                              direction[2] * normal[0] - direction[0] * normal[2],
                              direction[0] * normal[1] - direction[1] * normal[0]))
                for sign, v in ((-1, 0.), (1, 1.)):
                    points.append(tuple(p + sign * width * n for p, n in zip(point, cross)))
                    normals.append(normal)
                    bindings.append(binding)
                    uv.append((phase + u / 48., v))
            faces.extend((start, start + 1, start + 2, start + 2, start + 1, start + 3))
    groups = list(dict.fromkeys(bindings))
    if len(groups) > 256:
        raise ValueError("too many lightning skin groups")
    arrays = ((b"VRTX", points, "<3f"), (b"NRMS", normals, "<3f"),
              (b"PTYP", [(4,)], "<I"), (b"PCNT", [(len(faces),)], "<I"),
              (b"PVTX", [(v,) for v in faces], "<H"),
              (b"GNDX", [(groups.index(b),) for b in bindings], "<B"),
              (b"MTGC", [(len(b),) for b in groups], "<I"),
              (b"MATS", [(v,) for b in groups for v in b], "<I"))
    payload = b"".join(struct.pack("<4sI", tag, len(values)) + b"".join(struct.pack(fmt, *v) for v in values)
                       for tag, values, fmt in arrays)
    extent = extent_for(points)
    payload += struct.pack("<III", material, 0, 0) + extent + struct.pack("<I", sequence_count) + extent * sequence_count
    payload += b"UVAS" + struct.pack("<I", 1) + b"UVBS" + struct.pack("<I", len(uv))
    payload += b"".join(struct.pack("<2f", *v) for v in uv)
    return struct.pack("<I", len(payload) + 4) + payload


def element_emitter(node, parent, texture, colour, sequence, phase, flame=False):
    # Classic PRE2 model-space particles follow the original animated weapon bone.
    name = b"Element flame" if flame else b"Element spark"
    generic = struct.pack("<I80sIII", 96, name, node, parent, 0x1000 | 0x8000 | 0x40000 | 0x80000)
    settings = (22., .30, 30., -8., .44, 0., 1.2, 1.2, 1, 4, 4, 0, 0., .32) if flame else (
        16., .35, 180., 0., .20, 0., .4, .4, 1, 1, 1, 2, .045, .35)
    payload = generic + struct.pack("<8f4I2f", *settings)
    bgr = tuple(v / 255. for v in reversed(colour))
    hot = tuple(v / 255. for v in reversed(hot_colour(colour)))
    segments = (230, 210, 0, 7.5, 11.5, 3.) if flame else (255, 210, 0, 2.1, .9, 0.)
    payload += struct.pack("<9f3B3f", *(hot + bgr + bgr), *segments)
    frames = (0, 4, 1, 5, 15, 1, 0, 0, 1, 0, 0, 1) if flame else (0, 0, 1) * 4
    payload += struct.pack("<12I4I", *frames, texture, 0, 1, 0)
    keys = [(time, 12. + 6. * math.sin((time - phase) * math.tau / 1800.) if flame else
             22. * max(0., 1. - abs(((time - phase + 900) % 1800) - 900) / 330.))
            for time in range(0, 1801, 60)]
    payload += b"KP2E" + struct.pack("<III", len(keys), 1, sequence)
    payload += b"".join(struct.pack("<If", *key) for key in keys)
    return struct.pack("<I", len(payload) + 4) + payload


def add_surface_vfx(model, sources, element, sequence, reverse=False):
    paths = surface_paths(sources, reverse)
    animated = animate_lightning(model, paths)
    colour = ELEMENTS[element]
    texture = len(model[b"TEXS"]) // 268
    model[b"TEXS"] += struct.pack("<I260sI", 0, ARC_TEXTURE.encode("ascii"), 1)
    model[b"TEXS"] += struct.pack("<I260sI", 0, SPARK_TEXTURE.encode("ascii"), 0)
    model[b"TEXS"] += struct.pack("<I260sI", 0, FLAME_TEXTURE.encode("ascii"), 0)
    txid = len(records(model.get(b"TXAN", b"")))
    track = b"KTAT" + struct.pack("<III", 2, 1, sequence) + struct.pack("<I3fI3f", 0, 0., 0., 0., 1800, -1., 0., 0.)
    model[b"TXAN"] = model.get(b"TXAN", b"") + struct.pack("<I", len(track) + 4) + track
    materials, geosets = records(model[b"MTLS"]), records(model[b"GEOS"])
    animations = records(model.get(b"GEOA", b""))
    for layer_index, (width, alpha) in enumerate(ARC_LAYERS):
        layer = struct.pack("<IIIiiIf", 28, 4, 0x91, texture, txid, 0, alpha)
        materials.append(struct.pack("<IiI4sI", 48, 2, 0, b"LAYS", 1) + layer)
        gid = len(geosets)
        geosets.append(arc_geoset(animated, len(materials) - 1, width, len(model.get(b"SEQS", b"")) // 132))
        animations.append(glow_animation(None, gid, ARC_COLOURS[layer_index]))
    model[b"MTLS"], model[b"GEOS"], model[b"GEOA"] = map(b"".join, (materials, geosets, animations))
    pivots = model.get(b"PIVT", b"")
    emitters = []
    for index, step in enumerate((7, 14, 21, 28, 35, 42)):
        point, normal, binding = animated[index % 2][step]
        # Multi-matrix vertices retain exact skinning in the arcs; emit only on rigid points.
        if len(binding) != 1:
            continue
        emitters.append(element_emitter(len(pivots) // 12, binding[0], texture + 1, LIGHTNING_COLOUR, sequence, index * 300))
        pivots += struct.pack("<3f", *point)
    for index, step in enumerate((6, 12, 18, 24, 30, 36, 42, 46)):
        point, normal, binding = paths[index % 2][step]
        if len(binding) != 1:
            continue
        emitters.append(element_emitter(len(pivots) // 12, binding[0], texture + 2, colour, sequence, index * 225, flame=True))
        pivots += struct.pack("<3f", *point)
    model[b"PIVT"] = pivots
    model[b"PRE2"] = model.get(b"PRE2", b"") + b"".join(emitters)


def clone_with_glow(data, element, selected=None, reverse=False):
    model = chunks(data)
    if struct.unpack("<I", model[b"VERS"])[0] != 800:
        raise ValueError("weapon glow requires classic MDX version 800")
    geosets = records(model[b"GEOS"])
    materials = records(model[b"MTLS"])
    animations = records(model.get(b"GEOA", b""))
    selected = {i: geosets[i] for i in range(len(geosets))} if selected is None else dict(selected)
    if not selected or any(i < 0 or i >= len(geosets) for i in selected):
        raise ValueError("invalid glow geoset selection")
    original_animation = {struct.unpack_from("<I", r, 24)[0]: r for r in animations}
    texture = len(model[b"TEXS"]) // 268
    model[b"TEXS"] += struct.pack("<I260sI", 0, WHITE_TEXTURE.encode("ascii"), 0)
    sequence = len(model.get(b"GLBS", b"")) // 4
    model[b"GLBS"] = model.get(b"GLBS", b"") + struct.pack("<I", 1800)
    if not model.get(b"SEQS"):
        # VK_daoTLD and VK_kiemVDQ need a looping Stand to evaluate the new global tracks.
        extent = model[b"MODL"][340:368]
        model[b"SEQS"] = b"Stand".ljust(80, b"\0") + struct.pack("<IIfIfI", 0, 1800, 0., 0, 0., 0) + extent
    for amount, alpha in SHELLS:
        mid = len(materials)
        materials.append(glow_material(texture, alpha, sequence))
        for gid, source_geoset in selected.items():
            new_id = len(geosets)
            geosets.append(shell_geoset(source_geoset, mid, amount))
            animations.append(glow_animation(original_animation.get(gid), new_id, ELEMENTS[element]))
    model[b"GEOS"] = b"".join(geosets)
    model[b"MTLS"] = b"".join(materials)
    model[b"GEOA"] = b"".join(animations)
    if model.get(b"PRE2"):
        # Fist/palm models already contain hand particles; retain their shape and use the weapon element hue.
        model[b"PRE2"] = element_particles(model[b"PRE2"], ELEMENTS[element])
    add_surface_vfx(model, selected.values(), element, sequence, reverse)
    model[b"MODL"] = bytearray(model[b"MODL"])
    grow_extent(model[b"MODL"], 340, VFX_MARGIN)
    model[b"SEQS"] = bytearray(model.get(b"SEQS", b""))
    if len(model[b"SEQS"]) % 132:
        raise ValueError("invalid sequence chunk")
    for at in range(104, len(model[b"SEQS"]), 132):
        grow_extent(model[b"SEQS"], at, VFX_MARGIN)
    # Keep canonical MDX chunk order for older Warcraft III loaders.
    return pack_chunks(model)


def model_path(src, name):
    for folder in (Path(src) / "VLTK_data", Path(src) / "VLTK_data" / "Models"):
        path = folder / "war3mapImported" / (name + ".mdx")
        if path.is_file():
            return path
    raise FileNotFoundError(name + ".mdx")


def white_texture():
    # A neutral 32-bit TGA lets the additive shell use its geoset element colour.
    return struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, 4, 4, 32, 0x28) + bytes([255]) * 64


@lru_cache(maxsize=3)
def vfx_texture(kind):
    width, height = {"arc": (128, 32), "spark": (32, 32), "flame": (256, 256)}[kind]
    pixels = bytearray()
    for y in range(height):
        v = (y + .5) / height * 2 - 1
        for x in range(width):
            u = x / (width - 1)
            if kind == "arc":
                distance = ((u - .35 + .5) % 1) - .5
                packet = math.exp(-(distance / .13) ** 2)
                flicker = .78 + .22 * math.sin(u * math.tau * 19)
                alpha = math.exp(-(v / .30) ** 2) * (.25 + .75 * packet) * flicker
            elif kind == "spark":
                u = u * 2 - 1
                alpha = max(math.exp(-(u * u + v * v) * 17),
                            .72 * math.exp(-abs(u) * 6 - abs(v) * 35),
                            .72 * math.exp(-abs(v) * 6 - abs(u) * 35))
            else:
                # Sixteen tapered, curling flame frames with transparent gutters.
                frame = (y // 64) * 4 + x // 64
                phase = frame * math.tau / 16
                u = ((x % 64) + .5) / 64 * 2 - 1
                h = 1 - ((y % 64) + .5) / 64
                centre = .22 * math.sin(phase + h * 7) * h
                taper = .40 * (1 - h) ** .8 + .025
                alpha = math.exp(-((u - centre) / taper) ** 2) * (1 - h) ** .25
                for side in (-1, 1):
                    tip = .66 + .12 * math.sin(phase + side * 2)
                    if h < tip:
                        curl = side * (.30 + .12 * math.sin(phase * 2 + h * 9))
                        width_at = .16 * (1 - h / tip) + .015
                        alpha = max(alpha, .8 * math.exp(-((u - curl) / width_at) ** 2) * (1 - h / tip) ** .3)
                alpha *= min(1., max(0., h * 20 - 1), max(0., (.98 - h) * 20), max(0., (1 - abs(u)) * 16 - 1))
            pixels.extend((255, 255, 255, round(255 * alpha)))
    return struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, width, height, 32, 0x28) + pixels


def generate_weapons(src, weapons):
    prefixes = {}
    for base in sorted(set(weapons.values()) - {""}):
        original = model_path(src, base)
        dest = original.parent / "WeaponGlow"
        dest.mkdir(exist_ok=True)
        for element in ELEMENTS:
            (dest / (base + "_" + str(element) + ".mdx")).write_bytes(
                clone_with_glow(original.read_bytes(), element, reverse=base in REVERSE_FLOW))
        # Write at the matching staging/categorized texture path, not beside Models.
        data_root = Path(src) / "VLTK_data"
        tex_root = data_root if original.parent.parent == data_root else data_root / "Textures"
        tex = tex_root / "war3mapImported" / "WeaponGlow" / "white.tga"
        tex.parent.mkdir(parents=True, exist_ok=True)
        tex.write_bytes(white_texture())
        for kind in ("arc", "spark", "flame"):
            tex.with_name(kind + ".tga").write_bytes(vfx_texture(kind))
        prefixes[base] = "VLTK_data\\war3mapImported\\WeaponGlow\\" + base + "_"
    return prefixes


def triangles_for_bones(source, selected_bones):
    """Keep only faces skinned entirely to the specified bones; retain the original skin arrays."""
    info = geoset_info(source)
    at, n = info[b"MTGC"]
    sizes = struct.unpack_from("<%dI" % n, source, at)
    at, n = info[b"MATS"]
    indices = struct.unpack_from("<%dI" % n, source, at)
    groups = []
    offset = 0
    for size in sizes:
        groups.append(set(indices[offset:offset + size]))
        offset += size
    gp, count = info[b"GNDX"]
    allowed = [bool(groups[g]) and groups[g] <= selected_bones for g in source[gp:gp + count]]
    fp, count = info[b"PVTX"]
    faces = [face for face in struct.iter_unpack("<3H", source[fp:fp + count * 2])
             if all(allowed[index] for index in face)]
    if not faces:
        raise ValueError("no weapon triangles for selected bones")
    # This model uses one triangle group; refuse other layouts instead of guessing.
    if info[b"PCNT"][1] != 1 or info[b"PTYP"][1] != 1:
        raise ValueError("multiple primitive groups in embedded weapon")
    result = bytearray(source[:fp] + b"".join(struct.pack("<3H", *face) for face in faces)
                       + source[fp + count * 2:])
    struct.pack_into("<I", result, 0, len(result))
    struct.pack_into("<I", result, fp - 4, len(faces) * 3)
    struct.pack_into("<I", result, info[b"PCNT"][0], len(faces) * 3)
    return bytes(result)


def forearm_sockets(data):
    """Zero-origin sockets inherit exactly the same bone matrices as the embedded blades."""
    model = chunks(data)
    attachments = records(model[b"ATCH"])
    names = {r[8:88].split(b"\0", 1)[0]: r for r in attachments}
    pivots = model[b"PIVT"]
    for name, parent in ((b"Sprite First Ref", 19), (b"Sprite Second Ref", 20)):
        if name in names:
            record = names[name]
            node, bone = struct.unpack_from("<II", record, 88)
            if bone != parent or struct.unpack_from("<3f", pivots, node * 12) != (0., 0., 0.):
                raise ValueError("embedded blade socket already in use: " + repr(name))
            continue
        node = len(pivots) // 12
        generic = struct.pack("<I80sIII", 96, name, node, parent, 0x800)
        attachments.append(struct.pack("<I", 364) + generic + bytes(260) + struct.pack("<I", len(attachments)))
        pivots += bytes(12)
    model[b"ATCH"] = b"".join(attachments)
    model[b"PIVT"] = pivots
    return pack_chunks(model)


def rigid_geoset(source):
    """The attachment supplies the forearm matrix; bind every glow vertex to an identity bone."""
    info = geoset_info(source)
    parts = [bytes(4)]
    for tag, width in ((b"VRTX", 12), (b"NRMS", 12), (b"PTYP", 4),
                       (b"PCNT", 4), (b"PVTX", 2), (b"GNDX", 1),
                       (b"MTGC", 4), (b"MATS", 4)):
        at, count = info[tag]
        values = source[at:at + count * width]
        if tag == b"GNDX":
            values = bytes(count)
        elif tag in (b"MTGC", b"MATS"):
            count = 1
            values = struct.pack("<I", 1 if tag == b"MTGC" else 0)
        parts.append(struct.pack("<4sI", tag, count) + values)
    ep, count = info["sequence_extents"]
    extent = source[info["extent"]:info["extent"] + 28]
    parts.append(source[info["material"]:ep - 4] + struct.pack("<I", 1) + extent + source[ep + count * 28:])
    result = bytearray(b"".join(parts))
    struct.pack_into("<I", result, 0, len(result))
    return bytes(result)


def embedded_glow(source, element, reverse=False):
    """Glow-only geometry: the hero already renders the original blade mesh."""
    source = rigid_geoset(source)
    geosets = [shell_geoset(source, i, amount) for i, (amount, alpha) in enumerate(SHELLS)]
    info = geoset_info(geosets[-1])
    extent = geosets[-1][info["extent"]:info["extent"] + 28]
    model = {
        b"VERS": struct.pack("<I", 800),
        b"MODL": b"TYD blade glow".ljust(80, b"\0") + bytes(260) + extent + struct.pack("<I", 150),
        b"SEQS": b"Stand".ljust(80, b"\0") + struct.pack("<IIfIfI", 0, 1800, 0., 0, 0., 0) + extent,
        b"GLBS": struct.pack("<I", 1800),
        b"MTLS": b"".join(glow_material(0, alpha, 0) for amount, alpha in SHELLS),
        b"TEXS": struct.pack("<I260sI", 0, WHITE_TEXTURE.encode("ascii"), 0),
        b"GEOS": b"".join(geosets),
        b"GEOA": b"".join(glow_animation(None, i, ELEMENTS[element]) for i in range(len(SHELLS))),
        b"BONE": struct.pack("<I80sIIIii", 96, b"Glow", 0, 0xFFFFFFFF, 0x100, -1, -1),
        b"PIVT": bytes(12),
    }
    add_surface_vfx(model, [source], element, 0, reverse)
    model[b"MODL"] = bytearray(model[b"MODL"])
    model[b"SEQS"] = bytearray(model[b"SEQS"])
    grow_extent(model[b"MODL"], 340, VFX_MARGIN)
    grow_extent(model[b"SEQS"], 104, VFX_MARGIN)
    return pack_chunks(model)


def generate_embedded(src):
    """Thuy Yen Dao's two wrist blades follow forearm sockets, without post-1.31 skin natives."""
    import objdata

    original = model_path(src, "Hero_thuyyendao")
    data = original.read_bytes()
    geosets = records(chunks(data)[b"GEOS"])
    dest = original.parent / "WeaponGlow"
    dest.mkdir(exist_ok=True)
    original.write_bytes(forearm_sockets(data))
    units = objdata.ObjectFile.load(str(Path(src) / "war3map.w3u"))
    if units.find("E002") is None:
        raise ValueError("Thuy Yen Dao E002 missing")
    # Remove only the five obsolete skins/assets generated by the previous implementation.
    units.custom[:] = [u for u in units.custom if not (
        objdata.ObjectFile.obj_id(u) in {"ZG0" + str(e) for e in ELEMENTS}
        and b"WeaponGlow\\Hero_thuyyendao_" in (units.field(u, b"umdl") or b""))]
    units.save()
    for element in ELEMENTS:
        for folder in (dest, Path(src) / "VLTK_data" / "Models" / "war3mapImported" / "WeaponGlow"):
            (folder / ("Hero_thuyyendao_" + str(element) + ".mdx")).unlink(missing_ok=True)
    paths = {}
    for hand, bone in (("left", 19), ("right", 20)):
        blade = triangles_for_bones(geosets[6], {bone})
        for element in ELEMENTS:
            name = "Hero_thuyyendao_glow_%s_%d.mdx" % (hand, element)
            (dest / name).write_bytes(embedded_glow(blade, element, reverse=bone == 20))
            paths[hand, element] = "VLTK_data\\war3mapImported\\WeaponGlow\\" + name
    return paths


def attachment_point(src, hero_model):
    """Resolve a real socket in the imported hero; never silently attach at origin."""
    model = chunks(model_path(src, hero_model).read_bytes())
    names = {r[8:88].split(b"\0", 1)[0].decode("ascii").lower(): r
             for r in records(model.get(b"ATCH", b""))}
    for candidates, point in ((("weapon ref", "weapon"), "weapon"),
                              (("hand right ref", "hand right"), "hand,right")):
        for candidate in candidates:
            if candidate in names:
                node, parent = struct.unpack_from("<II", names[candidate], 88)
                if node * 12 + 12 > len(model[b"PIVT"]) or parent == 0xFFFFFFFF:
                    raise ValueError("invalid weapon/hand socket in " + hero_model)
                return point
    raise ValueError("no verified weapon/right-hand socket in " + hero_model)


def generate(src, weapons, hero_classes):
    from kskill_data import HERO

    prefixes = generate_weapons(src, weapons)
    embedded = generate_embedded(src)
    rows = []
    for hero, sect in hero_classes.items():
        if weapons[sect]:
            point = attachment_point(src, HERO[hero][0])
            rows.append("call SaveStr(zzVL_ht,'%s',612,\"%s\")" % (hero, point))
            for element in ELEMENTS:
                path = (prefixes[weapons[sect]] + str(element) + ".mdx").replace("\\", "\\\\")
                rows.append("call SaveStr(zzVL_ht,'%s',%d,\"%s\")" % (hero, 593 + element, path))
        else:
            if sect != "TYD":
                raise ValueError("missing glow implementation for " + sect)
            for (hand, element), path in embedded.items():
                key = (600 if hand == "left" else 605) + element
                rows.append("call SaveStr(zzVL_ht,'%s',%d,\"%s\")" % (hero, key, path.replace("\\", "\\\\")))
    print("weapon_glow: %d weapon clones + 10 forearm glow effects (1.31 compatible), %d sects" %
          (len(prefixes) * len(ELEMENTS), len(hero_classes)))
    return rows


def audit(src, names):
    for name in sorted(set(names)):
        model = chunks(model_path(src, name).read_bytes())
        print(name, "version", struct.unpack("<I", model[b"VERS"])[0])
        texs = model.get(b"TEXS", b"")
        print(" textures", [texs[i + 4:i + 264].split(b"\0")[0].decode("latin1")
                             for i in range(0, len(texs), 268)])
        for index, geoset in enumerate(records(model[b"GEOS"])):
            info = geoset_info(geoset)
            vp, count = info[b"VRTX"]
            points = list(struct.iter_unpack("<3f", geoset[vp:vp + count * 12]))
            mid = struct.unpack_from("<I", geoset, info["material"])[0]
            mats, n = info[b"MATS"]
            bones = struct.unpack_from("<%dI" % n, geoset, mats)
            print(" geoset", index, "vertices", count, "material", mid, "bones", bones,
                  "bounds", [[round(f(v[a] for v in points), 2) for a in range(3)] for f in (min, max)])


if __name__ == "__main__":
    import sys
    audit(Path(__file__).resolve().parents[1] / "src" / "map", sys.argv[1:])
