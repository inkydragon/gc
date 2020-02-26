#include <stdio.h>

int main(int argc, char **argv)
{
    int F;
    float C;

    scanf("%d", &F);
    // C=5×(F−32)/9
    C = 5 * (F - 32) / 9.0;
    // printf("%f\n", C);
    printf("Celsius = %d\n", (int)C);
    return 0;
    //< 150
    //> Celsius = 65
}
