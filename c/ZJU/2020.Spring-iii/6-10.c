#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct ListNode {
    char code[8];
    struct ListNode *next;
};

struct ListNode *createlist(); /*裁判实现，细节不表*/
int countcs( struct ListNode *head );

int main()
{
    struct ListNode  *head;

    head = createlist();
    printf("%d\n", countcs(head));
	
    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode  Node;
typedef struct ListNode* NodePtr;
int countcs(NodePtr head) {
    int n=0;
    NodePtr p = head;

    while ( p ) {
        (p->code[1]=='0') && (p->code[2]=='2') && n++;
        p = p->next;
    }
    return n;
}

