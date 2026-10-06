import re

with open(r'D:\vltk-dev-clone\tools\gameplay.j', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove Phi Phong item creation in zzVL_GiveCloak
givecloak_old = """  loop
  exitwhen vl_i>5
  set vl_it=UnitItemInSlot(vl_h,vl_i)
  if vl_it!=null and LoadInteger(zzVL_ht,GetItemTypeId(vl_it),1)>0 then
  call RemoveItem(vl_it)
  endif
  set vl_i=vl_i+1
  endloop
  set vl_it=CreateItem(zzVL_cloak[vl_r],GetUnitX(vl_h),GetUnitY(vl_h))
  call SetItemUserData(vl_it,vl_pid+1)
  if not UnitAddItem(vl_h,vl_it) then
  call zzVL_Msg(vl_pid,"|cffff8000Túi đồ đã đầy: phi phong nằm dưới chân tướng.|r")
  endif
  if zzVL_tag[vl_pid]==null then"""

givecloak_new = """  if zzVL_tag[vl_pid]==null then"""

content = content.replace(givecloak_old, givecloak_new)

# 2. Fix the message when ranking up in zzVL_GiveCloak
content = content.replace('  call zzVL_All(zzVL_Name(vl_pid)+" nhận "+GetItemName(vl_it)+", danh hiệu "+zzVL_tn[vl_r])\n  set vl_h=null\n  set vl_it=null',
                          '  call zzVL_All(zzVL_Name(vl_pid)+" nhận danh hiệu "+zzVL_tn[vl_r])\n  set vl_h=null')

# 3. Add invisible stats to zzVL_AffixSum
affixsum_old = """  if zzVL_wel[vl_pid]==1 then
  set zzVL_af[vl_pid*16+6]=zzVL_af[vl_pid*16+6]+8
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+300
  endif
  if zzVL_bcd[vl_pid]<=0. then"""

affixsum_new = """  if zzVL_wel[vl_pid]==1 then
  set zzVL_af[vl_pid*16+6]=zzVL_af[vl_pid*16+6]+8
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+300
  endif
  if zzVL_rank[vl_pid]==1 then
  set zzVL_af[vl_pid*16+11]=zzVL_af[vl_pid*16+11]+4
  set zzVL_af[vl_pid*16+8]=zzVL_af[vl_pid*16+8]+1
  set zzVL_af[vl_pid*16+9]=zzVL_af[vl_pid*16+9]+1
  set zzVL_af[vl_pid*16+10]=zzVL_af[vl_pid*16+10]+1
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+200
  elseif zzVL_rank[vl_pid]==2 then
  set zzVL_af[vl_pid*16+11]=zzVL_af[vl_pid*16+11]+8
  set zzVL_af[vl_pid*16+8]=zzVL_af[vl_pid*16+8]+2
  set zzVL_af[vl_pid*16+9]=zzVL_af[vl_pid*16+9]+2
  set zzVL_af[vl_pid*16+10]=zzVL_af[vl_pid*16+10]+2
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+400
  elseif zzVL_rank[vl_pid]==3 then
  set zzVL_af[vl_pid*16+11]=zzVL_af[vl_pid*16+11]+12
  set zzVL_af[vl_pid*16+8]=zzVL_af[vl_pid*16+8]+4
  set zzVL_af[vl_pid*16+9]=zzVL_af[vl_pid*16+9]+4
  set zzVL_af[vl_pid*16+10]=zzVL_af[vl_pid*16+10]+4
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+400
  elseif zzVL_rank[vl_pid]==4 then
  set zzVL_af[vl_pid*16+11]=zzVL_af[vl_pid*16+11]+16
  set zzVL_af[vl_pid*16+8]=zzVL_af[vl_pid*16+8]+6
  set zzVL_af[vl_pid*16+9]=zzVL_af[vl_pid*16+9]+6
  set zzVL_af[vl_pid*16+10]=zzVL_af[vl_pid*16+10]+6
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+600
  elseif zzVL_rank[vl_pid]==5 then
  set zzVL_af[vl_pid*16+11]=zzVL_af[vl_pid*16+11]+20
  set zzVL_af[vl_pid*16+8]=zzVL_af[vl_pid*16+8]+8
  set zzVL_af[vl_pid*16+9]=zzVL_af[vl_pid*16+9]+8
  set zzVL_af[vl_pid*16+10]=zzVL_af[vl_pid*16+10]+8
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+800
  endif
  if zzVL_bcd[vl_pid]<=0. then"""

content = content.replace(affixsum_old, affixsum_new)

# 4. Patch descriptions
content = content.replace('Mỗi bậc +2% sát thương và một phi phong.', 'Mỗi bậc +2% sát thương và tự động nâng cấp chỉ số phi phong ẩn.')
content = content.replace('mỗi quân hàm nhận một phi phong mạnh hơn kèm danh hiệu trên đầu: Hiệu Úy - Siêu Phàm, Thống Lĩnh - Xuất Trần, Phó Tướng - Kinh Thế, Đại Tướng - Ỷ Thiên, Nguyên Soái - |cffff6000Chí Tôn|r. Phi phong không bỏ, không bán được.',
                          'mỗi quân hàm tự động nâng cấp chỉ số phi phong ẩn (tăng sinh lực, giáp, thuộc tính) và nhận danh hiệu trên đầu: Hiệu Úy - Siêu Phàm, Thống Lĩnh - Xuất Trần, Phó Tướng - Kinh Thế, Đại Tướng - Ỷ Thiên, Nguyên Soái - |cffff6000Chí Tôn|r. Phi phong tự gắn vào nhân vật, không chiếm ô hành trang.')

with open(r'D:\vltk-dev-clone\tools\gameplay.j', 'w', encoding='utf-8') as f:
    f.write(content)

print("gameplay.j patched for cloaks!")
