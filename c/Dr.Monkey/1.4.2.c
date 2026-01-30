// 1.4 用 printf 输出数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    // 先定义后使用
    int a, b, sum;
    a = 123;
    b = 456;
    sum = a + b;
    printf("sum=a+b=%d", sum);
    // sum=a+b=579
    return 0;
}