#include <stdio.h>

int main(int argc, char **argv)
{
    char *c = "I Love GPLT";
    for (; *c != '\0'; c++)
    {
        putchar(*c);
        putchar('\n');
    }
    return 0;
    // I
    //
    // L
    // o
    // v
    // e
    //
    // G
    // P
    // L
    // T
}
