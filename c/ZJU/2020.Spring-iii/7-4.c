#include <stdio.h>
#include <stdlib.h>

typedef struct book{
    char  name[32];
    double price;
} Book;
typedef Book* BookPtr;

void print_max_min_books(Book books[], int n) {
    BookPtr maxb=books, minb=books;
    int i;
    float min=books->price, max=books->price, price;

    for (i=0; i<n; i++) {
        price = books[i].price;
        if ( price>max ) {
            max = price;
            maxb = books+i;
        }
        if ( price<min ) {
            min = price;
            minb = books+i;
        }
    }

    printf("%.2lf, %s\n", maxb->price, maxb->name);
    printf("%.2lf, %s\n", minb->price, minb->name);
}

int main() {
    int n, i;

    scanf("%d\n", &n);
    BookPtr books = (BookPtr)malloc(sizeof(Book)*n);
    if (n > 0) {
        for(i = 0; i < n; i++){
            // scanf( "%[^\n]", books[i].name  );
            gets(books[i].name);
            scanf("%lf",&books[i].price); getchar();
        }
        print_max_min_books(books, n);
    }
    return 0;
}