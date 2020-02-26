#include <stdio.h>

int main()
{
    int n;

    scanf("%d", &n);
    if (n >= 90) {
        n = 'A';
    } else if (n >= 80) {
        n = 'B';
    } else if (n >= 70) {
        n = 'C';
    } else if (n >= 60) {
        n = 'D';
    } else {
        n = 'E';
    }
    printf("%c\n", n);
    return 0;
    //< 100
    //> A
}
