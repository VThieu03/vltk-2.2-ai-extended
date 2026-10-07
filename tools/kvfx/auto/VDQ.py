# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/VDQ.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Bác Cập Nhị Phục': {'main': 'VDQ_baccapnhiphuc.mdx', 'from': 'J4l'},
    'Cửu Cung Bát Quái': {'main': 'VDQ_cuucung1.mdx', 'area': ['VDQ_cuucung2.mdx', 'VDQ_thaicuc.mdx'], 'cast': 'VDQ_thiendiacaster.mdx', 'cast_ground': True, 'from': 'JDp'},
    'Thiên Địa Vô Cực': {'main': 'VDQ_thaicuc.mdx', 'area': ['VDQ_thiendia.mdx'], 'cast': 'VDQ_thiendiacaster.mdx', 'target': 'VDQ_thiendiatarget.mdx', 'cast_ground': True, 'from': 'JCU'},
    'Vạn Kiếm Quy Tông': {'main': 'VDQ_vongakiem.mdx', 'target': 'VDQ_thiendiatarget.mdx', 'from': 'J9x'},
}
