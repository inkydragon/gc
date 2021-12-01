#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAXS 10

char *str_cat( char *s, char *t );

int main()
{
    char *p;
    char str1[MAXS+MAXS] = "abc";
    str1[MAXS+MAXS-1] = '\0';
    char str2[MAXS] = "def";
    
    // scanf("%s%s", str1, str2);
    p = str_cat(str1, str2);
    printf("%s\n%s\n", p, str1);

    return 0;
}

/* 你的代码将被嵌在这里 */


char *str_cat( char *s, char *t ) {
    int ls, lt;
    ls = strlen(s);
    lt = strlen(t);
    memcpy(s + ls, t, lt);
    return s;
}
