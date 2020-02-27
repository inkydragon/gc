#include <stdio.h>

int main() {
    int n, times=0;

    scanf("%d", &n);
    while ( n!=1 ) {
        if ( n%2==0 ) {
            // 偶数
            n = n / 2;
        } else {
            // 奇数
            n = 3 * n + 1;
        }
        times++;
        // printf("[%d] %d\n", times, n); // DBG1
        // printf("%d->", times, n); // DBG2
    }
    // printf("1 [%d] times.\n", times); // DBG2
    printf("%d\n", times);
    return 0;
}
