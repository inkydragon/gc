#include <stdio.h>

double ntsqrt(int x, double eps);

int main()
{
  int x;
  double eps;

  scanf("%d %lf", &x, &eps);

  printf("%.4f", ntsqrt(x, eps));

  return 0;
}

/* 请在这里填写答案 */
double ntsqrt(int x, double eps) {
    double r = 1.0;
    while ( r*r-x > eps || x-r*r > eps) {
        r = (r + x/r) / 2.0;
    }
    return r;
}
