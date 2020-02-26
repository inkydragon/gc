#include <stdio.h>

int main(int argc, char **argv) {
    int a,b;
    
    scanf("%d %d", &a,&b);
    printf("%d + %d = %d\n", a, b, a+b);
    printf("%d - %d = %d\n", a, b, a-b);
    printf("%d * %d = %d\n", a, b, a*b);
    a%b==0 ? printf("%d / %d = %d\n", a, b, a/b)
           : printf("%d / %d = %.2f\n", a, b, a*1.0/b);
    return 0;
    //< 8 3
    //> 8 + 3 = 11
    //> 8 - 3 = 5
    //> 8 * 3 = 24
    //> 8 / 3 = 2.67

    //< 9 3
    //> 9 + 3 = 12
    //> 9 - 3 = 6
    //> 9 * 3 = 27
    //> 9 / 3 = 3
}
