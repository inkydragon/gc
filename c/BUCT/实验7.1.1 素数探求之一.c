// 实验7_1_1 素数探求之一
// Online
// http://paste.ubuntu.com/26089536/
#include<stdio.h>

int IsPrime(int m) {
	int i;
	if (m <= 1) return 0;
	for (i = 2; i < m; i++)
		if (m % i == 0) return 0;
	return 1;
}
int main()
{
	int x;
	//do {
		scanf("%d", &x);
		if (IsPrime(x))
			printf("%d is a prime number\n", x);
		else
			printf("%d is not a prime number\n", x);
	//} while (1);

	return 0;
}