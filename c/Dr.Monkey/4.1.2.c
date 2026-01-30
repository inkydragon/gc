// 4.1 一维数组
#include <stdio.h>

int main()
{
    // 显示初始化数组时可以不写明数组大小 a[10]
    int a[10];
    // int a[] = {9,7,5,3,1,2,4,6,8,0};
    int i,j,t;
    printf("请依次输入 10 个面积，每输入一次换行：\n");
    for (i=0; i<=9; i++) scanf("%d", &a[i]);

    /// 方法 1 选择排序
    for (i=0; i<=8; i++) {
        for (j=i+1; j<=9; j++) {
            if (a[i] > a[j]) {
                t = a[i];
                a[i] = a[j];
                a[j] = t;
            }
        }
    }

    /// 方法 3 冒泡排序
    // for (j=0; j<=8; j++) {
    //     for (i=0; i<=8-j; i++) {
    //         if (a[i] > a[i+1]) {
    //             t = a[i];
    //             a[i] = a[i+1];
    //             a[i+1] = t;
    //         }
    //     }
    // }

    printf("排序后面积依次是：\n");
    for (i=0; i<=9; i++) printf("%d\t", a[i]);
    return 0;
}