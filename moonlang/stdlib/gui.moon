# ============================================
# MoonScript 标准库 - GUI (WebView2) - v3.1
# 用法: from "stdlib/gui.moon" import Window, Tray, Widget
# ============================================
#
# 资源打包: 在代码顶层声明要打包的文件夹
# 然后用 gui_load_url 加载打包的资源
# 支持的资源类型: HTML, CSS, JS, 图片, JSON 等
# 自动排除: .moon, .exe, .obj, .git 等
# ============================================

# ========== Window 类 ==========

class Window:
    function init(options):
        self.id = 0
        self.title = "MoonScript"
        self.width = 800
        self.height = 600
        self.options = {
            "frameless": false, 
            "transparent": false, 
            "topmost": false, 
            "resizable": true,
            "center": true,
            "devtools": false
        }
        self._messageHandler = null
        self._closeHandler = null
        self._exposedFuncs = {}
        
        if options != null:
            if has_key(options, "title"):
                self.title = options["title"]
            end
            if has_key(options, "width"):
                self.width = options["width"]
            end
            if has_key(options, "height"):
                self.height = options["height"]
            end
            if has_key(options, "frameless"):
                self.options["frameless"] = options["frameless"]
            end
            if has_key(options, "transparent"):
                self.options["transparent"] = options["transparent"]
            end
            if has_key(options, "topmost"):
                self.options["topmost"] = options["topmost"]
            end
            if has_key(options, "resizable"):
                self.options["resizable"] = options["resizable"]
            end
            if has_key(options, "center"):
                self.options["center"] = options["center"]
            end
            if has_key(options, "x"):
                self.options["x"] = options["x"]
            end
            if has_key(options, "y"):
                self.options["y"] = options["y"]
            end
            if has_key(options, "alpha"):
                self.options["alpha"] = options["alpha"]
            end
            if has_key(options, "clickThrough"):
                self.options["clickThrough"] = options["clickThrough"]
            end
            if has_key(options, "parent"):
                self.options["parent"] = options["parent"]
            end
            if has_key(options, "devtools"):
                self.options["devtools"] = options["devtools"]
            end
        end
        
        gui_init()
    end
    
    function create():
        self.id = gui_create(self.title, self.width, self.height, self.options)
        return self
    end
    
    function loadHTML(html):
        if self.id > 0:
            gui_load_html(self.id, html)
        else:
            gui_load_html(html)
        end
        return self
    end
    
    function loadURL(url):
        if self.id > 0:
            gui_load_url(self.id, url)
        else:
            gui_load_url(url)
        end
        return self
    end
    
    function loadFile(path):
        fullPath = path
        if not starts_with(path, "/") and not contains(path, ":"):
            fullPath = getcwd() + "/" + path
        end
        url = "file:///" + replace(fullPath, "\\", "/")
        return self.loadURL(url)
    end
    
    # 加载本地资源 (使用 moon 协议)
    # 注意: 此函数在运行时拼接路径，资源不会被打包到 EXE
    # 如需打包资源，请直接使用字面量字符串调用 gui_load_url
    function loadLocal(path):
        if self.id > 0:
            # 拆分字符串避免编译器静态分析
            protocol = "moon" + "://"
            gui_load_url(self.id, protocol + path)
        end
        return self
    end
    
    function eval(js):
        if self.id > 0:
            return gui_eval(self.id, js)
        end
        return null
    end
    
    function setTitle(title):
        if self.id > 0:
            gui_set_title(self.id, title)
        end
        self.title = title
        return self
    end
    
    function setSize(width, height):
        if self.id > 0:
            gui_set_size(self.id, width, height)
        end
        self.width = width
        self.height = height
        return self
    end
    
    function setPosition(x, y):
        if self.id > 0:
            gui_set_position(self.id, x, y)
        end
        return self
    end
    
    function center():
        return self.setPosition(-1, -1)
    end
    
    function show():
        if self.id > 0:
            gui_show(self.id, true)
        end
        return self
    end
    
    function hide():
        if self.id > 0:
            gui_show(self.id, false)
        end
        return self
    end
    
    function minimize():
        if self.id > 0:
            gui_minimize(self.id)
        end
        return self
    end
    
    function maximize():
        if self.id > 0:
            gui_maximize(self.id)
        end
        return self
    end
    
    function restore():
        if self.id > 0:
            gui_restore(self.id)
        end
        return self
    end
    
    function close():
        if self.id > 0:
            gui_close(self.id)
        end
        self.id = 0
        return self
    end
    
    function onMessage(callback):
        if self.id > 0:
            gui_on_message(self.id, callback)
        else:
            gui_on_message(callback)
        end
        self._messageHandler = callback
        return self
    end
    
    function onClose(callback):
        if self.id > 0:
            gui_on_close(self.id, callback)
        end
        self._closeHandler = callback
        return self
    end
    
    function postMessage(message):
        if self.id > 0:
            msg = message
            if type(message) != "string":
                msg = json_encode(message)
            end
            gui_post_message(self.id, msg)
        end
        return self
    end
    
    # 暴露函数给 JS 调用 (新功能)
    # JS 端使用: MoonGUI.call('funcName', arg1, arg2, ...)
    function expose(name, callback):
        if self.id > 0:
            gui_expose(self.id, name, callback)
        else:
            # 窗口还没创建，先存储
            self._exposedFuncs[name] = callback
        end
        return self
    end
    
    # 批量暴露函数
    function exposeAll(funcs):
        for name in keys(funcs):
            self.expose(name, funcs[name])
        end
        return self
    end
    
    function getId():
        return self.id
    end
    
    function isValid():
        return self.id > 0
    end
