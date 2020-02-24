global main

main:
    ; sum = 0;
    mov eax, 0
    ; i = 1;
    mov ecx, 1

_start:
    ; if(i>10) goto _end_of_block;
    cmp ecx, 10
    jg  _end_of_block

    ; sum += i;
    add eax, ecx
    ; i += 1;
    add ecx, 1
    ; goto _end_of_block;
    jmp _start

_end_of_block:
    ; retrun sum;
    ret
