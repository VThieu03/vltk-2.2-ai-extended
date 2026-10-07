import os

with open('tools/kskill_data.py', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('"E006": "DMPD",', '"E006": "DMPD", "H020": "CBB", "H021": "NMK", "H022": "MGC", "H023": "MGK", "H024": "DTC",')

with open('tools/kskill_data.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