end

# ========== Tray 类 (系统托盘) ==========

class Tray:
    function init(tooltip, iconPath):
        if tooltip == null:
            tooltip = "MoonScript App"
        end
        if iconPath == null:
            iconPath = ""
        end
        self.tooltip = tooltip
        self.iconPath = iconPath
        self.created = false
        self._clickHandler = null
    end
    
    function create():
        if self.created:
            return true
        end
        self.created = gui_tray_create(self.tooltip, self.iconPath)
        return self.created
    end
    
    function setMenu(items):
        gui_tray_set_menu(items)
        return self
    end
    
    function onClick(callback):
        gui_tray_on_click(callback)
        self._clickHandler = callback
        return self
    end
    
    function remove():
        gui_tray_remove()
        self.created = false
        return self
    end
end

# ========== Widget 全局状态 (避免闭包问题) ==========
_widget_instance = null
_widget_window = null
_widget_tray = null
_widget_onMessage = null
_widget_onTrayClick = null
_widget_onExit = null
_widget_mutex = 0
_widget_user32 = null
_widget_kernel32 = null

# Widget 消息处理器
function _widget_msg_handler(msg):
    data = json_decode(msg)
    if data != null:
        msgType = get(data, "type", "")
        if msgType == "close" or msgType == "exit":
            _widget_do_exit()
        elif msgType == "minimize" or msgType == "hide":
            gui_show(false)
        elif _widget_onMessage != null:
            _widget_onMessage(data)
        end
    end
end

# Widget 托盘处理器
function _widget_tray_handler(action):
    if action == "退出" or action == "exit" or action == "Exit":
        _widget_do_exit()
    elif action == "显示" or action == "show" or action == "Show":
        gui_show(true)
    elif action == "隐藏" or action == "hide" or action == "Hide":
        gui_show(false)
    elif _widget_onTrayClick != null:
        _widget_onTrayClick(action)
    end
end

