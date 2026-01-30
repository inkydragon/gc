// 3.1 while 循环
#include <stdio.h>

int main()
{
    int n=1,product=1,a=2;
    while(n <= 50) {
        n += 1;
        product *= a; // 结果溢出
        a += 2;
    }
    printf("product=%d", product);
    //> product=0
    return 0;
}