# REQUIRES: Windows DLL
# MessageBox Example

user32 = dll_load("user32.dll")
msgbox = dll_func(user32, "MessageBoxA")

# Allocate string memory
title_ptr = alloc_str("Alert")
msg_ptr = alloc_str("Hello from MoonLang!")

# MessageBox(hwnd, text, caption, type)
result = dll_call_int(msgbox, 0, msg_ptr, title_ptr, 0)

# Free memory
free_str(title_ptr)
free_str(msg_ptr)
dll_close(user32)
