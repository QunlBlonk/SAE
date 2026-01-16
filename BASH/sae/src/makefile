all : findkey decipher

findkey : findkey.o librairie.a
	gcc $^ -o findkey

decipher : decipher.o librairie.a
	gcc $^ -o decipher

librairie.a : statique.o
	ar rcs librairie.a statique.o

statique.o : statique.c statique.h
	gcc -c statique.c 

findkey.o : findkey.c
	gcc -c findkey.c

decipher.o : decipher.c
	gcc -c decipher.c

clean :
	rm -f *.o *.a findkey decipher
