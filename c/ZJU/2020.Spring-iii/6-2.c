#include <stdio.h>
#define MAXN 10

struct student{
    int num;
    char name[20];
    int score;
    char grade;
};

int set_grade( struct student *p, int n );

int main()
{   struct student stu[MAXN], *ptr;
    int n, i, count;

    ptr = stu;
    scanf("%d\n", &n);
    for(i = 0; i < n; i++){
       scanf("%d%s%d", &stu[i].num, stu[i].name, &stu[i].score);
    } 
   count = set_grade(ptr, n);
   printf("The count for failed (<60): %d\n", count);
   printf("The grades:\n"); 
   for(i = 0; i < n; i++)
       printf("%d %s %c\n", stu[i].num, stu[i].name, stu[i].grade);
    return 0;
}

/* 你的代码将被嵌在这里 */
char get_grade(int s) {
    char g;

    if (85<=s && s<=100) {
        g = 'A';
    } else if (70<=s && s<=84) {
        g = 'B';
    } else if (60<=s && s<=69) {
        g = 'C';
    } else if ( 0<=s && s<=59) {
        g = 'D';
    } else { // not in [0, 100]
        g = '?';
        printf("[error] grade (%d) not in [0, 100]", s);
    }
    return g;
}

int set_grade(struct student *p, int n) {
    int count=0;

    for (int i=0; i<n; i++) {
        p[i].grade = get_grade(p[i].score);
        if (p[i].score < 60) count++;
    }

    return count;
}