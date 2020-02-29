#include <stdio.h>
typedef struct pep{
    char  name[32];
    float price;
} Work;
typedef Work* WorkPtr;

int main() {
    Work *works;
    int n, i;
    float j,k,l;

    scanf("%d\n", &n);
    works = (WorkPtr)malloc(sizeof(Work)*n);
    for(i = 0; i < n; i++){
        scanf("%s%f%f%f", works[i].name, &j,&k,&l);
        works[i].price = j+k-l;
        // getchar(); // \n
    }
    for(i = 0; i < n; i++){
        printf("%s %.2f\n", works[i].name, works[i].price);
    }
    return 0;
}