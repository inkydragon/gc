// 6.9 指针与字符串
#include <stdio.h>

void copy1(char old[], char new[]);
void copy2(char  *old, char  *new);

int main() //  指针变量与字符串相关函数
{
    char *p,*q, b[32], a[] = "I am Bob.";
    p = &a[0];
    q = &b[0];

    copy2(p,q); // 方法 3 形参是指针变量，实参是指针变量
    // copy2(a,b); // 方法 2 形参是指针变量，实参是数组名
    // copy1(a,b); // 方法 1 形参是指针变量，实参是数组名

    printf("字符串b为：");
    puts(b);
    //> 字符串b为：I am Bob.
    return 0;
}

void copy1(char old[], char new[]) {
    int i=0;
    for ( ; old[i]!='\0'; i++) new[i]=old[i];
    new[i+1] = '\0';
}
void copy2(char *old, char *new) {
    int i=0;
    for ( ; *(old+i)!='\0'; i++) *(new+i)=*(old+i);
    *(new+i+1) = '\0';
}