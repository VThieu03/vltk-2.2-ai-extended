// ---- Nhóm DROP: rơi trang bị kiểu KVCT (10 ô + vũ khí theo loại phái của người đánh)
// Phụ thuộc: gameplay_09_equip.j (zzEQ_*), zzVL_RollAffix (gameplay_02_farm.j). File này phải nối SAU gameplay_09_equip.j.
// Mức rơi: 0 = quái thường, 1 = Tinh Anh, 2 = Thủ Lĩnh, 3 = Boss.

// ==========================================
// BẢNG TỈ LỆ (sửa số ở đây; mỗi hàm trả về một hằng số)
// ==========================================

// Tỉ lệ (%) một con quái THƯỜNG rơi 1 món trang bị.
constant function zzDR_ChanceNormal takes nothing returns integer
return 3
endfunction

// Tỉ lệ (%) mỗi lần quay của Tinh Anh / Thủ Lĩnh.
constant function zzDR_ChanceElite takes nothing returns integer
return 40
endfunction

// Số lần quay: Tinh Anh 3, Thủ Lĩnh 6 (giống hệ cũ); Boss rơi chắc chắn 5 món.
constant function zzDR_RollsElite takes nothing returns integer
return 3
endfunction
constant function zzDR_RollsLeader takes nothing returns integer
return 6
endfunction
constant function zzDR_DropsBoss takes nothing returns integer
return 5
endfunction

// Tỉ lệ (%) món rơi là VŨ KHÍ (phần còn lại chia đều cho 9 ô: nón, áo, lưng, tay, giày, liên, nhẫn, bội, hộ phù).
constant function zzDR_ChanceWeapon takes nothing returns integer
return 20
endfunction

// Bậc cường hóa khởi đầu (ngẫu nhiên min..max). Quái thường luôn bậc 0.
constant function zzDR_TierMinElite takes nothing returns integer
return 0
endfunction
constant function zzDR_TierMaxElite takes nothing returns integer
return 2
endfunction
constant function zzDR_TierMinLeader takes nothing returns integer
return 1
endfunction
constant function zzDR_TierMaxLeader takes nothing returns integer
return 4
endfunction
constant function zzDR_TierMinBoss takes nothing returns integer
return 3
endfunction
constant function zzDR_TierMaxBoss takes nothing returns integer
return 6
endfunction

// Số dòng chỉ số TỐI THIỂU (hệ cũ zzVL_RollAffix cho tối đa 2 dòng, nên 0..2). Quay lại tối đa 40 lần.
constant function zzDR_MinAffElite takes nothing returns integer
return 1
endfunction
constant function zzDR_MinAffLeader takes nothing returns integer
return 1
endfunction
constant function zzDR_MinAffBoss takes nothing returns integer
return 2
endfunction

// ==========================================
// Mã vật phẩm
// ==========================================

// Loại vũ khí 0..10 -> mã ITV0..ITVA (kiếm, đao, thương, chùy, triền thủ, côn, tụ tiễn, phi đao, trường đao, đại đao, phi tiêu).
function zzDR_WeaponCode takes integer vl_t returns integer
    if vl_t==0 then
        return 'ITV0'
    elseif vl_t==1 then
        return 'ITV1'
    elseif vl_t==2 then
        return 'ITV2'
    elseif vl_t==3 then
        return 'ITV3'
    elseif vl_t==4 then
        return 'ITV4'
    elseif vl_t==5 then
        return 'ITV5'
    elseif vl_t==6 then
        return 'ITV6'
    elseif vl_t==7 then
        return 'ITV7'
    elseif vl_t==8 then
        return 'ITV8'
    elseif vl_t==9 then
        return 'ITV9'
    endif
    return 'ITVA'
endfunction

// Chỉ số 0..8 -> ô không phải vũ khí: nón, áo, lưng, tay, giày, liên, nhẫn, bội, hộ phù.
function zzDR_SlotCode takes integer vl_i returns integer
    if vl_i==0 then
        return 'ITS1'
    elseif vl_i==1 then
        return 'ITS2'
    elseif vl_i==2 then
        return 'ITS3'
    elseif vl_i==3 then
        return 'ITS4'
    elseif vl_i==4 then
        return 'ITS5'
    elseif vl_i==5 then
        return 'ITS7'
    elseif vl_i==6 then
        return 'ITS8'
    elseif vl_i==7 then
        return 'ITS9'
    endif
    return 'ITSA'
