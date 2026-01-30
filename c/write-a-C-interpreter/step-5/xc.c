/* 
 * @file xc.c
 * @brief step 5
 */

#include <stdio.h>  // printf, malloc, fopen, fclose, fread,
#include <stdlib.h> // EXIT_SUCCESS, EXIT_FAILURE, exit
#include <memory.h> // memset,
#include <string.h> // memcmp,
#define int long long // 兼容 x64 架构

int DEBUG;

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
    cycle, // 循环次数
    index_of_bp; // bp 指针的地址
int *idmain; // main 函数
int basetype,   // 声明的类型
    expr_type;  // 表达式的类型

/// 标识符表 Symbol table
int token_val,   // token 的值
    *current_id, // parsered ID
    *symbols;    // 符号表
enum { // 字段 x10
    Token,  // 标识符对应的标记。除 ID 外还有关键字
    Hash,
    Name,   // 标识符本身的字符串

    Type,   // 类型 int, char, pointer
    Class,  // 类别 数字、局部变量、全局变量
    Value,  // 值   函数地址, ...
    // 局部作用域中，暂存全局信息
    BType, BClass, BValue,

    IdSize // 一个标识符结构体的大小
};


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

// tokens and classes
enum {
    Num=128, Fun, Sys, Glo, Loc, Id,
    // 标识符
    Char, Else, Enum, If, Int, Return, Sizeof, While,
    // 运算符
    Assign, Cond, Lor, Lan, Or, Xor, And, Eq, Ne, Lt, Gt, Le, Ge, Shl, Shr, Add, Sub, Mul, Div, Mod, Inc, Dec, Brak
};

// 变量、函数的类型
enum { CHAR, INT, PTR };


/**
 * @brief 跳过当前行剩余的字符，直到行尾
 * @param[g] src
 * 
 * @return void
 */
void jump_to_line_end() {
    while (*src!=0 && *src!='\n') {
        src++;
    }
} // end of `void jump_to_line_end()`

/**
 * @brief 词法分析。获取下一个 token
 * @param[g] token
 * @param[g] src
 * @param[g] current_id
 * @param[g] symbols
 * @param[g] token_val
 * 
 * @return void
 */
