// 7.4  结构体变量与指针变量
#include <stdio.h>

struct student {
    int id;
    char name[30];
    char sex;
} a = {001, "Doctor", 'M'};

int main()
{
    struct student *p;
    p = &a;
    printf("学号：%d,姓名：%s,性别：%c",
            p->id, p->name, p->sex);
    //> 学号：1,姓名：Doctor,性别：M
    return 0;
}