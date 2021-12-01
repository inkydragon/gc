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
void Print( List L ); /* 细节在此不表；空链表将输出NULL */

List Merge( List L1, List L2 );

int main()
{
    List L1, L2, L;
    L1 = Read();
    L2 = Read();
    L = Merge(L1, L2);
    Print(L);
    Print(L1);
    Print(L2);
    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct Node Node;
typedef PtrToNode   NodePtr;

NodePtr mergelists(NodePtr list1, NodePtr list2) {
    NodePtr Ohead = NULL, Onode, Oend;
    NodePtr node, next1, next2;

    if ( list1==NULL ) {
        return list2;
    } else if (list2==NULL) {
        return list1;
    }

    while ( list1 || list2 ) {
        list1 && (next1 = list1->Next);
        list2 && (next2 = list2->Next);

        if ( list1&&list2 ) {
            if (list1->Data < list2->Data) {
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
        node->Next = NULL;

        if ( Ohead==NULL ) {
            Ohead = node;
        } else {
            Oend->Next = node;
        }
        Oend = node;
    } // while (lnode) 遍历 L 结束

    return Ohead;
}
NodePtr Merge(NodePtr L1, NodePtr L2) {
    NodePtr head = (NodePtr)malloc(sizeof(Node));
    head->Next = mergelists(L1->Next, L2->Next);
    L1->Next = NULL;
    L2->Next = NULL;
    return head;
}



NodePtr createlist() {
    int n=-1;
    NodePtr head = NULL, node, end;

    while ( scanf("%d",&n) && n!=-1 ) {
        // 动态分配新的节点
        node = (NodePtr)malloc(sizeof(Node));
        node->Data = n;
        node->Next = NULL;

        if (head==NULL) { // 第一次添加节点
            head = node;
        } else { // 2+ 次添加节点
            end->Next = node;
        }
        end = node;
    }
    return head;
}

List Read() {
    List head = (List)malloc(sizeof(struct Node));
    head->Next = createlist();
    return head;
}
void Print(List L) {
    int no_space = 1;
    L = L->Next;
    if (L==NULL) {
        printf("NULL");
    } else {
        while (L) {
            if (no_space) {
                printf("%d", L->Data);
                no_space = 0;
            } else {
                printf(" %d", L->Data);
            }
            L = L->Next;
        }
    }
    putchar('\n');
    // puts("");
}