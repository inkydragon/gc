#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    FILE *fp;
    int a, b;

    // read input
    fp = fopen("in.txt", "r");
    if (!fp) exit(-1);
    fscanf(fp, "%d %d", &a, &b);
    fclose(fp);

    // write output
    fp = fopen("out.txt", "w");
    if (!fp) exit(-1);
    fprintf(fp, "%d", a + b);
    fclose(fp);

    return 0;
}