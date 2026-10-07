// ---- interface of VLKT 2.396 (Silva.Fox), rebuilt with its frame templates (dl\ek_frame.fdf) and textures:
// game console moved off screen, bottom frame (minimap, hp / mp bars, name, level, 12 command buttons in a row),
// gold / KNB panels, "Luc Chien" badge (tai phu), hero text at the top left. Same positions as VLKT.
function zzUI_B2S takes boolean vl_b returns string
    if vl_b then
        return "co"
    endif
    return "khong"
endfunction
function zzUI_Tex takes string vl_f,integer vl_lv returns framehandle
    local framehandle vl_p=BlzCreateSimpleFrame("TestTexture",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0)
    call BlzFrameSetTexture(BlzGetFrameByName("TestTextureValue",0),vl_f,0,true)
    call BlzFrameSetLevel(vl_p,vl_lv)
    call BlzFrameClearAllPoints(vl_p)
    return vl_p
endfunction
function zzUI_At takes framehandle vl_f,real vl_w,real vl_h,real vl_x,real vl_y returns nothing
    call BlzFrameSetAbsPoint(vl_f,FRAMEPOINT_TOPRIGHT,vl_x+vl_w,vl_y+vl_h)
    call BlzFrameSetAbsPoint(vl_f,FRAMEPOINT_BOTTOMLEFT,vl_x,vl_y)
endfunction
function zzUI_Text takes string vl_s,real vl_x0,real vl_y0,real vl_x1,real vl_y1,real vl_sc,textaligntype vl_v,textaligntype vl_h returns framehandle
    local framehandle vl_f=BlzCreateSimpleFrame("TextUnitLevel",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0)
    call BlzFrameSetLevel(vl_f,6)
    set vl_f=BlzGetFrameByName("TextUnitLevelValue",0)
    call BlzFrameSetText(vl_f,vl_s)
    call BlzFrameSetAbsPoint(vl_f,FRAMEPOINT_TOPLEFT,vl_x0,vl_y0)
    call BlzFrameSetAbsPoint(vl_f,FRAMEPOINT_BOTTOMRIGHT,vl_x1,vl_y1)
    call BlzFrameSetScale(vl_f,vl_sc)
    call BlzFrameSetTextAlignment(vl_f,vl_v,vl_h)
    return vl_f
