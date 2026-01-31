# Named capture groups in regex
text = "John:25"
result = regex_named(text, "(?P<name>\\w+):(?P<age>\\d+)")
print("Name:", result["name"])
print("Age:", result["age"])

# More complex example
log = "2026-01-25 ERROR: Connection failed"
parts = regex_named(log, "(?P<date>\\d{4}-\\d{2}-\\d{2}) (?P<level>\\w+): (?P<msg>.*)")
print("Date:", parts["date"])
print("Level:", parts["level"])
print("Message:", parts["msg"])
