# Symbol lookup test

## Symptom definition
- libstatic.a has library_func() with prototype `int library_func(int a)`
- libshared.so has library_func() with prototype `int library_func(const char *s)`
- libutil.so has dependency with library_func() in libshared.so

In runtime, libutil.so called library_func(), but library_func() in libstatic.a is called.
This is test code to make libutil.so call library_func() in libshared.so


```
$ make clean all

rm -rf main *.o *.so *.a
gcc -c  -o lib_static.o lib_static.cpp
ar -crs libstatic.a lib_static.o
gcc -c -o lib_shared.o lib_shared.cpp
gcc -fPIC -shared -o libshared.so lib_shared.o
gcc -c -o lib_util.o lib_util.cpp
gcc -fPIC -shared  -o libutil.so lib_util.o -Wl,-fvisibility=hidden,-rpath . -L. -lshared
gcc -o exe1 main.cpp -lstdc++ -lstatic -lutil -L. -pie -Wl,-rpath=.,-z,relro,--no-undefined
nm -CD exe1
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
                 U library_util()
0000000000201010 B __bss_start
                 w __cxa_finalize
                 w __gmon_start__
                 U __libc_start_main
0000000000201010 D _edata
0000000000201018 B _end
00000000000008a4 T _fini
0000000000000660 T _init
000000000000080b T library_func
                 U printf
                 U puts
gcc -o exe2 main.cpp -lstdc++ -lstatic -lutil -L. -pie -Wl,-rpath=.,-z,relro,--no-undefined,--exclude-libs,ALL
nm -CD exe2
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
                 U library_util()
0000000000201010 B __bss_start
                 w __cxa_finalize
                 w __gmon_start__
                 U __libc_start_main
0000000000201010 D _edata
0000000000201018 B _end
0000000000000874 T _fini
0000000000000630 T _init
                 U printf
                 U puts
```

### Called wrongly
```
$ ./exe1

[main] this is main
[libstatic.a] this is library function from static = 2
[libutil.so] this is library function from libutil.so
[libutil.so] I'll call library_func() in libshared.so
---> *WRONG* [libstatic.a] this is library function from static = 1702823734
```

### Called correctly
```
$ ./exe2

[main] this is main
[libstatic.a] this is library function from static = 2
[libutil.so] this is library function from libutil.so
[libutil.so] I'll call library_func() in libshared.so
---> *CORRECT* [libshared.so] this is library function from shared = string from libutil.so
```
