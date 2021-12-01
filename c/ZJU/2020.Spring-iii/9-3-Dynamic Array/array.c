#include "array.h"
#include <stdio.h>
#include <stdlib.h> // calloc, realloc
#include <string.h> // memcpy


// 报错行退出程序
void error_exit(char *s) {
    printf("[ArrayError]");
    printf("%s\n", s);
    exit(EXIT_FAILURE);
}

// 创建新的 Array
Array array_create() {
    Array arr;

    arr.size = BLOCK_SIZE;
    arr.content = (int *)calloc(arr.size, sizeof(int));
    if (arr.content == NULL) {
        error_exit("[array_create()] - unable to allocate required memory");
    } else {
        return arr;
    }
}

// 释放已有的 Array。原有内容置零。
void array_free(Array *arr) {
    free((*arr).content);
    (*arr).content = NULL;
    (*arr).size = 0;
}

// 返回 Array 的 size。
int array_size(const Array *arr) {
    return (*arr).size;
}

// 使得 Array 增大 BLOCK_SIZE 个大小。
void array_inflate(Array *arr) {
    int * ptr;
    (*arr).size += BLOCK_SIZE; // 大小增加 BLOCK_SIZE
    ptr = (int *)realloc((*arr).content, (*arr).size * sizeof(int));
    if (ptr == NULL) {
        array_free(arr);
        error_exit("[array_inflate(Array *)] - unable to re-allocate required memory");
    } else {
        (*arr).content = ptr;
    }
}

// 返回在 index 位置上的值。
int array_get(const Array *arr, int i) {
    return (*arr).content[i];
}

// 将 index 位置上的值置为 value。
void array_set(Array *arr, int i, int val){
    (*arr).content[i] = val;
}

// 复制一个新的 Array，其内容与函数参数相同。
Array array_clone(const Array *array) {
    Array arr;
    // 创建等大小的新 Array
    arr.size = array_size(array);
    arr.content = (int *)calloc(arr.size, sizeof(int));
    if (arr.content == NULL) {
        error_exit("[array_clone(const Array *)] - unable to allocate required memory");
    }

    // 复制内容
    memcpy(arr.content, (*array).content, arr.size * sizeof(int));
    return arr;
}