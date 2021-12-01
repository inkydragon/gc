#include <stdio.h>

int main() {
    int rnd, N, guess, count=1;
    scanf("%d %d", &rnd, &N);
    while (scanf("%d",&guess)!=0 && count<=N && guess>0) {
        if (guess < rnd) {
            printf("Too small\n");
        } else if (guess > rnd) {
            printf("Too big\n");
        } else { // guess == rnd
            count == 1 ? printf("Bingo!\n") :
            count <= 3 ? printf("Lucky You!\n") :
                         printf("Good Guess!\n");
            return 0;
        }
        count++;
    }
    printf("Game Over\n");
    return 0;
}
