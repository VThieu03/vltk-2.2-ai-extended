# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TLD.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'A La Hán Thần Công': {'aura': 'TLD_lahantran.mdx', 'from': 'passive dispatcher (JcZ)'},
    'Phục Ma Đao Pháp': {'main': 'TLD_phucmadp.mdx', 'from': 'eQs'},
    'Quy Thiền Đao Pháp': {'main': 'TLD_tamgioihoasen.mdx', 'area': ['TLD_votuongtram.mdx', 'TLD_tamgioidao.mdx'], 'target': 'TLD_thientructarget.mdx', 'from': 'eQr'},
    'Thiên Trúc Tuyệt Đao': {'main': 'TLD_votuongtram.mdx', 'area': ['TLD_thientrucdao.mdx'], 'target': 'TLD_thientructarget.mdx', 'from': 'JKw'},
    'Đại Thừa Như Lai Chú': {'main': 'TLD_daithua.mdx', 'area': ['TLD_votuongtram.mdx'], 'from': 'e_Y,e_u'},
}
