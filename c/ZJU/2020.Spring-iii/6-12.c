#include <stdio.h>
#include <stdlib.h>

typedef int ElementType;
typedef struct Node *PtrToNode;
struct Node {
    ElementType Data;
    PtrToNode   Next;
};
typedef PtrToNode List;

List Read(); /* 细节在此不表 */
void Print( List L ); /* 细节在此不表 */

List Insert( List L, ElementType X );

int main()
{
    List L;
    ElementType X;
    L = Read();
    scanf("%d", &X);
    L = Insert(L, X);
    Print(L);
    return 0;
}

/* 你的代码将被嵌在这里 */
List Insert( List L, ElementType X ) {
    List node = (List)malloc(sizeof(struct Node));
    List p = L, next = L->Next;
    
    node->Data = X;
    node->Next = NULL;

    if (next==NULL) {
        L->Next = node;
    }else if ( X < next->Data ) { // 放在头部
        L->Next = node;
        node->Next = next;
    } else { // X > L->Data
        while ( p ) {
            next = p->Next;
            if ( p->Data < X && next==NULL ) {
                p->Next = node;
                break; // ret
            } else if ( p->Data < X && X < next->Data ) {
                p->Next = node;
                node->Next = next;
                break;
            }
            p = next;
        }
    }

    return L;
}



List Read() {
    List p, tail, head;
    head = (List)malloc(sizeof(struct Node));
    head->Next = NULL;
    p = head;
    int n, i, j;
    scanf("%d", &n);
    for (i = 0; i < n; i++) {
        tail = (List)malloc(sizeof(struct Node));
        scanf("%d", &tail->Data);
        p->Next = tail;
        p = tail;
    }
    p->Next = NULL;
    return head;
}
void Print(List L) {
    int no_space = 1;

    L = L->Next;
    while (L) {
        if (no_space) {
            printf("%d", L->Data);
            no_space = 0;
        } else {
            printf(" %d", L->Data);
        }
        L = L->Next;
    }
    puts("");
}