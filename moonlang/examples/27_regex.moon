# Basic Matching
email = "user@example.com"
if regex_match(email, "^[\\w.]+@[\\w.]+$"):
    print("Valid email format")
else:
    print("Invalid email format")
end

# Extract date
date = "2026-01-25"
groups = regex_groups(date, "(\\d{4})-(\\d{2})-(\\d{2})")
print("Year:", groups[1])
print("Month:", groups[2])
print("Day:", groups[3])

# Global Replace
text = "Price: $100, Tax: $20"
result = regex_replace_all(text, "\\$\\d+", "[REDACTED]")
print("Replaced:", result)
