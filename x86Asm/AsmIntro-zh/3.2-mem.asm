global main

main:
    mov ebx, 1      ; ebx = 1
    mov ecx, 2      ; ecx = 2
    add ebx, ecx    ; ebx +=ecx = 1+2 = 3
    
    mov [sui_bian_xie], ebx ; sui_bian_xie = 3
    mov eax, [sui_bian_xie] ; eax = sui_bian_xie = 3
    
    ret ; ret 3

section .data
sui_bian_xie   dw    0 ; dw==double word