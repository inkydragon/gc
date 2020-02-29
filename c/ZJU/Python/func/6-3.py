CountDigit = lambda n,d: list(map(int, str(abs(n)))).count(d) # abs for -n
# ------------------------------
number, digit = input().split()
number = int(number)
digit = int(digit)
count = CountDigit(number, digit)
print("Number of digit 2 in "+str(number)+":", count)
#< -21252 2
#> Number of digit 2 in -21252: 3