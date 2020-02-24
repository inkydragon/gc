int x, y, z;

int main() {
    x = 2;
    y = 3;
    z = x + y;
    return z;
}

// C-lang
// Dump of assembler code for function main:
//    0x00000000004004d6 <+0>:     push   rbp
//    0x00000000004004d7 <+1>:     mov    rbp,rsp
//    0x00000000004004da <+4>:     mov    DWORD PTR [rip+0x200b54],0x2   
//      # 0x601038 <x>
//    0x00000000004004e4 <+14>:    mov    DWORD PTR [rip+0x200b4e],0x3   
//      # 0x60103c <y>
//    0x00000000004004ee <+24>:    mov    edx,DWORD PTR [rip+0x200b44]   
//      # 0x601038 <x>
//    0x00000000004004f4 <+30>:    mov    eax,DWORD PTR [rip+0x200b42]   
//      # 0x60103c <y>
//    0x00000000004004fa <+36>:    add    eax,edx
//    0x00000000004004fc <+38>:    mov    DWORD PTR [rip+0x200b32],eax   
//      # 0x601034 <z>
//    0x0000000000400502 <+44>:    mov    eax,DWORD PTR [rip+0x200b2c]   
//      # 0x601034 <z>
//    0x0000000000400508 <+50>:    pop    rbp
//    0x0000000000400509 <+51>:    ret
// End of assembler dump.

// ASM
// Dump of assembler code for function main:
//    0x00000000004004e0 <+0>:     mov    eax,0x2
//    0x00000000004004e5 <+5>:     mov    DWORD PTR ds:0x601030,eax      
//    0x00000000004004ec <+12>:    mov    eax,0x3
//    0x00000000004004f1 <+17>:    mov    DWORD PTR ds:0x601032,eax      
//    0x00000000004004f8 <+24>:    mov    eax,DWORD PTR ds:0x601030      
//    0x00000000004004ff <+31>:    mov    ebx,DWORD PTR ds:0x601032      
//    0x0000000000400506 <+38>:    add    eax,ebx
//    0x0000000000400508 <+40>:    mov    DWORD PTR ds:0x601034,eax      
//    0x000000000040050f <+47>:    mov    eax,DWORD PTR ds:0x601034      
//    0x0000000000400516 <+54>:    ret   
// End of assembler dump.