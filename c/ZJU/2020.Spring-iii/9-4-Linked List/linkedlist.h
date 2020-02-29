#ifndef LINKED_LIST_H
#define LINKED_LIST_H
#define STRUCT_NODE
#define STRUCT_LIST
#endif

typedef struct _node {
    int value;
    struct _node *next;
} Node;
// typedef struct _node Node;
typedef Node* NodePtr;

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


List list_create();
void list_free(ListPtr list);

void list_append(ListPtr list, int v);
void list_insert(ListPtr list, int v);

void list_set(ListPtr list, int index, int v);
int  list_get(ListPtr list, int index);

int  list_size(ListPtr list);

int  list_find(ListPtr list, int v);
void list_remove(ListPtr list, int v);

void list_iterate(ListPtr list, void (*func)(int v));

// for test only

// create
NodePtr _create_node(char* fname, int val, NodePtr next);
NodePtr _create_null_node(char *fname);
// add
void _add_node_at_tail(ListPtr list, int v);
void _add_node_at_head(ListPtr list, int v);
// void _add_node_at_middle(ListPtr list, int index, int value);
// void _add_node_at_index(ListPtr list, int index, int value);
// find
FindResult _find_node_value(ListPtr list, int val);
FindResult _find_node_index(ListPtr list, int index);
// delete
void _del_0or1_list_all(ListPtr list);
void _delete_list_head(ListPtr list);
void _delete_list_tail(ListPtr list);
void _delete_list_at_index(ListPtr list, int index);
int _delete_list_with_val(ListPtr list, int value);
