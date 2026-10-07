import ast,collections
t=ast.parse(open('tools/kskill.py',encoding='utf-8').read())
for n in t.body:
    if isinstance(n,ast.Assign) and getattr(n.targets[0],'id','')=='OVR':
        c=collections.Counter(k.value for k in n.value.keys)
        print("dups:",[k for k,v in c.items() if v>1])
