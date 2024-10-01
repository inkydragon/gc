# -*- coding: UTF-8 -*-

import requests
from bs4 import BeautifulSoup
import time
import random
import csv

START_PAGE = 126

headers = {
    'referer': 'https://www.wenku8.net/modules/article/articlelist.php',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'Accept-Encoding': 'gzip, deflate, br',
    'accept-language': 'zh-CN,zh;q=0.9'
}

cookies = requests.cookies.RequestsCookieJar()
cookies.set('PHPSESSID', 'imtgcvbcjvtb2filvh1ss6m7bijfhar4',
    domain='www.wenku8.net', path='/')
cookies.set('jieqiUserInfo', 'jieqiUserId%3D532528%2CjieqiUserName%3Dwoclass%2CjieqiUserGroup%3D3%2CjieqiUserName_un%3Dwoclass%2CjieqiUserLogin%3D1564046286',
    domain='www.wenku8.net', path='/')
cookies.set('jieqiVisitInfo', 'jieqiUserLogin%3D1564046286%2CjieqiUserId%3D532528',
    domain='www.wenku8.net', path='/')

url = 'https://www.wenku8.net/modules/article/articlelist.php?page=11'

# 保存为 CSV
now = time.strftime("%Y-%m-%d@%H+%M+%S", time.localtime())
fname = 'ln_' + str(START_PAGE) + '+_' + now + '.csv'
csvfile = open(fname, 'w', encoding="utf-8", newline='')
spamwriter = csv.writer(csvfile,
    delimiter=',',
)
spamwriter.writerow([ # 写表头
    'title', # ln_title,
    'author name', 'wenku name', 'state',  # author_name, wenku_name, state,
    'last update', 'abstract'  # last_update, abstract
])


# 爬取所有页面
# for i in range(1, 128):
for i in range(START_PAGE, 128):
    slp_time = random.randint(7, 13)
    print('will sleep[', slp_time, '] s')
    time.sleep(slp_time)
    url = 'https://www.wenku8.net/modules/article/articlelist.php?page='
    url += str(i)
    # print(url)

    ## 单次爬取开始
    print('scarpy page: ', url, '\n=====\n')
    response = requests.get(url,
        headers=headers,
        cookies=cookies
    )
    response.encoding = 'gbk'

    soup = BeautifulSoup(response.text, "html.parser")
    for ln in soup.select("#content > table.grid > tr > td > div")[1:]:
        ln_title = ln.div.a['title']
        ln_img_src = ln.div.img['src']
        ln_page_link = ln.div.a['href']

        ln_info = ln.select('div > p')[0].string
        info = list( map(lambda s: s.split(':'), ln_info.split('/')) )
        if list(map(lambda s: len(s), info)) == [2, 2, 2]:
            author_name =   info[0][1]
            wenku_name =    info[1][1]
            state =         info[2][1]
        else:
            print(ln_info)
            author_name = ln_info
            wenku_name = ""
            state =""

        ln_last_update = ln.select('div > p')[1].string
        ln_abstract = ln.select('div > p')[2].string
        last_update = ln_last_update[5:]
        abstract = ln_abstract[3:].translate(
            str.maketrans(dict.fromkeys('\r\n\u3000'))
        )

        print(ln_title)
        # print('\n'.join([
        #         ln_title,
        #         '; '.join([author_name, wenku_name, state]),
        #         last_update,
        #         abstract,
        #         ""
        #     ])
        # )
        spamwriter.writerow([
            ln_title, 
            author_name, wenku_name, state, 
            last_update, abstract
        ])
        ## 提取单页信息 结束 END

    ## 爬取所有页面 结束 END

