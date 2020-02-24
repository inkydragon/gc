global main

main:
    ; x = 2;
    mov dword [x], 0x2
    ; y = 3;
    mov dword [y], 0x3

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