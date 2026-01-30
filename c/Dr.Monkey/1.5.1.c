// 1.5 用 scanf 读取数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    int a,b,s;
    scanf("%d,%d", &a,&b);
    s = (a+b)/2;
    printf("s=(a+b)/2=%d", s);
    // < 200,100
    // > s=(a+b)/2=150
    return 0;
}