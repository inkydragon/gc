# -*- coding: UTF-8 -*-

import requests
from bs4 import BeautifulSoup
import time
import random
import csv
import re

START_PAGE = 155
END_PAGE  = 364
FORUM_ID = 4
LINK_BASE = 'https://www.lightnovel.us/'
url0 = LINK_BASE + 'forum-{}-{}.html'.format(FORUM_ID, START_PAGE)

headers = {
    'referer': url0,
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'Accept-Encoding': 'gzip, deflate, br',
    'accept-language': 'zh-CN,zh;q=0.9'
}

# cookies = requests.cookies.RequestsCookieJar()
# cookies.set('PHPSESSID', 'imtgcvbcjvtb2filvh1ss6m7bijfhar4',
#     domain='www.wenku8.net', path='/')
# cookies.set('jieqiUserInfo', 'jieqiUserId%3D532528%2CjieqiUserName%3Dwoclass%2CjieqiUserGroup%3D3%2CjieqiUserName_un%3Dwoclass%2CjieqiUserLogin%3D1564046286',
#     domain='www.wenku8.net', path='/')
# cookies.set('jieqiVisitInfo', 'jieqiUserLogin%3D1564046286%2CjieqiUserId%3D532528',
#     domain='www.wenku8.net', path='/')

r0 = requests.get(url0, 
    headers=headers
    # cookies=cookies
)
cookies = r0.cookies.get_dict()

# 保存为 CSV
now = time.strftime("%Y-%m-%d@%H+%M+%S", time.localtime())
fname = 'lncn-shareTXT_thread-{}_{}.csv'.format(START_PAGE, now)
csvfile = open(fname, 'w', encoding="utf-8", newline='')
spamwriter = csv.writer(csvfile,
    delimiter=',',
)
spamwriter.writerow([ # 写表头
    'type', # th_title,
    'thread title', 'url'
])

url = LINK_BASE + 'forum-{}-{}.html'.format(FORUM_ID, 1)

# 爬取所有页面
for i in range(START_PAGE, END_PAGE+1):
    slp_time = random.randint(7, 17)
    print('\nwill sleep[', slp_time, '] s')
    time.sleep(slp_time)
    url = LINK_BASE + 'forum-{}-{}.html'.format(FORUM_ID, i)
    # print(url)

    ## 单次爬取开始
    print('scarpy page: ', url, '\n=====\n')
    for _ in range(5):
        try:
            response = requests.get(url,
                headers=headers,
                cookies=cookies
            )
            response.raise_for_status()
            if response.status_code == 200:
                break
        except:
            continue

    # response = requests.get(url,
    #     headers=headers,
    #     cookies=cookies
    # )
    headers['referer'] = url
    for k, v in response.cookies.get_dict().items():
        cookies[k] = v
    # cookies = response.cookies.get_dict()
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, "html.parser")
    ths = soup.find_all('tbody', id=re.compile('normalthread'))
    th = ths[0]
    for th in ths:
        th_link = LINK_BASE + th.select('.xst')[0]['href']
        th_title = th.select('.xst')[0].string
        th_type = ""

        def is_novel(s):
            mojin = '魔法禁书目录' in s
            pari = ('[' in s) and (']' in s)
            txt = ('txt' in s) or ('TXT' in s)
            chatu = ('插图' in s) or ('插圖' in s)
            DuanPian_ZiFan = ('自翻' in s) or ('短篇' in s)

            return mojin or (pari and (txt or chatu or DuanPian_ZiFan))
        
        if th.em.a:
            th_type = th.em.a.string
        else:
            if not is_novel(th_title):
                print('; '.join([
                    th_title , th_link
                ]))
                continue

        print('; '.join([
            "[{}]".format(th_type),
            th_title #, th_link
        ]))
        spamwriter.writerow([
            th_type,
            th_title, th_link
        ])
        ## 提取单页信息 结束 END

    ## 爬取所有页面 结束 END

