// ---- Nhóm GEMDROP: rơi bảo thạch IG<loại><bậc> giống Huyền tinh (tools/config.py mục 13): không mở khóa theo phút,
// mỗi lần giết có tỉ lệ rơi theo loại quái, loại (1..6) và bậc ngẫu nhiên trong khoảng của loại quái đó.
// Phụ thuộc: gameplay_14_gem.j (zzGM_Code). File này phải nối SAU gameplay_14_gem.j.
// Số liệu do tools/kvequip.py ghi vào zzVL_ht (khóa cha 0), vl_kind = 0 thường, 1 Tinh Anh, 2 Thủ Lĩnh, 3 Boss:
//   363 bật (1) / tắt (0), 370+kind bậc thấp nhất, 380+kind bậc cao nhất, 390+kind tỉ lệ %, 365+kind số viên.

// Hàm công khai: rơi bảo thạch theo loại quái tại (x,y). Gọi từ zzDR_DropKind.
function zzGD_Drop takes integer vl_kind,real vl_x,real vl_y,unit vl_hero returns nothing
    local integer vl_k=IMinBJ(3,IMaxBJ(0,vl_kind))
    local integer vl_n
    local integer vl_code
    local item vl_it
    if vl_hero==null or LoadInteger(zzVL_ht,0,363)<=0 then
        return
    endif
    if GetRandomInt(1,100)>LoadInteger(zzVL_ht,0,390+vl_k) then
        return
    endif
    set vl_n=IMaxBJ(1,LoadInteger(zzVL_ht,0,365+vl_k))
    loop
        exitwhen vl_n<=0
        set vl_code=zzGM_Code(GetRandomInt(1,6),GetRandomInt(LoadInteger(zzVL_ht,0,370+vl_k),LoadInteger(zzVL_ht,0,380+vl_k)))
        if vl_code!=0 then
            set vl_it=CreateItem(vl_code,vl_x+GetRandomReal(-40.,40.),vl_y+GetRandomReal(-40.,40.))
            set vl_it=null
        endif
        set vl_n=vl_n-1
    endloop
endfunction
