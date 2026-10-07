// ---- Gem data API. Item metadata is populated by tools/kvgem.py (keys 110..114).
function zzGM_Type takes integer vl_itemType returns integer
    local integer vl_kind=LoadInteger(zzVL_ht,vl_itemType,110)
    // Nhận diện trực tiếp mã IG<loại><bậc> để luồng khảm không phụ thuộc
    // việc bảng hashtable đã được nạp trước khi người chơi bấm bảo thạch.
    if vl_kind==0 and vl_itemType/65536==18759 then
        set vl_kind=ModuloInteger(vl_itemType/256,256)-48
        if vl_kind<1 or vl_kind>6 or ModuloInteger(vl_itemType,256)<49 or ModuloInteger(vl_itemType,256)>57 then
            return 0
        endif
    endif
    if vl_kind==0 and vl_itemType/16777216==75 then
        set vl_kind=100+(ModuloInteger(vl_itemType/65536,256)-48)*10+ModuloInteger(vl_itemType/256,256)-48
        if vl_kind<101 or vl_kind>122 or ModuloInteger(vl_itemType,256)<49 or ModuloInteger(vl_itemType,256)>51 then
            return 0
        endif
    endif
    return vl_kind
endfunction

function zzGM_Tier takes integer vl_itemType returns integer
    local integer vl_tier=LoadInteger(zzVL_ht,vl_itemType,111)
    if vl_tier==0 and zzGM_Type(vl_itemType)>0 then
        set vl_tier=ModuloInteger(vl_itemType,256)-48
    endif
    return vl_tier
endfunction

function zzGM_Code takes integer vl_type,integer vl_tier returns integer
    if vl_type>=101 and vl_type<=122 and vl_tier>=1 and vl_tier<=3 then
        return 75*16777216+(48+(vl_type-100)/10)*65536+(48+ModuloInteger(vl_type-100,10))*256+48+vl_tier
    endif
    if vl_type<1 or vl_type>6 or vl_tier<1 or vl_tier>9 then
        return 0
    endif
    return 73*16777216+71*65536+(48+vl_type)*256+48+vl_tier
endfunction

function zzGM_Stat takes integer vl_type,integer vl_tier returns integer
    local integer vl_value=LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),113)
    local integer vl_scale=1
    if vl_value>0 then
        return vl_value
    endif
    if vl_tier<1 or vl_tier>9 then
        return 0
    endif
    if vl_tier==2 then
        set vl_scale=2
    elseif vl_tier==3 then
        set vl_scale=3
    elseif vl_tier==4 then
        set vl_scale=5
    elseif vl_tier==5 then
        set vl_scale=8
    elseif vl_tier==6 then
        set vl_scale=12
    elseif vl_tier==7 then
        set vl_scale=18
    elseif vl_tier==8 then
        set vl_scale=27
    elseif vl_tier==9 then
        set vl_scale=40
    endif
    if vl_type==4 then
        return 120*vl_scale
    endif
    return vl_scale
endfunction

function zzGM_StatCode takes integer vl_type,integer vl_tier returns integer
    local integer vl_stat=LoadInteger(zzVL_ht,zzGM_Code(vl_type,vl_tier),112)
    if vl_stat>0 then
        return vl_stat
    endif
    if vl_type==1 then
        return 3
    elseif vl_type==2 then
        return 4
    elseif vl_type==3 then
        return 5
    elseif vl_type==4 then
        return 7
    elseif vl_type==5 then
        return 6
    elseif vl_type==6 then
        return 16
    endif
    return 0
endfunction
