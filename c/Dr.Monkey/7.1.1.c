// 7.1 定义结构体
#include <stdio.h>

struct student {
    int id;
    char name[30];
    char sex;
    char address[60];
} a = {001, "woclass", 'M', "Hubei, China"};

int main()
{
    printf("学号：%d\n姓名：%s\n性别：%c\n住址：%s",
        a.id, a.name, a.sex, a.address);
    // 学号：1
    // 姓名：woclass
    // 性别：M
    // 住址：Hubei, China
    return 0;
}