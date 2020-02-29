#include <stdio.h>
#define MAXN 10

typedef struct student{
    char id[6]; // 5+1
    char name[32];
    int  score;
} Stud;
typedef Stud* StudPtr;

void print_max_min_books(Stud stu[], int n, float avg) {
    for (int i=0; i<n; i++) {
        if ( stu[i].score<avg ){
            printf("%s %s\n", stu[i].name, stu[i].id);
        }
    }
}

int main() {
    Stud stu[MAXN];
    int n, i;
    float count=0, avg=0;

    scanf("%d\n", &n);
    for(i = 0; i < n; i++){
       scanf(
           "%s %s %d",
            stu[i].id,
            stu[i].name,
            &stu[i].score
       );
       count += stu[i].score;
    }
    avg = count / n;
    printf("%.2f\n", avg);
    print_max_min_books(stu, n, avg);
    return 0;
}