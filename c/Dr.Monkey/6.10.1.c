// 6.10 指针与函数
#include <stdio.h>

int max(int x, int y);

int main()
{
    int a,b,(*p)(int,int);
    p = max;
    // a=10; b=20;
    printf("请输入2个数字：");
    scanf("%d,%d", &a,&b);

    /// 方法 2 改成用指针指向函数
    printf("较大的数为：%d", (*p)(a, b));
    /// 方法 1
    // printf("较大的数为：%d", max(a, b));

    // 请输入2个数字：10,20
    // 较大的数为：20
    return 0;
}

int max(int x, int y) {
    return (x>y ? x : y);
}