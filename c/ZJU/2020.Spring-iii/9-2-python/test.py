'''
data.txt中保存有n个单词，每个单词一行。
请编写一个程序从文件中将单词读出，找到最长的单词，
然后将其保存到result.txt中。程序须保存test.py中

输出格式：

用以下格式输出最长的字符串到**result.txt**中:
The longest word is: zhang
如果有多个单词，则每个单词用**英文逗号**间隔(结尾无**逗号**)：
The longest words are: zhang,xiang
'''

input_list = []
with open('data.txt') as data:
    input_list = data.readlines()

ln1 = [s.strip() for s in input_list]
ln2 = list(filter(None, ln1))
max_len = max([len(s) for s in ln2])
ln3 = list(filter(lambda s: len(s) == max_len, ln2))

# output
s = "The longest word"
if len(ln3) > 1:
    s += "s are: "
else:
    s += " is: "

s += ','.join(ln3)

with open('result.txt', 'w') as f:
    f.write(s)
