// 7.2 结构体数组
#include <stdio.h>

struct student {
    int id;
    char name[30];
    float grade;
} temp, stud[3] = 
{
    {001, "Doctor", 99},
    {002, "ProJeKT RED", 59},
    {003, "Amiya",  90}
};

int main()
{
    for (int i=0; i<2; i++) {
        for (int j=i+1; j<3; j++) {
            if (stud[j].grade > stud[i].grade) {
                temp = stud[i];
                stud[i] = stud[j];
                stud[j] =temp;
            }
        }
    }

    printf("排序后各学生信息如下：\n");
    for (int i=0; i<3; i++) {
        printf("学号：%d,姓名：%s,成绩：%f\n",
                stud[i].id, stud[i].name, stud[i].grade);
    }
    // 序后各学生信息如下：
    // 学号：1,姓名：Doctor,成绩：99.000000
    // 学号：3,姓名：Amiya,成绩：90.000000
    // 学号：2,姓名：ProJeKT RED,59.000000
    return 0;
}