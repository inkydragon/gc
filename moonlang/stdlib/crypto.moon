# ============================================
# MoonScript 标准库 - 加密与编码
# 用法: from "stdlib/crypto.moon" import *
# ============================================

# ========== Base64 编码 ==========

BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64_encode(data):
    result = ""
    padding = 0
    i = 0
    
    while i < len(data):
        # 获取3个字节
        b1 = ord(substring(data, i, 1))
        b2 = 0
        b3 = 0
        
        if i + 1 < len(data):
            b2 = ord(substring(data, i + 1, 1))
        else:
            padding = padding + 1
        end
        
        if i + 2 < len(data):
            b3 = ord(substring(data, i + 2, 1))
        else:
            padding = padding + 1
        end
        
        # 转换为4个6位数
        n = (b1 * 65536) + (b2 * 256) + b3
        
        c1 = (n / 262144) % 64
        c2 = (n / 4096) % 64
        c3 = (n / 64) % 64
        c4 = n % 64
        
        result = result + substring(BASE64_CHARS, int(c1), 1)
        result = result + substring(BASE64_CHARS, int(c2), 1)
        
        if padding < 2:
            result = result + substring(BASE64_CHARS, int(c3), 1)
        else:
            result = result + "="
        end
        
        if padding < 1:
            result = result + substring(BASE64_CHARS, int(c4), 1)
        else:
            result = result + "="
        end
        
        i = i + 3
    end
    
    return result
end

function base64_decode(data):
    result = ""
    i = 0
    
    while i < len(data):
        c1 = index_of(BASE64_CHARS, substring(data, i, 1))
        c2 = index_of(BASE64_CHARS, substring(data, i + 1, 1))
        c3 = index_of(BASE64_CHARS, substring(data, i + 2, 1))
        c4 = index_of(BASE64_CHARS, substring(data, i + 3, 1))
        
        if c3 == -1:
            c3 = 0
        end
        if c4 == -1:
            c4 = 0
        end
        
        n = (c1 * 262144) + (c2 * 4096) + (c3 * 64) + c4
        
        b1 = (n / 65536) % 256
        b2 = (n / 256) % 256
        b3 = n % 256
        
        result = result + chr(int(b1))
        
        if substring(data, i + 2, 1) != "=":
            result = result + chr(int(b2))
        end
        
        if substring(data, i + 3, 1) != "=":
            result = result + chr(int(b3))
        end
        
        i = i + 4
    end
    
    return result
end

# ========== 十六进制编码 ==========

HEX_CHARS = "0123456789abcdef"

function hex_encode(data):
    result = ""
    for i = 0 to len(data) - 1:
        b = ord(substring(data, i, 1))
        result = result + substring(HEX_CHARS, int(b / 16), 1)
        result = result + substring(HEX_CHARS, b % 16, 1)
    end
    return result
end

function hex_decode(data):
    result = ""
    i = 0
    while i < len(data):
        h = index_of(HEX_CHARS, to_lower(substring(data, i, 1)))
        l = index_of(HEX_CHARS, to_lower(substring(data, i + 1, 1)))
        result = result + chr(h * 16 + l)
        i = i + 2
    end
    return result
end

# ========== 简单哈希 ==========

# DJB2 哈希算法
function hash_djb2(data):
    h = 5381
    for i = 0 to len(data) - 1:
        c = ord(substring(data, i, 1))
        h = ((h * 33) + c) % 4294967296
    end
    return h
end

# FNV-1a 哈希算法 (简化版，不使用XOR)
function hash_fnv1a(data):
    h = 2166136261
    for i = 0 to len(data) - 1:
        c = ord(substring(data, i, 1))
        # 使用加法和乘法模拟散列
        h = ((h + c) * 16777619) % 4294967296
    end
    return h
end

# 简单哈希 (默认使用 djb2)
function hash(data):
    return hash_djb2(data)
end

# ========== 简单加密 ==========

# XOR 加密/解密 (使用位运算模拟)
function xor_cipher(data, key):
    result = ""
    keyLen = len(key)
    for i = 0 to len(data) - 1:
        c = ord(substring(data, i, 1))
        k = ord(substring(key, i % keyLen, 1))
        # 手动实现 XOR: a XOR b = (a + b) - 2 * (a AND b)
        # 简化版: 使用加减法模拟
        xorResult = 0
        bit = 1
        while bit <= 128:
            cBit = int(c / bit) % 2
            kBit = int(k / bit) % 2
            if cBit != kBit:
                xorResult = xorResult + bit
            end
            bit = bit * 2
        end
        result = result + chr(xorResult)
    end
    return result
end

# 凯撒密码加密
function caesar_encrypt(data, shift):
    result = ""
    for i = 0 to len(data) - 1:
        c = substring(data, i, 1)
        code = ord(c)
        
        if code >= 65 and code <= 90:  # A-Z
            code = ((code - 65 + shift) % 26) + 65
        elif code >= 97 and code <= 122:  # a-z
            code = ((code - 97 + shift) % 26) + 97
        end
        
        result = result + chr(code)
    end
    return result
end

# 凯撒密码解密
function caesar_decrypt(data, shift):
    return caesar_encrypt(data, 26 - (shift % 26))
end

# ROT13
function rot13(data):
    return caesar_encrypt(data, 13)
end

# ========== URL 编码 ==========

function url_encode(data):
    result = ""
    for i = 0 to len(data) - 1:
        c = substring(data, i, 1)
        code = ord(c)
        
        # 安全字符不编码
        if (code >= 48 and code <= 57) or (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or c == "-" or c == "_" or c == "." or c == "~":
            result = result + c
        elif c == " ":
            result = result + "+"
        else:
            result = result + "%" + to_upper(substring(HEX_CHARS, int(code / 16), 1)) + to_upper(substring(HEX_CHARS, code % 16, 1))
        end
    end
    return result
end

function url_decode(data):
    result = ""
    i = 0
    while i < len(data):
        c = substring(data, i, 1)
        if c == "%":
            h = index_of(HEX_CHARS, to_lower(substring(data, i + 1, 1)))
            l = index_of(HEX_CHARS, to_lower(substring(data, i + 2, 1)))
            result = result + chr(h * 16 + l)
            i = i + 3
        elif c == "+":
            result = result + " "
            i = i + 1
        else:
            result = result + c
            i = i + 1
        end
    end
    return result
end

# ========== 校验和 ==========

# 简单校验和
function checksum(data):
    total = 0
    for i = 0 to len(data) - 1:
        total = total + ord(substring(data, i, 1))
    end
    return total % 256
end

# CRC16 (简化版 - 使用累加校验)
function crc16(data):
    crc = 65535
    for i = 0 to len(data) - 1:
        b = ord(substring(data, i, 1))
        crc = (crc + b * (i + 1)) % 65536
    end
    return crc
end
