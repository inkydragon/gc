// 1.4 用 printf 输出数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    char a='B', b='O', c='Y';
    a = a + 32; // 'b'
    b = b + 32; // 'o'
    c = c + 32; // 'y'
    printf("小写字母：%c,%c,%c\n", a,b,c);

    // 另一种写法
    a -= 32; // 等价于 `a = a - 32;`
    b -= 32;
    c -= 32;
    printf("原来的字母：%c,%c,%c", a,b,c);
    return 0;
    // 小写字母：b,o,y
    //原来的字母：B,O,Y
}