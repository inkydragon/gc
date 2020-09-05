import bibtexparser

bib_database = None
with open('cce.bib') as bibtex_file:
    bib_database = bibtexparser.load(bibtex_file)


keyword_maps = {
    '优化': [
        'optimization', 'optimisation',
        'optimiz', 
        ],
    '故障诊断': ['diagnosis', ]
}

def kw_map(kw):
    lkw = kw.lower()
    for zh_kw in keyword_maps.keys():
        kw_list = keyword_maps[zh_kw]
        for en_kw in kw_list:
            if en_kw in lkw:
                return zh_kw
    return lkw


bib_count = 0
keywords = {}
for entry in bib_database.entries:
    kw_str = entry.get('keywords', '') # 可能为空
    if kw_str == '':
        continue
    kw_list = kw_str.split(', ')
    for kw in kw_list:
        kw = kw_map(kw)
        keywords[kw] = keywords.get(kw, 0) + 1
    # print(kw)
    bib_count += 1

print('bib count = {}'.format(bib_count))
print('kws = {}'.format(len(keywords)))

for k in keywords.keys():
    count = keywords[k]
    if count > 5:
        print('{}: {}'.format(k, count))