endfunction

// ==========================================
// Loại vũ khí người chơi dùng được (thử từng loại bằng zzEQ_CanUse, nhớ theo mã tướng). -1 = không tìm ra.
function zzDR_HeroWeapon takes unit vl_hero returns integer
    local integer vl_pid
    local integer vl_t=0
    local integer vl_found=-1
    local item vl_it
    local boolean vl_ok
    if vl_hero==null then
        return -1
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_pid<10 and LoadInteger(zzVL_ht,6100+vl_pid,0)==GetUnitTypeId(vl_hero) then
        return LoadInteger(zzVL_ht,6100+vl_pid,1)-1
    endif
    loop
        exitwhen vl_t>10 or vl_found>=0
        set vl_it=CreateItem(zzDR_WeaponCode(vl_t),0.,0.)
        if vl_it!=null then
            set vl_ok=zzEQ_CanUse(vl_hero,vl_it)
            call RemoveItem(vl_it)
            set vl_it=null
            if vl_ok then
                set vl_found=vl_t
            endif
        endif
        set vl_t=vl_t+1
    endloop
    if vl_pid<10 then
        call SaveInteger(zzVL_ht,6100+vl_pid,0,GetUnitTypeId(vl_hero))
        call SaveInteger(zzVL_ht,6100+vl_pid,1,vl_found+1)
    endif
    return vl_found
endfunction

// Tướng của người đánh (kể cả khi sát thủ là lính / triệu hồi): tướng chính Jx của chủ sở hữu.
function zzDR_KillerHero takes unit vl_killer returns unit
    local integer vl_pid
    if vl_killer==null then
        return null
    endif
    set vl_pid=GetPlayerId(GetOwningPlayer(vl_killer))
    if vl_pid<10 and Jx[vl_pid+1]!=null then
        return Jx[vl_pid+1]
    endif
    return null
endfunction

// Chọn mã vật phẩm rơi: vũ khí đúng loại phái (nếu tìm ra) hoặc một ô ngẫu nhiên.
function zzDR_PickCode takes unit vl_hero returns integer
    local integer vl_w=-1
    if GetRandomInt(1,100)<=zzDR_ChanceWeapon() then
        set vl_w=zzDR_HeroWeapon(vl_hero)
    endif
    if vl_w>=0 then
        return zzDR_WeaponCode(vl_w)
    endif
    return zzDR_SlotCode(GetRandomInt(0,8))
endfunction

// Đếm số dòng chỉ số ngẫu nhiên đã lăn trên món đồ (khóa 31..52 của hashtable).
function zzDR_CountAff takes item vl_it returns integer
    local integer vl_id=GetHandleId(vl_it)
    local integer vl_k=1
    local integer vl_n=0
    loop
        exitwhen vl_k>22
        if LoadInteger(zzVL_ht,vl_id,30+vl_k)!=0 then
            set vl_n=vl_n+1
        endif
        set vl_k=vl_k+1
    endloop
    return vl_n
endfunction

// Quay chỉ số bằng zzVL_RollAffix (hệ cũ); nếu thiếu số dòng tối thiểu thì xóa và quay lại.
function zzDR_RollAffixMin takes item vl_it,integer vl_min returns nothing
    local integer vl_id=GetHandleId(vl_it)
    local string vl_name=GetItemName(vl_it)
    local string vl_desc=BlzGetItemDescription(vl_it)
    local string vl_tip=BlzGetItemExtendedTooltip(vl_it)
    local integer vl_tries=0
    local integer vl_k
    call zzVL_RollAffix(vl_it)
    loop
        exitwhen vl_min<=0 or vl_tries>=40 or zzDR_CountAff(vl_it)>=vl_min
        call BlzSetItemName(vl_it,vl_name)
        call BlzSetItemDescription(vl_it,vl_desc)
        call BlzSetItemExtendedTooltip(vl_it,vl_tip)
        set vl_k=1
        loop
            exitwhen vl_k>22
            call RemoveSavedInteger(zzVL_ht,vl_id,30+vl_k)
            set vl_k=vl_k+1
        endloop
        call RemoveSavedInteger(zzVL_ht,vl_id,75)
        call RemoveSavedInteger(zzVL_ht,vl_id,29)
        call zzVL_RollAffix(vl_it)
        set vl_tries=vl_tries+1
    endloop
