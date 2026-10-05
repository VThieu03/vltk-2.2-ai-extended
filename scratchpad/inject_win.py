import os

with open('tools/gameplay.j', 'r', encoding='utf-8') as f:
    content = f.read()

win_func = """function zzVL_CheckWin takes nothing returns nothing
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
function zzVL_OnWinChat takes nothing returns nothing
local string vl_s=GetEventPlayerChatString()
local string vl_args=SubString(vl_s,5,StringLength(vl_s))
set zzVL_winKills=S2I(vl_args)
call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10.,"|cffffcc00Mốc mạng chiến thắng thay đổi thành: |r"+I2S(zzVL_winKills)+" mạng.")
endfunction
"""

content = content.replace('function zzVL_OnDeath takes nothing returns nothing', win_func + 'function zzVL_OnDeath takes nothing returns nothing')

# Inject call to zzVL_CheckWin in zzVL_OnDeath
content = content.replace('set zzVL_teamK[1]=zzVL_teamK[1]+1\nendif\nendif\ncall zzVL_Log', 'set zzVL_teamK[1]=zzVL_teamK[1]+1\nendif\ncall zzVL_CheckWin()\nendif\ncall zzVL_Log')

# Add -win registration in zzVL_Init
win_reg = """call TriggerAddAction(vl_t,function zzVL_OnWinChat)
set vl_t=CreateTrigger()
set vl_i=0
loop
exitwhen vl_i>9
call TriggerRegisterPlayerChatEvent(vl_t,Player(vl_i),"-win ",false)
set vl_i=vl_i+1
endloop
"""

content = content.replace('call TriggerAddAction(vl_t,function zzVL_OnChat)', win_reg + 'call TriggerAddAction(vl_t,function zzVL_OnChat)')

with open('tools/gameplay.j', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
