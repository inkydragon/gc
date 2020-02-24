int main() {
    register int grade = 80;
    register int level;
    if ( grade >= 85 ){
        level = 1;
    } else if ( grade >= 70 ) {
        level = 2;
    } else if ( grade >= 60 ) {
        level = 3;
    } else {
        level = 4;
    }
    return level;
}

// (gdb) set disassembly-flavor intel
// (gdb) disas main
// Dump of assembler code for function main:
//    0x00000000004004d6 <+0>:     push   rbp
//    0x00000000004004d7 <+1>:     mov    rbp,rsp
//    0x00000000004004da <+4>:     push   rbx
//    0x00000000004004db <+5>:     mov    ebx,0x50
//    0x00000000004004e0 <+10>:    cmp    ebx,0x54
//    0x00000000004004e3 <+13>:    jle    0x4004ec <main+22>
//    0x00000000004004e5 <+15>:    mov    ebx,0x1
//    0x00000000004004ea <+20>:    jmp    0x400509 <main+51>
//    0x00000000004004ec <+22>:    cmp    ebx,0x45
//    0x00000000004004ef <+25>:    jle    0x4004f8 <main+34>
//    0x00000000004004f1 <+27>:    mov    ebx,0x2
//    0x00000000004004f6 <+32>:    jmp    0x400509 <main+51>
//    0x00000000004004f8 <+34>:    cmp    ebx,0x3b
//    0x00000000004004fb <+37>:    jle    0x400504 <main+46>
//    0x00000000004004fd <+39>:    mov    ebx,0x3
//    0x0000000000400502 <+44>:    jmp    0x400509 <main+51>
//    0x0000000000400504 <+46>:    mov    ebx,0x4
//    0x0000000000400509 <+51>:    mov    eax,ebx
//    0x000000000040050b <+53>:    pop    rbx
//    0x000000000040050c <+54>:    pop    rbp
//    0x000000000040050d <+55>:    ret
// End of assembler dump.