# break - exit loop
print("Testing break:")
for i = 1 to 100:
    if i > 5:
        break
    end
    print(i)
end

# continue - skip iteration
print("Testing continue (odd numbers only):")
for i = 1 to 10:
    if i % 2 == 0:
        continue
    end
    print(i)
end
