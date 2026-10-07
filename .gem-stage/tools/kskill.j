// ---- KVCT skill sets (Kiem Vo Chi Ton, Silva.Fox) rebuilt on VLTK: kskill.py makes the abilities and the table
// (hero type: 229 count, 200+i ability, 230+i unlock level; ability: 240 kind, 241 hits, 242 status, 243 chance,
// 244 status time, 246 buff time, 247/248 stats, 249 proc on attack, 250 effect model).
// Keys added when matching KVCT's code (kskill.py OVR): 244 / 236 status time in tenths of a second, 234 / 235 / 236
// second status (later waves), 257 radius / range, 258 time between hits (1/100 s), 259 most enemies per hit,
// 239 / 245 / 231 a passive's effects on the Q (0) W (1) E (2) or all (3) hits: fx bits / life steal % per rank,
// 232 mana per second per rank of a toggle, 225 / 224 status chance per rank, 228 no damage (dash), 223 seconds
// free of control after the cast, 222 buff seconds per rank, 215 missile from the target point, low life passive
// 221 / 220 / 219 / 218 / 217, 216 chance of a passive's buff on attacks (cooldown 220).
// 214 dash end casts the hero's Q W E, 212 / 211 periodic immunity of a passive, 209 / 208 a passive's extra
// waves on the Q W E and their chance. Kinds 13 ground field, 14 toggle, 15 curse, 16 splash at the target point,
// 17 random enemies around, 18 field around the hero, 19 stealth (199 its buff tenths), 20 charging toggle
// (198 / 197 % per charge). 207 / 206 / 205 fan of missiles, 204 low life freeze, 203 / 202 proc immunity and
// chance per rank, 201 no 2 s stun cap, 200 status tenths per rank, 196 dash range per rank, 195 self buff
// after the cast, 194 farthest point of a field; fx 65536: 30% +25% damage; fx 131072: 21% -15% life (not heroes);
// 183 the skill also runs the hero's Q (1) W (2) E (3): with its own cast, on a proc hit, or at low life
// (KVCT Khi Thon Van Ly + Luc Mach Than Kiem, Luc Kiem Te Phat, Am Huong So Anh);
// status 5 bong (x1.5 damage taken, key 81 of the unit); 189 low life threshold %, 218 its seconds free of
// control; kind 21 toggle firing the fan every key 258 / 100 s.
// Lag limits (06/10/2026): a skill with no 259 limit hits at most 12 enemies per hit; at most 4 hit effects per area hit;
// the dash ghost every 3rd step; a dash casts the hero's Q W E on its first 3 enemies only.
// Kinds: 1 strike, 2 cone, 3 dash, 4 nova, 5 lance, 6 self buff, 7 party buff, 8 cleanse, 0 passive.
// Skills open by hero level only (no skill points) and level up with it, rank 10 at level 200.
// the skill's main effect (key 250) played once at a point / on a unit; key 290 = size in percent (hand table "scale"), the
// global factor is key 291 of the hero type 0 (tools/config.py SKILL_VFX_SCALE_PERCENT)
function zzKS_Size takes effect vl_e,integer vl_ab returns nothing
    local integer vl_pct=LoadInteger(zzVL_ht,vl_ab,290)
    if vl_pct<=0 then
        set vl_pct=100
    endif
    set vl_pct=vl_pct*LoadInteger(zzVL_ht,0,291)/100
    if vl_pct!=100 then
        call BlzSetSpecialEffectScale(vl_e,vl_pct/100.)
    endif
endfunction
// a cast / target layer (model string given): size from key vl_k (292 cast, 293 target) x the global factor
function zzKS_Layer takes integer vl_ab,integer vl_k,string vl_m,unit vl_u,string vl_pt,boolean vl_ground returns nothing
    local effect vl_e
    local integer vl_pct=LoadInteger(zzVL_ht,vl_ab,vl_k)
    if vl_ground then
        set vl_e=AddSpecialEffect(vl_m,GetUnitX(vl_u),GetUnitY(vl_u))
    else
        set vl_e=AddSpecialEffectTarget(vl_m,vl_u,vl_pt)
    endif
    if vl_pct<=0 then
        set vl_pct=100
    endif
    set vl_pct=vl_pct*LoadInteger(zzVL_ht,0,291)/100
    if vl_pct!=100 then
        call BlzSetSpecialEffectScale(vl_e,vl_pct/100.)
    endif
    call DestroyEffect(vl_e)
    set vl_e=null
endfunction
function zzKS_Pop takes integer vl_ab,real vl_x,real vl_y returns nothing
    local effect vl_e=AddSpecialEffect(LoadStr(zzVL_ht,vl_ab,250),vl_x,vl_y)
    call zzKS_Size(vl_e,vl_ab)
    call DestroyEffect(vl_e)
    set vl_e=null
endfunction
function zzKS_PopT takes integer vl_ab,unit vl_u,string vl_pt returns nothing
    local effect vl_e=AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,250),vl_u,vl_pt)
    call zzKS_Size(vl_e,vl_ab)
    call DestroyEffect(vl_e)
    set vl_e=null
endfunction
function zzKS_Atk takes unit vl_h returns real
    return I2R(BlzGetUnitBaseDamage(vl_h,0)+BlzGetUnitDiceNumber(vl_h,0)*(BlzGetUnitDiceSides(vl_h,0)+1)/2)+zzVL_MainStat(vl_h)
endfunction
function zzKS_Hit takes unit vl_h,integer vl_ab returns real
    local integer vl_lv=IMaxBJ(1,GetUnitAbilityLevel(vl_h,vl_ab))
    local integer vl_n=IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,241))
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    local real vl_base=zzKS_Atk(vl_h)*(.9+.17*vl_lv)*(1.+.3*(vl_n-1))/vl_n+20.*vl_lv
    if vl_p<10 and zzKS_chg[vl_p]>0 then
        set vl_base=vl_base*(1.+zzKS_chg[vl_p]*zzKS_chgPct[vl_p]/100.)
    endif
    if vl_p<10 and zzKS_stack[vl_p]>0 and TimerGetElapsed(zzVL_clock)<zzKS_stackEnd[vl_p] then
        set vl_base=vl_base*(1.+IMaxBJ(5,zzKS_stackPct[vl_p])/100.*I2R(zzKS_stack[vl_p]))
    endif
    return vl_base
endfunction
function zzKS_Immune takes unit vl_u returns boolean
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_u))
    return vl_p<10 and vl_u==Jx[vl_p+1] and TimerGetElapsed(zzVL_clock)<zzKS_imm[vl_p]
endfunction
function zzKS_RootEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_u=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0)
    if vl_u!=null then
        call SetUnitPropWindow(vl_u,GetUnitDefaultPropWindow(vl_u)*bj_DEGTORAD)
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
    set vl_u=null
endfunction
// tho thuong (KVCT effect_thothuong, a Silence): the KVCT skills of a hero cannot be cast for a while
function zzKS_SilenceEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_u=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0)
    local integer vl_i=0
    local integer vl_ab
    if vl_u!=null and TimerGetElapsed(zzVL_clock)>=LoadReal(zzVL_ht,GetHandleId(vl_u),77)-.05 then
        loop
            set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),200+vl_i)
            exitwhen vl_ab==0
            call BlzUnitDisableAbility(vl_u,vl_ab,false,false)
            set vl_i=vl_i+1
        endloop
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
    set vl_u=null
endfunction
function zzKS_Silence takes unit vl_u,real vl_d returns nothing
    local integer vl_i=0
    local integer vl_ab
    local timer vl_t
    if LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),200)==0 then
        return
    endif
    loop
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_u),200+vl_i)
        exitwhen vl_ab==0
        call BlzUnitDisableAbility(vl_u,vl_ab,true,false)
        set vl_i=vl_i+1
    endloop
    call SaveReal(zzVL_ht,GetHandleId(vl_u),77,RMaxBJ(LoadReal(zzVL_ht,GetHandleId(vl_u),77),TimerGetElapsed(zzVL_clock)+vl_d))
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl",vl_u,"overhead"))
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_u)
    call TimerStart(vl_t,vl_d,false,function zzKS_SilenceEnd)
    set vl_t=null
endfunction
// one status: 1 tho thuong, 2 dinh than, 3 choang, 4 cham; vl_d seconds
// status model on an enemy for vl_s seconds (config STATUS_VFX): key 300+status = model, 310+status = hundredths of a second
// of one run of the model (0: the model loops by itself); a Birth-only model is put again every run until the status ends
function zzKS_StatusTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_u=LoadUnitHandle(zzVL_ht,vl_id,0)
    local string vl_m=LoadStr(zzVL_ht,vl_id,1)
    call DestroyEffect(LoadEffectHandle(zzVL_ht,vl_id,9))
    call RemoveSavedHandle(zzVL_ht,vl_id,9)
    if LoadInteger(zzVL_ht,vl_id,2)>0 and vl_u!=null and GetWidgetLife(vl_u)>.405 and TimerGetElapsed(zzVL_clock)<LoadReal(zzVL_ht,vl_id,3) then
        call SaveEffectHandle(zzVL_ht,vl_id,9,AddSpecialEffectTarget(vl_m,vl_u,"origin"))
    else
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_u=null
endfunction
function zzKS_StatusFx takes unit vl_u,integer vl_st,real vl_s returns nothing
    local string vl_m=LoadStr(zzVL_ht,0,300+vl_st)
    local integer vl_per=LoadInteger(zzVL_ht,0,310+vl_st)
    local timer vl_t
    if vl_m==null or vl_m=="" or vl_u==null or TimerGetElapsed(zzVL_clock)<LoadReal(zzVL_ht,GetHandleId(vl_u),320+vl_st) then
        return
    endif
    call SaveReal(zzVL_ht,GetHandleId(vl_u),320+vl_st,TimerGetElapsed(zzVL_clock)+vl_s)
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_u)
    call SaveStr(zzVL_ht,GetHandleId(vl_t),1,vl_m)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),2,vl_per)
    call SaveReal(zzVL_ht,GetHandleId(vl_t),3,TimerGetElapsed(zzVL_clock)+vl_s)
    call SaveEffectHandle(zzVL_ht,GetHandleId(vl_t),9,AddSpecialEffectTarget(vl_m,vl_u,"origin"))
    if vl_per>0 then
        call TimerStart(vl_t,vl_per/100.,true,function zzKS_StatusTick)
    else
        call TimerStart(vl_t,vl_s,false,function zzKS_StatusTick)
    endif
    set vl_t=null
endfunction
// the skill's own model (key 250) on a unit for vl_s seconds when the model loops (key 294: it has a Stand sequence), as
// one flash otherwise (a self buff such as Triet Y Thap Bat Diet shows its shield / aura for the whole buff)
function zzKS_SelfFx takes integer vl_ab,unit vl_u,real vl_s returns nothing
    local timer vl_t
    local effect vl_e
    if LoadInteger(zzVL_ht,vl_ab,294)<=0 then
        call zzKS_PopT(vl_ab,vl_u,"origin")
        return
    endif
    set vl_e=AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,250),vl_u,"origin")
    call zzKS_Size(vl_e,vl_ab)
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_u)
    call SaveStr(zzVL_ht,GetHandleId(vl_t),1,LoadStr(zzVL_ht,vl_ab,250))
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),2,0)
    call SaveReal(zzVL_ht,GetHandleId(vl_t),3,0.)
    call SaveEffectHandle(zzVL_ht,GetHandleId(vl_t),9,vl_e)
    call TimerStart(vl_t,vl_s,false,function zzKS_StatusTick)
    set vl_t=null
    set vl_e=null
endfunction
function zzKS_BurnEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    call DestroyEffect(LoadEffectHandle(zzVL_ht,GetHandleId(vl_t),9))
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction
function zzKS_St takes unit vl_h,unit vl_u,integer vl_st,integer vl_ch,real vl_d returns nothing
    local timer vl_tm
    local integer vl_q=GetPlayerId(GetOwningPlayer(vl_u))
    if vl_q<10 and vl_u==Jx[vl_q+1] and zzKS_af[vl_q*16+14]>0 then
        set vl_d=vl_d*(1.-IMinBJ(80,zzKS_af[vl_q*16+14])/100.)
    endif
    if vl_st==0 or GetWidgetLife(vl_u)<.405 or IsUnitType(vl_u,UNIT_TYPE_STRUCTURE) or zzKS_Immune(vl_u) or GetRandomInt(1,100)>vl_ch then
        return
    endif
    if vl_st==1 then
        call zzKS_Silence(vl_u,vl_d)
        return
    elseif vl_st==5 then
        call SaveReal(zzVL_ht,GetHandleId(vl_u),81,RMaxBJ(LoadReal(zzVL_ht,GetHandleId(vl_u),81),TimerGetElapsed(zzVL_clock)+vl_d))
        // burning: the burn model (config STATUS_VFX) stays on the unit for the whole burn
        call zzKS_StatusFx(vl_u,5,RMinBJ(vl_d,6.))
        return
    endif
    set vl_tm=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_u)
    if vl_st==2 then
        call SetUnitPropWindow(vl_u,0)
        call zzKS_StatusFx(vl_u,2,vl_d)
        call TimerStart(vl_tm,vl_d,false,function zzKS_RootEnd)
    elseif vl_st==3 and not IsUnitPaused(vl_u) then
        call PauseUnit(vl_u,true)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",vl_u,"overhead"))
        if zzKS_noCap then
            call TimerStart(vl_tm,vl_d,false,function zzVL_TpUnpause)
        else
            call TimerStart(vl_tm,RMinBJ(vl_d,2.),false,function zzVL_TpUnpause)
        endif
    elseif vl_st==4 and LoadInteger(zzVL_ht,GetHandleId(vl_u),68)==0 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_u),68,1)
        call SaveReal(zzVL_ht,GetHandleId(vl_u),69,GetUnitMoveSpeed(vl_u))
        call SetUnitMoveSpeed(vl_u,GetUnitMoveSpeed(vl_u)*.6)
        call zzKS_StatusFx(vl_u,4,vl_d)
        call TimerStart(vl_tm,vl_d,false,function zzVL_SlowEnd)
    else
        call FlushChildHashtable(zzVL_ht,GetHandleId(vl_tm))
        call DestroyTimer(vl_tm)
    endif
    set vl_tm=null
