// ---- cao thu xuat hien ngau nhien (names from the author's Thien Kiem)

// ==========================================
// Hàm: zzVL_IsCreep
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_unit (unit)
// Trả về dữ liệu kiểu: boolean
function zzVL_IsCreep takes unit vl_unit returns boolean
    local integer vl_t=GetUnitTypeId(vl_unit)
    return GetWidgetLife(vl_unit)>.405 and (vl_t=='n001' or vl_t=='n004' or vl_t=='n006' or vl_t=='n007' or vl_t=='n009' or vl_t=='n00A' or vl_t=='n00B' or vl_t=='n00D' or vl_t=='n00E')
endfunction

// ==========================================
// Hàm: zzVL_BossSpawn
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_BossSpawn takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local integer vl_n=0
    local integer vl_min=R2I(TimerGetElapsed(zzVL_clock)/60.)
    local integer vl_k
    local integer vl_bid
    call zzVL_Log("boss xuat hien")
    set zzVL_logMsg="|cffff4040TUYỆT ĐẠI CAO THỦ|r xuất hiện ở khu quái!"
    call ExecuteFunc("zzVL_BannerMsg")
    if zzVL_boss!=null and GetWidgetLife(zzVL_boss)>.405 then
        call DestroyGroup(vl_g)
        set vl_g=null
        return
    endif
    call GroupEnumUnitsOfPlayer(vl_g,Player(12),null)
    loop
        set vl_unit=FirstOfGroup(vl_g)
        exitwhen vl_unit==null
        call GroupRemoveUnit(vl_g,vl_unit)
        if zzVL_IsCreep(vl_unit) then
            set vl_n=vl_n+1
            if GetRandomInt(1,vl_n)==1 then
                set vl_pick=vl_unit
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    if vl_pick==null then
        return
    endif
    set vl_k=GetRandomInt(1,5)
    if vl_k==1 then
        set vl_bid='H00Z' // Kim
    elseif vl_k==2 then
        set vl_bid='E000' // Mộc
    elseif vl_k==3 then
        set vl_bid='H021' // Thủy
    elseif vl_k==4 then
        set vl_bid='H00A' // Hỏa
    else
        set vl_bid='E001' // Thổ
    endif
    set zzVL_boss=CreateUnit(Player(12),vl_bid,GetUnitX(vl_pick),GetUnitY(vl_pick),GetRandomReal(0,360))
    call SetUnitPosition(zzVL_boss,GetUnitX(vl_pick)-350.,GetUnitY(vl_pick)+250.)
    call BlzSetUnitName(zzVL_boss,"|cffff8000"+zzVL_bn[vl_k]+"|r")
    call BlzSetUnitMaxHP(zzVL_boss,80000+15000*vl_min)
    call SetWidgetLife(zzVL_boss,80000.+15000.*vl_min)
    call BlzSetUnitBaseDamage(zzVL_boss,600+80*vl_min,0)
    call BlzSetUnitArmor(zzVL_boss,50.+5.*vl_min)
    call SetUnitScale(zzVL_boss,5.0,5.0,5.0)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_boss),GetUnitY(zzVL_boss)))
    call zzVL_All("|cffffcc00Chú ý|r: Tuyệt đại cao thủ |cffff8000"+zzVL_bn[vl_k]+"|r tái xuất giang hồ! Hạ được: |cffffcc002 Thủy tinh|r, 1000 ngân lượng, 25 công trạng.")
    call PingMinimapEx(GetUnitX(zzVL_boss),GetUnitY(zzVL_boss),5.,255,128,0,true)
    set vl_pick=null
endfunction

