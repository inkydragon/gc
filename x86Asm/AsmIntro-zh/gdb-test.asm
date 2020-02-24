global main

main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret

; gdb cmd:
; set disassembly-flavor intel
