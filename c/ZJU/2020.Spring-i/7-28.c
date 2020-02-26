#include <stdio.h>

int main()
{
    int n, len=0, sum=0;
    scanf("%d", &n);
    while ( n ) {
        len++;
        sum += n % 10;
        n /= 10;
    }
    printf("%d %d\n", len ,sum);
    return 0;
}
