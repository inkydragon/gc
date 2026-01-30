// 4.1 一维数组
#include <stdio.h>

int main()
{
    // 显示初始化数组时可以不写明数组大小 a[10]
    int i, a[] = {0,1,2,3,4,5,6,7,8,9};
    for (i=9; i>=0; i--) {
        printf("%d\t", a[i]);
    }
    //> 9	8	7	6	5	4	3	2	1	0	
    return 0;
}