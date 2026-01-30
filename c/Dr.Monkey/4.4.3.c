// 4.4 输出字符数组
#include <stdio.h>

int main()
{
    char a[] = "I am Bob.";
    char b[] = {'I',' ','a','m',' ','B','o','b','.','\0'};

    puts(a);
    puts(b);
    // I am Bob.
    // I am Bob.
    // 
    return 0;
}