# KVCT farm-creep model set. Models are in base.w3x; their skins are in D:\KVCT31_Data.
TIERS = [
    (1, "Creep_manhho", "Creep_bachho"),
    (20, "Creep_cuoptieu", "Creep_bokhoai"),
    (40, "Creep_dinhankiemkhach", "Creep_thanhthanhkiemkhach"),
    (60, "Creep_mongcokybinh", "Creep_kybinhkimquoc"),
    (80, "Creep_hoangnguyendaokhach", "Creep_bachphutruong"),
    (100, "Creep_culinhchienthan", "Creep_uminhdocsu"),
]

CODE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


def rawcode(index):
    return "Q" + CODE[index // 36] + CODE[index % 36] + "1"


def unit_codes():
    return {level: (rawcode(2 * index), rawcode(2 * index + 1))
            for index, (level, _, _) in enumerate(TIERS)}
