#include <stdio.h>
#include <math.h>

double round0(double n) {
    if (fabs(n) >= 0.05) {
        return round(n * 10) / 10.0;
    } else { // abs(n) < 0.05
        return 0.0;
    }
}

int main() {
    double a, b, c, d;
    // printf("%lf\n", fabs((double)-0.05));
    // printf("%lf\n", fabs((double)0.05));
    // printf("%lf\n", round0((double)-0.05));
    // printf("%lf\n", round0((double)0.05));
    // printf("%d\n", fabs((double)0.05)==fabs((double)-0.05));

    // while (1) {
    scanf("%lf %lf %lf %lf", &a, &b, &c, &d);
    printf("(%.1lf, %.1lf)\n", round0(a + c), round0(b + d));
    // }
    return 0;
}
