// 2.1 if 语句
#include <stdio.h>

int main()
{
    double a,b,c,t;
    scanf("%lf,%lf,%lf", &a,&b,&c);
    // a = -1;
    // b = 1;
    // c = 0;
    if (a > b) { 
        // 交换 a,b
        t = a;
        a = b;
        b = t;
    }
    if (a > c) { 
        // 交换 a,c
        t = a;
        a = c;
        c = t;
    }
    if (b > c) { 
        // 交换 b,c
        t = b;
        b = c;
        c = t;
    }
    printf("%f,%f,%f", a,b,c);
    // < -1,1,0
    // > -1.000000,0.000000,1.000000
    return 0;
}