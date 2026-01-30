// 4.5 输入字符数组
#include <stdio.h>

int main()
{
    char c[81];
    int words=1;
    gets(c);
    // char c[] = "I am Bob.";
    // char c[] = " I am Bob.";
    // char c[] = "I am Bob. ";

    if (c[0]==' ') words=0;
    for (int i=0; c[i]!='\0'; i++) {
        if (c[i]==' '&&c[i+1]!=' '&&c[i+1]!='\0') words++;
    }
    printf("Total %d words.", words);
    // < I am Bob.
    // > Total 3 words.
    return 0;
}