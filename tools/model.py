# Mô hình dữ liệu dùng chung cho các bước build, viết theo hướng đối tượng.
# Gom dữ liệu đang rải ở nhiều file (kskill_data.CLASS / HERO, kvequip_data.CLASS_WEAPON, config.CLASS_PHE) vào một chỗ:
#   from model import Phai
#   for p in Phai.all(): p.hero_id, p.code, p.name, p.model, p.he, p.is_noi, p.weapons, p.main_weapon
#   Phai.by_code("CBC"), Phai.by_hero("H00A"), p.skills (list KyNang), p.manual_qwe
#   VuKhi.all() (11 loại vũ khí), OTrangBi.all() (10 ô trang bị)
# Dữ liệu gốc vẫn sửa ở các file cũ; lớp này chỉ đọc và kiểm tra cho khớp.
import config
import kskill_data
import kvequip_data

NGOAI, NOI = "ngoai", "noi"


class KyNang(dict):
    """Một kỹ năng KVCT của một phái (đọc từ kskill_data.load()). Vẫn là dict nên code cũ dùng k["name"] chạy như trước."""

    def __init__(self, phai, index, data):
        super().__init__(data)
        self.phai = phai
        self.index = index          # 0..13, thứ tự ô trong bảng kỹ năng

    name = property(lambda self: self["name"])
    key = property(lambda self: self["key"])          # "Q" "W" "E" "R" "D" "F" "T" hoặc "" (bị động)
    kind = property(lambda self: self["kind"])        # loại chiêu (bảng KIND trong kskill_list.py)
    hits = property(lambda self: self["hits"])
    kv_id = property(lambda self: self["kv"])         # mã chiêu trong map KVCT
    icon = property(lambda self: self["icon"])
    tip = property(lambda self: self["tip"])

    @property
    def is_passive(self):
        return not self["key"]

    @property
    def is_manual(self):
        """Q W E cast tay (không autocast) theo kskill_data.MANUAL_QWE"""
        return self["key"] in self.phai.manual_qwe

    def __repr__(self):
        return "KyNang(%s %d %s [%s])" % (self.phai.code, self.index, self.name, self.key or "bị động")


class Phai:
    """Một môn phái (một loại tướng)."""

    _all = None
    _skills = None

    def __init__(self, hero_id, code):
        self.hero_id = hero_id                       # mã loại tướng trong map: E000, H00A...
        self.code = code                             # mã phái: NDD, CBC...
        self.model, self.name = kskill_data.HERO[hero_id]
        self.he = config.CLASS_PHE.get(code, NGOAI)  # hệ ngoại / nội công (config.py mục 15)
        assert self.he in (NGOAI, NOI), "config.CLASS_PHE[%r] phải là 'ngoai' hoặc 'noi'" % code
        assert code in kvequip_data.CLASS_WEAPON, "phái %s chưa có loại vũ khí" % code
        self.weapons = list(kvequip_data.CLASS_WEAPON[code])   # loại vũ khí mặc được, loại chính đầu tiên

    @property
    def is_noi(self):
        return self.he == NOI

    @property
    def he_id(self):
        """khóa 99 trong JASS: 1 ngoại công, 2 nội công"""
        return 2 if self.is_noi else 1

    @property
    def manual_qwe(self):
        return kskill_data.MANUAL_QWE.get(self.code, ())

    @property
    def skills(self):
        """14 kỹ năng KVCT của phái (list KyNang); dữ liệu đọc một lần cho mọi phái"""
        if Phai._skills is None:
            Phai._skills = kskill_data.load()
        return [KyNang(self, i, d) for i, d in enumerate(Phai._skills[self.code][:14])]

    def skill(self, name):
        return next((k for k in self.skills if k.name == name), None)

    @property
    def main_weapon(self):
        return self.weapons[0]

    def can_wear(self, weapon):
        return weapon in self.weapons

    def __repr__(self):
        return "Phai(%s %s %s)" % (self.hero_id, self.code, self.name)

    @classmethod
    def all(cls):
        if cls._all is None:
            cls._all = [cls(h, c) for h, c in kskill_data.CLASS.items()]
        return cls._all

    @classmethod
    def by_code(cls, code):
        return next(p for p in cls.all() if p.code == code)

    @classmethod
    def by_hero(cls, hero_id):
        return next(p for p in cls.all() if p.hero_id == hero_id)


class VuKhi:
    """Một loại vũ khí (chỉ số 0..10 = ITV0..ITVA, Tần Lăng ITW0..ITWA)."""

    def __init__(self, index):
        self.index = index
        self.name, self.icon_pattern = kvequip_data.WEAPONS[index]

    def code(self, tanlang=False):
        return kvequip_data.weapon_code(self.index, tanlang)

    @property
    def phai(self):
        return [p for p in Phai.all() if p.can_wear(self.index)]

    def __repr__(self):
        return "VuKhi(%d %s)" % (self.index, self.name)

    @classmethod
    def all(cls):
        return [cls(i) for i in range(len(kvequip_data.WEAPONS))]


class OTrangBi:
    """Một ô trang bị (1..10; ô 6 là vũ khí)."""

    def __init__(self, slot):
        self.slot = slot
        self.code, self.name, self.ui_order, self.icon_pattern = kvequip_data.SLOTS[slot]

    @property
    def is_weapon(self):
        return self.slot == 6

    def __repr__(self):
        return "OTrangBi(%d %s)" % (self.slot, self.name)

    @classmethod
    def all(cls):
        return [cls(s) for s in sorted(kvequip_data.SLOTS)]


if __name__ == "__main__":
    for p in Phai.all():
        print("%-5s %-4s %-22s %-5s vũ khí %s" % (p.hero_id, p.code, p.name, p.he, [VuKhi(w).name for w in p.weapons]))
    print(OTrangBi.all())