void next() {
DEBUG && printf("[DEBUG] step in `next()`\n");
    char *last_pos;
    int hash;

    while (token = *src++) { // 解析 token
        if     (token == '\n') { line++; }
        else if (token == '#') jump_to_line_end(); // 忽略宏定义

        /// 标识符 Id: 字幕及下划线开头
        else if((token >= 'a' && token <= 'z') ||  
                (token >= 'A' && token <= 'Z') || 
                (token == '_')) {
            last_pos = src - 1;
            hash = token;

            // 读取标识符的第 2+ 位
            while ( (*src >= 'a' && *src <= 'z') || 
                    (*src >= 'A' && *src <= 'Z') || 
                    (*src >= '0' && *src <= '9') || 
                    (*src == '_') ) {
                hash = hash * 147 + *src;
                src++;
            }

            // 线性查找 hash 是否存在
            current_id = symbols;
            while (current_id[Token]) {
                if (current_id[Hash] == hash &&
                    !memcmp((char *)current_id[Name], last_pos, src-last_pos)) {
                    token = current_id[Token];
                    return; // 返回已有的 token
                }
                current_id = current_id + IdSize;
            } // end of `while (current_id[Token])`

            // hash 不存在，加入新项
            current_id[Name] = (int)last_pos;
            current_id[Hash] = hash;
            current_id[Token] = Id;
            token = Id;
            return;
        } // end of `if (is_id())`

        /// 数字
        else if (token >= '0' && token <= '9') {
            // parse number, three kinds: dec(123) hex(0x123) oct(017)
            token_val = token - '0';
            if (token_val > 0) {
                // dec, starts with [1-9]
                while (*src >= '0' && *src <= '9') {
                    token_val = token_val*10 + *src++ - '0';
                }
            } else {
                // starts with 0
                if (*src == 'x' || *src == 'X') {
                    //hex
                    token = *++src;
                    while ( (token >= '0' && token <= '9') || 
                            (token >= 'a' && token <= 'f') || 
                            (token >= 'A' && token <= 'F')) {
                        token_val = token_val * 16 + (token & 15) + (token >= 'A' ? 9 : 0);
                        token = *++src;
                    }
                } else {
                    // oct
                    while (*src >= '0' && *src <= '7') {
                        token_val = token_val*8 + *src++ - '0';
                    }
                }
            }

            token = Num;
            return;
        } // end of `if (token >= '0' && token <= '9')`

        /// 字符串
        else if (token == '"' || token == '\'') {
            // 仅支持 \n 转义
            last_pos = data;

            while (*src!=0 && *src!=token) {
                token_val = *src++;
                if (token_val == '\\') {
                    // 转义字符
                    token_val = *src++;
                    if (token_val == 'n') {
                        token_val = '\n';
                    }
                } // end od `if (token_val=='\\')`
                if (token == '"') {
                    *data++ = token_val;
                }
            } // end of `while (*src!=0 && *src!=token)`

            src++;

            // 如果是单字母，则返回数字类型
            if (token == '"') {
                token_val = (int)last_pos;
            } else {
                token = Num;
            }
            return;
        } // end of `if (is_string())`
        
        /// 注释与除法
        else if (token == '/') {
            if (*src == '/') jump_to_line_end(); // 跳过注释
            else {
                token = Div;
                return; // 返回 除法
            }
        } // end of `if (token=='/')`

        /// 其他一元、二元操作符
        else if (token == '=') { // parse '==' and '='
            if (*src == '=') {
                src++;
                token = Eq;
            } else {
                token = Assign;
            }
            return;
        }
        else if (token == '+') { // parse '+' and '++'
            if (*src == '+') {
                src++;
                token = Inc;
            } else {
                token = Add;
            }
            return;
        }
        else if (token == '-') { // parse '-' and '--'
            if (*src == '-') {
                src++;
                token = Dec;
            } else {
                token = Sub;
            }
            return;
        }
        else if (token == '!') { // parse '!='
            if (*src == '=') {
                src++;
                token = Ne;
            }
            return;
        }
        else if (token == '<') { // parse '<=', '<<' or '<'
            if (*src == '=') {
                src++;
                token = Le;
            } else if (*src == '<') {
                src++;
                token = Shl;
            } else {
                token = Lt;
            }
            return;
        }
        else if (token == '>') { // parse '>=', '>>' or '>'
            if (*src == '=') {
                src++;
                token = Ge;
            } else if (*src == '>') {
                src++;
                token = Shr;
            } else {
                token = Gt;
            }
            return;
        }
        else if (token == '|') { // parse '|' or '||'
            if (*src == '|') {
                src++;
                token = Lor;
            } else {
                token = Or;
            }
            return;
        }
        else if (token == '&') { // parse '&' and '&&'
            if (*src == '&') {
                src++;
                token = Lan;
            } else {
                token = And;
            }
            return;
        }
        else if (token == '^') { token = Xor;  return; }
        else if (token == '%') { token = Mod;  return; }
        else if (token == '*') { token = Mul;  return; }
        else if (token == '[') { token = Brak; return; }
        else if (token == '?') { token = Cond; return; }
        else if (token == '~' || token == ';' || 
                 token == '{' || token == '}' || 
                 token == '(' || token == ')' || 
                 token == ']' || token == ',' || 
                 token == ':') {
            return; // 原样返回以上 token
        }
        else {
            if (DEBUG && token != ' ') {
                printf("[next] unkonwn token: %3d('%c') @line%d\n",
                       token, token, line);
            }
        } // end of if-else set
    } // end of `while (token = *src++)`
    return;
} // end of `void next()`

void match(int tk) { // @brief 匹配指定的符号
    if (token == tk) {
        next();
    } else {
        printf("expected token: %d(%c), got: %d(%c)\n", tk, tk, token, token);
        exit(-1);
    }
} // end of `void match(int tk)`

