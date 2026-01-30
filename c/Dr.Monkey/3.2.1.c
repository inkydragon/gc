// 3.2 while 循环
#include <stdio.h>

int main()
{
    float total_time=0, time;
    int n=0;
    while(total_time < 300) {
        printf("输入第%d只猴的表演时间（min）\n", n+1);
        scanf("%f", &time);
        total_time += time;
        n += 1;
    }
    printf("共看了%d只猴", n);
    return 0;
}