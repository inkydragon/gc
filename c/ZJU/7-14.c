#include <stdio.h>

int main(int argc, char **argv) {
    int start, mm, min;
    scanf("%d %d", &start, &min);
    mm = (start/100)*60 + start%100;
    // printf("mm=%d\n", mm);
    mm += min;
    // printf("mm += min=%d\n", mm);
    printf("%d%02d\n", mm/60, mm%60);
    return 0;
    //< 1120 110
    //> 1310
    //< 1100 -120 
    //> 900
}
