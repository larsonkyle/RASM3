all: driver

driver: driver.o String1.o 
	ld -o driver driver.o String1.o ../objfiles/putch.o ../objfiles/int64asc.o ../objfiles/putstring.o ../objfiles/ascint64.o ../objfiles/getstring.o

driver.o: driver.s
	as -g -o driver.o driver.s

String1.o: String1.s
	as -g -o String1.o String1.s

clean: 
	rm *.o driver 
