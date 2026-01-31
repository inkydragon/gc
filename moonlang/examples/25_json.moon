# JSON Encoding
data = {"name": "Alice", "age": 25}
json_str = json_encode(data)
print("Encoded:", json_str)

# JSON Decoding
json_str2 = '{"name":"Bob","skills":["Python","JS"]}'
data2 = json_decode(json_str2)
print("Decoded name:", data2["name"])
print("Decoded skills:", data2["skills"])
