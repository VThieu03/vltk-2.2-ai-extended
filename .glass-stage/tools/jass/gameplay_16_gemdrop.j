// ---- Nhóm GEMDROP: rơi bảo thạch IG<loại><bậc> theo lịch phút (docs/BAOTHACH_SPEC.md, tools/config.py mục 13)
// Phụ thuộc: gameplay_14_gem.j (zzGM_Code), zzVL_clock / zzVL_ht (gameplay_01_core.j). File này phải nối SAU gameplay_14_gem.j.
// Số liệu do Python ghi vào zzVL_ht (parent 0):
//   360 = rơi bù 1/N phần thiếu mỗi lần giết, 361 = tối đa viên mỗi lần giết (thường), 362 = tối đa viên mỗi lần giết (boss),
//   363 = bật (1) / tắt (0), 370+bậc = phút mở bậc, 380+bậc = tốc độ mục tiêu (viên/phút *1000), 390+bậc = số viên mục tiêu ngay lúc mở bậc.
// Số viên đã rơi cho từng người: zzVL_ht, 6300+người, khóa = bậc (1..9).

// Mục tiêu tích lũy (số viên) của một bậc tại phút vl_min: 0 trước khi mở, sau đó tăng đều theo phút.
function zzGD_Target takes integer vl_t,real vl_min returns real
    local real vl_open=I2R(LoadInteger(zzVL_ht,0,370+vl_t))
    if vl_min<vl_open then
        return 0.
    endif
    return LoadInteger(zzVL_ht,0,390+vl_t)+LoadInteger(zzVL_ht,0,380+vl_t)/1000.*(vl_min-vl_open)
endfunction

// Phần còn thiếu (>=0) của một bậc so với lịch.
function zzGD_Deficit takes integer vl_p,integer vl_t,real vl_min returns real
    local real vl_d=zzGD_Target(vl_t,vl_min)-LoadInteger(zzVL_ht,6300+vl_p,vl_t)
    if vl_d<0. then
        return 0.
    endif
    return vl_d
endfunction

// Chọn bậc rơi, trọng số = phần còn thiếu của từng bậc (bậc mới mở rơi ít viên nên hiếm, bậc cũ dồi dào). 0 = không cần rơi.
function zzGD_PickTier takes integer vl_p,real vl_min returns integer
    local real vl_sum=0.
    local real vl_r
    local integer vl_t=1
    loop
        exitwhen vl_t>9
        set vl_sum=vl_sum+zzGD_Deficit(vl_p,vl_t,vl_min)
        set vl_t=vl_t+1
    endloop
    if vl_sum<=0. then
        return 0
    endif
    set vl_r=GetRandomReal(0.,vl_sum)
    set vl_t=1
    loop
        exitwhen vl_t>9
        set vl_r=vl_r-zzGD_Deficit(vl_p,vl_t,vl_min)
        if vl_r<=0. then
            return vl_t
        endif
        set vl_t=vl_t+1
    endloop
    return 9
endfunction

// Hàm công khai: rơi bảo thạch theo mức (0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss) tại (x,y) cho tướng vl_hero. Gọi từ zzDR_DropKind.
function zzGD_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_p
    local real vl_min
    local real vl_sum=0.
    local real vl_want
    local integer vl_n
    local integer vl_max
    local integer vl_t
    local integer vl_code
    local item vl_it
    if vl_hero==null or LoadInteger(zzVL_ht,0,363)<=0 or LoadInteger(zzVL_ht,0,360)<=0 then
        return
    endif
    set vl_p=GetPlayerId(GetOwningPlayer(vl_hero))
    if vl_p>9 then
        return
    endif
    set vl_min=TimerGetElapsed(zzVL_clock)/60.
    set vl_t=1
    loop
        exitwhen vl_t>9
        set vl_sum=vl_sum+zzGD_Deficit(vl_p,vl_t,vl_min)
        set vl_t=vl_t+1
    endloop
    if vl_sum<=0. then
        return
    endif
    set vl_want=vl_sum/LoadInteger(zzVL_ht,0,360)
    set vl_max=LoadInteger(zzVL_ht,0,361)
    if vl_kind==1 then
        set vl_want=vl_want*1.5
    elseif vl_kind==2 then
        set vl_want=vl_want*2.
    elseif vl_kind>=3 then
        set vl_want=vl_want*3.
        set vl_max=LoadInteger(zzVL_ht,0,362)
    endif
    set vl_n=R2I(vl_want)
    if GetRandomReal(0.,1.)<vl_want-I2R(vl_n) then
        set vl_n=vl_n+1
    endif
    if vl_n>vl_max then
        set vl_n=vl_max
    endif
    loop
        exitwhen vl_n<=0
        set vl_t=zzGD_PickTier(vl_p,vl_min)
        exitwhen vl_t<=0
        set vl_code=zzGM_Code(GetRandomInt(1,6),vl_t)
        if vl_code!=0 then
            set vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
            set vl_it=null
        endif
        call SaveInteger(zzVL_ht,6300+vl_p,vl_t,LoadInteger(zzVL_ht,6300+vl_p,vl_t)+1)
        set vl_n=vl_n-1
    endloop
endfunction
