#include <stdio.h>

int hms2s(int hh, int mm, int ss) {
    return (hh*60 + mm)*60 + ss;
}

void s2hms(int *hh, int *mm, int *ss, int s) {
    *hh = s / 3600 % 24;
    *mm = s / 60   % 60;
    *ss = s % 60;
}

int main() {
    int hh, mm, ss, s;

    scanf("%d:%d:%d", &hh, &mm, &ss);
    scanf("%d", &s);
    s2hms(&hh, &mm, &ss, hms2s(hh, mm, ss)+s);
    printf("%02d:%02d:%02d\n", hh, mm, ss);
    return 0;
}