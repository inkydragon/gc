int fibo(int n) {
    if(n == 1) {
        return 1;
    }
    if(n == 2) {
         return 1;
    }
    int x = n - 1;
    int y = n - 2;
    int a = fibo(x);
    int b = fibo(y);
    int c = a + b;
    return c;
}

int main() {
    return fibo(4);
}