a.out: lex.yy.o y.tab.o ass5_16CS30012_translator.o 
	g++ ass5_16CS30012_translator.o lex.yy.o y.tab.o -lfl
	./a.out > ass5_16CS30012_ans1.out < ass5_16CS30012_test1.c 
	./a.out > ass5_16CS30012_ans2.out < ass5_16CS30012_test2.c 
	./a.out > ass5_16CS30012_ans3.out < ass5_16CS30012_test3.c 
	./a.out > ass5_16CS30012_ans4.out < ass5_16CS30012_test4.c 
	./a.out > ass5_16CS30012_ans5.out < ass5_16CS30012_test5.c 
y.tab.o: y.tab.c
	g++ -c y.tab.c
y.tab.c: ass5_16CS30012.y 
	yacc -dtv ass5_16CS30012.y
lex.yy.o: lex.yy.c y.tab.o 
	g++ -c lex.yy.c
lex.yy.c: ass5_16CS30012.l 
	flex ass5_16CS30012.l
ass5_16CS30012_translator.o: ass5_16CS30012_translator.cxx ass5_16CS30012_translator.h
	g++ -c ass5_16CS30012_translator.cxx
clean:
	rm lex.yy.c lex.yy.o a.out y.tab.o y.tab.c ass5_16CS30012_translator.o y.tab.h y.output
