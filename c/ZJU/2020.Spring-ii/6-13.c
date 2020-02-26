#include <stdio.h>

char *getmonth( int n );

int main()
{
    int n;
    char *s;

    scanf("%d", &n);
    s = getmonth(n);
    if ( s==NULL ) printf("wrong input!\n");
    else printf("%s\n", s);

    return 0;
}

/* 你的代码将被嵌在这里 */
char *getmonth( int n ) {
    char *month[] = { "NULL",
        "January",  "February", "March",    "April",
        "May",      "June",     "July",     "August",
        "September","October",  "November", "December"
    };
    
    if (1<=n && n<=12) {
        return month[n];
    } else {
        return NULL;
    }
}