void expression(int level) // @brief 解析表达式
{
    DEBUG &&printf("[DEBUG] step in `expression()`\n");
    // do something
    return;
} // end of `void expression(int level)`

// 由 function_body() 调用
void statement() {
    // statement ::= non_empty_statement | empty_statement
    // non_empty_statement ::= if_statement | while_statement | '{' statement '}' | 'return' expression | expression ';'
    // if_statement ::= 'if' '(' expression ')' statement ['else' non_empty_statement]
    // while_statement ::= 'while' '(' expression ')' non_empty_statement
    // 共有 6 种语句
    int *a, *b;

    if (token == If) {
        // 1. if (...) <statement> [else <statement>]
        //   if (...)           <cond>
        //                      JZ a
        //     <T_statement>      <T_statement>
        //   else:              JMP b
        // a:                 a:
        //     <F_statement>      <F_statement>
        // b:                 b:
        match(If);
        match('(');
        expression(Assign);
        match(')');

        /// codegen JZ A
        *++text = JZ;
        b = ++text;

        statement();
        if (token == Else) {
            match(Else);

            *b = (int)(text + 3);
            /// codegen for JMP B
            *++text = JMP;
            b = ++text;

            statement();
        } // end of `if (token == Else)`
        *b = (int)(text + 1);
    } // end of `if (token == If)`
    else if (token == While) {
        // 2. while (...) <statement>
        // a:                     a:
        //    while (<cond>)        <cond>
        //                          JZ b
        //     <statement>          <statement>
        //                          JMP a
        // b:                     b:
        match(While);
        a = text + 1;
        match('(');
        expression(Assign);
        match(')');
        /// codegen JZ B
        *++text = JZ;
        b = ++text;

        statement();
        /// codegen JMP A
        *++text = JMP;
        *++text = (int)a;
        *b = (int)(text + 1);
    } // end of `if (token == While)`
    else if (token == Return) {
        // 3. return xxx;
        match(Return);
        if (token != ';') {
            expression(Assign);
        }
        match(';');

        /// codegen LEV
        *++text = LEV;
    } // end of `if (token == Return)`
    else if (token == '{') {
        // 4. { <statement>... }
        match('{');
        while (token != '}') {
            statement();
        }
        match('}');
    } // end of `if (token == '{')`
    else if (token == ';') {
        // 5. <empty statement>;
        match(';');
    } // end of `if (token == ';')`
    else {
        // a = b; or function_call();
        expression(Assign);
        match(';');
    } // end of if-else-if set
} // end of `void statement()`

// 由
//      function_body()
//      function_parameter()
// 调用
void check_id_declaration(char *s) { // 检查局部变量的定义
    if (token != Id) { // 非 id
        printf("@line#%d: bad %s declaration\n", line, s);
        exit(-1);
    }
    if (current_id[Class] == Loc) { // 重复定义
        printf("@line#%d: duplicate %s declaration\n", line, s);
        exit(-1);
    }
} // end of `void check_id_declaration()`

// 由 function_declaration() 调用
void function_body() { // 函数体解析
    // body_decl ::= {variable_decl}, {statement}
    
    // type func_name (...) {...}
    //                   -->|   |<--
    // ... {
    // 1. local declarations
    // 2. statements
    // }
    int type,
        pos_local; // 栈上局部变量的地址
    pos_local = index_of_bp;

    while (token==Int || token==Char) {
        basetype = (token==Int) ? INT : CHAR;
        match(token);

        while (token != ';') {
            type = basetype;
            while (token == Mul) {
                match(Mul);
                type = type + PTR;
            }

            check_id_declaration("local");
            match(Id);

            // 保存局部变量的信息
            current_id[BClass] = current_id[Class];
            current_id[Class ] = Loc;
            current_id[BType ] = current_id[Type];
            current_id[Type  ] = type;
            current_id[BValue] = current_id[Value];
            current_id[Value ] = ++pos_local;

            if (token == ',') match(',');
        } // end of `while (token != ';')`
        match(';');
    } // end of `while (token==Int || token==Char)`
    
    /// vm 指令生成
    // 保存栈上局部变量的大小
    *++text = ENT;
    *++text = pos_local - index_of_bp;

    // 语句
    while (token != '}') {
        statement();
    }

    // 退出子函数
    *++text = LEV;
} // end of `void function_body()`

