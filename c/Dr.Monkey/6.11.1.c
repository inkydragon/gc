// 6.11 返回指针的函数
#include <stdio.h>

float *lookup(float (*p)[4], int n);

int main() 
{
    float *p, a[3][4] = {65,67,70,60, 80,87,90,81, 90,99,93,98};
    int n;
    printf("请输入学生序号：");
    scanf("%d", &n);
    printf("第%d名学生的成绩：", n);
    p = lookup(a, n-1);
    for (int i=0; i<=3; i++) printf("%f,", *(p+i));
    // 请输入学生序号：3
    // 第3名学生的成绩：90.000000,99.000000,93.000000,98.000000,
    return 0;
}

float *lookup(float (*p)[4], int n) {
    float *q;
    q = (p+n)[0];
    return q;
}