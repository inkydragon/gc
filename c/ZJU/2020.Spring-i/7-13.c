#include <stdio.h>

int main(int argc, char **argv) {
    int D;
    scanf("%d", &D);
    printf("%d\n", (D+1) % 7 + 1);
    return 0;
    //< 4
    //> 6
    //< 5
    //> 7
    //< 6
    //> 1
}
