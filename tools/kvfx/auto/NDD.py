# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/NDD.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Bách Độc Xuyên Tâm': {'main': 'NDD_bachdocxuyentam.mdx', 'from': 'eLA,eL6'},
    'Chu Cáp Thanh Minh': {'main': 'NDD_chucapeffect.mdx', 'area': ['NDD_chucapcoc.mdx'], 'from': 'elr,elN'},
    'Huyết Đao Độc Sát': {'main': 'NDD_huyetdao.mdx', 'from': 'JoX'},
    'Huyền Âm Trảm': {'main': 'NDD_huyenamdao.mdx', 'target': 'NDD_huyenamtarget.mdx', 'from': 'JoR'},
    'U Hồn Phệ Ảnh': {'main': 'NDD_uhonpheanh2.mdx', 'area': ['NDD_uhonpheanh.mdx', 'NDD_uhonpheanh3.mdx'], 'cast': 'NDD_uhoncast.mdx', 'target': 'NDD_uhonpheanhtarget.mdx', 'cast_ground': True, 'target_ground': True, 'from': 'Jsq'},
    'U Minh Khô Lâu': {'main': 'NDC_uminhkholautarget.mdx', 'from': 'JsN,Jsb'},
    'Vô Hình Cổ': {'main': 'NDD_sauvohinh.mdx', 'from': 'J9n,J9B'},
}
