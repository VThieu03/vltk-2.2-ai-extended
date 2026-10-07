# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/VDK.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Lưu Tinh Cản Nguyệt': {'main': 'VDK_nhankiemcast.mdx', 'from': 'Jxf'},
    'Lưỡng Nghi Kiếm Pháp': {'main': 'VDK_luongnghikiem.mdx', 'from': 'eNu'},
    'Nhân Kiếm Hợp Nhất': {'main': 'VDK_nhankiemsword.mdx', 'cast': 'VDK_nhankiemcast.mdx', 'target': 'VDK_nhankiemtarget.mdx', 'cast_ground': True, 'target_ground': True, 'from': 'eZK'},
    'Tam Hoàn Sáo Nguyệt': {'main': 'VDK_tamhoanthaonguyet.mdx', 'from': 'ei5'},
    'Thất Tinh Quyết': {'aura': 'VDK_thattinhaura.mdx', 'from': 'passive dispatcher (JcZ)'},
    'Vô Thượng Kiếm Đạo': {'main': 'VDK_vothuongkiem.mdx', 'area': ['VDK_vocuckiemy.mdx'], 'cast': 'VDK_vothuongcastereffect.mdx', 'target': 'VDK_vothuongtarget.mdx', 'cast_ground': True, 'target_ground': True, 'from': 'J9A'},
}
