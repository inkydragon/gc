global main

eax_plus_1s:
    add eax, 1
    ret

ebx_plus_1s:
    add ebx, 1
    ret

main:
    mov eax, 0
    mov ebx, 0
    call eax_plus_1s
    call eax_plus_1s
    
    call ebx_plus_1s
    add eax, ebx
    ret