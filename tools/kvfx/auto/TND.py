# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TND.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Hỏa Liên Phần Hoa': {'main': 'TND_hoalienhole.mdx', 'area': ['TND_hoalieneffect.mdx'], 'from': 'eg4,egD'},
    'Nhiếp Hồn Loạn Tâm': {'main': 'TND_nhiephoneffect.mdx', 'target': 'TND_nhiephontarget.mdx', 'from': 'eZp,eZV'},
    'Thiên Ngoại Lưu Tinh': {'main': 'TND_thienngoaistone.mdx', 'area': ['TND_thienngoaifire.mdx'], 'cast': 'TND_thienngoailuutinhcaster.mdx', 'cast_ground': True, 'from': 'J0M'},
    'Thôi Sơn Điền Hải': {'main': 'TND_thoisonfire.mdx', 'from': 'Jsf,Js9'},
    'Tật Hỏa Liêu Nguyên': {'main': 'TND_tathoafire.mdx', 'area': ['TND_bladerain.mdx', 'TND_tathoafire2.mdx'], 'cast': 'TND_tathoacast.mdx', 'target': 'TND_tathoatarget.mdx', 'cast_ground': True, 'from': 'JhU'},
    'Đạn Chỉ Liệt Diệm': {'main': 'TND_danchifire.mdx', 'from': 'JDX'},
}
