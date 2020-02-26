#include <stdio.h>

int gcd(int a, int b)
{
    if (a % b == 0)
    {
        return b;
    }
    else
    { // a < b
        return gcd(b, a % b);
    }
}

int main()
{
    int a, b;
    scanf("%d %d", &a, &b);

    printf("%d %d\n", gcd(a, b), a * b / gcd(a, b));
    return 0;
}