// 由 function_declaration() 调用
void function_parameter() { // 函数参数解析
    // parameter_decl ::= type {'*'} id {',' type {'*'} id}
    int type;
    int params;
    params = 0;
    
    while (token != ')') {
        // int, char 类型
        type = INT;
        if (token == Int) {
            match(Int);
        } else if (token == Char) {
            type = CHAR;
            match(Char);
        }

        // 指针类型
        while (token == Mul) {
            match(Mul);
            type = type + PTR;
        }

        // 参数名
        check_id_declaration("parameter");
        match(Id);

        // 储存局部变量
        current_id[BClass] = current_id[Class]; 
        current_id[Class ] = Loc;
        current_id[BType ] = current_id[Type];  
        current_id[Type  ] = type;
        current_id[BValue] = current_id[Value]; 
        current_id[Value ] = params++;   // index of current parameter

        if (token == ',') match(',');
    } // end of `while (token != ')')`
    index_of_bp = params + 1;
} // end of `void function_parameter()`

// 由 global_declaration() 调用
void function_declaration() { // 解析函数定义
    // function_decl ::= type {'*'} id '(' parameter_decl ')' '{' body_decl '}'
    // type func_name (...) {...}
    //                | this part
    /// 解析函数参数及函数体

    match('(');
    function_parameter();
    match(')');
    match('{');
    function_body();
    // match('}'); // 不在此处解析，而在外层循环解析

    /// 恢复符号表中的局部信息
    /// 避免因局部变量与全局变量重名，二覆盖掉全局变量
    current_id = symbols;
    while (current_id[Token]) {
        if (current_id[Class] == Loc) {
            current_id[Class] = current_id[BClass];
            current_id[Type ] = current_id[BType];
            current_id[Value] = current_id[BValue];
        }
        current_id = current_id + IdSize;
    } // end of `while (current_id[Token])`
} // end of `void function_declaration()`

// 由 global_declaration() 调用
void enum_declaration() { /// @brief 解析枚举定义
    int i;
    i = 0;

    while (token != '}') {
        if (token != Id) {
            printf("@line%d: bad enum identifier %d\n", line, token);
            exit(-1);
        }
        next();
        if (token == Assign) {
            // enum {a=10};
            next();
            if (token != Num) {
                printf("%d: bad enum initializer\n", line);
                exit(-1);
            }
            i = token_val;
            next();
        } // end of `if (token == Assign)`

        current_id[Class] = Num; // 全局常量
        current_id[Type ] = INT;
        current_id[Value] = i++;

        if (token == ',') next();
    } // end of `while (token != '}')`
} // end of `void enum_declaration()`

