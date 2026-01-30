// 2.1 if 语句
#include <stdio.h>

int main()
{
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
    // if (x >= 0) {
    //     if (x > 0) {
    //         y = 1;
    //     } else {
    //         y = 0;
    //     }
    // } else {
    //     y = -1;
    // }
    printf("x=%d,y=%d", x,y);
    // < -1
    // > x=-1,y=-1
    // < 0
    // > x=0,y=0
    // < 10
    // > x=10,y=1
    return 0;
}