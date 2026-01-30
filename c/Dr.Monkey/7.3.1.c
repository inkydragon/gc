// 7.3 使用结构体变量做函数参数 
#include <stdio.h>

struct student {
    int id;
    char name[30];
    float grade1;
    float grade2;
};

struct student max(struct student a[]);

int main()
{
    struct student leader, stud[5];
    // struct student leader, stud[5] =
    //     {
    //         {001, "Doctor", 99, 100},
    //         {002, "ProJeKT RED", 59, 60},
    //         {003, "Amiya",  90, 95},
    //         {004, "Firewatch", 90, 90},
    //         {005, "Ifrit", 59, 50}
    //     };
    
    for (int i=0; i<5; i++) {
        printf("请输入第%d个学生的学号、成绩x2和姓名：",i+1);
        scanf("%d,%f,%f,%s", &stud[i].id, &stud[i].grade1, &stud[i].grade2, &stud[i].name);
    }

    leader = max(stud);
    printf("平均分最高学生信息如下：\n");
    printf("学号：%d,姓名：%s,成绩：%f,%f\n",
            leader.id, leader.name, leader.grade1, leader.grade2);
    // 请输入第1个学生的学号、成绩x2和姓名：001,99,100,doctor
    // 请输入第2个学生的学号、成绩x2和姓名：002,59,60,red
    // 请输入第3个学生的学号、成绩x2和姓名：003,90,95,amiya
    // 请输入第4个学生的学号、成绩x2和姓名：004,90,90,firewatch
    // 请输入第5个学生的学号、成绩x2和姓名：005,59,50,ifrit
    // 平均分最高学生信息如下：
    // 学号：1,姓名：doctor,成绩：99.000000,100.000000
    return 0;
}

struct student max(struct student a[]) {
    float average[5];
    int maxid=0;
    for (int i=0; i<5; i++) 
        average[i]=(a[i].grade1+a[i].grade2)/2;
    for (int i=0; i<5; i++) 
        if (average[maxid] < average[i]) maxid=i;
    return a[maxid];
}