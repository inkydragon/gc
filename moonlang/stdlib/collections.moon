# ============================================
# MoonScript 标准库 - 集合类型
# 用法: from "stdlib/collections.moon" import *
# ============================================

# ========== 栈 (Stack) ==========

class Stack:
    function init():
        self.items = []
    end
    
    # 压入
    function push(item):
        append(self.items, item)
        return self
    end
    
    # 弹出
    function pop():
        if self.isEmpty():
            return null
        end
        return pop(self.items)
    end
    
    # 查看栈顶
    function peek():
        if self.isEmpty():
            return null
        end
        return self.items[len(self.items) - 1]
    end
    
    # 是否为空
    function isEmpty():
        return len(self.items) == 0
    end
    
    # 大小
    function size():
        return len(self.items)
    end
    
    # 清空
    function clear():
        self.items = []
        return self
    end
    
    # 转为列表
    function toList():
        return self.items
    end
end

# ========== 队列 (Queue) ==========

class Queue:
    function init():
        self.items = []
    end
    
    # 入队
    function enqueue(item):
        append(self.items, item)
        return self
    end
    
    # 出队
    function dequeue():
        if self.isEmpty():
            return null
        end
        item = self.items[0]
        self.items = slice(self.items, 1, len(self.items))
        return item
    end
    
    # 查看队首
    function front():
        if self.isEmpty():
            return null
        end
        return self.items[0]
    end
    
    # 查看队尾
    function back():
        if self.isEmpty():
            return null
        end
        return self.items[len(self.items) - 1]
    end
    
    # 是否为空
    function isEmpty():
        return len(self.items) == 0
    end
    
    # 大小
    function size():
        return len(self.items)
    end
    
    # 清空
    function clear():
        self.items = []
        return self
    end
    
    # 转为列表
    function toList():
        return self.items
    end
end

# ========== 双端队列 (Deque) ==========

class Deque:
    function init():
        self.items = []
    end
    
    # 从前端添加
    function pushFront(item):
        self.items = [item] + self.items
        return self
    end
    
    # 从后端添加
    function pushBack(item):
        append(self.items, item)
        return self
    end
    
    # 从前端移除
    function popFront():
        if self.isEmpty():
            return null
        end
        item = self.items[0]
        self.items = slice(self.items, 1, len(self.items))
        return item
    end
    
    # 从后端移除
    function popBack():
        if self.isEmpty():
            return null
        end
        return pop(self.items)
    end
    
    # 查看前端
    function peekFront():
        if self.isEmpty():
            return null
        end
        return self.items[0]
    end
    
    # 查看后端
    function peekBack():
        if self.isEmpty():
            return null
        end
        return self.items[len(self.items) - 1]
    end
    
    # 是否为空
    function isEmpty():
        return len(self.items) == 0
    end
    
    # 大小
    function size():
        return len(self.items)
    end
    
    # 清空
    function clear():
        self.items = []
        return self
    end
end

# ========== 集合 (Set) ==========

class Set:
    function init(items):
        self.data = {}
        if items != null:
            for item in items:
                self.add(item)
            end
        end
    end
    
    # 添加
    function add(item):
        self.data[str(item)] = item
        return self
    end
    
    # 移除
    function remove(item):
        key = str(item)
        if has_key(self.data, key):
            delete_key(self.data, key)
        end
        return self
    end
    
    # 是否包含
    function has(item):
        return has_key(self.data, str(item))
    end
    
    # 大小
    function size():
        return len(keys(self.data))
    end
    
    # 是否为空
    function isEmpty():
        return self.size() == 0
    end
    
    # 清空
    function clear():
        self.data = {}
        return self
    end
    
    # 转为列表
    function toList():
        return values(self.data)
    end
    
    # 并集
    function union(other):
        result = new Set(null)
        for item in self.toList():
            result.add(item)
        end
        for item in other.toList():
            result.add(item)
        end
        return result
    end
    
    # 交集
    function intersection(other):
        result = new Set(null)
        for item in self.toList():
            if other.has(item):
                result.add(item)
            end
        end
        return result
    end
    
    # 差集
    function difference(other):
        result = new Set(null)
        for item in self.toList():
            if not other.has(item):
                result.add(item)
            end
        end
        return result
    end
    
    # 是否是子集
    function isSubset(other):
        for item in self.toList():
            if not other.has(item):
                return false
            end
        end
        return true
    end
