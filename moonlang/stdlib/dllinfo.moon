# ============================================
# MoonScript 标准库 - DLL 信息查询
# 用法: from "stdlib/dllinfo.moon" import DLLInfo, listExports
# 
# 提供已知 Windows DLL 的函数列表和参数信息
# ============================================

# ========== DLL 函数信息数据库 ==========

DLL_DATABASE = {
    "kernel32.dll": {
        "description": "Windows Kernel 核心 API",
        "functions": {
            "GetCurrentProcessId": {
                "description": "获取当前进程ID",
                "return": "int",
                "params": []
            },
            "GetCurrentThreadId": {
                "description": "获取当前线程ID",
                "return": "int",
                "params": []
            },
            "GetTickCount": {
                "description": "获取系统启动后的毫秒数",
                "return": "int",
                "params": []
            },
            "Sleep": {
                "description": "暂停执行指定毫秒数",
                "return": "void",
                "params": [{"name": "dwMilliseconds", "type": "int", "desc": "毫秒数"}]
            },
            "Beep": {
                "description": "发出蜂鸣声",
                "return": "int",
                "params": [
                    {"name": "dwFreq", "type": "int", "desc": "频率 (Hz)"},
                    {"name": "dwDuration", "type": "int", "desc": "持续时间 (ms)"}
                ]
            },
            "GetSystemDirectoryA": {
                "description": "获取系统目录路径",
                "return": "int",
                "params": [
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "uSize", "type": "int", "desc": "缓冲区大小"}
                ]
            },
            "GetWindowsDirectoryA": {
                "description": "获取Windows目录路径",
                "return": "int",
                "params": [
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "uSize", "type": "int", "desc": "缓冲区大小"}
                ]
            },
            "GetTempPathA": {
                "description": "获取临时目录路径",
                "return": "int",
                "params": [
                    {"name": "nBufferLength", "type": "int", "desc": "缓冲区大小"},
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"}
                ]
            },
            "GetComputerNameA": {
                "description": "获取计算机名",
                "return": "int",
                "params": [
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "lpnSize", "type": "int*", "desc": "缓冲区大小指针"}
                ]
            },
            "GetLastError": {
                "description": "获取最后错误代码",
                "return": "int",
                "params": []
            },
            "SetEnvironmentVariableA": {
                "description": "设置环境变量",
                "return": "int",
                "params": [
                    {"name": "lpName", "type": "char*", "desc": "变量名"},
                    {"name": "lpValue", "type": "char*", "desc": "变量值"}
                ]
            },
            "GetEnvironmentVariableA": {
                "description": "获取环境变量",
                "return": "int",
                "params": [
                    {"name": "lpName", "type": "char*", "desc": "变量名"},
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "nSize", "type": "int", "desc": "缓冲区大小"}
                ]
            },
            "CreateDirectoryA": {
                "description": "创建目录",
                "return": "int",
                "params": [
                    {"name": "lpPathName", "type": "char*", "desc": "目录路径"},
                    {"name": "lpSecurityAttributes", "type": "void*", "desc": "安全属性 (可为0)"}
                ]
            },
            "DeleteFileA": {
                "description": "删除文件",
                "return": "int",
                "params": [{"name": "lpFileName", "type": "char*", "desc": "文件路径"}]
            },
            "CopyFileA": {
                "description": "复制文件",
                "return": "int",
                "params": [
                    {"name": "lpExistingFileName", "type": "char*", "desc": "源文件"},
                    {"name": "lpNewFileName", "type": "char*", "desc": "目标文件"},
                    {"name": "bFailIfExists", "type": "int", "desc": "文件存在是否失败"}
                ]
            },
            "MoveFileA": {
                "description": "移动/重命名文件",
                "return": "int",
                "params": [
                    {"name": "lpExistingFileName", "type": "char*", "desc": "源文件"},
                    {"name": "lpNewFileName", "type": "char*", "desc": "目标文件"}
                ]
            },
            "GetFileSize": {
                "description": "获取文件大小",
                "return": "int",
                "params": [
                    {"name": "hFile", "type": "handle", "desc": "文件句柄"},
                    {"name": "lpFileSizeHigh", "type": "int*", "desc": "高32位输出"}
                ]
            },
            "GetLogicalDriveStringsA": {
                "description": "获取逻辑驱动器列表",
                "return": "int",
                "params": [
                    {"name": "nBufferLength", "type": "int", "desc": "缓冲区大小"},
                    {"name": "lpBuffer", "type": "char*", "desc": "输出缓冲区"}
                ]
            },
            "GetDriveTypeA": {
                "description": "获取驱动器类型",
                "return": "int",
                "params": [{"name": "lpRootPathName", "type": "char*", "desc": "根路径"}]
            }
        }
    },
    
    "user32.dll": {
        "description": "Windows 用户界面 API",
        "functions": {
            "MessageBoxA": {
                "description": "显示消息框",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "父窗口句柄 (可为0)"},
                    {"name": "lpText", "type": "char*", "desc": "消息文本"},
                    {"name": "lpCaption", "type": "char*", "desc": "标题"},
                    {"name": "uType", "type": "int", "desc": "类型标志"}
                ]
            },
            "GetForegroundWindow": {
                "description": "获取前台窗口句柄",
                "return": "handle",
                "params": []
            },
            "GetDesktopWindow": {
                "description": "获取桌面窗口句柄",
                "return": "handle",
                "params": []
            },
            "FindWindowA": {
                "description": "查找窗口",
                "return": "handle",
                "params": [
                    {"name": "lpClassName", "type": "char*", "desc": "类名 (可为0)"},
                    {"name": "lpWindowName", "type": "char*", "desc": "窗口标题 (可为0)"}
                ]
            },
            "ShowWindow": {
                "description": "显示/隐藏窗口",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "窗口句柄"},
                    {"name": "nCmdShow", "type": "int", "desc": "显示命令"}
                ]
            },
            "SetWindowTextA": {
                "description": "设置窗口标题",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "窗口句柄"},
                    {"name": "lpString", "type": "char*", "desc": "新标题"}
                ]
            },
            "GetWindowTextA": {
                "description": "获取窗口标题",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "窗口句柄"},
                    {"name": "lpString", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "nMaxCount", "type": "int", "desc": "缓冲区大小"}
                ]
            },
            "GetSystemMetrics": {
                "description": "获取系统度量值",
                "return": "int",
                "params": [{"name": "nIndex", "type": "int", "desc": "度量索引"}]
            },
            "SetCursorPos": {
                "description": "设置光标位置",
                "return": "int",
                "params": [
                    {"name": "X", "type": "int", "desc": "X坐标"},
                    {"name": "Y", "type": "int", "desc": "Y坐标"}
                ]
            },
            "GetCursorPos": {
                "description": "获取光标位置",
                "return": "int",
                "params": [{"name": "lpPoint", "type": "POINT*", "desc": "输出坐标结构"}]
            },
            "SendMessageA": {
                "description": "发送窗口消息",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "窗口句柄"},
                    {"name": "Msg", "type": "int", "desc": "消息ID"},
                    {"name": "wParam", "type": "int", "desc": "参数1"},
                    {"name": "lParam", "type": "int", "desc": "参数2"}
                ]
            },
            "PostMessageA": {
                "description": "投递窗口消息",
                "return": "int",
                "params": [
                    {"name": "hWnd", "type": "handle", "desc": "窗口句柄"},
                    {"name": "Msg", "type": "int", "desc": "消息ID"},
                    {"name": "wParam", "type": "int", "desc": "参数1"},
                    {"name": "lParam", "type": "int", "desc": "参数2"}
                ]
            },
            "keybd_event": {
                "description": "模拟键盘事件",
                "return": "void",
                "params": [
                    {"name": "bVk", "type": "int", "desc": "虚拟键码"},
                    {"name": "bScan", "type": "int", "desc": "扫描码"},
                    {"name": "dwFlags", "type": "int", "desc": "标志"},
                    {"name": "dwExtraInfo", "type": "int", "desc": "附加信息"}
                ]
            },
            "mouse_event": {
                "description": "模拟鼠标事件",
                "return": "void",
                "params": [
                    {"name": "dwFlags", "type": "int", "desc": "标志"},
                    {"name": "dx", "type": "int", "desc": "X偏移"},
                    {"name": "dy", "type": "int", "desc": "Y偏移"},
                    {"name": "dwData", "type": "int", "desc": "滚轮数据"},
                    {"name": "dwExtraInfo", "type": "int", "desc": "附加信息"}
                ]
            }
        }
    },
    
    "shell32.dll": {
        "description": "Windows Shell API",
        "functions": {
            "ShellExecuteA": {
                "description": "执行程序/打开文件",
                "return": "int",
                "params": [
                    {"name": "hwnd", "type": "handle", "desc": "父窗口"},
                    {"name": "lpOperation", "type": "char*", "desc": "操作 (open/runas/print)"},
                    {"name": "lpFile", "type": "char*", "desc": "文件路径"},
                    {"name": "lpParameters", "type": "char*", "desc": "参数"},
                    {"name": "lpDirectory", "type": "char*", "desc": "工作目录"},
                    {"name": "nShowCmd", "type": "int", "desc": "显示方式"}
                ]
            }
        }
    },
    
    "msvcrt.dll": {
        "description": "Microsoft C 运行时库",
        "functions": {
            "printf": {
                "description": "格式化输出",
                "return": "int",
                "params": [{"name": "format", "type": "char*", "desc": "格式字符串"}]
            },
            "sprintf": {
                "description": "格式化到字符串",
                "return": "int",
                "params": [
                    {"name": "buffer", "type": "char*", "desc": "输出缓冲区"},
                    {"name": "format", "type": "char*", "desc": "格式字符串"}
                ]
            },
            "strlen": {
                "description": "计算字符串长度",
                "return": "int",
                "params": [{"name": "str", "type": "char*", "desc": "字符串"}]
            },
            "strcpy": {
                "description": "复制字符串",
                "return": "char*",
                "params": [
                    {"name": "dest", "type": "char*", "desc": "目标"},
                    {"name": "src", "type": "char*", "desc": "源"}
                ]
            },
            "strcmp": {
                "description": "比较字符串",
                "return": "int",
                "params": [
                    {"name": "str1", "type": "char*", "desc": "字符串1"},
                    {"name": "str2", "type": "char*", "desc": "字符串2"}
                ]
            },
            "malloc": {
                "description": "分配内存",
                "return": "void*",
                "params": [{"name": "size", "type": "int", "desc": "字节数"}]
            },
            "free": {
                "description": "释放内存",
                "return": "void",
                "params": [{"name": "ptr", "type": "void*", "desc": "内存指针"}]
            },
            "atoi": {
                "description": "字符串转整数",
                "return": "int",
                "params": [{"name": "str", "type": "char*", "desc": "字符串"}]
            },
            "atof": {
                "description": "字符串转浮点数",
                "return": "double",
                "params": [{"name": "str", "type": "char*", "desc": "字符串"}]
            }
        }
    },
    
    "ws2_32.dll": {
        "description": "Windows Sockets 2 API",
        "functions": {
            "WSAStartup": {
                "description": "初始化 Winsock",
                "return": "int",
                "params": [
                    {"name": "wVersionRequested", "type": "int", "desc": "版本"},
                    {"name": "lpWSAData", "type": "void*", "desc": "数据结构"}
                ]
            },
            "WSACleanup": {
                "description": "清理 Winsock",
                "return": "int",
                "params": []
            },
            "socket": {
                "description": "创建套接字",
                "return": "int",
                "params": [
                    {"name": "af", "type": "int", "desc": "地址族"},
                    {"name": "type", "type": "int", "desc": "类型"},
                    {"name": "protocol", "type": "int", "desc": "协议"}
                ]
            },
            "connect": {
                "description": "连接到服务器",
                "return": "int",
                "params": [
                    {"name": "s", "type": "int", "desc": "套接字"},
                    {"name": "name", "type": "void*", "desc": "地址结构"},
                    {"name": "namelen", "type": "int", "desc": "地址长度"}
                ]
            },
            "send": {
                "description": "发送数据",
                "return": "int",
                "params": [
                    {"name": "s", "type": "int", "desc": "套接字"},
                    {"name": "buf", "type": "char*", "desc": "数据缓冲区"},
                    {"name": "len", "type": "int", "desc": "长度"},
                    {"name": "flags", "type": "int", "desc": "标志"}
                ]
            },
            "recv": {
                "description": "接收数据",
                "return": "int",
                "params": [
                    {"name": "s", "type": "int", "desc": "套接字"},
                    {"name": "buf", "type": "char*", "desc": "缓冲区"},
                    {"name": "len", "type": "int", "desc": "长度"},
                    {"name": "flags", "type": "int", "desc": "标志"}
                ]
            },
            "closesocket": {
                "description": "关闭套接字",
                "return": "int",
                "params": [{"name": "s", "type": "int", "desc": "套接字"}]
            }
        }
    }
}

