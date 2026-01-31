# ============================================
# MoonScript DLL 加载器
# 让 DLL 调用像 import 一样简单
# 用法: dll = load_moon_dll("dlls/xxx.dll")
#       result = dll.call("funcName", arg1, arg2)
# ============================================

# 加载 MoonScript DLL 并返回封装对象
function load_moon_dll(path):
    handle = dll_load(path)
    if handle == 0:
        print("错误: 无法加载 DLL:", path)
        return null
    end
    
    # 获取标准函数
    fn_init = dll_func(handle, "moon_init")
    fn_call = dll_func(handle, "moon_call")
    fn_get = dll_func(handle, "moon_get")
    fn_cleanup = dll_func(handle, "moon_cleanup")
    
    # 初始化
    dll_call_void(fn_init)
    
    # 返回封装对象
    return {
        "_handle": handle,
        "_fn_call": fn_call,
        "_fn_get": fn_get,
        "_fn_cleanup": fn_cleanup,
        "_path": path
    }
end

# 调用 DLL 函数 (最多4个参数)
function dll_call(dll, func_name, a, b, c, d):
    if dll == null:
        return null
    end
    
    # 构建参数 JSON
    args = "["
    count = 0
    if a != null:
        args = args + json_encode(a)
        count = count + 1
    end
    if b != null:
        args = args + ", " + json_encode(b)
        count = count + 1
    end
    if c != null:
        args = args + ", " + json_encode(c)
        count = count + 1
    end
    if d != null:
        args = args + ", " + json_encode(d)
        count = count + 1
    end
    args = args + "]"
    
    # 调用
    name_ptr = alloc_str(func_name)
    args_ptr = alloc_str(args)
    result_ptr = dll_call_int(dll["_fn_call"], name_ptr, args_ptr)
    result_str = ptr_to_str(result_ptr)
    free_str(name_ptr)
    free_str(args_ptr)
    
    # 解析结果
    if result_str == "" or result_str == "null":
        return null
    end
    return json_decode(result_str)
end

# 获取 DLL 变量
function dll_var(dll, var_name):
    if dll == null:
        return null
    end
    
    name_ptr = alloc_str(var_name)
    result_ptr = dll_call_int(dll["_fn_get"], name_ptr)
    result_str = ptr_to_str(result_ptr)
    free_str(name_ptr)
    
    if result_str == "" or result_str == "null":
        return null
    end
    return json_decode(result_str)
end

# 关闭 DLL
function dll_unload(dll):
    if dll == null:
        return
    end
    dll_call_void(dll["_fn_cleanup"])
    dll_close(dll["_handle"])
end

# ============================================
# 更简洁的语法糖
# ============================================

# 创建可直接调用函数的代理
function moon_dll(path):
    dll = load_moon_dll(path)
    if dll == null:
        return null
    end
    
    # 返回代理对象，包含快捷方法
    return {
        "_dll": dll,
        "path": path,
        
        # 调用函数 - 支持 0-4 个参数
        "call": (name, a, b, c, d) => dll_call(dll, name, a, b, c, d),
        
        # 获取变量
        "get": (name) => dll_var(dll, name),
        
        # 关闭
        "close": () => dll_unload(dll)
    }
end
