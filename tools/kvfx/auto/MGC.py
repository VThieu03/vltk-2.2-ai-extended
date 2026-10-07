# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/MGC.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Hồn Phách Phi Dương': {'main': 'MGC_honphach.mdx', 'target': 'MGC_xichtarget.mdx', 'from': 'eg5,egX'},
    'Khai Thiên Thức': {'main': 'MGC_khaithienthuc.mdx', 'from': 'e6L'},
    'Khu Hổ Thức': {'main': 'MGC_khuhothuc.mdx', 'target': 'MGC_khuhothuctarget.mdx', 'from': 'eqc'},
    'Khốn Hổ Vân Tiếu': {'main': 'MGC_khonhovantieueffect.mdx', 'area': ['MGC_khaithienthuc.mdx'], 'target': 'MGC_phachdiatarget.mdx', 'target_ground': True, 'from': 'e6i'},
    'Kim Qua Thiết Mã': {'main': 'MGC_kimquathietma.mdx', 'from': 'eSq'},
    'Long Thôn Thức': {'main': 'MGC_longthontarget.mdx', 'from': 'etU'},
    'Phách Địa Thế': {'main': 'MGC_phachdia.mdx', 'area': ['MGC_dongdat.mdx'], 'from': 'eZX,eZA'},
}
