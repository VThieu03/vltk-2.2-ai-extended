// ---- tu thi trien: skills with a cooldown <= 15 s (table from tools\skills.py: hero type key 10.. = skill,
// skill key 2 = order id, key 3 = 0 none / 1 unit / 2 point) cast themselves on the hero's current target
// while a player's hero fights; never while the player is moving the hero; ultimates stay manual. -auto toggles.

// ==========================================
// Hàm: zzVL_OnAttack
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAttack takes nothing returns nothing
    local unit vl_a=GetAttacker()
    local integer vl_playerId=GetPlayerId(GetOwningPlayer(vl_a))
    if vl_playerId<10 and vl_a==Jx[vl_playerId+1] then
        set zzVL_tgt[vl_playerId]=GetTriggerUnit()
        set zzVL_tgtT[vl_playerId]=TimerGetElapsed(zzVL_clock)
    endif
    set vl_a=null
endfunction

// ==========================================
// Hàm: zzVL_AutoTick
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AutoTick takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_k
    local integer vl_ab
    local integer vl_lv
    local integer vl_ord
    local integer vl_kind
    local integer vl_cur
    local boolean vl_ok
    local unit vl_hero
    local unit vl_t
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        set vl_t=zzVL_tgt[vl_playerId]
        if vl_hero!=null and vl_t!=null and not zzVL_autoOff[vl_playerId] and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_USER and GetWidgetLife(vl_hero)>.405 then
            set vl_cur=GetUnitCurrentOrder(vl_hero)
            if GetWidgetLife(vl_t)>.405 and IsUnitEnemy(vl_t,Player(vl_playerId)) and IsUnitVisible(vl_t,Player(vl_playerId)) and IsUnitInRange(vl_hero,vl_t,900.) and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]<3. and (vl_cur==0 or vl_cur==851983 or vl_cur==851971) then
                set vl_ok=false
                set vl_k=10
                loop
                    set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),vl_k)
                    exitwhen vl_ab==0 or vl_ok
                    set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
                    if vl_lv>0 and BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)<=.01 and BlzGetAbilityCooldown(vl_ab,vl_lv-1)<=15. and GetUnitState(vl_hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
                        set vl_ord=LoadInteger(zzVL_ht,vl_ab,2)
                        set vl_kind=LoadInteger(zzVL_ht,vl_ab,3)
                        // 4: a KVCT toggle (kskill.j zzKS_Toggle), cast only while it is off
                        if vl_kind==4 and HaveSavedHandle(zzVL_ht,GetHandleId(vl_hero),vl_ab) then
                            set vl_ok=false
                        elseif vl_kind==1 then
                            set vl_ok=IssueTargetOrderById(vl_hero,vl_ord,vl_t)
                        elseif vl_kind==2 then
                            set vl_ok=IssuePointOrderById(vl_hero,vl_ord,GetUnitX(vl_t),GetUnitY(vl_t))
                        else
                            set vl_ok=IssueImmediateOrderById(vl_hero,vl_ord)
                        endif
                    endif
                    set vl_k=vl_k+1
                endloop
                if vl_ok then
                    set zzVL_reatk[vl_playerId]=true
                elseif zzVL_reatk[vl_playerId] and vl_cur==0 then
                    set zzVL_reatk[vl_playerId]=false
                    call IssueTargetOrderById(vl_hero,851983,vl_t)
                endif
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_OnAutoChat
// Chức năng dự kiến: Xử lý logic hệ thống.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_OnAutoChat takes nothing returns nothing
    local integer vl_playerId=GetPlayerId(GetTriggerPlayer())
    set zzVL_autoOff[vl_playerId]=not zzVL_autoOff[vl_playerId]
    if zzVL_autoOff[vl_playerId] then
        call zzVL_Msg(vl_playerId,"Tự thi triển: |cffff4040TẮT|r. Gõ -auto để bật lại.")
    else
        call zzVL_Msg(vl_playerId,"Tự thi triển: |cff00ff00BẬT|r - chiêu hồi chiêu dưới 15 giây tự ra khi giao chiến, tuyệt chiêu vẫn bấm tay.")
    endif
endfunction
// ---- AI may thong minh hon (runs next to the author's AI, which keeps lanes, retreat at 35% and items):
// focus the weakest enemy hero in range, cast every quick skill, ultimate when 2+ enemy heroes are close or
// the target is below 50%, and go for the tuyet dai cao thu / Minh Chu while healthy.

// ==========================================
// Hàm: zzVL_TryCast
// Chức năng dự kiến: Xử lý logic hệ thống.
// Tham số:
//   - vl_hero (unit)
//   - vl_t (unit)
//   - vl_key (integer)
// Trả về dữ liệu kiểu: boolean
function zzVL_TryCast takes unit vl_hero,unit vl_t,integer vl_key returns boolean
    local integer vl_ab
    local integer vl_lv
    local integer vl_kind
    local integer vl_ord
    loop
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_hero),vl_key)
        exitwhen vl_ab==0
        set vl_lv=GetUnitAbilityLevel(vl_hero,vl_ab)
        if vl_lv>0 and BlzGetUnitAbilityCooldownRemaining(vl_hero,vl_ab)<=.01 and GetUnitState(vl_hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(vl_ab,vl_lv-1) then
            set vl_ord=LoadInteger(zzVL_ht,vl_ab,2)
            set vl_kind=LoadInteger(zzVL_ht,vl_ab,3)
            if vl_kind==1 and IssueTargetOrderById(vl_hero,vl_ord,vl_t) then
                return true
            elseif vl_kind==2 and IssuePointOrderById(vl_hero,vl_ord,GetUnitX(vl_t),GetUnitY(vl_t)) then
                return true
            elseif vl_kind==0 and IssueImmediateOrderById(vl_hero,vl_ord) then
                return true
            elseif vl_kind==4 and not HaveSavedHandle(zzVL_ht,GetHandleId(vl_hero),vl_ab) and IssueImmediateOrderById(vl_hero,vl_ord) then
                return true
            endif
        endif
        set vl_key=vl_key+1
    endloop
    return false
endfunction

// ==========================================
// Hàm: zzVL_AiFight
// Chức năng dự kiến: Trí tuệ nhân tạo (AI) điều khiển bot.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AiFight takes nothing returns nothing
    local integer vl_playerId=0
    local integer vl_i
    local integer vl_n
    local integer vl_cur
    local real vl_best
    local real vl_pct
    local unit vl_hero
    local unit vl_e
    local unit vl_t
    local boolean vl_ok
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_COMPUTER and GetWidgetLife(vl_hero)>.405 and GetWidgetLife(vl_hero)>GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.35 then
            set vl_cur=GetUnitCurrentOrder(vl_hero)
            set vl_t=null
            set vl_best=2.
            set vl_n=0
            set vl_i=0
            loop
                exitwhen vl_i>9
                set vl_e=Jx[vl_i+1]
                if vl_e!=null and IsPlayerEnemy(Player(vl_i),Player(vl_playerId)) and GetWidgetLife(vl_e)>.405 and IsUnitVisible(vl_e,Player(vl_playerId)) and IsUnitInRange(vl_hero,vl_e,800.) then
                    set vl_n=vl_n+1
                    set vl_pct=GetWidgetLife(vl_e)/GetUnitState(vl_e,UNIT_STATE_MAX_LIFE)
                    if vl_pct<vl_best then
                        set vl_best=vl_pct
                        set vl_t=vl_e
                    endif
                endif
                set vl_i=vl_i+1
            endloop
            if vl_t==null and zzVL_tgt[vl_playerId]!=null and GetWidgetLife(zzVL_tgt[vl_playerId])>.405 and IsUnitInRange(vl_hero,zzVL_tgt[vl_playerId],800.) and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]<3. then
                set vl_t=zzVL_tgt[vl_playerId]
            endif
            if vl_t!=null and (vl_cur==0 or vl_cur==851983 or vl_cur==851971) then
                set vl_ok=false
                if IsUnitType(vl_t,UNIT_TYPE_HERO) and (vl_n>=2 or vl_best<.5) then
                    set vl_ok=zzVL_TryCast(vl_hero,vl_t,20)
                endif
                if not vl_ok then
                    set vl_ok=zzVL_TpAi(vl_hero,vl_t)
                endif
                if not vl_ok then
                    set vl_ok=zzVL_TryCast(vl_hero,vl_t,10)
                endif
                if not vl_ok and IsUnitType(vl_t,UNIT_TYPE_HERO) and (vl_t!=zzVL_aiTgt[vl_playerId] or vl_cur==0) then
                    set zzVL_aiTgt[vl_playerId]=vl_t
                    call IssueTargetOrderById(vl_hero,851983,vl_t)
                endif
            endif
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
    set vl_e=null
    set vl_t=null
