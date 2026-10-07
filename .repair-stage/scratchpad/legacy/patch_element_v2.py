import re

with open(r'D:\vltk-dev-clone\tools\gameplay.j', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Patch zzVL_RollAffix
def patch_roll(match):
    return """  endif
  set vl_n=vl_n-1
  endloop
  if LoadInteger(zzVL_ht,GetItemTypeId(vl_it),0)/10 != 3 then
  set vl_k=GetRandomInt(1,5)
  call SaveInteger(zzVL_ht,vl_id,75,vl_k)
  if vl_k==1 then
  set vl_s=vl_s+"|n|cffffd700Hệ Kim|r"
  elseif vl_k==2 then
  set vl_s=vl_s+"|n|cff40c040Hệ Mộc|r"
  elseif vl_k==3 then
  set vl_s=vl_s+"|n|cffc08040Hệ Thổ|r"
  elseif vl_k==4 then
  set vl_s=vl_s+"|n|cff4080ffHệ Thủy|r"
  elseif vl_k==5 then
  set vl_s=vl_s+"|n|cffff4040Hệ Hỏa|r"
  endif
  set vl_s=vl_s+" (Kháng "+I2S(10)+"%, kích ẩn: +5% ST, +200 HP)"
  endif
  if vl_s!="" then"""

content = re.sub(r'  endif\s+set vl_n=vl_n-1\s+endloop\s+if vl_s!="" then', patch_roll, content)

# 2. Patch zzVL_AffixSum (Inject into the loop that clears stats)
def patch_clear(match):
    return """  set zzVL_af[vl_pid*16+vl_i]=0
  set vl_i=vl_i+1
  endloop
  call SaveInteger(zzVL_ht, 1000+vl_pid, 1, 0)
  call SaveInteger(zzVL_ht, 1000+vl_pid, 2, 0)
  call SaveInteger(zzVL_ht, 1000+vl_pid, 3, 0)
  call SaveInteger(zzVL_ht, 1000+vl_pid, 4, 0)
  call SaveInteger(zzVL_ht, 1000+vl_pid, 5, 0)
  set vl_i=0"""

content = re.sub(r'  set zzVL_af\[vl_pid\*16\+vl_i\]=0\s+set vl_i=vl_i\+1\s+endloop\s+set vl_i=0', patch_clear, content)

# 3. Patch zzVL_AffixSum (Inject into the item loop)
def patch_sum(match):
    return """  set zzVL_af[vl_pid*16+vl_k]=zzVL_af[vl_pid*16+vl_k]+LoadInteger(zzVL_ht,vl_id,30+vl_k)
  set vl_k=vl_k+1
  endloop
  set vl_k=LoadInteger(zzVL_ht,vl_id,75)
  if vl_k>0 then
  call SaveInteger(zzVL_ht, 1000+vl_pid, vl_k, LoadInteger(zzVL_ht, 1000+vl_pid, vl_k) + 10)
  if vl_k == zzVL_he[vl_pid] then
  set zzVL_af[vl_pid*16+5]=zzVL_af[vl_pid*16+5]+5
  set zzVL_af[vl_pid*16+7]=zzVL_af[vl_pid*16+7]+200
  endif
  endif
  endif
  set vl_i=vl_i+1"""

content = re.sub(r'  set zzVL_af\[vl_pid\*16\+vl_k\]=zzVL_af\[vl_pid\*16\+vl_k\]\+LoadInteger\(zzVL_ht,vl_id,30\+vl_k\)\s+set vl_k=vl_k\+1\s+endloop\s+endif\s+set vl_i=vl_i\+1', patch_sum, content)

# 4. Patch zzVL_OnDamageBody (Inject resistance)
def patch_dmg(match):
    return """  if zzVL_af[vl_pt*16+6]>=50 then
  set vl_d=vl_d*.5
  else
  set vl_d=vl_d*(1.-zzVL_af[vl_pt*16+6]/100.)
  endif
  endif
  if vl_pt<10 and vl_tgt==Jx[vl_pt+1] and vl_ps<10 and zzVL_he[vl_ps]>0 then
  set vl_a=LoadInteger(zzVL_ht, 1000+vl_pt, zzVL_he[vl_ps])
  if vl_a>0 then
  if vl_a>=80 then
  set vl_a=80
  endif
  set vl_d=vl_d*(1.-vl_a/100.)
  endif
  endif"""

content = re.sub(r'  if zzVL_af\[vl_pt\*16\+6\]>=50 then\s+set vl_d=vl_d\*\.5\s+else\s+set vl_d=vl_d\*\(1\.-zzVL_af\[vl_pt\*16\+6\]/100\.\)\s+endif\s+endif', patch_dmg, content)


with open(r'D:\vltk-dev-clone\tools\gameplay.j', 'w', encoding='utf-8') as f:
    f.write(content)

print("gameplay.j properly patched!")
