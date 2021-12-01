# encoding:UTF-8

import urllib.parse 
import urllib.request 
from bs4 import BeautifulSoup

def doi2ref(doi):
    proxies = {
        'https': 'https://127.0.0.1:1080',
        'http': 'http://127.0.0.1:1080'
    }
    headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'
    }
    url = "https://reftag.appspot.com/doiweb.py"


    '''     
    params = {
        'doi': '10.1111/j.1600-0404.1986.tb04634.x'
        }
    data = urllib.parse.urlencode(params)
    geturl = url + "?" + data 
    '''
    geturl = url + "?doi=" + doi

    # 设置SS代理
    proxy_support = urllib.request.ProxyHandler(proxies)
    opener = urllib.request.build_opener(proxy_support)
    urllib.request.install_opener(opener)

    # 请求网页
    req = urllib.request.Request(geturl, headers=headers)
    content = urllib.request.urlopen(req)
    
    # 网页请求 状态监测
    if( content.status != 200 ):
        exit()
    # print('ok')

    # 解析网页
    html = content.read().decode()
    soup = BeautifulSoup(html, "html.parser")

    ref_raw_text = soup.textarea.string
    # print(ref_raw_text)

    return ref_raw_text

# for test
''' doi = "10.1007/s11244-013-0189-9"
ref = doi2ref(doi)
print(ref) '''


# - [html - Python：爬虫如何翻墙并保存获取到的数据？ - SegmentFault 思否](https://segmentfault.com/q/1010000008986220)

''' 
print('--------------使用urllib--------------')
google_url = 'https://www.google.com'
opener = request.build_opener(request.ProxyHandler(proxies))
request.install_opener(opener)

req = request.Request(google_url, headers=headers)
response = request.urlopen(req)

print(response.read().decode())

print('--------------使用requests--------------')
response = requests.get(google_url, proxies=proxies)
print(response.text) '''