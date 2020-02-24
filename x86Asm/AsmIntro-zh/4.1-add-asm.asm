global main

main:
    ; x = 2;
    mov eax, 2
    mov [x], eax
    ; y = 3;
    mov eax, 3
    mov [y], eax

    ; z = x + y;
    mov eax, [x]
    mov ebx, [y]
    add eax, ebx
    mov [z], eax

    ; return z;
    mov eax, [z]
    ret

section .data
; int x, y, z;
x   dw  0
y   dw  0
z   dw  0