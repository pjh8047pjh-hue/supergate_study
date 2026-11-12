#include <stdio.h>
#include <stdlib.h>

void main ()
{

  int n = 0, i, sum = 0;

  printf("Enter any no: ");
  fflush(stdout);

  scanf("%d", &n);


  for (i = 1; i < n; i = i + 2)
  {

    // write code  here
    printf("%d+", i);
    sum = sum + i;

  }

  printf("%d\n", n);
  printf("sum = %d", sum+n);
  getchar();
}