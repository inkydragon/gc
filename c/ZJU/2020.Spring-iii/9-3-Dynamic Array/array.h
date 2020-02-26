#ifndef BLOCK_SIZE
#define BLOCK_SIZE 128
#endif

typedef struct {
    int *content;
    int size;
} Array;

Array array_create();
void  array_free    (      Array *arr);

int   array_size    (const Array *arr);
void  array_inflate (      Array *arr);

int   array_get     (const Array *arr, int i);
void  array_set     (      Array *arr, int i, int val);

Array array_clone   (const Array *arr);
