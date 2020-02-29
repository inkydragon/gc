#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *createlist();
struct ListNode *deleteeven( struct ListNode *head );
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
    struct ListNode *head;

    head = createlist();
    head = deleteeven(head);
    printlist(head);

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

NodePtr deleteeven( NodePtr EvenHead ) {
    struct ListNode *Ohead=NULL, *Onode, *Oend; // OddList
    struct ListNode *node, *next;

    node = EvenHead;
    while (node) {
        next = node->next;
        node->next = NULL;

        if ( (node->data)%2!=0 ) { // 奇数
            if (Ohead==NULL) {
                Ohead = node;
            } else {
                Oend->next = node;
            }
            Oend = node;
        } // if (data%2==0) 就判断结束
        // 获取下一个 node
        node = next;
    } // while (lnode) 遍历 L 结束

    return Ohead;
}