# Widget 退出处理
function _widget_do_exit():
    if _widget_onExit != null:
        _widget_onExit()
    end
    
    gui_tray_remove()
    
    if _widget_mutex != 0 and _widget_kernel32 != null:
        CloseHandle = dll_func(_widget_kernel32, "CloseHandle")
        dll_call_int(CloseHandle, _widget_mutex)
    end
    
    if _widget_user32 != null:
        dll_close(_widget_user32)
    end
    if _widget_kernel32 != null:
        dll_close(_widget_kernel32)
    end
    
    gui_quit()
    exit(0)
end

# ========== Widget 类 (桌面小部件/桌宠) ==========
# 简化创建透明、置顶、无边框窗口的流程

class Widget:
    function init(config):
        # 默认配置
        self.title = "Widget"
        self.width = 200
        self.height = 200
        self.htmlFile = null
        self.iconPath = ""
        self.singleInstance = true
        self.hideTaskbar = true
        self.showTray = true
        self.trayMenu = [["退出", "exit"]]
        self.topmost = true
        
        # 应用配置
        if config != null:
            if has_key(config, "title"):
                self.title = config["title"]
            end
            if has_key(config, "width"):
                self.width = config["width"]
            end
            if has_key(config, "height"):
                self.height = config["height"]
            end
            if has_key(config, "html"):
                self.htmlFile = config["html"]
            end
            if has_key(config, "icon"):
                self.iconPath = config["icon"]
            end
            if has_key(config, "singleInstance"):
                self.singleInstance = config["singleInstance"]
            end
            if has_key(config, "hideTaskbar"):
                self.hideTaskbar = config["hideTaskbar"]
            end
            if has_key(config, "showTray"):
                self.showTray = config["showTray"]
            end
            if has_key(config, "trayMenu"):
                self.trayMenu = config["trayMenu"]
            end
            if has_key(config, "topmost"):
                self.topmost = config["topmost"]
            end
            if has_key(config, "onExit"):
                _widget_onExit = config["onExit"]
            end
            if has_key(config, "onTrayClick"):
                _widget_onTrayClick = config["onTrayClick"]
            end
            if has_key(config, "onMessage"):
                _widget_onMessage = config["onMessage"]
            end
        end
        
        _widget_instance = self
    end
    
    # 检查单实例
    function _checkSingleInstance():
        if not self.singleInstance:
            return true
        end
        
        _widget_kernel32 = dll_load("kernel32.dll")
        CreateMutexA = dll_func(_widget_kernel32, "CreateMutexA")
        GetLastError = dll_func(_widget_kernel32, "GetLastError")
        CloseHandle = dll_func(_widget_kernel32, "CloseHandle")
        
        mutexName = alloc_str("Global\\MoonWidget_" + self.title)
        _widget_mutex = dll_call_int(CreateMutexA, 0, 1, mutexName)
        free_str(mutexName)
        
        ERROR_ALREADY_EXISTS = 183
        if dll_call_int(GetLastError) == ERROR_ALREADY_EXISTS:
            if _widget_mutex != 0:
                dll_call_int(CloseHandle, _widget_mutex)
            end
            dll_close(_widget_kernel32)
            return false
        end
        return true
    end
    
    # 隐藏任务栏图标
    function _hideFromTaskbar():
        if not self.hideTaskbar:
            return
        end
        
        _widget_user32 = dll_load("user32.dll")
        GetForegroundWindow = dll_func(_widget_user32, "GetForegroundWindow")
        GetAncestor = dll_func(_widget_user32, "GetAncestor")
        GetWindowLongA = dll_func(_widget_user32, "GetWindowLongA")
        SetWindowLongA = dll_func(_widget_user32, "SetWindowLongA")
        ShowWindow = dll_func(_widget_user32, "ShowWindow")
        
        GWL_EXSTYLE = -20
        WS_EX_TOOLWINDOW = 128
        SW_HIDE = 0
        SW_SHOW = 5
        GA_ROOT = 2
        
        hwnd = dll_call_int(GetForegroundWindow)
        if hwnd != 0:
            root = dll_call_int(GetAncestor, hwnd, GA_ROOT)
            
            style = dll_call_int(GetWindowLongA, hwnd, GWL_EXSTYLE)
            dll_call_int(ShowWindow, hwnd, SW_HIDE)
            dll_call_int(SetWindowLongA, hwnd, GWL_EXSTYLE, style + WS_EX_TOOLWINDOW)
            dll_call_int(ShowWindow, hwnd, SW_SHOW)
            
            if root != 0 and root != hwnd:
                style = dll_call_int(GetWindowLongA, root, GWL_EXSTYLE)
                dll_call_int(ShowWindow, root, SW_HIDE)
                dll_call_int(SetWindowLongA, root, GWL_EXSTYLE, style + WS_EX_TOOLWINDOW)
                dll_call_int(ShowWindow, root, SW_SHOW)
            end
        end
    end
    
    # 启动 Widget (需要手动调用 loadHtml 加载内容)
    function start():
        if not self._checkSingleInstance():
            return false
        end
        
        # 直接使用 gui_* 函数 (单窗口模式，更稳定)
        gui_init()
        
        gui_create(self.title, self.width, self.height, {
            "transparent": true,
            "frameless": true,
            "topmost": self.topmost,
            "resizable": false,
            "center": true
        })
        
        # 注意: HTML 加载必须在调用代码中使用字面量字符串
        # 不能用变量拼接，因为编译器需要在编译时解析路径
        
        # 设置消息处理
        gui_on_message(_widget_msg_handler)
        
        # 创建托盘
        if self.showTray:
            gui_tray_create(self.title, self.iconPath)
            gui_tray_set_menu(self.trayMenu)
            gui_tray_on_click(_widget_tray_handler)
        end
        
        # 延迟隐藏任务栏图标
        sleep(200)
        self._hideFromTaskbar()
        
        return true
    end
    
    function run():
        gui_run()
    end
    
    function launch():
        if self.start():
            self.run()
        end
    end
    
    function exit():
        _widget_do_exit()
    end
    
    function show():
        gui_show(true)
        return self
    end
    
    function hide():
        gui_show(false)
        return self
    end
    
    function send(message):
        msg = message
        if type(message) != "string":
            msg = json_encode(message)
        end
        # 单窗口模式需要获取窗口ID，这里用全局变量
        # gui_post_message 必须有 windowId
        return self
    end
    
    function expose(name, callback):
        gui_expose(name, callback)
        return self
    end
