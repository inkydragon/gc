# ============================================
# MoonLang Standard Library - PostgreSQL Driver
# Usage: from "stdlib/pgsql.moon" import PostgreSQL
# Requires: libpq.dll (Windows) / libpq.so (Linux)
# ============================================

from "stdlib/dll.moon" import DLL, CString, buffer

# PostgreSQL connection status
CONNECTION_OK = 0
CONNECTION_BAD = 1

# PostgreSQL execution status
PGRES_EMPTY_QUERY = 0
PGRES_COMMAND_OK = 1
PGRES_TUPLES_OK = 2
PGRES_COPY_OUT = 3
PGRES_COPY_IN = 4
PGRES_BAD_RESPONSE = 5
PGRES_NONFATAL_ERROR = 6
PGRES_FATAL_ERROR = 7

class PostgreSQL:
    function init():
        # Load DLL based on platform
        if platform() == "windows":
            self.dll = new DLL("libpq.dll")
        else:
            self.dll = new DLL("libpq.so")
        end
        
        # Get function pointers
        self._connectdb = self.dll.getFunc("PQconnectdb")
        self._status = self.dll.getFunc("PQstatus")
        self._exec = self.dll.getFunc("PQexec")
        self._result_status = self.dll.getFunc("PQresultStatus")
        self._ntuples = self.dll.getFunc("PQntuples")
        self._nfields = self.dll.getFunc("PQnfields")
        self._fname = self.dll.getFunc("PQfname")
        self._getvalue = self.dll.getFunc("PQgetvalue")
        self._getisnull = self.dll.getFunc("PQgetisnull")
        self._clear = self.dll.getFunc("PQclear")
        self._finish = self.dll.getFunc("PQfinish")
        self._error = self.dll.getFunc("PQerrorMessage")
        self._escape_literal = self.dll.getFunc("PQescapeLiteral")
        self._freemem = self.dll.getFunc("PQfreemem")
        self._cmdTuples = self.dll.getFunc("PQcmdTuples")
        
        self.conn = 0
        self.connected = false
        self.lastError = ""
    end
    
    # Connect using connection string
    function connect(connString):
        connStr = new CString(connString)
        self.conn = dll_call_int(self._connectdb, connStr.pointer())
        connStr.free()
        
        status = dll_call_int(self._status, self.conn)
        if status == CONNECTION_OK:
            self.connected = true
            return true
        else:
            self.lastError = self.getError()
            return false
        end
    end
    
    # Connect using individual parameters
    function connectParams(host, port, user, password, database):
        if port == null:
            port = 5432
        end
        connString = "host=" + host + " port=" + str(port) + " user=" + user + " password=" + password + " dbname=" + database
        return self.connect(connString)
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
        result = dll_call_int(self._exec, self.conn, sqlStr.pointer())
        sqlStr.free()
        
        status = dll_call_int(self._result_status, result)
        dll_call_void(self._clear, result)
        
        return status == PGRES_COMMAND_OK or status == PGRES_TUPLES_OK
    end
    
    # Query (returns list of dictionaries)
    function query(sql):
        results = []
        if not self.connected:
            return results
        end
        
        sqlStr = new CString(sql)
        result = dll_call_int(self._exec, self.conn, sqlStr.pointer())
        sqlStr.free()
        
        status = dll_call_int(self._result_status, result)
        if status != PGRES_TUPLES_OK:
            self.lastError = self.getError()
            dll_call_void(self._clear, result)
            return results
        end
        
        nrows = dll_call_int(self._ntuples, result)
        ncols = dll_call_int(self._nfields, result)
        
        # Get column names
        columns = []
        for i = 0 to ncols - 1:
            namePtr = dll_call_int(self._fname, result, i)
            append(columns, ptr_to_str(namePtr))
        end
        
        # Get data
        for row = 0 to nrows - 1:
            rowData = {}
            for col = 0 to ncols - 1:
                isNull = dll_call_int(self._getisnull, result, row, col)
                if isNull == 1:
                    rowData[columns[col]] = null
                else:
                    valPtr = dll_call_int(self._getvalue, result, row, col)
                    rowData[columns[col]] = ptr_to_str(valPtr)
                end
            end
            append(results, rowData)
        end
        
        dll_call_void(self._clear, result)
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
        
        srcStr = new CString(str)
        escapedPtr = dll_call_int(self._escape_literal, self.conn, srcStr.pointer(), len(str))
        srcStr.free()
        
        if escapedPtr != 0:
            result = ptr_to_str(escapedPtr)
            dll_call_void(self._freemem, escapedPtr)
            return result
        end
        
        # Fallback to simple escape
        return "'" + replace(str, "'", "''") + "'"
    end
    
    # Insert and return ID (uses RETURNING clause)
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
        
        sql = "INSERT INTO " + tableName + " (" + join(cols, ", ") + ") VALUES (" + join(vals, ", ") + ") RETURNING id"
        results = self.query(sql)
        if len(results) > 0:
            idVal = results[0]["id"]
            if idVal != null:
                return int(idVal)
            end
        end
        return 0
    end
    
    # Insert without returning ID
    function insertRaw(tableName, data):
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
        return self.exec(sql)
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
        return self.exec(sql)
    end
    
    # Delete records
    function delete(tableName, where):
        sql = "DELETE FROM " + tableName + " WHERE " + where
        return self.exec(sql)
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
        sql = "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = '" + tableName + "')"
        result = self.queryValue(sql)
        return result == "t" or result == "true" or result == "1"
    end
    
    # Get all table names
    function tables():
        sql = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name"
        results = self.query(sql)
        names = []
        for row in results:
            append(names, row["table_name"])
        end
        return names
    end
    
    # Transaction control
    function begin():
        return self.exec("BEGIN")
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
    
    # Close connection
    function close():
        if self.connected:
            dll_call_void(self._finish, self.conn)
            self.connected = false
        end
        self.dll.close()
    end
end

# Quick connect functions
function connectPostgreSQL(connString):
    pg = new PostgreSQL()
    pg.connect(connString)
    return pg
end

function connectPg(host, user, password, database, port):
    pg = new PostgreSQL()
    pg.connectParams(host, port, user, password, database)
    return pg
end
