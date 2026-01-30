// 4.4 输出字符数组
#include <stdio.h>

int main()
{
    char a[3][3] = {{' ','*',' '}, {'*',' ','*'}, {' ','*',' '}};

    for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j++) putchar(a[i][j]);
        putchar('\n');
    }
    //  * 
    // * *
    //  * 
    // 
    return 0;
}
