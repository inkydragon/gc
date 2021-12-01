#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *createlist(); /*裁判实现，细节不表*/
struct ListNode *reverse( struct ListNode *head );
void printlist( struct ListNode *head )
{
     struct ListNode *p = head;
     while (p) {
           printf("%d ", p->data);
           p = p->next;
     }
     printf("\n");
}

int main()
{
    struct ListNode  *head;

    head = createlist();
    head = reverse(head);
    printlist(head);
	
    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode Node;
typedef struct ListNode* NodePtr;

NodePtr reverse( NodePtr head ) {
    NodePtr new_head=NULL, next, p;

    while ( head ) {
        next = head->next;

        p = head;
        p->next = new_head;
        new_head = p;
    
        head = next;
    }

    return new_head;
}

NodePtr createlist()
{
    int n = -1;
    NodePtr head = NULL, node, end;

    while (scanf("%d", &n) && n != -1)
    {
        // 动态分配新的节点
        node = (NodePtr)malloc(sizeof(Node));
        node->data = n;
        node->next = NULL;

        if (head == NULL)
        { // 第一次添加节点
            head = node;
        }
        else
        { // 2+ 次添加节点
            end->next = node;
        }
        end = node;
    }
    return head;
}