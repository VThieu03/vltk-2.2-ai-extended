# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TVC.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Hành Vân Quyết': {'main': 'TVC_Hanhvan.mdx', 'from': 'eA8'},
    'Hóa Kinh Quyết': {'aura': 'TVC_hoakinhquyet.mdx', 'from': 'passive dispatcher (JcZ)'},
    'Kim Chung Tráo': {'main': 'TVC_kimchungtrao.mdx', 'from': 'eSh'},
    'Thừa Long Quyết': {'main': 'TVC_thualongquyet.mdx', 'cast': 'TVC_thualongcast.mdx', 'target': 'TVC_thualongquyettarget.mdx', 'cast_ground': True, 'from': 'J3D'},
    'Trảm Long Quyết': {'main': 'TVC_tramlongeffect2.mdx', 'target': 'TVC_thualongquyettarget.mdx', 'from': 'eLJ'},
    'Tung Hoành Tứ Hải': {'main': 'TVC_tranphaieffect1.mdx', 'area': ['TVC_tranphaieffect2.mdx', 'TVC_tranphaichuy.mdx'], 'from': 'JeC'},
    'Đoạn Hồn Thích': {'main': 'TVT_doanhonthich.mdx', 'from': 'eOv'},
}
