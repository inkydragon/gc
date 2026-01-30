// 6.7 指针与二维数组的行变量
#include <stdio.h>

// 用指向二维数组行变量的指针变量做形参
void output(float (*p)[4], int n);

int main() 
{
    float a[3][4] = {65,67,70,60, 80,87,90,81, 90,99,93,98};
    output(a, 3);
    //> 第3个学生的成绩为：90.000000,99.000000,93.000000,98.000000,
    return 0;
}

void output(float (*p)[4], int n) {
    printf("第%d个学生的成绩为：", n);
    for (int i=0; i<=3; i++) printf("%f,", *(*(p+n-1)+i));
}