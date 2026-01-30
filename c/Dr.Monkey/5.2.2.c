// 5.2 调用无参函数
#include <stdio.h>

void sort(int a[], int n);

int main()
{
    int a[10];
    printf("请输入10个数字：\n");
    for (int i=0; i<=9; i++) {
        printf("请输入第%d个数字：", i+1);
        scanf("%d", &a[i]);
    }
    // int a[] = {9,5,4, 6,2,1, 0,3,8, 7};
    sort(a, 10);
    printf("排序后的数字为：\n");
    for (int i=0; i<=9; i++) printf("%d\t", a[i]);
    return 0;
}

void sort(int a[], int n) {
    int t;
    for (int i=0; i<n-1; i++) {
        for (int j=i+1; j<n; j++) {
            if (a[i]>a[j]) {
                t    = a[i];
                a[i] = a[j];
                a[j] =t;
            }
        }
    }
}