endfunction
// status of a hit (keys 242 / 243 / 244 tenths of a second); a second status (234 / 235 / 236) is for the later
// waves of a multi-hit skill (KVCT: wave 1 tho thuong, wave 2 dinh than) or comes with the first one
function zzKS_Status takes unit vl_h,unit vl_u,integer vl_ab returns nothing
    local integer vl_s2=LoadInteger(zzVL_ht,vl_ab,234)
    local string vl_tm=LoadStr(zzVL_ht,vl_ab,281)
    // KVCT model of the hit enemy (key 281), at most once every 0.4 s per enemy (lag)
    if vl_tm!=null and vl_tm!="" and vl_u!=null and TimerGetElapsed(zzVL_clock)>=LoadReal(zzVL_ht,GetHandleId(vl_u),86) then
        call SaveReal(zzVL_ht,GetHandleId(vl_u),86,TimerGetElapsed(zzVL_clock)+.4)
        // a floor model (KVCT AddSpecialEffect at the unit's point) goes on the ground, not on the unit
        call zzKS_Layer(vl_ab,293,vl_tm,vl_u,"chest",LoadInteger(zzVL_ht,vl_ab,288)>0)
        if LoadStr(zzVL_ht,vl_ab,283)!=null and LoadStr(zzVL_ht,vl_ab,283)!="" then
            call zzKS_Layer(vl_ab,293,LoadStr(zzVL_ht,vl_ab,283),vl_u,"origin",false)
        endif
    endif
    set zzKS_noCap=LoadInteger(zzVL_ht,vl_ab,201)>0
    if vl_s2==0 or LoadInteger(zzVL_ht,vl_ab,241)<=1 or zzKS_wave<=1 then
        call zzKS_St(vl_h,vl_u,LoadInteger(zzVL_ht,vl_ab,242),LoadInteger(zzVL_ht,vl_ab,243)+LoadInteger(zzVL_ht,vl_ab,225)*GetUnitAbilityLevel(vl_h,vl_ab),I2R(IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,244)+LoadInteger(zzVL_ht,vl_ab,200)*GetUnitAbilityLevel(vl_h,vl_ab)))/10.)
    endif
    if vl_s2>0 and (LoadInteger(zzVL_ht,vl_ab,241)<=1 or zzKS_wave>=2) then
        call zzKS_St(vl_h,vl_u,vl_s2,LoadInteger(zzVL_ht,vl_ab,235)+LoadInteger(zzVL_ht,vl_ab,224)*GetUnitAbilityLevel(vl_h,vl_ab),I2R(IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,236)))/10.)
    endif
    set zzKS_noCap=false
endfunction
// KVCT suy yeu (Me Hon Tran, Hon Phach Phi Duong): the unit deals vl_pct % less damage (at most 20) and attacks 20% slower
// for vl_s seconds (gameplay_04_combat.j reads keys 83 / 84 of the unit)
function zzKS_WeakEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local unit vl_u=LoadUnitHandle(zzVL_ht,GetHandleId(vl_t),0)
    if vl_u!=null and TimerGetElapsed(zzVL_clock)>=LoadReal(zzVL_ht,GetHandleId(vl_u),83)-.05 then
        if LoadReal(zzVL_ht,GetHandleId(vl_u),85)>0. then
            call BlzSetUnitAttackCooldown(vl_u,LoadReal(zzVL_ht,GetHandleId(vl_u),85),0)
            call RemoveSavedReal(zzVL_ht,GetHandleId(vl_u),85)
        endif
    endif
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
    set vl_u=null
endfunction
function zzKS_Weak takes unit vl_u,integer vl_pct,real vl_s returns nothing
    local timer vl_t
    local integer vl_id=GetHandleId(vl_u)
    if vl_u==null or GetWidgetLife(vl_u)<.405 or IsUnitType(vl_u,UNIT_TYPE_STRUCTURE) then
        return
    endif
    call SaveReal(zzVL_ht,vl_id,83,RMaxBJ(LoadReal(zzVL_ht,vl_id,83),TimerGetElapsed(zzVL_clock)+vl_s))
    call SaveInteger(zzVL_ht,vl_id,84,IMinBJ(20,IMaxBJ(LoadInteger(zzVL_ht,vl_id,84),vl_pct)))
    if LoadReal(zzVL_ht,vl_id,85)<=0. then
        call SaveReal(zzVL_ht,vl_id,85,BlzGetUnitAttackCooldown(vl_u,0))
        call BlzSetUnitAttackCooldown(vl_u,BlzGetUnitAttackCooldown(vl_u,0)*1.25,0)
    endif
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\Curse\\CurseTarget.mdl",vl_u,"overhead"))
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_u)
    call TimerStart(vl_t,vl_s,false,function zzKS_WeakEnd)
    set vl_t=null
endfunction
// suy yeu on the enemies within vl_r of (vl_x, vl_y); vl_a >= 0: only those within 20 degrees of that direction
function zzKS_WeakArea takes unit vl_h,real vl_x,real vl_y,real vl_r,real vl_a,integer vl_pct,real vl_s returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    local real vl_d
    call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,vl_r,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            set vl_d=Atan2(GetUnitY(vl_u)-vl_y,GetUnitX(vl_u)-vl_x)*bj_RADTODEG-vl_a
            loop
                exitwhen vl_d<=180.
                set vl_d=vl_d-360.
            endloop
            loop
                exitwhen vl_d>=-180.
                set vl_d=vl_d+360.
            endloop
            if vl_a<0. or RAbsBJ(vl_d)<=20. then
                call zzKS_Weak(vl_u,vl_pct,vl_s)
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
endfunction
// one more stack (fx 8192); KVCT numbers when given: key 173 + 172 x rank stacks at most, key 171 seconds, key 170 % each
function zzKS_StackAdd takes unit vl_h,integer vl_p,integer vl_ab,real vl_s returns nothing
    local integer vl_m=5
    if LoadInteger(zzVL_ht,vl_ab,173)>0 then
        set vl_m=LoadInteger(zzVL_ht,vl_ab,173)+LoadInteger(zzVL_ht,vl_ab,172)*GetUnitAbilityLevel(vl_h,vl_ab)
    endif
    if LoadInteger(zzVL_ht,vl_ab,171)>0 then
        set vl_s=I2R(LoadInteger(zzVL_ht,vl_ab,171))
    endif
    set zzKS_stackPct[vl_p]=LoadInteger(zzVL_ht,vl_ab,170)
    set zzKS_stack[vl_p]=IMinBJ(vl_m,zzKS_stack[vl_p]+1)
    set zzKS_stackEnd[vl_p]=TimerGetElapsed(zzVL_clock)+vl_s
    if zzKS_stack[vl_p]==vl_m then
        call zzVL_Text(vl_h,"|cffffcc00[Cực hạn "+I2S(vl_m)+" tầng]|r")
    endif
endfunction
// extra effects of a hit, from the KVCT description (key 252, see kskill_data.py)
function zzKS_Fx takes unit vl_h,unit vl_u,integer vl_ab,real vl_d returns nothing
    local integer vl_f=LoadInteger(zzVL_ht,vl_ab,252)
    local real vl_a=Atan2(GetUnitY(vl_u)-GetUnitY(vl_h),GetUnitX(vl_u)-GetUnitX(vl_h))
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    local integer vl_k=-1
    local integer vl_c
    local integer vl_m
    local timer vl_tm
    // passives that change the hero's Q / W / E (KVCT: Van Co Thuc Tam, Hoa Huyet Tiet Mach ...): zzKS_Tick
    if vl_p<10 then
        if LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),260)==vl_ab then
            set vl_k=0
        elseif LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),261)==vl_ab then
            set vl_k=1
        elseif LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),262)==vl_ab then
            set vl_k=2
        endif
        if vl_k>=0 then
            set vl_f=BlzBitOr(vl_f,BlzBitOr(zzKS_pfx[vl_p*4+vl_k],zzKS_pfx[vl_p*4+3]))
            if zzKS_steal[vl_p*4+vl_k]>0 and (zzKS_wave<=1 or LoadInteger(zzVL_ht,vl_ab,241)<=1) then
                call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+vl_d*zzKS_steal[vl_p*4+vl_k]/100.)
            endif
        endif
    endif
    if vl_f==0 or GetWidgetLife(vl_u)<.405 then
        return
    endif
    set vl_c=30
    set vl_m=25
    if vl_k>=0 and zzKS_pch[vl_p*4+vl_k]>0 then
        set vl_c=zzKS_pch[vl_p*4+vl_k]
        set vl_m=zzKS_pmul[vl_p*4+vl_k]
    elseif LoadInteger(zzVL_ht,vl_ab,180)>0 then
        set vl_c=LoadInteger(zzVL_ht,vl_ab,180)+LoadInteger(zzVL_ht,vl_ab,177)*GetUnitAbilityLevel(vl_h,vl_ab)
        set vl_m=LoadInteger(zzVL_ht,vl_ab,179)+LoadInteger(zzVL_ht,vl_ab,178)*GetUnitAbilityLevel(vl_h,vl_ab)
    endif
    if BlzBitAnd(vl_f,65536)>0 and vl_d>0. and GetRandomInt(1,100)<=vl_c then
        call zzVL_TpHit(vl_h,vl_u,vl_d*vl_m/100.)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",vl_u,"chest"))
    endif
    if BlzBitAnd(vl_f,131072)>0 and not IsUnitType(vl_u,UNIT_TYPE_HERO) and GetRandomInt(1,100)<=21 then
        call zzVL_TpHit(vl_h,vl_u,GetWidgetLife(vl_u)*.15)
    endif
    // 3 hits on the same enemy burst it (KVCT Thien Thu Van Doc: 3 tang That Tam Co)
    if BlzBitAnd(vl_f,16384)>0 then
        call SaveInteger(zzVL_ht,GetHandleId(vl_u),76,LoadInteger(zzVL_ht,GetHandleId(vl_u),76)+1)
        if LoadInteger(zzVL_ht,GetHandleId(vl_u),76)>=3 then
            call SaveInteger(zzVL_ht,GetHandleId(vl_u),76,0)
            call zzVL_TpHit(vl_h,vl_u,vl_d)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",vl_u,"chest"))
        endif
    endif
    if BlzBitAnd(vl_f,1)>0 and not IsUnitType(vl_u,UNIT_TYPE_STRUCTURE) and not zzKS_Immune(vl_u) then
        call SetUnitPosition(vl_u,GetUnitX(vl_u)+140.*Cos(vl_a),GetUnitY(vl_u)+140.*Sin(vl_a))
    elseif BlzBitAnd(vl_f,2)>0 and not IsUnitType(vl_u,UNIT_TYPE_STRUCTURE) and not zzKS_Immune(vl_u) and IsUnitInRange(vl_u,vl_h,160.)==false then
        call SetUnitPosition(vl_u,GetUnitX(vl_h)+110.*Cos(vl_a),GetUnitY(vl_h)+110.*Sin(vl_a))
    endif
    if BlzBitAnd(vl_f,4)>0 and HaveSavedInteger(zzVL_ht,vl_ab,187) then
        call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+vl_d*LoadInteger(zzVL_ht,vl_ab,187)/100.)
    elseif BlzBitAnd(vl_f,4)>0 then
        call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+vl_d*.2)
    endif
    if BlzBitAnd(vl_f,8)>0 and TimerGetElapsed(zzVL_clock)>LoadReal(zzVL_ht,GetHandleId(vl_u),75) then
        set vl_c=5
        if LoadInteger(zzVL_ht,vl_ab,166)>0 then
            // KVCT doc sat: N ticks, one a second (key 166)
            set vl_c=LoadInteger(zzVL_ht,vl_ab,166)
        endif
        call SaveReal(zzVL_ht,GetHandleId(vl_u),75,TimerGetElapsed(zzVL_clock)+vl_c)
        set vl_tm=CreateTimer()
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),5,vl_c)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_h)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_u)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),2,vl_d*.08)
        if BlzBitAnd(vl_f,2048)>0 then
            call SaveInteger(zzVL_ht,GetHandleId(vl_tm),4,1)
        endif
        call TimerStart(vl_tm,1.,true,function zzVL_TpPoison)
        set vl_tm=null
    endif
    if BlzBitAnd(vl_f,512)>0 then
        set vl_c=IMaxBJ(4,LoadInteger(zzVL_ht,vl_ab,246))
        if LoadInteger(zzVL_ht,vl_ab,164)>0 then
            set vl_c=LoadInteger(zzVL_ht,vl_ab,164)
        elseif vl_k>=0 and IMaxBJ(zzKS_pdur[vl_p*4+vl_k],zzKS_pdur[vl_p*4+3])>0 then
            set vl_c=IMaxBJ(zzKS_pdur[vl_p*4+vl_k],zzKS_pdur[vl_p*4+3])
        endif
        call SaveReal(zzVL_ht,GetHandleId(vl_u),74,RMaxBJ(LoadReal(zzVL_ht,GetHandleId(vl_u),74),TimerGetElapsed(zzVL_clock)+vl_c))
    endif
    if BlzBitAnd(vl_f,4096)>0 then
        call SetUnitState(vl_h,UNIT_STATE_MANA,GetUnitState(vl_h,UNIT_STATE_MANA)+vl_d*.04)
    endif
    if BlzBitAnd(vl_f,8192)>0 and vl_p<10 then
        if TimerGetElapsed(zzVL_clock)>zzKS_stackEnd[vl_p] then
            set zzKS_stack[vl_p]=0
        endif
        call zzKS_StackAdd(vl_h,vl_p,vl_ab,6.)
    endif
endfunction
function zzKS_StrikeFx takes unit vl_h,unit vl_u,integer vl_ab,real vl_d,boolean vl_fx returns nothing
    if vl_u!=null and zzVL_TpFoe(vl_h,vl_u) then
        if LoadInteger(zzVL_ht,vl_ab,228)==0 then
            call zzVL_TpHit(vl_h,vl_u,vl_d)
        endif
        if vl_fx then
            call zzKS_PopT(vl_ab,vl_u,"chest")
        endif
        call zzKS_Status(vl_h,vl_u,vl_ab)
        call zzKS_Fx(vl_h,vl_u,vl_ab,vl_d)
    endif