# ========== DLL 信息类 ==========

class DLLInfo:
    # 获取已知 DLL 列表
    static function listKnownDLLs():
        return keys(DLL_DATABASE)
    end
    
    # 获取 DLL 描述
    static function getDescription(dllName):
        dllName = to_lower(dllName)
        if has_key(DLL_DATABASE, dllName):
            return DLL_DATABASE[dllName]["description"]
        end
        return "Unknown DLL"
    end
    
    # 列出 DLL 所有函数
    static function listFunctions(dllName):
        dllName = to_lower(dllName)
        if has_key(DLL_DATABASE, dllName):
            return keys(DLL_DATABASE[dllName]["functions"])
        end
        return []
    end
    
    # 获取函数信息
    static function getFunctionInfo(dllName, funcName):
        dllName = to_lower(dllName)
        if has_key(DLL_DATABASE, dllName):
            funcs = DLL_DATABASE[dllName]["functions"]
            if has_key(funcs, funcName):
                return funcs[funcName]
            end
        end
        return null
    end
    
    # 打印 DLL 信息
    static function printInfo(dllName):
        dllName = to_lower(dllName)
        if not has_key(DLL_DATABASE, dllName):
            print("Unknown DLL: " + dllName)
            return
        end
        
        info = DLL_DATABASE[dllName]
        print("======================================")
        print("DLL: " + dllName)
        print("Description: " + info["description"])
        print("======================================")
        print("")
        print("Exported Functions:")
        print("")
        
        for funcName in keys(info["functions"]):
            funcInfo = info["functions"][funcName]
            print("  " + funcName + "()")
            print("    Description: " + funcInfo["description"])
            print("    Returns: " + funcInfo["return"])
            
            if len(funcInfo["params"]) > 0:
                print("    Parameters:")
                for p in funcInfo["params"]:
                    print("      - " + p["name"] + " (" + p["type"] + "): " + p["desc"])
                end
            else:
                print("    Parameters: none")
            end
            print("")
        end
    end
    
    # 搜索函数
    static function searchFunction(keyword):
        keyword = to_lower(keyword)
        results = []
        
        for dllName in keys(DLL_DATABASE):
            funcs = DLL_DATABASE[dllName]["functions"]
            for funcName in keys(funcs):
                if contains(to_lower(funcName), keyword) or contains(to_lower(funcs[funcName]["description"]), keyword):
                    append(results, {
                        "dll": dllName,
                        "function": funcName,
                        "description": funcs[funcName]["description"]
                    })
                end
            end
        end
        
        return results
    end
