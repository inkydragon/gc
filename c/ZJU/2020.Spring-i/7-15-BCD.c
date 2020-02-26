#include <stdio.h>

int main()
{
    int n, bcd;

    scanf("%d", &n);
    bcd = n / 16 * 10 + n % 16;
    printf("%d\n", bcd);
    return 0;
    //< 0
    //> 0
    //< 18
    //> 12
    //< 153
    //> 99
}