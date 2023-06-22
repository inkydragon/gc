// 实验7_1_6 素数探求之六
// http://paste.ubuntu.com/26090014/

#include<stdio.h>

int IsPrime(int m) {
	int i;
	if (m <= 1) return 0;
	for (i = 2; i < m; i++)
		if (m % i == 0) return 0;
	return 1;
}

// 
void PrimtFact(int num)
{
	int i;

	// 关于0,1 和负数 均不作因式分解
	/*if (num <= 1) { 
		printf("%d is not a prime number\n", num);
		return 1;
	}*/
	
	// 判断第一个 素因子 并按格式输出
	for (i = 2; ; i++) {
		if (num % i == 0 && IsPrime(i))
		{
			printf("%d = %d", num, i);
			num /= i; // num = num / i;
			break;
		}
	}

	// 继续找出其他素因子
	while (num > 1)
	{
		if (num % i == 0 && IsPrime(i))
		{
			printf(" * %d", i);
			num /= i;
		}
		else i++;
	}

	printf("\n"); // 补充末尾的换行
}

int main()
{
	int x;
	//do {
		scanf("%d", &x);
		if (IsPrime(x))
			printf("%d is a prime number\n", x);
		else
			PrimtFact(x);
	//} while (1);

	return 0;
}