endfunction
function zzKS_Strike takes unit vl_h,unit vl_u,integer vl_ab,real vl_d returns nothing
    call zzKS_StrikeFx(vl_h,vl_u,vl_ab,vl_d,true)
endfunction
// enemies in a circle (vl_cone<0) or in front of the caster within vl_cone degrees of vl_a
function zzKS_Area takes unit vl_h,real vl_x,real vl_y,real vl_r,real vl_a,real vl_cone,integer vl_ab,real vl_d returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    local real vl_b
    local integer vl_max=LoadInteger(zzVL_ht,vl_ab,259)
    local integer vl_n=0
    if vl_max==0 then
        set vl_max=12
    endif
    call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,vl_r,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null or (vl_max>0 and vl_n>=vl_max)
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            if vl_cone<0. then
                call zzKS_StrikeFx(vl_h,vl_u,vl_ab,vl_d,vl_n<4)
                set vl_n=vl_n+1
            else
                set vl_b=Atan2(GetUnitY(vl_u)-vl_y,GetUnitX(vl_u)-vl_x)*bj_RADTODEG-vl_a
                if Cos(vl_b*bj_DEGTORAD)>=Cos(vl_cone*bj_DEGTORAD) then
                    call zzKS_StrikeFx(vl_h,vl_u,vl_ab,vl_d,vl_n<4)
                    set vl_n=vl_n+1
                endif
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
endfunction
function zzKS_Rad takes integer vl_ab,real vl_r returns real
    if LoadInteger(zzVL_ht,vl_ab,257)>0 then
        return I2R(LoadInteger(zzVL_ht,vl_ab,257))
    endif
    return vl_r
endfunction
// a piercing missile: the skill's model flies 900 in a straight line, hitting every enemy on its way once
// one missile step (every 0.03 s): move, hit the enemies on the way once, true when it is over. The data of a missile are in
// the hashtable under a negative id; all missiles share one timer and one group (lag: no timer / group per missile)
function zzKS_FlyOne takes integer vl_id returns boolean
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local effect vl_e=LoadEffectHandle(zzVL_ht,vl_id,1)
    local group vl_hit=LoadGroupHandle(zzVL_ht,vl_id,2)
    local integer vl_ab=LoadInteger(zzVL_ht,vl_id,4)
    local real vl_a=LoadReal(zzVL_ht,vl_id,5)
    local real vl_x=LoadReal(zzVL_ht,vl_id,6)+40.*Cos(vl_a)
    local real vl_y=LoadReal(zzVL_ht,vl_id,7)+40.*Sin(vl_a)
    local real vl_go=LoadReal(zzVL_ht,vl_id,8)+40.
    local unit vl_u
    local integer vl_cap=LoadInteger(zzVL_ht,vl_ab,259)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,11)
    local boolean vl_end=false
    if vl_cap==0 then
        set vl_cap=12
    endif
    call SaveReal(zzVL_ht,vl_id,6,vl_x)
    call SaveReal(zzVL_ht,vl_id,7,vl_y)
    call SaveReal(zzVL_ht,vl_id,8,vl_go)
    call BlzSetSpecialEffectX(vl_e,vl_x)
    call BlzSetSpecialEffectY(vl_e,vl_y)
    if vl_n<vl_cap and vl_h!=null then
        if zzKS_fg==null then
            set zzKS_fg=CreateGroup()
        endif
        if LoadInteger(zzVL_ht,vl_ab,167)>0 then
            // KVCT width of the missile (key 167)
            call GroupEnumUnitsInRange(zzKS_fg,vl_x,vl_y,I2R(LoadInteger(zzVL_ht,vl_ab,167)),null)
        else
            call GroupEnumUnitsInRange(zzKS_fg,vl_x,vl_y,120.,null)
        endif
        loop
            set vl_u=FirstOfGroup(zzKS_fg)
            exitwhen vl_u==null
            call GroupRemoveUnit(zzKS_fg,vl_u)
            if vl_n<vl_cap and not IsUnitInGroup(vl_u,vl_hit) and zzVL_TpFoe(vl_h,vl_u) then
                set vl_n=vl_n+1
                call GroupAddUnit(vl_hit,vl_u)
                call zzVL_TpHit(vl_h,vl_u,LoadReal(zzVL_ht,vl_id,9))
                call zzKS_Status(vl_h,vl_u,vl_ab)
                call zzKS_Fx(vl_h,vl_u,vl_ab,LoadReal(zzVL_ht,vl_id,9))
            endif
        endloop
        call SaveInteger(zzVL_ht,vl_id,11,vl_n)
    endif
    if vl_go>=LoadReal(zzVL_ht,vl_id,10) or vl_h==null then
        call DestroyEffect(vl_e)
        call DestroyGroup(vl_hit)
        call FlushChildHashtable(zzVL_ht,vl_id)
        set vl_end=true
    endif
    set vl_h=null
    set vl_e=null
    set vl_hit=null
    set vl_u=null
    return vl_end
endfunction
function zzKS_Fly takes nothing returns nothing
    local integer vl_i=0
    loop
        exitwhen vl_i>=zzKS_misN
        if zzKS_FlyOne(zzKS_mis[vl_i]) then
            set zzKS_misN=zzKS_misN-1
            set zzKS_mis[vl_i]=zzKS_mis[zzKS_misN]
        else
            set vl_i=vl_i+1
        endif
    endloop
    if zzKS_misN<=0 then
        call PauseTimer(zzKS_misT)
    endif
endfunction
function zzKS_Missile takes unit vl_h,integer vl_ab,real vl_a,real vl_d,real vl_sx,real vl_sy returns nothing
    local integer vl_id
    local effect vl_e
    if zzKS_misN>=399 then
        return
    endif
    set zzKS_misC=zzKS_misC-1
    set vl_id=zzKS_misC
    set vl_e=AddSpecialEffect(LoadStr(zzVL_ht,vl_ab,250),vl_sx,vl_sy)
    call zzKS_Size(vl_e,vl_ab)
    call BlzSetSpecialEffectYaw(vl_e,vl_a)
    call BlzSetSpecialEffectHeight(vl_e,60.)
    call SaveUnitHandle(zzVL_ht,vl_id,0,vl_h)
    call SaveEffectHandle(zzVL_ht,vl_id,1,vl_e)
    call SaveGroupHandle(zzVL_ht,vl_id,2,CreateGroup())
    call SaveInteger(zzVL_ht,vl_id,4,vl_ab)
    call SaveReal(zzVL_ht,vl_id,5,vl_a)
    call SaveReal(zzVL_ht,vl_id,6,vl_sx)
    call SaveReal(zzVL_ht,vl_id,7,vl_sy)
    call SaveReal(zzVL_ht,vl_id,8,0.)
    call SaveReal(zzVL_ht,vl_id,9,vl_d)
    call SaveReal(zzVL_ht,vl_id,10,zzKS_Rad(vl_ab,900.))
    set zzKS_mis[zzKS_misN]=vl_id
    set zzKS_misN=zzKS_misN+1
    if zzKS_misT==null then
        set zzKS_misT=CreateTimer()
    endif
    if zzKS_misN==1 then
        call TimerStart(zzKS_misT,.03,true,function zzKS_Fly)
    endif
    set vl_e=null
endfunction
function zzKS_Fan takes unit vl_h,integer vl_ab,real vl_a,real vl_d,real vl_x,real vl_y returns nothing
    local integer vl_n=LoadInteger(zzVL_ht,vl_ab,207)
    local real vl_sp=I2R(LoadInteger(zzVL_ht,vl_ab,206))
    local integer vl_i=0
    local real vl_sx=GetUnitX(vl_h)
    local real vl_sy=GetUnitY(vl_h)
    if GetUnitAbilityLevel(vl_h,vl_ab)>=3 then
        set vl_n=vl_n+LoadInteger(zzVL_ht,vl_ab,205)
    endif
    if GetUnitAbilityLevel(vl_h,vl_ab)>=5 then
        set vl_n=vl_n+LoadInteger(zzVL_ht,vl_ab,205)
    endif
    // key 186: rank - key 186 missiles when more (KVCT Hang Long Huu Hoi: 3 palms, 9 at rank 10)
    if LoadInteger(zzVL_ht,vl_ab,186)>0 then
        set vl_n=IMaxBJ(vl_n,GetUnitAbilityLevel(vl_h,vl_ab)-LoadInteger(zzVL_ht,vl_ab,186))
    endif
    if LoadInteger(zzVL_ht,vl_ab,215)==1 then
        set vl_sx=vl_x
        set vl_sy=vl_y
    endif
    loop
        exitwhen vl_i>=vl_n
        call zzKS_Missile(vl_h,vl_ab,(vl_a+(vl_i-(vl_n-1)/2.)*vl_sp)*bj_DEGTORAD,vl_d,vl_sx,vl_sy)
        set vl_i=vl_i+1
    endloop
endfunction
function zzKS_Random takes unit vl_h,integer vl_ab,real vl_d returns nothing
    local group vl_g=CreateGroup()
    local group vl_f=CreateGroup()
    local unit vl_u
    local integer vl_n=IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,259))
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),zzKS_Rad(vl_ab,800.),null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            call GroupAddUnit(vl_f,vl_u)
        endif
    endloop
    loop
        set vl_u=GroupPickRandomUnit(vl_f)
        exitwhen vl_u==null or vl_n<=0
        call GroupRemoveUnit(vl_f,vl_u)
        set vl_n=vl_n-1
        call zzKS_Strike(vl_h,vl_u,vl_ab,vl_d)
    endloop
    call DestroyGroup(vl_g)
    call DestroyGroup(vl_f)
    set vl_g=null
    set vl_f=null
endfunction
function zzKS_Do takes unit vl_h,unit vl_t,integer vl_ab,real vl_x,real vl_y returns nothing
    local integer vl_k=LoadInteger(zzVL_ht,vl_ab,240)
    local real vl_d=zzKS_Hit(vl_h,vl_ab)
    local real vl_a=Atan2(vl_y-GetUnitY(vl_h),vl_x-GetUnitX(vl_h))*bj_RADTODEG
    // 3 dash: on a hit (Q W E autocast, proc) it strikes the target
    if vl_k==1 or vl_k==3 then
        call zzKS_Strike(vl_h,vl_t,vl_ab,vl_d)
    elseif vl_k==2 then
        call zzKS_Pop(vl_ab,GetUnitX(vl_h)+150.*Cos(vl_a*bj_DEGTORAD),GetUnitY(vl_h)+150.*Sin(vl_a*bj_DEGTORAD))
        call zzKS_Area(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),zzKS_Rad(vl_ab,450.),vl_a,45.,vl_ab,vl_d)
    elseif vl_k==4 then
        call zzKS_Pop(vl_ab,GetUnitX(vl_h),GetUnitY(vl_h))
        call zzKS_Area(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),zzKS_Rad(vl_ab,380.),0.,-1.,vl_ab,vl_d)
    elseif vl_k==5 and LoadInteger(zzVL_ht,vl_ab,207)>1 then
        call zzKS_Fan(vl_h,vl_ab,vl_a,vl_d,vl_x,vl_y)
    elseif vl_k==5 and LoadInteger(zzVL_ht,vl_ab,215)==1 then
        call zzKS_Missile(vl_h,vl_ab,vl_a*bj_DEGTORAD,vl_d,vl_x,vl_y)
    elseif vl_k==5 then
        call zzKS_Missile(vl_h,vl_ab,vl_a*bj_DEGTORAD,vl_d,GetUnitX(vl_h),GetUnitY(vl_h))
    elseif vl_k==17 then
        call zzKS_Random(vl_h,vl_ab,vl_d)
    elseif vl_k==13 then
        set zzKS_fh=vl_h
        set zzKS_fab=vl_ab
        set zzKS_fx=vl_x
        set zzKS_fy=vl_y
        call ExecuteFunc("zzKS_FieldX")
    elseif vl_k==16 then
        // splash at the target point (KVCT Kinh Loi Tram, Pha Thien Tram: radius 120-130 where the target stood)
        call zzKS_Pop(vl_ab,vl_x,vl_y)
        call zzKS_Area(vl_h,vl_x,vl_y,zzKS_Rad(vl_ab,130.),0.,-1.,vl_ab,vl_d)
    endif
endfunction
// later hits of a multi-hit skill (Bon Loi Toan Long Thuong: 7 hits ...)
function zzKS_Again takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local unit vl_u=LoadUnitHandle(zzVL_ht,vl_id,1)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)-1
    if vl_h!=null and GetWidgetLife(vl_h)>.405 and not IsUnitPaused(vl_h) then
        set zzKS_wave=LoadInteger(zzVL_ht,vl_id,7)-vl_n
        if LoadInteger(zzVL_ht,LoadInteger(zzVL_ht,vl_id,4),215)==1 and vl_u!=null and GetWidgetLife(vl_u)>.405 then
            call SaveReal(zzVL_ht,vl_id,5,GetUnitX(vl_u)+GetRandomReal(-30.,30.))
            call SaveReal(zzVL_ht,vl_id,6,GetUnitY(vl_u)+GetRandomReal(-30.,30.))
        endif
        call zzKS_Do(vl_h,vl_u,LoadInteger(zzVL_ht,vl_id,4),LoadReal(zzVL_ht,vl_id,5),LoadReal(zzVL_ht,vl_id,6))
        set zzKS_wave=1
    else
        set vl_n=0
    endif
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    if vl_n<=0 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
    set vl_u=null
