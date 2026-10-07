# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/NDC.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Hóa Cốt Miên Chưởng': {'main': 'NDC_hoacotmienchuong2.mdx', 'area': ['NDC_hoacotbuff.mdx'], 'from': 'JoK,Jof'},
    'Thiên Canh Địa Sát': {'main': 'NDC_thiencanhds.mdx', 'from': 'JCL,JCl'},
    'U Minh Khô Lâu': {'main': 'NDC_uminhkholautarget.mdx', 'from': 'JsN,Jsb'},
    'U Minh Quỷ Trảo': {'main': 'NDC_quytrao.mdx', 'area': ['NDC_quytrao3.mdx', 'NDC_uminheffect.mdx'], 'cast': 'NDC_amphongcast.mdx', 'from': 'JF3'},
    'Âm Phong Thực Cốt': {'main': 'NDC_amphong1.mdx', 'area': ['NDC_amphong3.mdx', 'NDC_amphong2.mdx'], 'cast': 'NDC_amphongcast.mdx', 'from': 'J4W'},
    'Độc Sa Chưởng': {'main': 'NDC_effect1.mdx', 'from': 'JDO'},
}
