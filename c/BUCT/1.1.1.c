#include<stdio.h>

int sum2(int x, int y)
{
    return x+y;
}

int main() 
{
    int a,b,c;
    scanf("%d, %d", &a, &b);
    c = sum2(a,b);
    printf("a+b=%d\n", c);
    return 0;
    // < 1, 2
    // > a+b=3
}