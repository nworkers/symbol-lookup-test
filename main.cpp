#include <stdio.h>
#include "lib_static.h"
#include "lib_util.h"

int main(int argc, char *argv[])
{
	printf("[main] this is main\n");
	library_func(2);
	library_util();
	return 0;
}
