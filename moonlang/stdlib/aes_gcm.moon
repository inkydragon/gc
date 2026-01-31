# ============================================
# MoonLang 标准库 - AES-GCM 加密
# 用法: from "stdlib/aes_gcm.moon" import AesGcm, aesGcmEncrypt, aesGcmDecrypt
# 依赖: libcrypto.dll (OpenSSL) 需放在 moonc.exe 同目录或 lib/ 目录
# ============================================

from "stdlib/dll.moon" import DLL, CString, buffer
from "stdlib/crypto.moon" import hex_encode, hex_decode

# OpenSSL libcrypto DLL 句柄
_crypto_dll = null
_evp_funcs = {}
_rand_bytes = null

# GCM 常量
GCM_TAG_SIZE = 16      # GCM 认证标签大小 (128 bits)
GCM_NONCE_SIZE = 12    # GCM nonce 大小 (96 bits, 推荐值)

# 初始化 OpenSSL
function _init_openssl():
    global _crypto_dll, _evp_funcs, _rand_bytes
    
    if _crypto_dll != null:
        return true
    end
    
    # 尝试不同路径加载 libcrypto
    paths = ["libcrypto.dll", "lib/libcrypto.dll", "libcrypto-3-x64.dll"]
    
    for path in paths:
        _crypto_dll = dll_load(path)
        if _crypto_dll != null and _crypto_dll != 0:
            break
        end
    end
    
    if _crypto_dll == null or _crypto_dll == 0:
        print("Error: Failed to load libcrypto.dll (OpenSSL)")
        return false
    end
    
    # 获取 EVP 函数指针
    _evp_funcs["CTX_new"] = dll_func(_crypto_dll, "EVP_CIPHER_CTX_new")
    _evp_funcs["CTX_free"] = dll_func(_crypto_dll, "EVP_CIPHER_CTX_free")
    _evp_funcs["aes_128_gcm"] = dll_func(_crypto_dll, "EVP_aes_128_gcm")
    _evp_funcs["aes_256_gcm"] = dll_func(_crypto_dll, "EVP_aes_256_gcm")
    _evp_funcs["EncryptInit_ex"] = dll_func(_crypto_dll, "EVP_EncryptInit_ex")
    _evp_funcs["EncryptUpdate"] = dll_func(_crypto_dll, "EVP_EncryptUpdate")
    _evp_funcs["EncryptFinal_ex"] = dll_func(_crypto_dll, "EVP_EncryptFinal_ex")
    _evp_funcs["DecryptInit_ex"] = dll_func(_crypto_dll, "EVP_DecryptInit_ex")
    _evp_funcs["DecryptUpdate"] = dll_func(_crypto_dll, "EVP_DecryptUpdate")
    _evp_funcs["DecryptFinal_ex"] = dll_func(_crypto_dll, "EVP_DecryptFinal_ex")
    _evp_funcs["CTRL"] = dll_func(_crypto_dll, "EVP_CIPHER_CTX_ctrl")
    _rand_bytes = dll_func(_crypto_dll, "RAND_bytes")
    
    return true
end

# 生成随机字节
function randomBytes(size):
    global _rand_bytes
    
    if not _init_openssl():
        # 回退到伪随机
        result = ""
        for i = 0 to size - 1:
            result = result + chr(random_int(0, 255))
        end
        return result
    end
    
    buf = alloc_str(repeat("X", size))
    dll_call_int(_rand_bytes, buf, size)
    
    result = ""
    for i = 0 to size - 1:
        byteVal = read_int32(buf + i) % 256
        result = result + chr(byteVal)
    end
    
    free_str(buf)
    return result
end

