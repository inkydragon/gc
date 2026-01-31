# ============================================
# MoonScript 标准库 - IO 操作
# 用法: from "stdlib/io.moon" import File, Dir, Path
# ============================================

# 文件操作类 (静态方法)
class File:
    # 读取整个文件
    static function read(path):
        if not exists(path):
            return null
        end
        return read_file(path)
    end
    
    # 写入文件 (覆盖)
    static function write(path, content):
        write_file(path, content)
        return true
    end
    
    # 追加内容
    static function append(path, content):
        append_file(path, content)
        return true
    end
    
    # 按行读取，返回列表
    static function readlines(path):
        if not exists(path):
            return []
        end
        content = read_file(path)
        if content == null:
            return []
        end
        return split(content, "\n")
    end
    
    # 写入多行
    static function writelines(path, lines):
        content = join(lines, "\n")
        write_file(path, content)
        return true
    end
    
    # 复制文件
    static function copy(src, dst):
        if not exists(src):
            return false
        end
        copy_file(src, dst)
        return true
    end
    
    # 移动文件
    static function move(src, dst):
        if not exists(src):
            return false
        end
        move_file(src, dst)
        return true
    end
    
    # 删除文件
    static function delete(path):
        if not exists(path):
            return false
        end
        remove_file(path)
        return true
    end
    
    # 获取文件大小
    static function size(path):
        if not exists(path):
            return -1
        end
        return file_size(path)
    end
    
    # 文件是否存在
    static function exists(path):
        return exists(path) and is_file(path)
    end
end

# 目录操作类 (静态方法)
class Dir:
    # 创建目录
    static function create(path):
        if exists(path):
            return false
        end
        create_dir(path)
        return true
    end
    
    # 创建多级目录
    static function mkdirs(path):
        parts = split(path, "/")
        current = ""
        for part in parts:
            if current == "":
                current = part
            else:
                current = current + "/" + part
            end
            if not exists(current):
                create_dir(current)
            end
        end
        return true
    end
    
    # 列出目录内容
    static function list(path):
        if not exists(path):
            return []
        end
        return list_dir(path)
    end
    
    # 列出所有文件 (不含目录)
    static function files(path):
        if not exists(path):
            return []
        end
        items = list_dir(path)
        result = []
        for item in items:
            full = path + "/" + item
            if is_file(full):
                append(result, item)
            end
        end
        return result
    end
    
    # 列出所有子目录
    static function dirs(path):
        if not exists(path):
            return []
        end
        items = list_dir(path)
        result = []
        for item in items:
            full = path + "/" + item
            if is_dir(full):
                append(result, item)
            end
        end
        return result
    end
    
    # 目录是否存在
    static function exists(path):
        return exists(path) and is_dir(path)
    end
end

# 路径工具类 (静态方法)
class Path:
    # 连接路径
    static function join(parts):
        return join(parts, "/")
    end
    
    # 获取文件名
    static function basename(path):
        parts = split(path, "/")
        return parts[len(parts) - 1]
    end
    
    # 获取目录名
    static function dirname(path):
        parts = split(path, "/")
        if len(parts) <= 1:
            return "."
        end
        pop(parts)
        return join(parts, "/")
    end
    
    # 获取扩展名
    static function ext(path):
        parts = split(path, "/")
        name = parts[len(parts) - 1]
        dot_parts = split(name, ".")
        if len(dot_parts) <= 1:
            return ""
        end
        return dot_parts[len(dot_parts) - 1]
    end
    
    # 去除扩展名，获取文件名主体
    static function stem(path):
        parts = split(path, "/")
        name = parts[len(parts) - 1]
        dot_parts = split(name, ".")
        if len(dot_parts) <= 1:
            return name
        end
        pop(dot_parts)
        return join(dot_parts, ".")
    end
end
