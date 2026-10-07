// ---- Gem data API. Item metadata is populated by tools/kvgem.py (keys 110..114).
function zzGM_Type takes integer vl_itemType returns integer
    return LoadInteger(zzVL_ht,vl_itemType,110)
endfunction

function zzGM_Tier takes integer vl_itemType returns integer
    return LoadInteger(zzVL_ht,vl_itemType,111)
endfunction

function zzGM_Code takes integer vl_type,integer vl_tier returns integer
    if vl_type<1 or vl_type>6 or vl_tier<1 or vl_tier>9 then
        return 0
    endif
    return 73*16777216+71*65536+(48+vl_type)*256+48+vl_tier
endfunction

function zzGM_Stat takes integer vl_type,integer vl_tier returns integer
    return LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),113)
endfunction
