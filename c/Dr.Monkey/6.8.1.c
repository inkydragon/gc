// 6.8 指针与字符串
#include <stdio.h>

int main() 
{
    char *p,*q, b[32], a[] = "I am Bob.";
    p = &a[0];
    q = &b[0];
    /// 方法 2 指针
    for (int i=0; *(p+i)!='\0'; i++) {
        *(q+i) = *(p+i);
        *(q+i+1) = '\0';
    }
    /// 方法 1 常规方法
    // for (int i=0; a[i]!='\0'; i++) b[i]=a[i], b[i+1]='\0';

    printf("字符串b为：");
    puts(b);
    //> 字符串b为：I am Bob.
    return 0;
}
