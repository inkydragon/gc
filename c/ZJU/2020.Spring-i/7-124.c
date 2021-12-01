#include <stdio.h>

int main() {
    int n, i, j, k=0;

    scanf("%d", &n);
    for (i = n; i>0; i--) {
        for (j = 1; j <= i; j++) {
            printf("%4d", j+k);
        }
        putchar('\n');
        k += --j;
    }
    return 0;
}
