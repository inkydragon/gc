#include <stdio.h>

int main() {
    int acc, b;
    char op;

    scanf("%d", &acc);
    while ( scanf("%c", &op) && op!='=' && scanf("%d", &b) ) {
        switch (op) {
            case '+': acc += b; break;
            case '-': acc -= b; break;
            case '*': acc *= b; break;
            case '/': if(b!=0) {
                acc /= b;
                break;
            }
            default: printf("ERROR\n"); exit(0);
        }
    }
    if (op=='=') {
        printf("%d\n", acc);
    } else {
        printf("ERROR\n");
    }
    return 0;
}
