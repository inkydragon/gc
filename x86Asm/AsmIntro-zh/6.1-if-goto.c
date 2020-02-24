
int main() {
    int sum = 0;
    int i = 1;

_start:
    if (i <= 10)
    {
        sum = sum + i;
        i = i + 1;
        goto _start;
    }

    return sum;
}