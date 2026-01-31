# Dictionary functions
person = {"name": "Alice", "age": 25}

print("person:", person)
print("keys:", keys(person))
print("values:", values(person))
print("get email (default 'none'):", get(person, "email", "none"))
print("has_key 'name':", has_key(person, "name"))
print("has_key 'email':", has_key(person, "email"))

# Set value
person["email"] = "alice@example.com"
print("After adding email:", person)

# Merge dicts
extra = {"city": "Beijing"}
merged = merge(person, extra)
print("Merged:", merged)
