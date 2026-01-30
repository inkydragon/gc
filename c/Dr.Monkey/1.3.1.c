// 3.1 数据类型(int, float, double, char)
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
    return 0;
}