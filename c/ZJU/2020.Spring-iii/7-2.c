#include <stdio.h>
#define MAXN 10

typedef struct student{
    char id[6]; // 5+1
    char name[32];
    int  score;
} Stud;
typedef Stud* StudPtr;

StudPtr get_max_score(Stud stu[], int n) {
    StudPtr m = stu;
    int i, max_score = stu[0].score;

    for (i=0; i<n; i++) {
        if ( stu[i].score>max_score ) {
            max_score = stu[i].score;
            m = stu+i;
        }
    }

    return m;
}

int main() {
    Stud stu[MAXN];
    StudPtr ptr;
    int n, i, count, o,p,q;

    ptr = stu;
    scanf("%d\n", &n);
    for(i = 0; i < n; i++){
       scanf(
           "%s %s %d %d %d",
            stu[i].id,
            stu[i].name,
            &o, &p, &q
       );
       stu[i].score = o+p+q;
    }

    StudPtr s = get_max_score(ptr, n);
    printf("%s %s %d\n", s->name, s->id, s->score);
    return 0;
}