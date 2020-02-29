#include "linkedlist.h"
#include <stdio.h>
#include <stdlib.h>

#define NOT_NULL(ptr) ( (ptr) != NULL )
#define IS_EMPTY_LIST_PTR(listptr) \
    ( (NULL==(listptr->head)) && (NULL==(listptr->tail)) )
#define IS_ONE_NODE_LIST_PTR(listptr) \
    ( (listptr->head==listptr->tail) && (1==listptr->len) )
#define EMPTY_OR_ONE_NODE(listptr) \
    ( IS_EMPTY_LIST_PTR(listptr) || IS_ONE_NODE_LIST_PTR(listptr) )

// DEBUG help
#ifdef DEBUG
// #define DEBUG
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

#define G_LOG(fmt, ...) \
    printf("%s:%s " fmt "\n", __func__, __FILE__ "!" TOSTRING(__LINE__), ##__VA_ARGS__)
#endif // end #ifndef DEBUG


// 辅助函数
void _null_check(void *ptr, char *msg) {
    if (NULL==ptr) {
        printf("[error]");
        printf("%s\n", msg);
    }
}
void _malloc_check(void *ptr, char *fname) {
    if (NULL==ptr) {
        printf("[error]");
        printf("[%s] malloc Node failed.\n", fname);
    }
}

// 根据参数创建一个 Node
// + `char* fname`  : malloc 报错时输出的函数名
// + `int val`      : node.value
// + `NodePtr next` : node.next
NodePtr _create_node(char* fname, int val, NodePtr next) {
    NodePtr head = NULL, tail = NULL;

    head = (NodePtr)malloc(sizeof(Node));
    _malloc_check(head, fname);

    head->value = val;
    head->next = next;
    return head;
}
// 创建一个空 Node
// node.value = 0
// node.next  = NULL
NodePtr _create_null_node(char* fname) {
    return _create_node(fname, 0, NULL);
}

// 判断 List 是否为空？
// + 1 非空
// + 0 空列表
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

/* API ----------------------------------------------------
 *
 */
ListPtr _create_list() {
    ListPtr list = NULL;
    NodePtr head = NULL, tail = NULL;

    list = (ListPtr)malloc(sizeof(List));
    _null_check(list, "[list_create()] malloc List failed.");

    list->head = NULL;
    list->tail = NULL;
    list->len  = 0;
    return list;
}

// 创建一个 List，其中的 head 和 tail 都是零
List list_create() {
    return *_create_list();
}

// 释放整个链表中全部的结点，list 的 head 和 tail 置零。
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

void _add_node_at_tail(ListPtr list, int v) {
    NodePtr node = _create_node("_add_node_at_tail()", v, NULL);

    if (_not_a_empty_list(list)) {
        list->tail->next = node; // 连接最后一个节点
        list->tail = node; // 更新 list.tail
    } else { // 空 List
        list->head = node;
        list->tail = node;
    }
    list->len++;
}
// 在 List 末尾插入 Node(value)
void list_append(ListPtr list, int value) {
    _add_node_at_tail(list, value);
}

void _add_node_at_head(ListPtr list, int v) {
    NodePtr node = _create_node("_add_node_at_head()", v, NULL);

    if (_not_a_empty_list(list)) {
        node->next = list->head;
        list->head = node;
    } else { // 空 List
        list->head = node;
        list->tail = node;
    }
    list->len++;
}
// 在 List 头部插入 Node(value)
void list_insert(ListPtr list, int value) {
    _add_node_at_head(list, value);
}

void _add_node_at_middle(ListPtr list, int index, int value) {
    //
}

// 在 index 处插入 Node(value)，原有的 node 后移
// 编号从 0 开始
void _add_node_at_index(ListPtr list, int index, int value) {
    int len = list_size(list);
    if ( index<0 || index>len)
    if (0==index) {
        _add_node_at_head(list, value);
    } else if (len==index) {
        _add_node_at_tail(list, value);
    } else {
        _add_node_at_middle(list, index, value);
    }
}


// 根据 val 寻找 Node。
// 返回 FindResult
// 未找到 r.node==NULL && r.index==-1
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

FindResult _find_node_value_start_at(NodePtr node, int val) {
    FindResult r = _null_find_result();
    r.node = node;

    while ( NOT_NULL(r.node) ) {
        r.index++;
        if (val==r.node->value) return r;
        r.prev = r.node;
        r.node = r.node->next;
    }

    return _null_find_result();
}

// 根据 index 寻找 Node。(index 从 0 开始)
// 返回 FindResult
// 未找到 r.node==NULL
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


// 将链表中第 index 个结点的值置为 v
// 链表结点从 0 开始编号
void list_set(ListPtr list, int index, int v) {
    FindResult r = _find_node_index(list, index);
    NOT_NULL(r.node) && (r.node->value = v);
}

// 获得链表中第 index 个结点的值
// 链表结点从 0 开始编号
int list_get(ListPtr list, int index) {
    // TODO: 未找到时，会返回合法值 -1
    return _find_node_index(list, index).node->value;
}

// 给出链表的大小
inline int list_size(ListPtr list) {
    return list->len;
}

// 在链表中寻找值为 value 的结点，返回结点的编号
// 链表结点从 0 开始编号
// 如果找不到，返回 -1
int list_find(ListPtr list, int value) {
    return _find_node_value(list, value).index;
}


/* REMOVE 辅助函数

*/

// 删除整个只有 0/1 个节点的 List
void _del_0or1_list_all(ListPtr list) {
    list_free(list);
}

// 删除 List 的头部
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
// 删除 List 的末尾
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

void _delete_list_at_index(ListPtr list, int index) {
    if (0==index) { 
        // @0
        _delete_list_head(list);
    } else if ( (list_size(list)-1)==index ) {
        // @end
        _delete_list_tail(list);
    } else {
        // 2 ~ end-1
        FindResult r = _find_node_index(list, index);
        if (r.node==NULL) return; // 未找到 node

        // 0~1 node list
        if (EMPTY_OR_ONE_NODE(list)) {
            return _del_0or1_list_all(list);
        }

        // 2+ nodes list
        r.prev->next = r.node->next; // 跳过 node
        free(r.node);
        list->len--;
    }
}

// 删除第一个值为 value 的 node
// + 0 全部删除完毕
// + 1 还有剩余
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

// 删除链表中值为 value 的结点
void list_remove(ListPtr list, int value) {
    while (_delete_list_with_val(list, value));
}

void list_iterate(ListPtr list, void (*func)(int v)) {
    for (NodePtr node = list->head
        ; NOT_NULL(node)
        ; node = node->next) {
        func(node->value);
    }
}
