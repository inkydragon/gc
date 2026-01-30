// 1.6 putchar(), getchar()
#include <stdio.h>

int main()
{
    char a,b,c;
    a = getchar();
    b = getchar();
    c = getchar();
    a += 32;
    b += 32;
    c += 32;
    putchar(a);
    putchar(b);
    putchar(c);
    putchar('\n');
    // < GKD
    // > gkd
    return 0;
}