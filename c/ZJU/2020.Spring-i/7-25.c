#include <stdio.h>

int main()
{
    int n, sum = 0;
    while (scanf("%d", &n) && n > 0 && (getchar() == ' '))
    {
        n % 2 != 0 && (sum += n);
    }
    printf("%d\n", sum);
    return 0;
}
