// ---- nhiem vu Su Gia Vo Lam (h01N, one per base): select him with the hero nearby to take a quest.
// 1 Tru Hai Giang Ho: kill creeps; 2 Diet Cuong Dich: kill creeps of level >= 10; 3 Tranh Hung: kill or
// assist on enemy heroes. Done at once: Thuy tinh + gold + cong trang; every 5th quest 2 more Thuy tinh.

// ==========================================
// Hàm: zzVL_QName
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_t (integer)
// Trả về dữ liệu kiểu: string
function zzVL_QName takes integer vl_t returns string
    if vl_t==1 then
        return "Trừ Hại Giang Hồ"
    elseif vl_t==2 then
        return "Diệt Cường Địch"
    endif
    return "Tranh Hùng"
endfunction

// ==========================================
// Hàm: zzVL_QGoal
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_t (integer)
//   - vl_n (integer)
// Trả về dữ liệu kiểu: string
function zzVL_QGoal takes integer vl_t,integer vl_n returns string
    if vl_t==1 then
        return "diệt "+I2S(vl_n)+" quái"
    elseif vl_t==2 then
        return "hạ "+I2S(vl_n)+" quái từ cấp 10 trở lên"
    endif
    return "hạ hoặc hỗ trợ hạ "+I2S(vl_n)+" tướng địch"
endfunction

// ==========================================
// Hàm: zzVL_QShow
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QShow takes integer vl_playerId returns nothing
    if zzVL_qType[vl_playerId]==0 then
        call zzVL_Msg(vl_playerId,"Chưa có nhiệm vụ. Đưa tướng tới gần |cffffcc00Sứ Giả Võ Lâm|r (cạnh căn cứ) rồi bấm chọn ông ấy để nhận. Đã hoàn thành: "+I2S(zzVL_qDone[vl_playerId]))
    else
        call zzVL_Msg(vl_playerId,"|cffffcc00Nhiệm vụ "+zzVL_QName(zzVL_qType[vl_playerId])+"|r: "+zzVL_QGoal(zzVL_qType[vl_playerId],zzVL_qNeed[vl_playerId])+" - "+I2S(zzVL_qHave[vl_playerId])+"/"+I2S(zzVL_qNeed[vl_playerId]))
    endif
endfunction

// ==========================================
// Hàm: zzVL_QGiveTT
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_n (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QGiveTT takes unit vl_hero,integer vl_n returns nothing
    if vl_hero!=null then
        call zzGL_Give(GetPlayerId(GetOwningPlayer(vl_hero)),vl_n)
    endif
endfunction

// ==========================================
// Hàm: zzVL_QProgress
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_playerId (integer)
//   - vl_t (integer)
// Không trả về giá trị (thực thi hành động).
function zzVL_QProgress takes integer vl_playerId,integer vl_t returns nothing
    local unit vl_hero=Jx[vl_playerId+1]
    local integer vl_g
    if zzVL_qType[vl_playerId]!=vl_t or vl_hero==null then
        set vl_hero=null
        return
    endif
    set zzVL_qHave[vl_playerId]=zzVL_qHave[vl_playerId]+1
    if zzVL_qHave[vl_playerId]<zzVL_qNeed[vl_playerId] then
        if vl_t!=1 or ModuloInteger(zzVL_qHave[vl_playerId],5)==0 then
            call DisplayTimedTextToPlayer(Player(vl_playerId),0,0,3.,"Nhiệm vụ "+zzVL_QName(vl_t)+": "+I2S(zzVL_qHave[vl_playerId])+"/"+I2S(zzVL_qNeed[vl_playerId]))
        endif
        set vl_hero=null
        return
    endif
    set zzVL_qDone[vl_playerId]=zzVL_qDone[vl_playerId]+1
    set zzVL_qType[vl_playerId]=0
    set vl_g=400+100*zzVL_qDone[vl_playerId]
    call AdjustPlayerStateBJ(vl_g,Player(vl_playerId),PLAYER_STATE_RESOURCE_GOLD)
    call zzVL_QGiveTT(vl_hero,1)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",vl_hero,"origin"))
    call zzVL_Msg(vl_playerId,"|cff00ff00Hoàn thành nhiệm vụ "+zzVL_QName(vl_t)+"!|r Nhận 1 Huyền tinh, "+I2S(vl_g)+" ngân lượng, 8 công trạng. Quay lại Sứ Giả Võ Lâm để nhận nhiệm vụ mới.")
    if ModuloInteger(zzVL_qDone[vl_playerId],5)==0 then
        call zzVL_QGiveTT(vl_hero,2)
        call zzVL_All(zzVL_Name(vl_playerId)+" đã hoàn thành "+I2S(zzVL_qDone[vl_playerId])+" nhiệm vụ của Sứ Giả Võ Lâm, nhận thêm 2 Huyền tinh.")
    endif
    call zzVL_AddCT(vl_playerId,8)
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_OnSelect
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnSelect takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    local unit vl_npc=GetTriggerUnit()
    local unit vl_hero
    local integer vl_t
    if GetUnitTypeId(vl_npc)!='h01N' or vl_playerId>9 then
        set vl_npc=null
        return
    endif
    set vl_hero=Jx[vl_playerId+1]
    if vl_hero==null or GetWidgetLife(vl_hero)<.405 or not IsUnitInRange(vl_hero,vl_npc,700.) then
        call zzVL_Msg(vl_playerId,"|cffffcc00Sứ Giả Võ Lâm|r: hãy đưa tướng tới gần ta để nhận nhiệm vụ.")
    elseif zzVL_qType[vl_playerId]!=0 then
        call zzVL_QShow(vl_playerId)
    else
        set vl_t=GetRandomInt(1,3)
        set zzVL_qType[vl_playerId]=vl_t
        set zzVL_qHave[vl_playerId]=0
        if vl_t==1 then
            set zzVL_qNeed[vl_playerId]=IMinBJ(15+2*zzVL_qDone[vl_playerId],30)
        elseif vl_t==2 then
            set zzVL_qNeed[vl_playerId]=5
        else
            set zzVL_qNeed[vl_playerId]=2
        endif
        call zzVL_Msg(vl_playerId,"|cffffcc00Sứ Giả Võ Lâm|r giao nhiệm vụ |cffffcc00"+zzVL_QName(vl_t)+"|r: "+zzVL_QGoal(vl_t,zzVL_qNeed[vl_playerId])+". Gõ -nv để xem tiến độ.")
    endif
    set vl_npc=null
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_OnQuestChat
// Chức năng dự kiến: Hệ thống nhiệm vụ (Sứ Giả Võ Lâm).
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnQuestChat takes nothing returns nothing
    call zzVL_QShow(GetPlayerId(GetTriggerPlayer()))
endfunction
