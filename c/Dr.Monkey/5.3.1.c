// 5.3 函数的嵌套
#include <stdio.h>

int max2(int a, int b);
int max4(int a, int b, int c, int d);

int main()
{
    int a,b,c,d,max;
    printf("请输入4个数字：\n");
    scanf("%d,%d,%d,%d", &a,&b,&c,&d);
    // a=9,b=5,c=2,d=7;

    max = max4(a,b,c,d);
    printf("max=%d", max);
    return 0;
}

int max2(int a, int b) { return (a>b ? a : b); }

int max4(int a, int b, int c, int d) {
    return (
        max2(
            max2(a,b),
            max2(c,d)
        )
    );
}