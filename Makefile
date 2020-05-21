
all: exe 

exe: main.cpp lib_static lib_shared lib_util
	gcc -o main main.cpp -lstdc++ -lstatic -lutil -L. -Wl,--allow-shlib-undefined,-rpath .

lib_static: lib_static.cpp
	gcc -c  -o lib_static.o lib_static.cpp
	ar -crs libstatic.a lib_static.o

lib_shared: lib_shared.cpp
	gcc -c -o lib_shared.o lib_shared.cpp
	gcc -fPIC -shared -o libshared.so lib_shared.o

lib_util: lib_util.cpp
	gcc -c -o lib_util.o lib_util.cpp
	gcc -fPIC -shared  -o libutil.so lib_util.o -Wl,-fvisibility=hidden,-rpath . -L. -lshared 

clean:
	rm -rf main *.o *.so *.a
