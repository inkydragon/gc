# REQUIRES: Windows DLL
# Simple DLL call

kernel32 = dll_load("kernel32.dll")
get_pid = dll_func(kernel32, "GetCurrentProcessId")
pid = dll_call_int(get_pid)
print("Process ID:", pid)
dll_close(kernel32)
