// 7.2 结构体数组
#include <stdio.h>

struct student {
    int id;
    char name[30];
    float grade;
} a, b;

int main()
{
    printf("请输入第一个学生的学号、成绩和姓名：");
    // scanf("%d,%s,%f", &a.id, a.name, &a.grade);
    /// 姓名最好放在最后，不然会把成绩一起读入
    scanf("%d,%f,%s", &a.id, &a.grade, a.name);
    printf("请输入第二个学生的学号、成绩和姓名：");
    // scanf("%d,%s,%f", &b.id, b.name, &b.grade);
    scanf("%d,%f,%s", &b.id, &b.grade, b.name);

    printf("成绩较高者信息如下：\n");
    if (a.grade > b.grade) {
        printf("学号：%d,姓名：%s,成绩：%f\n",
            a.id, a.name, a.grade);
    } else if (a.grade < b.grade) {
        printf("学号：%d,姓名：%s,成绩：%f\n",
            b.id, b.name, b.grade);
    } else { // a.grade == b.grade
        printf("学号：%d,姓名：%s,成绩：%f\n",
            a.id, a.name, a.grade);
        printf("学号：%d,姓名：%s,成绩：%f\n",
            b.id, b.name, b.grade);
    }
    // 请输入第一个学生的学号、成绩和姓名：1,60,woclass
    // 请输入第二个学生的学号、成绩和姓名：2,90,???
    // 成绩较高者信息如下：
    // 学号：2,姓名：???,成绩：90.000000
    return 0;
}