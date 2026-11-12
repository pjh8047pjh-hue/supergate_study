#include <stdio.h>
#include <stdlib.h>

int score[50] = {
43, 65, 51, 27, 79, 11, 56, 61, 82,  9,
25, 36,  7, 49, 55, 63, 74, 81, 49, 37,
40, 49, 16, 75, 87, 91, 33, 24, 58, 78,
65, 56, 76, 67, 45, 54, 36, 63, 12, 21,
73, 49, 51, 19, 39, 49, 68, 93, 85, 59
};

void main ()
{

  int i, low, high;
  int group[11] = {0};

  for (i = 0; i < 50; i++) {
    ++group[(int)(score[i]/10)];
  }

  printf("GROUP\t  RANGE\t     STUDENT#\n");

  for (i = 0; i < 11; i++) {

    low = i*10;
    if (i == 10) high = 100;
    else high = low + 9;

    printf("%2d\t%3d to %3d\t%d\n", i+1, low, high, group[i]);
  }

}