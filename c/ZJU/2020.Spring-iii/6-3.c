#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *readlist();
struct ListNode *getodd( struct ListNode **L );
void printlist( struct ListNode *L )
{
     struct ListNode *p = L;
     while (p) {
           printf("%d ", p->data);
           p = p->next;
     }
     printf("\n");
}

int main()
{
    struct ListNode *L, *Odd;
    L = readlist();
    Odd = getodd(&L);
    printlist(Odd);
    printlist(L);

    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode  node_t;
typedef struct ListNode* nodeptr_t;

void alloc_check(void *ptr, char *msg) {
    if (ptr==NULL) {
        printf("[error]");
        printf("%s\n", msg);
    }
}

nodeptr_t readlist() {
    int n=-1;
    nodeptr_t head=NULL, node, end;

    while ( scanf("%d",&n) && n!=-1 ) {
        // 动态分配新的节点
        node = (nodeptr_t)malloc(sizeof(node_t));
        alloc_check((void *)node, "[readlist()] malloc failed!");
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

nodeptr_t getodd( nodeptr_t *EvenHead ) {
    struct ListNode *Ohead=NULL, *Onode, *Oend; // OddList
    struct ListNode *Ehead=NULL, *Enode, *Eend; // EvenList
    struct ListNode *node, *next;

    node = *EvenHead;
    while (node) {
        next = node->next;
        node->next = NULL;

        if ( (node->data)%2==0 ) { // 偶数
            if (Ehead==NULL) {
                Ehead = node;
            } else {
                Eend->next = node;
            }
            Eend = node;
        } else { // 奇数
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

    *EvenHead = Ehead;
    return Ohead;
}