"""Regression checks against the actual KVCT weapon assets, not simplified mock meshes.

Run: python -m unittest discover -s tools/tests -v
"""
from pathlib import Path
import math
import re
import shutil
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOOLS))
import asset_layout
import objdata
import weapon_glow as glow
from kskill import WEAPON
from kskill_data import CLASS, HERO

SRC = TOOLS.parent / "src" / "map"


def array(record, tag, width):
    at, count = glow.geoset_info(record)[tag]
    return record[at:at + count * width]


class WeaponGlowTests(unittest.TestCase):
    def assert_clone(self, data, element, selected=None):
        original = glow.chunks(data)
        clone = glow.chunks(glow.clone_with_glow(data, element, selected))
        geosets = glow.records(original[b"GEOS"])
        output = glow.records(clone[b"GEOS"])
        selected = dict(enumerate(geosets)) if selected is None else selected
        self.assertEqual(output[:len(geosets)], geosets)
        self.assertEqual(len(output), len(geosets) + len(selected) * 2 + 2)
        for tag in (b"HELP", b"ATCH", b"EVTS", b"CLID"):
            self.assertEqual(clone.get(tag), original.get(tag), tag)
        for tag in (b"BONE", b"PIVT", b"TXAN"):
            self.assertTrue(clone.get(tag, b"").startswith(original.get(tag, b"")))
        self.assertTrue(clone[b"TEXS"].startswith(original[b"TEXS"]))
        self.assertTrue(clone[b"MTLS"].startswith(original[b"MTLS"]))
        self.assertTrue(clone[b"GEOA"].startswith(original.get(b"GEOA", b"")))
        materials = glow.records(clone[b"MTLS"])
        old_materials = len(glow.records(original[b"MTLS"]))
        texture_id = len(original[b"TEXS"]) // 268
        sequence_id = len(original.get(b"GLBS", b"")) // 4
        self.assertEqual(struct.unpack_from("<I", clone[b"GLBS"], sequence_id * 4)[0], 1800)
        for shell, (amount, alpha) in enumerate(glow.SHELLS):
            material = materials[old_materials + shell]
            self.assertEqual(material[12:20], b"LAYS" + struct.pack("<I", 1))
            size, mode, flags, texture, animation, uv, opacity = struct.unpack_from("<IIIiiIf", material, 20)
            self.assertEqual(size, len(material) - 20)
            self.assertEqual((mode, flags, texture, animation, uv), (4, 0x91, texture_id, -1, 0))
            self.assertAlmostEqual(opacity, alpha)
            self.assertEqual(material[48:52], b"KMTA")
            self.assertEqual(struct.unpack_from("<III", material, 52), (3, 1, sequence_id))
            for n, source in enumerate(selected.values()):
                target = output[len(geosets) + shell * len(selected) + n]
                self.assertEqual(struct.unpack_from("<I", target, glow.geoset_info(target)["material"])[0], old_materials + shell)
                for tag, width in ((b"PVTX", 2), (b"PTYP", 4), (b"PCNT", 4), (b"GNDX", 1), (b"MTGC", 4), (b"MATS", 4)):
                    self.assertEqual(array(target, tag, width), array(source, tag, width), tag)
                vertices = struct.iter_unpack("<3f", array(source, b"VRTX", 12))
                expanded = struct.iter_unpack("<3f", array(target, b"VRTX", 12))
                for a, b in zip(vertices, expanded):
                    distance = math.sqrt(sum((x - y) ** 2 for x, y in zip(a, b)))
                    self.assertLessEqual(distance, amount + .0001)
        old_animations = len(glow.records(original.get(b"GEOA", b"")))
        for n, animation in enumerate(glow.records(clone[b"GEOA"])[old_animations:]):
            self.assertEqual(struct.unpack_from("<I", animation, 8)[0], 2)
            colour = struct.unpack_from("<3f", animation, 12)
            expected_colour = (glow.ELEMENTS[element] if n < len(selected) * 2
                               else glow.ARC_COLOURS[n - len(selected) * 2])
            for actual, expected in zip(colour, reversed(expected_colour)):
                self.assertAlmostEqual(actual, expected / 255.)
            self.assertEqual(struct.unpack_from("<I", animation, 24)[0], len(geosets) + n)
        return clone

    def test_all_weapon_shapes_and_five_elements(self):
        names = sorted(set(WEAPON.values()) - {""})
        self.assertEqual(len(names), 20)
        for name in names:
            data = glow.model_path(SRC, name).read_bytes()
            for element in glow.ELEMENTS:
                with self.subTest(weapon=name, element=element):
                    self.assert_clone(data, element)

    def test_hand_particles_keep_motion_and_only_change_hue(self):
        for name in sorted(set(WEAPON.values()) - {""}):
            data = glow.model_path(SRC, name).read_bytes()
            particles = glow.chunks(data).get(b"PRE2", b"")
            if not particles:
                continue
            for element in glow.ELEMENTS:
                clone = glow.chunks(glow.clone_with_glow(data, element))[b"PRE2"]
                for before, after in zip(glow.records(particles), glow.records(clone)):
                    at = 4 + struct.unpack_from("<I", before, 4)[0] + 56
                    self.assertEqual(before[:at], after[:at])
                    self.assertEqual(before[at + 36:], after[at + 36:])
                    for offset in range(at, at + 36, 12):
                        light = max(struct.unpack_from("<3f", before, offset))
                        for actual, expected in zip(struct.unpack_from("<3f", after, offset), reversed(glow.ELEMENTS[element])):
                            self.assertAlmostEqual(actual, expected / 255. * light)

    def test_embedded_blades_do_not_light_the_body(self):
        data = glow.model_path(SRC, "Hero_thuyyendao").read_bytes()
        geoset = glow.records(glow.chunks(data)[b"GEOS"])[6]
        selected = glow.triangles_for_bones(geoset, {19, 20})
        sizes = struct.unpack("<%dI" % (len(array(geoset, b"MTGC", 4)) // 4), array(geoset, b"MTGC", 4))
        bones = list(struct.iter_unpack("<I", array(geoset, b"MATS", 4)))
        groups, offset = [], 0
        for size in sizes:
            groups.append({b[0] for b in bones[offset:offset + size]})
            offset += size
        indices = array(selected, b"GNDX", 1)
        faces = list(struct.iter_unpack("<3H", array(selected, b"PVTX", 2)))
        self.assertTrue(faces)
        self.assertLess(len(faces) * 6, len(array(geoset, b"PVTX", 2)))
        for face in faces:
            for vertex in face:
                self.assertTrue(groups[indices[vertex]] <= {19, 20})
        for element in glow.ELEMENTS:
            self.assert_clone(data, element, {6: selected})

    def test_all_sects_have_five_variants_and_valid_archive_paths(self):
        with tempfile.TemporaryDirectory(prefix="test_weapon_glow_", dir=TOOLS.parent / "build") as folder:
            root = Path(folder)
            shutil.copy2(SRC / "war3map.w3u", root / "war3map.w3u")
            original_template = objdata.ObjectFile.load(str(root / "war3map.w3u")).find("E002")
            for name in (set(WEAPON.values()) - {""}) | {row[0] for row in HERO.values()}:
                path = root / "VLTK_data" / "war3mapImported" / (name + ".mdx")
                path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(glow.model_path(SRC, name), path)
            rows = glow.generate(root, WEAPON, CLASS)
            self.assertEqual(len(CLASS), 33)
            self.assertEqual(len(rows), 32 * 6 + 10)
            for hero in CLASS:
                self.assertEqual(sum("'%s'" % hero in row for row in rows), 10 if CLASS[hero] == "TYD" else 6)
            for row in rows:
                match = re.search(r'"([^"]+)"', row)
                if match and ",612," not in row:
                    legacy = match[1].replace("\\\\", "\\")
                    path = root / Path(legacy.replace("\\", "/"))
                    self.assertTrue(path.is_file(), path)
                    rewritten = asset_layout.rewrite_references(row.encode()).decode()
                    self.assertIn("VLTK_data\\\\Models\\\\war3mapImported\\\\WeaponGlow", rewritten)
            units = objdata.ObjectFile.load(str(root / "war3map.w3u"))
            template = units.find("E002")
            for element in glow.ELEMENTS:
                self.assertIsNone(units.find("ZG0" + str(element)))
            self.assertEqual(template, original_template)
            glow.generate_embedded(root)
            units = objdata.ObjectFile.load(str(root / "war3map.w3u"))
            self.assertEqual(sum(units.obj_id(u).startswith("ZG0") for u in units.custom), 0)
            for file in (root / "VLTK_data" / "war3mapImported" / "WeaponGlow").glob("*.mdx"):
                rewritten = glow.chunks(asset_layout.rewrite_mdx_textures(file.read_bytes()))
                textures = rewritten[b"TEXS"]
                self.assertIn(b"VLTK_data\\Textures\\war3mapImported\\WeaponGlow\\white.tga", textures)
            self.assertEqual(len(list((root / "VLTK_data" / "war3mapImported" / "WeaponGlow").glob("*.mdx"))), 110)

    def test_embedded_glow_follows_forearms_without_skin_natives(self):
        data = glow.model_path(SRC, "Hero_thuyyendao").read_bytes()
        original = glow.chunks(data)
        patched_data = glow.forearm_sockets(data)
        patched = glow.chunks(patched_data)
        for tag in (b"GEOS", b"BONE", b"SEQS", b"TEXS", b"MTLS"):
            self.assertEqual(original[tag], patched[tag])
        self.assertTrue(patched[b"ATCH"].startswith(original[b"ATCH"]))
        self.assertTrue(patched[b"PIVT"].startswith(original[b"PIVT"]))
        self.assertEqual(glow.forearm_sockets(patched_data), patched_data)
        attachments = {r[8:88].split(b"\0", 1)[0]: r for r in glow.records(patched[b"ATCH"])}
        geoset = glow.records(original[b"GEOS"])[6]
        for name, bone in ((b"Sprite First Ref", 19), (b"Sprite Second Ref", 20)):
            node, parent = struct.unpack_from("<II", attachments[name], 88)
            self.assertEqual(parent, bone)
            self.assertEqual(struct.unpack_from("<3f", patched[b"PIVT"], node * 12), (0., 0., 0.))
            blade = glow.triangles_for_bones(geoset, {bone})
            for element in glow.ELEMENTS:
                light = glow.chunks(glow.embedded_glow(blade, element))
                self.assertEqual(len(light[b"MODL"]), 372)
                self.assertEqual(len(light[b"SEQS"]), 132)
                self.assertEqual(struct.unpack_from("<II", light[b"BONE"], 84), (0, 0xFFFFFFFF))
                shells = glow.records(light[b"GEOS"])
                self.assertEqual(len(shells), 4)
                for shell in shells[:2]:
                    self.assertEqual(array(shell, b"PVTX", 2), array(blade, b"PVTX", 2))
                    self.assertEqual(set(array(shell, b"GNDX", 1)), {0})
                    self.assertEqual(array(shell, b"MATS", 4), bytes(4))
                for index, animation in enumerate(glow.records(light[b"GEOA"])):
                    colour = (glow.ELEMENTS[element] if index < 2
                              else glow.ARC_COLOURS[index - 2])
                    for actual, expected in zip(struct.unpack_from("<3f", animation, 12), reversed(colour)):
                        self.assertAlmostEqual(actual, expected / 255.)

    def test_blue_white_lightning_scrolls_along_weapon_and_sparks_follow(self):
        for name in sorted(set(WEAPON.values()) - {""}):
            data = glow.model_path(SRC, name).read_bytes()
            original = glow.chunks(data)
            for element in glow.ELEMENTS:
                with self.subTest(weapon=name, element=element):
                    clone = glow.chunks(glow.clone_with_glow(data, element))
                    tx = glow.records(clone[b"TXAN"])[-1]
                    self.assertEqual(tx[4:8], b"KTAT")
                    sequence = len(original.get(b"GLBS", b"")) // 4
                    self.assertEqual(struct.unpack_from("<III", tx, 8), (2, 1, sequence))
                    self.assertEqual(struct.unpack_from("<I3f", tx, 20), (0, 0., 0., 0.))
                    self.assertEqual(struct.unpack_from("<I3f", tx, 36), (1800, -1., 0., 0.))
                    original_count = len(glow.records(original.get(b"PRE2", b"")))
                    arc_nodes = {struct.unpack_from("<I", r, 84)[0]
                                 for r in glow.bone_records(clone[b"BONE"][len(original.get(b"BONE", b"")):])}
                    emitters = [r for r in glow.records(clone[b"PRE2"])[original_count:]
                                if r[8:88].split(b"\0", 1)[0] == b"Element spark"]
                    self.assertGreater(len(emitters), 0)
                    self.assertLessEqual(len(emitters), 6)
                    phases = []
                    for emitter in emitters:
                        self.assertEqual(struct.unpack_from("<I", emitter, 4)[0], 96)
                        node, parent, flags = struct.unpack_from("<III", emitter, 88)
                        self.assertIn(parent, arc_nodes)
                        self.assertGreaterEqual(node, len(original[b"PIVT"]) // 12)
                        self.assertEqual(flags & 0x80000, 0x80000)
                        self.assertEqual(flags & 0x1000, 0x1000)
                        self.assertAlmostEqual(struct.unpack_from("<f", emitter, 116)[0], .2)
                        for offset in (156, 168, 180):
                            colour = glow.hot_colour(glow.LIGHTNING_COLOUR) if offset == 156 else glow.LIGHTNING_COLOUR
                            for actual, expected in zip(struct.unpack_from("<3f", emitter, offset), reversed(colour)):
                                self.assertAlmostEqual(actual, expected / 255.)
                        self.assertEqual(emitter[271:275], b"KP2E")
                        count, interpolation, global_sequence = struct.unpack_from("<III", emitter, 275)
                        self.assertEqual((interpolation, global_sequence), (1, sequence))
                        keys = list(struct.iter_unpack("<If", emitter[287:]))
                        self.assertEqual(len(keys), count)
                        self.assertEqual((keys[0][0], keys[-1][0]), (0, 1800))
                        self.assertAlmostEqual(keys[0][1], keys[-1][1])
                        self.assertEqual(min(value for time, value in keys), 0.)
                        self.assertEqual(max(value for time, value in keys), 22.)
                        phases.append(max(keys[:-1], key=lambda key: key[1])[0])
                    self.assertEqual(len(set(phases)), len(phases))
                    for arc in glow.records(clone[b"GEOS"])[-2:]:
                        indices = list(struct.iter_unpack("<H", array(arc, b"PVTX", 2)))
                        points = list(struct.iter_unpack("<3f", array(arc, b"VRTX", 12)))
                        self.assertLess(max(i[0] for i in indices), len(points))
                        bindings = list(struct.iter_unpack("<I", array(arc, b"MATS", 4)))
                        self.assertTrue(all(i[0] in arc_nodes for i in bindings))

    def test_flames_use_element_colour_animated_atlas_and_bounded_particle_budget(self):
        sources = [(glow.model_path(SRC, name).read_bytes(), False)
                   for name in sorted(set(WEAPON.values()) - {""})]
        hero = glow.chunks(glow.model_path(SRC, "Hero_thuyyendao").read_bytes())
        for bone in (19, 20):
            blade = glow.triangles_for_bones(glow.records(hero[b"GEOS"])[6], {bone})
            sources.append((blade, True))
        for index, (source, embedded) in enumerate(sources):
            for element in glow.ELEMENTS:
                with self.subTest(weapon=index, element=element):
                    generate = glow.embedded_glow if embedded else glow.clone_with_glow
                    model = glow.chunks(generate(source, element))
                    colour = glow.ELEMENTS[element]
                    flames = [r for r in glow.records(model[b"PRE2"])
                              if r[8:88].split(b"\0", 1)[0] == b"Element flame"]
                    self.assertGreater(len(flames), 0)
                    self.assertLessEqual(len(flames), 8)
                    budget = 0
                    for flame in flames:
                        node, parent, flags = struct.unpack_from("<III", flame, 88)
                        self.assertLess(parent, node)
                        self.assertLess(node * 12, len(model[b"PIVT"]))
                        self.assertEqual(flags & 0x81000, 0x81000)
                        self.assertEqual(struct.unpack_from("<4I", flame, 132), (1, 4, 4, 0))
                        life = struct.unpack_from("<f", flame, 116)[0]
                        self.assertAlmostEqual(life, .44)
                        self.assertLess(struct.unpack_from("<f", flame, 112)[0], 0.)
                        self.assertEqual(struct.unpack_from("<3f", flame, 195), (7.5, 11.5, 3.))
                        self.assertEqual(struct.unpack_from("<6I", flame, 207), (0, 4, 1, 5, 15, 1))
                        for offset in (156, 168, 180):
                            expected = glow.hot_colour(colour) if offset == 156 else colour
                            for actual, value in zip(struct.unpack_from("<3f", flame, offset), reversed(expected)):
                                self.assertAlmostEqual(actual, value / 255.)
                        texid = struct.unpack_from("<I", flame, 255)[0]
                        texture = model[b"TEXS"][texid * 268 + 4:texid * 268 + 264].split(b"\0", 1)[0]
                        self.assertEqual(texture.decode("ascii"), glow.FLAME_TEXTURE)
                        self.assertEqual(flame[271:275], b"KP2E")
                        self.assertEqual(struct.unpack_from("<III", flame, 275), (31, 1, len(model[b"GLBS"]) // 4 - 2))
                        keys = list(struct.iter_unpack("<If", flame[287:]))
                        self.assertAlmostEqual(keys[0][1], keys[-1][1])
                        self.assertGreaterEqual(min(v for t, v in keys), 6.)
                        self.assertLessEqual(max(v for t, v in keys), 18.)
                        budget += life * max(v for t, v in keys)
                    self.assertLess(budget, 64.)
                    self.assertGreaterEqual(glow.VFX_MARGIN, 40.)

    def test_lightning_bends_on_global_clock_without_changing_original_bones(self):
        for name in sorted(set(WEAPON.values()) - {""}):
            with self.subTest(weapon=name):
                original = glow.chunks(glow.model_path(SRC, name).read_bytes())
                clone = glow.chunks(glow.clone_with_glow(glow.pack_chunks(original), 4))
                self.assertTrue(clone[b"BONE"].startswith(original.get(b"BONE", b"")))
                self.assertEqual(clone.get(b"RIBB"), original.get(b"RIBB"))
                bones = glow.bone_records(clone[b"BONE"][len(original.get(b"BONE", b"")):])
                self.assertGreaterEqual(len(bones), 18)
                self.assertLessEqual(len(bones), 36)
                self.assertEqual(struct.unpack_from("<I", clone[b"GLBS"], len(clone[b"GLBS"]) - 4)[0], 600)
                motion = []
                for bone in bones:
                    node, parent, flags = struct.unpack_from("<III", bone, 84)
                    self.assertLess(parent, len(original[b"PIVT"]) // 12)
                    self.assertGreaterEqual(node, len(original[b"PIVT"]) // 12)
                    self.assertEqual(flags, 0x100)
                    self.assertEqual(bone[96:100], b"KGTR")
                    self.assertEqual(struct.unpack_from("<III", bone, 100), (9, 1, len(clone[b"GLBS"]) // 4 - 1))
                    keys = list(struct.iter_unpack("<I3f", bone[112:-8]))
                    self.assertEqual([key[0] for key in keys], list(range(0, 601, 75)))
                    self.assertEqual(keys[0][1:], keys[-1][1:])
                    self.assertNotEqual(keys[0][1:], keys[1][1:])
                    self.assertTrue(all(math.sqrt(sum(v*v for v in key[1:])) < 1.6 for key in keys))
                    motion.append(keys[0][1:])
                self.assertGreater(len(set(motion)), 8)
                # A complete U span and negative texture translation move the pulse grip -> tip.
                arc = glow.records(clone[b"GEOS"])[-1]
                info = glow.geoset_info(arc)
                uv = arc.index(b"UVBS", info["sequence_extents"][0])
                values = list(struct.iter_unpack("<2f", arc[uv+8:]))
                self.assertEqual(values[0][0], 0.)
                self.assertEqual(values[191][0], 1.)
                if not original.get(b"SEQS"):
                    self.assertEqual(clone[b"SEQS"][:5], b"Stand")
                    self.assertEqual(struct.unpack_from("<II", clone[b"SEQS"], 80), (0, 1800))
                    self.assertEqual(struct.unpack_from("<I", clone[b"SEQS"], 92)[0], 0)

    def test_verified_hero_sockets_and_no_world_space_lightning_trigger(self):
        missing_weapon = {"E003", "H00Z", "H009", "H01U", "H00V", "H022", "H028", "H02A"}
        for hero, (model, label) in HERO.items():
            if CLASS[hero] == "TYD":
                continue
            self.assertEqual(glow.attachment_point(SRC, model), "hand,right" if hero in missing_weapon else "weapon")
        with self.assertRaises(ValueError):
            glow.attachment_point(SRC, "VK_daoTND")
        script = (TOOLS / "jass" / "gameplay_09_equip.j").read_text(encoding="utf-8")
        update = script.split("function zzEQ_UpdateWeaponGlow takes", 1)[1].split("endfunction", 1)[0]
        update = re.sub(r"//[^\n]*", "", update)
        calls = set(re.findall(r"\bcall\s+(\w+)\(", update))
        self.assertTrue(calls <= {"DestroyEffect", "RemoveSavedHandle", "BlzPlaySpecialEffect",
                                 "SaveEffectHandle", "BlzSetSpecialEffectScale", "SaveInteger"}, calls)
        self.assertIn("LoadStr(zzVL_ht,vl_type,612)", update)
        self.assertNotRegex(update, r"\b(?:AddLightning\w*|MoveLightning\w*|TimerStart|GetUnitX|GetUnitY)\(")

    def test_measured_flow_direction_for_spears_and_embedded_blades(self):
        for name, direction in (("VK_daoTND", 1), ("VK_thuongTNK", 1), ("VK_thuongTVT", 1), ("VK_chuongngav1", -1)):
            model = glow.chunks(glow.model_path(SRC, name).read_bytes())
            paths = glow.surface_paths(glow.records(model[b"GEOS"]), name in glow.REVERSE_FLOW)
            self.assertTrue(all((path[-1][0][0]-path[0][0][0])*direction > 0 for path in paths))
        hero = glow.chunks(glow.model_path(SRC, "Hero_thuyyendao").read_bytes())
        for bone, reverse, direction in ((19, False, 1), (20, True, -1)):
            blade = glow.triangles_for_bones(glow.records(hero[b"GEOS"])[6], {bone})
            paths = glow.surface_paths([blade], reverse)
            self.assertTrue(all((path[-1][0][1]-path[0][0][1])*direction > 0 for path in paths))

    def test_paths_use_only_selected_faces_and_stay_close_to_weapon(self):
        hero = glow.chunks(glow.model_path(SRC, "Hero_thuyyendao").read_bytes())
        geoset = glow.records(hero[b"GEOS"])[6]
        for bone in (19, 20):
            blade = glow.triangles_for_bones(geoset, {bone})
            paths = glow.surface_paths([blade])
            for path in paths:
                self.assertEqual(len(path), 49)
                for point, normal, binding in path:
                    self.assertEqual(binding, (bone,))
                    self.assertAlmostEqual(sum(n * n for n in normal), 1.)
            rigid_paths = glow.surface_paths([glow.rigid_geoset(blade)])
            for actual, expected in zip(paths, rigid_paths):
                self.assertEqual([p[0] for p in actual], [p[0] for p in expected])
        data = glow.model_path(SRC, "VK_daoTND").read_bytes()
        model = glow.chunks(data)
        geoset = glow.records(model[b"GEOS"])[0]
        points = list(struct.iter_unpack("<3f", array(geoset, b"VRTX", 12)))
        lo = [min(p[a] for p in points) for a in range(3)]
        hi = [max(p[a] for p in points) for a in range(3)]
        for path in glow.surface_paths([geoset]):
            for point, normal, binding in path:
                for a in range(3):
                    self.assertGreaterEqual(point[a], lo[a] - 4.71)
                    self.assertLessEqual(point[a], hi[a] + 4.71)
                self.assertEqual(binding, (0,))

    def test_vfx_textures_have_transparency_and_seamless_arc_loop(self):
        from PIL import Image
        import io
        for kind in ("arc", "spark", "flame"):
            texture = Image.open(io.BytesIO(glow.vfx_texture(kind)))
            alpha = texture.getchannel("A")
            self.assertEqual(alpha.getextrema()[0], 0)
            self.assertGreater(alpha.getextrema()[1], 180)
            if kind == "arc":
                self.assertEqual(alpha.crop((0, 0, 1, 32)).tobytes(),
                                 alpha.crop((127, 0, 128, 32)).tobytes())
            elif kind == "flame":
                self.assertEqual(texture.size, (256, 256))
                frames = []
                for y in range(0, 256, 64):
                    for x in range(0, 256, 64):
                        frame = alpha.crop((x, y, x + 64, y + 64))
                        frames.append(frame.tobytes())
                        self.assertGreater(frame.getextrema()[1], 180)
                        for box in ((0, 0, 64, 1), (0, 63, 64, 64), (0, 0, 1, 64), (63, 0, 64, 64)):
                            self.assertEqual(frame.crop(box).getextrema(), (0, 0))
                self.assertEqual(len(set(frames)), 16)

    def test_white_texture_and_categorized_path(self):
        from PIL import Image
        import io
        image = Image.open(io.BytesIO(glow.white_texture()))
        self.assertEqual(image.size, (4, 4))
        self.assertEqual(image.getpixel((0, 0)), (255, 255, 255, 255))
        with tempfile.TemporaryDirectory(prefix="test_weapon_glow_", dir=TOOLS.parent / "build") as folder:
            root = Path(folder)
            path = root / "VLTK_data" / "Models" / "war3mapImported" / "VK_daoTND.mdx"
            path.parent.mkdir(parents=True)
            shutil.copy2(glow.model_path(SRC, "VK_daoTND"), path)
            glow.generate_weapons(root, {"TND": "VK_daoTND"})
            self.assertTrue((root / "VLTK_data" / "Textures" / "war3mapImported" / "WeaponGlow" / "white.tga").is_file())
            self.assertTrue((root / "VLTK_data" / "Textures" / "war3mapImported" / "WeaponGlow" / "flame.tga").is_file())

    def test_malformed_models_are_rejected(self):
        for data in (b"", b"MDLXbad", b"MDLXGEOS" + struct.pack("<I", 100)):
            with self.assertRaises(ValueError):
                glow.chunks(data)
        with self.assertRaises(ValueError):
            glow.records(b"bad")
        data = glow.model_path(SRC, "VK_daoTND").read_bytes()
        with self.assertRaises(ValueError):
            glow.clone_with_glow(data, 1, {})


if __name__ == "__main__":
    unittest.main()
