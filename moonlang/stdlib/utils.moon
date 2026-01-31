# ============================================
# MoonScript 标准库 - 实用工具
# 用法: from "stdlib/utils.moon" import *
# ============================================
#
# 注意：以下函数已内置到运行时，无需导入即可使用：
#   - map(fn, list)       映射
#   - filter(fn, list)    过滤
#   - reduce(fn, list, initial)  归约
#   - pad_left(str, width, char)  左填充
#   - pad_right(str, width, char) 右填充
#   - take(list, n)       取前n个
#   - drop(list, n)       跳过前n个
#   - zip(a, b)           压缩两个列表
#   - range(start, stop, step)  范围生成
#
# ============================================

# ========== 字符串工具 ==========

# 格式化字符串 (简单版)
function format(template, values):
    result = template
    for i = 0 to len(values) - 1:
        result = replace(result, "{" + str(i) + "}", str(values[i]))
    end
    return result
end

# 重复字符串
function times(s, n):
    return repeat(s, n)
end

# 首字母大写 (注: capitalize 已内置)
# function capitalize(s):
#     if len(s) == 0:
#         return s
#     end
#     return to_upper(substring(s, 0, 1)) + substring(s, 1, len(s) - 1)
# end

# 驼峰转下划线
function toSnakeCase(s):
    result = ""
    for i = 0 to len(s) - 1:
        c = substring(s, i, 1)
        if c >= "A" and c <= "Z":
            if i > 0:
                result = result + "_"
            end
            result = result + to_lower(c)
        else:
            result = result + c
        end
    end
    return result
end

# ========== 列表工具 ==========

# 查找 (返回第一个满足条件的元素)
function find(list, fn):
    for item in list:
        if fn(item):
            return item
        end
    end
    return null
end

# 任一满足
function any(list, fn):
    for item in list:
        if fn(item):
            return true
        end
    end
    return false
end

# 全部满足
function all(list, fn):
    for item in list:
        if not fn(item):
            return false
        end
    end
    return true
end

# 分组
function groupBy(list, keyFunc):
    groups = {}
    for item in list:
        key = keyFunc(item)
        if not has_key(groups, key):
            groups[key] = []
        end
        append(groups[key], item)
    end
    return groups
end

# 去重 (保持顺序) - 别名，unique 已内置
function distinct(list):
    return unique(list)
end

# 跳过前n个 - 别名，drop 已内置
function skip(list, n):
    return drop(list, n)
end

# ========== 数学工具 ==========

# 平均值
function average(list):
    if len(list) == 0:
        return 0
    end
    return sum(list) / len(list)
end

# 中位数
function median(list):
    sorted = sort(list)
    n = len(sorted)
    if n == 0:
        return 0
    end
    mid = n / 2
    if n % 2 == 0:
        return (sorted[mid - 1] + sorted[mid]) / 2
    else:
        return sorted[mid]
    end
end

# ========== 日期时间工具 ==========

class DateTime:
    function init(ts):
        if ts == null:
            self.timestamp = time()
        else:
            self.timestamp = ts
        end
    end
    
    function year():
        return year(self.timestamp)
    end
    
    function month():
        return month(self.timestamp)
    end
    
    function day():
        return day(self.timestamp)
    end
    
    function hour():
        return hour(self.timestamp)
    end
    
    function minute():
        return minute(self.timestamp)
    end
    
    function second():
        return second(self.timestamp)
    end
    
    function format(fmt):
        return date_format(self.timestamp, fmt)
    end
    
    function toString():
        return self.format("%Y-%m-%d %H:%M:%S")
    end
    
    function toDateString():
        return self.format("%Y-%m-%d")
    end
    
    function toTimeString():
        return self.format("%H:%M:%S")
    end
    
    static function now():
        return new DateTime(null)
    end
end

# ========== 其他工具 ==========

# 计时器
class Timer:
    function init():
        self.start_time = 0
        self.end_time = 0
    end
    
    function start():
        self.start_time = time()
        return self
    end
    
    function stop():
        self.end_time = time()
        return self
    end
    
    function elapsed():
        if self.end_time > 0:
            return self.end_time - self.start_time
        end
        return time() - self.start_time
    end
    
    function elapsedMs():
        return self.elapsed()
    end
end

# 简单缓存
class Cache:
    function init():
        self.data = {}
    end
    
    function set(key, value):
        self.data[key] = value
        return self
    end
    
    function getValue(key, defaultVal):
        return get(self.data, key, defaultVal)
    end
    
    function has(key):
        return has_key(self.data, key)
    end
    
    function delete(key):
        if has_key(self.data, key):
            delete_key(self.data, key)
        end
        return self
    end
    
    function clear():
        self.data = {}
        return self
    end
    
    function size():
        return len(keys(self.data))
    end
end

# UUID生成 (简单版)
function uuid():
    chars = "0123456789abcdef"
    result = ""
    for i = 1 to 32:
        result = result + substring(chars, random_int(0, 15), 1)
        if i == 8 or i == 12 or i == 16 or i == 20:
            result = result + "-"
        end
    end
    return result
end

# 随机字符串
function randomString(length, charset):
    if charset == null:
        charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    end
    result = ""
    for i = 1 to length:
        result = result + substring(charset, random_int(0, len(charset) - 1), 1)
    end
    return result
end
