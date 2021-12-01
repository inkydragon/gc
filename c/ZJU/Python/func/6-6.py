acronym = lambda s: ''.join(map(lambda s: s[0:1].upper(), s.split(' ')))
# --------------------
phrase = input()
print(acronym(phrase))
#< central  processing  unit
#> CPU