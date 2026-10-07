import re

p1 = r'src\map\war3mapMisc.txt'
t = open(p1, 'r', encoding='utf-8').read()
t = re.sub(r'StrHitPointBonus=.*', 'StrHitPointBonus=250.0', t)
t = re.sub(r'IntManaBonus=.*', 'IntManaBonus=150.0', t)
t = re.sub(r'StrRegenBonus=.*', 'StrRegenBonus=2.5', t)
t = re.sub(r'IntRegenBonus=.*', 'IntRegenBonus=1.5', t)
t = re.sub(r'AgiDefenseBonus=.*', 'AgiDefenseBonus=0.5', t)
t = re.sub(r'AgiAttackSpeedBonus=.*', 'AgiAttackSpeedBonus=0.03', t)
open(p1, 'w', encoding='utf-8').write(t)
p2 = r'src\map\war3mapSkin.txt'
t = open(p2, 'r', encoding='utf-8').read()
t = t.replace('Trí tuệ', 'Nội công')
if 'AGILITY_TOOLTIP=' not in t:
    t += '\nAGILITY_TOOLTIP=Mỗi điểm Thân pháp tăng 0.5 Giáp và 3% Tốc độ đánh, đồng thời tăng 0.2% sát thương cơ bản.'
    t += '\nSTRENGTH_TOOLTIP=Mỗi điểm Sức mạnh tăng 250 Sinh lực và 2.5 Sinh lực hồi phục/giây, đồng thời tăng 0.2% sát thương cơ bản.'
    t += '\nINTELLECT_TOOLTIP=Mỗi điểm Nội công tăng 150 Nội lực và 1.5 Nội lực hồi phục/giây, đồng thời tăng 0.2% sát thương cơ bản.'
open(p2, 'w', encoding='utf-8').write(t)
