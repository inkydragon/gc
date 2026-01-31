# ============================================
# MoonScript 标准库 - 扩展数学库
# 用法: from "stdlib/math.moon" import *
# ============================================

# ========== 常量 ==========

PI = 3.14159265358979323846
E = 2.71828182845904523536
TAU = 6.28318530717958647692  # 2 * PI
PHI = 1.61803398874989484820  # 黄金比例
SQRT2 = 1.41421356237309504880
SQRT3 = 1.73205080756887729352
LN2 = 0.69314718055994530942
LN10 = 2.30258509299404568402

# ========== 基本数学函数 ==========

# 绝对值
function abs(x):
    if x < 0:
        return -x
    end
    return x
end

# 符号函数
function sign(x):
    if x > 0:
        return 1
    elif x < 0:
        return -1
    end
    return 0
end

# 向下取整
function floor(x):
    return int(x)
end

# 向上取整
function ceil(x):
    i = int(x)
    if x > i:
        return i + 1
    end
    return i
end

# 四舍五入
function round(x, decimals):
    if decimals == null:
        decimals = 0
    end
    factor = pow(10, decimals)
    return int(x * factor + 0.5) / factor
end

# 截断
function trunc(x):
    return int(x)
end

# 钳制范围
function clamp(x, minVal, maxVal):
    if x < minVal:
        return minVal
    end
    if x > maxVal:
        return maxVal
    end
    return x
end

# 线性插值
function lerp(a, b, t):
    return a + (b - a) * t
end

# 映射范围
function mapRange(x, inMin, inMax, outMin, outMax):
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

# ========== 幂和对数 ==========

# 幂运算
function pow(base, exp):
    return power(base, exp)
end

# 平方根
function sqrt(x):
    return power(x, 0.5)
end

# 立方根
function cbrt(x):
    if x < 0:
        return -power(-x, 1/3)
    end
    return power(x, 1/3)
end

# 自然对数 (简化近似)
function ln(x):
    if x <= 0:
        return null
    end
    # 使用牛顿迭代法近似
    result = 0
    term = (x - 1) / (x + 1)
    term2 = term * term
    n = 1
    current = term
    while abs(current) > 0.0000001 and n < 100:
        result = result + current / n
        current = current * term2
        n = n + 2
    end
    return 2 * result
end

# 以10为底的对数
function log10(x):
    return ln(x) / LN10
end

# 以2为底的对数
function log2(x):
    return ln(x) / LN2
end

# 任意底的对数
function log(x, base):
    if base == null:
        return ln(x)
    end
    return ln(x) / ln(base)
end

# 指数函数 e^x
function exp(x):
    return pow(E, x)
end

# ========== 三角函数 (简化近似) ==========

# 角度转弧度
function radians(degrees):
    return degrees * PI / 180
end

# 弧度转角度
function degrees(radians):
    return radians * 180 / PI
end

# 正弦 (泰勒级数近似)
function sin(x):
    # 归一化到 [-PI, PI]
    while x > PI:
        x = x - TAU
    end
    while x < -PI:
        x = x + TAU
    end
    
    result = 0
    term = x
    n = 1
    while abs(term) > 0.0000001 and n < 20:
        result = result + term
        term = -term * x * x / ((n + 1) * (n + 2))
        n = n + 2
    end
    return result
end

# 余弦
function cos(x):
    return sin(x + PI / 2)
end

# 正切
function tan(x):
    c = cos(x)
    if abs(c) < 0.0000001:
        return null
    end
    return sin(x) / c
end

# ========== 统计函数 ==========

# 求和
function sum(list):
    result = 0
    for item in list:
        result = result + item
    end
    return result
end

# 最小值
function min(list):
    if len(list) == 0:
        return null
    end
    result = list[0]
    for item in list:
        if item < result:
            result = item
        end
    end
    return result
end

# 最大值
function max(list):
    if len(list) == 0:
        return null
    end
    result = list[0]
    for item in list:
        if item > result:
            result = item
        end
    end
    return result
end

# 平均值
function mean(list):
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
    mid = int(n / 2)
    if n % 2 == 0:
        return (sorted[mid - 1] + sorted[mid]) / 2
    else:
        return sorted[mid]
    end
end

