// 3.1 while 循环
#include <stdio.h>

int main()
{
    int n=1,sum=0,a=1;
    while(n <= 20) {
        n += 1;
        sum += a;
        a *= n;
    }
    printf("sum=%d", sum);
    //> sum=268040729
    return 0;
}