global main

fibo:
    cmp eax, 1
    je _get_out
    cmp eax, 2
    je _get_out
    
    mov edx, eax
    sub eax, 1
    call fibo
    mov ebx, eax
    
    mov eax, edx
    sub eax, 2
    call fibo
    mov ecx, eax
    
    mov eax, ebx
    add eax, ecx
    ret
    
_get_out:
    mov eax, 1
    ret

main:
    mov eax, 4
    call fibo
    ret