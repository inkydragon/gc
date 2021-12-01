#include <stdio.h>

int main()
{
    int m1 = 1, m2 = 0, n = 0, month, N;
    scanf("%d", &month);

    while ( month-- )
    {
        n = n + m2;
        m2 = m1;
        m1 = n;
        // printf("[%d] m1=%d, m2=%d, n=%d\n", month,m1,m2,n);
    }
    printf("%d\n", (m1+m2+n));
    return 0;
}