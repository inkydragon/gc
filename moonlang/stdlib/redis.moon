# ============================================
# MoonLang Standard Library - Redis Client
# Usage: from "stdlib/redis.moon" import Redis
# Uses TCP protocol directly, no DLL required
# Implements RESP (Redis Serialization Protocol)
# ============================================

class Redis:
    function init(host, port):
        if host == null:
            host = "127.0.0.1"
        end
        if port == null:
            port = 6379
        end
        self.host = host
        self.port = port
        self.socket = null
        self.connected = false
        self.lastError = ""
        self.timeout = 5000
    end
    
    # Connect to Redis server
    function connect():
        self.socket = tcp_connect(self.host, self.port)
        if self.socket != null and self.socket != 0:
            self.connected = true
            return true
        else:
            self.lastError = "Failed to connect to " + self.host + ":" + str(self.port)
            return false
        end
    end
    
    # Check if connected
    function isConnected():
        return self.connected
    end
    
    # Send RESP command
    function _sendCommand(args):
        if not self.connected:
            self.lastError = "Not connected"
            return null
        end
        
        # Build RESP array command
        cmd = "*" + str(len(args)) + "\r\n"
        for arg in args:
            s = str(arg)
            cmd = cmd + "$" + str(len(s)) + "\r\n" + s + "\r\n"
        end
        
        tcp_send(self.socket, cmd)
        return self._readResponse()
    end
    
    # Read RESP response
    function _readResponse():
        data = tcp_recv(self.socket)
        if data == null or len(data) == 0:
            return null
        end
        
        return self._parseResponse(data)
    end
    
    # Parse RESP response
    function _parseResponse(data):
        if len(data) == 0:
            return null
        end
        
        prefix = substring(data, 0, 1)
        
        if prefix == "+":
            # Simple String
            return self._parseSimpleString(data)
        elif prefix == "-":
            # Error
            content = self._parseSimpleString(data)
            self.lastError = content
            return {"error": content}
        elif prefix == ":":
            # Integer
            return self._parseInteger(data)
        elif prefix == "$":
            # Bulk String
            return self._parseBulkString(data)
        elif prefix == "*":
            # Array
            return self._parseArray(data)
        end
        
        return data
    end
    
    # Parse simple string (+OK\r\n)
    function _parseSimpleString(data):
        endPos = find(data, "\r\n")
        if endPos > 1:
            return substring(data, 1, endPos - 1)
        end
        return substring(data, 1, len(data) - 1)
    end
    
    # Parse integer (:123\r\n)
    function _parseInteger(data):
        endPos = find(data, "\r\n")
        if endPos > 1:
            return int(substring(data, 1, endPos - 1))
        end
        return int(substring(data, 1, len(data) - 1))
    end
    
    # Parse bulk string ($6\r\nfoobar\r\n)
    function _parseBulkString(data):
        firstCRLF = find(data, "\r\n")
        if firstCRLF < 0:
            return null
        end
        
        lengthStr = substring(data, 1, firstCRLF - 1)
        bulkLen = int(lengthStr)
        
        if bulkLen < 0:
            return null  # Null bulk string
        end
        
        start = firstCRLF + 2
        return substring(data, start, bulkLen)
    end
    
    # Parse array (*2\r\n$3\r\nfoo\r\n$3\r\nbar\r\n)
    function _parseArray(data):
        firstCRLF = find(data, "\r\n")
        if firstCRLF < 0:
            return []
        end
        
        countStr = substring(data, 1, firstCRLF - 1)
        count = int(countStr)
        
        if count < 0:
            return null  # Null array
        end
        
        if count == 0:
            return []
        end
        
        # Simple parsing: split on bulk string boundaries
        results = []
        pos = firstCRLF + 2
        
        for i = 0 to count - 1:
            if pos >= len(data):
                break
            end
            
            prefix = substring(data, pos, 1)
            
            if prefix == "$":
                # Bulk string
                crlfPos = find(substring(data, pos, len(data) - pos), "\r\n")
                if crlfPos < 0:
                    break
                end
                
                lenStr = substring(data, pos + 1, crlfPos - 1)
                bulkLen = int(lenStr)
                
                if bulkLen < 0:
                    append(results, null)
                    pos = pos + crlfPos + 2
                else:
                    start = pos + crlfPos + 2
                    value = substring(data, start, bulkLen)
                    append(results, value)
                    pos = start + bulkLen + 2
                end
            elif prefix == ":":
                # Integer
                crlfPos = find(substring(data, pos, len(data) - pos), "\r\n")
                if crlfPos < 0:
                    break
                end
                value = int(substring(data, pos + 1, crlfPos - 1))
                append(results, value)
                pos = pos + crlfPos + 2
            elif prefix == "+":
                # Simple string
                crlfPos = find(substring(data, pos, len(data) - pos), "\r\n")
                if crlfPos < 0:
                    break
                end
                value = substring(data, pos + 1, crlfPos - 1)
                append(results, value)
                pos = pos + crlfPos + 2
            else:
                pos = pos + 1
            end
        end
        
        return results
    end
    
    # ============== String Commands ==============
    
    # GET key
    function get(key):
        return self._sendCommand(["GET", key])
    end
    
    # SET key value [EX seconds]
    function set(key, value, ex):
        if ex != null:
            return self._sendCommand(["SET", key, value, "EX", ex])
        end
        return self._sendCommand(["SET", key, value])
    end
    
    # SETNX key value (Set if Not eXists)
    function setnx(key, value):
        result = self._sendCommand(["SETNX", key, value])
        return result == 1
    end
    
    # SETEX key seconds value
    function setex(key, seconds, value):
        return self._sendCommand(["SETEX", key, seconds, value])
    end
    
    # MGET key1 key2 ...
    function mget(keysList):
        args = ["MGET"]
        for k in keysList:
            append(args, k)
        end
        return self._sendCommand(args)
    end
    
    # MSET key1 value1 key2 value2 ...
    function mset(data):
        args = ["MSET"]
        for k in keys(data):
            append(args, k)
            append(args, data[k])
        end
        return self._sendCommand(args)
    end
    
    # APPEND key value
    function appendStr(key, value):
        return self._sendCommand(["APPEND", key, value])
    end
    
    # STRLEN key
    function strlen(key):
        return self._sendCommand(["STRLEN", key])
    end
    
    # ============== Key Commands ==============
    
    # DEL key
    function del(key):
        return self._sendCommand(["DEL", key])
    end
    
    # EXISTS key
    function exists(key):
        result = self._sendCommand(["EXISTS", key])
        return result == 1
    end
    
    # KEYS pattern
    function findKeys(pattern):
        return self._sendCommand(["KEYS", pattern])
    end
    
    # TYPE key
    function typeOf(key):
        return self._sendCommand(["TYPE", key])
    end
    
    # RENAME key newkey
    function rename(key, newkey):
        return self._sendCommand(["RENAME", key, newkey])
    end
    
    # ============== Counter Commands ==============
    
    # INCR key
    function incr(key):
        return self._sendCommand(["INCR", key])
    end
    
    # INCRBY key increment
    function incrby(key, increment):
        return self._sendCommand(["INCRBY", key, increment])
    end
    
    # DECR key
    function decr(key):
        return self._sendCommand(["DECR", key])
    end
    
    # DECRBY key decrement
    function decrby(key, decrement):
        return self._sendCommand(["DECRBY", key, decrement])
    end
    
    # INCRBYFLOAT key increment
    function incrbyfloat(key, increment):
        result = self._sendCommand(["INCRBYFLOAT", key, increment])
        if result != null:
            return float(result)
        end
        return null
    end
    
    # ============== Hash Commands ==============
    
    # HSET key field value
    function hset(key, field, value):
        return self._sendCommand(["HSET", key, field, value])
    end
    
    # HGET key field
    function hget(key, field):
        return self._sendCommand(["HGET", key, field])
    end
    
    # HMSET key field1 value1 field2 value2 ...
    function hmset(key, data):
        args = ["HMSET", key]
        for f in keys(data):
            append(args, f)
            append(args, data[f])
        end
        return self._sendCommand(args)
    end
    
    # HMGET key field1 field2 ...
    function hmget(key, fieldsList):
        args = ["HMGET", key]
        for f in fieldsList:
            append(args, f)
        end
        return self._sendCommand(args)
    end
    
    # HGETALL key
    function hgetall(key):
        result = self._sendCommand(["HGETALL", key])
        if type(result) == "list" and len(result) > 0:
            # Convert array to dictionary
            dict = {}
            i = 0
            while i < len(result) - 1:
                dict[result[i]] = result[i + 1]
                i = i + 2
            end
            return dict
        end
        return {}
    end
    
    # HDEL key field
    function hdel(key, field):
        return self._sendCommand(["HDEL", key, field])
    end
    
    # HEXISTS key field
    function hexists(key, field):
        result = self._sendCommand(["HEXISTS", key, field])
        return result == 1
    end
    
    # HKEYS key
    function hkeys(key):
        return self._sendCommand(["HKEYS", key])
    end
    
    # HVALS key
    function hvals(key):
        return self._sendCommand(["HVALS", key])
    end
    
    # HLEN key
    function hlen(key):
        return self._sendCommand(["HLEN", key])
    end
    
    # HINCRBY key field increment
    function hincrby(key, field, increment):
        return self._sendCommand(["HINCRBY", key, field, increment])
    end
    
    # ============== List Commands ==============
    
    # LPUSH key value
    function lpush(key, value):
        return self._sendCommand(["LPUSH", key, value])
    end
    
    # RPUSH key value
    function rpush(key, value):
        return self._sendCommand(["RPUSH", key, value])
    end
    
    # LPOP key
    function lpop(key):
        return self._sendCommand(["LPOP", key])
    end
    
    # RPOP key
    function rpop(key):
        return self._sendCommand(["RPOP", key])
    end
    
    # LRANGE key start stop
    function lrange(key, start, stop):
        return self._sendCommand(["LRANGE", key, start, stop])
    end
    
    # LLEN key
    function llen(key):
        return self._sendCommand(["LLEN", key])
    end
    
    # LINDEX key index
    function lindex(key, index):
        return self._sendCommand(["LINDEX", key, index])
    end
    
    # LSET key index value
    function lset(key, index, value):
        return self._sendCommand(["LSET", key, index, value])
    end
    
    # LREM key count value
    function lrem(key, countVal, value):
        return self._sendCommand(["LREM", key, countVal, value])
    end
    
    # LTRIM key start stop
    function ltrim(key, start, stop):
        return self._sendCommand(["LTRIM", key, start, stop])
    end
    
    # ============== Set Commands ==============
    
    # SADD key member
    function sadd(key, member):
        return self._sendCommand(["SADD", key, member])
    end
    
    # SREM key member
    function srem(key, member):
        return self._sendCommand(["SREM", key, member])
    end
    
    # SMEMBERS key
    function smembers(key):
        return self._sendCommand(["SMEMBERS", key])
    end
    
    # SISMEMBER key member
    function sismember(key, member):
        result = self._sendCommand(["SISMEMBER", key, member])
        return result == 1
    end
    
    # SCARD key
    function scard(key):
        return self._sendCommand(["SCARD", key])
    end
    
    # SPOP key
    function spop(key):
        return self._sendCommand(["SPOP", key])
    end
    
    # SRANDMEMBER key
    function srandmember(key):
        return self._sendCommand(["SRANDMEMBER", key])
    end
    
    # SUNION key1 key2 ...
    function sunion(keysList):
        args = ["SUNION"]
        for k in keysList:
            append(args, k)
        end
        return self._sendCommand(args)
    end
    
    # SINTER key1 key2 ...
    function sinter(keysList):
        args = ["SINTER"]
        for k in keysList:
            append(args, k)
        end
        return self._sendCommand(args)
    end
    
    # ============== Sorted Set Commands ==============
    
    # ZADD key score member
    function zadd(key, score, member):
        return self._sendCommand(["ZADD", key, score, member])
    end
    
    # ZREM key member
    function zrem(key, member):
        return self._sendCommand(["ZREM", key, member])
    end
    
    # ZRANGE key start stop [WITHSCORES]
    function zrange(key, start, stop, withScores):
        if withScores:
            return self._sendCommand(["ZRANGE", key, start, stop, "WITHSCORES"])
        end
        return self._sendCommand(["ZRANGE", key, start, stop])
    end
    
    # ZREVRANGE key start stop [WITHSCORES]
    function zrevrange(key, start, stop, withScores):
        if withScores:
            return self._sendCommand(["ZREVRANGE", key, start, stop, "WITHSCORES"])
        end
        return self._sendCommand(["ZREVRANGE", key, start, stop])
    end
    
    # ZSCORE key member
    function zscore(key, member):
        result = self._sendCommand(["ZSCORE", key, member])
        if result != null:
            return float(result)
        end
        return null
    end
    
    # ZRANK key member
    function zrank(key, member):
        return self._sendCommand(["ZRANK", key, member])
    end
    
    # ZCARD key
    function zcard(key):
        return self._sendCommand(["ZCARD", key])
    end
    
    # ZINCRBY key increment member
    function zincrby(key, increment, member):
        result = self._sendCommand(["ZINCRBY", key, increment, member])
        if result != null:
            return float(result)
        end
        return null
    end
    
    # ============== Expiry Commands ==============
    
    # EXPIRE key seconds
    function expire(key, seconds):
        result = self._sendCommand(["EXPIRE", key, seconds])
        return result == 1
    end
    
    # EXPIREAT key timestamp
    function expireat(key, timestamp):
        result = self._sendCommand(["EXPIREAT", key, timestamp])
        return result == 1
    end
    
    # PEXPIRE key milliseconds
    function pexpire(key, milliseconds):
        result = self._sendCommand(["PEXPIRE", key, milliseconds])
        return result == 1
    end
    
    # TTL key
    function ttl(key):
        return self._sendCommand(["TTL", key])
    end
    
    # PTTL key (milliseconds)
    function pttl(key):
        return self._sendCommand(["PTTL", key])
    end
    
    # PERSIST key
    function persist(key):
        result = self._sendCommand(["PERSIST", key])
        return result == 1
    end
    
    # ============== Pub/Sub Commands ==============
    
    # PUBLISH channel message
    function publish(channel, message):
        return self._sendCommand(["PUBLISH", channel, message])
    end
    
    # ============== Server Commands ==============
    
    # PING
    function ping():
        result = self._sendCommand(["PING"])
        return result == "PONG"
    end
    
    # ECHO message
    function echo(message):
        return self._sendCommand(["ECHO", message])
    end
    
    # INFO [section]
    function info(section):
        if section != null:
            return self._sendCommand(["INFO", section])
        end
        return self._sendCommand(["INFO"])
    end
    
    # DBSIZE
    function dbsize():
        return self._sendCommand(["DBSIZE"])
    end
    
    # FLUSHDB
    function flushdb():
        return self._sendCommand(["FLUSHDB"])
    end
    
    # FLUSHALL
    function flushall():
        return self._sendCommand(["FLUSHALL"])
    end
    
    # SELECT db
    function selectDb(db):
        return self._sendCommand(["SELECT", db])
    end
    
    # AUTH password
    function auth(password):
        result = self._sendCommand(["AUTH", password])
        return result == "OK"
    end
    
    # AUTH username password (Redis 6.0+)
    function authUser(username, password):
        result = self._sendCommand(["AUTH", username, password])
        return result == "OK"
    end
    
    # ============== Utility Methods ==============
    
    # Get last error
    function getError():
        return self.lastError
    end
    
    # Close connection
    function close():
        if self.socket != null:
            tcp_close(self.socket)
            self.socket = null
            self.connected = false
        end
    end
end

# Quick connect function
function connectRedis(host, port):
    redis = new Redis(host, port)
    redis.connect()
    return redis
end

# Connect with authentication
function connectRedisAuth(host, port, password):
    redis = new Redis(host, port)
    if redis.connect():
        if redis.auth(password):
            return redis
        end
    end
    return null
end
