import re

with open(r'D:\vltk-dev-clone\tools\gameplay.j', 'r', encoding='utf-8') as f:
    content = f.read()

m1 = re.search(r'  endif\s+set vl_n=vl_n-1\s+endloop\s+if vl_s!="" then', content)
print("Match 1:", bool(m1))

m2 = re.search(r'  set zzVL_af\[vl_pid\*16\+vl_i\]=0\s+set vl_i=vl_i\+1\s+endloop\s+set vl_i=0', content)
print("Match 2:", bool(m2))

m3 = re.search(r'  set zzVL_af\[vl_pid\*16\+vl_k\]=zzVL_af\[vl_pid\*16\+vl_k\]\+LoadInteger\(zzVL_ht,vl_id,30\+vl_k\)\s+set vl_k=vl_k\+1\s+endloop\s+endif\s+set vl_i=vl_i\+1', content)
print("Match 3:", bool(m3))

m4 = re.search(r'  if zzVL_af\[vl_pt\*16\+6\]>=50 then\s+set vl_d=vl_d\*\.5\s+else\s+set vl_d=vl_d\*\(1\.-zzVL_af\[vl_pt\*16\+6\]/100\.\)\s+endif\s+endif', content)
print("Match 4:", bool(m4))