end

# ========== 有序字典 (OrderedDict) ==========

class OrderedDict:
    function init():
        self.keys_list = []
        self.data = {}
    end
    
    # 设置值
    function set(key, value):
        if not has_key(self.data, key):
            append(self.keys_list, key)
        end
        self.data[key] = value
        return self
    end
    
    # 获取值
    function get(key, defaultVal):
        return get(self.data, key, defaultVal)
    end
    
    # 是否包含
    function has(key):
        return has_key(self.data, key)
    end
    
    # 删除
    function delete(key):
        if has_key(self.data, key):
            delete_key(self.data, key)
            # 从keys_list中移除
            newKeys = []
            for k in self.keys_list:
                if k != key:
                    append(newKeys, k)
                end
            end
            self.keys_list = newKeys
        end
        return self
    end
    
    # 所有键 (保持顺序)
    function keys():
        return self.keys_list
    end
    
    # 所有值 (保持顺序)
    function values():
        result = []
        for k in self.keys_list:
            append(result, self.data[k])
        end
        return result
    end
    
    # 所有条目 (保持顺序)
    function entries():
        result = []
        for k in self.keys_list:
            append(result, [k, self.data[k]])
        end
        return result
    end
    
    # 大小
    function size():
        return len(self.keys_list)
    end
    
    # 清空
    function clear():
        self.keys_list = []
        self.data = {}
        return self
    end
end

# ========== 计数器 (Counter) ==========

class Counter:
    function init(items):
        self.data = {}
        if items != null:
            for item in items:
                self.add(item)
            end
        end
    end
    
    # 添加计数
    function add(item, count):
        if count == null:
            count = 1
        end
        key = str(item)
        if has_key(self.data, key):
            self.data[key] = self.data[key] + count
        else:
            self.data[key] = count
        end
        return self
    end
    
    # 获取计数
    function count(item):
        return get(self.data, str(item), 0)
    end
    
    # 获取最常见的n个
    function mostCommon(n):
        items = []
        for k in keys(self.data):
            append(items, [k, self.data[k]])
        end
        # 简单排序
        for i = 0 to len(items) - 2:
            for j = i + 1 to len(items) - 1:
                if items[j][1] > items[i][1]:
                    temp = items[i]
                    items[i] = items[j]
                    items[j] = temp
                end
            end
        end
        if n != null and n < len(items):
            return slice(items, 0, n)
        end
        return items
    end
    
    # 总计数
    function total():
        result = 0
        for k in keys(self.data):
            result = result + self.data[k]
        end
        return result
    end
    
    # 所有元素
    function elements():
        return keys(self.data)
    end
end

# ========== 默认字典 (DefaultDict) ==========

class DefaultDict:
    function init(defaultFactory):
        self.data = {}
        self.defaultFactory = defaultFactory
    end
    
    # 获取值 (不存在时使用默认值)
    function get(key):
        if not has_key(self.data, key):
            self.data[key] = self.defaultFactory()
        end
        return self.data[key]
    end
    
    # 设置值
    function set(key, value):
        self.data[key] = value
        return self
    end
    
    # 是否包含
    function has(key):
        return has_key(self.data, key)
    end
    
    # 所有键
    function keys():
        return keys(self.data)
    end
    
    # 所有值
    function values():
        return values(self.data)
    end
end

# ========== 快捷函数 ==========

function stack():
    return new Stack()
end

function queue():
    return new Queue()
end

function deque():
    return new Deque()
end

function set(items):
    return new Set(items)
end

function orderedDict():
    return new OrderedDict()
end

function counter(items):
    return new Counter(items)
end

function defaultDict(factory):
    return new DefaultDict(factory)
end