endfunction
// a skill with all its hits: the first now, the next every key 258 hundredths of a second (default .22 s)
function zzKS_Run takes unit vl_h,unit vl_t,integer vl_ab,real vl_x,real vl_y returns nothing
    local integer vl_n=LoadInteger(zzVL_ht,vl_ab,241)
    local string vl_cm=LoadStr(zzVL_ht,vl_ab,280)
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    local integer vl_k=-1
    local timer vl_tm
    // KVCT model of the cast (key 280) on the hero
    if vl_cm!=null and vl_cm!="" then
        call zzKS_Layer(vl_ab,292,vl_cm,vl_h,"origin",LoadInteger(zzVL_ht,vl_ab,289)>0)
    endif
    // more KVCT layers of the cast: 282 second cast model, 284 buff model on the hero, 285 / 286 effect layers at the point
    if LoadStr(zzVL_ht,vl_ab,282)!=null and LoadStr(zzVL_ht,vl_ab,282)!="" then
        call zzKS_Layer(vl_ab,292,LoadStr(zzVL_ht,vl_ab,282),vl_h,"origin",false)
    endif
    if LoadStr(zzVL_ht,vl_ab,284)!=null and LoadStr(zzVL_ht,vl_ab,284)!="" then
        call DestroyEffect(AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,284),vl_h,"chest"))
    endif
    if LoadStr(zzVL_ht,vl_ab,285)!=null and LoadStr(zzVL_ht,vl_ab,285)!="" then
        call DestroyEffect(AddSpecialEffect(LoadStr(zzVL_ht,vl_ab,285),vl_x,vl_y))
    endif
    if LoadStr(zzVL_ht,vl_ab,286)!=null and LoadStr(zzVL_ht,vl_ab,286)!="" then
        call DestroyEffect(AddSpecialEffect(LoadStr(zzVL_ht,vl_ab,286),vl_x,vl_y))
    endif
    if vl_p<10 then
        if LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),260)==vl_ab then
            set vl_k=0
        elseif LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),261)==vl_ab then
            set vl_k=1
        elseif LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),262)==vl_ab then
            set vl_k=2
        endif
        if vl_k>=0 and zzKS_xw[vl_p*4+vl_k]>0 and GetRandomInt(1,100)<=zzKS_xc[vl_p*4+vl_k] then
            set vl_n=vl_n+zzKS_xw[vl_p*4+vl_k]
        endif
    endif
    set zzKS_wave=1
    call zzKS_Do(vl_h,vl_t,vl_ab,vl_x,vl_y)
    if vl_k>=0 then
        set zzKS_chg[vl_p]=0
    endif
    // a field (kind 13) makes its own pulses
    if vl_n>1 and LoadInteger(zzVL_ht,vl_ab,240)!=13 then
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_h)
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),1,vl_t)
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),3,vl_n-1)
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),4,vl_ab)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),5,vl_x)
        call SaveReal(zzVL_ht,GetHandleId(vl_tm),6,vl_y)
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),7,vl_n)
        if LoadInteger(zzVL_ht,vl_ab,258)>0 then
            call TimerStart(vl_tm,LoadInteger(zzVL_ht,vl_ab,258)/100.,true,function zzKS_Again)
        else
            call TimerStart(vl_tm,.22,true,function zzKS_Again)
        endif
        set vl_tm=null
    endif
    if LoadInteger(zzVL_ht,vl_ab,183)>0 then
        set zzKS_fh=vl_h
        set zzKS_fab=vl_ab
        set zzKS_fx=vl_x
        set zzKS_fy=vl_y
        call ExecuteFunc("zzKS_SlotX")
    endif
endfunction
// a skill that also runs the hero's Q W E (key 183: 1 2 3) at a point
function zzKS_Slot takes unit vl_h,integer vl_ab,real vl_x,real vl_y returns nothing
    local integer vl_s=LoadInteger(zzVL_ht,vl_ab,183)
    local integer vl_a=0
    if vl_s>0 then
        set vl_a=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),259+vl_s)
    endif
    if vl_a!=0 and vl_a!=vl_ab and GetUnitAbilityLevel(vl_h,vl_a)>0 then
        call zzKS_Run(vl_h,null,vl_a,vl_x,vl_y)
    endif
endfunction
function zzKS_SlotX takes nothing returns nothing
    call zzKS_Slot(zzKS_fh,zzKS_fab,zzKS_fx,zzKS_fy)
endfunction
// nearest enemy within 900 (null when none)
function zzKS_Near takes unit vl_h returns unit
    local group vl_g=CreateGroup()
    local unit vl_u
    local unit vl_b=null
    local real vl_d=0.
    local real vl_m=1000000.
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),900.,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            set vl_d=(GetUnitX(vl_u)-GetUnitX(vl_h))*(GetUnitX(vl_u)-GetUnitX(vl_h))+(GetUnitY(vl_u)-GetUnitY(vl_h))*(GetUnitY(vl_u)-GetUnitY(vl_h))
            if vl_d<vl_m then
                set vl_m=vl_d
                set vl_b=vl_u
            endif
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
    set vl_u=null
    return vl_b
endfunction
// pull (fx 2): slide the unit to within 80 of the field's middle in 10 steps of 0.03 s
function zzKS_PullTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_u=LoadUnitHandle(zzVL_ht,vl_id,0)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,1)-1
    local real vl_x=GetUnitX(vl_u)+LoadReal(zzVL_ht,vl_id,2)
    local real vl_y=GetUnitY(vl_u)+LoadReal(zzVL_ht,vl_id,3)
    if GetWidgetLife(vl_u)>.405 and IsTerrainPathable(vl_x,vl_y,PATHING_TYPE_WALKABILITY)==false then
        call SetUnitX(vl_u,vl_x)
        call SetUnitY(vl_u,vl_y)
    else
        set vl_n=0
    endif
    call SaveInteger(zzVL_ht,vl_id,1,vl_n)
    if vl_n<=0 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_u=null
endfunction
function zzKS_Pull takes unit vl_u,real vl_x,real vl_y returns nothing
    local timer vl_t
    local real vl_a=Atan2(vl_y-GetUnitY(vl_u),vl_x-GetUnitX(vl_u))
    local real vl_r=SquareRoot((vl_x-GetUnitX(vl_u))*(vl_x-GetUnitX(vl_u))+(vl_y-GetUnitY(vl_u))*(vl_y-GetUnitY(vl_u)))-80.
    if vl_r<=0. then
        return
    endif
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_u)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),1,10)
    call SaveReal(zzVL_ht,GetHandleId(vl_t),2,vl_r/10.*Cos(vl_a))
    call SaveReal(zzVL_ht,GetHandleId(vl_t),3,vl_r/10.*Sin(vl_a))
    call TimerStart(vl_t,.03,true,function zzKS_PullTick)
    set vl_t=null
endfunction
// KVCT ground field (Chu Cap Thanh Minh ...): at the target point (at most 640 away), a pulse every key 258
// hundredths of a second, key 241 pulses; each pulse pulls (fx 2) the enemies in it 100 toward the middle and
// hits them (key 257 radius, key 259 at most)
function zzKS_FieldTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local integer vl_ab=LoadInteger(zzVL_ht,vl_id,4)
    local real vl_x=LoadReal(zzVL_ht,vl_id,5)
    local real vl_y=LoadReal(zzVL_ht,vl_id,6)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)-1
    local integer vl_c=0
    local integer vl_max=LoadInteger(zzVL_ht,vl_ab,259)
    local group vl_g=CreateGroup()
    local unit vl_u
    local real vl_a
    local real vl_d
    if vl_max==0 then
        set vl_max=12
    endif
    if vl_h!=null and GetWidgetLife(vl_h)>.405 then
        set vl_d=zzKS_Hit(vl_h,vl_ab)
        if LoadBoolean(zzVL_ht,vl_id,11) then
            set vl_x=GetUnitX(vl_h)
            set vl_y=GetUnitY(vl_h)
        endif
        call zzKS_Pop(vl_ab,vl_x,vl_y)
        call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,zzKS_Rad(vl_ab,350.)+LoadInteger(zzVL_ht,vl_ab,196)*GetUnitAbilityLevel(vl_h,vl_ab),null)
        loop
            set vl_u=FirstOfGroup(vl_g)
            exitwhen vl_u==null or (vl_max>0 and vl_c>=vl_max)
            call GroupRemoveUnit(vl_g,vl_u)
            if zzVL_TpFoe(vl_h,vl_u) then
                set vl_c=vl_c+1
                if BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),2)>0 and not zzKS_Immune(vl_u) and not IsUnitInRangeXY(vl_u,vl_x,vl_y,110.) then
                    if LoadInteger(zzVL_ht,vl_ab,181)>0 then
                        // key 181 (KVCT Hoa Lien Phan Hoa): enemies further than 100 from the middle are sucked into it
                        call zzKS_Pull(vl_u,vl_x,vl_y)
                    else
                        // KVCT Chu Cap Thanh Minh ...: pulled 100 toward the middle
                        set vl_a=Atan2(vl_y-GetUnitY(vl_u),vl_x-GetUnitX(vl_u))
                        call SetUnitPosition(vl_u,GetUnitX(vl_u)+100.*Cos(vl_a),GetUnitY(vl_u)+100.*Sin(vl_a))
                    endif
                endif
                if LoadInteger(zzVL_ht,vl_ab,228)==0 then
                    call zzVL_TpHit(vl_h,vl_u,vl_d)
                endif
                call zzKS_PopT(vl_ab,vl_u,"origin")
                call zzKS_Status(vl_h,vl_u,vl_ab)
                call zzKS_Fx(vl_h,vl_u,vl_ab,vl_d)
            endif
        endloop
    else
        set vl_n=0
    endif
    call DestroyGroup(vl_g)
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    if vl_n<=0 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
    set vl_g=null
endfunction
function zzKS_Field takes unit vl_h,integer vl_ab,real vl_x,real vl_y returns nothing
    local timer vl_t=CreateTimer()
    local integer vl_id=GetHandleId(vl_t)
    local real vl_a=Atan2(vl_y-GetUnitY(vl_h),vl_x-GetUnitX(vl_h))
    local real vl_r=SquareRoot((vl_x-GetUnitX(vl_h))*(vl_x-GetUnitX(vl_h))+(vl_y-GetUnitY(vl_h))*(vl_y-GetUnitY(vl_h)))
    call SaveBoolean(zzVL_ht,vl_id,11,LoadInteger(zzVL_ht,vl_ab,240)==18)
    if LoadInteger(zzVL_ht,vl_ab,194)>0 and vl_r>LoadInteger(zzVL_ht,vl_ab,194) then
        set vl_x=GetUnitX(vl_h)+LoadInteger(zzVL_ht,vl_ab,194)*Cos(vl_a)
        set vl_y=GetUnitY(vl_h)+LoadInteger(zzVL_ht,vl_ab,194)*Sin(vl_a)
    elseif LoadInteger(zzVL_ht,vl_ab,194)==0 and vl_r>640. then
        set vl_x=GetUnitX(vl_h)+640.*Cos(vl_a)
        set vl_y=GetUnitY(vl_h)+640.*Sin(vl_a)
    endif
    call SaveUnitHandle(zzVL_ht,vl_id,0,vl_h)
    call SaveInteger(zzVL_ht,vl_id,3,IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,241)))
    call SaveInteger(zzVL_ht,vl_id,4,vl_ab)
    call SaveReal(zzVL_ht,vl_id,5,vl_x)
    call SaveReal(zzVL_ht,vl_id,6,vl_y)
    call zzKS_Pop(vl_ab,vl_x,vl_y)
    if LoadInteger(zzVL_ht,vl_ab,258)>0 then
        call TimerStart(vl_t,LoadInteger(zzVL_ht,vl_ab,258)/100.,true,function zzKS_FieldTick)
    else
        call TimerStart(vl_t,2.,true,function zzKS_FieldTick)
    endif
    set vl_t=null
endfunction
function zzKS_FieldX takes nothing returns nothing
    call zzKS_Field(zzKS_fh,zzKS_fab,zzKS_fx,zzKS_fy)
endfunction
// KVCT toggle (Vo Hinh Co): on until cast again or out of mana; every second costs key 232 x rank mana and hurts
// the enemies around (key 257 radius, key 259 at most)
function zzKS_Auto takes unit vl_h,integer vl_ab returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    local unit vl_best=null
    local real vl_r=zzKS_Rad(vl_ab,600.)
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),vl_r,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) and (vl_best==null or IsUnitInRange(vl_u,vl_h,SquareRoot((GetUnitX(vl_best)-GetUnitX(vl_h))*(GetUnitX(vl_best)-GetUnitX(vl_h))+(GetUnitY(vl_best)-GetUnitY(vl_h))*(GetUnitY(vl_best)-GetUnitY(vl_h))))) then
            set vl_best=vl_u
        endif
    endloop
    call DestroyGroup(vl_g)
    if vl_best!=null then
        call zzKS_Fan(vl_h,vl_ab,Atan2(GetUnitY(vl_best)-GetUnitY(vl_h),GetUnitX(vl_best)-GetUnitX(vl_h))*bj_RADTODEG,zzKS_Hit(vl_h,vl_ab),GetUnitX(vl_best),GetUnitY(vl_best))
    endif
    set vl_g=null
    set vl_best=null
endfunction
function zzKS_ToggleTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local integer vl_ab=LoadInteger(zzVL_ht,vl_id,4)
    local real vl_cost=0.
    local boolean vl_end=LoadBoolean(zzVL_ht,vl_id,8) or vl_h==null
    local group vl_g
    local unit vl_u
    local integer vl_c=0
    local integer vl_max=LoadInteger(zzVL_ht,vl_ab,259)
    local real vl_d
    if vl_max==0 then
        set vl_max=12
    endif
    if not vl_end then
        set vl_end=GetWidgetLife(vl_h)<.405 or GetUnitAbilityLevel(vl_h,vl_ab)==0
        set vl_cost=I2R(LoadInteger(zzVL_ht,vl_ab,232)*IMaxBJ(1,GetUnitAbilityLevel(vl_h,vl_ab)))
    endif
    if not vl_end and LoadInteger(zzVL_ht,vl_ab,240)==21 then
        call SaveInteger(zzVL_ht,vl_id,12,LoadInteger(zzVL_ht,vl_id,12)+1)
        if LoadInteger(zzVL_ht,vl_id,12)*100>=LoadInteger(zzVL_ht,vl_ab,258) then
            call SaveInteger(zzVL_ht,vl_id,12,0)
            call zzKS_Auto(vl_h,vl_ab)
        endif
        set vl_t=null
        set vl_h=null
        return
    endif
    if not vl_end and GetUnitState(vl_h,UNIT_STATE_MANA)<vl_cost then
        set vl_end=true
        call zzVL_Text(vl_h,"|cff8080ffHết nội lực|r")
    endif
    if vl_end then
        call DestroyEffect(LoadEffectHandle(zzVL_ht,vl_id,9))
        if vl_h!=null and LoadTimerHandle(zzVL_ht,GetHandleId(vl_h),vl_ab)==vl_t then
            call RemoveSavedHandle(zzVL_ht,GetHandleId(vl_h),vl_ab)
        endif
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    else
        call SetUnitState(vl_h,UNIT_STATE_MANA,GetUnitState(vl_h,UNIT_STATE_MANA)-vl_cost)
        set vl_d=zzKS_Atk(vl_h)*.35
        set vl_g=CreateGroup()
        call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),zzKS_Rad(vl_ab,350.),null)
        loop
            set vl_u=FirstOfGroup(vl_g)
            exitwhen vl_u==null or (vl_max>0 and vl_c>=vl_max)
            call GroupRemoveUnit(vl_g,vl_u)
            if zzVL_TpFoe(vl_h,vl_u) then
                set vl_c=vl_c+1
                call zzVL_TpHit(vl_h,vl_u,vl_d)
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl",vl_u,"chest"))
            endif
        endloop
        call DestroyGroup(vl_g)
    endif
    set vl_t=null
    set vl_h=null
    set vl_g=null
