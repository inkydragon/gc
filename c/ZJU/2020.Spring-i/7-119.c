#include <stdio.h>

int main() {
    int n;
    scanf("%d", &n);
    (n%2==0) && n--;
    for (int i=1; i<n; i+=2) {
        printf("%d ", i);
    }
    printf("%d\n", n);
    return 0;
}
