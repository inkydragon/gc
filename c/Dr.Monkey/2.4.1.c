// 2.4 switch 语句
#include <stdio.h>

int main()
{
    char lv;
    scanf("%c", &lv);
    // lv = 'A';
    // lv = 'B';
    // lv = 'C';
    // lv = 'D';

    switch(lv) {
        case 'A': printf("85~100\n"); break;
        case 'B': printf("70~84\n"); break;
        case 'C': printf("60~69\n"); break;
        case 'D': printf("<60\n"); break;
        // 最好带上处理其他情况的 default 语句
        default:  printf("Error lv!\n"); break;
    }
    return 0;
    // < D
    // > <60
    // < B
    // > 70~84
}