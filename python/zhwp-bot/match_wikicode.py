# encoding:UTF-8

import re
import codecs
from doi_bot import doi2ref

# def re_doi(doi_num):
doi_num = 2

# 保证即使出错文件句柄也会关闭
with open("entry.wiki", "r+", encoding="utf8") as fo:
    entry = fo.read()

    # 正则参数
    doi_pattern = r'({{cite doi\|[ ]*){1}(10\.[^\s\/]+\/[^\s]+)([ ]?}})'
    flags = re.I # 大小写不敏感

    # 总 DOI 个数核查
    pattern = re.compile(doi_pattern, flags)
    doi_list = pattern.findall(entry)
    re_num = len(doi_list) # 匹配到的 DOI 个数
    if(doi_num != re_num):
        print("Error: 输入的字符串个数与匹配的DOI个数不符！")
        print("共{}个字符串；但匹配到{}个DOI".format(doi_num, re_num))
        exit()

    # 循环替换：DOI -> <ref>
    count = re_num
    while (count > 0):
        doi_res = re.search(doi_pattern, entry, flags)
        print(re_num-count+1)
        '''         print(doi_res)
        print(doi_res.group())
        print(doi_res.group(1))
        print(doi_res.group(3)) '''
        doi = doi_res.group(2)
        ref = doi2ref(doi)
        entry = re.sub(pattern, ref, entry, 1)
        #print(entry)
        count = count - 1

    # 重置文件指针
    fo.seek(0)
    fo.write(entry)

print("匹配完成~")