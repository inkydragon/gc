// 5.4 递归
#include <stdio.h>

int factorial(int n);

int main()
{
    int n;
    printf("n=");
    scanf("%d", &n);
    printf("%d!=%d", n,factorial(n));
    // n=4
    // 4!=24
    return 0;
}

int factorial(int n) {
    if (n < 0) {
        printf("输入有误，n 不能为负数！\n");
        return -1;
    }
    return ( (n==0||n==1) ? 1 : factorial(n-1)*n );
}