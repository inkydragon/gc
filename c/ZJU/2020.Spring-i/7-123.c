#include <stdio.h>
#define PADDING 40

int main() {
    int h, i, pad;
    char c;

    scanf("%c", &c);
    // c = 'E';

    // 塔高
    h = c - 'A' + 1;
    for (i = 0; i < h; i++) {
        c = 'A' + i; // 本轮循环打印的字符

        // 左侧空格填充
        pad = PADDING - i; // 左侧字符 padding 导得位置
        while ( --pad ) putchar(' '); // padding

        putchar(c); // 输出左侧第一个字符

        // 输出第 2~h 层
        if ( 1<=i && i<=h-1 ) {
            pad = 2*i;
            while ( --pad ) {
                if ( i==h-1 ) {
                    putchar(c);
                } else {
                    putchar(' ');
                }
            }
            putchar(c); // 输出右侧最后一个字符
        } // 2+ 层输出 if end

        putchar('\n'); // 换行
    } // 塔高遍历 for end
    return 0;
//< E
//                                        A
//                                       B B
//                                      C   C
//                                     D     D
//                                    EEEEEEEEE
}
