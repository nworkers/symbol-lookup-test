#include <stdio.h>
#include "lib_shared.h"

int library_func(const char *s)
{
	printf("[libshared.so] this is library function from shared = %s\n", s);
}

