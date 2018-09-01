a.out:	lex.yy.c
		gcc lex.yy.c -lfl

lex.yy.c:	ass3_16CS30012.l ass3_16CS30012.c
		flex ass3_16CS30012.l ass3_16CS30012.c
        
clean:
		rm a.out lex.yy.c

test:
		./a.out <ass3_16CS30012_test.c