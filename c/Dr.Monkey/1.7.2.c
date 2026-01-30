// 1.7 数学运算(e^x, log, ...)
#include <stdio.h>
#include <math.h>

int main()
{
    // a*x^2 + b*x + c = 0
    double a,b,c,delta,x1,x2;
    printf("Input: a,b,c\n");
    scanf("%lf,%lf,%lf", &a,&b,&c);

    delta = sqrt(b*b - 4*a*c);
    x1 = (-b+delta)/(2*a);
    x2 = (-b-delta)/(2*a);

    printf("x1=%f\n", x1);
    printf("x2=%f",   x2);
    // > Input: a,b,c
    // < 1,0,-4
    // > x1=2.000000
    // > x2=-2.000000
    return 0;
}