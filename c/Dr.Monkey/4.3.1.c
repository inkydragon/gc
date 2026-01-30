// 4.3 字符数组
#include <stdio.h>

int main()
{
    // 字符数组的多种表示方法
    char c[] = "I am Bob.";
    char a[] = {'I',' ','a','m',' ','B','o','b','.'};
    char b[9];
    b[0]='I'; b[1]=' '; b[2]='a'; 
    b[3]='m'; b[4]=' '; b[5]='B'; 
    b[6]='o'; b[7]='b'; b[8]='.'; 

    for (int i=0; i<=8; i++) {
        if (a[i]!=b[i]) {
            printf("a[%d](%c) != b[%d](%c)\n", i,a[i],i,b[i]);
            printf("a[], b[] 不相等。");
            return 0;
        }
    }
    for (int i=0; i<=8; i++) {
        if (a[i]!=c[i]) {
            printf("a[%d](%c) != c[%d](%c)\n", i,a[i],i,c[i]);
            printf("a[], c[] 不相等。");
            return 0;
        }
    }
    printf("a[], b[], c[] 相等。");
    //> a[], b[], c[] 相等。
    return 0;
}