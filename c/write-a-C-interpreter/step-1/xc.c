/* 
 * @file xc.c
 * @brief step 1
 * 指令集与虚拟机环境
 */

#include <stdio.h>  // printf, malloc, fopen, fclose, fread,
#include <stdlib.h> // EXIT_SUCCESS, EXIT_FAILURE
#include <memory.h> // memset,
#include <string.h> // memcmp,
#define int long long // 兼容 x64 架构

int line;       // 行号
int token;      // 当前 token
int POOL_SIZE;  // 默认 文本段/数据段/栈 的大小
// 以下 int 实际为 uint, 用于存放内存地址
char *src,      // 指向源码的指针
     *old_src;
/* @brief 虚拟机相关 */
int *text,     // 文本段 text segment
    *old_text, // 暂存文本段
    *stack;    // 栈 stack
char *data;    // 数据段
// 寄存器 registers
int *pc, // 程序寄存器
    *bp, // 基址寄存器
    *sp, // 栈顶寄存器
    ax,  // 通用寄存器
    cycle; // 循环次数

/* enum */
// 指令集 instructions
enum { // x38 = 14 + 16 + 8
    // x14
    LEA ,IMM ,JMP ,CALL,JZ  ,JNZ ,ENT ,ADJ ,
    LEV ,LI  ,LC  ,SI  ,SC  ,PUSH,
    // x16 二元运算
    OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,
    GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,
    // x8 内置函数
    OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT
};


/**
 * @brief 初始化 vm。为虚拟机分配内存
 * @param[g] text
 * @param[g] old_text
 * @param[g] data
 * @param[g] stack
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int init_vm_segment() {
    if (!(text = old_text = malloc(POOL_SIZE)))
    {
        printf("could not malloc(%d) for text area\n", POOL_SIZE);
        return EXIT_FAILURE;
    }
    if (!(data = malloc(POOL_SIZE)))
    {
        printf("could not malloc(%d) for data area\n", POOL_SIZE);
        return EXIT_FAILURE;
    }
    if (!(stack = malloc(POOL_SIZE)))
    {
        printf("could not malloc(%d) for stack area\n", POOL_SIZE);
        return EXIT_FAILURE;
    }

    memset(text,  0, POOL_SIZE);
    memset(data,  0, POOL_SIZE);
    memset(stack, 0, POOL_SIZE);

    // 初始化寄存器
    bp = sp = (int *)((int)stack + POOL_SIZE);
    ax = 0;

    return EXIT_SUCCESS;
}

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
    int op, *tmp;
    while (1) {
        op = *pc++; // 取指令

        /// MOV
        if     (op==IMM) {ax = *pc++;} // 将立即数传给 ax
        else if (op==LC) {ax = *(char *)ax;} // 将字符传给 ax, 地址位于 ax 中
        else if (op==LI) {ax = *(int  *)ax;}
        else if (op==SC) {*(char *)*sp++ = ax;} // 将 ax 中的字符保存到栈顶的地址中 
        else if (op==SI) {*(int  *)*sp++ = ax;}

        else if (op==PUSH) {*--sp = ax;} // 将 ax 的值压入栈中
        
        /// 转跳指令
        else if (op==JMP)  {pc = (int *)*pc;} // 无条件转跳
        else if (op==JZ )  {pc = ax ? pc+1 : (int *)*pc;} // jump if ax==0
        else if (op==JNZ)  {pc = ax ? (int *)*pc : pc+1;} // jump if ax！=0

        /// 子函数调用
        else if (op == CALL) { // 子函数调用
            *--sp = (int)(pc + 1);
            pc = (int *)*pc;
        }
        // else if (op==RET) {pc = (int *)*sp++;} // 从函数中返回
        else if (op == ENT) { // ENT <size>
                              // enter: make new call frame
            // 等价汇编
            // push ebp
            // mov  ebp, esp
            // sub  1,   esp
            *--sp = (int)bp; // 保存当前基址寄存器 bp 到栈中
            bp = sp;         // bp 指向当前栈顶
            sp = sp - *pc++; // 在栈上申请 <size> 大小的空间
                             // <size> 为立即数
        }
        else if (op == ADJ) { // ADJ <size>
                              // add: remove arguments from frame
            // 等价汇编
            // add  1,   esp
            sp = sp + *pc++;
        }
        else if (op == LEV) { // LEV
                              // leave: restore old call frame
            // 等价汇编
            // mov esp, ebp
            // pop ebp
            // ret
            sp = bp;           // 清空栈
            bp = (int *)*sp++; // 还原基址寄存器
            pc = (int *)*sp++; // 返回到函数调用处
        }
        else if (op == LEA) { // LEA <offset>
                              // 加载栈上的参数
            ax = (int)(bp + *pc++);
        }

        /// 运算符指令
        else if (op == OR)  ax = *sp++ |  ax;
        else if (op == XOR) ax = *sp++ ^  ax;
        else if (op == AND) ax = *sp++ &  ax;
        else if (op == EQ)  ax = *sp++ == ax;
        else if (op == NE)  ax = *sp++ != ax;
        else if (op == LT)  ax = *sp++ <  ax;
        else if (op == LE)  ax = *sp++ <= ax;
        else if (op == GT)  ax = *sp++ >  ax;
        else if (op == GE)  ax = *sp++ >= ax;
        else if (op == SHL) ax = *sp++ << ax;
        else if (op == SHR) ax = *sp++ >> ax;
        else if (op == ADD) ax = *sp++ +  ax;
        else if (op == SUB) ax = *sp++ -  ax;
        else if (op == MUL) ax = *sp++ *  ax;
        else if (op == DIV) ax = *sp++ /  ax;
        else if (op == MOD) ax = *sp++ %  ax;

        /// 内置函数
        else if (op == EXIT) { printf("exit(%d)", *sp); return *sp;}
        else if (op == OPEN) { ax = open((char *)sp[1], sp[0]); }
        else if (op == CLOS) { ax = close(*sp);}
        else if (op == READ) { ax = read(sp[2], (char *)sp[1], *sp); }
        else if (op == PRTF) {
            tmp = sp + pc[1];
            ax = printf(
                (char *)tmp[-1],
                tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]
            );
        }
        else if (op == MALC) { ax = (int)malloc(*sp);}
        else if (op == MSET) { ax = (int)memset((char *)sp[2], sp[1], *sp);}
        else if (op == MCMP) { ax = memcmp((char *)sp[2], (char *)sp[1], *sp);}

        /// 错误处理
        else { 
            printf("unknown instructions: %d\n", op);
            return EXIT_FAILURE;
        }
    } // end of `while (1)`
    return EXIT_SUCCESS;
} // end of `int eval()`

#undef int // main 必须返回 int
/**
 * @brief 主函数
 * @param[g] 所有全局变量
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int main(int argc, char **argv) {
#define int long long // 兼容 x64 架构
    int i, fd;

    argc--;
    argv++;

    POOL_SIZE = 256 * 1024; // 任意大小
    line = 1;

    // 读取文件
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

    // 初始化 vm
    if (init_vm_segment()!=EXIT_SUCCESS) return EXIT_FAILURE;

    /// 测试程序
    i = 0;
    // 1. exit(30)
    text[i++] = IMM;
    text[i++] = 10;
    text[i++] = PUSH;
    text[i++] = IMM;
    text[i++] = 20;
    text[i++] = ADD;
    text[i++] = PUSH;
    text[i++] = EXIT;
    // end of opcode
    pc = text;

    // program();
    return eval();
}