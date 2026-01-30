// 2.4 switch 语句
#include <stdio.h>

int main()
{
    double grade;
    printf("请输入分数：\n");
    scanf("%lf", &grade);
    // grade = 100;
    // grade = 73;
    // grade = 60;
    // grade = 59;
    // grade = 0;

    switch( (int)(grade/10) ) {
        case 10:
        case 9: printf("Lv. A\n"); break;
        case 8: printf("Lv. B\n"); break;
        case 7: printf("Lv. C\n"); break;
        case 6: printf("Lv. D\n"); break;
        case 5:
        case 4:
        case 3:
        case 2:
        case 1:
        case 0: printf("Lv. E\n"); break;
        default: printf("Error Grade!\n"); break;
    }
    return 0;
    // > 请输入分数：
    // < 100
    // > Lv. A
    // > 请输入分数：
    // < 0
    // > Lv. E
}