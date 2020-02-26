#include <stdio.h>
#include <string.h>

#define MAXS 10

void Shift( char s[] );

void GetString( char s[] ) {
    scanf("%s", s);
}

int main()
{
    char s[MAXS];

    GetString(s);
    Shift(s);
    printf("%s\n", s);
	
    return 0; 
}

/* 你的代码将被嵌在这里 */
void Shift( char s[] ) {
    char a3[3];
    int len = strlen(s);
    strncpy(a3, s, 3);
    for (int i=0; i<len-3; i++) {
        *(s+i) = *(s+3+i);
    }
    strncpy(s+len-3, a3, 3);
    //< abcd
    //> bcda
}