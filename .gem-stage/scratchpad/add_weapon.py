import os

with open('tools/kskill.py', 'r', encoding='utf-8') as f:
    content = f.read()

target = '"TVC": "VK_chuyTVC", "DMPD": "VK_pdaov1"}'
new = '"TVC": "VK_chuyTVC", "DMPD": "VK_pdaov1", "CBB": "VK_bongTL", "NMK": "VK_kiemVDK", "MGC": "VK_chuyTVC", "MGK": "VK_kiemVDK", "DTC": "VK_phitieuv1"}'
content = content.replace(target, new)

with open('tools/kskill.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
