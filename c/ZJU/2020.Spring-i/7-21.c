#include <stdio.h>

int main()
{
    int v;

    scanf("%d", &v);
    printf("Speed: %d - %s\n", v, (v > 60 ? "Speeding" : "OK"));
    // v > 60 ? printf("Speed: %d - %s\n", v, "Speeding")
    //        : printf("Speed: %d - %s\n", v, "OK");
    return 0;
}
