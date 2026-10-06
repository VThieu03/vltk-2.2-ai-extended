import os, re, glob

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
JASS_DIR = os.path.join(ROOT, 'tools', 'jass')

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # 1. zzVL_AiGear in gameplay_02_farm.j
    if 'function zzVL_AiGear' in content:
        content = re.sub(
            r'(function zzVL_AiGear takes unit vl_hero,item vl_n returns nothing\n.*?)(loop\n\s*exitwhen vl_i>5\n\s*set vl_item=)UnitItemInSlot\(vl_hero,vl_i\)',
            r'\1local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_hero))\n    \2zzVL_equipItem[vl_playerId*10+vl_i]',
            content, flags=re.DOTALL
        )
        content = re.sub(
            r'(function zzVL_AiGear.*?)exitwhen vl_i>5',
            r'\1exitwhen vl_i>9',
            content, flags=re.DOTALL
        )

    # 2. zzVL_AutoGear in gameplay_02_farm.j
    if 'function zzVL_AutoGear' in content:
        content = re.sub(
            r'(function zzVL_AutoGear.*?)exitwhen vl_i>5\n\s*set vl_item=UnitItemInSlot\(vl_hero,vl_i\)',
            r'\1exitwhen vl_i>9\n        set vl_item=zzVL_equipItem[vl_playerId*10+vl_i]',
            content, flags=re.DOTALL
        )
        
    # 3. zzVL_AffixSum in gameplay_02_farm.j
    if 'function zzVL_AffixSum' in content:
        content = re.sub(
            r'(function zzVL_AffixSum.*?)exitwhen vl_i>5\n\s*if UnitItemInSlot\(vl_hero,vl_i\)!=null then\n\s*set vl_id=GetHandleId\(UnitItemInSlot\(vl_hero,vl_i\)\)',
            r'\1exitwhen vl_i>9\n        if zzVL_equipItem[vl_playerId*10+vl_i]!=null then\n            set vl_id=GetHandleId(zzVL_equipItem[vl_playerId*10+vl_i])',
            content, flags=re.DOTALL
        )
        content = re.sub(
            r'(function zzVL_AffixSum.*?set vl_i=0\n\s*loop\n\s*)exitwhen vl_i>5\n\s*if UnitItemInSlot\(vl_hero,vl_i\)!=null then\n\s*set vl_k=LoadInteger\(zzVL_ht,GetItemTypeId\(UnitItemInSlot\(vl_hero,vl_i\)\),0\)/10',
            r'\1exitwhen vl_i>9\n        if zzVL_equipItem[vl_playerId*10+vl_i]!=null then\n            set vl_k=LoadInteger(zzVL_ht,GetItemTypeId(zzVL_equipItem[vl_playerId*10+vl_i]),0)/10',
            content, flags=re.DOTALL
        )
        # replace other UnitItemInSlot(vl_hero,vl_i) in zzVL_AffixSum with zzVL_equipItem[vl_playerId*10+vl_i]
        def replacer(m):
            if 'function zzVL_AffixSum' in m.group(0):
                return m.group(0).replace('UnitItemInSlot(vl_hero,vl_i)', 'zzVL_equipItem[vl_playerId*10+vl_i]')
            return m.group(0)
        
        # It's safer to just regex replace the specific ones.
        content = content.replace('UnitItemInSlot(vl_hero,vl_i)', 'zzVL_equipItem[vl_playerId*10+vl_i]')

    # 4. zzVL_OnDamage in gameplay_04_combat.j
    if 'function zzVL_OnDamage' in content:
        content = content.replace('UnitItemInSlot(vl_hero,vl_i)', 'zzVL_equipItem[vl_playerId*10+vl_i]')
        content = re.sub(
            r'(function zzVL_OnDamage.*?exitwhen vl_i>)5',
            r'\g<1>9',
            content, flags=re.DOTALL
        )

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {filepath}')

for f in glob.glob(os.path.join(JASS_DIR, '*.j')):
    process_file(f)
