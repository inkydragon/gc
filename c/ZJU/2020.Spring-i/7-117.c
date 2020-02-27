#include <stdio.h>

int main() {
    int count=0;
    char c;

    while ( (c=getchar()) ) {
        if (c=='.') {
            if (count) {
                printf("%d\n", count);
            } else {
                printf("\b\n");
            }
            break;
        }
        if (c==' ') {
            count && printf("%d ", count);
            count = 0;
        } else {
            count++;
        }
    }
    return 0;
    // It's great to see you here.
    //     It's great to see you here.   //
    // It's   great   to   see you here   .
    //> 4 5 2 3 3 4
}
