all: parser

parser: lex.yy.o parser.tab.o
	gcc -o parser lex.yy.o parser.tab.o -lfl

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

clean:
	rm -f parser lex.yy.o parser.tab.o lex.yy.c parser.tab.c parser.tab.h