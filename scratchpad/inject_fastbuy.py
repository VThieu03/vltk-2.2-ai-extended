import os

with open('tools/gameplay.j', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the swap first
content = content.replace("call TriggerAddAction(vl_t,function zzVL_OnWinChat)\n  set vl_t=CreateTrigger()\n  set vl_i=0\n  loop\n  exitwhen vl_i>9\n  call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),\"-win \",false)\n  set vl_i=vl_i+1\n  endloop\n  call TriggerAddAction(vl_t,function zzVL_OnChat)", 
"call TriggerAddAction(vl_t,function zzVL_OnChat)\n  set vl_t=CreateTrigger()\n  set vl_i=0\n  loop\n  exitwhen vl_i>9\n  call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),\"-win \",false)\n  set vl_i=vl_i+1\n  endloop\n  call TriggerAddAction(vl_t,function zzVL_OnWinChat)")

# Now add fast-buy logic
fast_buy_jass = """
function zzVL_OnFastBuy takes nothing returns nothing
  local player p = GetTriggerPlayer()
  local integer pid = GetPlayerId(p)
  local unit hero = Jx[pid+1]
  local string msg = GetEventPlayerChatString()
  local string cmd = SubString(msg, 0, 4)
  local integer amount = S2I(SubString(msg, 4, StringLength(msg)))
  local integer cost = amount
  local integer current_knb = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
  
  if hero == null then
    call zzVL_Msg(pid, "Chưa chọn tướng.")
    return
  endif
  
  if amount <= 0 then
    return
  endif
  
  if current_knb < cost then
    call zzVL_Msg(pid, "Không đủ " + I2S(cost) + " KNB.")
    return
  endif
  
  call SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, current_knb - cost)
  
  if cmd == "-sm " then
    call SetHeroStr(hero, GetHeroStr(hero, false) + amount, true)
    call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Sức mạnh.")
  elseif cmd == "-tp " then
    call SetHeroAgi(hero, GetHeroAgi(hero, false) + amount, true)
    call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Thân pháp.")
  elseif cmd == "-tt " then
    call SetHeroInt(hero, GetHeroInt(hero, false) + amount, true)
    call zzVL_Msg(pid, "Đã mua " + I2S(amount) + " Nội công / Trí tuệ.")
  endif
endfunction
"""

# Insert the function before zzVL_Quest
content = content.replace("function zzVL_Quest takes nothing returns nothing", fast_buy_jass + "\nfunction zzVL_Quest takes nothing returns nothing")

# Register the commands in zzVL_Quest
register_fast_buy = """
  set vl_t=CreateTrigger()
  set vl_i=0
  loop
  exitwhen vl_i>9
  call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-sm ",false)
  call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-tp ",false)
  call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-tt ",false)
  set vl_i=vl_i+1
  endloop
  call TriggerAddAction(vl_t,function zzVL_OnFastBuy)
"""

content = content.replace("call TriggerAddAction(vl_t,function zzVL_OnWinChat)", "call TriggerAddAction(vl_t,function zzVL_OnWinChat)\n" + register_fast_buy)

with open('tools/gameplay.j', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done!")
