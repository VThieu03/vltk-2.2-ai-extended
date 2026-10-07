import os

with open('tools/gameplay.py', 'r', encoding='utf-8') as f:
    content = f.read()

target1 = '["E000", "H01L", "E003", "H01M", "E006", "H022", "H023"]'
new1 = '["E000", "H01L", "E003", "H01M", "E006", "H022", "H023", "H029", "H02A"]'
content = content.replace(target1, new1)

target2 = '["E005", "E002", "H021", "H024"]'
new2 = '["E005", "E002", "H021", "H024", "H027", "H028", "H02B"]'
content = content.replace(target2, new2)

target3 = '["E001", "H01S", "H009", "H01U", "H00U"]'
new3 = '["E001", "H01S", "H009", "H01U", "H00U", "H025", "H026"]'
content = content.replace(target3, new3)

with open('tools/gameplay.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