endfunction
function zzKS_Toggle takes unit vl_h,integer vl_ab returns nothing
    local timer vl_t
    if HaveSavedHandle(zzVL_ht,GetHandleId(vl_h),vl_ab) then
        call SaveBoolean(zzVL_ht,GetHandleId(LoadTimerHandle(zzVL_ht,GetHandleId(vl_h),vl_ab)),8,true)
        call RemoveSavedHandle(zzVL_ht,GetHandleId(vl_h),vl_ab)
        call zzVL_Text(vl_h,"|cffc0c0c0"+GetObjectName(vl_ab)+": tắt|r")
        return
    endif
    set vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_h)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),4,vl_ab)
    call SaveEffectHandle(zzVL_ht,GetHandleId(vl_t),9,AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,250),vl_h,"origin"))
    call SaveTimerHandle(zzVL_ht,GetHandleId(vl_h),vl_ab,vl_t)
    call zzVL_Text(vl_h,"|cff80ff80"+GetObjectName(vl_ab)+": bật|r")
    call TimerStart(vl_t,1.,true,function zzKS_ToggleTick)
    set vl_t=null
endfunction
// KVCT curse (U Minh Kho Lau ...): no damage, the enemies around the target point (key 257, key 259 at most)
// get the skill's status and effects (fx 512 lasts key 246 seconds)
function zzKS_Curse takes unit vl_h,integer vl_ab,real vl_x,real vl_y returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    local integer vl_c=0
    local integer vl_max=LoadInteger(zzVL_ht,vl_ab,259)
    if vl_max==0 then
        set vl_max=12
    endif
    call zzKS_Pop(vl_ab,vl_x,vl_y)
    call GroupEnumUnitsInRange(vl_g,vl_x,vl_y,zzKS_Rad(vl_ab,200.),null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null or (vl_max>0 and vl_c>=vl_max)
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            set vl_c=vl_c+1
            call zzKS_PopT(vl_ab,vl_u,"chest")
            call zzKS_Status(vl_h,vl_u,vl_ab)
            call zzKS_Fx(vl_h,vl_u,vl_ab,0.)
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
endfunction
// KVCT dash (Doan Hon Thich, ...): the hero slides 48 every 1/32 s leaving a 20% ghost of itself walking,
// then hits enemies around the end (radius key 9 of the timer, at most 7), effect at each of them
function zzKS_GhostEnd takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    call DestroyEffect(LoadEffectHandle(zzVL_ht,GetHandleId(vl_t),0))
    call FlushChildHashtable(zzVL_ht,GetHandleId(vl_t))
    call DestroyTimer(vl_t)
    set vl_t=null
endfunction
function zzKS_Ghost takes unit vl_h,real vl_a returns nothing
    local effect vl_e
    local timer vl_t
    if LoadStr(zzVL_ht,GetUnitTypeId(vl_h),272)==null then
        return
    endif
    set vl_e=AddSpecialEffect(LoadStr(zzVL_ht,GetUnitTypeId(vl_h),272),GetUnitX(vl_h),GetUnitY(vl_h))
    call BlzSetSpecialEffectScale(vl_e,BlzGetUnitRealField(vl_h,UNIT_RF_SCALING_VALUE))
    call BlzSetSpecialEffectAlpha(vl_e,51)
    call BlzSetSpecialEffectYaw(vl_e,vl_a)
    call BlzPlaySpecialEffect(vl_e,ANIM_TYPE_WALK)
    set vl_t=CreateTimer()
    call SaveEffectHandle(zzVL_ht,GetHandleId(vl_t),0,vl_e)
    call TimerStart(vl_t,.2,false,function zzKS_GhostEnd)
    set vl_e=null
    set vl_t=null
endfunction
function zzKS_QWE takes unit vl_h,unit vl_u returns nothing
    local integer vl_i=0
    local integer vl_ab
    loop
        exitwhen vl_i>2
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),260+vl_i)
        if vl_ab!=0 and GetUnitAbilityLevel(vl_h,vl_ab)>0 then
            call zzKS_Run(vl_h,vl_u,vl_ab,GetUnitX(vl_u),GetUnitY(vl_u))
        endif
        set vl_i=vl_i+1
    endloop
endfunction
function zzKS_DashHit takes unit vl_h,integer vl_ab,real vl_r,boolean vl_attach returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    local integer vl_n=0
    local real vl_d=zzKS_Hit(vl_h,vl_ab)
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),vl_r,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null or vl_n>=7
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            set vl_n=vl_n+1
            if LoadInteger(zzVL_ht,vl_ab,228)==0 then
                call zzVL_TpHit(vl_h,vl_u,vl_d)
            endif
            if LoadInteger(zzVL_ht,vl_ab,214)>0 and vl_n<=3 then
                call zzKS_QWE(vl_h,vl_u)
            endif
            if vl_attach then
                call zzKS_PopT(vl_ab,vl_u,"origin")
            else
                call zzKS_Pop(vl_ab,GetUnitX(vl_u),GetUnitY(vl_u))
            endif
            call zzKS_Status(vl_h,vl_u,vl_ab)
            call zzKS_Fx(vl_h,vl_u,vl_ab,vl_d)
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
endfunction
function zzKS_DashTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local real vl_a=LoadReal(zzVL_ht,vl_id,5)
    local real vl_s=LoadReal(zzVL_ht,vl_id,10)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,6)-1
    local real vl_x
    local real vl_y
    if vl_h==null or GetWidgetLife(vl_h)<.405 then
        set vl_n=-1
    else
        set vl_x=GetUnitX(vl_h)+vl_s*Cos(vl_a)
        set vl_y=GetUnitY(vl_h)+vl_s*Sin(vl_a)
        if not IsTerrainPathable(vl_x,vl_y,PATHING_TYPE_WALKABILITY) then
            if ModuloInteger(vl_n,3)==0 then
                call zzKS_Ghost(vl_h,vl_a)
            endif
            call SetUnitX(vl_h,vl_x)
            call SetUnitY(vl_h,vl_y)
        else
            set vl_n=0
        endif
    endif
    call SaveInteger(zzVL_ht,vl_id,6,vl_n)
    if vl_n<=0 then
        if vl_n==0 then
            call zzKS_DashHit(vl_h,LoadInteger(zzVL_ht,vl_id,4),LoadReal(zzVL_ht,vl_id,9),LoadBoolean(zzVL_ht,vl_id,11))
        endif
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
endfunction
function zzKS_Dash takes unit vl_h,integer vl_ab,real vl_x,real vl_y,real vl_r,integer vl_steps,boolean vl_attach returns nothing
    local timer vl_t=CreateTimer()
    local integer vl_id=GetHandleId(vl_t)
    local real vl_dist=SquareRoot((vl_x-GetUnitX(vl_h))*(vl_x-GetUnitX(vl_h))+(vl_y-GetUnitY(vl_h))*(vl_y-GetUnitY(vl_h)))
    call SaveUnitHandle(zzVL_ht,vl_id,0,vl_h)
    call SaveInteger(zzVL_ht,vl_id,4,vl_ab)
    call SaveReal(zzVL_ht,vl_id,5,Atan2(vl_y-GetUnitY(vl_h),vl_x-GetUnitX(vl_h)))
    call SaveReal(zzVL_ht,vl_id,9,vl_r)
    call SaveBoolean(zzVL_ht,vl_id,11,vl_attach)
    if vl_steps>0 then
        call SaveInteger(zzVL_ht,vl_id,6,vl_steps)
        call SaveReal(zzVL_ht,vl_id,10,vl_dist/vl_steps)
    else
        call SaveInteger(zzVL_ht,vl_id,6,IMaxBJ(1,R2I(vl_dist/48.)))
        call SaveReal(zzVL_ht,vl_id,10,48.)
    endif
    call SetUnitFacing(vl_h,Atan2(vl_y-GetUnitY(vl_h),vl_x-GetUnitX(vl_h))*bj_RADTODEG)
    call TimerStart(vl_t,.03125,true,function zzKS_DashTick)
    set vl_t=null
endfunction
// KVCT chain dash (Bon Loi Toan Long Thuong): 7 times every 0.3125 s, to an enemy not hit yet within 1000,
// 10 steps, hit radius 350 with the effect on each enemy; no damage / control on the hero meanwhile
function zzKS_ChainTick takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local group vl_done=LoadGroupHandle(zzVL_ht,vl_id,2)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)-1
    local group vl_g=CreateGroup()
    local unit vl_u
    local unit vl_pick=null
    local integer vl_p
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),1000.,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if vl_pick==null and zzVL_TpFoe(vl_h,vl_u) and not IsUnitInGroup(vl_u,vl_done) then
            set vl_pick=vl_u
        endif
    endloop
    call DestroyGroup(vl_g)
    if vl_pick!=null and GetWidgetLife(vl_h)>.405 then
        call GroupAddUnit(vl_done,vl_pick)
        call zzKS_Dash(vl_h,LoadInteger(zzVL_ht,vl_id,4),GetUnitX(vl_pick),GetUnitY(vl_pick),350.,10,true)
        set vl_p=GetPlayerId(GetOwningPlayer(vl_h))
        if vl_p<10 then
            set zzKS_dimm[vl_p]=TimerGetElapsed(zzVL_clock)+.4
            set zzKS_imm[vl_p]=TimerGetElapsed(zzVL_clock)+.4
        endif
    else
        set vl_n=0
    endif
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    if vl_n<=0 then
        call DestroyGroup(vl_done)
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
    set vl_done=null
    set vl_g=null
    set vl_pick=null
endfunction
function zzKS_Chain takes unit vl_h,integer vl_ab returns nothing
    local timer vl_t=CreateTimer()
    call SaveUnitHandle(zzVL_ht,GetHandleId(vl_t),0,vl_h)
    call SaveGroupHandle(zzVL_ht,GetHandleId(vl_t),2,CreateGroup())
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),3,8)
    call SaveInteger(zzVL_ht,GetHandleId(vl_t),4,vl_ab)
    call TimerStart(vl_t,.3125,true,function zzKS_ChainTick)
    set vl_t=null
endfunction
function zzKS_Aura takes nothing returns nothing
    local timer vl_t=GetExpiredTimer()
    local integer vl_id=GetHandleId(vl_t)
    local unit vl_h=LoadUnitHandle(zzVL_ht,vl_id,0)
    local integer vl_n=LoadInteger(zzVL_ht,vl_id,3)-1
    if vl_h!=null and GetWidgetLife(vl_h)>.405 then
        call zzKS_Area(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),350.,0.,-1.,LoadInteger(zzVL_ht,vl_id,4),zzKS_Atk(vl_h)*.35)
    else
        set vl_n=0
    endif
    call SaveInteger(zzVL_ht,vl_id,3,vl_n)
    if vl_n<=0 then
        call FlushChildHashtable(zzVL_ht,vl_id)
        call DestroyTimer(vl_t)
    endif
    set vl_t=null
    set vl_h=null
endfunction
function zzKS_BuffFx takes integer vl_p,integer vl_ab returns nothing
    local integer vl_f=LoadInteger(zzVL_ht,vl_ab,252)
    local unit vl_h=Jx[vl_p+1]
    local integer vl_lv=IMaxBJ(1,GetUnitAbilityLevel(vl_h,vl_ab))
    local timer vl_tm
    if BlzBitAnd(vl_f,16)>0 then
        call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+BlzGetUnitMaxHP(vl_h)*(.1+.02*vl_lv))
    endif
    if BlzBitAnd(vl_f,64)>0 then
        set zzKS_dimm[vl_p]=TimerGetElapsed(zzVL_clock)+3.
    endif
    if BlzBitAnd(vl_f,4096)>0 then
        call SetUnitState(vl_h,UNIT_STATE_MANA,GetUnitState(vl_h,UNIT_STATE_MANA)+BlzGetUnitMaxMana(vl_h)*(.15+.02*vl_lv))
    endif
    if BlzBitAnd(vl_f,8192)>0 and vl_p<10 then
        if TimerGetElapsed(zzVL_clock)>zzKS_stackEnd[vl_p] then
            set zzKS_stack[vl_p]=0
        endif
        call zzKS_StackAdd(vl_h,vl_p,vl_ab,I2R(IMaxBJ(8,LoadInteger(zzVL_ht,vl_ab,246))))
    endif
    if BlzBitAnd(vl_f,32)>0 then
        set vl_tm=CreateTimer()
        call SaveUnitHandle(zzVL_ht,GetHandleId(vl_tm),0,vl_h)
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),3,IMaxBJ(5,LoadInteger(zzVL_ht,vl_ab,246)))
        call SaveInteger(zzVL_ht,GetHandleId(vl_tm),4,vl_ab)
        call TimerStart(vl_tm,1.,true,function zzKS_Aura)
        set vl_tm=null
    endif
    set vl_h=null
