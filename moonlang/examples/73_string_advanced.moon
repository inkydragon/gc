# Advanced string operations
text = "Hello, World!"

print("Original:", text)
print("Length:", len(text))
print("Uppercase:", to_upper(text))
print("Lowercase:", to_lower(text))

# Substring check
print("starts_with 'Hello':", starts_with(text, "Hello"))
print("ends_with '!':", ends_with(text, "!"))
print("index_of 'World':", index_of(text, "World"))

# Replace
print("replace:", replace(text, "World", "MoonLang"))

# Split and join
parts = split("a,b,c,d", ",")
print("split:", parts)
print("join:", join(parts, "-"))

# Repeat
print("repeat:", repeat("ab", 3))

# Trim
text2 = "  spaced  "
print("trim:", trim(text2))

# 字符串填充 (新内置函数)
print("")
print("=== 字符串填充 (内置) ===")
print("pad_left('42', 6, '0'):", pad_left("42", 6, "0"))
print("pad_right('Hi', 6, '.'):", pad_right("Hi", 6, "."))
