# ============================================
# MoonScript 标准库 - Windows API 高级封装
# 用法: from "stdlib/winapi.moon" import *
# ============================================

from "scripts/stdlib/dll.moon" import DLL, CString, buffer

# ========== 常用 Windows 常量 ==========

# 消息框按钮
MB_OK = 0
MB_OKCANCEL = 1
MB_ABORTRETRYIGNORE = 2
MB_YESNOCANCEL = 3
MB_YESNO = 4
MB_RETRYCANCEL = 5

# 消息框图标
MB_ICONERROR = 16
MB_ICONQUESTION = 32
MB_ICONWARNING = 48
MB_ICONINFO = 64

# 消息框返回值
IDOK = 1
IDCANCEL = 2
IDABORT = 3
IDRETRY = 4
IDIGNORE = 5
IDYES = 6
IDNO = 7

# 虚拟键码
VK_BACK = 8
VK_TAB = 9
VK_RETURN = 13
VK_SHIFT = 16
VK_CONTROL = 17
VK_ESCAPE = 27
VK_SPACE = 32
VK_LEFT = 37
VK_UP = 38
VK_RIGHT = 39
VK_DOWN = 40
VK_DELETE = 46

# ========== Kernel32 API ==========

class Kernel32:
    static function init():
        if Kernel32.dll == null:
            Kernel32.dll = new DLL("kernel32.dll")
        end
    end
    
    # 获取当前进程ID
    static function GetCurrentProcessId():
        Kernel32.init()
        return Kernel32.dll.callInt("GetCurrentProcessId")
    end
    
    # 获取当前线程ID
    static function GetCurrentThreadId():
        Kernel32.init()
        return Kernel32.dll.callInt("GetCurrentThreadId")
    end
    
    # 获取Tick计数 (毫秒)
    static function GetTickCount():
        Kernel32.init()
        return Kernel32.dll.callInt("GetTickCount")
    end
    
    # 休眠
    static function Sleep(ms):
        Kernel32.init()
        Kernel32.dll.callVoid("Sleep", ms)
    end
    
    # 蜂鸣
    static function Beep(freq, duration):
        Kernel32.init()
        return Kernel32.dll.callInt("Beep", freq, duration)
    end
    
    # 获取系统目录
    static function GetSystemDirectory():
        Kernel32.init()
        buf = buffer(260)
        Kernel32.dll.callInt("GetSystemDirectoryA", buf.pointer(), 260)
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取Windows目录
    static function GetWindowsDirectory():
        Kernel32.init()
        buf = buffer(260)
        Kernel32.dll.callInt("GetWindowsDirectoryA", buf.pointer(), 260)
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取临时目录
    static function GetTempPath():
        Kernel32.init()
        buf = buffer(260)
        Kernel32.dll.callInt("GetTempPathA", 260, buf.pointer())
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取计算机名
    static function GetComputerName():
        Kernel32.init()
        buf = buffer(260)
        sizePtr = buffer(4)
        Kernel32.dll.callInt("GetComputerNameA", buf.pointer(), sizePtr.pointer())
        result = buf.read()
        buf.free()
        sizePtr.free()
        return result
    end
    
    # 获取逻辑驱动器
    static function GetLogicalDriveStrings():
        Kernel32.init()
        buf = buffer(260)
        Kernel32.dll.callInt("GetLogicalDriveStringsA", 260, buf.pointer())
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取磁盘类型
    static function GetDriveType(path):
        Kernel32.init()
        pathPtr = new CString(path)
        result = Kernel32.dll.callInt("GetDriveTypeA", pathPtr.pointer())
        pathPtr.free()
        return result
    end
    
    # 创建目录
    static function CreateDirectory(path):
        Kernel32.init()
        pathPtr = new CString(path)
        result = Kernel32.dll.callInt("CreateDirectoryA", pathPtr.pointer(), 0)
        pathPtr.free()
        return result != 0
    end
    
    # 删除文件
    static function DeleteFile(path):
        Kernel32.init()
        pathPtr = new CString(path)
        result = Kernel32.dll.callInt("DeleteFileA", pathPtr.pointer())
        pathPtr.free()
        return result != 0
    end
    
    # 复制文件
    static function CopyFile(src, dst, failIfExists):
        Kernel32.init()
        srcPtr = new CString(src)
        dstPtr = new CString(dst)
        flag = 0
        if failIfExists:
            flag = 1
        end
        result = Kernel32.dll.callInt("CopyFileA", srcPtr.pointer(), dstPtr.pointer(), flag)
        srcPtr.free()
        dstPtr.free()
        return result != 0
    end
    
    # 移动文件
    static function MoveFile(src, dst):
        Kernel32.init()
        srcPtr = new CString(src)
        dstPtr = new CString(dst)
        result = Kernel32.dll.callInt("MoveFileA", srcPtr.pointer(), dstPtr.pointer())
        srcPtr.free()
        dstPtr.free()
        return result != 0
    end
    
    # 设置环境变量
    static function SetEnvironmentVariable(name, value):
        Kernel32.init()
        namePtr = new CString(name)
        valuePtr = new CString(value)
        result = Kernel32.dll.callInt("SetEnvironmentVariableA", namePtr.pointer(), valuePtr.pointer())
        namePtr.free()
        valuePtr.free()
        return result != 0
    end
    
    # 获取环境变量
    static function GetEnvironmentVariable(name):
        Kernel32.init()
        namePtr = new CString(name)
        buf = buffer(32767)
        Kernel32.dll.callInt("GetEnvironmentVariableA", namePtr.pointer(), buf.pointer(), 32767)
        result = buf.read()
        namePtr.free()
        buf.free()
        return result
    end
    
    # 获取最后错误
    static function GetLastError():
        Kernel32.init()
        return Kernel32.dll.callInt("GetLastError")
    end
