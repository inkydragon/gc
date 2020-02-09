// - [c++ - Win32 - read from stdin with timeout - Stack Overflow](https://stackoverflow.com/a/21749034)

#include <Windows.h>
#include <stdio.h>

int main()
{
    char ret;
    DWORD fdwMode, fdwOldMode;
    HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);
    GetConsoleMode(hStdin, &fdwOldMode); // 保存旧的状态

    fdwMode = fdwOldMode 
            ^ ENABLE_ECHO_INPUT  // 不回显
            ^ ENABLE_LINE_INPUT; // return when one or more characters are available
    SetConsoleMode(hStdin, fdwMode); // 设置新状态
    FlushConsoleInputBuffer(hStdin); // 清空缓存

    while (1) {
        switch (WaitForSingleObject(hStdin, 1000))
        {
        case (WAIT_TIMEOUT):
            printf("timeout~\n");
            break;
        case (WAIT_OBJECT_0):
            if (_kbhit()) // _kbhit() always returns immediately
            {
                ret = getchar(); // _getch
                printf("> %c\n", ret);
            }
            else // some sort of other events , we need to clear it from the queue
            {
                // clear events
                INPUT_RECORD r[512];
                DWORD read;
                ReadConsoleInput(hStdin, r, 512, &read);
                printf("mouse event\n");
            }
            break;
        case (WAIT_FAILED):
            printf("WAIT_FAILED\n");
            break;
        case (WAIT_ABANDONED):
            printf("WAIT_ABANDONED\n");
            break;
        default:
            printf("Someting's unexpected was returned.\n");
        }
    }
    SetConsoleMode(hStdin, fdwOldMode); // 退出前恢复状态
    return 0;
}