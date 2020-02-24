global main

main:
    mov eax, 10

    cmp eax, 100
    jle less_eq_100
    sub eax, 20

less_eq_100:
    cmp eax, 10
    jg  great_10
    add eax, 10

great_10:
    add eax, 1
    ret