endfunction

// Tạo một món tại (x,y) theo mức rơi: bậc cường hóa khởi đầu + chỉ số tối thiểu.
function zzDR_MakeOne takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_code=zzDR_PickCode(vl_hero)
    local item vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
    local integer vl_tier=0
    local integer vl_min=0
    if vl_it==null then
        return
    endif
    if vl_kind==1 then
        set vl_tier=GetRandomInt(zzDR_TierMinElite(),zzDR_TierMaxElite())
        set vl_min=zzDR_MinAffElite()
    elseif vl_kind==2 then
        set vl_tier=GetRandomInt(zzDR_TierMinLeader(),zzDR_TierMaxLeader())
        set vl_min=zzDR_MinAffLeader()
    elseif vl_kind>=3 then
        set vl_tier=GetRandomInt(zzDR_TierMinBoss(),zzDR_TierMaxBoss())
        set vl_min=zzDR_MinAffBoss()
    endif
    if vl_tier>0 then
        call zzEQ_SetTier(vl_it,vl_tier)
    endif
    call zzDR_RollAffixMin(vl_it,vl_min)
    // khóa 73: đồ rơi từ quái, cho phép tự mặc / tự bán (giống hệ cũ).
    call SaveInteger(zzVL_ht,GetHandleId(vl_it),73,1)
    set vl_it=null
endfunction

// ==========================================
// RƠI THỦY TINH THEO LỊCH (tools/config.py mục 11): mỗi tướng được rơi dần để đúng mốc phút có bấy nhiêu món +10.
// Số thủy tinh cần cho một món +10 = 10*base + 45*step (base / step của nút +, hashtable 0 / 340, 341).


function zzDR_Crystal takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    call zzGL_Drop(vl_kind,vl_hero)
endfunction

// ==========================================
// Hàm công khai 1: rơi theo mức (0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss) tại (x,y), vũ khí hợp phái của vl_hero.
function zzDR_DropKind takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_n=0
    local integer vl_chance=100
    if vl_kind<=0 then
        set vl_n=1
        set vl_chance=zzDR_ChanceNormal()
    elseif vl_kind==1 then
        set vl_n=zzDR_RollsElite()
        set vl_chance=zzDR_ChanceElite()
    elseif vl_kind==2 then
        set vl_n=zzDR_RollsLeader()
        set vl_chance=zzDR_ChanceElite()
    else
        set vl_n=zzDR_DropsBoss()
    endif
    call zzDR_Crystal(vl_kind,vl_x,vl_y,vl_hero)
    call zzGD_Drop(vl_kind,vl_x,vl_y,vl_hero)
    loop
        exitwhen vl_n<=0
        if GetRandomInt(1,100)<=vl_chance then
            call zzDR_MakeOne(vl_kind,vl_x,vl_y,vl_hero)
        endif
        set vl_n=vl_n-1
    endloop
endfunction

// Hàm công khai 2: gọi từ sự kiện chết. Đọc mức từ hashtable (khóa 10 của đơn vị chết, phải gọi TRƯỚC FlushChildHashtable)
// hoặc Boss khi vl_dead==zzVL_boss.
function zzDR_Drop takes unit vl_dead,unit vl_killer returns nothing
    local integer vl_kind=LoadInteger(zzVL_ht,GetHandleId(vl_dead),10)
    if vl_dead==zzVL_boss then
        set vl_kind=3
    endif
    call zzDR_DropKind(vl_kind,GetUnitX(vl_dead),GetUnitY(vl_dead),zzDR_KillerHero(vl_killer))
endfunction