// ==========================================
// Hàm: zzVL_BossKilled
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Tham số:
//   - vl_pk (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_BossKilled takes integer vl_pk returns nothing
    local integer vl_i=0
    call zzVL_All(zzVL_Name(vl_pk)+" đã hạ tuyệt đại cao thủ "+GetUnitName(zzVL_boss)+"!")
    call AdjustPlayerStateBJ(1000,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
    loop
        exitwhen vl_i>9
        if vl_i!=vl_pk and IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
            call AdjustPlayerStateBJ(300,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
        endif
        set vl_i=vl_i+1
    endloop
    call CreateItem('I00W',GetUnitX(zzVL_boss),GetUnitY(zzVL_boss))
    call CreateItem('I00W',GetUnitX(zzVL_boss),GetUnitY(zzVL_boss))
    call zzVL_DropGear(5, 5, GetUnitX(zzVL_boss), GetUnitY(zzVL_boss))
    call zzVL_AddCT(vl_pk,25)
    set zzVL_boss=null
endfunction

// ==========================================
// Hàm: zzVL_AddUD
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_AddUD takes integer vl_playerId,integer vl_n returns nothing
    if Oo then
        return
    endif
    if IsPlayerAlly(Player(vl_playerId),Player(0)) then
        set ro[$B]=ro[$B]+vl_n
    else
        set ro[$C]=ro[$C]+vl_n
    endif
    call MultiboardSetItemValueBJ(eo,3,$C,I2S(ro[$B]))
    call MultiboardSetItemValueBJ(eo,3,$D,I2S(ro[$C]))
    call ConditionalTriggerExecute(IE)
    call ConditionalTriggerExecute(AE)
endfunction

// ==========================================
// Hàm: zzVL_SpawnMC
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_SpawnMC takes nothing returns nothing
    local group vl_g=CreateGroup()
    local unit vl_unit
    local unit vl_pick=null
    local integer vl_n=0
    call zzVL_Log("minh chu xuat hien")
    call GroupEnumUnitsOfPlayer(vl_g,Player(12),null)
    loop
        set vl_unit=FirstOfGroup(vl_g)
        exitwhen vl_unit==null
        call GroupRemoveUnit(vl_g,vl_unit)
        if zzVL_IsCreep(vl_unit) then
            set vl_n=vl_n+1
            if GetRandomInt(1,vl_n)==1 then
                set vl_pick=vl_unit
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    if vl_pick==null then
        return
    endif
    set zzVL_mc=CreateUnit(Player(12),'n008',GetUnitX(vl_pick),GetUnitY(vl_pick),GetRandomReal(0,360))
    call BlzSetUnitName(zzVL_mc,"|cffff0000Võ Lâm Minh Chủ|r")
    call BlzSetUnitMaxHP(zzVL_mc,200000)
    call SetWidgetLife(zzVL_mc,200000.)
    call BlzSetUnitBaseDamage(zzVL_mc,700,0)
    call BlzSetUnitArmor(zzVL_mc,60.)
    call SetUnitScale(zzVL_mc,2.2,2.2,2.2)
    call SetUnitVertexColor(zzVL_mc,255,60,60,255)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(zzVL_mc),GetUnitY(zzVL_mc)))
    call PingMinimapEx(GetUnitX(zzVL_mc),GetUnitY(zzVL_mc),8.,255,0,0,true)
    call zzVL_All("|cffff0000VÕ LÂM MINH CHỦ|r đã xuất hiện! Phe nào hạ được nhận |cffffcc00+10 uy danh|r, mỗi người 1000 ngân lượng.")
    set vl_pick=null
endfunction

