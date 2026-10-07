import os

with open('tools/describe.py', 'r', encoding='utf-8') as f:
    content = f.read()

target = 'setv(b"utub", tub)'

inject = """
                if "Tiến cử:" in tub or "Tiến Cử:" in tub:
                    tub = tub.replace("Võ Đang Kiếm, Côn Luân Kiếm", "Võ Đang Kiếm, Côn Luân Kiếm, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Thúy Yên Song Đao")
                    tub = tub.replace("Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền", "Thiên Vương Đao, Thiên Vương Thương, Thiên Vương Chùy, Thiếu Lâm Quyền, Cái Bang Bổng, Minh Giáo Chùy")
                    tub = tub.replace("Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu", "Ngũ Độc Đao, Võ Đang Kiếm, Thúy Yên Song Đao, Đường Môn Phi Tiêu, Nga My Kiếm, Minh Giáo Kiếm, Cổ Mộ Kiếm, Cổ Mộ Châm, Hoa Sơn Kiếm, Tiêu Dao Kiếm, Đoàn Thị Chỉ")
                setv(b"utub", tub)"""

content = content.replace(target, inject)

with open('tools/describe.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
