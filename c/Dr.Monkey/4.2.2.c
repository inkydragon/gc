// 4.2 二维数组
#include <stdio.h>

int main()
{
    // 多维数组即使初始化，必须显示指定大小
    int a[3][3] = {{1,2,3}, {9,8,7}, {-10,10,-5}};
    int i, j, max=a[0][0];

    for (i=0; i<=1; i++) {
        for (j=0; j<=2; j++) {
            if (a[i][j] > max) max=a[i][j];
        }
    }
    printf("max=%d\n", max);
    //> max=9
    return 0;
}