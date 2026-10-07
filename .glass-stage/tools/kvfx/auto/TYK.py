# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TYK.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Băng Tâm Tiên Tử': {'main': 'TYK_bangtamtientu2.mdx', 'area': ['TYK_bangtamtientu1.mdx'], 'from': 'edc'},
    'Phi Tự Phiêu Hoa': {'main': 'TYK_phituphieuhoaeffect.mdx', 'from': 'eHA,eHS'},
    'Phong Quyển Tàn Tuyết': {'main': 'TYK_phongquyen.mdx', 'from': 'eQJ'},
    'Thủy Ánh Mạn Tú': {'main': 'TYK_thuyanh1.mdx', 'area': ['TYK_thuyanhmantu.mdx', 'TYK_thuyanheffect2.mdx'], 'target': 'TYK_phituphieuhoaeffect.mdx', 'target_ground': True, 'from': 'Jsw'},
    'Tuyết Ảnh': {'aura': 'TYK_tuyetanh.mdx', 'from': 'passive dispatcher (JcZ)'},
}
