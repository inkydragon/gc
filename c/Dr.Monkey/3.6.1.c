// 3.6 for 循环
#include <stdio.h>

int main()
{
    int sum=0,a=1;
    /// 方法 3
    for (int n=1; n<=20; sum+=a,n++) a*=n;

    /// 方法 2
    // for ( ; n<=20; ) {
    //     a *= n;
    //     sum += a;
    //     n += 1;
    // }

    /// 方法 1
    // while(n <= 20) {
    //     a *= n;
    //     sum += a;
    //     n += 1;
    // }
    printf("sum=%d", sum);
    //> sum=268040729
    return 0;
}