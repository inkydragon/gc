// 1.7 数学运算(e^x, log, ...)
#include <stdio.h>
#include <math.h>  // 导入数学库

int main()
{
    double a,b,c,s,area;
    printf("Input: a,b,c\n");
    scanf("%lf,%lf,%lf", &a,&b,&c);

    s = (a+b+c)/2;
    area = sqrt(s*(s-a)*(s-b)*(s-c));

    printf("a=%f,b=%f,c=%f\n", a,b,c);
    printf("area=%f", area);
    // > Input: a,b,c
    // < 3,4,5
    // > a=3.000000,b=4.000000,c=5.000000
    // > area=6.000000
    return 0;
}