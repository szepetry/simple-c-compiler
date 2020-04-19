#include <stdio.h>
#include <stdlib.h>
void printer(int c)
{
	printf("Printer executed %c \n", c);
}
int main()
{
	signed int c, d, e, f, i, j;
	float able = 7.9;
	int array[20][20];
	scanf("%d", &c);
	if (c < 15)
	{
		c = c + 1;
		d = c * 5;
		e = d / 4;
		f = d % 3;
	}
	else
	{
		c = c + 3;
		d = c * 3;
		e = d / 5;
		f = d % 2;
	}
	for (i = 0; i < 2; i++)
	{
		printf("Hello");
		printer(i);
	}
	int y = 0;
	while (y < 2)
	{
		if (c > 15)

		{
			y++;
			continue;
		}
	}
	printf("Enter 2D array\n");
	for (i = 0; i < 2; i++)
	{
		for (j = 0; j < 2; j++)
		{
			printf("Compound statement");
		}
	}
}
