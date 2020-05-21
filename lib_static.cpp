#include <stdio.h>
#include "lib_static.h"

int library_func(int a)
{
	printf("[libstatic.a] this is library function from static = %d\n", a);
}
