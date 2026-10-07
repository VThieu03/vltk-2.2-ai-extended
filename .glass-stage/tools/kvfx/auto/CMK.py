# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/CMK.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Chung Nam Vãn Chiếu': {'main': 'CMK_chungnam.mdx', 'target': 'CMK_target1.mdx', 'target_ground': True, 'from': 'JDD,JDk'},
    'Cô Nguyệt Bồi Hồi': {'main': 'CMK_conguyet.mdx', 'area': ['CMK_conguyet2.mdx', 'CMK_chungnam.mdx'], 'target': 'CMK_target1.mdx', 'target_ground': True, 'from': 'JFb'},
    'Cô Thân Chi Ảnh': {'main': 'CMK_chungnam.mdx', 'area': ['CMK_phamonghanh3.mdx', 'CMK_cothanca.mdx'], 'cast': 'CMK_castercothan.mdx', 'target': 'CMK_target1.mdx', 'target_ground': True, 'from': 'Jhe'},
    'Hồng Tụ Triền': {'main': 'CMK_hongtutrien.mdx', 'from': 'egT,egW'},
    'Thu Nhạn Bàng Hoàng': {'main': 'CMK_thunhan.mdx', 'area': ['CMK_chungnam.mdx'], 'target': 'CMK_target1.mdx', 'target_ground': True, 'from': 'JhM'},
}
