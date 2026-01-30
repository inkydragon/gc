// 1.4 用 printf 输出数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    // 先定义后使用
    double a, b, c, s;
    a = 3.67;
    b = 5.43;
    c = 6.21;
    s = (a+b+c)/2;
    printf("a=%f,b=%f,c=%f\n", a,b,c);
    printf("s=(a+b+c)/2=%f", s);
    // a=3.670000,b=5.430000,c=6.210000
    // s=(a+b+c)/2=7.655000
    return 0;
}