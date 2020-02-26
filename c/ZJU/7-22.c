#include <stdio.h>

int main() {
    int a,b,c;

    scanf("%d %d %d", &a,&b,&c);
    b==c ? putchar('A') :
    a==c ? putchar('B') :
           putchar('C');
    return 0;
}
