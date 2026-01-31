# MoonLang Regular Expression Standard Library
# Copyright (c) 2026 greenteng.com
#
# Provides a high-level interface for regular expression operations.
# Uses PCRE-compatible syntax (currently implemented with C++ std::regex).
#
# Usage:
#   from "stdlib/regex.moon" import *
#
# Example:
#   if regex_match("hello123", "\\w+\\d+"):
#       print("Pattern matched!")
#   end
#
#   groups = regex_groups("2026-01-25", "(\\d+)-(\\d+)-(\\d+)")
#   print(groups)  # ["2026-01-25", "2026", "01", "25"]
#

# ============================================================================
# Regex Class - Object-oriented interface
# ============================================================================

class Regex:
    # Create a compiled regex pattern for better performance
    # pattern = new Regex("\\d+")
    function init(pattern):
        self.pattern = pattern
        self.compiled = regex_compile(pattern)
        self.lastError = null
    end
    
    # Check if pattern matches the entire string
    function match(text):
        if self.compiled != null:
            return regex_match_compiled(self.compiled, text)
        end
        return regex_match(text, self.pattern)
    end
    
    # Search for first match in string
    function search(text):
        if self.compiled != null:
            return regex_search_compiled(self.compiled, text)
        end
        return regex_search(text, self.pattern)
    end
    
    # Find all matches
    function findAll(text):
        if self.compiled != null:
            return regex_find_all_compiled(self.compiled, text)
        end
        return regex_find_all(text, self.pattern)
    end
    
    # Replace first occurrence
    function replace(text, replacement):
        if self.compiled != null:
            return regex_replace_compiled(self.compiled, text, replacement)
        end
        return regex_replace(text, self.pattern, replacement)
    end
    
    # Replace all occurrences
    function replaceAll(text, replacement):
        return regex_replace_all(text, self.pattern, replacement)
    end
    
    # Split string by pattern
    function split(text):
        return regex_split(text, self.pattern)
    end
    
    # Get capture groups
    function groups(text):
        return regex_groups(text, self.pattern)
    end
    
    # Get named capture groups
    function namedGroups(text):
        return regex_named(text, self.pattern)
    end
    
    # Free compiled pattern (call when done)
    function free():
        if self.compiled != null:
            regex_free(self.compiled)
            self.compiled = null
        end
    end
end

# ============================================================================
# Helper Functions
# ============================================================================

# Check if a string contains a pattern match
function regex_contains(text, pattern):
    return regex_test(text, pattern)
end

# Count number of matches
function regex_count(text, pattern):
    matches = regex_find_all(text, pattern)
    return len(matches)
end

# Extract all matches as a simple list (alias for regex_find_all)
function regex_extract(text, pattern):
    return regex_find_all(text, pattern)
end

# Check if string is a valid email
function is_email(text):
    pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    return regex_match(text, pattern)
end

# Check if string is a valid URL
function is_url(text):
    pattern = "^https?://[a-zA-Z0-9.-]+(?:/[^\\s]*)?$"
    return regex_match(text, pattern)
end

# Check if string is a valid IPv4 address
function is_ipv4(text):
    pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    return regex_match(text, pattern)
end

# Check if string is a valid phone number (basic)
function is_phone(text):
    pattern = "^[+]?[0-9]{10,15}$"
    return regex_match(text, pattern)
end

# Check if string contains only digits
function is_numeric(text):
    return regex_match(text, "^[0-9]+$")
end

# Check if string contains only alphanumeric characters
function is_alphanumeric(text):
    return regex_match(text, "^[a-zA-Z0-9]+$")
end

# Remove all non-alphanumeric characters
function strip_non_alnum(text):
    return regex_replace_all(text, "[^a-zA-Z0-9]", "")
end

# Remove all whitespace
function strip_whitespace(text):
    return regex_replace_all(text, "\\s+", "")
end

# Normalize whitespace (multiple spaces to single)
function normalize_whitespace(text):
    return regex_replace_all(text, "\\s+", " ")
end

# Extract all numbers from string
function extract_numbers(text):
    return regex_find_all(text, "[0-9]+")
end

# Extract all words from string
function extract_words(text):
    return regex_find_all(text, "[a-zA-Z]+")
end

# ============================================================================
# Common Pattern Constants
# ============================================================================

# Common regex patterns
PATTERN_EMAIL = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
PATTERN_URL = "^https?://[a-zA-Z0-9.-]+(?:/[^\\s]*)?$"
PATTERN_IPV4 = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
PATTERN_DATE_ISO = "^\\d{4}-\\d{2}-\\d{2}$"
PATTERN_TIME_24H = "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
PATTERN_HEX_COLOR = "^#[0-9A-Fa-f]{6}$"
PATTERN_UUID = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
