#include "array.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "array.h"

// #define JUDGE(x, c, s) {\
//     FILE *fp = fopen(argv[1], "a");\
//     if ( fp ) {\
//         fprintf(fp, "%s\t", s);\
//         if ( x ) {\
//             credit += c;\
//             fprintf(fp, "PASS %d %d\n", c, credit);\
//         } else {\
//             fprintf(fp, "FAIL 0\n");\
//         }\
//         fclose(fp);\
//     }\
// }

#define JUDGE(x, c, s)              \
    {                               \
        printf("%s\t", s);          \
        if (x)                      \
        {                           \
            printf("PASS %d\n", c); \
        }                           \
        else                        \
        {                           \
            printf("FAIL 0\n");     \
        }                           \
    }

// define JUDGE(x, c, s) END


int main(int argc, char *argv[])
{
    // if ( argc != 2 ) {
    //     exit(-1);
    // }
    srand(time(0));
    int ranloc = BLOCK_SIZE-1-rand()%20;
    int ranv = rand() % 65536;
    // int credit = 0;
    
    // FILE *fp = fopen(argv[1], "w");
    // if ( !fp ) {
    //     exit(-1);
    // }
    // fclose(fp);
    
    Array a = array_create();
    JUDGE(array_size(&a) == BLOCK_SIZE, 1, "create\t");

    array_set(&a, BLOCK_SIZE-1, ranv);
    array_set(&a, ranloc, -11);
    JUDGE(array_get(&a, ranloc) ==  -11, 1, "get/set random");
    JUDGE(array_get(&a, BLOCK_SIZE-1) ==  ranv, 1, "get/set last");

    array_inflate(&a);
    array_inflate(&a);
    JUDGE(array_size(&a) == BLOCK_SIZE*3, 1, "inflate size");
    JUDGE(array_get(&a, BLOCK_SIZE-1) == ranv && array_get(&a, ranloc) ==  -11, 1, "inflate content");
    array_set(&a, array_size(&a)-1, ranv*2);
    JUDGE(array_get(&a, array_size(&a)-1) == ranv*2, 1, "inflate memory");

    Array c = array_clone(&a);
    JUDGE(array_size(&c) == BLOCK_SIZE*3, 1, "clone size");
    JUDGE(array_get(&c, array_size(&c)-1) == ranv*2 && array_get(&c, ranloc) ==  -11, 1, "clone content");
    JUDGE(a.content != c.content, 1, "clone memory");

    array_free(&c);
    array_free(&a);
    JUDGE(array_size(&a) == 0, 1, "free\t");
    
    // fp = fopen(argv[1], "a");
    // if ( fp ) {
    //     fprintf(fp, "%d\n", credit);
    //     fclose(fp);
    // }
}