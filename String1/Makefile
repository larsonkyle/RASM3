all: driver

driver: driver.o String1.o 
	ld -o driver driver.o String1.o ../../../objfiles/putch.o ../../../objfiles/int64asc.o ../../../objfiles/putstring.o ../../../objfiles/ascint64.o ../../../objfiles/getstring.o /usr/lib/aarch64-linux-gnu/libc.so -dynamic-linker /lib/ld-linux-aarch64.so.1

driver.o: driver.s
	as -g -o driver.o driver.s

String1.o: String1.s
	as -g -o String1.o String1.s

clean: 
	rm *.o driver 
