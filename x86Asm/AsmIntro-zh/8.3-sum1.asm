global main

sum_one_to_n:
    mov ebx, 0

_go_on:
    cmp eax, 0
    je _get_out
    add ebx, eax
    sub eax, 1
    jmp _go_on

_get_out:
    mov eax, ebx
    ret

main:
    mov eax, 100
    call sum_one_to_n
    ret