// 2.1 if 语句
#include <stdio.h>

int main()
{
    double a,b,t;
    scanf("%lf,%lf", &a,&b);
    // a = 10;
    // b = 90;
    if (a > b) { 
        // 交换 a,b
        t = a;
        a = b;
        b = t;
    }
    printf("%f,%f", a,b);
    // < 10,90
    // > 10.000000,90.000000
    // < 90,10
    // > 10.000000,90.000000
    return 0;
}