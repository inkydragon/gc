#include <stdio.h>

int main(int argc, char **argv) {
    int cm;
    float foot, inch;

    scanf("%d", &cm);
    // (foot+inch/12)×0.3048
    foot = cm /100.0 /0.3048;
    inch = (foot - (int)foot) *12;
    // printf("err=%f\n", ((foot+inch/12.0)*0.3048) - (cm/100.0));
    // printf("%f %f\n", foot, inch);
    printf("%d %d\n", (int)foot, (int)inch);
    return 0;
    //< 170
    //> 5 6
}
