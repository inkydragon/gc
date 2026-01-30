// 1.7 数学运算(e^x, log, ...)
#include <stdio.h>
#include <math.h>

int main()
{
    // p = (1+r)^n
    double r,n,p;
    r = -0.1;
    n = 10;
    p = pow(1+r, n);

    printf("p=(1+r)^n=%f", p);
    //> p=(1+r)^n=0.348678
    return 0;
}