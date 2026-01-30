// 1.4 用 printf 输出数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    // 先定义后使用
    int a=5, b, c, d, e, f;
    b = a + 2; // = 5+2 = 7
    c = b - a; // = 7-5 = 2
    d = a * c; // = 5*2 =10
    e = a / d; // = (int) 5/10 = 0
    f = a % d; // = 5%10 = 5
    printf("a=%d,b=%d,c=%d\n", a,b,c);
    printf("d=%d,e=%d,f=%d\n", d,e,f);
    // a=5,b=7,c=2
    // d=10,e=0,f=5
    // 
    return 0;
}