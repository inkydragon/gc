# ============================================
# MoonLang 标准库 - 跨进程内存操作
# 用法: from "stdlib/process.moon" import Process
# ============================================
# 
# 示例:
#   proc = Process.open(1234)  # 通过 PID 打开进程
#   value = proc.readInt32(0x12345678)  # 读取 32 位整数
#   proc.writeInt32(0x12345678, 999)    # 写入 32 位整数
#   proc.close()
#
# 注意: 需要管理员权限才能操作其他进程
# ============================================

# Windows API 常量
PROCESS_ALL_ACCESS = 2035711
PROCESS_VM_READ = 16
PROCESS_VM_WRITE = 32
PROCESS_VM_OPERATION = 8
PROCESS_QUERY_INFORMATION = 1024
PROCESS_VM_RW = 56
MEM_COMMIT = 4096
MEM_RESERVE = 8192
MEM_RELEASE = 32768
PAGE_READWRITE = 4
PAGE_EXECUTE_READWRITE = 64

# 模块级变量
_kernel32 = null
_kernel32_funcs = {}

# 初始化 kernel32.dll
function _init_kernel32():
    global _kernel32, _kernel32_funcs
    if _kernel32 == null:
        _kernel32 = dll_load("kernel32.dll")
        _kernel32_funcs["OpenProcess"] = dll_func(_kernel32, "OpenProcess")
        _kernel32_funcs["CloseHandle"] = dll_func(_kernel32, "CloseHandle")
        _kernel32_funcs["ReadProcessMemory"] = dll_func(_kernel32, "ReadProcessMemory")
        _kernel32_funcs["WriteProcessMemory"] = dll_func(_kernel32, "WriteProcessMemory")
        _kernel32_funcs["VirtualAllocEx"] = dll_func(_kernel32, "VirtualAllocEx")
        _kernel32_funcs["VirtualFreeEx"] = dll_func(_kernel32, "VirtualFreeEx")
        _kernel32_funcs["GetLastError"] = dll_func(_kernel32, "GetLastError")
    end
end

# 获取最后的错误码
function getLastError():
    global _kernel32_funcs
    _init_kernel32()
    return dll_call_int(_kernel32_funcs["GetLastError"])
end

# 进程类
class Process:
    static function open(pid):
        return Process._openWithAccess(pid, PROCESS_ALL_ACCESS)
    end
    
    static function openReadOnly(pid):
        return Process._openWithAccess(pid, PROCESS_VM_READ + PROCESS_QUERY_INFORMATION)
    end
    
    static function openReadWrite(pid):
        return Process._openWithAccess(pid, PROCESS_VM_RW + PROCESS_QUERY_INFORMATION)
    end
    
    static function _openWithAccess(pid, access):
        global _kernel32_funcs
        _init_kernel32()
        handle = dll_call_int(_kernel32_funcs["OpenProcess"], access, 0, pid)
        if handle == 0:
            return null
        end
        proc = new Process()
        proc.handle = handle
        proc.pid = pid
        return proc
    end
    
    function init():
        self.handle = 0
        self.pid = 0
    end
    
    function isValid():
        return self.handle != 0
    end
    
    # 读取 32 位整数
    function readInt32(address):
        global _kernel32_funcs
        buffer = alloc_str("XXXX")
        bytesRead = alloc_str("XXXX")
        write_ptr(bytesRead, 0)
        f = _kernel32_funcs["ReadProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, 4, bytesRead)
        if result == 0:
            free_str(buffer)
            free_str(bytesRead)
            return null
        end
        value = read_int32(buffer)
        free_str(buffer)
        free_str(bytesRead)
        return value
    end
    
    # 读取 64 位整数
    function readInt64(address):
        global _kernel32_funcs
        buffer = alloc_str("XXXXXXXX")
        bytesRead = alloc_str("XXXXXXXX")
        write_ptr(bytesRead, 0)
        f = _kernel32_funcs["ReadProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, 8, bytesRead)
        if result == 0:
            free_str(buffer)
            free_str(bytesRead)
            return null
        end
        value = read_ptr(buffer)
        free_str(buffer)
        free_str(bytesRead)
        return value
    end
    
    # 读取字符串
    function readString(address, maxLength):
        global _kernel32_funcs
        buffer = alloc_str(repeat("X", maxLength))
        bytesRead = alloc_str("XXXXXXXX")
        write_ptr(bytesRead, 0)
        f = _kernel32_funcs["ReadProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, maxLength, bytesRead)
        if result == 0:
            free_str(buffer)
            free_str(bytesRead)
            return null
        end
        str = ptr_to_str(buffer)
        free_str(buffer)
        free_str(bytesRead)
        return str
    end
    
    # 写入 32 位整数
    function writeInt32(address, value):
        global _kernel32_funcs
        buffer = alloc_str("XXXX")
        write_int32(buffer, value)
        bytesWritten = alloc_str("XXXX")
        write_ptr(bytesWritten, 0)
        f = _kernel32_funcs["WriteProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, 4, bytesWritten)
        free_str(buffer)
        free_str(bytesWritten)
        return result != 0
    end
    
    # 写入 64 位整数
    function writeInt64(address, value):
        global _kernel32_funcs
        buffer = alloc_str("XXXXXXXX")
        write_ptr(buffer, value)
        bytesWritten = alloc_str("XXXXXXXX")
        write_ptr(bytesWritten, 0)
        f = _kernel32_funcs["WriteProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, 8, bytesWritten)
        free_str(buffer)
        free_str(bytesWritten)
        return result != 0
    end
    
    # 写入字符串
    function writeString(address, str):
        global _kernel32_funcs
        data = str + chr(0)
        size = len(data)
        buffer = alloc_str(data)
        bytesWritten = alloc_str("XXXXXXXX")
        write_ptr(bytesWritten, 0)
        f = _kernel32_funcs["WriteProcessMemory"]
        result = dll_call_int(f, self.handle, address, buffer, size, bytesWritten)
        free_str(buffer)
        free_str(bytesWritten)
        return result != 0
    end
    
    # 分配内存
    function allocate(size):
        global _kernel32_funcs
        f = _kernel32_funcs["VirtualAllocEx"]
        flags = MEM_COMMIT + MEM_RESERVE
        address = dll_call_int(f, self.handle, 0, size, flags, PAGE_READWRITE)
        return address
    end
    
    # 释放内存
    function free(address):
        global _kernel32_funcs
        f = _kernel32_funcs["VirtualFreeEx"]
        result = dll_call_int(f, self.handle, address, 0, MEM_RELEASE)
        return result != 0
    end
    
    # 关闭进程
    function close():
        global _kernel32_funcs
        if self.handle != 0:
            dll_call_int(_kernel32_funcs["CloseHandle"], self.handle)
            self.handle = 0
        end
    end
end

# 通过进程名查找 PID
function findProcessByName(name):
    output = shell_output("tasklist /FO CSV /NH")
    lines = split(output, "\n")
    for line in lines:
        if contains(line, name):
            parts = split(line, ",")
            if len(parts) >= 2:
                pidStr = replace(parts[1], "\"", "")
                pidStr = trim(pidStr)
                if is_digit(pidStr):
                    return int(pidStr)
                end
            end
        end
    end
    return 0
end

# 通过进程名打开进程
function openProcessByName(name):
    pid = findProcessByName(name)
    if pid == 0:
        return null
    end
    return Process.open(pid)
end
