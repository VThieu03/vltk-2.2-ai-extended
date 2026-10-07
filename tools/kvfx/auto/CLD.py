# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/CLD.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'Cuồng Phong Sậu Điện': {'main': 'CLD_cuongphong.mdx', 'target': 'CLD_effecttarget.mdx', 'from': 'JDF'},
    'Cửu Thiên Canh Phong': {'main': 'CLD_canhphong2.mdx', 'area': ['CLD_canhphong.mdx', 'CLD_hoiphongphatlieu.mdx'], 'cast': 'CLD_ngaotuyetcast.mdx', 'cast_ground': True, 'from': 'JDR'},
    'Ngạo Tuyết Tiếu Phong': {'main': 'CLD_ngaotuyet.mdx', 'area': ['CLD_hoiphongphatlieu.mdx'], 'cast': 'CLD_ngaotuyetcast.mdx', 'target': 'CLD_ngaotuyettarget.mdx', 'cast_ground': True, 'from': 'Jxc'},
    'Nhất Khí Tam Thanh': {'main': 'NMC_phongsuongtoaianh.mdx', 'from': 'eZ4'},
}
