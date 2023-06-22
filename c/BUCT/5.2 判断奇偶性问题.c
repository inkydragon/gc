/*
试题描述
	由键盘上任意输入一个正整数n。
	请编程判断它是奇数还是偶数，
		若为奇数则输出“odd”，
		若为偶数则输出“even”。

输入	输入一个正整数n。
输出	输出“odd”或“even”（均不输出引号）。

输入示例1	12
输出示例1	even

输入示例2	7
输出示例2	odd

数据范围	输入为int范围的整数
*/

#include<stdio.h>
#include<math.h>

int main()
{
	int a, b, c;
	float p;

	scanf("%d %d %d", &a, &b, &c);

	if ((a + b)>c && (a + c)>b && (b + c)>a) {
		p = (a + b + c) / 2;
		printf("%.2f", sqrt(p*(p - a)*(p - b)*(p - c)));
	} else {
		printf("FALSE");
	}

	return 0;
}