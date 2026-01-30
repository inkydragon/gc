// 4.4 输出字符数组
#include <stdio.h>

int main()
{
    char a[] = "I am Bob.";
    char b[] = {'I',' ','a','m',' ','B','o','b','.'};

    for (int i=0; i<=8; i++) putchar(a[i]);
    putchar('\n');
    for (int i=0; i<=8; i++) putchar(b[i]);
    // I am Bob.
    // I am Bob.
    return 0;
}