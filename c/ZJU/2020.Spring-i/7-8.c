#include <stdio.h>

int main(int argc, char **argv) {
    int H;
    float sj;

    scanf("%d", &H);
    // sj = (H - 100) * 0.9 * 2
    sj = (H - 100) * 0.9 * 2;
    printf("%.1f\n", sj);
    return 0;
    //< 169
    //> 124.2
}
