#include <stdio.h>
#include <stdlib.h>

struct stud_node {
    int     num;      /*学号*/
    char    name[20]; /*姓名*/
    int     score;    /*成绩*/
    struct stud_node*   next; /*指向下个结点的指针*/
};

struct stud_node *createlist();
struct stud_node *deletelist( struct stud_node *head, int min_score );

int main() {
    int min_score;
    struct stud_node *p, *head = NULL;

    head = createlist();
    scanf("%d", &min_score);
    head = deletelist(head, min_score);
    for ( p = head; p != NULL; p = p->next )
        printf("%d %s %d\n", p->num, p->name, p->score);

    return 0;
    // 1 zhang 78
    // 2 wang 80
    // 3 li 75
    // 4 zhao 85
    // 0
    // 80
}

/* 你的代码将被嵌在这里 */
typedef struct stud_node  Stud;
typedef struct stud_node* StudPtr;

StudPtr createlist() {
    StudPtr node = (StudPtr)malloc(sizeof(Stud));
    StudPtr head = NULL, tail;
    node->next = NULL;

    while ( 
        scanf("%d", &(node->num))
        && (node->num) 
        && scanf("%s %d", &(node->name), &(node->score)) 
    ) {
        if (head==NULL) { // 第一次添加节点
            head = node;
        } else { // 2+ 次添加节点
            tail->next = node;
        }
        tail = node;

        node = (StudPtr)malloc(sizeof(Stud));
        node->next = NULL;
    }
    return head;
}

StudPtr deletelist(StudPtr head, int min_score) {
    StudPtr nhead=NULL, nend=NULL, std, next;

    std = head;
    while ( std ) {
        next = std->next;
        std->next = NULL;

        if (std->score >= min_score) {
            if (nhead==NULL) {
                nhead = std;
            } else {
                nend->next = std;
            }
            nend = std;
        }
        std = next;
    } // end while

    return nhead;
}