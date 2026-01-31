# ============================================
# MoonScript 标准库 - 系统操作
# 用法: from "stdlib/sys.moon" import *
# ============================================

# ========== 环境变量 ==========

# 获取环境变量
function getenv(name):
    return env(name)
end

# 设置环境变量
function setenv(name, value):
    return set_env(name, value)
end

# 获取所有环境变量
function environ():
    return env_list()
end

# ========== 系统信息 ==========

class System:
    # 操作系统
    static function os():
        return "windows"
    end
    
    # 处理器架构
    static function arch():
        return env("PROCESSOR_ARCHITECTURE")
    end
    
    # 用户名
    static function username():
        return env("USERNAME")
    end
    
    # 计算机名
    static function hostname():
        return env("COMPUTERNAME")
    end
    
    # 用户目录
    static function home():
        return env("USERPROFILE")
    end
    
    # 临时目录
    static function temp():
        return env("TEMP")
    end
    
    # 系统目录
    static function windir():
        return env("WINDIR")
    end
    
    # 程序文件目录
    static function programFiles():
        return env("PROGRAMFILES")
    end
    
    # 当前目录
    static function cwd():
        return getcwd()
    end
    
    # 改变目录
    static function chdir(path):
        return cd(path)
    end
    
    # 执行命令
    static function exec(cmd):
        return shell(cmd)
    end
    
    # 执行命令并获取输出
    static function execOutput(cmd):
        return shell_output(cmd)
    end
    
    # 退出程序
    static function exit(code):
        exit(code)
    end
    
    # 休眠
    static function sleep(ms):
        sleep(ms)
    end
end

# ========== 进程信息 ==========

class Process:
    # 当前进程ID
    static function pid():
        return getpid()
    end
    
    # 命令行参数
    static function args():
        return argv()
    end
    
    # 可执行文件路径
    static function executable():
        return exepath()
    end
end

# ========== 注册表操作 (Windows) ==========

# 预定义根键
HKEY_CLASSES_ROOT = 2147483648
HKEY_CURRENT_USER = 2147483649
HKEY_LOCAL_MACHINE = 2147483650
HKEY_USERS = 2147483651

class Registry:
    # 读取字符串值
    static function getString(root, path, name):
        return reg_read_string(root, path, name)
    end
    
    # 读取整数值
    static function getInt(root, path, name):
        return reg_read_int(root, path, name)
    end
end

# ========== 剪贴板 ==========

class Clipboard:
    # 获取文本
    static function getText():
        return clipboard_get()
    end
    
    # 设置文本
    static function setText(text):
        return clipboard_set(text)
    end
end

# ========== 快捷函数 ==========

function exec(cmd):
    return System.exec(cmd)
end

function sleep(ms):
    return System.sleep(ms)
end

function cwd():
    return System.cwd()
end

function chdir(path):
    return System.chdir(path)
end
