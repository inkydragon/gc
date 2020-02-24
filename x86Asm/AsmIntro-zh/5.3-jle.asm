global main

main:
    mov eax, 1
    cmp eax, 100
    jle less_eq_100
    sub eax, 10

less_eq_100:
    add eax, 1
    ret