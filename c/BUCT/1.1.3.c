#include<stdio.h>

int main()
{
    float r,l;
    printf("r=");
    scanf("%f", &r);
    l = 2 * 3.14159 * r; // l = 2*pi*r = pi*D
    printf("L=%f\n", l);
    return 0;
    // > r =
    // < 1
    // > L = 6.283180
}