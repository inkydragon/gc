#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int data;
    struct ListNode *next;
};

struct ListNode *readlist();
struct ListNode *deletem( struct ListNode *L, int m );
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
    int m;
    struct ListNode *L = readlist();
    scanf("%d", &m);
    L = deletem(L, m);
    printlist(L);

    return 0;
}

/* 你的代码将被嵌在这里 */
typedef struct ListNode  Node;
typedef struct ListNode* NodePtr;
typedef struct {
    NodePtr head;
    NodePtr tail;
    int len;
} List;
typedef List* ListPtr;

typedef struct {
    NodePtr prev;
    NodePtr node;
    int index;
} FindResult;

ListPtr make_list(NodePtr node) {
    ListPtr list = NULL;
    NodePtr head = node;
    int i = 0;

    list = (ListPtr)malloc(sizeof(List));
    while ( head ) {
        i++;
        head = head->next;
    }

    list->head = node;
    list->tail = head;
    list->len  = i;
    return list;
}

#define NOT_NULL(ptr) ( (ptr) != NULL )
#define IS_EMPTY_LIST_PTR(listptr) \
    ( (NULL==(listptr->head)) && (NULL==(listptr->tail)) )
#define IS_ONE_NODE_LIST_PTR(listptr) \
    ( (listptr->head==listptr->tail) && (1==listptr->len) )
#define EMPTY_OR_ONE_NODE(listptr) \
    ( IS_EMPTY_LIST_PTR(listptr) || IS_ONE_NODE_LIST_PTR(listptr) )

int list_size(ListPtr list);


ListPtr _create_list() {
    ListPtr list = NULL;
    NodePtr head = NULL, tail = NULL;

    list = (ListPtr)malloc(sizeof(List));

    list->head = NULL;
    list->tail = NULL;
    list->len  = 0;
    return list;
}

int _not_a_empty_list(ListPtr list) {
    return list->head != NULL 
        && list->tail != NULL 
        && list->len  != 0;
}

FindResult _null_find_result() {
    FindResult r;
    r.index = -1;
    r.prev = NULL;
    r.node = NULL;
    return r;
}

void list_free(ListPtr list) {
    NodePtr node = NULL, p = NULL;

    if (_not_a_empty_list(list)) {
        node = list->head;
        // 遍历 List
        while ( NOT_NULL(node) ) {
            p = node;
            node = node->next;
            free(p);
        }
        // 置空
        list->head = NULL;
        list->tail = NULL;
        list->len = 0;
    } else {
        // 空 List
        // 无需处理
    }
}

FindResult _find_node_value(ListPtr list, int val) {
    FindResult r = _null_find_result();
    r.node = list->head;

    while ( NOT_NULL(r.node) ) {
        r.index++;
        if (val==r.node->data) return r;
        r.prev = r.node;
        r.node = r.node->next;
    }

    return _null_find_result();
}

FindResult _find_node_index(ListPtr list, int index) {
    FindResult r = _null_find_result();
    r.node = list->head;

    while ( NOT_NULL(r.node) ) {
        r.index++;
        if (index==r.index) return r;
        r.prev = r.node;
        r.node = r.node->next;
    }
    return _null_find_result();
}

inline int list_size(ListPtr list) {
    return list->len;
}

void _del_0or1_list_all(ListPtr list) {
    list_free(list);
}
void _delete_list_head(ListPtr list) {
    // 0~1 node list
    if (EMPTY_OR_ONE_NODE(list)) {
        return _del_0or1_list_all(list);
    }

    // 2+ node list: tail 不用动
    NodePtr node = list->head; // 取头部
    list->head = node->next; // 移动头部指针
    free(node);
    list->len--;
}
void _delete_list_tail(ListPtr list) {
    // 0~1 node list
    if (EMPTY_OR_ONE_NODE(list)) {
        return _del_0or1_list_all(list);
    }

    // 2+ node list: head 不用动
    FindResult r = _find_node_index(list, list_size(list) - 1);
    list->tail = r.prev;
    r.prev->next = NULL; // 倒数第二个节点 next 置空
    free(r.node);
    list->len--;
}

int _delete_list_with_val(ListPtr list, int value) {
    ListPtr next_list = _create_list();
    // 找到应删除的节点
    FindResult r = _find_node_value(list, value);
    if (r.node==NULL) return 0; // 未找到 node
    next_list->head = r.node->next; // 下次搜索的起点

    if (0==r.index) { 
        // @0
        _delete_list_head(list);
    } else if ( (list_size(list)-1)==r.index ) {
        // @end
        _delete_list_tail(list);
    } else { // 2 ~ end-1
        // 0~1 node list
        if (EMPTY_OR_ONE_NODE(list)) {
            _del_0or1_list_all(list);
            return 0;
        }

        // 2+ nodes list
        r.prev->next = r.node->next; // 跳过 node
        free(r.node);
        list->len--;
    }

    return NOT_NULL(_find_node_value(next_list, value).node);
}

void list_remove(ListPtr list, int value) {
    while (_delete_list_with_val(list, value));
}


NodePtr readlist() {
    int n=-1;
    NodePtr head=NULL, node, end;

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

NodePtr deletem(NodePtr node, int m) {
    ListPtr list = make_list(node);
    list_remove(list, m);
    return list->head;
}