endfunction
function zzKS_Buff takes integer vl_p,integer vl_ab,real vl_f returns nothing
    local integer vl_lv=IMaxBJ(1,GetUnitAbilityLevel(Jx[vl_p+1],vl_ab))
    local real vl_end=TimerGetElapsed(zzVL_clock)+I2R(IMaxBJ(8,LoadInteger(zzVL_ht,vl_ab,246)+LoadInteger(zzVL_ht,vl_ab,222)*vl_lv))
    local integer vl_s=LoadInteger(zzVL_ht,vl_ab,247)
    if vl_s>0 then
        set zzKS_buf[vl_p*16+vl_s]=R2I(zzKS_per[vl_s]*vl_lv*1.5*vl_f)
        if HaveSavedInteger(zzVL_ht,vl_ab,253) then
            set zzKS_buf[vl_p*16+vl_s]=R2I((LoadInteger(zzVL_ht,vl_ab,253)+LoadInteger(zzVL_ht,vl_ab,254)*vl_lv)*vl_f)
        endif
        set zzKS_bufEnd[vl_p*16+vl_s]=vl_end
    endif
    set vl_s=LoadInteger(zzVL_ht,vl_ab,248)
    if vl_s>0 then
        set zzKS_buf[vl_p*16+vl_s]=R2I(zzKS_per[vl_s]*vl_lv*1.5*vl_f)
        if HaveSavedInteger(zzVL_ht,vl_ab,255) then
            set zzKS_buf[vl_p*16+vl_s]=R2I((LoadInteger(zzVL_ht,vl_ab,255)+LoadInteger(zzVL_ht,vl_ab,256)*vl_lv)*vl_f)
        endif
        set zzKS_bufEnd[vl_p*16+vl_s]=vl_end
    endif
    call zzKS_SelfFx(vl_ab,Jx[vl_p+1],I2R(IMaxBJ(8,LoadInteger(zzVL_ht,vl_ab,246)+LoadInteger(zzVL_ht,vl_ab,222)*vl_lv)))
    // KVCT cast / buff layers of a buff skill (keys 280 282 284)
    if LoadStr(zzVL_ht,vl_ab,280)!=null and LoadStr(zzVL_ht,vl_ab,280)!="" then
        call DestroyEffect(AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,280),Jx[vl_p+1],"origin"))
    endif
    if LoadStr(zzVL_ht,vl_ab,284)!=null and LoadStr(zzVL_ht,vl_ab,284)!="" then
        call DestroyEffect(AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,284),Jx[vl_p+1],"chest"))
    endif
    if vl_f>=1. then
        call zzKS_BuffFx(vl_p,vl_ab)
    endif
    // KVCT Thoi Thua Luc Long: the buff ends after key 182 attacks / skills
    if vl_f>=1. and LoadInteger(zzVL_ht,vl_ab,182)>0 then
        set zzKS_bhN[vl_p]=LoadInteger(zzVL_ht,vl_ab,182)
        set zzKS_bhAb[vl_p]=vl_ab
    endif
endfunction
// one attack / skill used up a charge of a counted buff (key 182)
function zzKS_BhUse takes integer vl_p,integer vl_ab returns nothing
    local integer vl_b=zzKS_bhAb[vl_p]
    if zzKS_bhN[vl_p]<=0 or vl_ab==vl_b then
        return
    endif
    if TimerGetElapsed(zzVL_clock)>=zzKS_bufEnd[vl_p*16+LoadInteger(zzVL_ht,vl_b,247)] then
        set zzKS_bhN[vl_p]=0
        return
    endif
    set zzKS_bhN[vl_p]=zzKS_bhN[vl_p]-1
    if zzKS_bhN[vl_p]==0 then
        if LoadInteger(zzVL_ht,vl_b,247)>0 then
            set zzKS_bufEnd[vl_p*16+LoadInteger(zzVL_ht,vl_b,247)]=0.
        endif
        if LoadInteger(zzVL_ht,vl_b,248)>0 then
            set zzKS_bufEnd[vl_p*16+LoadInteger(zzVL_ht,vl_b,248)]=0.
        endif
        call zzVL_Text(Jx[vl_p+1],"|cff808080"+GetObjectName(vl_b)+" hết|r")
    endif
endfunction
function zzKS_OnCast takes nothing returns nothing
    local unit vl_h=GetTriggerUnit()
    local integer vl_ab=GetSpellAbilityId()
    local integer vl_k=LoadInteger(zzVL_ht,vl_ab,240)
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    local unit vl_t=GetSpellTargetUnit()
    local real vl_x=GetSpellTargetX()
    local real vl_y=GetSpellTargetY()
    local real vl_a
    local real vl_r
    local integer vl_i
    if vl_k==0 or vl_p>9 then
        set vl_h=null
        set vl_t=null
        return
    endif
    if LoadInteger(zzVL_ht,vl_ab,223)>0 then
        set zzKS_imm[vl_p]=RMaxBJ(zzKS_imm[vl_p],TimerGetElapsed(zzVL_clock)+LoadInteger(zzVL_ht,vl_ab,223))
    endif
    call zzKS_BhUse(vl_p,vl_ab)
    if LoadInteger(zzVL_ht,vl_ab,162)>0 and LoadInteger(zzVL_ht,vl_ab,165)!=3 then
        // KVCT Hon Phach Phi Duong: the enemies in front (key 160 far) are weakened
        call zzKS_WeakArea(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),IMaxBJ(300,LoadInteger(zzVL_ht,vl_ab,160)),GetUnitFacing(vl_h),LoadInteger(zzVL_ht,vl_ab,162),LoadInteger(zzVL_ht,vl_ab,161))
    endif
    if LoadInteger(zzVL_ht,vl_ab,195)>0 then
        call zzKS_Buff(vl_p,vl_ab,1.)
    endif
    // immune to damage for key 185 seconds, at most key 184 hits (KVCT Hang Long Bat Vu: 99% less damage, 30 hits)
    if LoadInteger(zzVL_ht,vl_ab,185)>0 then
        set zzKS_dimm[vl_p]=TimerGetElapsed(zzVL_clock)+LoadInteger(zzVL_ht,vl_ab,185)
        set zzKS_dimmN[vl_p]=LoadInteger(zzVL_ht,vl_ab,184)
    endif
    if vl_t!=null then
        set vl_x=GetUnitX(vl_t)
        set vl_y=GetUnitY(vl_t)
    elseif vl_x==0. and vl_y==0. then
        set vl_x=GetUnitX(vl_h)+100.*Cos(GetUnitFacing(vl_h)*bj_DEGTORAD)
        set vl_y=GetUnitY(vl_h)+100.*Sin(GetUnitFacing(vl_h)*bj_DEGTORAD)
    endif
    if vl_k==3 then
        set vl_a=Atan2(vl_y-GetUnitY(vl_h),vl_x-GetUnitX(vl_h))
        set vl_r=RMinBJ(zzKS_Rad(vl_ab,700.)+LoadInteger(zzVL_ht,vl_ab,196)*GetUnitAbilityLevel(vl_h,vl_ab),SquareRoot((vl_x-GetUnitX(vl_h))*(vl_x-GetUnitX(vl_h))+(vl_y-GetUnitY(vl_h))*(vl_y-GetUnitY(vl_h))))
        call zzKS_Dash(vl_h,vl_ab,GetUnitX(vl_h)+vl_r*Cos(vl_a),GetUnitY(vl_h)+vl_r*Sin(vl_a),200.,0,false)
    elseif vl_k==11 then
        call zzKS_Chain(vl_h,vl_ab)
    elseif vl_k==12 then
        call zzKS_Pop(vl_ab,GetUnitX(vl_h),GetUnitY(vl_h))
        call zzKS_Area(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),1000.,0.,-1.,vl_ab,zzKS_Hit(vl_h,vl_ab))
    elseif vl_k==13 then
        call zzKS_Field(vl_h,vl_ab,vl_x,vl_y)
    elseif vl_k==18 then
        call zzKS_Field(vl_h,vl_ab,GetUnitX(vl_h),GetUnitY(vl_h))
    elseif vl_k==14 or vl_k==21 then
        call zzKS_Toggle(vl_h,vl_ab)
    elseif vl_k==19 then
        // stealth (KVCT Ngu Tuyet An): invisible for key 246 seconds, the next attack ends it with the skill's buff
        call UnitAddAbility(vl_h,'Apiv')
        set zzKS_hideAb[vl_p]=vl_ab
        set zzKS_hideEnd[vl_p]=TimerGetElapsed(zzVL_clock)+LoadInteger(zzVL_ht,vl_ab,246)
        call zzKS_SelfFx(vl_ab,vl_h,I2R(LoadInteger(zzVL_ht,vl_ab,246)))
    elseif vl_k==20 then
        // charging toggle (KVCT Tuong Tu): on / off; while on, +1 charge every 2 s (max 20), each + key 198 + 197 x rank %
        // damage of the next Q W E (zzKS_Hit), spent by it
        if zzKS_chgOn[vl_p] then
            set zzKS_chgOn[vl_p]=false
            set zzKS_chg[vl_p]=0
            call RemoveSavedHandle(zzVL_ht,GetHandleId(vl_h),vl_ab)
            call zzVL_Text(vl_h,"|cffc0c0c0"+GetObjectName(vl_ab)+": tắt|r")
        else
            set zzKS_chgOn[vl_p]=true
            set zzKS_chgPct[vl_p]=LoadInteger(zzVL_ht,vl_ab,198)+LoadInteger(zzVL_ht,vl_ab,197)*GetUnitAbilityLevel(vl_h,vl_ab)
            set zzKS_chgNext[vl_p]=TimerGetElapsed(zzVL_clock)+2.
            call SaveUnitHandle(zzVL_ht,GetHandleId(vl_h),vl_ab,vl_h)
            call zzVL_Text(vl_h,"|cff80ff80"+GetObjectName(vl_ab)+": bật|r")
        endif
    elseif vl_k==15 then
        call zzKS_Curse(vl_h,vl_ab,vl_x,vl_y)
    elseif vl_k==6 then
        call zzKS_Buff(vl_p,vl_ab,1.)
    elseif vl_k==7 then
        set vl_i=0
        loop
            exitwhen vl_i>9
            if Jx[vl_i+1]!=null and GetWidgetLife(Jx[vl_i+1])>.405 and IsPlayerAlly(Player(vl_i),Player(vl_p)) and IsUnitInRange(Jx[vl_i+1],vl_h,1000.) then
                if vl_i==vl_p then
                    call zzKS_Buff(vl_i,vl_ab,1.)
                else
                    call zzKS_Buff(vl_i,vl_ab,.6)
                endif
            endif
            set vl_i=vl_i+1
        endloop
    elseif vl_k==9 then
        // ho thuan (Thuan Duong Vo Cuc ...): 85% of the current mana becomes a shield of (20+5*rank)% of the max mana
        call SetUnitState(vl_h,UNIT_STATE_MANA,GetUnitState(vl_h,UNIT_STATE_MANA)*.15)
        set zzVL_shield[vl_p]=BlzGetUnitMaxMana(vl_h)*(.2+.05*GetUnitAbilityLevel(vl_h,vl_ab))
        set zzVL_tpEnd[vl_p*12]=TimerGetElapsed(zzVL_clock)+I2R(IMaxBJ(8,LoadInteger(zzVL_ht,vl_ab,246)))
        call zzKS_SelfFx(vl_ab,vl_h,I2R(IMaxBJ(8,LoadInteger(zzVL_ht,vl_ab,246))))
        call zzVL_Text(vl_h,"|cff80c0ffHộ thuẫn "+I2S(R2I(zzVL_shield[vl_p]))+"|r")
    elseif vl_k==8 then
        // with stats (KVCT Tung Hoanh Bat Hoang: chi mang) it is a buff too
        if LoadInteger(zzVL_ht,vl_ab,247)>0 then
            call zzKS_Buff(vl_p,vl_ab,1.)
        else
            call zzKS_BuffFx(vl_p,vl_ab)
        endif
        set zzKS_imm[vl_p]=TimerGetElapsed(zzVL_clock)+I2R(IMaxBJ(4,LoadInteger(zzVL_ht,vl_ab,246)+LoadInteger(zzVL_ht,vl_ab,222)*GetUnitAbilityLevel(vl_h,vl_ab)))
        call PauseUnit(vl_h,false)
        call SetUnitPropWindow(vl_h,GetUnitDefaultPropWindow(vl_h)*bj_DEGTORAD)
        call zzKS_SelfFx(vl_ab,vl_h,I2R(IMaxBJ(4,LoadInteger(zzVL_ht,vl_ab,246)+LoadInteger(zzVL_ht,vl_ab,222)*GetUnitAbilityLevel(vl_h,vl_ab))))
    else
        call zzKS_Run(vl_h,vl_t,vl_ab,vl_x,vl_y)
    endif
    set vl_h=null
    set vl_t=null
endfunction
// the hero was hit (gameplay.j zzVL_OnDamageBody): KVCT passives that stack when hit (key 165 = 2, fx 8192)
function zzKS_OnHurt takes nothing returns nothing
    local unit vl_h=zzKS_tgt
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    local integer vl_i=0
    local integer vl_ab
    loop
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),200+vl_i)
        exitwhen vl_ab==0 or vl_i>15
        if LoadInteger(zzVL_ht,vl_ab,165)==2 and BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),8192)>0 and GetUnitAbilityLevel(vl_h,vl_ab)>0 then
            call zzKS_StackAdd(vl_h,vl_p,vl_ab,6.)
        endif
        // KVCT Me Hon Tran: when hit, the enemies around are weakened (key 162 %, 161 s, 160 radius), every key 220 s
        if LoadInteger(zzVL_ht,vl_ab,165)==3 and GetUnitAbilityLevel(vl_h,vl_ab)>0 and TimerGetElapsed(zzVL_clock)>=LoadReal(zzVL_ht,GetHandleId(vl_h),-vl_ab) then
            call SaveReal(zzVL_ht,GetHandleId(vl_h),-vl_ab,TimerGetElapsed(zzVL_clock)+IMaxBJ(1,LoadInteger(zzVL_ht,vl_ab,220)))
            call zzKS_WeakArea(vl_h,GetUnitX(vl_h),GetUnitY(vl_h),IMaxBJ(300,LoadInteger(zzVL_ht,vl_ab,160)),-1.,LoadInteger(zzVL_ht,vl_ab,162),LoadInteger(zzVL_ht,vl_ab,161))
            call zzVL_Text(vl_h,"|cffffcc00"+GetObjectName(vl_ab)+"|r")
        endif
        set vl_i=vl_i+1
    endloop
    set vl_h=null
