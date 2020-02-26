#include <stdio.h>

int main()
{
    int n;

    scanf("%d", &n);
    printf("sign(%d) = ", n);
    if (n>0) {
        n=1;
    } else if (n<0) {
        n=-1;
    }
    printf("%d\n", n);
    return 0;
    //< 10
    //> sign(10) = 1
    //< 0
    //> sign(0) = 0
    //< -5
    //> sign(-5) = -1
}
