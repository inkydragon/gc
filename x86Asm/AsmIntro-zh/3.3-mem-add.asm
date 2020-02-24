global main

main:
    mov ebx, [number_1]
    mov ecx, [number_2]
    add ebx, ecx
    
    mov [result], ebx
    mov eax, [result]
    
    ret

section .data
number_1      dw        10
number_2      dw        20
result        dw        0