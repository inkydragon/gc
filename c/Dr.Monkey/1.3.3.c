// 3.1 数据类型(int, float, double, char)
#include <stdio.h>

int main()
{
    // 输出字符
    char a='B', b='O', c='Y';
    // 英文字符在 ASCII 码下，大小写字母相差 32
    a = a + 32; // 'b'
    b = b + 32; // 'o'
    c = c + 32; // 'y'

    // 另一种写法
    a -= 32; // 等价于 `a = a - 32;`
    b -= 32;
    c -= 32;
    // `x*=y+8;` => `x=x*(y+8);`
    // `z%=3;`   => `z=z%3;`
    return 0;
}