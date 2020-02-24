int fibo(int eax) {

    int ebx, ecx;
    if(eax == 1) {
        return eax;
    }
    if(eax == 2) {
        eax = 1;
        return eax;
    }
    
    int edx = eax;
    
    eax = edx - 1;
    eax = fibo(eax);
    ebx = eax;
    
    eax = edx - 2;
    eax = fibo(eax);
    ecx = eax;
    
    eax = ebx + ecx;
    return eax;
}

int main() {
    return fibo(4);
}