#include <stdio.h>

int main()
{
    int x=12, g,s;
    g = x % 10;
    s = x / 10;
    printf("x=%d\n", x);
    printf("g=%d\n", g);
    printf("s=%d\n",s);
    return 0;
    // x=12
    // g=2
    // s=1
}