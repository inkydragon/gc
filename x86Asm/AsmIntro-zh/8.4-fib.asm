global main

fibo:
    cmp eax, 1
    je _get_out
    cmp eax, 2
    je _get_out

    ; SAVE ebx, ecx, edx
    push rbx
    push rcx
    push rdx
    
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

    pop rdx
    pop rcx
    pop rbx

    ret
    
_get_out:
    mov eax, 1
    ret

main:
    mov eax, 7
    call fibo
    ret ; fib(7) = 13