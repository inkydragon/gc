// 6.10 指针与函数
#include <stdio.h>

int max(int x, int y);
int min(int x, int y);

int main()
{
    int a, b, choose, (*p)(int,int);
    p = max;
    // a=10; b=20; choose=1;
    printf("请输入2个数字：");
    scanf("%d,%d", &a,&b);
    printf("请输入1或2：");
    scanf("%d", &choose);

    /// 方法 2 改成用指针指向函数
    choose==1 ? 
        p = max : 
        choose==2 ? 
            p = min : 
            printf("choose 输入有误！");
    printf("结果为：%d", (*p)(a, b));
    /// 方法 1
    // choose==1 ? 
    //     printf("结果为：%d", max(a, b)) : 
    //     choose==2 ? 
    //         printf("结果为：%d", min(a, b)) : 
    //         printf("choose 输入有误！");

    // 输入2个数字：1,9
    // 请输入1或2：1
    // 结果为：9
    // 请输入2个数字：1,9
    // 请输入1或2：2
    // 结果为：1
    return 0;
}

int max(int x, int y) {
    return (x>y ? x : y);
}
int min(int x, int y) {
    return (x<y ? x : y);
}