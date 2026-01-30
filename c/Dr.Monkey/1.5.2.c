// 1.5 用 scanf 读取数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    char a,b;
    printf("输入大写字母：\n");
    scanf("%c", &a);
    b = a+32;
    printf("%c的小写是%c", a,b);
    // > 输入大写字母：
    // < A
    // > A的小写是a
    return 0;
}