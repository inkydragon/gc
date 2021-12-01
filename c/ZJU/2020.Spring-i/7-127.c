#include <stdio.h>

int main() {
    unsigned int n, sum=0;

    scanf("%u", &n);
    while ( n ) {
        sum += n % 10;  // 取最低位
        n /= 10;        // 左移一位
    }
    printf("%d\n", sum);
    return 0;
}