endfunction
function zzUI_Tick takes nothing returns nothing
    local integer vl_p=GetPlayerId(GetLocalPlayer())
    local unit vl_h=null
    local integer vl_hp=0
    local integer vl_mp=0
    local integer vl_i=0
    local integer vl_tp=0
    local framehandle vl_f
    if vl_p<10 then
        set vl_h=Jx[vl_p+1]
    endif
    if vl_h!=null then
        set vl_hp=IMinBJ(100,IMaxBJ(0,R2I(100.*GetWidgetLife(vl_h)/RMaxBJ(1.,BlzGetUnitMaxHP(vl_h)))))
        set vl_mp=IMinBJ(100,IMaxBJ(0,R2I(100.*GetUnitState(vl_h,UNIT_STATE_MANA)/RMaxBJ(1.,BlzGetUnitMaxMana(vl_h)))))
        call BlzFrameSetText(zzUI_hpT,I2S(R2I(GetWidgetLife(vl_h)))+"/"+I2S(BlzGetUnitMaxHP(vl_h)))
        call BlzFrameSetText(zzUI_mpT,I2S(R2I(GetUnitState(vl_h,UNIT_STATE_MANA)))+"/"+I2S(BlzGetUnitMaxMana(vl_h)))
        call BlzFrameSetText(zzUI_name,"|cffffcc00"+GetHeroProperName(vl_h)+"|r")
        call BlzFrameSetText(zzUI_cls,"|cffffcc00"+GetUnitName(vl_h)+"|r")
        call BlzFrameSetText(zzUI_lv,"|cffFFCC00Cấp: "+I2S(GetHeroLevel(vl_h))+"|r")
        call BlzFrameSetTexture(zzUI_icon,BlzGetAbilityIcon(GetUnitTypeId(vl_h)),0,true)
        call BlzFrameSetText(zzUI_info,"|cffffcc00"+GetHeroProperName(vl_h)+"|r - "+GetUnitName(vl_h)+"|n|cff00ff00Sinh lực: "+I2S(R2I(GetWidgetLife(vl_h)))+" ("+I2S(vl_hp)+"%)|r|n|cffff8040Ngoại công: "+I2S(BlzGetUnitBaseDamage(vl_h,0))+"|r|n|cff8080ffNội công: "+I2S(GetHeroInt(vl_h,true))+"|r|n|cffffcc00Phòng thủ: "+I2S(R2I(BlzGetUnitArmor(vl_h)))+"|r")
        loop
            exitwhen vl_i>5
            if UnitItemInSlot(vl_h,vl_i)!=null and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_i)),0)>=10 and LoadInteger(zzVL_ht,GetItemTypeId(UnitItemInSlot(vl_h,vl_i)),0)<50 then
                set vl_tp=vl_tp+zzVL_GearScore(UnitItemInSlot(vl_h,vl_i))
            endif
            set vl_i=vl_i+1
        endloop
        call BlzFrameSetText(zzUI_power,"|cffffcc00"+I2S(vl_tp)+"|r")
    endif
    call BlzFrameSetText(zzUI_gold,"|cffffffff"+I2S(GetPlayerState(GetLocalPlayer(),PLAYER_STATE_RESOURCE_GOLD))+"|r")
    call BlzFrameSetText(zzUI_knb,"|cffffff00"+I2S(GetPlayerState(GetLocalPlayer(),PLAYER_STATE_RESOURCE_LUMBER))+"|r")
    if vl_hp!=zzUI_lastHp then
        call BlzFrameSetVisible(zzUI_hp[zzUI_lastHp],false)
        call BlzFrameSetVisible(zzUI_hp[vl_hp],vl_h!=null)
        set zzUI_lastHp=vl_hp
    endif
    if vl_mp!=zzUI_lastMp then
        call BlzFrameSetVisible(zzUI_mp[zzUI_lastMp],false)
        call BlzFrameSetVisible(zzUI_mp[vl_mp],vl_h!=null)
        set zzUI_lastMp=vl_mp
    endif
    set vl_i=0
    loop
        exitwhen vl_i>11
        set vl_f=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,vl_i)
        call BlzFrameClearAllPoints(vl_f)
        if vl_i <= 4 then
            call zzUI_At(vl_f,.03556,.03556,99.,99.)
        else
            call zzUI_At(vl_f,.03556,.03556,.37+.035*(vl_i-5),.012)
        endif
        set vl_i=vl_i+1
    endloop
    set vl_h=null
endfunction
// heroes: the 12 command buttons show the skills first (VLKT hides move / stop / hold / attack / patrol buttons)
function zzUI_Hide takes nothing returns nothing
    local integer vl_p=0
    loop
        exitwhen vl_p>9
        // We no longer disable abilities here, so move/attack still work
        set vl_p=vl_p+1
    endloop
