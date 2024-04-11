all: driver

driver: test1.o test2.o String1.o String2.o
	ld -o driver String1/test1.o String2/test2.o String1/String1.o String2/String2.o -lc ../../objfiles/putch.o ../../objfiles/int64asc.o ../../objfiles/putstring.o ../../objfiles/ascint64.o ../../objfiles/getstring.o 

test1.o: String1/test1.s
	as -g -o String1/test1.o String1/test1.s

test2.o: String2/test2.s
	as -g -o String2/test2.o String2/test2.s

String1.o: String1/String1.s
	as -g -o String1/String1.o String1/String1.s

String2.o: String2/String2.s
	as -g -o String2/String2.o String2/String2.s

clean: 
	rm String1/*.o String2/*.o driver
