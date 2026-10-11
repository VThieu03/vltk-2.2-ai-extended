"""The lobby must not depend on newer natives merely present in the pjass common.j."""
from pathlib import Path
import json
import sys
import unittest

TOOLS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOOLS))
import jass_compat


class NativeCompatibilityTests(unittest.TestCase):
    def setUp(self):
        self.target = json.loads(jass_compat.MANIFEST.read_text(encoding="utf-8"))
        self.common = (TOOLS.parent / "work" / "pjass" / "common.j").read_text(encoding="utf-8")

    def test_skin_natives_rejected_even_though_pjass_knows_them(self):
        script = "call BlzSetUnitSkin(vl_hero,BlzGetUnitSkin(vl_hero))"
        self.assertEqual(jass_compat.unsupported_natives(script, self.common, self.target["natives"]),
                         ["BlzGetUnitSkin", "BlzSetUnitSkin"])

    def test_existing_effect_natives_are_supported(self):
        script = 'set vl_fx=AddSpecialEffectTarget("glow.mdx",vl_hero,"sprite,first")\ncall BlzSetSpecialEffectColor(vl_fx,255,0,0)'
        self.assertEqual(jass_compat.unsupported_natives(script, self.common, self.target["natives"]), [])

    def test_comments_and_escaped_strings_do_not_trigger_guard(self):
        script = '// BlzSetUnitSkin(hero,skin)\ncall BJDebugMsg("BlzGetUnitSkin \\\"BlzSetUnitSkin\\\"")'
        self.assertEqual(jass_compat.unsupported_natives(script, self.common, self.target["natives"]), [])

    def test_equipment_module_has_no_unsupported_natives(self):
        script = (TOOLS / "jass" / "gameplay_09_equip.j").read_text(encoding="utf-8")
        self.assertEqual(jass_compat.unsupported_natives(script, self.common, self.target["natives"]), [])


if __name__ == "__main__":
    unittest.main()
