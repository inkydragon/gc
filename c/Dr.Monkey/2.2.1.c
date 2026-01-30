// 2.2 常见 if 语句用法
#include <stdio.h>

int main()
{   // 符号函数
    int x,y;
    scanf("%d", &x);
    if (x < 0) {
        y = -1;
    } else {
        if (x > 0) {
            y = 1;
        } else {
            y = 0;
        }
    }
    /// 另一种写法
    // if (x < 0) {
    //     y = -1;
    // } else {
    //     if (x == 0) {
    //         y = 0;
    //     } else {
    //         y = 1;
    //     }
    // }
    printf("%d", y);
    // < 10
    // > 1
    // < 0
    // > 0
    // < -2
    // > -1
    return 0;
}