endfunction
function zzUI_Init takes nothing returns nothing
    local integer vl_i=0
    local framehandle vl_f
    if BlzLoadTOCFile("dl\\ek_frame.toc") then
        call zzVL_Log("giao dien: nap ek_frame.toc ok")
    else
        call zzVL_Log("giao dien: KHONG nap duoc ek_frame.toc")
    endif
    call BlzEnableUIAutoPosition(false)
    call BlzFrameSetAbsPoint(BlzGetFrameByName("ConsoleUI",0),FRAMEPOINT_BOTTOM,.4,-.38)
    call BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0),false)
    call BlzFrameSetAllPoints(BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0),BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0))
    call BlzFrameSetVisible(BlzGetFrameByName("ResourceBarFrame",0),true)
    call zzUI_At(BlzGetFrameByName("ResourceBarGoldText",0),.001,.001,99,99)
    call zzUI_At(BlzGetFrameByName("ResourceBarLumberText",0),.001,.001,99,99)
    call zzUI_At(BlzGetFrameByName("ResourceBarSupplyText",0),.001,.001,99,99)
    call zzUI_At(BlzGetFrameByName("ResourceBarUpkeepText",0),.001,.001,99,99)
    call zzUI_At(zzUI_Tex("VLKT_Data\\VLKT_FrameUI_Bottom3.blp",5),.8,.195555556,.00045,0)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_UNIT_MSG,0),FRAMEPOINT_BOTTOMLEFT,0.,.2)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_UNIT_MSG,0),FRAMEPOINT_BOTTOMRIGHT,.8,.2)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG,0),FRAMEPOINT_BOTTOMLEFT,0.,.18)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG,0),FRAMEPOINT_BOTTOMRIGHT,.8,.18)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP,0),FRAMEPOINT_BOTTOMLEFT,.48,.158)
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP,0),FRAMEPOINT_BOTTOMRIGHT,.7645,.158)
    call BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP,0),true)
    // Move hero bar out of screen so F1 still works
    call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR,0),FRAMEPOINT_TOPRIGHT,99.,99.)
    // hp / mp bars: one picture per percent, as VLKT
    loop
        exitwhen vl_i>100
        set zzUI_hp[vl_i]=zzUI_Tex("war3mapImported\\HPBar"+I2S(vl_i)+".blp",6)
        call zzUI_At(zzUI_hp[vl_i],.101,.012,.25583,.05799)
        call BlzFrameSetVisible(zzUI_hp[vl_i],false)
        set zzUI_mp[vl_i]=zzUI_Tex("war3mapImported\\MPBar"+I2S(vl_i)+".blp",6)
        call zzUI_At(zzUI_mp[vl_i],.101,.012,.25583,.04261)
        call BlzFrameSetVisible(zzUI_mp[vl_i],false)
        set vl_i=vl_i+1
    endloop
    set zzUI_lastHp=0
    set zzUI_lastMp=0
    // the 12 command buttons in one row over the bottom frame
    set vl_i=0
    loop
        exitwhen vl_i>11
        set vl_f=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,vl_i)
        call BlzFrameSetVisible(BlzFrameGetParent(vl_f),true)
        call BlzFrameClearAllPoints(vl_f)
        call BlzFrameSetLevel(vl_f,7)
        call zzUI_At(vl_f,.03556,.03556,.37+.035*vl_i,.012)
        set vl_i=vl_i+1
    endloop
    // hero portrait (icon), name, class, level, hp / mp numbers
    set vl_f=zzUI_Tex("war3mapImported\\UIButton_trong.blp",6)
    call zzUI_At(vl_f,.06,.06,.17,.02)
    set zzUI_icon=BlzCreateFrameByType("BACKDROP","",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetAbsPoint(zzUI_icon,FRAMEPOINT_BOTTOMLEFT,.179,.029)
    call BlzFrameSetAbsPoint(zzUI_icon,FRAMEPOINT_TOPRIGHT,.221,.071)
    set zzUI_name=zzUI_Text(" ",.25783,.0868,.38208,.0723,1.6,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
    set zzUI_cls=zzUI_Text(" ",.24783,.0368,.37208,.0223,1.3,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
    set zzUI_lv=zzUI_Text(" ",.14697,.03827,.23137,.0115,1.3,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_MIDDLE)
    set zzUI_hpT=zzUI_Text(" ",.262,.0685,.34464,.0585,1.1,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_MIDDLE)
    set zzUI_mpT=zzUI_Text(" ",.262,.053,.34464,.043,1.1,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_MIDDLE)
    // top: gold / KNB panels, Luc Chien badge (tai phu), hero text
    call zzUI_At(zzUI_Tex("VLKT_Data\\FrameUI_infopanel1.blp",6),.07444,.0223,.4871,.57993)
    set zzUI_gold=zzUI_Text(" ",.51377,.59937,.55821,.5827,1.25,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
    call zzUI_At(zzUI_Tex("VLKT_Data\\FrameUI_infopanel2.blp",6),.07444,.0223,.57644,.57993)
    set zzUI_knb=zzUI_Text(" ",.6031,.59937,.64755,.5827,1.25,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
    call zzUI_At(zzUI_Tex("war3mapImported\\lucchien.blp",5),.13167,.04111,.31401,.56097)
    set zzUI_power=zzUI_Text(" ",.36985,.59358,.43985,.57016,2.0,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_MIDDLE)
    set zzUI_info=zzUI_Text(" ",-.085,.59,.12,.49,1.25,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
    call zzVL_Log("giao dien: o lenh 0 hien="+zzUI_B2S(BlzFrameIsVisible(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,0)))+" cha hien="+zzUI_B2S(BlzFrameIsVisible(BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,0))))+" TestTexture="+zzUI_B2S(BlzGetFrameByName("TestTextureValue",0)!=null))
    call TimerStart(CreateTimer(),.1,true,function zzUI_Tick)
    call TimerStart(CreateTimer(),1.,true,function zzUI_Hide)
    set vl_f=null
endfunction
// typed "-vlkt": try the VLKT interface (off by default: it moves the game console)
function zzUI_OnChat takes nothing returns nothing
    if not zzUI_on then
        set zzUI_on=true
        call zzUI_Init()
    endif
endfunction
function zzUI_Setup takes nothing returns nothing
    if not zzUI_on then
        set zzUI_on=true
        call zzUI_Init()
    endif
endfunction
