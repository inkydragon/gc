#include <stdio.h>

int main() {
    int hh1, mm1, hh2, mm2, diff;

    scanf("%d:%d %d:%d", &hh1,&mm1, &hh2,&mm2);
    diff = (hh2*60+mm2) - (hh1*60+mm1);
    printf("%d %d", diff/60,diff%60);
    return 0;
}
