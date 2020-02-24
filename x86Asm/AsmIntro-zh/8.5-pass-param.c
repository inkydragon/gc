#include <stdio.h>

int sum(int n, int a, ...) {
    int s = 0;
    int *p = &a;
    for(int i = 0; i < n; i++) {
        s += p[i];
    }
    return s;
}

int main() {
    int s=0;
    s = sum(10, 1,2,3,4,5, 1,2,3,4,5);
    printf("%d\n", s);
    return 0;
}
// 必须在 x86 下编译