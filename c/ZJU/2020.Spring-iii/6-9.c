#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *createlist(); /*裁判实现，细节不表*/
struct ListNode *mergelists(struct ListNode *list1, struct ListNode *list2);
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
    struct ListNode  *list1, *list2;

    list1 = createlist();
    list2 = createlist();
    list1 = mergelists(list1, list2);
    printlist(list1);
	
    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode  Node;
typedef struct ListNode* NodePtr;

NodePtr createlist() {
    int n=-1;
    NodePtr head = NULL, node, end;

    while ( scanf("%d",&n) && n!=-1 ) {
        // 动态分配新的节点
        node = (NodePtr)malloc(sizeof(Node));
        node->data = n;
        node->next = NULL;

        if (head==NULL) { // 第一次添加节点
            head = node;
        } else { // 2+ 次添加节点
            end->next = node;
        }
        end = node;
    }
    return head;
}

NodePtr mergelists(NodePtr list1, NodePtr list2) {
    struct ListNode *Ohead=NULL, *Onode, *Oend; // OddList
    struct ListNode *node, *next1, *next2;

    if ( list1==NULL ) {
        return list2;
    } else if (list2==NULL) {
        return list1;
    }

    while ( list1 || list2 ) {
        list1 && (next1 = list1->next);
        list2 && (next2 = list2->next);

        if ( list1&&list2 ) {
            if (list1->data < list2->data) {
                node = list1;
                list1 = next1;
            } else {
                node = list2;
                list2 = next2;
            }
        } else if ( list1==NULL ) {
            node = list2;
            list2 = next2;
        } else if ( list2==NULL ) {
            node = list1;
            list1 = next1;
        }    
        node->next = NULL;

        if ( Ohead==NULL ) {
            Ohead = node;
        } else {
            Oend->next = node;
        }
        Oend = node;
    } // while (lnode) 遍历 L 结束

    return Ohead;
}