"""Give existing combat units and interactive NPCs a consistent KVCT model set."""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import kvcreep
import objdata
import vfx
from mpq import MPQ

SRC = kvcreep.SRC
DEST = "VLTK_data\\war3mapImported\\KVCTUnits\\"
CREEP_DEST = kvcreep.DEST

# Explicit IDs only: heroes, spell dummies, selection cards, and buildings retain
# their own presentation and behavior. The IDs and every non-model field stay put.
CREEPS = {
    "n002": "Creep_bokhoai", "n004": "Creep_manhho", "n005": "Creep_bachho",
    "n006": "Creep_cuoptieu", "n007": "Creep_dinhankiemkhach",
    "n008": "Creep_cuoptieu", "n009": "Creep_bokhoai",
    "n00A": "Creep_uminhdocsu", "n00B": "Creep_uminhdocsu",
    "n00D": "Creep_culinhchienthan", "n00E": "Creep_dinhankiemkhach",
    "n00J": "Creep_thanhthanhkiemkhach",
    # cua / Nhược Thủy còn model game gốc (đơn vị gốc sửa lại: khóa là mã gốc vì mã riêng để trống)
    "nlkl": "Creep_bachho", "nltc": "Creep_manhho", "nsc3": "Creep_bokhoai",
    "n00N": "Creep_uminhdocsu",
}
BOSSES = {
    "o001": "Boss_satdaimuc", "h01F": "Boss_doccokiem",
    "e003": "Boss_lymacsau", "n018": "Boss_kiemma",
    "n0TK": "Boss_lymacsau", "n00C": "Boss_doccokiem",
    "n00F": "Boss_lymacsau", "n00G": "Boss_lymacsau",
    "n00H": "Boss_lymacsau", "n00I": "Boss_kiemma",
    "n00Q": "Boss_satdaimuc",
}
NPCS = {
    "n000": "NPC_1", "h00W": "NPC_2", "h01N": "NPC_3",
    "h0XP": "NPC_4", "h0B1": "NPC_5", "h0B2": "NPC_6",
}


def import_model(model, archive):
    name = model + ".mdx"
    data = archive.read("war3mapImported\\" + name)
    if data is None:
        raise FileNotFoundError("KVCT unit model missing: " + name)
    for texture in vfx.textures(data):
        if texture.lower().startswith(("kvct3_data\\", "war3mapimported\\")):
            kvcreep.copy_texture(texture, archive)
    data = vfx.rewrite_model_textures(data)
    path = os.path.join(SRC, *DEST.split("\\"), name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as output:
        output.write(data)


def main():
    archive = MPQ(kvcreep.KVCT, open(kvcreep.KVCT, "rb").read(1 << 20).find(b"MPQ\x1a"))
    path = os.path.join(SRC, "war3map.w3u")
    units = objdata.ObjectFile.load(path)
    mapping = {**{code: CREEP_DEST + model + ".mdx" for code, model in CREEPS.items()},
               **{code: DEST + model + ".mdx" for code, model in {**BOSSES, **NPCS}.items()}}
    for model in sorted(set(BOSSES.values()) | set(NPCS.values())):
        import_model(model, archive)
    found = set()
    for table in units.tables:
        for base, code, sets in table:
            key = (code if code.strip(bytes(1)) else base).decode("ascii")  # đơn vị gốc sửa lại: mã riêng trống -> mã gốc
            if key in mapping:
                for mods in sets:
                    kvcreep.set_field(mods, "umdl", 3, mapping[key])
                found.add(key)
    missing = set(mapping) - found
    if missing:
        raise RuntimeError("KVCT model mapping IDs missing: " + ", ".join(sorted(missing)))
    units.save()
    print("kvunit_models: mapped %d existing units (%d creep, %d boss, %d NPC)" %
          (len(found), len(CREEPS), len(BOSSES), len(NPCS)))


if __name__ == "__main__":
    main()
