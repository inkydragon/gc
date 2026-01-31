# ============================================
# MoonScript 标准库 - DLL 操作
# 用法: from "stdlib/dll.moon" import DLL, WinAPI
# ============================================

# DLL封装类
class DLL:
    function init(path):
        self.path = path
        self.handle = dll_load(path)
        self.funcs = {}
    end
    
    # 获取函数
    function getFunc(name):
        if not has_key(self.funcs, name):
            self.funcs[name] = dll_func(self.handle, name)
        end
        return self.funcs[name]
    end
    
    # 调用函数 - 返回int
    function callInt(name, arg1, arg2, arg3, arg4):
        f = self.getFunc(name)
        if arg4 != null:
            return dll_call_int(f, arg1, arg2, arg3, arg4)
        elif arg3 != null:
            return dll_call_int(f, arg1, arg2, arg3)
        elif arg2 != null:
            return dll_call_int(f, arg1, arg2)
        elif arg1 != null:
            return dll_call_int(f, arg1)
        else:
            return dll_call_int(f)
        end
    end
    
    # 调用函数 - 返回double
    function callDouble(name, arg1, arg2, arg3, arg4):
        f = self.getFunc(name)
        if arg4 != null:
            return dll_call_double(f, arg1, arg2, arg3, arg4)
        elif arg3 != null:
            return dll_call_double(f, arg1, arg2, arg3)
        elif arg2 != null:
            return dll_call_double(f, arg1, arg2)
        elif arg1 != null:
            return dll_call_double(f, arg1)
        else:
            return dll_call_double(f)
        end
    end
    
    # 调用函数 - 无返回值
    function callVoid(name, arg1, arg2, arg3, arg4):
        f = self.getFunc(name)
        if arg4 != null:
            dll_call_void(f, arg1, arg2, arg3, arg4)
        elif arg3 != null:
            dll_call_void(f, arg1, arg2, arg3)
        elif arg2 != null:
            dll_call_void(f, arg1, arg2)
        elif arg1 != null:
            dll_call_void(f, arg1)
        else:
            dll_call_void(f)
        end
    end
    
    # 关闭DLL
    function close():
        dll_close(self.handle)
    end
end

# 字符串内存管理
class CString:
    function init(text):
        self.text = text
        self.ptr = alloc_str(text)
    end
    
    # 获取指针
    function pointer():
        return self.ptr
    end
    
    # 读取当前值
    function read():
        return ptr_to_str(self.ptr)
    end
    
    # 释放
    function free():
        free_str(self.ptr)
    end
end

# 创建缓冲区 (返回 CString 对象)
function buffer(size):
    return new CString(repeat("X", size))
end

# 创建指针缓冲区 (返回清零的地址，专门用于存储指针)
function ptr_buffer():
    buf = alloc_str("XXXXXXXX")
    write_ptr(buf, 0)
    return buf
end

# Windows API 封装 (使用模块级变量存储DLL句柄)
_winapi_data = {"kernel32": null, "user32": null}

class WinAPI:
    static function init():
        _winapi_data["kernel32"] = new DLL("kernel32.dll")
        _winapi_data["user32"] = new DLL("user32.dll")
    end
    
    # 获取进程ID
    static function getProcessId():
        return _winapi_data["kernel32"].callInt("GetCurrentProcessId", null, null, null, null)
    end
    
    # 获取线程ID
    static function getThreadId():
        return _winapi_data["kernel32"].callInt("GetCurrentThreadId", null, null, null, null)
    end
    
    # 消息框
    static function messageBox(text, title, flags):
        textPtr = new CString(text)
        titlePtr = new CString(title)
        result = _winapi_data["user32"].callInt("MessageBoxA", 0, textPtr.pointer(), titlePtr.pointer(), flags)
        textPtr.free()
        titlePtr.free()
        return result
    end
    
    # 简单消息框
    static function alert(msg):
        textPtr = new CString(msg)
        titlePtr = new CString("提示")
        result = _winapi_data["user32"].callInt("MessageBoxA", 0, textPtr.pointer(), titlePtr.pointer(), 0)
        textPtr.free()
        titlePtr.free()
        return result
    end
    
    # 确认框
    static function confirm(msg):
        textPtr = new CString(msg)
        titlePtr = new CString("确认")
        result = _winapi_data["user32"].callInt("MessageBoxA", 0, textPtr.pointer(), titlePtr.pointer(), 4)
        textPtr.free()
        titlePtr.free()
        return result == 6
    end
    
    # 获取系统目录
    static function getSystemDirectory():
        buf = buffer(260)
        _winapi_data["kernel32"].callInt("GetSystemDirectoryA", buf.pointer(), 260, null, null)
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取Windows目录
    static function getWindowsDirectory():
        buf = buffer(260)
        _winapi_data["kernel32"].callInt("GetWindowsDirectoryA", buf.pointer(), 260, null, null)
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取临时目录
    static function getTempPath():
        buf = buffer(260)
        _winapi_data["kernel32"].callInt("GetTempPathA", 260, buf.pointer(), null, null)
        result = buf.read()
        buf.free()
        return result
    end
    
    # 获取计算机名
    static function getComputerName():
        buf = buffer(260)
        sizePtr = new CString(repeat(" ", 4))
        _winapi_data["kernel32"].callInt("GetComputerNameA", buf.pointer(), sizePtr.pointer(), null, null)
        result = buf.read()
        buf.free()
        sizePtr.free()
        return result
    end
    
    # 休眠
    static function sleep(ms):
        _winapi_data["kernel32"].callVoid("Sleep", ms, null, null, null)
    end
    
    # 蜂鸣
    static function beep(freq, duration):
        return _winapi_data["kernel32"].callInt("Beep", freq, duration, null, null)
    end
    
    # 关闭
    static function cleanup():
        _winapi_data["kernel32"].close()
        _winapi_data["user32"].close()
    end
end

# MoonScript DLL封装 (用于调用moondll编译的DLL)
class MoonDLL:
    function init(path):
        self.dll = new DLL(path)
        self._init = self.dll.getFunc("moon_init")
        self._call = self.dll.getFunc("moon_call")
        self._get = self.dll.getFunc("moon_get")
        self._cleanup = self.dll.getFunc("moon_cleanup")
        
        # 初始化
        dll_call_int(self._init)
    end
    
    # 调用函数
    function call(funcName, args):
        namePtr = new CString(funcName)
        argsJson = json_encode(args)
        argsPtr = new CString(argsJson)
        
        resultPtr = dll_call_int(self._call, namePtr.pointer(), argsPtr.pointer())
        result = ptr_to_str(resultPtr)
        
        namePtr.free()
        argsPtr.free()
        
        if result != "" and result != "null":
            return json_decode(result)
        end
        return null
    end
    
    # 获取变量
    function get(varName):
        namePtr = new CString(varName)
        resultPtr = dll_call_int(self._get, namePtr.pointer())
        result = ptr_to_str(resultPtr)
        namePtr.free()
        
        if result != "" and result != "null":
            return json_decode(result)
        end
        return null
    end
    
    # 关闭
    function close():
        dll_call_void(self._cleanup)
        self.dll.close()
    end
end

# 快捷函数
function loadDLL(path):
    return new DLL(path)
end

function loadMoonDLL(path):
    return new MoonDLL(path)
end

function cstring(text):
    return new CString(text)
end
