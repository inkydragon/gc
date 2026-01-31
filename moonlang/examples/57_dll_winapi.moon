# REQUIRES: Windows DLL + stdlib
# Using WinAPI wrapper

from "stdlib/dll.moon" import DLL, WinAPI

WinAPI.init()
print("Process ID:", WinAPI.getProcessId())
print("System dir:", WinAPI.getSystemDirectory())
WinAPI.alert("Hello!")
WinAPI.cleanup()
