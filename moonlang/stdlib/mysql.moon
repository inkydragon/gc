# ============================================
# MoonLang Standard Library - MySQL Driver
# Usage: from "stdlib/mysql.moon" import MySQL
# Requires: libmysql.dll (Windows) / libmysqlclient.so (Linux)
# ============================================

from "stdlib/dll.moon" import DLL, CString, buffer

class MySQL:
    function init():
        # Load DLL based on platform
        if platform() == "windows":
            self.dll = new DLL("libmysql.dll")
        else:
            self.dll = new DLL("libmysqlclient.so")
        end
        
        # Get function pointers
        self._init = self.dll.getFunc("mysql_init")
        self._real_connect = self.dll.getFunc("mysql_real_connect")
        self._query = self.dll.getFunc("mysql_query")
        self._store_result = self.dll.getFunc("mysql_store_result")
        self._fetch_row = self.dll.getFunc("mysql_fetch_row")
        self._fetch_fields = self.dll.getFunc("mysql_fetch_fields")
        self._num_fields = self.dll.getFunc("mysql_num_fields")
        self._num_rows = self.dll.getFunc("mysql_num_rows")
        self._free_result = self.dll.getFunc("mysql_free_result")
        self._close = self.dll.getFunc("mysql_close")
        self._error = self.dll.getFunc("mysql_error")
        self._errno = self.dll.getFunc("mysql_errno")
        self._insert_id = self.dll.getFunc("mysql_insert_id")
        self._affected_rows = self.dll.getFunc("mysql_affected_rows")
        self._real_escape_string = self.dll.getFunc("mysql_real_escape_string")
        self._set_character_set = self.dll.getFunc("mysql_set_character_set")
        self._fetch_lengths = self.dll.getFunc("mysql_fetch_lengths")
        self._field_count = self.dll.getFunc("mysql_field_count")
        
        # Initialize MySQL handle
        self.conn = dll_call_int(self._init, 0)
        self.connected = false
        self.lastError = ""
    end
    
    # Connect to MySQL server
    function connect(host, user, password, database, port):
        if port == null:
            port = 3306
        end
        
        hostStr = new CString(host)
        userStr = new CString(user)
        passStr = new CString(password)
        dbStr = new CString(database)
        
        result = dll_call_int(self._real_connect, self.conn, hostStr.pointer(), userStr.pointer(), passStr.pointer(), dbStr.pointer(), port, 0, 0)
        
        hostStr.free()
        userStr.free()
        passStr.free()
        dbStr.free()
        
        if result != 0:
            self.connected = true
            # Set UTF-8 charset
            charsetStr = new CString("utf8mb4")
            dll_call_int(self._set_character_set, self.conn, charsetStr.pointer())
            charsetStr.free()
            return true
        else:
            self.lastError = self.getError()
            return false
        end
    end
    
    # Check if connected
    function isConnected():
        return self.connected
    end
    
    # Execute SQL (no return result)
    function exec(sql):
        if not self.connected:
            return false
        end
        sqlStr = new CString(sql)
        result = dll_call_int(self._query, self.conn, sqlStr.pointer())
        sqlStr.free()
        return result == 0
    end
    
    # Query (returns list of dictionaries)
    function query(sql):
        results = []
        if not self.connected:
            return results
        end
        
        sqlStr = new CString(sql)
        result = dll_call_int(self._query, self.conn, sqlStr.pointer())
        sqlStr.free()
        
        if result != 0:
            self.lastError = self.getError()
            return results
        end
        
        res = dll_call_int(self._store_result, self.conn)
        if res == 0:
            # Query succeeded but no result set (INSERT, UPDATE, etc.)
            return results
        end
        
        numFields = dll_call_int(self._num_fields, res)
        
        # Get field information for column names
        fieldsPtr = dll_call_int(self._fetch_fields, res)
        columns = []
        
        # For simplicity, use numeric indices if field names not accessible
        for i = 0 to numFields - 1:
            append(columns, "col" + str(i))
        end
        
        # Fetch rows
        row = dll_call_int(self._fetch_row, res)
        while row != 0:
            rowData = {}
            for i = 0 to numFields - 1:
                # Read string value from row array
                valPtr = dll_call_int(row + i * 8, null)
                if valPtr != 0:
                    rowData[columns[i]] = ptr_to_str(valPtr)
                else:
                    rowData[columns[i]] = null
                end
            end
            append(results, rowData)
            row = dll_call_int(self._fetch_row, res)
        end
        
        dll_call_void(self._free_result, res)
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
    
    # Escape string for SQL
    function escape(str):
        if not self.connected:
            return replace(str, "'", "''")
        end
        
        # Allocate buffer for escaped string (worst case: 2x + 1)
        bufSize = len(str) * 2 + 1
        buf = buffer(bufSize)
        srcStr = new CString(str)
        
        dll_call_int(self._real_escape_string, self.conn, buf.pointer(), srcStr.pointer(), len(str))
        
        result = buf.read()
        buf.free()
        srcStr.free()
        return result
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
        return dll_call_int(self._insert_id, self.conn)
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
        return dll_call_int(self._affected_rows, self.conn)
    end
    
    # Delete records
    function delete(tableName, where):
        sql = "DELETE FROM " + tableName + " WHERE " + where
        self.exec(sql)
        return dll_call_int(self._affected_rows, self.conn)
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
    
    # Transaction control
    function begin():
        return self.exec("START TRANSACTION")
    end
    
    function commit():
        return self.exec("COMMIT")
    end
    
    function rollback():
        return self.exec("ROLLBACK")
    end
    
    # Get error message
    function getError():
        errPtr = dll_call_int(self._error, self.conn)
        return ptr_to_str(errPtr)
    end
    
    # Get error code
    function getErrorCode():
        return dll_call_int(self._errno, self.conn)
    end
    
    # Get last insert ID
    function lastInsertId():
        return dll_call_int(self._insert_id, self.conn)
    end
    
    # Get affected rows
    function affectedRows():
        return dll_call_int(self._affected_rows, self.conn)
    end
    
    # Close connection
    function close():
        if self.connected:
            dll_call_void(self._close, self.conn)
            self.connected = false
        end
        self.dll.close()
    end
end

# Quick connect function
function connectMySQL(host, user, password, database, port):
    mysql = new MySQL()
    mysql.connect(host, user, password, database, port)
    return mysql
end
