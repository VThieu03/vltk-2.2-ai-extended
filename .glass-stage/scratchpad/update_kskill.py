import os

with open('tools/kskill.py', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('min(8, s["hits"])', 's["hits"]')

with open('tools/kskill.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
