#include <stdio.h>

int main() {
    int i, n;
    float point, sum=0.0, max=0.0, min=10.0;

    scanf("%d", &n);
    i = n;
    while (i--) {
        scanf("%f", &point);
        i && getchar(); // 去掉空格
        sum += point;
        if (point > max) max = point;
        if (point < min) min = point;
    }
    // printf("sum=%.4f\n", sum);
    sum -= max + min;
    // printf("max=%.4f; min=%.4f, sum=%.4f\n", max, min, sum);
    printf("%.2f\n", sum/(n-2));
    return 0;
}
