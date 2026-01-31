# REQUIRES: File system access
# File operations

# Write file
write_file("test_output.txt", "Hello from MoonLang!")
print("File written")

# Read file
content = read_file("test_output.txt")
print("Content:", content)

# Check file exists
if exists("test_output.txt"):
    print("File exists")
end

# File info
print("Size:", file_size("test_output.txt"), "bytes")
print("Is file:", is_file("test_output.txt"))

# Directory operations
create_dir("test_dir")
print("Directory created")

files = list_dir(".")
print("Files in current directory:")
for file in files:
    print("  -", file)
end

# Cleanup
delete_file("test_output.txt")
delete_dir("test_dir")
print("Cleanup done")
