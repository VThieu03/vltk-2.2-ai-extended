import os

with open('tools/kskill_data.py', 'r', encoding='utf-8') as f:
    content = f.read()

target1 = '"H024": "DTC"'
new1 = '"H024": "DTC", "H025": "CMC", "H026": "CMK", "H027": "HSQ", "H028": "HSK", "H029": "TDC", "H02A": "TDK", "H02B": "TYK"'
content = content.replace(target1, new1)

target2 = '"H024": ("Hero_doanthichi", "Đoàn Thị Chỉ")'
new2 = '"H024": ("Hero_doanthichi", "Đoàn Thị Chỉ"), "H025": ("Hero_comocham", "Cổ Mộ Châm"), "H026": ("Hero_comokiem", "Cổ Mộ Kiếm"), "H027": ("Hero_hoasonkhi", "Hoa Sơn Khí"), "H028": ("Hero_hoasonkiem", "Hoa Sơn Kiếm"), "H029": ("Hero_tieudaochuong", "Tiêu Dao Chưởng"), "H02A": ("Hero_tieudaokiem", "Tiêu Dao Kiếm"), "H02B": ("Hero_thuyyenkiem", "Thúy Yên Kiếm")'
content = content.replace(target2, new2)

with open('tools/kskill_data.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
