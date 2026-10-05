# TCVN3 (ABC / .VnTime fonts) -> Unicode for text the 1.24 map stored as UTF-8 of Latin-1 characters.
# The map mixes encodings (some strings are already Unicode Vietnamese), so a string is converted only
# when it contains a character that cannot occur in Unicode Vietnamese but is a TCVN3 code, or a word
# whose spelling is impossible in Unicode Vietnamese but normal in TCVN3 ("KiÕm", "lùc", "Thêi").
import re

_T = {
    0xA1: "Ă", 0xA2: "Â", 0xA3: "Ê", 0xA4: "Ô", 0xA5: "Ơ", 0xA6: "Ư", 0xA7: "Đ",
    0xA8: "ă", 0xA9: "â", 0xAA: "ê", 0xAB: "ô", 0xAC: "ơ", 0xAD: "ư", 0xAE: "đ",
    0xB5: "à", 0xB6: "ả", 0xB7: "ã", 0xB8: "á", 0xB9: "ạ",
    0xBB: "ằ", 0xBC: "ẳ", 0xBD: "ẵ", 0xBE: "ắ", 0xC6: "ặ",
    0xC7: "ầ", 0xC8: "ẩ", 0xC9: "ẫ", 0xCA: "ấ", 0xCB: "ậ",
    0xCC: "è", 0xCE: "ẻ", 0xCF: "ẽ", 0xD0: "é", 0xD1: "ẹ",
    0xD2: "ề", 0xD3: "ể", 0xD4: "ễ", 0xD5: "ế", 0xD6: "ệ",
    0xD7: "ì", 0xD8: "ỉ", 0xDC: "ĩ", 0xDD: "í", 0xDE: "ị",
    0xDF: "ò", 0xE1: "ỏ", 0xE2: "õ", 0xE3: "ó", 0xE4: "ọ",
    0xE5: "ồ", 0xE6: "ổ", 0xE7: "ỗ", 0xE8: "ố", 0xE9: "ộ",
    0xEA: "ờ", 0xEB: "ở", 0xEC: "ỡ", 0xED: "ớ", 0xEE: "ợ",
    0xEF: "ù", 0xF1: "ủ", 0xF2: "ũ", 0xF3: "ú", 0xF4: "ụ",
    0xF5: "ừ", 0xF6: "ử", 0xF7: "ữ", 0xF8: "ứ", 0xF9: "ự",
    0xFA: "ỳ", 0xFB: "ỷ", 0xFC: "ỹ", 0xFD: "ý", 0xFE: "ỵ",
}
# Latin-1 letters that are legitimate in Unicode Vietnamese
_VN_OK = set("ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúý")
# the author also typed some text with Latin-1 look-alikes only ("Thû khô" = Thủ Khố): û is never the
# only TCVN3 code of a real TCVN3 string in this map, so it does not mark one, and is shown as ủ
_APPROX = {"û": "ủ", "Û": "Ủ"}
_L1 = "\u00c0-\u00ff"
_WORD = re.compile(r"[A-Za-z%s]+" % _L1)
# huyen / nga tone letters, impossible before a stop final (c ch p t) in Unicode Vietnamese
_NO_STOP = "àèìòùãõÀÈÌÒÙÃÕ"
# TCVN3 words of the map that pass every rule (valid-looking spelling)
_WORDS = {"Trèng"}
unknown = {}


def _bad_word(w):
    if w in _WORDS:
        return True
    for i, c in enumerate(w):
        if not 0xC0 <= ord(c) <= 0xFF:
            continue
        if i and c.isupper() and w[i - 1].islower():      # KiÕm XÝch TiÒn NhuyÔn
            return True
        if c in _NO_STOP and re.fullmatch(r"(c|ch|p|t)", w[i + 1:]):
            return True                                    # lùc Tèc Cèt
        if c in "èéêÈÉÊ" and w[i + 1:i + 2] == "i":        # Néi Thêi
            return True
    return False


def is_tcvn3(s):
    if any(0x80 <= ord(c) <= 0xFF and c not in _VN_OK and c not in _APPROX for c in s):
        return True
    return any(_bad_word(w) for w in _WORD.findall(s) if re.search("[%s]" % _L1, w))


def convert(s):
    """convert one string if it looks like TCVN3; returns (new, changed)"""
    if not is_tcvn3(s):
        if any(c in s for c in _APPROX):
            return "".join(_APPROX.get(c, c) for c in s), True
        return s, False
    out = []
    for c in s:
        o = ord(c)
        if 0x80 <= o <= 0xFF:
            if o in _T:
                out.append(_T[o])
            else:
                unknown[c] = unknown.get(c, 0) + 1
                out.append(c)
        else:
            out.append(c)
    return "".join(out), True
