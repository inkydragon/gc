# ============================================
# MoonScript 标准库 - 索引
# 
# 使用方法:
#   import "stdlib/index.moon" as std
#   
# 或者单独导入:
#   from "stdlib/io.moon" import File, Dir, Path
#   from "stdlib/http.moon" import HttpServer
#   from "stdlib/net.moon" import TcpClient, TcpServer
#   from "stdlib/dll.moon" import DLL, WinAPI, MoonDLL
#   from "stdlib/db.moon" import Database
#   from "stdlib/utils.moon" import *
#   from "stdlib/sys.moon" import System, Process
#   from "stdlib/winapi.moon" import Kernel32, User32, Shell32
#   from "stdlib/crypto.moon" import base64_encode, hash
#   from "stdlib/collections.moon" import Stack, Queue, Set
#   from "stdlib/math.moon" import sin, cos, PI
# ============================================

VERSION = "1.1.0"

print("MoonScript Standard Library v" + VERSION)
print("Copyright (c) 2026 greenteng.com")
print("")
print("Available modules:")
print("  - stdlib/io.moon          : File, Dir, Path")
print("  - stdlib/http.moon        : HttpServer, Request, Response")
print("  - stdlib/net.moon         : TcpClient, TcpServer, UdpSocket")
print("  - stdlib/dll.moon         : DLL, WinAPI, MoonDLL, CString")
print("  - stdlib/db.moon          : Database, Table, Model")
print("  - stdlib/utils.moon       : map, filter, reduce, DateTime, Timer, Cache")
print("  - stdlib/sys.moon         : System, Process, Registry, Clipboard")
print("  - stdlib/winapi.moon      : Kernel32, User32, Shell32")
print("  - stdlib/crypto.moon      : base64, hex, hash, xor_cipher, url_encode")
print("  - stdlib/collections.moon : Stack, Queue, Set, Deque, Counter")
print("  - stdlib/math.moon        : sin, cos, sqrt, PI, statistics, vectors")