end

# ========== 快捷函数 ==========

function createWindow(title, width, height):
    win = new Window({"title": title, "width": width, "height": height})
    win.create()
    return win
end

function createTransparentWindow(title, width, height):
    win = new Window({
        "title": title, 
        "width": width, 
        "height": height, 
        "transparent": true, 
        "frameless": true
    })
    win.create()
    return win
end

function createFramelessWindow(title, width, height):
    win = new Window({
        "title": title, 
        "width": width, 
        "height": height, 
        "frameless": true
    })
    win.create()
    return win
end

function createFloatingWindow(title, width, height):
    win = new Window({
        "title": title, 
        "width": width, 
        "height": height, 
        "topmost": true, 
        "frameless": true
    })
    win.create()
    return win
end

function createTray(tooltip, iconPath):
    tray = new Tray(tooltip, iconPath)
    tray.create()
    return tray
end

# 一行代码创建桌面小部件
function createWidget(config):
    widget = new Widget(config)
    return widget
end

# ========== 全局函数 ==========

function run():
    gui_run()
end

function quit():
    gui_quit()
end

function alert(message):
    return gui_alert(message)
end

function confirm(message):
    return gui_confirm(message)
end

# 模块信息
MODULE_NAME = "gui"
MODULE_VERSION = "3.0.0"
MODULE_DESCRIPTION = "MoonScript GUI 模块 - 支持 Window, Tray, Widget"
