// 2.3 <expr1> ? <expr2> : <expr3> 三元表达式
#include <stdio.h>

int main()
{
    char ch;
    scanf("%c", &ch);
    /// 方法 2
    ch = ('A'<=ch && ch<='Z') ? (ch+32) : ch
    /// 方法 3
    // ch += ('A'<=ch && ch<='Z') ? 32 : 0
    /// 方法 1
    // if ( 'A'<=ch && ch<='Z' ) {
    //     ch += 32;
    // }
    printf("%c", ch);
    // < H
    // > h
    // < f
    // > f
    return 0;
}