endfunction
// a hero's normal attack hit (gameplay.j zzVL_OnDamageBody): skills without a key of their own strike on their own
function zzKS_OnHit takes nothing returns nothing
    local unit vl_h=zzKS_src
    local unit vl_t=zzKS_tgt
    local integer vl_i=0
    local integer vl_ab
    local integer vl_p=GetPlayerId(GetOwningPlayer(vl_h))
    if vl_p<10 then
        call zzKS_BhUse(vl_p,0)
    endif
    if vl_p<10 and zzKS_hideAb[vl_p]!=0 then
        set vl_ab=zzKS_hideAb[vl_p]
        set zzKS_hideAb[vl_p]=0
        call UnitRemoveAbility(vl_h,'Apiv')
        call zzKS_Buff(vl_p,vl_ab,1.)
        set zzKS_bufEnd[vl_p*16+LoadInteger(zzVL_ht,vl_ab,247)]=TimerGetElapsed(zzVL_clock)+(LoadInteger(zzVL_ht,vl_ab,199)+LoadInteger(zzVL_ht,vl_ab,174)*GetUnitAbilityLevel(vl_h,vl_ab))/10.
        set zzKS_bufEnd[vl_p*16+LoadInteger(zzVL_ht,vl_ab,248)]=TimerGetElapsed(zzVL_clock)+(LoadInteger(zzVL_ht,vl_ab,199)+LoadInteger(zzVL_ht,vl_ab,174)*GetUnitAbilityLevel(vl_h,vl_ab))/10.
        call zzVL_Text(vl_h,"|cffffcc00"+GetObjectName(vl_ab)+"|r")
    endif
    if GetUnitAbilityLevel(vl_t, 'Bdba') > 0 then
        call UnitRemoveAbility(vl_t, 'Bdba')
        set vl_ab = LoadInteger(zzVL_ht, GetUnitTypeId(vl_h), 260)
        if vl_ab != 0 and GetUnitAbilityLevel(vl_h, vl_ab) > 0 then
            set zzKS_repl = true
            call zzKS_Run(vl_h, vl_t, vl_ab, GetUnitX(vl_t), GetUnitY(vl_t))
        endif
    endif
    if GetUnitAbilityLevel(vl_t, 'Bpoa') > 0 then
        call UnitRemoveAbility(vl_t, 'Bpoa')
        set vl_ab = LoadInteger(zzVL_ht, GetUnitTypeId(vl_h), 261)
        if vl_ab != 0 and GetUnitAbilityLevel(vl_h, vl_ab) > 0 then
            set zzKS_repl = true
            call zzKS_Run(vl_h, vl_t, vl_ab, GetUnitX(vl_t), GetUnitY(vl_t))
        endif
    endif
    if GetUnitAbilityLevel(vl_t, 'Bhea') > 0 then
        call UnitRemoveAbility(vl_t, 'Bhea')
        set vl_ab = LoadInteger(zzVL_ht, GetUnitTypeId(vl_h), 262)
        if vl_ab != 0 and GetUnitAbilityLevel(vl_h, vl_ab) > 0 then
            set zzKS_repl = true
            call zzKS_Run(vl_h, vl_t, vl_ab, GetUnitX(vl_t), GetUnitY(vl_t))
        endif
    endif
    loop
        set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),200+vl_i)
        exitwhen vl_ab==0
        if BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),8192)>0 and vl_p<10 and LoadInteger(zzVL_ht,vl_ab,165)!=2 then
            if TimerGetElapsed(zzVL_clock)>zzKS_stackEnd[vl_p] then
                set zzKS_stack[vl_p]=0
            endif
            call zzKS_StackAdd(vl_h,vl_p,vl_ab,6.)
        endif
        if LoadInteger(zzVL_ht,vl_ab,216)>0 and vl_p<10 and GetUnitAbilityLevel(vl_h,vl_ab)>0 and TimerGetElapsed(zzVL_clock)>=LoadReal(zzVL_ht,GetHandleId(vl_h),-vl_ab) and GetRandomInt(1,100)<=LoadInteger(zzVL_ht,vl_ab,216)+LoadInteger(zzVL_ht,vl_ab,202)*GetUnitAbilityLevel(vl_h,vl_ab) then
            call SaveReal(zzVL_ht,GetHandleId(vl_h),-vl_ab,TimerGetElapsed(zzVL_clock)+LoadInteger(zzVL_ht,vl_ab,220))
            if LoadInteger(zzVL_ht,vl_ab,203)>0 then
                set zzKS_imm[vl_p]=RMaxBJ(zzKS_imm[vl_p],TimerGetElapsed(zzVL_clock)+(LoadInteger(zzVL_ht,vl_ab,203)+GetUnitAbilityLevel(vl_h,vl_ab))/10.)
                call zzKS_PopT(vl_ab,vl_h,"origin")
            endif
            if LoadInteger(zzVL_ht,vl_ab,247)>0 or LoadInteger(zzVL_ht,vl_ab,203)==0 then
                call zzKS_Buff(vl_p,vl_ab,1.)
            endif
            call zzVL_Text(vl_h,"|cffffcc00"+GetObjectName(vl_ab)+"|r")
            if LoadInteger(zzVL_ht,vl_ab,183)>0 then
                call zzKS_Slot(vl_h,vl_ab,GetUnitX(vl_t),GetUnitY(vl_t))
            endif
        endif
        if LoadInteger(zzVL_ht,vl_ab,249)==1 and GetUnitAbilityLevel(vl_h,vl_ab)>0 and GetRandomInt(1,100)<=10 then
            call zzKS_Run(vl_h,vl_t,vl_ab,GetUnitX(vl_t),GetUnitY(vl_t))
            set vl_ab=0
            set vl_i=99
        endif
        set vl_i=vl_i+1
    endloop
    set vl_h=null
    set vl_t=null
endfunction
function zzKS_Low takes integer vl_ab returns real
    if LoadInteger(zzVL_ht,vl_ab,189)>0 then
        return LoadInteger(zzVL_ht,vl_ab,189)/100.
    endif
    return .4
endfunction
function zzKS_Freeze takes unit vl_h,real vl_r,real vl_d returns nothing
    local group vl_g=CreateGroup()
    local unit vl_u
    call GroupEnumUnitsInRange(vl_g,GetUnitX(vl_h),GetUnitY(vl_h),vl_r,null)
    loop
        set vl_u=FirstOfGroup(vl_g)
        exitwhen vl_u==null
        call GroupRemoveUnit(vl_g,vl_u)
        if zzVL_TpFoe(vl_h,vl_u) then
            call zzKS_St(vl_h,vl_u,3,100,vl_d)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",vl_u,"origin"))
        endif
    endloop
    call DestroyGroup(vl_g)
    set vl_g=null
endfunction
// every second: open / rank up the skills by hero level, sum passives and buffs into zzKS_af (read by AffixSum)
function zzKS_Tick takes nothing returns nothing
    local integer vl_p=0
    local integer vl_i
    local integer vl_ab
    local integer vl_u
    local integer vl_lv
    local integer vl_w
    local integer vl_s
    local unit vl_h
    local unit vl_f=null
    local real vl_now=TimerGetElapsed(zzVL_clock)
    loop
        exitwhen vl_p>9
        set vl_h=Jx[vl_p+1]
        set vl_i=1
        loop
            exitwhen vl_i>14
            set zzKS_af[vl_p*16+vl_i]=0
            if vl_now<zzKS_bufEnd[vl_p*16+vl_i] then
                set zzKS_af[vl_p*16+vl_i]=zzKS_buf[vl_p*16+vl_i]
            endif
            set vl_i=vl_i+1
        endloop
        if vl_now<zzKS_stackEnd[vl_p] and zzKS_stack[vl_p]>0 then
            set zzKS_af[vl_p*16+5]=zzKS_af[vl_p*16+5]+zzKS_stack[vl_p]*4
            set zzKS_af[vl_p*16+3]=zzKS_af[vl_p*16+3]+zzKS_stack[vl_p]*2
        else
            set zzKS_stack[vl_p]=0
        endif
        set zzKS_refl[vl_p]=0
        if zzKS_hideAb[vl_p]!=0 and (vl_now>=zzKS_hideEnd[vl_p] or vl_h==null or GetWidgetLife(vl_h)<.405) then
            set zzKS_hideAb[vl_p]=0
            call UnitRemoveAbility(vl_h,'Apiv')
        endif
        if zzKS_chgOn[vl_p] and (vl_h==null or GetWidgetLife(vl_h)<.405) then
            set zzKS_chgOn[vl_p]=false
            set zzKS_chg[vl_p]=0
        endif
        if zzKS_chgOn[vl_p] and vl_now>=zzKS_chgNext[vl_p] then
            set zzKS_chgNext[vl_p]=vl_now+2.
            set zzKS_chg[vl_p]=IMinBJ(20,zzKS_chg[vl_p]+1)
            call zzVL_Text(vl_h,"|cffff80c0+"+I2S(zzKS_chg[vl_p])+"|r")
        endif
        set vl_i=0
        loop
            exitwhen vl_i>3
            set zzKS_pfx[vl_p*4+vl_i]=0
            set zzKS_pch[vl_p*4+vl_i]=0
            set zzKS_pdur[vl_p*4+vl_i]=0
            set zzKS_pmul[vl_p*4+vl_i]=0
            set zzKS_steal[vl_p*4+vl_i]=0
            set zzKS_xw[vl_p*4+vl_i]=0
            set zzKS_xc[vl_p*4+vl_i]=0
            set vl_i=vl_i+1
        endloop
        if vl_h!=null then
            call BlzUnitDisableAbility(vl_h,'Apat',true,true)
            if LoadInteger(zzVL_ht,GetHandleId(vl_h),271)==0 and LoadStr(zzVL_ht,GetUnitTypeId(vl_h),270)!=null then
                call SaveInteger(zzVL_ht,GetHandleId(vl_h),271,1)
                call AddSpecialEffectTarget(LoadStr(zzVL_ht,GetUnitTypeId(vl_h),270),vl_h,"weapon")
            endif
            set vl_lv=GetHeroLevel(vl_h)
            set vl_i=0
            loop
                set vl_ab=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),200+vl_i)
                exitwhen vl_ab==0
                set vl_u=LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),230+vl_i)
                if vl_lv>=vl_u then
                    set vl_w=IMinBJ(10,1+(vl_lv-vl_u)*10/IMaxBJ(1,201-vl_u))
                    // KVCT aura of a passive (key 287): an effect on the hero for as long as it has the skill
                    if LoadStr(zzVL_ht,vl_ab,287)!=null and LoadStr(zzVL_ht,vl_ab,287)!="" and LoadInteger(zzVL_ht,GetHandleId(vl_h),300000+vl_ab)==0 then
                        call SaveInteger(zzVL_ht,GetHandleId(vl_h),300000+vl_ab,1)
                        call AddSpecialEffectTarget(LoadStr(zzVL_ht,vl_ab,287),vl_h,"origin")
                    endif
                    if GetUnitAbilityLevel(vl_h,vl_ab)==0 then
                        call UnitAddAbility(vl_h,vl_ab)
                        call UnitMakeAbilityPermanent(vl_h,true,vl_ab)
                        if LoadStr(zzVL_ht,vl_ab,251)!=null and LoadStr(zzVL_ht,vl_ab,251)!="" then
                            call IssueImmediateOrder(vl_h,LoadStr(zzVL_ht,vl_ab,251))
                        endif
                        if GetPlayerController(Player(vl_p))==MAP_CONTROL_USER then
                            call zzVL_Msg(vl_p,"|cffff8000Lĩnh ngộ võ công:|r "+GetObjectName(vl_ab))
                        endif
                    endif
                    if GetUnitAbilityLevel(vl_h,vl_ab)!=vl_w then
                        call SetUnitAbilityLevel(vl_h,vl_ab,vl_w)
                    endif
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),1024)>0 and GetWidgetLife(vl_h)>.405 and GetWidgetLife(vl_h)<BlzGetUnitMaxHP(vl_h)*zzKS_Low(vl_ab) and vl_now>zzKS_lowCd[vl_p] and (LoadInteger(zzVL_ht,vl_ab,165)!=1 or vl_now-zzKS_hurt[vl_p]<=1.1) and (not HaveSavedInteger(zzVL_ht,vl_ab,217) or GetRandomInt(1,100)<=LoadInteger(zzVL_ht,vl_ab,217)+LoadInteger(zzVL_ht,vl_ab,169)*vl_w) then
                        if HaveSavedInteger(zzVL_ht,vl_ab,220) then
                            set zzKS_lowCd[vl_p]=vl_now+RMaxBJ(1.,LoadInteger(zzVL_ht,vl_ab,220)+LoadInteger(zzVL_ht,vl_ab,168)*(vl_w-1)/10.)
                            set zzKS_dimm[vl_p]=vl_now+LoadInteger(zzVL_ht,vl_ab,221)
                            if LoadInteger(zzVL_ht,vl_ab,218)>0 then
                                set zzKS_imm[vl_p]=RMaxBJ(zzKS_imm[vl_p],vl_now+LoadInteger(zzVL_ht,vl_ab,218))
                            endif
                            call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+BlzGetUnitMaxHP(vl_h)*LoadInteger(zzVL_ht,vl_ab,219)/100.)
                        else
                            set zzKS_lowCd[vl_p]=vl_now+30.
                            set zzKS_dimm[vl_p]=vl_now+4.
                            call SetWidgetLife(vl_h,GetWidgetLife(vl_h)+BlzGetUnitMaxHP(vl_h)*.1)
                        endif
                        call zzKS_PopT(vl_ab,vl_h,"origin")
                        call zzVL_Text(vl_h,"|cffffcc00"+GetObjectName(vl_ab)+"|r")
                        if LoadInteger(zzVL_ht,vl_ab,204)>0 then
                            call zzKS_Freeze(vl_h,400.,LoadInteger(zzVL_ht,vl_ab,204)/10.)
                        endif
                        if LoadInteger(zzVL_ht,vl_ab,183)>0 then
                            set vl_f=zzKS_Near(vl_h)
                            if vl_f!=null then
                                call zzKS_Slot(vl_h,vl_ab,GetUnitX(vl_f),GetUnitY(vl_f))
                            endif
                        endif
                    endif
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and LoadInteger(zzVL_ht,vl_ab,212)>0 and GetWidgetLife(vl_h)>.405 and vl_now>=LoadReal(zzVL_ht,GetHandleId(vl_h),-vl_ab) then
                        call SaveReal(zzVL_ht,GetHandleId(vl_h),-vl_ab,vl_now+(LoadInteger(zzVL_ht,vl_ab,212)-LoadInteger(zzVL_ht,vl_ab,211)*vl_w)/10.)
                        set zzKS_dimm[vl_p]=RMaxBJ(zzKS_dimm[vl_p],vl_now+1.)
                        set zzKS_imm[vl_p]=RMaxBJ(zzKS_imm[vl_p],vl_now+1.)
                        call zzKS_PopT(vl_ab,vl_h,"origin")
                    endif
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),128)>0 then
                        set zzKS_refl[vl_p]=zzKS_refl[vl_p]+2*vl_w
                    endif
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and BlzBitAnd(LoadInteger(zzVL_ht,vl_ab,252),4096)>0 then
                        call SetUnitState(vl_h,UNIT_STATE_MANA,GetUnitState(vl_h,UNIT_STATE_MANA)+12.*vl_w)
                    endif
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and HaveSavedInteger(zzVL_ht,vl_ab,239) then
                        set vl_s=LoadInteger(zzVL_ht,vl_ab,239)
                        set zzKS_pfx[vl_p*4+vl_s]=BlzBitOr(zzKS_pfx[vl_p*4+vl_s],LoadInteger(zzVL_ht,vl_ab,245))
                        // KVCT time of the passive's weakening (fx 512), key 164 seconds
                        if LoadInteger(zzVL_ht,vl_ab,164)>0 then
                            set zzKS_pdur[vl_p*4+vl_s]=LoadInteger(zzVL_ht,vl_ab,164)
                        endif
                        // KVCT numbers of the passive's extra hit (fx 65536): chance key 180 + 177 x rank %, damage key 179 + 178 x rank %
                        if LoadInteger(zzVL_ht,vl_ab,180)>0 then
                            set zzKS_pch[vl_p*4+vl_s]=LoadInteger(zzVL_ht,vl_ab,180)+LoadInteger(zzVL_ht,vl_ab,177)*vl_w
                            set zzKS_pmul[vl_p*4+vl_s]=LoadInteger(zzVL_ht,vl_ab,179)+LoadInteger(zzVL_ht,vl_ab,178)*vl_w
                        endif
                        if vl_s<3 and LoadInteger(zzVL_ht,vl_ab,209)>0 then
                            set zzKS_xw[vl_p*4+vl_s]=LoadInteger(zzVL_ht,vl_ab,209)
                            set zzKS_xc[vl_p*4+vl_s]=LoadInteger(zzVL_ht,vl_ab,208)
                        endif
                        if vl_s<3 then
                            set zzKS_steal[vl_p*4+vl_s]=zzKS_steal[vl_p*4+vl_s]+LoadInteger(zzVL_ht,vl_ab,231)*vl_w
                        else
                            set zzKS_steal[vl_p*4]=zzKS_steal[vl_p*4]+LoadInteger(zzVL_ht,vl_ab,231)*vl_w
                            set zzKS_steal[vl_p*4+1]=zzKS_steal[vl_p*4+1]+LoadInteger(zzVL_ht,vl_ab,231)*vl_w
                            set zzKS_steal[vl_p*4+2]=zzKS_steal[vl_p*4+2]+LoadInteger(zzVL_ht,vl_ab,231)*vl_w
                        endif
                    endif
                    // (a passive that buffs on attacks, key 216, gives its stats only while the buff lasts)
                    if LoadInteger(zzVL_ht,vl_ab,240)==0 and LoadInteger(zzVL_ht,vl_ab,216)==0 then
                        set vl_s=LoadInteger(zzVL_ht,vl_ab,247)
                        if vl_s>0 then
                            set zzKS_af[vl_p*16+vl_s]=zzKS_af[vl_p*16+vl_s]+R2I(zzKS_per[vl_s]*vl_w)
                        endif
                        set vl_s=LoadInteger(zzVL_ht,vl_ab,248)
                        if vl_s>0 then
                            set zzKS_af[vl_p*16+vl_s]=zzKS_af[vl_p*16+vl_s]+R2I(zzKS_per[vl_s]*vl_w)
                        endif
                    endif
                endif
                set vl_i=vl_i+1
            endloop
        endif
        set vl_p=vl_p+1
    endloop
    set vl_h=null
