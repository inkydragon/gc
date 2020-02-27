#include <stdio.h>

int main() {
    int n, i, j, k;

    scanf("%d", &n);
    for (i=1; i<=n; i++) {
        k=i;
        printf("%4d", i);
        for (j=n; j>i; j--) {
            k += j;
            printf("%4d", k);
        }
        putchar('\n');
    }
    return 0;
}