// ==========================================
// Hàm: zzVL_McKilled
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_pk (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_McKilled takes integer vl_pk returns nothing
    local integer vl_i=0
    call zzVL_All(zzVL_Name(vl_pk)+" đã hạ |cffff0000Võ Lâm Minh Chủ|r! Phe "+zzVL_Team(vl_pk)+" nhận +10 uy danh.")
    loop
        exitwhen vl_i>9
        if IsPlayerAlly(Player(vl_i),Player(vl_pk)) then
            call AdjustPlayerStateBJ(1000,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
        endif
        set vl_i=vl_i+1
    endloop
    call zzVL_DropGear(5, 8, GetUnitX(zzVL_mc), GetUnitY(zzVL_mc))
    call zzVL_AddCT(vl_pk,30)
    set zzVL_mc=null
    call zzVL_AddUD(vl_pk,10)
endfunction
// ---- su kien: tuyet dai cao thu moi 7 phut (7', 14', 21'...), Vo Lam Minh Chu moi 18 phut (neu con song thi bo qua);
// moi tinh nang co tu dau tran, tran ket thuc theo moc uy danh nhu ban goc

// ==========================================
// Hàm: zzVL_CountUnits
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Trả về dữ liệu kiểu: integer
function zzVL_CountUnits takes nothing returns integer
    local group vl_g=CreateGroup()
    local integer vl_n
    call GroupEnumUnitsInRect(vl_g,bj_mapInitialPlayableArea,null)
    set vl_n=CountUnitsInGroup(vl_g)
    call DestroyGroup(vl_g)
    set vl_g=null
    return vl_n
endfunction

// ==========================================
// Hàm: zzVL_EventTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_EventTick takes nothing returns nothing
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    if ModuloInteger(R2I(TimerGetElapsed(zzVL_clock)),60)==0 then
        call zzVL_Log("-- phut "+I2S(vl_m)+", don vi: "+I2S(zzVL_CountUnits()))
    endif
    if vl_m>=zzVL_nextBoss then
        set zzVL_nextBoss=zzVL_nextBoss+7
        call zzVL_BossSpawn()
    endif
    if vl_m>=zzVL_nextMc then
        set zzVL_nextMc=zzVL_nextMc+18
        if zzVL_mc==null or GetWidgetLife(zzVL_mc)<.405 then
            call zzVL_SpawnMC()
        endif
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnEventChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnEventChat takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local integer vl_m=R2I(TimerGetElapsed(zzVL_clock)/60.)
    call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,15.,"|cffffcc00Phút "+I2S(vl_m)+"|r - uy danh: Tống "+I2S(ro[$B])+" - Kim "+I2S(ro[$C])+" (mốc thắng "+I2S(Do)+")|nTuyệt đại cao thủ kế tiếp: phút "+I2S(zzVL_nextBoss)+"|nVõ Lâm Minh Chủ kế tiếp: phút "+I2S(zzVL_nextMc))
endfunction
// ---- quai: ca phe cung huong, khong can danh phat cuoi. Nguoi ha van nhan tien thuong goc; dong doi
// nhan vang ~ tien thuong (3+2*cap), dong doi o xa (ngoai 1200, game khong chia kinh nghiem) nhan 10+8*cap kinh nghiem

// ==========================================
// Hàm: zzVL_ShareCreep
// Chức năng dự kiến: Quản lý bãi quái farm và thời gian hồi sinh.
// Tham số:
//   - vl_pk (integer)
//   - vl_d (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_ShareCreep takes integer vl_pk,unit vl_d returns nothing
    local integer vl_i=0
    local integer vl_lv=GetUnitLevel(vl_d)
    local integer vl_g=3+2*vl_lv
    local integer vl_x=10+8*vl_lv
    local unit vl_hero
    loop
        exitwhen vl_i>9
        set vl_hero=Jx[vl_i+1]
        if vl_i!=vl_pk and vl_hero!=null and IsPlayerAlly(Player(vl_i),Player(vl_pk)) and GetPlayerSlotState(Player(vl_i))==PLAYER_SLOT_STATE_PLAYING then
            call AdjustPlayerStateBJ(vl_g,Player(vl_i),PLAYER_STATE_RESOURCE_GOLD)
            if GetWidgetLife(vl_hero)>.405 and not IsUnitInRange(vl_hero,vl_d,1200.) then
                call AddHeroXP(vl_hero,vl_x,true)
            endif
        endif
        set vl_i=vl_i+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_CheckWin
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_CheckWin takes nothing returns nothing
    local integer vl_i=0
    local player vl_wp=null
    if zzVL_winKills>0 then
        if zzVL_teamK[0]>=zzVL_winKills then
            set vl_wp=Player(0)
        elseif zzVL_teamK[1]>=zzVL_winKills then
            set vl_wp=Player(5)
        endif
    endif
    if vl_wp!=null then
        loop
            exitwhen vl_i>9
            if IsPlayerAlly(Player(vl_i),vl_wp) then
                call CustomVictoryBJ(Player(vl_i),true,true)
            else
                call CustomDefeatBJ(Player(vl_i),"Thất bại!")
            endif
            set vl_i=vl_i+1
        endloop
    endif
endfunction

// ==========================================
// Hàm: zzVL_OnWinChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnWinChat takes nothing returns nothing
    local string vl_string=GetEventPlayerChatString()
    local string vl_args=SubString(vl_string,5,StringLength(vl_string))
    set zzVL_winKills=S2I(vl_args)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10.,"|cffffcc00Mốc mạng chiến thắng thay đổi thành: |r"+I2S(zzVL_winKills)+" mạng.")
endfunction

