# TU SINH boi kvfx_extract.py (chay lai se ghi de file nay). Muon sua tay: dat muc cung ten chieu trong
# tools/kvfx/hand/TLB.py, bang tay thang bang nay. Muc: main / cast / target / area, 'from' = ham cast trong readable.j
VFX = {
    'A La Hán Thần Công': {'aura': 'TLD_lahantran.mdx', 'from': 'passive dispatcher (JcZ)'},
    'Phổ Độ Côn Pháp': {'main': 'TLB_targeteffect.mdx', 'from': 'eHN'},
    'Thất Tinh La Sát Côn': {'main': 'TLB_lasatcon11.mdx', 'area': ['TLB_lasatcon2.mdx'], 'target': 'TLB_targeteffect.mdx', 'from': 'JEQ'},
    'Túy Tiên Bát Côn': {'main': 'TLB_lasatcon11.mdx', 'area': ['TLB_lasatcon2.mdx'], 'target': 'TLB_targeteffect.mdx', 'from': 'JsU'},
    'Vi Đà Hiến Chử': {'main': 'TLB_vidaeffect.mdx', 'cast': 'TLB_vidacast.mdx', 'target': 'TLB_vidatarget.mdx', 'target_ground': True, 'from': 'J9P'},
}
