// 5.4 递归
#include <stdio.h>

int age(int n);

int main()
{
    printf("第五个学生的年龄为：%d", age(5));
    //> 第五个学生的年龄为：18
    return 0;
}

int age(int n) {
    return ( (n==1) ? 10 : (age(n-1)+2) );
}