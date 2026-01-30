// 6.5 指针与二维数组
#include <stdio.h>

// 形参是指针变量，实参是数组名
void output(float *p, int n);

int main() 
{
    float a[3][4] = {65,67,70,60, 80,87,90,81, 90,99,93,98};
    output(*a, 12);
    //> 三人的总平均分为81.666664
    return 0;
}

void output(float *p, int n) {
    float sum=0;
    for (int i=0; i<=11; i++) sum+=*(p+i);
    printf("三人的总平均分为%f", sum/n);
}