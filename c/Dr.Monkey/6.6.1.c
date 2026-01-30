// 6.6 指针与二维数组的行变量
#include <stdio.h>

int main() //  指针变量指向二维数组的行变量
{
    int a[3][3] = {1,2,3, 4,5,6, 7,8,9};
    int (*p)[3], row, col;
    p = a;

    printf("请输入 row,col: ");
    scanf("%d,%d", &row,&col);
    printf("%d行,%d列的元素为%d", row,col,*(*(p+row-1)+col-1));
    // 请输入 row,col: 2,3
    // 2行,3列的元素为6
    return 0;
}