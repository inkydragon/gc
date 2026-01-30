// 3.3 break 终止循环
#include <stdio.h>

int main()
{
    float total_time=0, time;
    int n=0;
    /// 方法 2
    while(total_time<300 && n<100) {
        n += 1;
        printf("输入第%d只猴的表演时间（min）\n", n+1);
        scanf("%f", &time);
        total_time += time;
    }

    /// 方法 1
    // while(total_time < 300) {
    //     printf("输入第%d只猴的表演时间（min）\n", n+1);
    //     scanf("%f", &time);
    //     total_time += time;
    //     n += 1;
    //     if (n>=100) break;
    // }
    printf("共看了%d只猴", n);
    return 0;
}