#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXS 10

char *match( char *s, char ch1, char ch2 );

int main()
{
    char str[MAXS], ch_start, ch_end, *p;
    scanf("%s\n", str);
    scanf("%c %c", &ch_start, &ch_end);
    p = match(str, ch_start, ch_end);
    printf("%s\n", p);

    return 0;
}

/* 你的代码将被嵌在这里 */
char *match( char *s, char ch1, char ch2 ) {
    int len = strlen(s);

    char *pc1 = memchr(s, ch1, len);
    char *p = pc1;
    char *pc2 = memchr(s, ch2, len);

    if ( pc1 ) {
        if ( pc2 == NULL ) {
            printf("%s", pc1);
        } else {
            while ( pc1 != (pc2+1) ) {
                putchar(*pc1++);
            }
        }
    } else {
        return &"\n";
    }

    putchar('\n');
    return p;
}
