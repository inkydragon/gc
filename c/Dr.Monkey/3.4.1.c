// 3.4 continue 继续循环
#include <stdio.h>

int main()
{
    int n=99;
    while(n < 300) {
        n += 1;
        if (n%4==0) continue;
        printf("%d\t", n);
    }
    return 0;
}