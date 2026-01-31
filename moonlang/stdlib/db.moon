# ============================================
# MoonLang Standard Library - Database Manager
# Usage: from "stdlib/db.moon" import DBManager
# Unified interface for SQLite, MySQL, PostgreSQL, Redis
# ============================================

from "stdlib/sqlite.moon" import SQLite
from "stdlib/mysql.moon" import MySQL
from "stdlib/pgsql.moon" import PostgreSQL
from "stdlib/redis.moon" import Redis

# Unified Database Manager
class DBManager:
    function init(dbType, config):
        self.dbType = dbType
        self.config = config
        self.driver = null
        self.lastError = ""
        
        if dbType == "sqlite":
            path = get(config, "path", ":memory:")
            self.driver = new SQLite(path)
            if not self.driver.isOpen():
                self.lastError = self.driver.error
            end
        elif dbType == "mysql":
            self.driver = new MySQL()
            connected = self.driver.connect(get(config, "host", "localhost"), get(config, "user", "root"), get(config, "password", ""), get(config, "database", ""), get(config, "port", 3306))
            if not connected:
                self.lastError = self.driver.getError()
            end
        elif dbType == "pgsql" or dbType == "postgresql":
            self.driver = new PostgreSQL()
            connected = false
            if has_key(config, "connString"):
                connected = self.driver.connect(config["connString"])
            else:
                connected = self.driver.connectParams(get(config, "host", "localhost"), get(config, "port", 5432), get(config, "user", "postgres"), get(config, "password", ""), get(config, "database", "postgres"))
            end
            if not connected:
                self.lastError = self.driver.getError()
            end
        elif dbType == "redis":
            self.driver = new Redis(get(config, "host", "127.0.0.1"), get(config, "port", 6379))
            connected = self.driver.connect()
            if connected and has_key(config, "password"):
                self.driver.auth(config["password"])
            end
            if connected and has_key(config, "db"):
                self.driver.selectDb(config["db"])
            end
            if not connected:
                self.lastError = self.driver.getError()
            end
        else:
            self.lastError = "Unknown database type: " + dbType
        end
    end
    
    # Check if connected
    function isConnected():
        if self.driver == null:
            return false
        end
        if self.dbType == "sqlite":
            return self.driver.isOpen()
        elif self.dbType == "mysql":
            return self.driver.isConnected()
        elif self.dbType == "pgsql" or self.dbType == "postgresql":
            return self.driver.isConnected()
        elif self.dbType == "redis":
            return self.driver.isConnected()
        end
        return false
    end
    
    # ============== SQL Database Methods ==============
    
    # Execute SQL (no return result)
    function exec(sql):
        if self.dbType == "redis":
            self.lastError = "exec() not supported for Redis"
            return false
        end
        return self.driver.exec(sql)
    end
    
    # Query (returns list of dictionaries)
    function query(sql):
        if self.dbType == "redis":
            self.lastError = "query() not supported for Redis"
            return []
        end
        return self.driver.query(sql)
    end
    
    # Query single row
    function queryOne(sql):
        if self.dbType == "redis":
            return null
        end
        return self.driver.queryOne(sql)
    end
    
    # Query single value
    function queryValue(sql):
        if self.dbType == "redis":
            return null
        end
        return self.driver.queryValue(sql)
    end
    
    # Insert record
    function insert(tableName, data):
        if self.dbType == "redis":
            self.lastError = "insert() not supported for Redis, use set/hset instead"
            return 0
        end
        return self.driver.insert(tableName, data)
    end
    
    # Update records
    function update(tableName, data, where):
        if self.dbType == "redis":
            self.lastError = "update() not supported for Redis"
            return 0
        end
        return self.driver.update(tableName, data, where)
    end
    
    # Delete records
    function delete(tableName, where):
        if self.dbType == "redis":
            self.lastError = "delete() not supported for Redis, use del() instead"
            return 0
        end
        return self.driver.delete(tableName, where)
    end
    
    # Count records
    function count(tableName, where):
        if self.dbType == "redis":
            self.lastError = "count() not supported for Redis"
            return 0
        end
        return self.driver.count(tableName, where)
    end
    
    # Transaction control
    function begin():
        if self.dbType == "redis":
            self.lastError = "Transaction not supported for Redis"
            return false
        end
        return self.driver.begin()
    end
    
    function commit():
        if self.dbType == "redis":
            return false
        end
        return self.driver.commit()
    end
    
    function rollback():
        if self.dbType == "redis":
            return false
        end
        return self.driver.rollback()
    end
    
    # ============== Redis-specific Methods ==============
    
    # GET key
    function get(key):
        if self.dbType != "redis":
            self.lastError = "get() is Redis-specific, use query() for SQL"
            return null
        end
        return self.driver.get(key)
    end
    
    # SET key value [EX seconds]
    function set(key, value, ex):
        if self.dbType != "redis":
            self.lastError = "set() is Redis-specific, use insert() for SQL"
            return null
        end
        return self.driver.set(key, value, ex)
    end
    
    # DEL key
    function del(key):
        if self.dbType != "redis":
            self.lastError = "del() is Redis-specific, use delete() for SQL"
            return null
        end
        return self.driver.del(key)
    end
    
    # EXISTS key
    function exists(key):
        if self.dbType != "redis":
            self.lastError = "exists() is Redis-specific"
            return false
        end
        return self.driver.exists(key)
    end
    
    # INCR key
    function incr(key):
        if self.dbType != "redis":
            return null
        end
        return self.driver.incr(key)
    end
    
    # DECR key
    function decr(key):
        if self.dbType != "redis":
            return null
        end
        return self.driver.decr(key)
    end
    
    # Hash operations
    function hset(key, field, value):
        if self.dbType != "redis":
            return null
        end
        return self.driver.hset(key, field, value)
    end
    
    function hget(key, field):
        if self.dbType != "redis":
            return null
        end
        return self.driver.hget(key, field)
    end
    
    function hgetall(key):
        if self.dbType != "redis":
            return {}
        end
        return self.driver.hgetall(key)
    end
    
    # List operations
    function lpush(key, value):
        if self.dbType != "redis":
            return null
        end
        return self.driver.lpush(key, value)
    end
    
    function rpush(key, value):
        if self.dbType != "redis":
            return null
        end
        return self.driver.rpush(key, value)
    end
    
    function lpop(key):
        if self.dbType != "redis":
            return null
        end
        return self.driver.lpop(key)
    end
    
    function rpop(key):
        if self.dbType != "redis":
            return null
        end
        return self.driver.rpop(key)
    end
    
    function lrange(key, start, stop):
        if self.dbType != "redis":
            return []
        end
        return self.driver.lrange(key, start, stop)
    end
    
    # Set operations
    function sadd(key, member):
        if self.dbType != "redis":
            return null
        end
        return self.driver.sadd(key, member)
    end
    
    function smembers(key):
        if self.dbType != "redis":
            return []
        end
        return self.driver.smembers(key)
    end
    
    function sismember(key, member):
        if self.dbType != "redis":
            return false
        end
        return self.driver.sismember(key, member)
    end
    
    # Expiry
    function expire(key, seconds):
        if self.dbType != "redis":
            return false
        end
        return self.driver.expire(key, seconds)
    end
    
    function ttl(key):
        if self.dbType != "redis":
            return -1
        end
        return self.driver.ttl(key)
    end
    
    # Pub/Sub
    function publish(channel, message):
        if self.dbType != "redis":
            return null
        end
        return self.driver.publish(channel, message)
    end
    
    # ============== Common Methods ==============
    
    # Get last error
    function getError():
        if self.lastError != "":
            return self.lastError
        end
        if self.driver != null:
            return self.driver.getError()
        end
        return ""
    end
    
    # Get driver type
    function getType():
        return self.dbType
    end
    
    # Get underlying driver
    function getDriver():
        return self.driver
    end
    
    # Close connection
    function close():
        if self.driver != null:
            self.driver.close()
        end
    end
