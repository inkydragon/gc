#include "linkedlist.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
// #include "linkedlist.h"

// #define JUDGE(x, c, s) {\
//     FILE *fp = fopen(argv[1], "a");\
//     if ( fp ) {\
//         fprintf(fp, "%s\t", s);\
//         if ( x ) {\
//             credit += c;\
//             fprintf(fp, "PASS %d %d\n", c, credit);\
//         } else {\
//             fprintf(fp, "FAIL 0\n");\
//         }\
//         fclose(fp);\
//     }\
// }

#define JUDGE(x, c, s)              \
    {                               \
        printf("%s\t", s);          \
        if (x)                      \
        {                           \
            printf("PASS %d\n", c); \
        }                           \
        else                        \
        {                           \
            printf("FAIL 0 <----"); \
            printf("-------!!!\n"); \
        }                           \
    }

#ifndef STRUCT_NODE
typedef struct _node {
    int value;
    struct _node *next;
} Node;
#endif

static int sum = 0;

void acc(int v)
{
    sum += v;
}

int main(int argc, char *argv[])
{
    // if ( argc != 2 ) {
    //     exit(-1);
    // }

    // FILE *fp = fopen(argv[1], "w");
    // if ( !fp ) {
    //     exit(-1);
    // }
    // fclose(fp);

    srand(time(0));
    int ranlen = rand()%100+100;
    int ranloc = ranlen-rand()%10-1;
    int ranv = rand() % 65536;
    // int credit = 0;
    
    List lst = list_create();
    JUDGE(lst.head == NULL, 1, "create 1");
    JUDGE(lst.tail == NULL, 1, "create 2");

    list_append(&lst, 1);
    JUDGE(lst.head->value == 1, 1, "append empty");

    for ( int i=2; i<ranlen; i++ ) {
        list_append(&lst, i);
    }
    JUDGE(lst.tail->value == ranlen-1, 1, "append normal");

    list_insert(&lst, ranv);
    JUDGE(lst.head->value == ranv && lst.head->next->value == 1, 1, "insert normal");


    List c = list_create();
    list_insert(&c, ranv%37);
    JUDGE(c.head->value == ranv%37, 1, "insert empty");
    JUDGE(list_size(&lst) == ranlen, 1, "size\t");

    list_set(&lst, 0, 0);
    JUDGE(list_get(&lst, 0) == 0 , 1, "get/set first");
    list_set(&lst, ranloc, ranv);
    JUDGE(list_get(&lst, ranloc) == ranv, 1, "get/set random");
    list_set(&lst, ranlen-1, ranv);
    JUDGE(list_get(&lst, ranlen-1) == ranv, 1, "get/set last");
    list_set(&lst, ranlen-1, ranlen-1);
    list_set(&lst, ranloc, ranv);

    JUDGE(list_find(&lst, ranv) == ranloc, 1, "find random");
    list_set(&lst, ranloc, ranloc);
    ranloc = rand()%(ranlen-2)+1;
    JUDGE(list_find(&lst, 0) == 0, 1, "find first");
    JUDGE(list_find(&lst, ranlen-1) == ranlen-1, 1, "find last");
    JUDGE(list_find(&lst, ranlen*2) == -1, 1, "find not in 1");
    JUDGE(list_find(&lst, -ranlen) == -1, 1, "find not in 2");

    list_remove(&lst, ranloc);
    JUDGE(list_size(&lst)==ranlen-1 && list_find(&lst, ranloc) == -1, 1, "remove random");
    list_remove(&lst, ranlen-1);
    JUDGE(list_size(&lst)==ranlen-2 && lst.tail->value == ranlen-2, 1, "remove last");
    list_remove(&lst, 0);
    JUDGE(list_size(&lst)==ranlen-3 && lst.head->value == 1, 1, "remove first");

    int ans = 0;
    for ( int i=0; i<list_size(&lst); i++ ) {
        ans += list_get(&lst, i);
    }
    list_iterate(&lst, acc);
    JUDGE(ans == sum, 1, "iterate\t");

    list_free(&lst);
    list_free(&c);
    JUDGE(lst.head == NULL && lst.tail == NULL, 1, "free\t");


// WOCLASS EXT TEST SET ======================================
//              BEGIN   ======================================
printf("\nWOCLASS EXT TEST SET ===========\n");

// [create] -------------------------------------
    NodePtr node = _create_null_node("test");
    JUDGE(node->next == NULL, 1, "[_create_null_node] next==NULL");
    JUDGE(node->value == 0, 1, "[_create_null_node] value == 0");
    free(node);

    node = _create_node("test", ranv, NULL);
    JUDGE(node->next == NULL, 1, "[_create_node] next == NULL");
    JUDGE(node->value == ranv, 1, "[_create_node] value == ranv");
    free(node);

// [add] ---------------------------------------
    List list4test = list_create();
    JUDGE(list4test.head == NULL, 1, "[create] head == NULL\t");
    JUDGE(list4test.tail == NULL, 1, "[create] tail == NULL\t");
    JUDGE(list4test.len == 0, 1, "[create] len == 0\t");
    JUDGE(list_size(&list4test) == 0, 1, "[list_size] == 0\t");

    _add_node_at_head(&list4test, 100);
    JUDGE(list4test.tail->value == 100, 1, "[_add_node_at_head] start normal");
    JUDGE(list_size(&list4test) == 1, 1, "[list_size] == 1\t");

    for ( int i=1; i<=10; i++ ) {
        // 10 ~ 1, 100
        _add_node_at_head(&list4test, i);
    }
    JUDGE(list_size(&list4test) == 1+10, 1, "[list_size] == 11\t");

    _add_node_at_tail(&list4test, -100);
    JUDGE(list4test.tail->value == -100, 1, "[_add_node_at_tail] end normal\t");
    for ( int i=1; i<=10; i++ ) {
        // -100, -1~-10
        _add_node_at_tail(&list4test, -i);
    }
    JUDGE(list4test.tail->value == -10, 1, "[_add_node_at_tail] end++ normal");
    JUDGE(list_size(&list4test) == 22, 1, "[list_size] == 22\t");

    // [find] ---------------------------------------
    FindResult r = _find_node_value(&list4test, -100);
    JUDGE(r.index == 12-1, 1, "\t[_find_node_value] at end");
    r = _find_node_value(&list4test, 100);


    for (int i = 1; i <= 10; i++)
    {
        // 10 ~ 1, 100
        r = _find_node_value(&list4test, i);
        JUDGE(
            r.index == 10-i, 
            1, 
            "\t[_find_node_value] at start+0~9"
        );
    }
    for (int i = 1; i <= 10; i++)
    {
        // 10 ~ 1, 100
        r = _find_node_value(&list4test, -i);
        JUDGE(
            r.index == (list_size(&list4test)-1-10+i), 
            1, "\t[_find_node_value] at end-(0~9)"
        );
    }

// [free] ---------------------------------------
    list_free(&list4test);
    JUDGE(list4test.head == NULL, 1, "[free] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "[free] tail == NULL");
    JUDGE(list4test.len == 0, 1, "[free] len == 0\t");

// [delete] -------------------------------------
    _del_0or1_list_all(&list4test);
    JUDGE(list4test.head == NULL, 1, "[_del_0or1_list_all] [0] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "[_del_0or1_list_all] [0] tail == NULL");
    JUDGE(list4test.len == 0, 1, "[_del_0or1_list_all] [0] len == 0");
    _add_node_at_head(&list4test, 1);
    _del_0or1_list_all(&list4test);
    JUDGE(list4test.head == NULL, 1, "[_del_0or1_list_all] [1] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "[_del_0or1_list_all] [1] tail == NULL");
    JUDGE(list4test.len == 0, 1, "[_del_0or1_list_all] [1] len == 0");

    // _delete_list_head
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _add_node_at_head(&list4test, i);
    }
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _delete_list_head(&list4test);
    }
    JUDGE(list4test.head == NULL, 1, "\t[_delete_list_head] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "\t[_delete_list_head] tail == NULL");
    JUDGE(list4test.len == 0, 1, "\t[_delete_list_head] len == 0\t");

    // _delete_list_head
    _add_node_at_head(&list4test, 1);
    _add_node_at_head(&list4test, 2);
    r = _find_node_index(&list4test, list_size(&list4test) - 1);
    JUDGE(r.prev == list4test.head, 1, "\t[_find_node_index] r.prev == list4test.head\t");
    JUDGE(r.prev->next == list4test.tail, 1, "\t[_find_node_index] r.prev->next == list4test.tail");
    JUDGE(r.node == list4test.tail, 1, "\t[_find_node_index] r.node == list4test.tail\t");

    _delete_list_tail(&list4test);
    JUDGE(list4test.head == list4test.tail, 1, "\t[_delete_list_tail] list4test.head == list4test.tail");
    JUDGE(list4test.len == 1, 1, "\t[_delete_list_tail] len == 1 \t");

    list_free(&list4test);
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _add_node_at_head(&list4test, i);
    }
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _delete_list_tail(&list4test);
    }
    JUDGE(list4test.head == NULL, 1, "\t[_delete_list_tail] [5] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "\t[_delete_list_tail] [5] tail == NULL");
    JUDGE(list4test.len ==  0, 1,    "\t[_delete_list_tail] [5] len == 0");

    //
    list_free(&list4test);
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _add_node_at_head(&list4test, i);
    }
    for (int i = 1; i <= 5; i++)
    {
        // 5 ~ 1
        _delete_list_at_index(&list4test, 0);
        // _delete_list_head(&list4test);
    }
    JUDGE(list4test.head == NULL, 1, "\t[_delete_list_at_index] [5] head == NULL");
    JUDGE(list4test.tail == NULL, 1, "\t[_delete_list_at_index] [5] tail == NULL");
    JUDGE(list4test.len == 0, 1, "\t[_delete_list_at_index] [5] len == 0\t");





    // [remove] -------------------------------------
    int val = 0x66ccff, v_len=2;
    List list_all_v = list_create();

    /// [v+]
    for ( int i=0; i<v_len; i++ ) {
        list_append(&list_all_v, val);
    }

    list_remove(&list_all_v, val);
    JUDGE(
        list_all_v.head == NULL 
        && list_all_v.tail == NULL, 
        1, "[remove] [v+]\t"
    );
    list_free(&list_all_v);
    // --------------------------------
    list_all_v = list_create();
    /// 1 : [v+]
    list_append(&list_all_v, 1);
    for ( int i=0; i<v_len; i++ ) {
        list_append(&list_all_v, val);
    }

    list_remove(&list_all_v, val);
    JUDGE(
        list_size(&list_all_v) == 1 
        && list_find(&list_all_v, 1) == 0, 
        1, "[remove] 1 : [v+]"
    );
    list_free(&list_all_v);
    // --------------------------------
    list_all_v = list_create();
    ///  [v+] : 1
    for ( int i=0; i<v_len; i++ ) {
        list_append(&list_all_v, val);
    }
    list_append(&list_all_v, 1);

    list_remove(&list_all_v, val);
    JUDGE(
        list_size(&list_all_v) == 1 
        && list_find(&list_all_v, 1) == 0, 
        1, "[remove] [v+] : 1"
    );
    list_free(&list_all_v);
    JUDGE(list_all_v.head == NULL, 1, "[free] head == NULL");
    JUDGE(list_all_v.tail == NULL, 1, "[free] tail == NULL");
    JUDGE(list_all_v.len == 0, 1, "[free] len == 0\t");
    // --------------------------------

// remove --------------------------------------



// printf("================================\n");
// WOCLASS EXT TEST SET ======================================
//              END     ======================================


    // fp = fopen(argv[1], "a");
    // if ( fp ) {
    //     fprintf(fp, "%d\n", credit);
    //     fclose(fp);
    // }
}