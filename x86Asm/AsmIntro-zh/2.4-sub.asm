global main

main:
    mov eax, 0
    mov ebx, 1
    mov ecx, 2
    mov edx, 3
    sub eax, ebx ; eax -=ebx = 0-2 = -2 = 255
    sub eax, ecx ; eax -=ecx = 255-2 = 253
    sub eax, edx ; eax -=edx = 253-3 = 250
    ret ; ret 250