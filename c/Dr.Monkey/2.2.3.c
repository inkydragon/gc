// 2.2 常见 if 语句用法
#include <stdio.h>

int main()
{
    char ch;
    scanf("%c", &ch);
    if ( 'A'<=ch && ch<='Z' ) {
        ch += 32;
    }
    printf("%c", ch);
    // < H
    // > h
    // < f
    // > f
    return 0;
}