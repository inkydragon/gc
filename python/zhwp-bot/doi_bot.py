# encoding:UTF-8
#  [GitHub - 5j9/citer: An online citation generator for Wikipedia](https://github.com/5j9/citer)

import urllib.parse 
import urllib.request
from bs4 import BeautifulSoup
import re

def doi2ref(doi):
    headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'
    }
    
    # 构造URL参数
    url = "https://tools.wmflabs.org/citer/citer.fcgi"
    params = { ## input_type=url-doi-isbn & user_input=10.1111/j.1600-0404.1986.tb04634.x & dateformat=%Y-%m-%d
        'input_type': 'url-doi-isbn',
        'user_input': '10.1111/j.1600-0404.1986.tb04634.x',
        'dateformat': '%Y-%m-%d'
        }
    params['user_input'] = doi
    data = urllib.parse.urlencode(params)
    geturl = url + "?" + data 

    # 请求网页
    req = urllib.request.Request(geturl, headers=headers)
    content = urllib.request.urlopen(req)
    
    # 网页请求 状态监测
    if( content.status != 200 ):
        exit()
    # print('ok')

    # 解析网页
    html = content.read()
    ''' print(html)
    fo = open("./1.html", "wb+")
    fo.write(html)
    fo.close()   '''

    soup = BeautifulSoup(html, "html.parser")

    ref_raw_text = soup.find(id='named_ref').string
    
    # 正则参数
    cite_pattern = r'(<ref name=".+">){1}({{cite journal.+}})(</ref>)'
    flags = re.I # 大小写不敏感
    doi_res = re.search(cite_pattern, ref_raw_text)
    cite_text = doi_res.group(2)

    return cite_text

# for test
''' doi = "10.1007/s11244-013-0189-9"
ref = doi2ref(doi)
print(ref) '''