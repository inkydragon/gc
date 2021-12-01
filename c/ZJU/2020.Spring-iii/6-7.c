#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *createlist();

int main()
{
    struct ListNode *p, *head = NULL;

    head = createlist();
    for ( p = head; p != NULL; p = p->next )
        printf("%d ", p->data);
    printf("\n");

    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode  Node;
typedef struct ListNode* NodePtr;

NodePtr createlist() {
    int n=-1;
    NodePtr head=NULL, node;

    while ( scanf("%d",&n) && n!=-1 ) {
        node = (NodePtr)malloc(sizeof(Node));
        node->data = n;
        node->next = head;
        head = node;
    }
    return head;
}