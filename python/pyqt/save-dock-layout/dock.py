from PyQt5 import QtCore, QtWidgets


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        self.initUI()
        self.readSettings()

    def readSettings(self):
        settings = QtCore.QSettings("./QtPad.ini", QtCore.QSettings.IniFormat)
        self.restoreGeometry(settings.value("geometry").data())
        self.restoreState(settings.value("windowState").data())

    def closeEvent(self, event):
        settings = QtCore.QSettings("./QtPad.ini", QtCore.QSettings.IniFormat)
        settings.setValue("geometry", self.saveGeometry())
        settings.setValue("windowState", self.saveState())

    def initUI(self):
        self.toolbar = self.addToolBar('Toolbar')
        self.toolbar.setObjectName('Main Toolbar')

        self.toggle_dock_widget_action = self.toolbar.addAction(
            "Show/Hide Filter Pane"
        )
        self.toggle_dock_widget_action.setCheckable(True)

        self.controlDock = MyDockWidget('控制条')
        self.cardDock = MyDockWidget('卡片槽')
        self.addDockWidget(QtCore.Qt.TopDockWidgetArea, self.controlDock)
        self.addDockWidget(QtCore.Qt.TopDockWidgetArea, self.cardDock)
        self.setCentralWidget(QtWidgets.QLabel("This is the main widget"))


class MyDockWidget(QtWidgets.QDockWidget):
    def __init__(self, name, parent=None):
        super(MyDockWidget, self).__init__(parent)
        self.setObjectName(f'dock-{name}')
        self.setFloating(False)
        self.setWidget(QtWidgets.QLabel(name))


if __name__ == '__main__':
    import sys
    app = QtWidgets.QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec_())