// 由 program() 调用
void global_declaration() { // 解析 全局的定义语句
DEBUG && printf("[DEBUG] step in `global_declaration()`\n");
    // global_declaration ::= enum_decl | variable_decl | function_decl
    // enum_decl ::= 'enum' [id] '{' id ['=' 'num'] {',' id ['=' 'num'} '}'
    // variable_decl ::= type {'*'} id { ',' {'*'} id } ';'
    // function_decl ::= type {'*'} id '(' parameter_decl ')' '{' body_decl '}'
    int type, i;
    basetype = INT;

    // 解析 enum
    if(token == Enum) {
        match(Enum);
        if (token != '{') {
            match(Id);
        } else { // token == '{'
            match('{');
            enum_declaration();
            match('}');
        }
        match(';');
        return;
    } // end of `if(token == Enum)`

    // 类型定义
    if (token == Int) {
        match(Int);
    } 
    else if (token == Char) {
        match(Char);
        basetype = CHAR;
    }

    // 解析逗号分隔的变量定义
    while (token!=';' && token!='}') {
        type = basetype;
        while (token == Mul) {
            match(Mul);
            type = type + PTR;
        }

        if (token != Id) {
            // 无效的定义
            printf("@line%d: bad global declaration\n", line);
            exit(-1);
        }
        if (current_id[Class]) {
            // 已存在的定义
            printf("@line%d: duplicate global declaration\n", line);
            exit(-1);
        }
        match(Id);
        current_id[Type] = type;

        if (token == '('){
            // 函数定义
            current_id[Class] = Fun;
            current_id[Value] = (int)(text+1); // 函数的内存地址
            function_declaration();
        } else {
            // 变量定义
            current_id[Class] = Glo; // 全局变量
            current_id[Value] = (int)data;
            data = data + sizeof(int);
        }

        if (token == ',') match(',');
    } // end of `while (token!=';' && token!='}')`
    next();
} // end of `void global_declaration()`

void program() { // 语法分析。分析整个 C 程序
DEBUG && printf("[DEBUG] step in `program()`\n");
    next(); // 获取下一个 token
    while (token > 0) {
        global_declaration();
    }
}

/**
 * @brief 解释执行目标代码
 * @param[g] pc
 * @param[g] ax
 * @param[g] sp
 * @param[g] bp
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int eval() {
DEBUG && printf("[DEBUG] step in `eval()`\n");
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

/**
 * @brief 初始化符号表
 * @param[g] src
 * @param[g] symbols
 * @param[g] current_id
 * @param[g] idmain
 * @param[g] `next()` 所有参数
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int init_symbol_table() {
DEBUG && printf("[DEBUG] step in `init_symbol_table()`\n");
    int i;
    src = "char else enum if int return sizeof while "
          "open read close printf malloc memset memcmp exit void main";

    if (!(symbols = malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for symbol table\n", POOL_SIZE);
        return EXIT_FAILURE;
    }
    memset(symbols, 0, POOL_SIZE);

    // 将关键词加入符号表
    i = Char;
    while (i <= While) {
        next();
        current_id[Token] = i++;
    }

    // 将库函数加入符号表
    i = OPEN;
    while (i <= EXIT) {
        next();
        current_id[Class] = Sys;
        current_id[Type]  = INT;
        current_id[Value] = i++;
    }

    next(); current_id[Token] = Char; // void
    next(); idmain = current_id; // main
    return EXIT_SUCCESS;
}

/**
 * @brief 初始化 vm。为虚拟机分配内存
 * @param[g] text
 * @param[g] old_text
 * @param[g] data
 * @param[g] stack
 * @param[g] bp
 * @param[g] sp
 * @param[g] ax
 * 
 * @return 返回错误代码
 * - EXIT_SUCCESS
 * - EXIT_FAILURE
 */
int init_vm_segment() {
DEBUG && printf("[DEBUG] step in `init_vm_segment()`\n");
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
DEBUG = 0;
DEBUG && printf("[DEBUG] step in `main()`\n");
#define int long long // 兼容 x64 架构
    int i, file;

    argc--;
    argv++;

    POOL_SIZE = 256 * 1024; // 任意大小
    line = 1;

    // 初始化 vm
    if (init_vm_segment()!=EXIT_SUCCESS) return EXIT_FAILURE;
    // 初始化符号表
    if (init_symbol_table()!=EXIT_SUCCESS) return EXIT_FAILURE;

    // 读取文件
    if ((file=open(*argv, 0)) < 0)
    {
        printf("could not open(%s)\n", *argv);
        return EXIT_FAILURE;
    }
    if (!(src=old_src=malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for source area\n", POOL_SIZE);
        return EXIT_FAILURE;
    }
    if ((i=read(file,src,POOL_SIZE-1)) <= 0) {
        printf("could not read(): returned %d\n", i);
        return EXIT_FAILURE;
    }
    src[i] = 0; // 添加 EOF
    close(file);

    program();
    return eval();
}