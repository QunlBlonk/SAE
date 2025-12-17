
all : decipher findkey
	
decipher : decipher.o librairie.a
	gcc $^ -o decipher
	
findkey : findkey.o librairie.a
	gcc $^ -o findkey
	
librairie.a : statique.o
	ar rcs librairie.a statique.o

statique.o : statique.c statique.h
	gcc -c statique.c 

decipher.o : decipher.c
	gcc -c decipher.c
	
findkey.o : findkey.c
	gcc -c findkey.c	


clean :
	rm -f *.o *.a decipher findkey