# 众数 (简化版)
function mode(list):
    counts = {}
    for item in list:
        key = str(item)
        if has_key(counts, key):
            counts[key] = counts[key] + 1
        else:
            counts[key] = 1
        end
    end
    
    maxCount = 0
    result = null
    for item in list:
        key = str(item)
        if counts[key] > maxCount:
            maxCount = counts[key]
            result = item
        end
    end
    return result
end

# 方差
function variance(list):
    if len(list) == 0:
        return 0
    end
    m = mean(list)
    sumSq = 0
    for item in list:
        diff = item - m
        sumSq = sumSq + diff * diff
    end
    return sumSq / len(list)
end

# 标准差
function stddev(list):
    return sqrt(variance(list))
end

# ========== 数论函数 ==========

# 最大公约数
function gcd(a, b):
    a = abs(int(a))
    b = abs(int(b))
    while b != 0:
        temp = b
        b = a % b
        a = temp
    end
    return a
end

# 最小公倍数
function lcm(a, b):
    return abs(a * b) / gcd(a, b)
end

# 是否为质数
function isPrime(n):
    if n < 2:
        return false
    end
    if n == 2:
        return true
    end
    if n % 2 == 0:
        return false
    end
    i = 3
    while i * i <= n:
        if n % i == 0:
            return false
        end
        i = i + 2
    end
    return true
end

# 阶乘
function factorial(n):
    if n <= 1:
        return 1
    end
    result = 1
    for i = 2 to n:
        result = result * i
    end
    return result
end

# 组合数 C(n, k)
function combination(n, k):
    if k > n or k < 0:
        return 0
    end
    if k == 0 or k == n:
        return 1
    end
    return factorial(n) / (factorial(k) * factorial(n - k))
end

# 排列数 P(n, k)
function permutation(n, k):
    if k > n or k < 0:
        return 0
    end
    return factorial(n) / factorial(n - k)
end

# 斐波那契数
function fibonacci(n):
    if n <= 0:
        return 0
    end
    if n == 1:
        return 1
    end
    a = 0
    b = 1
    for i = 2 to n:
        temp = a + b
        a = b
        b = temp
    end
    return b
end

# ========== 随机数 ==========

# 随机整数 [min, max]
function randint(minVal, maxVal):
    return random_int(minVal, maxVal)
end

# 随机浮点数 [0, 1)
function random():
    return random_int(0, 999999999) / 1000000000
end

# 随机浮点数 [min, max)
function uniform(minVal, maxVal):
    return minVal + random() * (maxVal - minVal)
end

# 随机选择
function choice(list):
    if len(list) == 0:
        return null
    end
    return list[random_int(0, len(list) - 1)]
end

# 随机打乱 (返回新列表)
function shuffle(list):
    result = []
    for item in list:
        append(result, item)
    end
    i = len(result) - 1
    while i >= 1:
        j = random_int(0, i)
        temp = result[i]
        result[i] = result[j]
        result[j] = temp
        i = i - 1
    end
    return result
end

# 随机采样
function sample(list, k):
    if k > len(list):
        k = len(list)
    end
    shuffled = shuffle(list)
    return slice(shuffled, 0, k)
end

# ========== 向量运算 ==========

# 向量加法
function vectorAdd(v1, v2):
    result = []
    for i = 0 to len(v1) - 1:
        append(result, v1[i] + v2[i])
    end
    return result
end

# 向量减法
function vectorSub(v1, v2):
    result = []
    for i = 0 to len(v1) - 1:
        append(result, v1[i] - v2[i])
    end
    return result
end

# 向量点积
function dot(v1, v2):
    result = 0
    for i = 0 to len(v1) - 1:
        result = result + v1[i] * v2[i]
    end
    return result
end

# 向量模长
function magnitude(v):
    return sqrt(dot(v, v))
end

# 向量归一化
function normalize(v):
    mag = magnitude(v)
    if mag == 0:
        return v
    end
    result = []
    for item in v:
        append(result, item / mag)
    end
    return result
end

# 向量叉积 (3D)
function cross(v1, v2):
    return [
        v1[1] * v2[2] - v1[2] * v2[1],
        v1[2] * v2[0] - v1[0] * v2[2],
        v1[0] * v2[1] - v1[1] * v2[0]
    ]
end

# 两点距离
function distance(p1, p2):
    sumSq = 0
    for i = 0 to len(p1) - 1:
        diff = p1[i] - p2[i]
        sumSq = sumSq + diff * diff
    end
    return sqrt(sumSq)
end
