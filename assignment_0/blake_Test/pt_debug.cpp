// Jh_Test.cpp : 콘솔 응용 프로그램에 대한 진입점을 정의합니다.
//

#include "stdafx.h"

#include <string.h>

typedef unsigned long long uint64;

static const char INDENT[] =  "    ";  /* how much to indent on new line */

extern FILE *gfp_out;
void Show64_step(size_t cnt,const uint64 *X,size_t step)
{
	size_t i,j;
	for (i=j=0;i < cnt;i++,j+=step)
	{
		if (i % 4 ==  0) fprintf(gfp_out, INDENT);
		fprintf(gfp_out, " %08X.%08X ",(unsigned int)(X[j] >> 32),(unsigned int)X[j]);
		if (i % 4 ==  3 || i==cnt-1) fprintf(gfp_out, "\n");
	}
}


void Show08(size_t cnt,const unsigned char *b)
{
	size_t i;
	for (i=0;i < cnt;i++)
	{
		if (i %16 ==  0) fprintf(gfp_out, INDENT);
		else if (i % 4 == 0) fprintf(gfp_out, " ");
		fprintf(gfp_out, " %02X",b[i]);
		if (i %16 == 15 || i==cnt-1) fprintf(gfp_out, "\n");
	}
}


void Show32(size_t cnt,const unsigned int *b)
{
	size_t i;
	for (i=0;i < cnt;i++)
	{
		if (i % 4 ==  0) fprintf(gfp_out, INDENT);
		fprintf(gfp_out, " %08X",b[i]);
		if (i % 4 ==  3 || i==cnt-1) fprintf(gfp_out, "\n");
	}
}