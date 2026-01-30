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
    // lv = 'F';

    switch(lv) {
        case 'A':
        case 'B': printf("70~100\n"); break;
        case 'C':
        case 'D': printf("<70\n"); break;
        default:  printf("Error lv!\n"); break;
    }
    return 0;
    // < F
    // > Error lv!
    // < A
    // > 70~100
}