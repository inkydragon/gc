int main() {
    int sum = 0;
    int i = 1;

_start:
    if (i > 10) goto _end_of_block;

    sum = sum + i;
    i = i + 1;
    goto _start;

_end_of_block:
    return sum;
}