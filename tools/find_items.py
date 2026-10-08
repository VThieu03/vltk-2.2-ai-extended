import sys, os, re

sys.path.insert(0, 'tools')
import describe, objdata


def n(s):
    return describe.plain(re.sub(r'\|c[0-9a-fA-F]{8}|\|r', '', s.decode('utf-8'))).strip().lower()


v, t = objdata.parse(open(r'src\map\war3map.w3t', 'rb').read(), '.w3t')
items = {}
for o, n_id, s in t[0] + t[1]:
    for m in s:
        if m[0] == b'unam':
            items[n(m[4])] = n_id.decode('utf-8')

targets = [
    'o long bao thach',
    'bi pho',
    'hong anh bao thach',
    'luc bao thach',
    'lam bao thach',
    'long nguyen',
    'bach bao thach',
    'co nguyet bao thach',
    'thien nien co vat',
    'ngoc luc bao',
    'kim cuong',
    'sa nhung',
    'nu oa tinh thach',
    'bo de moc',
]
for t in targets:
    print(t, items.get(t))
