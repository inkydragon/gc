#include <stdio.h>

int main(int argc, char **argv) {
    int a,b,c,d;
    
    scanf("%d %d %d %d", &a,&b,&c,&d);
    printf("Sum = %d; Average = %.1f\n", a+b+c+d, (a+b+c+d)/4.0);
    return 0;
    //< 1 2 3 4
    //> Sum = 10; Average = 2.5
}
