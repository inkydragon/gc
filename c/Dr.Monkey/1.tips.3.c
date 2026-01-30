// 1.tips 小知识点
#include <stdio.h>

int main()
{
    // (int)expr 强制类型转换
    double a;
    //  个, 十,  百
    printf("请输入数字：\n"); 
    int Ge, Shi, Bai;
    scanf("%lf", &a);

    Bai = (int) (a/100);
    Shi = (int) ( (a - Bai*100)/10 );
    Ge  = (int) (a - Bai*100 - Shi*10);

    printf("个位数字：%d\n", Ge); 
    printf("十位数字：%d\n", Shi); 
    printf("百位数字：%d", Bai); 
    // > 请输入数字：
    // < 314
    // > 个位数字：4
    // > 十位数字：1
    // > 百位数字：3
    return 0;
}