#include <stdio.h>

int main(int argc, char **argv) {
    int yyyy, mm, dd;
    scanf("%d-%d-%d", &mm, &dd, &yyyy);
    printf("%4d-%02d-%02d\n", yyyy, mm, dd);
    return 0;
    //< 03-15-2017
    //> 2017-03-15
    //< 01-02-1234
    //> 1234-01-02
}
