# Exception handling
try:
    result = 10 / 0
catch error:
    print("Error:", error)
end

print("Program continues after error handling")

# Another try-catch example
try:
    data = json_decode("invalid json")
catch e:
    print("JSON parse error:", e)
end
