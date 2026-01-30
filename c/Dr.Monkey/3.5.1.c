// 3.5 do-while 循环
#include <stdio.h>

int main()
{
    int n=1,sum=0,a=2;
    /// 方法 2 do-while
    do {
        n += 1;
        sum += a;
        a += 2;
    } while (n <= 50);
    /// 方法 1
    // while(n <= 50) {
    //     n += 1;
    //     sum += a;
    //     a += 2;
    // }
    printf("sum=%d", sum);
    //> sum=2550
    return 0;
}