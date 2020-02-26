#include <stdio.h>
#include <math.h>

int main() {
    float len = 0, m = 0;
    int min = 0;

    scanf("%f %d", &len, &min);

    // 起步 10r
    m = 10;

    if (3 <= len && len <= 10) {
        // 3~10: 2r/km
        m += (len-3) * 2;
    } else if (len > 10){
        m += (10-3) * 2;
        // len > 10
        m += (len-10) * 3;
    }

    if (min >= 5) {
        m += min /5 *2;
    }

    printf("%.0f\n", round(m));
    return 0;
}
