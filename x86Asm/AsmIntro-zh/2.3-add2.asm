global main

main:
    mov eax, 1
    mov ebx, 2
    mov ecx, 3
    mov edx, 4
    add eax, ebx ; eax +=ebx = 1+2 = 3
    add eax, ecx ; eax +=ecx = 3+3 = 6
    add eax, edx ; eax +=edx = 6+4 = 10
    ret ; ret 10