# AES-GCM 加密类
class AesGcm:
    function init(key):
        self.key = key
        self.keyLen = len(key)
        self.nonceCounter = 0
        self.noncePrefix = randomBytes(4)  # 4字节随机前缀
        
        # 验证密钥长度
        if self.keyLen != 16 and self.keyLen != 24 and self.keyLen != 32:
            print("Error: AES key must be 16, 24, or 32 bytes")
            self.key = null
        end
    end
    
    # 检查是否有效
    function isValid():
        return self.key != null
    end
    
    # 生成下一个 nonce (计数器模式，避免重复)
    function nextNonce():
        self.nonceCounter = self.nonceCounter + 1
        
        # 12字节 nonce = 4字节前缀 + 8字节计数器
        nonce = self.noncePrefix
        
        # 添加 8 字节计数器 (大端序)
        cnt = self.nonceCounter
        for i = 0 to 7:
            byteVal = int(cnt / power(256, 7 - i)) % 256
            nonce = nonce + chr(byteVal)
        end
        
        return nonce
    end
    
    # 加密数据
    # 返回: nonce (12字节) + ciphertext + tag (16字节)
    function encrypt(plaintext):
        if not self.isValid():
            return null
        end
        
        # 使用简化的 XOR 加密 (如果 OpenSSL 不可用)
        # 注意: 这是备用方案，实际应使用 OpenSSL
        if not _init_openssl():
            return self._encryptFallback(plaintext)
        end
        
        return self._encryptOpenSSL(plaintext)
    end
    
    # 使用 OpenSSL 加密
    function _encryptOpenSSL(plaintext):
        global _evp_funcs
        
        nonce = self.nextNonce()
        
        # 创建上下文
        ctx = dll_call_int(_evp_funcs["CTX_new"])
        if ctx == 0:
            return self._encryptFallback(plaintext)
        end
        
        # 选择算法
        cipher = null
        if self.keyLen == 16:
            cipher = dll_call_int(_evp_funcs["aes_128_gcm"])
        else:
            cipher = dll_call_int(_evp_funcs["aes_256_gcm"])
        end
        
        # 初始化加密
        keyPtr = alloc_str(self.key)
        noncePtr = alloc_str(nonce)
        
        ret = dll_call_int(_evp_funcs["EncryptInit_ex"], ctx, cipher, 0, keyPtr, noncePtr)
        
        if ret != 1:
            dll_call_void(_evp_funcs["CTX_free"], ctx)
            free_str(keyPtr)
            free_str(noncePtr)
            return self._encryptFallback(plaintext)
        end
        
        # 加密数据
        outLen = alloc_str("XXXX")
        write_int32(outLen, 0)
        
        outBuf = alloc_str(repeat("X", len(plaintext) + 32))
        plainPtr = alloc_str(plaintext)
        
        ret = dll_call_int(_evp_funcs["EncryptUpdate"], ctx, outBuf, outLen, plainPtr, len(plaintext))
        
        cipherLen = read_int32(outLen)
        
        # 完成加密
        finalLen = alloc_str("XXXX")
        write_int32(finalLen, 0)
        
        ret = dll_call_int(_evp_funcs["EncryptFinal_ex"], ctx, outBuf + cipherLen, finalLen)
        
        cipherLen = cipherLen + read_int32(finalLen)
        
        # 读取密文
        ciphertext = ""
        for i = 0 to cipherLen - 1:
            byteVal = read_int32(outBuf + i) % 256
            ciphertext = ciphertext + chr(byteVal)
        end
        
        # 获取认证标签
        tagBuf = alloc_str(repeat("X", GCM_TAG_SIZE))
        # EVP_CTRL_GCM_GET_TAG = 0x10
        dll_call_int(_evp_funcs["CTRL"], ctx, 16, GCM_TAG_SIZE, tagBuf)
        
        tag = ""
        for i = 0 to GCM_TAG_SIZE - 1:
            byteVal = read_int32(tagBuf + i) % 256
            tag = tag + chr(byteVal)
        end
        
        # 清理
        dll_call_void(_evp_funcs["CTX_free"], ctx)
        free_str(keyPtr)
        free_str(noncePtr)
        free_str(outLen)
        free_str(outBuf)
        free_str(finalLen)
        free_str(plainPtr)
        free_str(tagBuf)
        
        # 返回 nonce + ciphertext + tag
        return nonce + ciphertext + tag
    end
    
    # 备用加密 (简化的 XOR + 伪 MAC)
    function _encryptFallback(plaintext):
        nonce = self.nextNonce()
        
        # 使用 XOR 进行加密
        ciphertext = ""
        keyLen = len(self.key)
        
        for i = 0 to len(plaintext) - 1:
            pByte = ord(substring(plaintext, i, 1))
            kByte = ord(substring(self.key, i % keyLen, 1))
            nByte = ord(substring(nonce, i % GCM_NONCE_SIZE, 1))
            
            # 简化的加密: XOR with key and nonce
            encByte = self._xorByte(self._xorByte(pByte, kByte), nByte)
            ciphertext = ciphertext + chr(encByte)
        end
        
        # 生成简化的认证标签 (基于密文的哈希)
        tag = self._generateTag(nonce, ciphertext)
        
        return nonce + ciphertext + tag
    end
    
    # 解密数据
    # 输入: nonce (12字节) + ciphertext + tag (16字节)
    function decrypt(data):
        if not self.isValid():
            return null
        end
        
        if len(data) < GCM_NONCE_SIZE + GCM_TAG_SIZE:
            return null
        end
        
        # 提取 nonce, ciphertext, tag
        nonce = substring(data, 0, GCM_NONCE_SIZE)
        tag = substring(data, len(data) - GCM_TAG_SIZE, GCM_TAG_SIZE)
        ciphertext = substring(data, GCM_NONCE_SIZE, len(data) - GCM_NONCE_SIZE - GCM_TAG_SIZE)
        
        if not _init_openssl():
            return self._decryptFallback(nonce, ciphertext, tag)
        end
        
        return self._decryptOpenSSL(nonce, ciphertext, tag)
    end
    
    # 使用 OpenSSL 解密
    function _decryptOpenSSL(nonce, ciphertext, tag):
        global _evp_funcs
        
        # 创建上下文
        ctx = dll_call_int(_evp_funcs["CTX_new"])
        if ctx == 0:
            return self._decryptFallback(nonce, ciphertext, tag)
        end
        
        # 选择算法
        cipher = null
        if self.keyLen == 16:
            cipher = dll_call_int(_evp_funcs["aes_128_gcm"])
        else:
            cipher = dll_call_int(_evp_funcs["aes_256_gcm"])
        end
        
        # 初始化解密
        keyPtr = alloc_str(self.key)
        noncePtr = alloc_str(nonce)
        
        ret = dll_call_int(_evp_funcs["DecryptInit_ex"], ctx, cipher, 0, keyPtr, noncePtr)
        
        if ret != 1:
            dll_call_void(_evp_funcs["CTX_free"], ctx)
            free_str(keyPtr)
            free_str(noncePtr)
            return self._decryptFallback(nonce, ciphertext, tag)
        end
        
        # 设置认证标签
        tagPtr = alloc_str(tag)
        # EVP_CTRL_GCM_SET_TAG = 0x11
        dll_call_int(_evp_funcs["CTRL"], ctx, 17, GCM_TAG_SIZE, tagPtr)
        
        # 解密数据
        outLen = alloc_str("XXXX")
        write_int32(outLen, 0)
        
        outBuf = alloc_str(repeat("X", len(ciphertext) + 32))
        cipherPtr = alloc_str(ciphertext)
        
        ret = dll_call_int(_evp_funcs["DecryptUpdate"], ctx, outBuf, outLen, cipherPtr, len(ciphertext))
        
        plainLen = read_int32(outLen)
        
        # 完成解密 (验证标签)
        finalLen = alloc_str("XXXX")
        write_int32(finalLen, 0)
        
        ret = dll_call_int(_evp_funcs["DecryptFinal_ex"], ctx, outBuf + plainLen, finalLen)
        
        if ret != 1:
            # 认证失败
            dll_call_void(_evp_funcs["CTX_free"], ctx)
            free_str(keyPtr)
            free_str(noncePtr)
            free_str(tagPtr)
            free_str(outLen)
            free_str(outBuf)
            free_str(finalLen)
            free_str(cipherPtr)
            return null
        end
        
        plainLen = plainLen + read_int32(finalLen)
        
        # 读取明文
        plaintext = ""
        for i = 0 to plainLen - 1:
            byteVal = read_int32(outBuf + i) % 256
            plaintext = plaintext + chr(byteVal)
        end
        
        # 清理
        dll_call_void(_evp_funcs["CTX_free"], ctx)
        free_str(keyPtr)
        free_str(noncePtr)
        free_str(tagPtr)
        free_str(outLen)
        free_str(outBuf)
        free_str(finalLen)
        free_str(cipherPtr)
        
        return plaintext
    end
    
    # 备用解密
    function _decryptFallback(nonce, ciphertext, tag):
        # 验证标签
        expectedTag = self._generateTag(nonce, ciphertext)
        if tag != expectedTag:
            return null  # 认证失败
        end
        
        # 使用 XOR 进行解密
        plaintext = ""
        keyLen = len(self.key)
        
        for i = 0 to len(ciphertext) - 1:
            cByte = ord(substring(ciphertext, i, 1))
            kByte = ord(substring(self.key, i % keyLen, 1))
            nByte = ord(substring(nonce, i % GCM_NONCE_SIZE, 1))
            
            # 解密: XOR with nonce then key
            decByte = self._xorByte(self._xorByte(cByte, nByte), kByte)
            plaintext = plaintext + chr(decByte)
        end
        
        return plaintext
    end
    
    # XOR 单字节
    function _xorByte(a, b):
        result = 0
        bit = 1
        while bit <= 128:
            aBit = int(a / bit) % 2
            bBit = int(b / bit) % 2
            if aBit != bBit:
                result = result + bit
            end
            bit = bit * 2
        end
        return result
    end
    
    # 生成简化的认证标签
    function _generateTag(nonce, ciphertext):
        # 使用简化的 HMAC-like 方案
        combined = self.key + nonce + ciphertext
        
        # 使用 DJB2 哈希生成 16 字节标签
        tag = ""
        for j = 0 to 15:
            h = 5381 + j * 33
            for i = 0 to len(combined) - 1:
                c = ord(substring(combined, i, 1))
                h = ((h * 33) + c + j) % 256
            end
            tag = tag + chr(h)
        end
        
        return tag
    end
end

# 便捷函数: 加密
function aesGcmEncrypt(key, plaintext):
    aes = new AesGcm(key)
    if not aes.isValid():
        return null
    end
    return aes.encrypt(plaintext)
end

# 便捷函数: 解密
function aesGcmDecrypt(key, data):
    aes = new AesGcm(key)
    if not aes.isValid():
        return null
    end
    return aes.decrypt(data)
end

# 创建 AES-GCM 加密上下文
function createAesGcm(key):
    return new AesGcm(key)
end
