#include <stdio.h>
#include <stdlib.h>

#define JUDGE(x, c, s) {\
    FILE *fp = fopen(argv[1], "a");\
    if ( fp ) {\
        fprintf(fp, "%s\t", s);\
        if ( x ) {\
            credit += c;\
            fprintf(fp, "PASS %d %d\n", c, credit);\
        } else {\
            fprintf(fp, "FAIL 0\n");\
        }\
        fclose(fp);\
    }\
}

int main(int argc, char *argv[])
{
    // if ( argc != 2 ) {
    //     exit(-1);
    // }

    // FILE *fp = fopen(argv[1], "w");
    // if ( !fp ) {
    //     exit(-1);
    // }
    // fclose(fp);

    // int credit=0;

    FILE *fp;
    fp = fopen("in.txt", "r");
    if ( !fp ) {
        exit(-1);
    }
    int a,b;
    fscanf(fp, "%d %d", &a, &b);
    fclose(fp);

    fp = fopen("out.txt", "r");
    if ( !fp ) {
        exit(-1);
    }
    int x;
    fscanf(fp, "%d", &x);
    fclose(fp);

    // JUDGE(a+b==x, 10, "file");
    if (a + b == x) {
        printf("PASS!\n");
        printf("a+b==x: %d+%d=%d!\n", a,b,x);
    } else {
        printf("FAIL!\n");
        printf("a+b==x: %d+%d!=%d!\n", a, b, x);
    }
    // fp = fopen(argv[1], "a");
    // if ( fp ) {
    //     fprintf(fp, "%d\n", credit);
    //     fclose(fp);
    // }
    return 0;
}