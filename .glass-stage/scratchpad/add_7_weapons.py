import os

with open('tools/kskill.py', 'r', encoding='utf-8') as f:
    content = f.read()

target = '"DTC": "VK_phitieuv1"}'
new = '"DTC": "VK_phitieuv1", "CMC": "VK_phitieuv1", "CMK": "VK_kiemVDK", "HSQ": "VK_chuongcaiv1", "HSK": "VK_kiemVDK", "TDC": "VK_chuongcaiv1", "TDK": "VK_kiemVDK", "TYK": "VK_kiemVDK"}'
content = content.replace(target, new)

with open('tools/kskill.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
