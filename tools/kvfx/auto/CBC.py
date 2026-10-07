# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/CBC.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Hàng Long Hữu Hối': {'main': 'CBC_hanglong.mdx', 'from': 'e6B'},
    'Long Du Thiên Địa': {'main': 'CBC_dulong.mdx', 'area': ['CBC_flame.mdx'], 'cast': 'CBC_casting.mdx', 'cast_ground': True, 'from': 'Jk1'},
    'Phi Long Tại Thiên': {'main': 'CBC_hanglong.mdx', 'area': ['VolcanoMissile.mdx'], 'cast': 'CBC_casting.mdx', 'cast_ground': True, 'from': 'eHR'},
    'Túy Điệp Cuồng Vũ': {'aura': 'CBC_hoatbatluuthu.mdx', 'from': 'passive dispatcher (JcZ)'},
}
