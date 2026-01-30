// 4.2 二维数组
#include <stdio.h>

int main()
{
    // 多维数组即使初始化，必须显示指定大小
    int a[2][3] = {{1,2,3}, {4,5,6}};
    int b[3][2], i, j;
    for (i=0; i<=1; i++) {
        for (j=0; j<=2; j++) {
            b[j][i] = a[i][j];
        }
    }
    printf("数组 b 为：\n");
    for (j=0; j<=2; j++) {
        for (i=0; i<=1; i++) printf("%d\t", b[i][j]);
        printf("\n");
    }
    // 数组 b 为：
    // 1	2	
    // 4	5	
    // 2	3	
    return 0;
}