/* 
 * @file xc.c
 * @brief step 0
 * 目前的功能：读取文件，逐字符输出
 */

#include <stdio.h> // printf, fopen, malloc
#include <stdlib.h> // EXIT_SUCCESS, EXIT_FAILURE
// #include <memory.h>
// #include <string.h>

int line;       // 行号
int token;      // 当前 token
int POOL_SIZE;  // 默认 文本段/数据段/栈 的大小
char *src,      // 指向源码的指针
     *old_src;  


/**
 * @brief 词法分析。获取下一个 token
 * @param[g] token
 * @param[g] src
 * 
 * @return void
 */
void next() {
    token = *src++;
    return;
}

/**
 * @brief 解析表达式
 * @param level
 * 
 * @return void
 */
void expression(int level) {
    // do something
    return;
}

/**
 * @brief 语法分析。分析整个 C 程序
 * @param[g] token
 * 
 * @return void
 */
void program() {
    next(); // 获取下一个 token
    while (token > 0) {
        printf("token is: %c\n", token);
        next();
    }
    return;
}

/**
 * @brief 解释执行目标代码
 * @param void
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 */
int eval() {
    return EXIT_SUCCESS;
}

/**
 * @brief 主函数
 * @param[g] 所有全局变量
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int main(int argc, char **argv) {
    int i, fd;

    argc--;
    argv++;

    POOL_SIZE = 256 * 1024; // 任意大小
    line = 1;

    if ((fd=open(*argv, 0)) < 0) {
        printf("could not open(%s)\n", *argv);
        return EXIT_FAILURE;
    }
    if (!(src=old_src=malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for source area\n", POOL_SIZE);
        return EXIT_FAILURE;
    }
    if ((i=read(fd,src,POOL_SIZE-1)) <= 0) {
        printf("could not read(): returned %d\n", i);
        return EXIT_FAILURE;
    }
    src[i] = 0; // 添加 EOF
    close(fd);

    program();
    return eval();
}