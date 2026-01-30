// 2.1 if 语句
#include <stdio.h>

int main()
{
    int a;
    scanf("%d", &a);
    if (a >= 60) {
        printf("及格。\n");
    } else {
        printf("不及格!");
    }
    // < 60
    // > 及格。
    return 0;
}