end

# ========== User32 API ==========

class User32:
    static function init():
        if User32.dll == null:
            User32.dll = new DLL("user32.dll")
        end
    end
    
    # 消息框
    static function MessageBox(hwnd, text, title, flags):
        User32.init()
        textPtr = new CString(text)
        titlePtr = new CString(title)
        result = User32.dll.callInt("MessageBoxA", hwnd, textPtr.pointer(), titlePtr.pointer(), flags)
        textPtr.free()
        titlePtr.free()
        return result
    end
    
    # 获取活动窗口
    static function GetForegroundWindow():
        User32.init()
        return User32.dll.callInt("GetForegroundWindow")
    end
    
    # 获取桌面窗口
    static function GetDesktopWindow():
        User32.init()
        return User32.dll.callInt("GetDesktopWindow")
    end
    
    # 获取屏幕宽度
    static function GetSystemMetrics(index):
        User32.init()
        return User32.dll.callInt("GetSystemMetrics", index)
    end
    
    # 屏幕宽度
    static function ScreenWidth():
        return User32.GetSystemMetrics(0)
    end
    
    # 屏幕高度
    static function ScreenHeight():
        return User32.GetSystemMetrics(1)
    end
    
    # 设置光标位置
    static function SetCursorPos(x, y):
        User32.init()
        return User32.dll.callInt("SetCursorPos", x, y) != 0
    end
    
    # 获取光标位置
    static function GetCursorPos():
        User32.init()
        buf = buffer(8)
        User32.dll.callInt("GetCursorPos", buf.pointer())
        # 简化返回
        return {"x": 0, "y": 0}
    end
    
    # 查找窗口
    static function FindWindow(className, windowName):
        User32.init()
        classPtr = null
        namePtr = null
        if className != null:
            classPtr = new CString(className)
        end
        if windowName != null:
            namePtr = new CString(windowName)
        end
        
        classArg = 0
        nameArg = 0
        if classPtr != null:
            classArg = classPtr.pointer()
        end
        if namePtr != null:
            nameArg = namePtr.pointer()
        end
        
        result = User32.dll.callInt("FindWindowA", classArg, nameArg)
        
        if classPtr != null:
            classPtr.free()
        end
        if namePtr != null:
            namePtr.free()
        end
        return result
    end
    
    # 显示/隐藏窗口
    static function ShowWindow(hwnd, cmd):
        User32.init()
        return User32.dll.callInt("ShowWindow", hwnd, cmd)
    end
    
    # 设置窗口标题
    static function SetWindowText(hwnd, text):
        User32.init()
        textPtr = new CString(text)
        result = User32.dll.callInt("SetWindowTextA", hwnd, textPtr.pointer())
        textPtr.free()
        return result != 0
    end
    
    # 发送消息
    static function SendMessage(hwnd, msg, wparam, lparam):
        User32.init()
        return User32.dll.callInt("SendMessageA", hwnd, msg, wparam, lparam)
    end
    
    # 投递消息
    static function PostMessage(hwnd, msg, wparam, lparam):
        User32.init()
        return User32.dll.callInt("PostMessageA", hwnd, msg, wparam, lparam) != 0
    end
    
    # 模拟按键
    static function keybd_event(vk, scan, flags, extra):
        User32.init()
        User32.dll.callVoid("keybd_event", vk, scan, flags, extra)
    end
    
    # 模拟鼠标
    static function mouse_event(flags, dx, dy, data, extra):
        User32.init()
        User32.dll.callVoid("mouse_event", flags, dx, dy, data, extra)
    end
