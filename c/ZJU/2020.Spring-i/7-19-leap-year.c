#include <stdio.h>

int days_sum(int year[], int mm)
{
    int sum = 0;
    for (int d = 0; d < mm - 1; d++)
    {
        sum += year[d];
    }
    return sum;
}

int main()
{
    int year[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int leap[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int yyyy, mm, days;

    scanf("%d/%d/%d", &yyyy, &mm, &days);
    if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0)
    {
        days += days_sum(leap, mm);
    }
    else
    {
        days += days_sum(year, mm);
    }
    printf("%d\n", days);
    return 0;
}