end

# ============== Quick Connect Functions ==============

# Connect to SQLite
function connectSQLite(path):
    return new DBManager("sqlite", {"path": path})
end

# Connect to in-memory SQLite
function memoryDatabase():
    return new DBManager("sqlite", {"path": ":memory:"})
end

# Connect to MySQL
function connectMySQL(host, user, password, database, port):
    return new DBManager("mysql", {
        "host": host,
        "user": user,
        "password": password,
        "database": database,
        "port": port
    })
end

# Connect to PostgreSQL using connection string
function connectPostgreSQL(connString):
    return new DBManager("pgsql", {"connString": connString})
end

# Connect to PostgreSQL using parameters
function connectPg(host, user, password, database, port):
    return new DBManager("pgsql", {
        "host": host,
        "user": user,
        "password": password,
        "database": database,
        "port": port
    })
end

# Connect to Redis
function connectRedis(host, port):
    return new DBManager("redis", {"host": host, "port": port})
end

# Connect to Redis with authentication
function connectRedisWithAuth(host, port, password, db):
    return new DBManager("redis", {
        "host": host,
        "port": port,
        "password": password,
        "db": db
    })
end

# ============== Legacy Support ==============
# Keeping the old Database/Table classes for backward compatibility

class Table:
    function init(db, name):
        self.db = db
        self.name = name
    end
    
    function insert(data):
        self.db.insert(self.name, data)
        return self
    end
    
    function insertMany(records):
        for record in records:
            self.insert(record)
        end
        return self
    end
    
    function all():
        return self.db.query("SELECT * FROM " + self.name)
    end
    
    function find(where):
        whereClause = self._buildWhere(where)
        return self.db.query("SELECT * FROM " + self.name + " WHERE " + whereClause)
    end
    
    function findOne(where):
        results = self.find(where)
        if len(results) > 0:
            return results[0]
        end
        return null
    end
    
    function update(where, data):
        whereClause = self._buildWhere(where)
        self.db.update(self.name, data, whereClause)
        return self
    end
    
    function delete(where):
        whereClause = self._buildWhere(where)
        self.db.delete(self.name, whereClause)
        return self
    end
    
    function count():
        return self.db.count(self.name, null)
    end
    
    function clear():
        self.db.exec("DELETE FROM " + self.name)
        return self
    end
    
    function _buildWhere(where):
        if type(where) == "string":
            return where
        end
        parts = []
        for col in keys(where):
            v = where[col]
            if type(v) == "string":
                append(parts, col + " = '" + replace(v, "'", "''") + "'")
            elif v == null:
                append(parts, col + " IS NULL")
            else:
                append(parts, col + " = " + str(v))
            end
        end
        return join(parts, " AND ")
    end
end

class Database:
    function init(path):
        self.path = path
        self.manager = connectSQLite(path)
        self.tables = {}
    end
    
    function table(name):
        if not has_key(self.tables, name):
            self.tables[name] = new Table(self.manager, name)
        end
        return self.tables[name]
    end
    
    function listTables():
        return self.manager.driver.tables()
    end
    
    function save():
        # SQLite auto-commits
        return self
    end
    
    function close():
        self.manager.close()
    end
end

# Legacy quick functions
function openDatabase(path):
    return new Database(path)
end

function connect(path):
    return new Database(path)
end
