// 6.3 指针与一维数组
#include <stdio.h>

// 形参是指针变量，实参是指针变量
float aver(float *p, int n);

int main()
{
    float gp1[5], gp2[10], *p=&gp1, *q=&gp2;
    printf("第一组成绩：\n");
    for (int i=0; i<=4; i++) {
        printf("  输入第%d个成绩", i+1);
        scanf("%f", p+i);
    }
    printf("第二组成绩：\n");
    for (int i=0; i<=9; i++) {
        printf("  输入第%d个成绩", i+1);
        scanf("%f", q+i);
    }
    printf("第一组平均分%f\n", aver(p,5));
    printf("第二组平均分%f\n", aver(q,10));
    // 第一组成绩：
    //   输入第1个成绩2
    //   输入第2个成绩4
    //   输入第3个成绩6
    //   输入第4个成绩8
    //   输入第5个成绩0
    // 第二组成绩：
    //   输入第1个成绩1
    //   输入第2个成绩2
    //   输入第3个成绩3
    //   输入第4个成绩4
    //   输入第5个成绩5
    //   输入第6个成绩6
    //   输入第7个成绩7
    //   输入第8个成绩8
    //   输入第9个成绩9
    //   输入第10个成绩0
    // 第一组平均分4.000000
    // 第二组平均分4.500000
    return 0;
}

float aver(float *p, int n) {
    float sum=*p;
    for (int i=1; i<n; i++) sum+=*(p+i);
    return sum/n;
}