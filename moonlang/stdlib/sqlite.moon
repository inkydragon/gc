# ============================================
# MoonLang Standard Library - SQLite3 Driver
# Usage: from "stdlib/sqlite.moon" import SQLite
# Requires: sqlite3.dll (Windows) / libsqlite3.so (Linux)
# ============================================

from "stdlib/dll.moon" import DLL, CString, buffer

# SQLite3 Return Codes
SQLITE_OK = 0
SQLITE_ROW = 100
SQLITE_DONE = 101

# SQLite3 Column Types
SQLITE_INTEGER = 1
SQLITE_FLOAT = 2
SQLITE_TEXT = 3
SQLITE_BLOB = 4
SQLITE_NULL = 5

class SQLite:
    function init(dbPath):
        # Load DLL based on platform
        if platform() == "windows":
            self.dll = new DLL("sqlite3.dll")
        else:
            self.dll = new DLL("libsqlite3.so")
        end
        
        # Get function pointers
        self._open = self.dll.getFunc("sqlite3_open")
        self._close = self.dll.getFunc("sqlite3_close")
        self._exec = self.dll.getFunc("sqlite3_exec")
        self._prepare = self.dll.getFunc("sqlite3_prepare_v2")
        self._step = self.dll.getFunc("sqlite3_step")
        self._finalize = self.dll.getFunc("sqlite3_finalize")
        self._column_count = self.dll.getFunc("sqlite3_column_count")
        self._column_name = self.dll.getFunc("sqlite3_column_name")
        self._column_text = self.dll.getFunc("sqlite3_column_text")
        self._column_int = self.dll.getFunc("sqlite3_column_int")
        self._column_double = self.dll.getFunc("sqlite3_column_double")
        self._column_type = self.dll.getFunc("sqlite3_column_type")
        self._errmsg = self.dll.getFunc("sqlite3_errmsg")
        self._changes = self.dll.getFunc("sqlite3_changes")
        self._last_insert_rowid = self.dll.getFunc("sqlite3_last_insert_rowid")
        self._bind_int = self.dll.getFunc("sqlite3_bind_int")
        self._bind_double = self.dll.getFunc("sqlite3_bind_double")
        self._bind_text = self.dll.getFunc("sqlite3_bind_text")
        self._bind_null = self.dll.getFunc("sqlite3_bind_null")
        self._reset = self.dll.getFunc("sqlite3_reset")
        self._clear_bindings = self.dll.getFunc("sqlite3_clear_bindings")
        
        # Open database
        self.db = 0
        # 使用 alloc_str 分配缓冲区，并清零
        self.dbPtrBuf = alloc_str("XXXXXXXX")
        write_ptr(self.dbPtrBuf, 0)
        
        pathStr = new CString(dbPath)
        result = dll_call_int(self._open, pathStr.pointer(), self.dbPtrBuf)
        pathStr.free()
        
        if result != SQLITE_OK:
            self.error = "Failed to open database: " + dbPath
            self.db = 0
        else:
            # Read the sqlite3* pointer using cross-platform read_ptr
            self.db = read_ptr(self.dbPtrBuf)
            self.error = null
        end
        
        self.dbPath = dbPath
    end
    
    # Check if database is open
    function isOpen():
        return self.db != 0
    end
    
    # Execute SQL (no return result)
    function exec(sql):
        if self.db == 0:
            return false
        end
        sqlStr = new CString(sql)
        result = dll_call_int(self._exec, self.db, sqlStr.pointer(), 0, 0, 0)
        sqlStr.free()
        return result == SQLITE_OK
    end
    
    # Query (returns list of dictionaries)
    function query(sql):
        results = []
        if self.db == 0:
            return results
        end
        
        sqlStr = new CString(sql)
        stmtPtrBuf = alloc_str("XXXXXXXX")
        write_ptr(stmtPtrBuf, 0)
        
        result = dll_call_int(self._prepare, self.db, sqlStr.pointer(), -1, stmtPtrBuf, 0)
        sqlStr.free()
        
        if result != SQLITE_OK:
            free_str(stmtPtrBuf)
            return results
        end
        
        # Read statement pointer using cross-platform read_ptr
        stmt = read_ptr(stmtPtrBuf)
        free_str(stmtPtrBuf)
        if stmt == 0:
            return results
        end
        colCount = dll_call_int(self._column_count, stmt)
        
        # Get column names
        columns = []
        for i = 0 to colCount - 1:
            namePtr = dll_call_int(self._column_name, stmt, i)
            append(columns, ptr_to_str(namePtr))
        end
        
        # Iterate rows
        while dll_call_int(self._step, stmt) == SQLITE_ROW:
            row = {}
            for i = 0 to colCount - 1:
                colType = dll_call_int(self._column_type, stmt, i)
                colName = columns[i]
                
                if colType == SQLITE_INTEGER:
                    row[colName] = dll_call_int(self._column_int, stmt, i)
                elif colType == SQLITE_FLOAT:
                    row[colName] = dll_call_double(self._column_double, stmt, i)
                elif colType == SQLITE_TEXT:
                    textPtr = dll_call_int(self._column_text, stmt, i)
                    row[colName] = ptr_to_str(textPtr)
                elif colType == SQLITE_NULL:
                    row[colName] = null
                else:
                    # BLOB - read as text for simplicity
                    textPtr = dll_call_int(self._column_text, stmt, i)
                    row[colName] = ptr_to_str(textPtr)
                end
            end
            append(results, row)
        end
        
        dll_call_int(self._finalize, stmt)
        return results
    end
    
    # Query single row
    function queryOne(sql):
        results = self.query(sql)
        if len(results) > 0:
            return results[0]
        end
        return null
    end
    
    # Query single value
    function queryValue(sql):
        row = self.queryOne(sql)
        if row != null:
            ks = keys(row)
            if len(ks) > 0:
                return row[ks[0]]
            end
        end
        return null
    end
    
    # Insert and return ID
    function insert(tableName, data):
        cols = keys(data)
        vals = []
        for col in cols:
            v = data[col]
            if type(v) == "string":
                append(vals, "'" + replace(v, "'", "''") + "'")
            elif v == null:
                append(vals, "NULL")
            else:
                append(vals, str(v))
            end
        end
        
        sql = "INSERT INTO " + tableName + " (" + join(cols, ", ") + ") VALUES (" + join(vals, ", ") + ")"
        self.exec(sql)
        return dll_call_int(self._last_insert_rowid, self.db)
    end
    
    # Update records
    function update(tableName, data, where):
        sets = []
        for col in keys(data):
            v = data[col]
            if type(v) == "string":
                append(sets, col + " = '" + replace(v, "'", "''") + "'")
            elif v == null:
                append(sets, col + " = NULL")
            else:
                append(sets, col + " = " + str(v))
            end
        end
        
        sql = "UPDATE " + tableName + " SET " + join(sets, ", ") + " WHERE " + where
        self.exec(sql)
        return dll_call_int(self._changes, self.db)
    end
    
    # Delete records
    function delete(tableName, where):
        sql = "DELETE FROM " + tableName + " WHERE " + where
        self.exec(sql)
        return dll_call_int(self._changes, self.db)
    end
    
    # Count records
    function count(tableName, where):
        sql = "SELECT COUNT(*) as cnt FROM " + tableName
        if where != null and where != "":
            sql = sql + " WHERE " + where
        end
        result = self.queryValue(sql)
        if result != null:
            return int(result)
        end
        return 0
    end
    
    # Check if table exists
    function tableExists(tableName):
        sql = "SELECT name FROM sqlite_master WHERE type='table' AND name='" + tableName + "'"
        result = self.queryOne(sql)
        return result != null
    end
    
    # Get all table names
    function tables():
        sql = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
        results = self.query(sql)
        names = []
        for row in results:
            append(names, row["name"])
        end
        return names
    end
    
    # Transaction control
    function begin():
        return self.exec("BEGIN TRANSACTION")
    end
    
    function commit():
        return self.exec("COMMIT")
    end
    
    function rollback():
        return self.exec("ROLLBACK")
    end
    
    # Get error message
    function getError():
        if self.db == 0:
            return self.error
        end
        errPtr = dll_call_int(self._errmsg, self.db)
        return ptr_to_str(errPtr)
    end
    
    # Get last insert ID
    function lastInsertId():
        return dll_call_int(self._last_insert_rowid, self.db)
    end
    
    # Get affected rows
    function affectedRows():
        return dll_call_int(self._changes, self.db)
    end
    
    # Close database
    function close():
        if self.db != 0:
            dll_call_int(self._close, self.db)
            self.db = 0
        end
        self.dll.close()
    end
end

# Quick connect function
function connectSQLite(dbPath):
    return new SQLite(dbPath)
end

# Create in-memory database
function memoryDatabase():
    return new SQLite(":memory:")
end
