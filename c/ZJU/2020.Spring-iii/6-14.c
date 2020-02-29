#include <stdio.h>
#include <stdlib.h>

typedef struct _Node {
    int value;
    struct _Node *next;
    struct _Node *prev;
} Node;

typedef struct {
    Node *head;
    Node *tail;
} List;

void list_append(List *list, int value);
void list_remove(List *list, int value);
void list_print(List *list);
void list_clear(List *list);

int main()
{
    List list = {NULL, NULL};
    while ( 1 ) {
        int x;
        scanf("%d", &x);
        if ( x == -1 ) {
            break;
        }
        list_append(&list, x);
    }
    int k;
    scanf("%d", &k);
    list_remove(&list, k);
    list_print(&list);
    list_clear(&list);
}

void list_print(List *list)
{
    for ( Node *p = list->head; p; p=p->next ) {
        printf("%d ", p->value);
    }
    printf("\n");
}

void list_clear(List *list)
{
    for ( Node *p = list->head, *q; p; p=q ) {
        q = p->next;
        free(p);
    }
}


/* 请在这里填写答案 */

typedef Node* NodePtr;

typedef struct {
    NodePtr head;
    NodePtr tail;
    int len;
} List_t;
typedef List_t* ListPtr;

typedef struct {
    NodePtr prev;
    NodePtr node;
    int index;
} FindResult;

ListPtr make_list(List *lst) {
    int i = 0;
    NodePtr head = lst->head;
    ListPtr list = (ListPtr)malloc(sizeof(List_t));

    while ( head ) {
        i++;
        head = head->next;
    }

    list->head = lst->head;
    list->tail = lst->tail;
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

    list = (ListPtr)malloc(sizeof(List_t));

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
        if (val==r.node->value) return r;
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

NodePtr readlist() {
    int n=-1;
    NodePtr head=NULL, node, end=NULL;

    while ( scanf("%d",&n) && n!=-1 ) {
        // 动态分配新的节点
        node = (NodePtr)malloc(sizeof(Node));
        node->value = n;
        node->next = NULL;
        node->prev = end;

        if (head==NULL) { // 第一次添加节点
            head = node;
        } else { // 2+ 次添加节点
            end->next = node;
        }
        end = node;
    }
    return head;
}

void _list_append(ListPtr list, int value) {
    NodePtr node = NULL;

    node = (NodePtr)malloc(sizeof(Node));
    node->value = value;
    node->prev = list->tail;
    node->next = NULL;

    if (list->head==NULL) { // 第一次添加节点
        list->head = node;
    } else { // 2+ 次添加节点
        list->tail->next = node;
    }
    list->tail = node;
    list->len++;
}

void list_append(List *list, int value) {
    ListPtr new_list = make_list(list);
    _list_append(new_list, value);
    list->head = new_list->head;
    list->tail = new_list->tail;
}
void list_remove(List *list, int value) {
    ListPtr new_list = make_list(list);
    while (_delete_list_with_val(new_list, value));
    list->head = new_list->head;
    list->tail = new_list->tail;
}