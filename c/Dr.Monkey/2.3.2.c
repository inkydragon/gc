// 2.3 <expr1> ? <expr2> : <expr3> 三元表达式
#include <stdio.h>

int main()
{
    double a,b,t;
    scanf("%lf,%lf", &a,&b);
    // a = 10;
    // b = 90;
    /// 方法 2
    (a>b) ? printf("%f,%f", a,b); : printf("%f,%f", b,a);

    /// 方法 1
    // if (a > b) { 
    //     // 交换 a,b
    //     t = a;
    //     a = b;
    //     b = t;
    // }
    // printf("%f,%f", a,b);
    return 0;
    // < 10,90
    // > 10.000000,90.000000
    // < 90,10
    // > 10.000000,90.000000
}