end

# ========== 快捷函数 ==========

# 列出 DLL 导出
function listExports(dllName):
    return DLLInfo.listFunctions(dllName)
end

# 获取函数帮助
function funcHelp(dllName, funcName):
    info = DLLInfo.getFunctionInfo(dllName, funcName)
    if info == null:
        print("Function not found: " + funcName)
        return
    end
    
    print("Function: " + funcName)
    print("DLL: " + dllName)
    print("Description: " + info["description"])
    print("Returns: " + info["return"])
    
    if len(info["params"]) > 0:
        print("Parameters:")
        for p in info["params"]:
            print("  " + p["name"] + " (" + p["type"] + ")")
            print("    " + p["desc"])
        end
    else:
        print("Parameters: none")
    end
end

# 搜索函数
function searchDLL(keyword):
    results = DLLInfo.searchFunction(keyword)
    if len(results) == 0:
        print("No functions found matching: " + keyword)
        return
    end
    
    print("Found " + str(len(results)) + " functions:")
    print("")
    for r in results:
        print("  " + r["dll"] + " :: " + r["function"])
        print("    " + r["description"])
    end
end

# 显示所有已知 DLL
function showDLLs():
    print("Known Windows DLLs:")
    print("")
    for dllName in DLLInfo.listKnownDLLs():
        desc = DLLInfo.getDescription(dllName)
        funcCount = len(DLLInfo.listFunctions(dllName))
        print("  " + dllName)
        print("    " + desc)
        print("    Functions: " + str(funcCount))
        print("")
    end
end
