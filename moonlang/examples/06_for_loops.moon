# Range loop
print("1 to 5:")
for i = 1 to 5:
    print(i)
end

# Iterate list
fruits = ["apple", "banana", "orange"]
for fruit in fruits:
    print("Fruit:", fruit)
end

# Iterate with index
for i = 0 to len(fruits) - 1:
    print(i, ":", fruits[i])
end
