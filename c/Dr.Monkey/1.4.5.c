// 1.4 用 printf 输出数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    // 凯撒加密
    char a='o', b='y', c='r', d='a';
    a = a + 1;
    b = b + 1;
    c = c + 1;
    d = d + 1;
    printf("密文：%c%c%c%c", a,b,c,d);
    // 密文：pzsb
    return 0;
}