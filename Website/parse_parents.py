from html import unescape
import re
import sys
sys.stdout.reconfigure(encoding='utf-8')
with open('hasaki.html','r',encoding='utf-8',errors='ignore') as f:
    text=f.read()
pattern=r'<a class="parent_menu"[^>]*href="([^"]*)"[^>]*>(.*?)</a>'
seen=set()
for href,label_html in re.findall(pattern,text,re.S):
    label=re.sub(r'<[^>]+>','',label_html).strip()
    if not label:
        continue
    label=unescape(label)
    if label in seen:
        continue
    seen.add(label)
    print(label, href)
