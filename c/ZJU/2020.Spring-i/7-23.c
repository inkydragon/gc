#include <stdio.h>

int main()
{
    int n;

    scanf("%d", &n);
    printf("%.2f\n", n < 15 ? 4 * n / 3.0 : 2.5 * n - 17.5);
    return 0;
}
