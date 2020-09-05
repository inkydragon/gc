import bibtexparser
import csv

bib_database = None
with open('all.bib') as bibtex_file:
    bib_database = bibtexparser.load(bibtex_file)

bib_count = 0

for entry in bib_database.entries:
    title    = entry.get('title')
    keywords = entry.get('keywords', '') # 可能为空
    abstract = entry.get('abstract', '')
    if keywords == '' and abstract=='':
        continue

    bib_list = [title, keywords, abstract]
    # print(bib_list)

    bib_count += 1

print(bib_count)

with open('141-139.csv','wt') as f:
    cw = csv.writer(f, lineterminator = '\n') # 仅使用 LF 避免多余的空行
    headers = ['title','keywords','abstract']
    cw.writerow(headers)
    for entry in bib_database.entries:
        title    = entry.get('title')
        keywords = entry.get('keywords', '') # 可能为空
        abstract = entry.get('abstract', '')
        if keywords == '' and abstract=='':
            continue
        tag = gen_tag([title, keywords, abstract])
        bib_list = [title, keywords, abstract, tag]
        # print(bib_list)
        cw.writerow(bib_list)
        bib_count += 1

