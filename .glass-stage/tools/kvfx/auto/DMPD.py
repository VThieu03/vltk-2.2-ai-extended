# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/DMPD.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Nhiếp Hồn Nguyệt Ảnh': {'main': 'DMPD_nhiephonwave1_1.mdx', 'area': ['DMPD_nhiephonwave2_1.mdx'], 'target': 'DMPD_nhiephontarget.mdx', 'target_ground': True, 'from': 'JxA'},
    'Tiểu Lý Phi Đao': {'main': 'DMPD_phidao1.mdx', 'from': 'Jsy'},
    'Tôi Độc Thuật': {'aura': 'DMTT_toidocaura.mdx', 'from': 'passive dispatcher (JcZ)'},
    'Vô Ảnh Xuyên': {'main': 'DMPD_voanhxuyen.mdx', 'area': ['DMPD_voanhxuyen_11.mdx', 'DMPD_voanhxuyen_2.mdx'], 'from': 'JFp'},
    'Ảnh Tung Trận': {'main': 'DMPD_anhtungtranaura.mdx', 'area': ['DMPD_anhtungtran.mdx'], 'from': 'eLp'},
}
