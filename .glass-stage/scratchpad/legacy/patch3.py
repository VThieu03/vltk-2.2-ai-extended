import sys
import re

with open('tools/describe.py', 'r', encoding='utf-8') as f:
    content = f.read()

injection = \"\"\"
              if st:
                  slot, tier = st
                  h = sum(ord(c) for c in iid)
                  if tier == 5:
                      if slot == 3:
                          prefix = 'Tần Lăng'
                      else:
                          prefixes = ['Phá Quân', 'Sương Tinh', 'U Lung', 'Sát Quỷ', 'Vô Ma', 'Băng Hư', 'Đồng Cừu', 'Ma Hoàng', 'Lăng Nhạc', 'Vô Vọng']
                          prefix = prefixes[h % len(prefixes)]
                  else:
                      if tier == 4 and slot == 3:
                          prefix = 'An Bang'
                      else:
                          prefix = {1: 'Động Sát', 2: 'Nhu Tình', 3: 'Hiệp Cốt', 4: 'Định Quốc'}.get(tier, '')
                  color_prefix = ''
                  color_suffix = ''
                  m = re.match(r'(\\\\|c[0-9a-fA-F]{8})(.*?)(\\\\|r)', name)
                  if m:
                      color_prefix = m.group(1)
                      color_suffix = m.group(3)
                  plus = ''
                  pm = re.search(r'(\\\\+\\\\s*\\\\d+)', name)
                  if pm:
                      plus = ' ' + pm.group(1)
                  orig_plain = plain(name).lower()
                  suffix = ''
                  if slot == 3:
                      w_words = ['kiếm', 'song đao', 'đao', 'mâu', 'kích', 'côn', 'bổng', 'trượng', 'phiến', 'phủ']
                      for w in w_words:
                          if w in orig_plain:
                              suffix = w.title()
                              break
                      if not suffix: suffix = 'Khí'
                  elif slot == 1:
                      w_words = ['quán', 'khôi', 'mão', 'mũ', 'cân']
                      for w in w_words:
                          if w in orig_plain:
                              suffix = w.title()
                              break
                      if not suffix: suffix = ['Quán', 'Khôi', 'Mão'][h % 3]
                  elif slot == 2:
                      w_words = ['giáp', 'y', 'bào', "thường", 'sam']
                      for w in w_words:
                          if w in orig_plain:
                              suffix = w.title()
                              break
                      if not suffix: suffix = ['Giáp', 'Y', 'Bào', "Thường", 'Sam'][h % 5]
                  elif slot == 4:
                      w_words = ['hài', 'ngoa', 'lý', 'giày']
                      for w in w_words:
                          if w in orig_plain:
                              suffix = w.title()
                              break
                      if not suffix: suffix = ['Hài', 'Ngoa', 'Lý'][h % 3]
                  new_name = prefix + ' ' + suffix + plus
                  name = color_prefix + new_name + color_suffix
                  setv(b'unam', name)
                  setv(b'utip', name)
\"\"\"
injection = injection.replace(\"\\\\\\\\\", \"\\\\\")
idx = content.find('              if st is None and iid in FIX:')
if idx != -1:
    content = content[:idx] + injection.strip('\\n') + '\\n' + content[idx:]
    with open('tools/describe.py', 'w', encoding='utf-8') as f:
        f.write(content)
    print('Patched successfully')