endfunction
// ---- skill bar at the bottom (KVCT style): the 7 keyed skills, the sect skill (G) and a potion button;
// icon, key, rank, cooldown seconds; a click presses the key. The 6 item buttons of the game are hidden.
function zzKS_BarAb takes unit vl_h,integer vl_k returns integer
    if vl_h==null then
        return 0
    elseif vl_k<7 then
        return LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),260+vl_k)
    elseif vl_k==7 then
        return LoadInteger(zzVL_ht,GetUnitTypeId(vl_h),50)
    endif
    return 0
endfunction
function zzKS_BarTick takes nothing returns nothing
    local integer vl_p=GetPlayerId(GetLocalPlayer())
    local unit vl_h=null
    local integer vl_k=0
    local integer vl_ab
    local integer vl_lv
    local real vl_cd
    local integer vl_n
    if vl_p<10 then
        set vl_h=Jx[vl_p+1]
    endif
    loop
        exitwhen vl_k>8
        if vl_k==8 then
            set vl_n=0
            if vl_h!=null then
                set vl_ab=0
                loop
                    exitwhen vl_ab>5
                    if UnitItemInSlot(vl_h,vl_ab)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_ab)),57)>0 then
                        set vl_n=vl_n+GetItemCharges(UnitItemInSlot(vl_h,vl_ab))
                    endif
                    set vl_ab=vl_ab+1
                endloop
            endif
            call BlzFrameSetText(zzKS_bCd[8],"")
            call BlzFrameSetText(zzKS_bLv[8],I2S(vl_n))
            call BlzFrameSetVisible(zzKS_bBtn[8],vl_h!=null)
        else
            set vl_ab=zzKS_BarAb(vl_h,vl_k)
            set vl_lv=0
            if vl_ab!=0 then
                set vl_lv=GetUnitAbilityLevel(vl_h,vl_ab)
            endif
            call BlzFrameSetVisible(zzKS_bBtn[vl_k],vl_lv>0)
            if vl_lv>0 then
                call BlzFrameSetTexture(zzKS_bIco[vl_k],BlzGetAbilityIcon(vl_ab),0,true)
                set vl_cd=BlzGetUnitAbilityCooldownRemaining(vl_h,vl_ab)
                call BlzFrameSetText(zzKS_bLv[vl_k],I2S(vl_lv))
                if vl_cd>.05 then
                    call BlzFrameSetText(zzKS_bCd[vl_k],"|cffffffff"+I2S(R2I(vl_cd+.99))+"|r")
                    call BlzFrameSetVisible(zzKS_bDim[vl_k],true)
                else
                    call BlzFrameSetText(zzKS_bCd[vl_k],"")
                    call BlzFrameSetVisible(zzKS_bDim[vl_k],false)
                endif
            endif
        endif
        set vl_k=vl_k+1
    endloop
    set vl_h=null
endfunction
function zzKS_BarClick takes nothing returns nothing
    local integer vl_k=LoadInteger(zzVL_ht,GetHandleId(BlzGetTriggerFrame()),7)
    local player vl_pl=GetTriggerPlayer()
    local unit vl_h=Jx[GetPlayerId(vl_pl)+1]
    local integer vl_i=0
    local item vl_best=null
    if GetLocalPlayer()==vl_pl then
        call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
    endif
    if vl_k==8 then
        loop
            exitwhen vl_i>5
            if UnitItemInSlot(vl_h,vl_i)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_i)),57)>0 and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_i)),57)<=GetHeroLevel(vl_h) then
                if vl_best==null or LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_i)),57)>LoadInteger(zzVL_ht,GetItemTypeId(vl_best),57) then
                    set vl_best=UnitItemInSlot(vl_h,vl_i)
                endif
            endif
            set vl_i=vl_i+1
        endloop
        if vl_best!=null then
            call UnitUseItem(vl_h,vl_best)
        endif
    elseif GetLocalPlayer()==vl_pl then
        call ForceUIKey(zzKS_bKey[vl_k])
    endif
    set vl_pl=null
    set vl_h=null
    set vl_best=null
endfunction
function zzKS_BarInit takes nothing returns nothing
    local framehandle vl_ui=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local trigger vl_t=CreateTrigger()
    local integer vl_k=0
    local real vl_x
    local framehandle vl_f
    call TriggerAddAction(vl_t,function zzKS_BarClick)
    set zzKS_bKey[0]="Q"
    set zzKS_bKey[1]="W"
    set zzKS_bKey[2]="E"
    set zzKS_bKey[3]="R"
    set zzKS_bKey[4]="D"
    set zzKS_bKey[5]="F"
    set zzKS_bKey[6]="T"
    set zzKS_bKey[7]="G"
    set zzKS_bKey[8]="Thuốc"
    call zzVL_Panel(vl_ui,.226,.183,.574,.137,"war3mapImported\\vl_ui_tile.blp",215)
    loop
        exitwhen vl_k>8
        set vl_x=.232+vl_k*.038
        set zzKS_bBtn[vl_k]=BlzCreateFrameByType("GLUEBUTTON","",vl_ui,"ScoreScreenTabButtonTemplate",0)
        call BlzFrameSetAbsPoint(zzKS_bBtn[vl_k],FRAMEPOINT_TOPLEFT,vl_x,.179)
        call BlzFrameSetSize(zzKS_bBtn[vl_k],.034,.034)
        set zzKS_bIco[vl_k]=BlzCreateFrameByType("BACKDROP","",zzKS_bBtn[vl_k],"",0)
        call BlzFrameSetAllPoints(zzKS_bIco[vl_k],zzKS_bBtn[vl_k])
        if vl_k==8 then
            call BlzFrameSetTexture(zzKS_bIco[vl_k],"ReplaceableTextures\\CommandButtons\\BTNPotionGreenSmall.blp",0,true)
        endif
        set zzKS_bDim[vl_k]=BlzCreateFrameByType("BACKDROP","",zzKS_bIco[vl_k],"",0)
        call BlzFrameSetAllPoints(zzKS_bDim[vl_k],zzKS_bBtn[vl_k])
        call BlzFrameSetTexture(zzKS_bDim[vl_k],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0,true)
        call BlzFrameSetAlpha(zzKS_bDim[vl_k],170)
        call BlzFrameSetVisible(zzKS_bDim[vl_k],false)
        set zzKS_bCd[vl_k]=BlzCreateFrameByType("TEXT","",zzKS_bIco[vl_k],"",0)
        call BlzFrameSetAllPoints(zzKS_bCd[vl_k],zzKS_bBtn[vl_k])
        call BlzFrameSetTextAlignment(zzKS_bCd[vl_k],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(zzKS_bCd[vl_k],1.3)
        set vl_f=BlzCreateFrameByType("TEXT","",zzKS_bIco[vl_k],"",0)
        call BlzFrameSetPoint(vl_f,FRAMEPOINT_TOPLEFT,zzKS_bBtn[vl_k],FRAMEPOINT_TOPLEFT,.002,-.001)
        call BlzFrameSetSize(vl_f,.032,.012)
        call BlzFrameSetText(vl_f,"|cffffcc00"+zzKS_bKey[vl_k]+"|r")
        call BlzFrameSetScale(vl_f,.8)
        set zzKS_bLv[vl_k]=BlzCreateFrameByType("TEXT","",zzKS_bIco[vl_k],"",0)
        call BlzFrameSetPoint(zzKS_bLv[vl_k],FRAMEPOINT_BOTTOMRIGHT,zzKS_bBtn[vl_k],FRAMEPOINT_BOTTOMRIGHT,-.002,.002)
        call BlzFrameSetSize(zzKS_bLv[vl_k],.02,.012)
        call BlzFrameSetTextAlignment(zzKS_bLv[vl_k],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
        call SaveInteger(zzVL_ht,GetHandleId(zzKS_bBtn[vl_k]),7,vl_k)
        call BlzTriggerRegisterFrameEvent(vl_t,zzKS_bBtn[vl_k],FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(zzKS_bBtn[vl_k],false)
        set vl_k=vl_k+1
    endloop
    set vl_k=0
    loop
        exitwhen vl_k>5
        call BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON,vl_k),false)
        set vl_k=vl_k+1
    endloop
    call TimerStart(CreateTimer(),.1,true,function zzKS_BarTick)
    call DestroyTimer(GetExpiredTimer())
    set vl_ui=null
    set vl_t=null
    set vl_f=null
endfunction
function zzKS_Init takes nothing returns nothing
    local trigger vl_t=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(vl_t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(vl_t,function zzKS_OnCast)
    // per rank: 1 hut sinh luc, 3 bao kich, 4 toc danh, 5 sat thuong %, 6 giam sat thuong, 7 sinh luc, 11 phong thu
    set zzKS_per[1]=1.
    set zzKS_per[2]=1.
    set zzKS_per[3]=1.
    set zzKS_per[4]=3.
    set zzKS_per[5]=2.
    set zzKS_per[6]=1.
    set zzKS_per[7]=80.
    set zzKS_per[11]=1.
    set zzKS_per[13]=4.
    set zzKS_per[14]=2.
    call TimerStart(CreateTimer(),1.,true,function zzKS_Tick)
    set vl_t=null
endfunction
