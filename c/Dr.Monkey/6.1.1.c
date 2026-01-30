// 6.1 指针
#include <stdio.h>

int main()
{
    int a,b,t, *p,*q,*r;
    printf("输入两整数：");
    scanf("%d,%d", &a,&b);
    p = &a;
    q = &b;
    /// 方法 1
    if (a < b) {
        r = p;
        p = q;
        q = r;
    }

    /// 方法 2
    // if (a < b) {
    //     t = *p;
    //     *p = *q;
    //     *q = t;
    // }
    printf("较大数%d, 较小数%d", a,b);
    // 输入两整数：10,0
    // 较大数10, 较小数0
    return 0;
}