end

# ========== Shell32 API ==========

class Shell32:
    static function init():
        if Shell32.dll == null:
            Shell32.dll = new DLL("shell32.dll")
        end
    end
    
    # 执行程序
    static function ShellExecute(hwnd, operation, file, params, dir, showCmd):
        Shell32.init()
        opPtr = new CString(operation)
        filePtr = new CString(file)
        paramsPtr = null
        dirPtr = null
        
        paramsArg = 0
        dirArg = 0
        
        if params != null and params != "":
            paramsPtr = new CString(params)
            paramsArg = paramsPtr.pointer()
        end
        if dir != null and dir != "":
            dirPtr = new CString(dir)
            dirArg = dirPtr.pointer()
        end
        
        result = Shell32.dll.callInt("ShellExecuteA", hwnd, opPtr.pointer(), filePtr.pointer(), paramsArg, dirArg, showCmd)
        
        opPtr.free()
        filePtr.free()
        if paramsPtr != null:
            paramsPtr.free()
        end
        if dirPtr != null:
            dirPtr.free()
        end
        return result
    end
    
    # 打开文件/URL
    static function Open(path):
        return Shell32.ShellExecute(0, "open", path, null, null, 1)
    end
    
    # 以管理员身份运行
    static function RunAs(path, params):
        return Shell32.ShellExecute(0, "runas", path, params, null, 1)
    end
    
    # 打开文件所在位置
    static function Explore(path):
        return Shell32.ShellExecute(0, "explore", path, null, null, 1)
    end
end

# ========== 便捷函数 ==========

# 简单消息框
function alert(msg):
    return User32.MessageBox(0, str(msg), "提示", MB_OK + MB_ICONINFO)
end

# 确认框
function confirm(msg):
    result = User32.MessageBox(0, str(msg), "确认", MB_YESNO + MB_ICONQUESTION)
    return result == IDYES
end

# 错误框
function error(msg):
    return User32.MessageBox(0, str(msg), "错误", MB_OK + MB_ICONERROR)
end

# 警告框
function warning(msg):
    return User32.MessageBox(0, str(msg), "警告", MB_OK + MB_ICONWARNING)
end

# 打开URL或文件
function open(path):
    return Shell32.Open(path)
end

# 蜂鸣
function beep(freq, duration):
    return Kernel32.Beep(freq, duration)
end

# 屏幕尺寸
function screenSize():
    return {
        "width": User32.ScreenWidth(),
        "height": User32.ScreenHeight()
    }
end
