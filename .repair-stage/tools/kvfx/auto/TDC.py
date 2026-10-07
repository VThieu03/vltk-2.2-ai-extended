# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TDC.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Bài Sơn Đảo Hải': {'main': 'TDC_wave1.mdx', 'area': ['TDC_baisondh.mdx'], 'cast': 'TDC_caster2.mdx', 'from': 'J4Q'},
    'Bạch Nhật Sâm Thần': {'main': 'TDC_bachnhat1.mdx', 'area': ['TDC_bachnhat2.mdx', 'TDC_wave1.mdx'], 'cast': 'TDC_caster.mdx', 'cast_ground': True, 'from': 'J4S'},
    'Dương Ca Thiên Quân': {'main': 'TDC_duongca.mdx', 'area': ['TDC_wave1.mdx'], 'target': 'TDC_target.mdx', 'from': 'JD6'},
    'Hàn Tụ Huyệt': {'main': 'TDC_tuhuyet.mdx', 'cast': 'TDC_caster2.mdx', 'target': 'TDC_target.mdx', 'from': 'eA5'},
    'Sinh Tử Phù': {'main': 'TDC_sinhtuphueffect.mdx', 'from': 'ei0,ei3'},
    'Thiên Tàm Cửu Biến': {'main': 'TDC_thientamcb.mdx', 'from': 'J02,J0i'},
}