endfunction

// ==========================================
// Hàm: zzVL_AiToBoss
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Tham số:
//   - vl_b (unit)
// Không trả về giá trị (thực thi hành động).
function zzVL_AiToBoss takes unit vl_b returns nothing
    local integer vl_playerId=0
    local unit vl_hero
    loop
        exitwhen vl_playerId>9
        set vl_hero=Jx[vl_playerId+1]
        if vl_hero!=null and GetPlayerController(Player(vl_playerId))==MAP_CONTROL_COMPUTER and GetWidgetLife(vl_hero)>GetUnitState(vl_hero,UNIT_STATE_MAX_LIFE)*.6 and TimerGetElapsed(zzVL_clock)-zzVL_tgtT[vl_playerId]>5. then
            call IssuePointOrderById(vl_hero,851983,GetUnitX(vl_b),GetUnitY(vl_b))
        endif
        set vl_playerId=vl_playerId+1
    endloop
    set vl_hero=null
endfunction

// ==========================================
// Hàm: zzVL_AiBossTick
// Chức năng dự kiến: Sự kiện sinh ra Boss / Cao thủ.
// Không yêu cầu tham số đầu vào.
// Không trả về giá trị (thực thi hành động).
function zzVL_AiBossTick takes nothing returns nothing
    if zzVL_mc!=null and GetWidgetLife(zzVL_mc)>.405 then
        call zzVL_AiToBoss(zzVL_mc)
    elseif zzVL_boss!=null and GetWidgetLife(zzVL_boss)>.405 then
        call zzVL_AiToBoss(zzVL_boss)
    endif
endfunction
