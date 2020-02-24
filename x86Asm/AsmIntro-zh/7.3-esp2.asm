global main

func1:
    add eax, 1
    call func2
    sub ebx, 1
    ret

func2:
    add eax, 1

    cmp eax, 5
    mov ebx, eax
    jge _ret 
    call func1
_ret:
    sub ebx, 1
    ret

main:
    mov eax, 1
    mov ebx, 0
    call func1
    sub ebx, 1
    ret