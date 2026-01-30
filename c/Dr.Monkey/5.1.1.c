// 5.1 调用函数
#include <stdio.h>

float max(float x, float y);

int main()
{
    float a[4], t,u,v;
    // float t,u,v;
    // float a[] = {4,6,8,0};
    for (int i=0; i<=3; i++) {
        printf("请输入第%d个数字：", i+1);
        scanf("%f", &a[i]);
    }

    t = max(a[0], a[1]);
    u = max(a[2], a[3]);
    v = max(t, u);

    printf("前两个最大的：%f\n", t);
    printf("后两个最大的：%f\n", u);
    printf("数组中最大的：%f\n", v);
    // 请输入第1个数字：4
    // 请输入第2个数字：6
    // 请输入第3个数字：8
    // 请输入第4个数字：0
    // 前两个最大的：6.000000
    // 后两个最大的：8.000000
    // 数组中最大的：8.000000
    return 0;
}

float max(float x, float y) {
    return (x>y ? x : y);
}