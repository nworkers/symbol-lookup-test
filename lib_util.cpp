#include <stdio.h>
#include "lib_shared.h"

int library_util(void)
{
	printf("[libutil.so] this is library function from libutil.so\n");
	printf("[libutil.so] I'll call library_func() in libshared.so\n");
	library_func("string from libutil.so\n");
}
