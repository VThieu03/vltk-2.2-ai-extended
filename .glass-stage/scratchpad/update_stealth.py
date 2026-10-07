import os

with open('tools/kskill.j', 'r', encoding='utf-8') as f:
    content = f.read()

# Add stealth support for self buff (kind 6) if status is 5
target_line = '''call zzKS_Buff(vl_p,vl_ab,1.)
call DestroyEffect(AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,250),vl_h,"origin"))'''
new_line = '''call zzKS_Buff(vl_p,vl_ab,1.)
if LoadInteger(zzVL_ht,vl_ab,242)==5 then
call UnitAddAbility(vl_h,'AOwk')
call SetUnitAbilityLevel(vl_h,'AOwk',1)
call IssueImmediateOrder(vl_h,"windwalk")
endif
call DestroyEffect(AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,250),vl_h,"origin"))'''

content = content.replace(target_line, new_line)

with open('tools/kskill.j', 'w', encoding='utf-8') as f:
    f.write(content)

with open('tools/kskill.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Add OVR for VDK and TYD
ovr_add = '''
    "A0KG": {"kind": 3},
    "A0KH": {"kind": 4, "hits": 40},
    "A0XM": {"kind": 4, "status": 4, "sdur": 24, "hits": 4},
    "A0CE": {"kind": 6, "status": 5},
'''

content = content.replace('OVR = {', 'OVR = {' + ovr_add)

with open('tools/kskill.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
