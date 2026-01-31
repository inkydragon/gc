# Pre-compiled regex for performance
pattern = regex_compile("\\d+")

lines = ["line 1: 100", "line 2: 200", "line 3: 300"]

for line in lines:
    numbers = regex_find_all_compiled(pattern, line)
    print("Numbers in '", line, "':", numbers)
end

regex_free(pattern)
print("Pattern freed")