// ==========================================
// Hàm: zzVL_OnDeath
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnDeath takes nothing returns nothing
    local unit vl_d=GetDyingUnit()
    local unit vl_k=GetKillingUnit()
    local integer vl_pk
    local integer vl_pd
    local integer vl_i=0
    if vl_d!=null then
        call zzVL_CampDeath(vl_d)
    endif
    if vl_d!=null and IsUnitType(vl_d,UNIT_TYPE_HERO) and GetPlayerId(GetOwningPlayer(vl_d))<10 and vl_d==Jx[GetPlayerId(GetOwningPlayer(vl_d))+1] then
        set zzVL_deaths[GetPlayerId(GetOwningPlayer(vl_d))]=zzVL_deaths[GetPlayerId(GetOwningPlayer(vl_d))]+1
        if vl_k!=null and GetPlayerId(GetOwningPlayer(vl_k))<10 and IsUnitEnemy(vl_d,GetOwningPlayer(vl_k)) then
            set zzVL_kills[GetPlayerId(GetOwningPlayer(vl_k))]=zzVL_kills[GetPlayerId(GetOwningPlayer(vl_k))]+1
            if IsPlayerAlly(GetOwningPlayer(vl_k),Player(0)) then
                set zzVL_teamK[0]=zzVL_teamK[0]+1
            else
                set zzVL_teamK[1]=zzVL_teamK[1]+1
            endif
            call zzVL_CheckWin()
        endif
        call zzVL_Log("tuong chet p"+I2S(GetPlayerId(GetOwningPlayer(vl_d))))
    endif
    if vl_k!=null and vl_d!=null then
        set vl_pk=GetPlayerId(GetOwningPlayer(vl_k))
        set vl_pd=GetPlayerId(GetOwningPlayer(vl_d))
        if vl_pd<10 and vl_d==Jx[vl_pd+1] and vl_pk>=10 then
            // bi the luc ngoai dao danh bai
            call zzVL_AddCT(vl_pd,-3)
            call zzVL_Msg(vl_pd,"|cffff8000Bị thế lực ngoại đạo đánh bại, công trạng giảm 3.|r")
        elseif vl_pk<10 and Jx[vl_pk+1]!=null and IsUnitEnemy(vl_d,Player(vl_pk)) then
            if vl_pd>=10 and not IsUnitType(vl_d,UNIT_TYPE_HERO) and not IsUnitType(vl_d,UNIT_TYPE_STRUCTURE) then
                call zzVL_ShareCreep(vl_pk,vl_d)
                call zzVL_QProgress(vl_pk,1)
                if GetUnitLevel(vl_d)>=10 then
                    call zzVL_QProgress(vl_pk,2)
                endif
            endif
            if vl_d==zzVL_mc then
                call zzVL_McKilled(vl_pk)
            elseif vl_d==zzVL_boss then
                call zzVL_BossKilled(vl_pk)
            elseif vl_pd<10 and vl_d==Jx[vl_pd+1] then
                if not zzVL_fb then
                    set zzVL_fb=true
                    call zzVL_All("|cffff4000Nhất đao đoạt mạng!|r "+zzVL_Name(vl_pk)+" hạ "+GetPlayerName(Player(vl_pd))+" đầu tiên, nhận thêm 500 ngân lượng và 10 công trạng.")
                    call AdjustPlayerStateBJ(500,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
                    call zzVL_AddCT(vl_pk,10)
                endif
                call zzVL_AddCT(vl_pk,10)
                call zzVL_QProgress(vl_pk,3)
                call AdjustPlayerStateBJ(300,Player(vl_pk),PLAYER_STATE_RESOURCE_GOLD)
                loop
                    exitwhen vl_i>9
                    if vl_i!=vl_pk and IsPlayerAlly(Player(vl_i),Player(vl_pk)) and Jx[vl_i+1]!=null and GetWidgetLife(Jx[vl_i+1])>.405 and IsUnitInRange(Jx[vl_i+1],vl_d,1200.) then
                        call zzVL_AddCT(vl_i,4)
                        call zzVL_QProgress(vl_i,3)
                    endif
                    set vl_i=vl_i+1
                endloop
            elseif vl_pd>=10 and GetUnitState(vl_d,UNIT_STATE_MAX_LIFE)>=5000. then
                call zzVL_AddCT(vl_pk,15)
            endif
        endif
    endif
    set vl_d=null
    set vl_k=null
endfunction
// ---- a cloak picked up by another player's hero goes back to its owner

// ==========================================
// Hàm: zzVL_OnItem
// Chức năng dự kiến: Xử lý trang bị, nhặt đồ và tính điểm tài phú.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnItem takes nothing returns nothing
    local item vl_item=GetManipulatedItem()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    call RemoveSavedInteger(zzVL_ht,GetHandleId(vl_item),67)
    if LoadInteger(zzVL_ht,GetItemTypeId(vl_item),1)>0 and GetItemUserData(vl_item)!=vl_playerId+1 then
        call UnitRemoveItem(GetTriggerUnit(),vl_item)
        call zzVL_Msg(vl_playerId,"Phi phong này đã có chủ.")
    endif
    set vl_item=null
endfunction
